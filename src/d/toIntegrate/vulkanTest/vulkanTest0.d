import api.vulkan.vulkan;

import vulkan.VulkanPlatform;

import std.stdio;

import vulkan.VulkanHelpers;
import vulkan.VulkanDevice;

// helper which creates code to copy an GC'ed array to a non-GC'ed array, memory gets released with scope
template copyGcedArrayToNongcedMemory(string sourceGcedArray, string destinationNonGcedVariablename) {
	const char[] copyGcedArrayToNongcedMemory = 
	"import core.memory : GC;\n" ~
	"import core.stdc.string : memcpy;\n" ~
	
    destinationNonGcedVariablename ~" = cast(typeof(" ~ destinationNonGcedVariablename ~ "))GC.malloc(" ~ sourceGcedArray ~ ".sizeof, GC.BlkAttr.NO_MOVE | GC.BlkAttr.NO_SCAN);\n" ~
	"scope(exit) GC.free(" ~ destinationNonGcedVariablename ~ ");\n" ~
	"memcpy(" ~ destinationNonGcedVariablename ~ ", " ~ sourceGcedArray ~ ".ptr, " ~ sourceGcedArray ~ ".sizeof);\n";
}







import std.string : toStringz;
import core.memory : GC;
import Exceptions : EngineException;

void main(string[] args) {
	initializeVulkanPointers();

	VkInstance instance;

	immutable(char)*[1] layerArray;
	layerArray[0] = toStringz("VK_LAYER_LUNARG_standard_validation");

	VkInstanceCreateInfo instanceCreateInfo;
	initInstanceCreateInfo(&instanceCreateInfo);

	// we enable the standard debug and validation layers
	instanceCreateInfo.enabledLayerCount = 1;
	instanceCreateInfo.ppEnabledLayerNames = layerArray.ptr;

	VkResult vulkanResult = vkCreateInstance(&instanceCreateInfo, null, &instance);
	if( !vulkanSuccess(vulkanResult) ) {
		throw new EngineException(true, true, "vkCreateInstance failed!");
	}

	// enumerate devices
	uint32_t physicalDevicesCount;
	vulkanResult = vkEnumeratePhysicalDevices(instance, &physicalDevicesCount, null);
	if( !vulkanSuccess(vulkanResult) ) {
		throw new EngineException(true, true, "vkEnumeratePhysicalDevices failed!");
	}
	
	if( physicalDevicesCount == 0 ) {
		throw new EngineException(true, true, "vkEnumeratePhysicalDevices returned a device count of zero!");
	}


	// TODO< check if we do this like this in the OpenGL implementation and rewrite this code here if we allocate memory not over the GC
	VkPhysicalDevice[] physicalDevices = new VkPhysicalDevice[physicalDevicesCount];
	vulkanResult = vkEnumeratePhysicalDevices(instance, &physicalDevicesCount, physicalDevices.ptr);
	if( !vulkanSuccess(vulkanResult) ) {
		throw new EngineException(true, true, "vkEnumeratePhysicalDevices failed!");
	}

	VulkanDevice[] vulkanDevices = new VulkanDevice[physicalDevicesCount];
	for( uint deviceI = 0; deviceI < physicalDevicesCount; deviceI++ ) {
		vulkanDevices[deviceI] = new VulkanDevice();
	}

	// copy
	for( uint deviceI = 0; deviceI < physicalDevicesCount; deviceI++ ) {
		vulkanDevices[deviceI].physicalDevice = physicalDevices[deviceI];
	}

	// invalidate/ free
	physicalDevices = null;
	physicalDevicesCount = 0;


	// enumerate all properties and queue information of the physical devices for the selection of the best device
	foreach( VulkanDevice deviceIterator; vulkanDevices ) {
		vkGetPhysicalDeviceProperties(deviceIterator.physicalDevice, &(deviceIterator.physicalDeviceProperties));

		uint32_t queueFamilyPropertiesCount;
		vkGetPhysicalDeviceQueueFamilyProperties(deviceIterator.physicalDevice, &queueFamilyPropertiesCount, null);

		deviceIterator.queueFamilyProperties = new VkQueueFamilyProperties[queueFamilyPropertiesCount];
		vkGetPhysicalDeviceQueueFamilyProperties(deviceIterator.physicalDevice, &queueFamilyPropertiesCount, deviceIterator.queueFamilyProperties.ptr);
	}

	writeln("I have ", vulkanDevices.length, " vulkan devices");
	
	// now we filter for the devices with at least n queue of the given type
	VulkanDevice[] possibleDevices;

	/* TODO
	final uint minimumNumberOfComputeQueues = 2;

	foreach( VulkanDevice currentDevice; vulkanDevices ) {
		// TODO< check for required properties of the queues >
		deviceIterator.queueFamilyProperties
	}
	*/

	// HACK
	// for now we just add all devices to possibleDevices
	foreach( VulkanDevice currentDevice; vulkanDevices ) {
		possibleDevices ~= currentDevice;
	}

	if( possibleDevices.length == 0 ) {
		throw new EngineException(true, true, "Could not find a vulkan device with the required properties!");
	}

	// now we select the best device
	// HACK
	// < we select the first device >
	VulkanDevice chosenDevice = possibleDevices[0];


	// query memory
	chosenDevice.physicalDeviceMemoryProperties = cast(VkPhysicalDeviceMemoryProperties*)GC.malloc(VkPhysicalDeviceMemoryProperties.sizeof, GC.BlkAttr.NO_MOVE | GC.BlkAttr.NO_SCAN);
	vkGetPhysicalDeviceMemoryProperties(chosenDevice.physicalDevice, chosenDevice.physicalDeviceMemoryProperties);

	// create device
	{
		VkPhysicalDeviceFeatures physicalDeviceFeatures;
		initPhysicalDeviceFeatures(&physicalDeviceFeatures);

		// TODO< check if we do this like this in the OpenGL implementation and rewrite this code here if we allocate memory not over the GC
		float[] queuePriorities = new float[2];
		queuePriorities[0] = 1.0f;
		queuePriorities[1] = 0.3f;

		// TODO< check if we do this like this in the OpenGL implementation and rewrite this code here if we allocate memory not over the GC
		// for now we just request two queues
		// one high priority queue and one low priority queue
		VkDeviceQueueCreateInfo[] queueCreateInfoArray = new VkDeviceQueueCreateInfo[1];
		initDeviceQueueCreateInfo(&(queueCreateInfoArray[0]));
		queueCreateInfoArray[0].queueFamilyIndex = 0; // HACK< TODO< lookup index > >
		queueCreateInfoArray[0].queueCount = 2;
		queueCreateInfoArray[0].pQueuePriorities = cast(immutable(float)*)queuePriorities.ptr;

		VkDeviceCreateInfo deviceCreateInfo;
		initDeviceCreateInfo(&deviceCreateInfo);
		deviceCreateInfo.queueCreateInfoCount = queueCreateInfoArray.length;
		deviceCreateInfo.pQueueCreateInfos = cast(immutable(VkDeviceQueueCreateInfo)*)queueCreateInfoArray.ptr;

		// we enable the standard debug and validation layers
		deviceCreateInfo.enabledLayerCount = 1;
		deviceCreateInfo.ppEnabledLayerNames = layerArray.ptr;

		deviceCreateInfo.pEnabledFeatures = cast(immutable(VkPhysicalDeviceFeatures)*)&physicalDeviceFeatures;

		vulkanResult = vkCreateDevice(chosenDevice.physicalDevice, &deviceCreateInfo, null, &chosenDevice.logicalDevice);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create vulkan device!");
		}
	}


	// retrive queues

	VkQueue highPriorityQueue, lowPriorityQueue;
	{
		uint32_t queueFamilyIndex = 0; // HACK< TODO< lookup index > >

		vkGetDeviceQueue(chosenDevice.logicalDevice, queueFamilyIndex, 0, &highPriorityQueue);
		vkGetDeviceQueue(chosenDevice.logicalDevice, queueFamilyIndex, 1, &lowPriorityQueue);
	}

	// create command pool
	VkCommandPool commandPool;
	{
		uint32_t queueFamilyIndex = 0; // HACK< TODO< lookup index > >

		VkCommandPoolCreateInfo commandPoolCreateInfo;
		initCommandPoolCreateInfo(&commandPoolCreateInfo);
		commandPoolCreateInfo.flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
		commandPoolCreateInfo.queueFamilyIndex = queueFamilyIndex;

		vulkanResult = vkCreateCommandPool(
			chosenDevice.logicalDevice,
			&commandPoolCreateInfo,
			null,
			&commandPool
		);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create command pool!");
		}
	}

	// create command buffer
	// we later can create n command buffers and fill them in different threads

	VkCommandBuffer primaryCommandBuffer;
	{
		VkCommandBufferAllocateInfo commandBufferAllocationInfo;
		initCommandBufferAllocateInfo(&commandBufferAllocationInfo);
		commandBufferAllocationInfo.commandPool = commandPool;
		commandBufferAllocationInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
		commandBufferAllocationInfo.commandBufferCount = 1; // we just want to allocate one command buffer in the target array

		// SYNC : this needs to be host synced with a mutex
		vulkanResult = vkAllocateCommandBuffers(
			chosenDevice.logicalDevice,
			&commandBufferAllocationInfo,
			&primaryCommandBuffer);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't allocate command buffer!");
		}
	}

	VkFormat depthFormatMediumPrecision;
	VkFormat depthFormatHighPrecision;

	// find best formats
	{
		bool calleeSuccess;
		VkFormat[] preferedMediumPrecisionFormats = [VK_FORMAT_D24_UNORM_S8_UINT, VK_FORMAT_D16_UNORM_S8_UINT, VK_FORMAT_D16_UNORM];
		depthFormatMediumPrecision = vulkanHelperFindBestFormatTry(chosenDevice.physicalDevice, preferedMediumPrecisionFormats, VK_FORMAT_FEATURE_DEPTH_STENCIL_ATTACHMENT_BIT, calleeSuccess);
		if( !calleeSuccess ) {
			throw new EngineException(true, true, "Couldn't find a format for '" ~ "depthFormatMediumPrecision" ~ "'!");
		}

		VkFormat[] preferedHighPrecisionFormats = [VK_FORMAT_D32_SFLOAT_S8_UINT, VK_FORMAT_D32_SFLOAT];
		depthFormatHighPrecision = vulkanHelperFindBestFormatTry(chosenDevice.physicalDevice, preferedHighPrecisionFormats, VK_FORMAT_FEATURE_DEPTH_STENCIL_ATTACHMENT_BIT, calleeSuccess);
		if( !calleeSuccess ) {
			throw new EngineException(true, true, "Couldn't find a format for '" ~ "depthFormatHighPrecision" ~ "'!");
		}
	}
	//CUT CUT CUT CUT CUT CUT CUT CUT CUT CUT CUT CUT CUT CUT CUT CUT CUT CUT CUT CUT CUT
	
	
	// FROM EXAMPLE do overthing VulkanExampleBase does 
	VkCommandBuffer postPresentCmdBuffer;
	
	VkRenderPass renderPass;
	                       // TODO LOW< rename >
	VkCommandPool cmdPool; // alocated/used for swapchain
	
	
	TypedPointerWithSize!VkCommandBuffer drawCmdBuffers;
	
	
	{
		// from https://github.com/SaschaWillems/Vulkan/blob/master/base/vulkanexamplebase.cpp
		// under MIT license
		void createCommandPool() {
			VkCommandPoolCreateInfo cmdPoolInfo;
			initCommandPoolCreateInfo(&cmdPoolInfo);
			cmdPoolInfo.queueFamilyIndex = swapChain.queueNodeIndex;
			cmdPoolInfo.flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
			vulkanResult = vkCreateCommandPool(chosenDevice.physicalDevice, &cmdPoolInfo, null, &cmdPool);
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Couldn't create command pool!");
			}
		}
		
		// from https://github.com/SaschaWillems/Vulkan/blob/master/base/vulkanexamplebase.cpp
		// under MIT license
		void setupSwapChain() {
			// TODO
		}
		
		// from https://github.com/SaschaWillems/Vulkan/blob/master/base/vulkanexamplebase.cpp
		// under MIT license
		void createCommandBuffers()
		{
			// Create one command buffer per frame buffer 
			// in the swap chain
			// Command buffers store a reference to the 
			// frame buffer inside their render pass info
			// so for static usage withouth having to rebuild 
			// them each frame, we use one per frame buffer
			drawCmdBuffers = TypedPointerWithSize!VkCommandBuffer.allocate(swapChain.imageCount);
			
			VkCommandBufferAllocateInfo cmdBufAllocateInfo;
			cmdBufAllocateInfo.commandPool = commandPool;
			cmdBufAllocateInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
			cmdBufAllocateInfo.commandBufferCount = cast(uint32_t)drawCmdBuffers.length;
			
			vulkanResult = vkAllocateCommandBuffers(chosenDevice.physicalDevice, &cmdBufAllocateInfo, drawCmdBuffers.ptr);
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Couldn't allocate command buffer!");
			}
		
			// Create one command buffer for submitting the
			// post present image memory barrier
			cmdBufAllocateInfo.commandBufferCount = 1;
		
			vulkanResult = vkAllocateCommandBuffers(chosenDevice.physicalDevice, &cmdBufAllocateInfo, &postPresentCmdBuffer);
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Couldn't allocate command buffer!");
			}
		}
		
		// create renderpass
		void createRenderpass() {
			// from https://github.com/SaschaWillems/Vulkan/blob/master/base/vulkanexamplebase.cpp
			// under MIT license
			// void VulkanExampleBase::setupRenderPass()
			// TODO< understand and replace >
	
			VkFormat colorformat = VK_FORMAT_B8G8R8A8_UNORM;
	
			VkAttachmentDescription[2] attachments;
			attachments[0].format = colorformat;
			attachments[0].samples = VK_SAMPLE_COUNT_1_BIT;
			attachments[0].loadOp = VK_ATTACHMENT_LOAD_OP_CLEAR;
			attachments[0].storeOp = VK_ATTACHMENT_STORE_OP_STORE;
			attachments[0].stencilLoadOp = VK_ATTACHMENT_LOAD_OP_DONT_CARE;
			attachments[0].stencilStoreOp = VK_ATTACHMENT_STORE_OP_DONT_CARE;
			attachments[0].initialLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
			attachments[0].finalLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
	
			attachments[1].format = depthFormatMediumPrecision;
			attachments[1].samples = VK_SAMPLE_COUNT_1_BIT;
			attachments[1].loadOp = VK_ATTACHMENT_LOAD_OP_CLEAR;
			attachments[1].storeOp = VK_ATTACHMENT_STORE_OP_STORE;
			attachments[1].stencilLoadOp = VK_ATTACHMENT_LOAD_OP_DONT_CARE;
			attachments[1].stencilStoreOp = VK_ATTACHMENT_STORE_OP_DONT_CARE;
			attachments[1].initialLayout = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;
			attachments[1].finalLayout = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;
	
			VkAttachmentReference colorReference;
			colorReference.attachment = 0;
			colorReference.layout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
	
			VkAttachmentReference depthReference;
			depthReference.attachment = 1;
			depthReference.layout = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;
	
			VkSubpassDescription subpass;
			subpass.pipelineBindPoint = VK_PIPELINE_BIND_POINT_GRAPHICS; // only this is possible in vulkan 1.0.2
			subpass.flags = 0;
			subpass.inputAttachmentCount = 0;
			subpass.pInputAttachments = null;
			subpass.colorAttachmentCount = 1;
			subpass.pColorAttachments = cast(immutable(VkAttachmentReference)*)&colorReference;
			subpass.pResolveAttachments = null;
			subpass.pDepthStencilAttachment = cast(immutable(VkAttachmentReference)*)&depthReference;
			subpass.preserveAttachmentCount = 0;
			subpass.pPreserveAttachments = null;
	
			VkRenderPassCreateInfo renderPassCreateInfo;
			initRenderPassCreateInfo(&renderPassCreateInfo);
			renderPassCreateInfo.attachmentCount = 2;
			renderPassCreateInfo.pAttachments = cast(immutable(VkAttachmentDescription)*)&attachments;
			renderPassCreateInfo.subpassCount = 1;
			renderPassCreateInfo.pSubpasses = cast(immutable(VkSubpassDescription)*)&subpass;
			renderPassCreateInfo.dependencyCount = 0;
			renderPassCreateInfo.pDependencies = cast(immutable(VkSubpassDependency)*)null;
	
			vulkanResult = vkCreateRenderPass(chosenDevice.logicalDevice, &renderPassCreateInfo, null, &renderPass);
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Couldn't create renderpass!");
			}
		}
		
		
		
		createCommandPool(); // DONE
		createSetupCommandBuffer();
		setupSwapChain();
		createCommandBuffers(); // DONE
		setupDepthStencil();
		createRenderpass(); // DONE
		createPipelineCache();
		setupFrameBuffer();
		flushSetupCommandBuffer();
		// Recreate setup command buffer for derived class
		createSetupCommandBuffer();
		
		
		
	}
	
	
	


	class BufferDescriptor {
		VkBuffer buffer;
		VkDeviceMemory deviceMemory;
	}

	// create and fill buffers for vertex data
	// TODO< abstract this somehow deep into the engine >
	// see https://github.com/SaschaWillems/Vulkan/blob/master/triangle/triangle.cpp
	//     license: MIT
	void vulkanHelperCreateMemoryAndBufferBindAndFill(BufferDescriptor buffer, VkBufferUsageFlags usageFlags, void* dataPtr, size_t dataSize) {
		import core.stdc.string : memcpy;

		VkResult vulkanResult;
		bool calleeSuccess;

		VkBufferCreateInfo bufferCreateInfo;
		initBufferCreateInfo(&bufferCreateInfo);
		bufferCreateInfo.size = dataSize; // in bytes
		bufferCreateInfo.usage = usageFlags;
		bufferCreateInfo.flags = 0;

		vulkanResult = vkCreateBuffer(chosenDevice.logicalDevice, &bufferCreateInfo, null, &buffer.buffer);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create buffer!");
		}

		VkMemoryRequirements memoryRequirements;
		vkGetBufferMemoryRequirements(chosenDevice.logicalDevice, buffer.buffer, &memoryRequirements);

		VkMemoryAllocateInfo memoryAllocateInfo;
		initMemoryAllocateInfo(&memoryAllocateInfo);
		memoryAllocateInfo.memoryTypeIndex = 0;
		memoryAllocateInfo.allocationSize = memoryRequirements.size;
		memoryAllocateInfo.memoryTypeIndex = vulkanHelperSearchBestIndexOfMemoryType(chosenDevice.physicalDeviceMemoryProperties, memoryRequirements.memoryTypeBits, VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT, calleeSuccess);
		if( !calleeSuccess ) {
			throw new EngineException(true, true, "vulkanHelperSearchBestIndexOfMemoryType() failed!");
		}

		vulkanResult = vkAllocateMemory(
			chosenDevice.logicalDevice,
			&memoryAllocateInfo,
			null,
			&buffer.deviceMemory
		);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(false, false, "Couldn't allocate device memory!");
		}

		void* hostMemoryPtr;

		VkDeviceSize mappingOffset = 0;
		VkDeviceSize mappingSize = memoryAllocateInfo.allocationSize;
		VkMemoryMapFlags mappingFlags = 0;
		vulkanResult = vkMapMemory(chosenDevice.logicalDevice, buffer.deviceMemory, mappingOffset, mappingSize, mappingFlags, &hostMemoryPtr);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, false, "Couldn't map memory!");
		}

		memcpy(hostMemoryPtr, dataPtr, dataSize);
		vkUnmapMemory(chosenDevice.logicalDevice, buffer.deviceMemory);
		
		// SYNC : needs host sync
		vulkanResult = vkBindBufferMemory(chosenDevice.logicalDevice, buffer.buffer, buffer.deviceMemory, 0);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, false, "Couldn't bind memory!");
		}
	}

	BufferDescriptor bufferDescriptorVertexBuffer = new BufferDescriptor();
	float[3*(3+3)] testVerticesWithColor;

	vulkanHelperCreateMemoryAndBufferBindAndFill(bufferDescriptorVertexBuffer, VK_BUFFER_USAGE_VERTEX_BUFFER_BIT, &testVerticesWithColor, testVerticesWithColor.sizeof);

	BufferDescriptor bufferDescriptorIndexBuffer = new BufferDescriptor();
	uint32_t testIndices;

	vulkanHelperCreateMemoryAndBufferBindAndFill(bufferDescriptorIndexBuffer, VK_BUFFER_USAGE_INDEX_BUFFER_BIT, &testIndices, testIndices.sizeof);





	// setup descriptors
	// =================

	// helper struct
	struct BindingDescriptors {
		//VkBuffer buf;
		//VkDeviceMemory mem;
		VkPipelineVertexInputStateCreateInfo vi; // TODO< rename >
		VkVertexInputBindingDescription[] bindingDescriptionsGced;
		VkVertexInputAttributeDescription[] attributeDescriptionsGced;
	}
	
	const uint VERTEX_BUFFER_BIND_ID = 0;
	
	// TODO< rename >
	BindingDescriptors vertices;

	
	// Binding description
	vertices.bindingDescriptionsGced.length = 1;
	vertices.bindingDescriptionsGced[0].binding = VERTEX_BUFFER_BIND_ID;
	vertices.bindingDescriptionsGced[0].stride = (3+3) * float.sizeof;
	vertices.bindingDescriptionsGced[0].inputRate = VK_VERTEX_INPUT_RATE_VERTEX;

	// Attribute descriptions
	// Describes memory layout and shader attribute locations
	vertices.attributeDescriptionsGced.length = 2;
	// Location 0 : Position
	vertices.attributeDescriptionsGced[0].binding = VERTEX_BUFFER_BIND_ID;
	vertices.attributeDescriptionsGced[0].location = 0;
	vertices.attributeDescriptionsGced[0].format = VK_FORMAT_R32G32B32_SFLOAT;
	vertices.attributeDescriptionsGced[0].offset = 0;
	vertices.attributeDescriptionsGced[0].binding = 0;
	// Location 1 : Color
	vertices.attributeDescriptionsGced[1].binding = VERTEX_BUFFER_BIND_ID;
	vertices.attributeDescriptionsGced[1].location = 1;
	vertices.attributeDescriptionsGced[1].format = VK_FORMAT_R32G32B32_SFLOAT;
	vertices.attributeDescriptionsGced[1].offset = float.sizeof * 3;
	vertices.attributeDescriptionsGced[1].binding = 0;

	// Assign to vertex buffer
	initPipelineVertexInputStateCreateInfo(&vertices.vi);

	
	
	VkVertexInputBindingDescription* bindingDescriptionsNonGced;
	mixin(copyGcedArrayToNongcedMemory!("vertices.bindingDescriptionsGced", "bindingDescriptionsNonGced"));
	
	VkVertexInputAttributeDescription* attributeDescriptionsNonGced;
	mixin(copyGcedArrayToNongcedMemory!("vertices.attributeDescriptionsGced", "attributeDescriptionsNonGced"));
	
	vertices.vi.vertexBindingDescriptionCount = vertices.bindingDescriptionsGced.length;
	vertices.vi.pVertexBindingDescriptions = cast(immutable(VkVertexInputBindingDescription)*)bindingDescriptionsNonGced;
	vertices.vi.vertexAttributeDescriptionCount = vertices.attributeDescriptionsGced.length;
	vertices.vi.pVertexAttributeDescriptions = cast(immutable(VkVertexInputAttributeDescription)*)attributeDescriptionsNonGced;
	
	
	
	
	// TODO< refactor buffer managment into helper functions which manage it >
	// prepare uniform buffers
	// =======================
	
	// see https://github.com/SaschaWillems/Vulkan/blob/master/triangle/triangle.cpp
	//     license: MIT
	
	struct UniformDataVS{
		VkBuffer buffer;
		VkDeviceMemory memory;
		VkDescriptorBufferInfo descriptor;
	}

	UniformDataVS uniformDataVS;
	
	struct UboVS{
		// TODO< rewrite as our matrices if we see that the program works
		float[16] projectionMatrix;
		float[16] modelMatrix;
		float[16] viewMatrix;
	}
	UboVS uboVS;
	
	void updateUniformBuffers() {
		// Update matrices
		
		// ME< for now we just use precalculated values >
		
		uboVS.projectionMatrix = [1.29904, 0,0,0
,0,1.73205,0,0
,0,0,-1.00078,-1
,0,0,-0.200078,0];
		
		
		//uboVS.projectionMatrix = glm.perspective(deg_to_rad(60.0f), cast(float)width / cast(float)height, 0.1f, 256.0f);
		uboVS.viewMatrix = [1,0,0,0,0,1,0,0,0,0,1,0,0,0,-2.5,1];

		//uboVS.viewMatrix = glm.translate(glm.mat4(), glm.vec3(0.0f, 0.0f, zoom));

		uboVS. modelMatrix = [1,0,0,0
		,0,1,0,0
,0,0,1,0
,0,0,0,1];


		/*
		uboVS.modelMatrix = glm.mat4();
		uboVS.modelMatrix = glm.rotate(uboVS.modelMatrix, deg_to_rad(rotation.x), glm.vec3(1.0f, 0.0f, 0.0f));
		uboVS.modelMatrix = glm.rotate(uboVS.modelMatrix, deg_to_rad(rotation.y), glm.vec3(0.0f, 1.0f, 0.0f));
		uboVS.modelMatrix = glm.rotate(uboVS.modelMatrix, deg_to_rad(rotation.z), glm.vec3(0.0f, 0.0f, 1.0f));
		*/
		
		
		// Map uniform buffer and update it
		uint8_t* pData;
		vulkanResult = vkMapMemory(chosenDevice.logicalDevice, uniformDataVS.memory, 0, uboVS.sizeof, 0, cast(void **)&pData);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, false, "Couldn't map memory!");
		}
		memcpy(pData, &uboVS, uboVS.sizeof);
		vkUnmapMemory(chosenDevice.logicalDevice, uniformDataVS.memory);
		
	}
	
	{
		bool calleeSuccess;
		
		// Prepare and initialize uniform buffer containing shader uniforms
		VkMemoryRequirements memoryRequirements;

		
		VkMemoryAllocateInfo allocInfo; // TODO< rename >
		initMemoryAllocateInfo(&allocInfo);
		allocInfo.allocationSize = 0;
		allocInfo.memoryTypeIndex = 0;

		// Vertex shader uniform buffer block
		VkBufferCreateInfo bufferInfo;
		initBufferCreateInfo(&bufferInfo);
		bufferInfo.size = uboVS.sizeof;
		bufferInfo.usage = VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT;

		// Create a new buffer
		vulkanResult = vkCreateBuffer(chosenDevice.logicalDevice, &bufferInfo, null, &uniformDataVS.buffer);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(false, false, "Couldn't create buffer!");
		}
		// Get memory requirements including size, alignment and memory type 
		vkGetBufferMemoryRequirements(chosenDevice.logicalDevice, uniformDataVS.buffer, &memoryRequirements);
		allocInfo.allocationSize = memoryRequirements.size;
		// Gets the appropriate memory type for this type of buffer allocation
		// Only memory types that are visible to the host
		allocInfo.memoryTypeIndex = vulkanHelperSearchBestIndexOfMemoryType(chosenDevice.physicalDeviceMemoryProperties, memoryRequirements.memoryTypeBits, VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT, calleeSuccess);
		if( !calleeSuccess ) {
			throw new EngineException(true, true, "vulkanHelperSearchBestIndexOfMemoryType() failed!");
		}
		
		
		// Allocate memory for the uniform buffer
		vulkanResult = vkAllocateMemory(chosenDevice.logicalDevice, &allocInfo, null, &(uniformDataVS.memory));
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(false, false, "Couldn't allocate device memory!");
		}
		
		
		// Bind memory to buffer
		// SYNC : needs host sync
		vulkanResult = vkBindBufferMemory(chosenDevice.logicalDevice, uniformDataVS.buffer, uniformDataVS.memory, 0);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, false, "Couldn't bind memory!");
		}
		
		// Store information in the uniform's descriptor
		uniformDataVS.descriptor.buffer = uniformDataVS.buffer;
		uniformDataVS.descriptor.offset = 0;
		uniformDataVS.descriptor.range = uboVS.sizeof;

		updateUniformBuffers();
	}
	
	
	
	



	// setup descriptor set layout
	// ===========================
	VkPipelineLayout pipelineLayout;
	VkDescriptorSetLayout descriptorSetLayout;
	{
		VkDescriptorSetLayoutBinding descriptorSetLayoutBinding;
		descriptorSetLayoutBinding.binding = 0;
		descriptorSetLayoutBinding.descriptorType = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
		descriptorSetLayoutBinding.descriptorCount = 1;
		descriptorSetLayoutBinding.stageFlags = VK_SHADER_STAGE_VERTEX_BIT;
		descriptorSetLayoutBinding.pImmutableSamplers = null;

		VkDescriptorSetLayoutCreateInfo descriptorSetLayoutCreateInfo;
		initDescriptorSetLayoutCreateInfo(&descriptorSetLayoutCreateInfo);
		descriptorSetLayoutCreateInfo.bindingCount = 1;
		descriptorSetLayoutCreateInfo.pBindings = cast(immutable(VkDescriptorSetLayoutBinding)*)&descriptorSetLayoutBinding;

		vulkanResult = vkCreateDescriptorSetLayout(chosenDevice.logicalDevice, &descriptorSetLayoutCreateInfo, null, &descriptorSetLayout);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create Descriptor set layout!");
		}
		
		VkPipelineLayoutCreateInfo pipelineLayoutCreateInfo;
		initPipelineLayoutCreateInfo(&pipelineLayoutCreateInfo);
		pipelineLayoutCreateInfo.setLayoutCount = 1;
		pipelineLayoutCreateInfo.pSetLayouts = cast(immutable(ulong)*)&descriptorSetLayout;

		vulkanResult = vkCreatePipelineLayout(chosenDevice.logicalDevice, &pipelineLayoutCreateInfo, null, &pipelineLayout);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create Pipeline layout!");
		}
	}
	
	// prepare pipelines
	// =================
	VkPipeline pipelineDefault;
	{
		import core.stdc.string : memcpy;

		VkGraphicsPipelineCreateInfo graphicsPipelineCreateInfo;
		initGraphicsPipelineCreateInfo(&graphicsPipelineCreateInfo);
		graphicsPipelineCreateInfo.layout = pipelineLayout;
		graphicsPipelineCreateInfo.renderPass = renderPass;

		// TODO< rename >
		VkPipelineInputAssemblyStateCreateInfo inputAssemblyState;
		initPipelineInputAssemblyStateCreateInfo(&inputAssemblyState);
		inputAssemblyState.topology = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST; // This pipeline renders vertex data as triangle lists

		// TODO< rename >
		VkPipelineRasterizationStateCreateInfo rasterizationState;
		initPipelineRasterizationStateCreateInfo(&rasterizationState);
		rasterizationState.polygonMode = VK_POLYGON_MODE_FILL; // Solid polygon mode
		rasterizationState.cullMode = VK_CULL_MODE_NONE; // No culling
		rasterizationState.frontFace = VK_FRONT_FACE_COUNTER_CLOCKWISE;
		rasterizationState.depthClampEnable = vulkanBoolean(false);
		rasterizationState.rasterizerDiscardEnable = vulkanBoolean(false);
		rasterizationState.depthBiasEnable = vulkanBoolean(false);

		
		VkPipelineColorBlendStateCreateInfo colorBlendState;
		initPipelineColorBlendStateCreateInfo(&colorBlendState);
		// One blend attachment state
		// Blending is not used in this example
		VkPipelineColorBlendAttachmentState[1] blendAttachmentState;
		blendAttachmentState[0].colorWriteMask = 0xf;
		blendAttachmentState[0].blendEnable = vulkanBoolean(false);
		colorBlendState.attachmentCount = 1;
		colorBlendState.pAttachments = cast(immutable(VkPipelineColorBlendAttachmentState)*)&blendAttachmentState;

		// Viewport state
		VkPipelineViewportStateCreateInfo viewportState;
		initPipelineViewportStateCreateInfo(&viewportState);
		viewportState.viewportCount = 1; // One viewport
		viewportState.scissorCount = 1; // One scissor rectangle
		
		// Enable dynamic states
		// Describes the dynamic states to be used with this pipeline
		// Dynamic states can be set even after the pipeline has been created
		// So there is no need to create new pipelines just for changing
		// a viewport's dimensions or a scissor box
		VkPipelineDynamicStateCreateInfo dynamicState;
		initPipelineDynamicStateCreateInfo(&dynamicState);
		// The dynamic state properties themselves are stored in the command buffer
		VkDynamicState[] dynamicStateEnablesGced;
		dynamicStateEnablesGced ~= (VK_DYNAMIC_STATE_VIEWPORT);
		dynamicStateEnablesGced ~= (VK_DYNAMIC_STATE_SCISSOR);

		// copy to non GC'ed memory
		VkDynamicState* dynamicStateEnablesNonGced = cast(VkDynamicState*)GC.malloc(VkDynamicState.sizeof * dynamicStateEnablesGced.length, GC.BlkAttr.NO_MOVE | GC.BlkAttr.NO_SCAN);
		scope(exit) GC.free(dynamicStateEnablesNonGced);
		memcpy(dynamicStateEnablesNonGced, dynamicStateEnablesGced.ptr, VkDynamicState.sizeof * dynamicStateEnablesGced.length);

		dynamicState.pDynamicStates = cast(immutable(VkDynamicState*))dynamicStateEnablesNonGced;
		dynamicState.dynamicStateCount = dynamicStateEnablesGced.length;

		// depth and stencil
		VkPipelineDepthStencilStateCreateInfo depthStencilState;
		initPipelineDepthStencilStateCreateInfo(&depthStencilState);
		depthStencilState.depthTestEnable = vulkanBoolean(true);
		depthStencilState.depthWriteEnable = vulkanBoolean(true);
		depthStencilState.depthCompareOp = VK_COMPARE_OP_LESS_OR_EQUAL;
		depthStencilState.depthBoundsTestEnable = vulkanBoolean(false);
		depthStencilState.back.failOp = VK_STENCIL_OP_KEEP;
		depthStencilState.back.passOp = VK_STENCIL_OP_KEEP;
		depthStencilState.back.compareOp = VK_COMPARE_OP_ALWAYS;
		depthStencilState.stencilTestEnable = vulkanBoolean(false);
		depthStencilState.front = depthStencilState.back;

		// Multi sampling state
		VkPipelineMultisampleStateCreateInfo multisampleState;
		initPipelineMultisampleStateCreateInfo(&multisampleState);
		multisampleState.rasterizationSamples = VK_SAMPLE_COUNT_1_BIT;

		// Load shaders
		VkPipelineShaderStageCreateInfo[2] shaderStages;
		initPipelineShaderStageCreateInfo(&(shaderStages[0]));
		initPipelineShaderStageCreateInfo(&(shaderStages[1]));
		shaderStages[0].stage = VK_SHADER_STAGE_VERTEX_BIT;
		shaderStages[0].pName = "main";
		shaderStages[1].stage = VK_SHADER_STAGE_FRAGMENT_BIT;
		shaderStages[1].pName = "main";
		
		static if(/*USE_GLSL*/false) {
			shaderStages[0].module_ = loadShaderGlSl("triangle.vert", chosenDevice.logicalDevice, VK_SHADER_STAGE_VERTEX_BIT);
			shaderStages[1].module_ = loadShaderGlSl("triangle.frag", chosenDevice.logicalDevice, VK_SHADER_STAGE_FRAGMENT_BIT);
		}
		else {
			shaderStages[0].module_ = loadShader("triangle.vert.spv", chosenDevice.logicalDevice, VK_SHADER_STAGE_VERTEX_BIT);
			shaderStages[1].module_ = loadShader("triangle.frag.spv", chosenDevice.logicalDevice, VK_SHADER_STAGE_FRAGMENT_BIT);
		}
		
		// Assign states
		// Two shader stages
		graphicsPipelineCreateInfo.stageCount = 2;
		// Assign pipeline state create information
		graphicsPipelineCreateInfo.pStages = cast(immutable(VkPipelineShaderStageCreateInfo)*)shaderStages.ptr;
		graphicsPipelineCreateInfo.pVertexInputState = cast(immutable(VkPipelineVertexInputStateCreateInfo)*)&vertices.vi;
		graphicsPipelineCreateInfo.pInputAssemblyState = cast(immutable(VkPipelineInputAssemblyStateCreateInfo)*)&inputAssemblyState;
		graphicsPipelineCreateInfo.pViewportState = cast(immutable(VkPipelineViewportStateCreateInfo)*)&viewportState;
		graphicsPipelineCreateInfo.pRasterizationState = cast(immutable(VkPipelineRasterizationStateCreateInfo)*)&rasterizationState;
		graphicsPipelineCreateInfo.pMultisampleState = cast(immutable(VkPipelineMultisampleStateCreateInfo)*)&multisampleState;
		graphicsPipelineCreateInfo.pDepthStencilState = cast(immutable(VkPipelineDepthStencilStateCreateInfo)*)&depthStencilState;
		graphicsPipelineCreateInfo.pColorBlendState = cast(immutable(VkPipelineColorBlendStateCreateInfo)*)&colorBlendState;
		graphicsPipelineCreateInfo.pDynamicState = cast(immutable(VkPipelineDynamicStateCreateInfo)*)&dynamicState;
		
		graphicsPipelineCreateInfo.renderPass = renderPass;
		

		// Create rendering pipeline
		VkPipelineCache pipelineCache = VK_NULL_HANDLE;
		vulkanResult = vkCreateGraphicsPipelines(chosenDevice.logicalDevice, pipelineCache, 1, &graphicsPipelineCreateInfo, null, &pipelineDefault);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create Graphics Pipeline!");
		}
	}

	
	
	
	// setup descriptor pool
	// =====================
	VkDescriptorPool descriptorPool;
	{
		// We need to tell the API the number of max. requested descriptors per type
		VkDescriptorPoolSize[1] typeCounts;
		typeCounts[0].type = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
		typeCounts[0].descriptorCount = 1;

		// Create the global descriptor pool
		// All descriptors used in this example are allocated from this pool
		VkDescriptorPoolCreateInfo descriptorPoolInfo;
		initDescriptorPoolCreateInfo(&descriptorPoolInfo);
		descriptorPoolInfo.poolSizeCount = 1;
		descriptorPoolInfo.pPoolSizes = cast(immutable(VkDescriptorPoolSize)*)typeCounts.ptr;
		// Set the max. number of sets that can be requested
		// Requesting descriptors beyond maxSets will result in an error
		descriptorPoolInfo.maxSets = 1;

		vulkanResult = vkCreateDescriptorPool(chosenDevice.logicalDevice, &descriptorPoolInfo, null, &descriptorPool);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create Descriptor pool!");
		}
	}

	
	
	
	// setup Descriptor Set
	// ====================
	VkDescriptorSet descriptorSet;
	{
		// Update descriptor sets determining the shader binding points
		// For every binding point used in a shader there needs to be one
		// descriptor set matching that binding point
		
		VkDescriptorSetAllocateInfo allocInfo; // TODO< rename >
		initDescriptorSetAllocateInfo(&allocInfo);
		allocInfo.descriptorPool = descriptorPool;
		allocInfo.descriptorSetCount = 1;
		allocInfo.pSetLayouts = cast(immutable(ulong)*)&descriptorSetLayout;

		vulkanResult = vkAllocateDescriptorSets(chosenDevice.logicalDevice, &allocInfo, &descriptorSet);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(false, false, "Couldn't allocate descriptor sets!");
		}
		
		VkWriteDescriptorSet writeDescriptorSet;
		initWriteDescriptorSet(&writeDescriptorSet);

		// Binding 0 : Uniform buffer
		writeDescriptorSet.dstSet = descriptorSet;
		writeDescriptorSet.descriptorCount = 1;
		writeDescriptorSet.descriptorType = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
		writeDescriptorSet.pBufferInfo = cast(immutable(VkDescriptorBufferInfo)*)&uniformDataVS.descriptor;
		// Binds this uniform buffer to binding point 0
		writeDescriptorSet.dstBinding = 0;

		vkUpdateDescriptorSets(chosenDevice.logicalDevice, 1, &writeDescriptorSet, 0, null);
	}

	
	
	
	
	// build command buffers
	// =====================
	
	// Build separate command buffers for every framebuffer image
	// Unlike in OpenGL all rendering commands are recorded once
	// into command buffers that are then resubmitted to the queue
	
	// Command buffers used for rendering
	VkCommandBuffer[] drawCmdBuffersGced;
	{
		VkCommandBufferBeginInfo cmdBufInfo;
		initCommandBufferBeginInfo(&cmdBufInfo);

		VkClearValue[2] clearValues;
		clearValues[0].color = defaultClearColor;
		clearValues[1].depthStencil = [ 1.0f, 0 ];

		VkRenderPassBeginInfo renderPassBeginInfo;
		initRenderPassBeginInfo(&renderPassBeginInfo);
		renderPassBeginInfo.renderPass = renderPass;
		renderPassBeginInfo.renderArea.offset.x = 0;
		renderPassBeginInfo.renderArea.offset.y = 0;
		renderPassBeginInfo.renderArea.extent.width = width;
		renderPassBeginInfo.renderArea.extent.height = height;
		renderPassBeginInfo.clearValueCount = 2;
		renderPassBeginInfo.pClearValues = clearValues;

		for (int32_t i = 0; i < drawCmdBuffers.size(); ++i)
		{
			// Set target frame buffer
			renderPassBeginInfo.framebuffer = frameBuffers[i];

			vulkanResult = vkBeginCommandBuffer(drawCmdBuffers[i], &cmdBufInfo);
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Couldn't begin command buffer!");
			}

			vkCmdBeginRenderPass(drawCmdBuffers[i], &renderPassBeginInfo, VK_SUBPASS_CONTENTS_INLINE);

			// Update dynamic viewport state
			VkViewport viewport;
			viewport.height = cast(float)height;
			viewport.width = cast(float)width;
			viewport.minDepth = cast(float) 0.0f;
			viewport.maxDepth = cast(float) 1.0f;
			vkCmdSetViewport(drawCmdBuffers[i], 0, 1, &viewport);

			// Update dynamic scissor state
			VkRect2D scissor;
			scissor.extent.width = width;
			scissor.extent.height = height;
			scissor.offset.x = 0;
			scissor.offset.y = 0;
			vkCmdSetScissor(drawCmdBuffers[i], 0, 1, &scissor);

			// Bind descriptor sets describing shader binding points
			vkCmdBindDescriptorSets(drawCmdBuffers[i], VK_PIPELINE_BIND_POINT_GRAPHICS, pipelineLayout, 0, 1, &descriptorSet, 0, NULL);

			// Bind the rendering pipeline (including the shaders)
			vkCmdBindPipeline(drawCmdBuffers[i], VK_PIPELINE_BIND_POINT_GRAPHICS, pipelines.solid);

			// Bind triangle vertices
			VkDeviceSize[1] offsets;
			vkCmdBindVertexBuffers(drawCmdBuffers[i], VERTEX_BUFFER_BIND_ID, 1, &vertices.buf, offsets);

			// Bind triangle indices
			vkCmdBindIndexBuffer(drawCmdBuffers[i], indices.buf, 0, VK_INDEX_TYPE_UINT32);

			// Draw indexed triangle
			vkCmdDrawIndexed(drawCmdBuffers[i], indices.count, 1, 0, 0, 1);

			vkCmdEndRenderPass(drawCmdBuffers[i]);

			// Add a present memory barrier to the end of the command buffer
			// This will transform the frame buffer color attachment to a
			// new layout for presenting it to the windowing system integration 
			VkImageMemoryBarrier prePresentBarrier;
			initImageMemoryBarrier(&prePresentBarrier);
			prePresentBarrier.srcAccessMask = VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;
			prePresentBarrier.dstAccessMask = 0;
			prePresentBarrier.oldLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
			prePresentBarrier.newLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;
			prePresentBarrier.srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
			prePresentBarrier.dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
			prePresentBarrier.subresourceRange = { VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1 };			
			prePresentBarrier.image = swapChain.buffers[i].image;

			VkImageMemoryBarrier* pMemoryBarrier = &prePresentBarrier;
			vkCmdPipelineBarrier(
				drawCmdBuffers[i], 
				VK_PIPELINE_STAGE_ALL_COMMANDS_BIT, 
				VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT, 
				VK_FLAGS_NONE,
				0, null,
				0, null,
				1, &prePresentBarrier
			);

			vulkanResult = vkEndCommandBuffer(drawCmdBuffers[i]);
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Couldn't end command buffer!");
			}
		}
	}







	writeln("success!");

	vkDestroyRenderPass(chosenDevice.logicalDevice, renderPass, null);


	vkFreeCommandBuffers(chosenDevice.logicalDevice, commandPool, 1, &primaryCommandBuffer); ///

	vkDestroyCommandPool(chosenDevice.logicalDevice, commandPool, null); ///


	vkDestroyDevice(chosenDevice.logicalDevice, null); ///


	vkDestroyInstance(instance, null); ///


	releaseVulkanLibrary();
}
