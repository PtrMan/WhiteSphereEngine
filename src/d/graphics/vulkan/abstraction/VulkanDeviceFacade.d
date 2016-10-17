module graphics.vulkan.abstraction.VulkanDeviceFacade;

import core.stdc.stdint;

import Exceptions;
import api.vulkan.Vulkan;
import vulkan.VulkanHelpers;
import graphics.vulkan.VulkanTypesAndEnums;

// hides the device handle and exposes a thin wrapper around the vulkan functions
// * throws also exceptions if an function didn't return VK_SUCCESS
// * simplifies names by overloads for images, etc
// * TODO< static methods which construct default structures, for exmple for the parameters of image creation >
class VulkanDeviceFacade {
	final this(VkDevice device) {
		this.protectedDevice = device;
	}
	
	final void getMemoryRequirements(TypesafeVkImage image, out VkMemoryRequirements memRequirements) {
		VkMemoryRequirements internalMemRequirements; // local value to avoid troubles with pointers
		vkGetImageMemoryRequirements(device, cast(VkImage)image, &internalMemRequirements);
		memRequirements = internalMemRequirements;
	}
	
	final void getMemoryRequirements(TypesafeVkBuffer buffer, out VkMemoryRequirements memRequirements) {
		VkMemoryRequirements internalMemRequirements; // local value to avoid troubles with pointers
		vkGetBufferMemoryRequirements(device, cast(VkBuffer)buffer, &internalMemRequirements);
		memRequirements = internalMemRequirements;
	}

	
	final void bind(TypesafeVkImage image, TypesafeVkDeviceMemory memory, VkDeviceSize memoryOffset) {
		VkResult result = vkBindImageMemory(device, cast(VkImage)image, cast(VkDeviceMemory)memory, memoryOffset);
		if( !result.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't bind memory! [vkBindImageMemory]");
		}
	}
	
	final void bind(TypesafeVkBuffer buffer, TypesafeVkDeviceMemory memory, VkDeviceSize memoryOffset) {
		VkResult result = vkBindBufferMemory(device, cast(VkBuffer)buffer, cast(VkDeviceMemory)memory, memoryOffset);
		if( !result.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't bind memory! [vkBindBufferMemory]");
		}
	}

	
	final TypesafeVkSemaphore createSemaphore(const VkAllocationCallbacks* allocator = null) {
		VkSemaphore rawSemaphore;
		const VkSemaphoreCreateInfo semaphoreCreateInfo = {
			VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO,    // sType
			null,                                       // pNext
			0                                           // flags
		};
		
		VkResult result = vkCreateSemaphore(device, &semaphoreCreateInfo, allocator, &rawSemaphore);
		if( !result.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't create semaphore! [vkCreateSemaphore]");
		}
		
		return cast(TypesafeVkSemaphore)rawSemaphore;
	}
	
	final void destroySemaphore(TypesafeVkSemaphore semaphore, const VkAllocationCallbacks* allocator = null) {
		TypesafeVkSemaphore[1] semaphores = [semaphore];
		destroySemaphores(semaphores, allocator);
	}
	
	// meta function
	final void destroySemaphores(TypesafeVkSemaphore[] semaphores, const VkAllocationCallbacks* allocator = null) {
		foreach( iterationSemaphore; semaphores ) {
			vkDestroySemaphore(device, cast(VkSemaphore)iterationSemaphore, allocator);
		}
	}
	
	static struct CreateBufferArguments {
		VkBufferCreateFlags flags = 0;
		VkDeviceSize size;
		VkBufferUsageFlags usage;
		VkSharingMode sharingMode = VK_SHARING_MODE_EXCLUSIVE;
		uint32_t[] queueFamilyIndices;
	}
	
	final TypesafeVkBuffer createBuffer(CreateBufferArguments arguments, const VkAllocationCallbacks* allocator = null) {
		VkBuffer rawBuffer;
		
		VkBufferCreateInfo createInfo = VkBufferCreateInfo.init;
		with(createInfo) {
			sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
			flags = arguments.flags;
			size = arguments.size;
			usage = arguments.usage;
			sharingMode = arguments.sharingMode;
			queueFamilyIndexCount = cast(uint32_t)arguments.queueFamilyIndices.length;
			pQueueFamilyIndices = cast(immutable(uint)*)arguments.queueFamilyIndices.ptr;
		}
		
		VkResult result = vkCreateBuffer(device, &createInfo, allocator, &rawBuffer);
		if( !result.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't create buffer! [vkCreateBuffer]");
		}
		return cast(TypesafeVkBuffer)rawBuffer;
	}
	
	final void destroyBuffer(TypesafeVkBuffer buffer, const VkAllocationCallbacks* allocator = null) {
		TypesafeVkBuffer[1] buffers = [buffer];
		destroyBuffers(buffers, allocator);
	}
	
	// meta function
	final void destroyBuffers(TypesafeVkBuffer[] buffers, const VkAllocationCallbacks* allocator = null) {
		foreach( iterationBuffer; buffers ) {
			vkDestroyBuffer(device, cast(VkBuffer)iterationBuffer, allocator);
		}
	}
	
	
	// TODO< create image >

	static struct CreateImageArguments {
		VkImageCreateFlags flags = 0;
		VkImageType imageType = VK_IMAGE_TYPE_2D;
		VkFormat format;
		VkExtent3D extent;
		uint32_t mipLevels = 1;
		uint32_t arrayLayers = 1;
		VkSampleCountFlagBits samples = VK_SAMPLE_COUNT_1_BIT;
		VkImageTiling tiling = VK_IMAGE_TILING_OPTIMAL;
		VkImageUsageFlags usage;
		VkSharingMode sharingMode = 0;
		uint32_t queueFamilyIndexCount;
		immutable(uint32_t)* pQueueFamilyIndices;
		VkImageLayout initialLayout = VK_IMAGE_LAYOUT_UNDEFINED;
	}

	final TypesafeVkImage createImage(CreateImageArguments arguments, const VkAllocationCallbacks* allocator = null) {
		VkImage rawImage;

		VkImageCreateInfo imageCreateInfo;
		initImageCreateInfo(&imageCreateInfo);
		with(imageCreateInfo) {
			flags = arguments.flags;
			imageType = arguments.imageType;
			format = arguments.format;
			extent = arguments.extent;
			mipLevels = arguments.mipLevels;
			arrayLayers = arguments.arrayLayers;
			samples = arguments.samples;
			tiling = arguments.tiling;
			usage = arguments.usage;
			sharingMode = arguments.sharingMode;
			queueFamilyIndexCount = arguments.queueFamilyIndexCount;
			pQueueFamilyIndices = arguments.pQueueFamilyIndices;
			initialLayout = arguments.initialLayout;
		}

		VkResult result = vkCreateImage(
			device,
			&imageCreateInfo,
			allocator,
			&rawImage
		);
		if( !result.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't create image [vkCreateImage]!");
		}
		return cast(TypesafeVkImage)rawImage;
	}
	
	final void destroyImage(TypesafeVkImage image, const VkAllocationCallbacks* allocator = null) {
		TypesafeVkImage[1] images = [image];
		destroyImages(images, allocator);
	}
	
	final void destroyImages(TypesafeVkImage[] images, const VkAllocationCallbacks* allocator = null) {
		foreach( iterationImage; images ) {
			vkDestroyImage(device, cast(VkImage)iterationImage, allocator);
		}
	}
	
	final TypesafeVkFence createFence(VkFenceCreateFlags flags = 0, const VkAllocationCallbacks* allocator = null) {
		VkFence rawFence;
		
		VkFenceCreateInfo fenceCreateInfo = VkFenceCreateInfo.init;
		fenceCreateInfo.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
		fenceCreateInfo.flags = flags;
		
		VkResult vulkanResult = vkCreateFence(device, &fenceCreateInfo, allocator, &rawFence);
		if( !vulkanResult.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't create fence [vkCreateFence]!");
		}
		return cast(TypesafeVkFence)rawFence;
	}
	
	final void destroyFence(TypesafeVkFence fence, const VkAllocationCallbacks* allocator = null) {
		TypesafeVkFence[1] fences = [fence];
		destroyFences(fences, allocator);
	}
	
	final void destroyFences(TypesafeVkFence[] fences, const VkAllocationCallbacks* allocator = null) {
		foreach( iterationFence; fences ) {
			vkDestroyFence(device, cast(VkFence)iterationFence, allocator);
		}
		
	}
	
	// meta function
	final void fenceWaitAndReset(TypesafeVkFence fence) {
		VkFence rawFence = cast(VkFence)fence;
		VkResult vulkanResult = vkWaitForFences(protectedDevice, 1, &rawFence, VK_TRUE, UINT64_MAX);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Wait for fences failed! [vkWaitForFences]");
		}
		
		vulkanResult = vkResetFences(protectedDevice, 1, &rawFence);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Fence reset failed! [vkResetFrences]");
		}
	}
	
	
	final TypesafeVkCommandBuffer[] allocateCommandBuffers(TypesafeVkCommandPool pool, size_t count, VkCommandBufferLevel level = VK_COMMAND_BUFFER_LEVEL_PRIMARY) {
		
		VkCommandBuffer[] rawCommandBuffers;
		rawCommandBuffers.length = count;
		
		VkCommandBufferAllocateInfo commandBufferAllocateInfo = VkCommandBufferAllocateInfo.init;
		with(commandBufferAllocateInfo) {
			sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
			commandPool = cast(VkCommandPool)pool;
			commandBufferCount = cast(uint32_t)count;
		}
		commandBufferAllocateInfo.level = level;// outside because of variablename
		
		VkResult vulkanResult = vkAllocateCommandBuffers(device, &commandBufferAllocateInfo, rawCommandBuffers.ptr);
		if( !vulkanResult.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't allocate command buffers [vkAllocateCommandBuffers]");
		}
		
		// translate to typesafe values
		TypesafeVkCommandBuffer[] commandBuffers;
		commandBuffers.length = rawCommandBuffers.length;
		foreach( i; 0..commandBuffers.length ) {
			commandBuffers[i] = cast(TypesafeVkCommandBuffer)rawCommandBuffers[i];
		}
		
		return commandBuffers;
	}
	
	final TypesafeVkCommandBuffer allocateCommandBuffer(TypesafeVkCommandPool pool, VkCommandBufferLevel level = VK_COMMAND_BUFFER_LEVEL_PRIMARY) {
		TypesafeVkCommandBuffer[] commandBuffers = allocateCommandBuffers(pool, 1, level);
		return commandBuffers[0];
	}
	
	final void freeCommandBuffer(TypesafeVkCommandBuffer commandBuffer, TypesafeVkCommandPool commandPool) {
		TypesafeVkCommandBuffer[1] commandBuffers = [commandBuffer];
		freeCommandBuffers(commandBuffers, commandPool);
	}
	
	final void freeCommandBuffers(TypesafeVkCommandBuffer[] commandBuffers, TypesafeVkCommandPool commandPool) {
		static assert( TypesafeVkCommandBuffer.sizeof == VkCommandBuffer.sizeof ); // sizes have to be identical for array cheatery
		vkFreeCommandBuffers(device, cast(VkCommandPool)commandPool, commandBuffers.length, cast(VkCommandBuffer*)commandBuffers.ptr);
	}
	
	
	static struct CreateImageViewArguments {
		VkImageViewCreateFlags     flags = 0; // default
		TypesafeVkImage            image;
		VkImageViewType            viewType;
		VkFormat                   format;
		VkComponentMapping         components; // default
		VkImageSubresourceRange    subresourceRange; // default
		
		static CreateImageViewArguments make() {
			CreateImageViewArguments result = CreateImageViewArguments.init;
			with( result.components ) {
				r = g = b = a = VK_COMPONENT_SWIZZLE_IDENTITY;
			}
			
			with( result.subresourceRange ) {
				aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
				baseMipLevel = 0;
				levelCount = 1;
				baseArrayLayer = 0;
				layerCount = 1;
			}
			
			return result;
		}
	}
	
	final TypesafeVkImageView createImageView(CreateImageViewArguments arguments, const(VkAllocationCallbacks*) allocator = null) {
		VkImageViewCreateInfo imageViewCreateInfo = VkImageViewCreateInfo.init;
		with(imageViewCreateInfo) {
			sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
			flags = arguments.flags;
			image = cast(VkImage)arguments.image;
			viewType = arguments.viewType;
			format = arguments.format;
			components = arguments.components;
			subresourceRange = arguments.subresourceRange;
		}
		
		VkImageView rawImageView;
		VkResult vulkanResult = vkCreateImageView(device, &imageViewCreateInfo, allocator, &rawImageView);
		if( !vulkanResult.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't create image view [vkCreateImageView]!");
		}
		return cast(TypesafeVkImageView)rawImageView;
	}
	
	final void destroyImageView(TypesafeVkImageView imageView, const(VkAllocationCallbacks*) allocator = null) {
		vkDestroyImageView(device, cast(VkImageView)imageView, allocator);
	}
	
	static struct CreateSamplerArguments {
		VkSamplerCreateFlags flags = 0; // default
		VkFilter                magFilter;
		VkFilter                minFilter;
		VkSamplerMipmapMode     mipmapMode;
		VkSamplerAddressMode    addressModeU;
		VkSamplerAddressMode    addressModeV;
		VkSamplerAddressMode    addressModeW;
		float                   mipLodBias = 0.0f; // default
		bool                anisotropyEnable;
		float                   maxAnisotropy;
		bool                compareEnable = false; // default
		VkCompareOp             compareOp = VK_COMPARE_OP_ALWAYS; // default
		float                   minLod = 0.0f; // default
		float                   maxLod = 0.0f; // default
		VkBorderColor           borderColor = VK_BORDER_COLOR_INT_OPAQUE_BLACK; // default
		bool                unnormalizedCoordinates = false; // default
	}

	final TypesafeVkSampler createSampler(CreateSamplerArguments arguments, const(VkAllocationCallbacks*) allocator = null) {
		VkSamplerCreateInfo samplerCreateInfo = VkSamplerCreateInfo.init;
		with(samplerCreateInfo) {
			sType = VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO;
			flags = arguments.flags;
			magFilter = arguments.magFilter;
			minFilter = arguments.minFilter;
			mipmapMode = arguments.mipmapMode;
			addressModeU = arguments.addressModeU;
			addressModeV = arguments.addressModeV;
			addressModeW = arguments.addressModeW;
			mipLodBias = arguments.mipLodBias;
			anisotropyEnable = vulkanBoolean(arguments.anisotropyEnable);
			maxAnisotropy = arguments.maxAnisotropy;
			compareEnable = vulkanBoolean(arguments.compareEnable);
			compareOp = arguments.compareOp;
			minLod = arguments.minLod;
			maxLod = arguments.maxLod;
			borderColor = arguments.borderColor;
			unnormalizedCoordinates = vulkanBoolean(arguments.unnormalizedCoordinates);
		}

		VkSampler rawSampler;
		VkResult vulkanResult = vkCreateSampler(device, &samplerCreateInfo, allocator, &rawSampler);
		if( !vulkanResult.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't create sampler [vkCreateSampler]!");
		}

		return cast(TypesafeVkSampler)rawSampler;
	}

	final void destroySampler(TypesafeVkSampler sampler, const(VkAllocationCallbacks*) allocator = null) {
		vkDestroySampler(device, cast(VkSampler)sampler, allocator);
	}


	static struct CreateFramebufferArguments {
		VkFramebufferCreateFlags flags = 0; // default
		TypesafeVkRenderPass renderPass;
		TypesafeVkImageView[] attachments;
		uint32_t width = 0;
		uint32_t height = 0;
		uint32_t layers = 1; // default
	}
	
	final TypesafeVkFramebuffer createFramebuffer(CreateFramebufferArguments arguments, const(VkAllocationCallbacks*) allocator = null) {
		VkImageView[] translatedAttachments;
		translatedAttachments.length = arguments.attachments.length;
		foreach( i; 0..arguments.attachments.length ) {
			translatedAttachments[i] = cast(VkImageView)arguments.attachments[i];
		}
		
		VkFramebufferCreateInfo framebufferCreateInfo = VkFramebufferCreateInfo.init;
		with(framebufferCreateInfo) {
			sType = VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO;
			flags = arguments.flags;
			renderPass = cast(VkRenderPass)arguments.renderPass;
			attachmentCount = cast(uint32_t)translatedAttachments.length;
			pAttachments = cast(immutable(ulong)*)translatedAttachments.ptr;
			width = arguments.width;
			height = arguments.height;
			layers = arguments.layers;
		}
		
		VkFramebuffer rawFramebuffer;
		VkResult vulkanResult = vkCreateFramebuffer(device, &framebufferCreateInfo, allocator, &rawFramebuffer);
		if( !vulkanResult.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't create a framebuffer [vkCreateFramebuffer]!");
		}
		return cast(TypesafeVkFramebuffer)rawFramebuffer;
	}
	
	final void destroyFramebuffer(TypesafeVkFramebuffer framebuffer, const(VkAllocationCallbacks*) allocator = null) {
		vkDestroyFramebuffer(device, cast(VkFramebuffer)framebuffer, allocator);
	}
	
	
	static struct CreateRenderPassArguments {
		VkRenderPassCreateFlags flags = 0;
		VkAttachmentDescription[] attachmentDescriptions;
		VkSubpassDescription[] subpassDescriptions;
		VkSubpassDependency[] subpassDependencies;
	}
	
	final TypesafeVkRenderPass createRenderPass(CreateRenderPassArguments arguments, const(VkAllocationCallbacks*) allocator = null) {
		VkRenderPassCreateInfo renderPassCreateInfo = VkRenderPassCreateInfo.init;
		with(renderPassCreateInfo) {
			sType = VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
			flags = arguments.flags;
			attachmentCount = cast(uint32_t)arguments.attachmentDescriptions.length;
			pAttachments = cast(immutable(VkAttachmentDescription)*)arguments.attachmentDescriptions.ptr;
			subpassCount = cast(uint32_t)arguments.subpassDescriptions.length;
			pSubpasses = cast(immutable(VkSubpassDescription)*)arguments.subpassDescriptions.ptr;
			dependencyCount = cast(uint32_t)arguments.subpassDependencies.length;
			pDependencies = cast(immutable(VkSubpassDependency)*)arguments.subpassDependencies.ptr;
		}
		
		VkRenderPass rawRenderpass;
		VkResult vulkanResult = vkCreateRenderPass(device, &renderPassCreateInfo, allocator, &rawRenderpass);
		if( !vulkanResult.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't create render pass [vkCreateRenderPass]!");
		}
		return cast(TypesafeVkRenderPass)rawRenderpass;
	}
	
	final void destroyRenderPass(TypesafeVkRenderPass renderPass, const(VkAllocationCallbacks*) allocator = null) {
		vkDestroyRenderPass(device, cast(VkRenderPass)renderPass, allocator);
	}
	
	static struct CreateGraphicsPipelineArguments {
		VkPipelineCreateFlags flags = 0;
		VkPipelineShaderStageCreateInfo[] stages;
		VkPipelineVertexInputStateCreateInfo vertexInputState;
		VkPipelineInputAssemblyStateCreateInfo inputAssemblyState;
		VkPipelineTessellationStateCreateInfo* tessellationState; // pointer because its optional
		VkPipelineViewportStateCreateInfo viewportState;
		VkPipelineRasterizationStateCreateInfo rasterizationState;
		VkPipelineMultisampleStateCreateInfo multisampleState;
		VkPipelineDepthStencilStateCreateInfo depthStencilState; // pointer because its optional
		VkPipelineColorBlendStateCreateInfo colorBlendState;
		VkPipelineDynamicStateCreateInfo* dynamicState; // pointer because its optional
		
		TypesafeVkPipelineLayout layout;
		TypesafeVkRenderPass renderPass;
		
		uint32_t subpass = 0; // default
		TypesafeVkPipeline basePipeline = cast(TypesafeVkPipeline)0;
		uint32_t basePipelineIndex = -1; // default
	}
	
	final TypesafeVkPipeline createGraphicsPipeline(CreateGraphicsPipelineArguments arguments, const(VkAllocationCallbacks*) allocator = null) {
		VkGraphicsPipelineCreateInfo pipelineCreateInfo = VkGraphicsPipelineCreateInfo.init;
		with(pipelineCreateInfo) {
			sType = VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO;
			flags = arguments.flags;
			stageCount = cast(uint32_t)arguments.stages.length;
			pStages = cast(immutable(VkPipelineShaderStageCreateInfo)*)arguments.stages.ptr;
			pVertexInputState = cast(immutable(VkPipelineVertexInputStateCreateInfo)*)&arguments.vertexInputState;
			pInputAssemblyState = cast(immutable(VkPipelineInputAssemblyStateCreateInfo)*)&arguments.inputAssemblyState;
			pTessellationState = cast(immutable(VkPipelineTessellationStateCreateInfo)*)arguments.tessellationState;
			pViewportState = cast(immutable(VkPipelineViewportStateCreateInfo)*)&arguments.viewportState;
			pRasterizationState = cast(immutable(VkPipelineRasterizationStateCreateInfo)*)&arguments.rasterizationState;
			pMultisampleState= cast(immutable(VkPipelineMultisampleStateCreateInfo)*)&arguments.multisampleState;
			pDepthStencilState = cast(immutable(VkPipelineDepthStencilStateCreateInfo)*)&arguments.depthStencilState;
			pColorBlendState = cast(immutable(VkPipelineColorBlendStateCreateInfo)*)&arguments.colorBlendState;
			pDynamicState = cast(immutable(VkPipelineDynamicStateCreateInfo)*)arguments.dynamicState;
			
			layout = cast(VkPipelineLayout)arguments.layout;
			renderPass = cast(VkRenderPass)arguments.renderPass;
			subpass = arguments.subpass;
			basePipelineHandle = cast(VkPipeline)arguments.basePipeline;
			basePipelineIndex = arguments.basePipelineIndex;
		}
		
		VkPipeline rawGraphicsPipeline;
		VkResult vulkanResult = vkCreateGraphicsPipelines(device, VK_NULL_HANDLE, 1, &pipelineCreateInfo, allocator, &rawGraphicsPipeline);
		if( !vulkanResult.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't create graphics pipeline [vkCreateGraphicsPipelines]");
		}
		return cast(TypesafeVkPipeline)rawGraphicsPipeline;
	}
	
	
	final void destroyPipeline(TypesafeVkPipeline pipeline, const(VkAllocationCallbacks*) allocator = null) {
		vkDestroyPipeline(device, cast(VkPipeline)pipeline, allocator);
	}
	
	final void destroyPipelineLayout(TypesafeVkPipelineLayout pipelineLayout, const(VkAllocationCallbacks*) allocator = null) {
		vkDestroyPipelineLayout(device, cast(VkPipelineLayout)pipelineLayout, allocator);
	}
	
	final void* map(TypesafeVkDeviceMemory memory, VkDeviceSize offset, VkDeviceSize size, VkMemoryMapFlags flags) {
		void *mapResult;
		VkResult vulkanResult = vkMapMemory(device, cast(VkDeviceMemory)memory, offset, size, flags, &mapResult);
		if( !vulkanResult.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't map memory! [vkMapMemory]");
		}
		
		return mapResult;
	}
	

	final TypesafeVkDescriptorSetLayout createDescriptorSetLayout(VkDescriptorSetLayoutBinding[] bindings, const(VkAllocationCallbacks*) allocator = null) {
		VkDescriptorSetLayoutCreateInfo layoutInfo = VkDescriptorSetLayoutCreateInfo.init;
		layoutInfo.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
		layoutInfo.bindingCount = cast(uint32_t)bindings.length;
		layoutInfo.pBindings = cast(immutable(VkDescriptorSetLayoutBinding)*)bindings.ptr;

		VkDescriptorSetLayout rawDescriptorSetLayout;
		VkResult vulkanResult = vkCreateDescriptorSetLayout(device, &layoutInfo, allocator, &rawDescriptorSetLayout);
		if( !vulkanResult.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't create descriptor set layout [vkCreateDescriptorSetLayout]");
		}
		return cast(TypesafeVkDescriptorSetLayout)rawDescriptorSetLayout;
	}

	final void destroyDescriptorSetLayout(TypesafeVkDescriptorSetLayout descriptorSetLayout, const VkAllocationCallbacks* allocator = null) {
		vkDestroyDescriptorSetLayout(device, cast(VkDescriptorSetLayout)descriptorSetLayout, allocator);
	}

	static struct CreateDescriptorPoolArguments {
		VkDescriptorPoolCreateFlags flags;
		uint32_t maxSets;
		VkDescriptorPoolSize[] poolSizes;
	}


	final TypesafeVkDescriptorPool createDescriptorPool(CreateDescriptorPoolArguments arguments, const(VkAllocationCallbacks*) allocator = null) {
		VkDescriptorPoolCreateInfo createInfo = VkDescriptorPoolCreateInfo.init;
		with(createInfo) {
			sType = VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
			flags = arguments.flags;
			maxSets = arguments.maxSets;
			poolSizeCount = cast(uint32_t)arguments.poolSizes.length;
			pPoolSizes = cast(immutable(VkDescriptorPoolSize)*)arguments.poolSizes.ptr;
		}

		VkDescriptorPool rawDescriptorPool;
		VkResult vulkanResult = vkCreateDescriptorPool(device, &createInfo, allocator, &rawDescriptorPool);
		if( !vulkanResult.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't create descriptor pool [vkCreateDescriptorPool]");
		}
		return cast(TypesafeVkDescriptorPool)rawDescriptorPool;
	}

	final void destroyDescriptorPool(TypesafeVkDescriptorPool descriptorPool, const(VkAllocationCallbacks*) allocator = null) {
		vkDestroyDescriptorPool(device, cast(VkDescriptorPool)descriptorPool, allocator);
	}


	final TypesafeVkDescriptorSet[] allocateDescriptorSets(TypesafeVkDescriptorSetLayout[] layouts, TypesafeVkDescriptorPool descriptorPool) {
		// NOTE< actually we dont have to translate the whole resources all the time but it doesnt eat any performance, because we dont call this too often, so its fine >


		VkDescriptorSetLayout[] translatedLayouts;
		translatedLayouts.length = layouts.length;
		foreach( i, iterationLayout; layouts) {
			translatedLayouts[i] = cast(VkDescriptorSetLayout)iterationLayout;
		}

		VkDescriptorSetAllocateInfo allocInfo;
		allocInfo.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
		allocInfo.descriptorPool = cast(VkDescriptorPool)descriptorPool;
		allocInfo.descriptorSetCount = cast(uint32_t)translatedLayouts.length;
		allocInfo.pSetLayouts = cast(immutable(VkDescriptorSetLayout)*)translatedLayouts.ptr;

		VkDescriptorSet[] rawDescriptorSets;
		rawDescriptorSets.length = layouts.length;
		VkResult vulkanResult;
		if( !(vulkanResult = vkAllocateDescriptorSets(device, &allocInfo, rawDescriptorSets.ptr)).vulkanSuccess ) {
    		throw new EngineException(true, true, "Couldn't create descriptor set [vkAllocateDescriptorSets]");
		}

		// translate
		TypesafeVkDescriptorSet[] result;
		result.length = layouts.length;
		foreach( i, iterationDescriptorSet; rawDescriptorSets ) {
			result[i] = cast(TypesafeVkDescriptorSet)iterationDescriptorSet;
		}

		return result;
	}

	final void destroyDescriptorSets(TypesafeVkDescriptorPool descriptorPool, TypesafeVkDescriptorSet[] descriptorSets) {
		// translate
		VkDescriptorSet[] translatedDescriptorSets;
		translatedDescriptorSets.length = descriptorSets.length;
		foreach( i, iterationDescriptorSet; descriptorSets ) {
			translatedDescriptorSets[i] = cast(VkDescriptorSet)iterationDescriptorSet;
		}

		vkFreeDescriptorSets(device, cast(VkDescriptorPool)descriptorPool, cast(uint32_t) translatedDescriptorSets.length, cast(const VkDescriptorSet*)translatedDescriptorSets.ptr);
	}

	final void updateDescriptorSets(VkWriteDescriptorSet[] descriptorWrites, VkCopyDescriptorSet[] descriptorCopies) {
		vkUpdateDescriptorSets(device, cast(uint32_t)descriptorWrites.length, descriptorWrites.ptr, cast(uint32_t)descriptorCopies.length, descriptorCopies.ptr);
	}


	final void unmap(TypesafeVkDeviceMemory memory) {
		vkUnmapMemory(device, cast(VkDeviceMemory)memory);
	}

	final void waitIdle() {
		vkDeviceWaitIdle(device);
	}
	
	final @property device() {
		return protectedDevice;
	}
	
	protected VkDevice protectedDevice;
}