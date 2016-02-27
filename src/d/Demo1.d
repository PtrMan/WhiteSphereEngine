import core.runtime;
import core.sys.windows.windows;
import std.string;

/*
extern (Windows)
int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
            LPSTR lpCmdLine, int nCmdShow)
{
    int result;
 
    try
    {
        Runtime.initialize();
        result = myWinMain(hInstance, hPrevInstance, lpCmdLine, nCmdShow);
        Runtime.terminate();
    }
    catch (Throwable e) 
    {
        MessageBoxA(null, e.toString().toStringz(), "Error",
                    MB_OK | MB_ICONEXCLAMATION);
        result = 0;     // failed
    }
 
    return result;
}
*/

import systemEnvironment.EnvironmentChain;
import systemEnvironment.Vulkan;
import systemEnvironment.Window;
import systemEnvironment.ChainContext;

import api.vulkan.Vulkan;
import vulkan.VulkanHelpers;
import vulkan.VulkanDevice;
import vulkan.VulkanTools;

import std.stdint;


// TODO< move to utilities! >
// helper which creates code to copy an GC'ed array to a non-GC'ed array, memory gets released with scope
template copyGcedArrayToNongcedMemory(string sourceGcedArray, string destinationNonGcedVariablename) {
	const char[] copyGcedArrayToNongcedMemory = 
	"import core.memory : GC;\n" ~
	"import core.stdc.string : memcpy;\n" ~
	
    destinationNonGcedVariablename ~" = cast(typeof(" ~ destinationNonGcedVariablename ~ "))GC.malloc(" ~ sourceGcedArray ~ ".sizeof, GC.BlkAttr.NO_MOVE | GC.BlkAttr.NO_SCAN);\n" ~
	"scope(exit) GC.free(" ~ destinationNonGcedVariablename ~ ");\n" ~
	"memcpy(" ~ destinationNonGcedVariablename ~ ", " ~ sourceGcedArray ~ ".ptr, " ~ sourceGcedArray ~ ".sizeof);\n";
}


void innerFunction(ChainContext chainContext, ChainElement[] chainElements, uint chainIndex) {
	import std.stdio;
	
	// cache variables
	VulkanDevice chosenDevice = chainContext.vulkan.chosenDevice;


	VkResult vulkanResult;
	
	VkDescriptorPool descriptorPool;
	VkDescriptorSetLayout descriptorSetLayout;
	VkDescriptorSet descriptorSet;
	
	VkPipelineLayout pipelineLayout;
	
	
	// helper struct
	
	class BufferDescriptor {
		VkBuffer buffer;
		VkDeviceMemory deviceMemory;
	}
	
	
	struct BindingDescriptors {
		//VkBuffer buf;
		//VkDeviceMemory mem;
		BufferDescriptor bufferDescriptor;

		VkPipelineVertexInputStateCreateInfo vi; // TODO< rename >
		VkVertexInputBindingDescription[] bindingDescriptionsGced;
		VkVertexInputAttributeDescription[] attributeDescriptionsGced;
	}
	
	const uint VERTEX_BUFFER_BIND_ID = 0;
	
	// TODO< rename >
	BindingDescriptors vertices;
	
	
	
	struct IndicesStruct {
		//VkBuffer buf;
		//VkDeviceMemory mem;
		BufferDescriptor bufferDescriptor;
		
		uint count;
	}
	
	IndicesStruct indices;
	
	
	
	struct UniformDataVS{
		VkBuffer buffer;
		VkDeviceMemory memory;
		VkDescriptorBufferInfo descriptor;
	}

	UniformDataVS uniformDataVS;
	
	
	struct Pipelines {
		VkPipeline solid;
	}
	Pipelines pipelines;

	
	
	writeln("INNER ENTER");
	
	
	// see https://github.com/SaschaWillems/Vulkan/blob/master/triangle/triangle.cpp
	//     license: MIT
	
	void prepareVertices() {	
		
		// create and fill buffers for vertex data
		// TODO< abstract this somehow deep into the engine >
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
			vkUnmapMemory(chainContext.vulkan.chosenDevice.logicalDevice, buffer.deviceMemory);
			
			// SYNC : needs host sync
			vulkanResult = vkBindBufferMemory(chosenDevice.logicalDevice, buffer.buffer, buffer.deviceMemory, 0);
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, false, "Couldn't bind memory!");
			}
		}
		
		vertices.bufferDescriptor = new BufferDescriptor();
		float[3*(3+3)] testVerticesWithColor;
	
		vulkanHelperCreateMemoryAndBufferBindAndFill(vertices.bufferDescriptor, VK_BUFFER_USAGE_VERTEX_BUFFER_BIT, &testVerticesWithColor, testVerticesWithColor.sizeof);
	
		indices.bufferDescriptor = new BufferDescriptor();
		uint32_t[1/*TODO*/] testIndices;
	
		vulkanHelperCreateMemoryAndBufferBindAndFill(indices.bufferDescriptor, VK_BUFFER_USAGE_INDEX_BUFFER_BIT, &testIndices, testIndices.sizeof);
		
		
		
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

	
	
	// this crashes and sucks >
	//VkVertexInputBindingDescription* bindingDescriptionsNonGced;
	//mixin(copyGcedArrayToNongcedMemory!("vertices.bindingDescriptionsGced", "bindingDescriptionsNonGced"));	
	//VkVertexInputAttributeDescription* attributeDescriptionsNonGced;
	//mixin(copyGcedArrayToNongcedMemory!("vertices.attributeDescriptionsGced", "attributeDescriptionsNonGced"));
	
	vertices.vi.vertexBindingDescriptionCount = vertices.bindingDescriptionsGced.length;
	vertices.vi.pVertexBindingDescriptions = cast(immutable(VkVertexInputBindingDescription)*)vertices.bindingDescriptionsGced.ptr;
	vertices.vi.vertexAttributeDescriptionCount = vertices.attributeDescriptionsGced.length;
	vertices.vi.pVertexAttributeDescriptions = cast(immutable(VkVertexInputAttributeDescription)*)vertices.attributeDescriptionsGced.ptr;

	}
	
	
	// TODO< refactor buffer managment into helper functions which manage it >
	void prepareUniformBuffers() {
		import core.stdc.string : memcpy;
		
		// see https://github.com/SaschaWillems/Vulkan/blob/master/triangle/triangle.cpp
		//     license: MIT
		
		
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
		allocInfo.memoryTypeIndex = vulkanHelperSearchBestIndexOfMemoryType(chainContext.vulkan.chosenDevice.physicalDeviceMemoryProperties, memoryRequirements.memoryTypeBits, VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT, calleeSuccess);
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
	
	void setupDescriptorSetLayout() {
		VkPipelineLayout pipelineLayout;
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
	}
	
	
	
	
	void preparePipelines() {
		VkPipeline pipelineDefault;
		{
			import core.stdc.string : memcpy;
	
			VkGraphicsPipelineCreateInfo graphicsPipelineCreateInfo;
			initGraphicsPipelineCreateInfo(&graphicsPipelineCreateInfo);
			graphicsPipelineCreateInfo.layout = pipelineLayout;
			graphicsPipelineCreateInfo.renderPass = chainContext.vulkan.renderPass;
	
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
			
			IDisposable[] toCleanupAfterCreationOfPipeline;
			
			static if(/*USE_GLSL*/false) {
				shaderStages[0].module_ = loadShaderGlSl("triangle.vert", chosenDevice.logicalDevice, VK_SHADER_STAGE_VERTEX_BIT);
				shaderStages[1].module_ = loadShaderGlSl("triangle.frag", chosenDevice.logicalDevice, VK_SHADER_STAGE_FRAGMENT_BIT);
			}
			else {
				toCleanupAfterCreationOfPipeline ~= loadShader("triangle.vert.spv", chosenDevice.logicalDevice, VK_SHADER_STAGE_VERTEX_BIT, &shaderStages[0].module_);
				toCleanupAfterCreationOfPipeline ~= loadShader("triangle.frag.spv", chosenDevice.logicalDevice, VK_SHADER_STAGE_FRAGMENT_BIT, &shaderStages[1].module_);
			}
			
			// Assign states
			// Two shader stages
			graphicsPipelineCreateInfo.stageCount = 2;
			// Assign pipeline state create information
			graphicsPipelineCreateInfo.pStages = cast(immutable(VkPipelineShaderStageCreateInfo)*)&shaderStages;
			graphicsPipelineCreateInfo.pVertexInputState = cast(immutable(VkPipelineVertexInputStateCreateInfo)*)&vertices.vi;
			graphicsPipelineCreateInfo.pInputAssemblyState = cast(immutable(VkPipelineInputAssemblyStateCreateInfo)*)&inputAssemblyState;
			graphicsPipelineCreateInfo.pViewportState = cast(immutable(VkPipelineViewportStateCreateInfo)*)&viewportState;
			graphicsPipelineCreateInfo.pRasterizationState = cast(immutable(VkPipelineRasterizationStateCreateInfo)*)&rasterizationState;
			graphicsPipelineCreateInfo.pMultisampleState = cast(immutable(VkPipelineMultisampleStateCreateInfo)*)&multisampleState;
			graphicsPipelineCreateInfo.pDepthStencilState = cast(immutable(VkPipelineDepthStencilStateCreateInfo)*)&depthStencilState;
			graphicsPipelineCreateInfo.pColorBlendState = cast(immutable(VkPipelineColorBlendStateCreateInfo)*)&colorBlendState;
			graphicsPipelineCreateInfo.pDynamicState = cast(immutable(VkPipelineDynamicStateCreateInfo)*)&dynamicState;
			
			graphicsPipelineCreateInfo.renderPass = chainContext.vulkan.renderPass;
			
			
			// Create rendering pipeline
			VkPipelineCache pipelineCache = VK_NULL_HANDLE;
			vulkanResult = vkCreateGraphicsPipelines(chosenDevice.logicalDevice, pipelineCache, 1, &graphicsPipelineCreateInfo, null, &pipelineDefault);
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Couldn't create Graphics Pipeline!");
			}
			
			// release all memory of the shaders
			foreach( IDisposable iterationDisposable; toCleanupAfterCreationOfPipeline ) {
				iterationDisposable.dispose();
			}
		}
	}
	
	void setupDescriptorPool() {
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

	void setupDescriptorSet() {
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
	
	// Build separate command buffers for every framebuffer image
	// Unlike in OpenGL all rendering commands are recorded once
	// into command buffers that are then resubmitted to the queue
	void buildCommandBuffers() {
		// Command buffers used for rendering
		VkCommandBuffer[] drawCmdBuffersGced;
		{
			VkCommandBufferBeginInfo cmdBufInfo;
			initCommandBufferBeginInfo(&cmdBufInfo);
			
			VkClearColorValue defaultClearColor;
			defaultClearColor.float32[0] = 0.025f;
			defaultClearColor.float32[1] = 0.025f;
			defaultClearColor.float32[2] = 0.025f;
			defaultClearColor.float32[3] = 1.0f;
	
			VkClearValue[2] clearValues;
			clearValues[0].color = defaultClearColor;
			clearValues[1].depthStencil.depth = 1.0f;
			clearValues[1].depthStencil.stencil = 0;
	
			VkRenderPassBeginInfo renderPassBeginInfo;
			initRenderPassBeginInfo(&renderPassBeginInfo);
			renderPassBeginInfo.renderPass = chainContext.vulkan.renderPass;
			renderPassBeginInfo.renderArea.offset.x = 0;
			renderPassBeginInfo.renderArea.offset.y = 0;
			renderPassBeginInfo.renderArea.extent.width = chainContext.window.width;
			renderPassBeginInfo.renderArea.extent.height = chainContext.window.height;
			renderPassBeginInfo.clearValueCount = 2;
			renderPassBeginInfo.pClearValues = cast(immutable(VkClearValue)*)clearValues.ptr;
	
			for (int32_t i = 0; i < chainContext.vulkan.drawCmdBuffers.length; ++i)
			{
				// Set target frame buffer
				renderPassBeginInfo.framebuffer = chainContext.vulkan.frameBuffers.ptr[i];
	
				vulkanResult = vkBeginCommandBuffer(chainContext.vulkan.drawCmdBuffers.ptr[i], &cmdBufInfo);
				if( !vulkanSuccess(vulkanResult) ) {
					throw new EngineException(true, true, "Couldn't begin command buffer!");
				}
	
				vkCmdBeginRenderPass(chainContext.vulkan.drawCmdBuffers.ptr[i], &renderPassBeginInfo, VK_SUBPASS_CONTENTS_INLINE);
	
				// Update dynamic viewport state
				VkViewport viewport;
				viewport.height = cast(float)chainContext.window.height;
				viewport.width = cast(float)chainContext.window.width;
				viewport.minDepth = cast(float)0.0f;
				viewport.maxDepth = cast(float)1.0f;
				vkCmdSetViewport(chainContext.vulkan.drawCmdBuffers.ptr[i], 0, 1, &viewport);
	
				// Update dynamic scissor state
				VkRect2D scissor;
				scissor.extent.width = chainContext.window.width;
				scissor.extent.height = chainContext.window.height;
				scissor.offset.x = 0;
				scissor.offset.y = 0;
				vkCmdSetScissor(chainContext.vulkan.drawCmdBuffers.ptr[i], 0, 1, &scissor);
	
				// Bind descriptor sets describing shader binding points
				vkCmdBindDescriptorSets(chainContext.vulkan.drawCmdBuffers.ptr[i], VK_PIPELINE_BIND_POINT_GRAPHICS, pipelineLayout, 0, 1, &descriptorSet, 0, NULL);
	
				// Bind the rendering pipeline (including the shaders)
				vkCmdBindPipeline(chainContext.vulkan.drawCmdBuffers.ptr[i], VK_PIPELINE_BIND_POINT_GRAPHICS, pipelines.solid);
	
				// Bind triangle vertices
				VkDeviceSize[1] offsets;
				vkCmdBindVertexBuffers(chainContext.vulkan.drawCmdBuffers.ptr[i], VERTEX_BUFFER_BIND_ID, 1, &vertices.bufferDescriptor.buffer, offsets.ptr);
	
				// Bind triangle indices
				vkCmdBindIndexBuffer(chainContext.vulkan.drawCmdBuffers.ptr[i], indices.bufferDescriptor.buffer, 0, VK_INDEX_TYPE_UINT32);
	
				// Draw indexed triangle
				vkCmdDrawIndexed(chainContext.vulkan.drawCmdBuffers.ptr[i], indices.count, 1, 0, 0, 1);
	
				vkCmdEndRenderPass(chainContext.vulkan.drawCmdBuffers.ptr[i]);
	
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
				prePresentBarrier.subresourceRange.baseMipLevel = 0;
				prePresentBarrier.subresourceRange.levelCount = 1;
				prePresentBarrier.subresourceRange.baseArrayLayer = 0;
				prePresentBarrier.subresourceRange.layerCount = 1;
				prePresentBarrier.image = chainContext.vulkan.swapChain.buffers[i].image;
	
				VkImageMemoryBarrier* pMemoryBarrier = &prePresentBarrier;
				vkCmdPipelineBarrier(
					chainContext.vulkan.drawCmdBuffers.ptr[i], 
					VK_PIPELINE_STAGE_ALL_COMMANDS_BIT, 
					VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT, 
					VK_FLAGS_NONE,
					0, null,
					0, null,
					1, &prePresentBarrier
				);
	
				vulkanResult = vkEndCommandBuffer(chainContext.vulkan.drawCmdBuffers[i]);
				if( !vulkanSuccess(vulkanResult) ) {
					throw new EngineException(true, true, "Couldn't end command buffer!");
				}
			}
		}
	}
	
	
	
	prepareVertices();
	// TODO< cleanup >
	
	prepareUniformBuffers();
	// TODO< cleanup >
	
	setupDescriptorSetLayout();
	// TODO< cleanup >
	
	preparePipelines();
	// TODO< cleanup >
	
	setupDescriptorPool();
	// TODO< cleanup >
	
	setupDescriptorSet();
	// TODO< cleanup >
	
	buildCommandBuffers();
	// TODO< cleanup >
	
	writeln("INNER EXIT");
}

//int myWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
void main(string[] args) {
	// for tracing down possible bugs
	import core.memory : GC;
	GC.disable();
	
	
	ChainContext chainContext = new ChainContext();
	chainContext.window.caption = "PtrEngine Demo1";
	chainContext.window.width = 800;
	chainContext.window.height = 600;
	version(Win32) {
		import core.sys.windows.windows;
		
		// this is not 100% clean but we grab the hInstance from the system and set it
		// see http://stackoverflow.com/questions/1749972/determine-the-current-hinstance
		// NOTE< propably doesn't work if we create a opengl context >
		chainContext.windowsContext.hInstance = GetModuleHandleA(null);
	}
	
	ChainElement[] chainElements;
	chainElements ~= new ChainElement(&platformWindow);
	chainElements ~= new ChainElement(&platformVulkan1Libary);
	chainElements ~= new ChainElement(&platformVulkan2DeviceBase);
	chainElements ~= new ChainElement(&platformVulkan3SwapChain);
	chainElements ~= new ChainElement(&platformVulkan4);
	chainElements ~= new ChainElement(&innerFunction);
	processChain(chainElements, chainContext);

    //return 1;
}
