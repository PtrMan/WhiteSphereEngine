module graphics.vulkan.GraphicsVulkan;

import std.stdint;

import Exceptions;
import api.vulkan.Vulkan;
import graphics.vulkan.VulkanTypesAndEnums;
import graphics.vulkan.VulkanContext;
import graphics.vulkan.VulkanMemoryAllocator;
import graphics.vulkan.abstraction.VulkanDeviceFacade;
import graphics.vulkan.abstraction.VulkanDevicelessFacade : DevicelessFacade = VulkanDevicelessFacade;
import vulkan.VulkanHelpers;
import vulkan.VulkanTools;
import common.IDisposable;
import helpers.VariableValidator;

import common.ResourceDag;
import graphics.vulkan.resourceDag.VulkanResourceDagResource;

// some parts are from
// https://av.dfki.de/~jhenriques/development.html#tutorial_011
// (really copyleft as stated on the site)

class GraphicsVulkan {
	// TODO< refactor to outside into the right class >
	// vulkan resource (for example VkImage) with the offset of the bind, size, alignment, memory hint
	static class VulkanResourceWithMemoryDecoration(Datatype) {
		static struct DerivedInformation {
			uint32_t typeIndex; // type index of the resource as reported by vkGet*MemoryRequirements
		
			VulkanMemoryAllocator.OffsetType offset; // allocated offset in the heap
			VulkanMemoryAllocator.HintAllocatedSizeType hintAllocatedSize; // real size allocated by the allocator, for an hint of the allocator
			                                                               // the nullable indicates to the allocator which tpye of alloction it was actually
		}
		
		VariableValidator!Datatype resource;
		VariableValidator!DerivedInformation derivedInformation;
	}
	
	
	public final this(ResourceDag resourceDag) {
		this.resourceDag = resourceDag;
	}
	
	public void setVulkanContext(VulkanContext vulkanContext) {
		this.vulkanContext = vulkanContext;
	}
	
	protected ResourceDag resourceDag;
	protected VulkanContext vulkanContext;
	
	public final void initialisationEntry() {
		vulkanSetupRendering();
	}
	
	protected final void vulkanSetupRendering() {
		
		ResourceDag.ResourceNode[] framebufferImageViewsResourceNodes;
		ResourceDag.ResourceNode[] framebufferFramebufferResourceNodes;
		ResourceDag.ResourceNode renderPassResourceNode;
		ResourceDag.ResourceNode pipelineResourceNode;
		VulkanResourceWithMemoryDecoration!TypesafeVkImage framebufferImageResource = new VulkanResourceWithMemoryDecoration!TypesafeVkImage;
		
		TypesafeVkCommandBuffer[] commandBuffersForCopy; // no need to manage this with the resource dag, because we need it just once
		TypesafeVkCommandBuffer commandBufferForRendering;
		
		TypesafeVkCommandBuffer setupCommandBuffer; // used for setup of images and such
		TypesafeVkFence setupCommandBufferFence; // fence to secure setupCommandBuffer
		
		// semaphores for chaining
		TypesafeVkSemaphore chainSemaphore2;
		
		
		// TODO< initialize this somewhere outside and only once >
		vkDevFacade = new VulkanDeviceFacade(vulkanContext.chosenDevice.logicalDevice);
		
		VulkanResourceWithMemoryDecoration!TypesafeVkBuffer vboPositionBufferResource = new VulkanResourceWithMemoryDecoration!TypesafeVkBuffer;
		
		
		// code taken from https://software.intel.com/en-us/articles/api-without-secrets-introduction-to-vulkan-part-3
		// at first commit time
		// license is intel license

		






		void createRenderpass() {
			VkResult vulkanResult;
			
			VkAttachmentDescription attachmentDescriptions[] = [
				{
					0,                                   // VkAttachmentDescriptionFlags   flags
					// TODO< pass this as argument or something, we get this from the best format for the framebuffer, so we have to create the ramebuffer first and drag out the format >
					VK_FORMAT_A2B10G10R10_UINT_PACK32,               // VkFormat                       format
					VK_SAMPLE_COUNT_1_BIT,               // VkSampleCountFlagBits          samples
					VK_ATTACHMENT_LOAD_OP_CLEAR,         // VkAttachmentLoadOp             loadOp
					VK_ATTACHMENT_STORE_OP_STORE,        // VkAttachmentStoreOp            storeOp
					VK_ATTACHMENT_LOAD_OP_DONT_CARE,     // VkAttachmentLoadOp             stencilLoadOp
					VK_ATTACHMENT_STORE_OP_DONT_CARE,    // VkAttachmentStoreOp            stencilStoreOp
					
					VK_IMAGE_LAYOUT_UNDEFINED, // we overwrite it so it shouldn't matter      //VK_IMAGE_LAYOUT_PRESENT_SRC_KHR,     // VkImageLayout                  initialLayout;
					
					// TODO< pass this as argument or something, we set this to the same layout as the framebuffer target is now
					VK_IMAGE_LAYOUT_GENERAL//VK_IMAGE_LAYOUT_PRESENT_SRC_KHR      // VkImageLayout                  finalLayout
				}
			];


			// subpass description

			VkAttachmentReference colorAttachmentReferences[] = [
				{
					0,                                          // uint32_t                       attachment
					VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL    // VkImageLayout                  layout
				}
			];
			 
			VkSubpassDescription subpassDescriptions[] = [
				{
					0,                                          // VkSubpassDescriptionFlags      flags
					VK_PIPELINE_BIND_POINT_GRAPHICS,            // VkPipelineBindPoint            pipelineBindPoint
					0,                                          // uint32_t                       inputAttachmentCount
					null,                                    // const VkAttachmentReference   *pInputAttachments
					1,                                          // uint32_t                       colorAttachmentCount
					cast(immutable(VkAttachmentReference)*)colorAttachmentReferences.ptr,                // const VkAttachmentReference   *pColorAttachments
					null,                                    // const VkAttachmentReference   *pResolveAttachments
					null,                                    // const VkAttachmentReference   *pDepthStencilAttachment
					0,                                          // uint32_t                       preserveAttachmentCount
					null                                     // const uint32_t*                pPreserveAttachments
				}
			];
			
			
			const(VkAllocationCallbacks*) allocator = null;
			
			VulkanDeviceFacade.CreateRenderPassArguments createRenderPassArguments = VulkanDeviceFacade.CreateRenderPassArguments.init;
			createRenderPassArguments.flags = 0;
			createRenderPassArguments.attachmentDescriptions = attachmentDescriptions;
			createRenderPassArguments.subpassDescriptions = subpassDescriptions;
			createRenderPassArguments.subpassDependencies = [];
			TypesafeVkRenderPass renderPass = vkDevFacade.createRenderPass(createRenderPassArguments, allocator);
			
			VulkanResourceDagResource!TypesafeVkRenderPass renderPassDagResource = new VulkanResourceDagResource!TypesafeVkRenderPass(vkDevFacade, renderPass, allocator, &disposeRenderPass);
			renderPassResourceNode = resourceDag.createNode(renderPassDagResource);
			
			// we hold this because else the resourceDag would dispose them
			renderPassResourceNode.incrementExternalReferenceCounter();
		}
		
		
		void createFramebuffer() {
			VkResult vulkanResult;
			
			VkExtent3D framebufferImageExtent = {300, 300, 1};
			
			
			VkFormatFeatureFlagBits requiredFramebufferImageFormatFeatures =
			  VK_FORMAT_FEATURE_STORAGE_IMAGE_BIT | // must support an image view
			  VK_FORMAT_FEATURE_COLOR_ATTACHMENT_BIT; // must support an attachment (or a destination) for the framebuffer
			VkImageUsageFlagBits usageFlags =
				VK_IMAGE_USAGE_TRANSFER_SRC_BIT | //
				VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT;
			
			// search best format
			VkFormat framebufferImageFormat = vulkanHelperFindBestFormatTryThrows(vulkanContext.chosenDevice.physicalDevice, [VK_FORMAT_A2B10G10R10_UINT_PACK32], requiredFramebufferImageFormatFeatures, "Framebuffer");
			
			
			
			uint32_t graphicsQueueFamilyIndex = vulkanContext.queueManager.getDeviceQueueInfoByName("graphics").queueFamilyIndex;
			uint32_t presentQueueFamilyIndex = vulkanContext.queueManager.getDeviceQueueInfoByName("present").queueFamilyIndex;
			
			VkQueue graphicsQueue = vulkanContext.queueManager.getQueueByName("graphics");
			
			
			
			{
				// for image creation we actually have to check if the extent is valid (should always be the case)
				// TODO< vkGetPhysicalDeviceImageFormatProperties >
				
				// create image (as a "render target")
				
				
				VkImageCreateInfo imageCreateInfo;
				initImageCreateInfo(&imageCreateInfo);
				with(imageCreateInfo) {
					flags = 0; // mydefault
					imageType = VK_IMAGE_TYPE_2D; // mydefault
					format = framebufferImageFormat;
					extent = framebufferImageExtent;
					mipLevels = 1; // mydefault
					arrayLayers = 1; // mydefault
					samples = VK_SAMPLE_COUNT_1_BIT; // mydefault
					tiling = VK_IMAGE_TILING_OPTIMAL; // mydefault, is fine
					usage = usageFlags;
					sharingMode = 0; // mydefault
					queueFamilyIndexCount = 2;
					pQueueFamilyIndices = cast(immutable(uint32_t)*)[graphicsQueueFamilyIndex, presentQueueFamilyIndex].ptr;
					initialLayout =  VK_IMAGE_LAYOUT_UNDEFINED; // mydefault, should be hardcoded this way
				}
				
				// TODO< refactor this into own method >
				{ // scope the variable imageResult
					VkImage imageResult;
					vulkanResult = vkCreateImage(
						vulkanContext.chosenDevice.logicalDevice,
						&imageCreateInfo,
						null,
						&imageResult
					);
					framebufferImageResource.resource = cast(TypesafeVkImage)imageResult;
					if( !vulkanSuccess(vulkanResult) ) {
						throw new EngineException(true, true, "Couldn't create image for framebuffer [vkCreateImage]!");
					}
					
				}
				
				/////
				// allocate and bind memory
				resourceQueryAllocateBind(framebufferImageResource, VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT, "image");
				
				////////////////////
				// transition layout
				
				{ // scope for beginCommandBuffer/end
					VkCommandBufferBeginInfo beginInfo = {};
					beginInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
					beginInfo.flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;
					vkBeginCommandBuffer(cast(VkCommandBuffer)setupCommandBuffer, &beginInfo);
					scope(success) vkEndCommandBuffer(cast(VkCommandBuffer)setupCommandBuffer);
					
					setImageLayout(
					    cast(VkCommandBuffer)setupCommandBuffer, // cmdBuffer
					    cast(VkImage)framebufferImageResource.resource.value, // image
					    VK_IMAGE_ASPECT_COLOR_BIT, // aspectMask
					    VK_IMAGE_LAYOUT_UNDEFINED, // oldImageLayout
					    VK_IMAGE_LAYOUT_GENERAL // newImageLayout
					);
				}
				
				
				VkPipelineStageFlags[] waitStageMask = [VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT];
				VkSubmitInfo submitInfo = {};
				with(submitInfo) {
					sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
					waitSemaphoreCount = 0;
					pWaitSemaphores = null;
					pWaitDstStageMask = cast(immutable(uint)*)waitStageMask.ptr;
					commandBufferCount = 1;
					pCommandBuffers = cast(immutable(VkCommandBuffer)*)&setupCommandBuffer;
					signalSemaphoreCount = 0;
					pSignalSemaphores = null;
				}
				vulkanResult = vkQueueSubmit(graphicsQueue, 1, &submitInfo, cast(VkFence)setupCommandBufferFence);
				if( !vulkanSuccess(vulkanResult) ) {
					throw new EngineException(true, true, "Queue submit failed [vkQueueSubmit]!");
				}
				
				vkDevFacade.fenceWaitAndReset(setupCommandBufferFence);
				
				vulkanResult = vkResetCommandBuffer(cast(VkCommandBuffer)setupCommandBuffer, 0);
				if( !vulkanSuccess(vulkanResult) ) {
					throw new EngineException(true, true, "Reset command buffer failed! [vkResetCommandBuffer]");
				}
				
			}
			
			
			// create image views
			
			foreach( i; 0..vulkanContext.swapChain.swapchainImages.length ) {
				ResourceDag.ResourceNode imageViewResourceNode;
				{ // brace to scope the allocator
					const(VkAllocationCallbacks*) allocator = null;
					
					VulkanDeviceFacade.CreateImageViewArguments createImageViewArguments = VulkanDeviceFacade.CreateImageViewArguments.make();
					with(createImageViewArguments) {
						flags = 0;
						image = framebufferImageResource.resource.value;
						viewType = VK_IMAGE_VIEW_TYPE_2D;
						format = framebufferImageFormat;
					}
					TypesafeVkImageView createdImageView = vkDevFacade.createImageView(createImageViewArguments, allocator);
						
					VulkanResourceDagResource!TypesafeVkImageView imageViewDagResource = new VulkanResourceDagResource!TypesafeVkImageView(vkDevFacade, createdImageView, allocator, &disposeImageView);
					imageViewResourceNode = resourceDag.createNode(imageViewDagResource);
					
					// we hold this because else the resourceDag would dispose them
					imageViewResourceNode.incrementExternalReferenceCounter();
					
					framebufferImageViewsResourceNodes ~= imageViewResourceNode;
				}
				
				
				
				TypesafeVkImageView imageViewForFramebuffer = (cast(VulkanResourceDagResource!TypesafeVkImageView)imageViewResourceNode.resource).resource;
				
				VulkanDeviceFacade.CreateFramebufferArguments createFramebufferArguments = VulkanDeviceFacade.CreateFramebufferArguments.init;
				with(createFramebufferArguments) {
					flags = 0;
					renderPass = (cast(VulkanResourceDagResource!TypesafeVkRenderPass)renderPassResourceNode.resource).resource;
					attachments = [imageViewForFramebuffer];
					width = 300;
					height = 300;
				}
				
				{ // brace to scope the allocator
					const(VkAllocationCallbacks*) allocator = null;
					TypesafeVkFramebuffer createdFramebuffer = vkDevFacade.createFramebuffer(createFramebufferArguments, allocator);
					
					VulkanResourceDagResource!TypesafeVkFramebuffer framebufferDagResource = new VulkanResourceDagResource!TypesafeVkFramebuffer(vkDevFacade, createdFramebuffer, allocator, &disposeFramebuffer);
					ResourceDag.ResourceNode framebufferResourceNode = resourceDag.createNode(framebufferDagResource);
					imageViewResourceNode.addChild(framebufferResourceNode); // link it so if the imageView gets disposed the framebuffer gets disposed too
					framebufferResourceNode.addChild(renderPassResourceNode); // link it because it depends on the renderpass
					
					framebufferFramebufferResourceNodes ~= framebufferResourceNode;
				}
				
			
			}
		}
		
		void createPipeline() {
			VkResult vulkanResult;
			
			VkPipelineLayout createPipelineLayout() {
				VkPipelineLayoutCreateInfo layout_create_info = {
					VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,  // VkStructureType                sType
					null,                                        // const void                    *pNext
					0,                                              // VkPipelineLayoutCreateFlags    flags
					0,                                              // uint32_t                       setLayoutCount
					null,                                        // const VkDescriptorSetLayout   *pSetLayouts
					0,                                              // uint32_t                       pushConstantRangeCount
					null                                         // const VkPushConstantRange     *pPushConstantRanges
				};
	
				VkPipelineLayout pipelineLayout;
				vulkanResult = vkCreatePipelineLayout(vulkanContext.chosenDevice.logicalDevice, &layout_create_info, null, &pipelineLayout);
				if( !vulkanSuccess(vulkanResult) ) {
					throw new EngineException(true, true, "Couldn't create pipeline layout! [vkCreatePipelineLayout]");
				}
				
				return pipelineLayout;
			}
	
			
			// prepare description of stages
			
			VkShaderModule vertexShaderModule, fragmentShaderModule;
			IDisposable vertexShaderMemory = loadShader("TestHardcoded.vert.spv", vulkanContext.chosenDevice.logicalDevice, VK_SHADER_STAGE_VERTEX_BIT, &vertexShaderModule);
			scope(exit) vertexShaderMemory.dispose();
			scope(exit) vkDestroyShaderModule(vulkanContext.chosenDevice.logicalDevice, vertexShaderModule, null);
			IDisposable fragmentShaderMemory = loadShader("Simple1.frag.spv", vulkanContext.chosenDevice.logicalDevice, VK_SHADER_STAGE_FRAGMENT_BIT, &fragmentShaderModule);
			scope(exit) fragmentShaderMemory.dispose();
			scope(exit) vkDestroyShaderModule(vulkanContext.chosenDevice.logicalDevice, fragmentShaderModule, null);
			
			VkPipelineShaderStageCreateInfo[] shader_stage_create_infos = [
				// Vertex shader
				{
					VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,        // VkStructureType                                sType
					null,                                                    // const void                                    *pNext
					0,                                                          // VkPipelineShaderStageCreateFlags               flags
					VK_SHADER_STAGE_VERTEX_BIT,                                 // VkShaderStageFlagBits                          stage
					vertexShaderModule,                                 // VkShaderModule                                 module
					"main",                                                     // const char                                    *pName
					null                                                     // const VkSpecializationInfo                    *pSpecializationInfo
				},
				
				// Fragment shader
				{
					VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,        // VkStructureType                                sType
					null,                                                    // const void                                    *pNext
					0,                                                          // VkPipelineShaderStageCreateFlags               flags
					VK_SHADER_STAGE_FRAGMENT_BIT,                               // VkShaderStageFlagBits                          stage
					fragmentShaderModule,                               // VkShaderModule                                 module
					"main",                                                     // const char                                    *pName
					null                                                     // const VkSpecializationInfo                    *pSpecializationInfo
				}
			];



			// prepare description of vertex input

			VkPipelineVertexInputStateCreateInfo vertex_input_state_create_info = {
				VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO,    // VkStructureType                                sType
				null,                                                      // const void                                    *pNext
				0,                                                            // VkPipelineVertexInputStateCreateFlags          flags;
				0,                                                            // uint32_t                                       vertexBindingDescriptionCount
				null,                                                      // const VkVertexInputBindingDescription         *pVertexBindingDescriptions
				0,                                                            // uint32_t                                       vertexAttributeDescriptionCount
				null                                                       // const VkVertexInputAttributeDescription       *pVertexAttributeDescriptions
			};



			// prepare description of input assembly
			VkPipelineInputAssemblyStateCreateInfo input_assembly_state_create_info = {
				VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO,  // VkStructureType                                sType
				null,                                                      // const void                                    *pNext
				0,                                                            // VkPipelineInputAssemblyStateCreateFlags        flags
				VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST,                          // VkPrimitiveTopology                            topology
				VK_FALSE                                                      // VkBool32                                       primitiveRestartEnable
			};



			// prepare viewport description
			VkViewport viewport = {
				0.0f,                                                         // float                                          x
				0.0f,                                                         // float                                          y
				300.0f,                                                       // float                                          width
				300.0f,                                                       // float                                          height
				0.0f,                                                         // float                                          minDepth
				1.0f                                                          // float                                          maxDepth
			};

			VkRect2D scissor = {
				{                                                             // VkOffset2D                                     offset
					0,                                                            // int32_t                                        x
					0                                                             // int32_t                                        y
				},
				{                                                             // VkExtent2D                                     extent
					300,                                                          // int32_t                                        width
					300                                                           // int32_t                                        height
				}
			};
			
			
			VkPipelineViewportStateCreateInfo viewport_state_create_info = {
				VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO,        // VkStructureType                                sType
				null,                                                      // const void                                    *pNext
				0,                                                            // VkPipelineViewportStateCreateFlags             flags
				1,                                                            // uint32_t                                       viewportCount
				cast(immutable(VkViewport)*)&viewport,                                                    // const VkViewport                              *pViewports
				1,                                                            // uint32_t                                       scissorCount
				cast(immutable(VkRect2D)*)&scissor                                                      // const VkRect2D                                *pScissors
			};
			
			
			// prepare rasterisatio state description
			VkPipelineRasterizationStateCreateInfo rasterization_state_create_info = {
				VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO,   // VkStructureType                                sType
				null,                                                      // const void                                    *pNext
				0,                                                            // VkPipelineRasterizationStateCreateFlags        flags
				VK_FALSE,                                                     // VkBool32                                       depthClampEnable
				VK_FALSE,                                                     // VkBool32                                       rasterizerDiscardEnable
				VK_POLYGON_MODE_FILL,                                         // VkPolygonMode                                  polygonMode
				VK_CULL_MODE_BACK_BIT,                                        // VkCullModeFlags                                cullMode
				VK_FRONT_FACE_COUNTER_CLOCKWISE,                              // VkFrontFace                                    frontFace
				VK_FALSE,                                                     // VkBool32                                       depthBiasEnable
				0.0f,                                                         // float                                          depthBiasConstantFactor
				0.0f,                                                         // float                                          depthBiasClamp
				0.0f,                                                         // float                                          depthBiasSlopeFactor
				1.0f                                                          // float                                          lineWidth
			};
			
			VkPipelineMultisampleStateCreateInfo multisampleStateCreateInfo = VkPipelineMultisampleStateCreateInfo.init;
			with(multisampleStateCreateInfo) {
				sType = VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO;
				flags = 0;
				rasterizationSamples = VK_SAMPLE_COUNT_1_BIT;
				sampleShadingEnable = VK_FALSE;
				minSampleShading = 1.0f;
				alphaToCoverageEnable = alphaToOneEnable = VK_FALSE;
			}
			
			// setting blending state description
			VkPipelineColorBlendAttachmentState color_blend_attachment_state = {
				VK_FALSE,                                                     // VkBool32                                       blendEnable
				VK_BLEND_FACTOR_ONE,                                          // VkBlendFactor                                  srcColorBlendFactor
				VK_BLEND_FACTOR_ZERO,                                         // VkBlendFactor                                  dstColorBlendFactor
				VK_BLEND_OP_ADD,                                              // VkBlendOp                                      colorBlendOp
				VK_BLEND_FACTOR_ONE,                                          // VkBlendFactor                                  srcAlphaBlendFactor
				VK_BLEND_FACTOR_ZERO,                                         // VkBlendFactor                                  dstAlphaBlendFactor
				VK_BLEND_OP_ADD,                                              // VkBlendOp                                      alphaBlendOp
				VK_COLOR_COMPONENT_R_BIT | VK_COLOR_COMPONENT_G_BIT |         // VkColorComponentFlags                          colorWriteMask
				VK_COLOR_COMPONENT_B_BIT | VK_COLOR_COMPONENT_A_BIT
			};
			
			
			VkPipelineColorBlendStateCreateInfo color_blend_state_create_info = {
				VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,     // VkStructureType                                sType
				null,                                                      // const void                                    *pNext
				0,                                                            // VkPipelineColorBlendStateCreateFlags           flags
				VK_FALSE,                                                     // VkBool32                                       logicOpEnable
				VK_LOGIC_OP_COPY,                                             // VkLogicOp                                      logicOp
				1,                                                            // uint32_t                                       attachmentCount
				cast(immutable(VkPipelineColorBlendAttachmentState)*)&color_blend_attachment_state,                                // const VkPipelineColorBlendAttachmentState     *pAttachments
				[ 0.0f, 0.0f, 0.0f, 0.0f ]                                    // float                                          blendConstants[4]
			};


			// create graphics pipeline
			TypesafeVkPipelineLayout pipelineLayout = createPipelineLayout();
			scope(exit) {
				vkDevFacade.destroyPipelineLayout(pipelineLayout);
			}
			
			TypesafeVkRenderPass renderPass = (cast(VulkanResourceDagResource!TypesafeVkRenderPass)renderPassResourceNode.resource).resource;
			
			
			VulkanDeviceFacade.CreateGraphicsPipelineArguments createGraphicsPipelineArguments = VulkanDeviceFacade.CreateGraphicsPipelineArguments.init;
			with(createGraphicsPipelineArguments) {
				flags = 0;
				stages = shader_stage_create_infos;
				vertexInputState = vertex_input_state_create_info;
				inputAssemblyState = input_assembly_state_create_info;
				tessellationState = null;
				viewportState = viewport_state_create_info;
				rasterizationState = rasterization_state_create_info;
				multisampleState = multisampleStateCreateInfo;
				depthStencilState = null;
				colorBlendState = color_blend_state_create_info;
				dynamicState = null;
				
				layout = pipelineLayout;
				
				// all others are default
			}
			createGraphicsPipelineArguments.renderPass = renderPass;
			
			
			const(VkAllocationCallbacks*) allocator = null;
			TypesafeVkPipeline createdGraphicsPipeline = vkDevFacade.createGraphicsPipeline(createGraphicsPipelineArguments, allocator);
			
			VulkanResourceDagResource!TypesafeVkPipeline pipelineDagResource = new VulkanResourceDagResource!TypesafeVkPipeline(vkDevFacade, createdGraphicsPipeline, allocator, &disposePipeline);
			pipelineResourceNode = resourceDag.createNode(pipelineDagResource);
			
			// we hold this because else the resourceDag would dispose them
			pipelineResourceNode.incrementExternalReferenceCounter();
		}
		
		// function just for the example code, eeds to get refactored later
		void recordingCommandBuffers() {
			VkResult vulkanResult;
			
			VkCommandBufferBeginInfo graphicsCommandBufferBeginInfo = VkCommandBufferBeginInfo.init;
			with(graphicsCommandBufferBeginInfo) {
				sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
				flags = VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT;
				pInheritanceInfo = null;
			};

			VkImageSubresourceRange imageSubresourceRange;
			with(imageSubresourceRange) {
				aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
				baseMipLevel = 0;
				levelCount = 1;
				baseArrayLayer = 0;
				layerCount = 1;
			};

			VkClearValue clear_value;
			clear_value.color.float32 = [ 1.0f, 0.8f, 0.4f, 0.0f ];
			
			uint32_t graphicsQueueFamilyIndex = vulkanContext.queueManager.getDeviceQueueInfoByName("graphics").queueFamilyIndex;
			uint32_t presentQueueFamilyIndex = vulkanContext.queueManager.getDeviceQueueInfoByName("present").queueFamilyIndex;
			VkQueue graphicsQueue = vulkanContext.queueManager.getQueueByName("graphics");
			VkQueue presentQueue = vulkanContext.queueManager.getQueueByName("present");;
			
			TypesafeVkRenderPass renderPass = (cast(VulkanResourceDagResource!TypesafeVkRenderPass)renderPassResourceNode.resource).resource;
			TypesafeVkPipeline graphicsPipeline = (cast(VulkanResourceDagResource!TypesafeVkPipeline)pipelineResourceNode.resource).resource;

			foreach( i; 0..commandBuffersForCopy.length ) {
				vkBeginCommandBuffer(cast(VkCommandBuffer)commandBuffersForCopy[i], &graphicsCommandBufferBeginInfo);
				
				/* uncommented because its impossible to test with this hardware of the developer ;)
				if( presentQueue != graphicsQueue ) {
					VkImageMemoryBarrier barrier_from_present_to_draw = {
						VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,     // VkStructureType                sType
						null,                                    // const void                    *pNext
						VK_ACCESS_MEMORY_READ_BIT,                  // VkAccessFlags                  srcAccessMask
						VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT,       // VkAccessFlags                  dstAccessMask
						VK_IMAGE_LAYOUT_PRESENT_SRC_KHR,            // VkImageLayout                  oldLayout
						VK_IMAGE_LAYOUT_PRESENT_SRC_KHR,            // VkImageLayout                  newLayout
						presentQueueFamilyIndex,              // uint32_t                       srcQueueFamilyIndex
						graphicsQueueFamilyIndex,             // uint32_t                       dstQueueFamilyIndex
						swap_chain_images[i],                       // VkImage                        image
						image_subresource_range                     // VkImageSubresourceRange        subresourceRange
					};
					
					vkCmdPipelineBarrier(commandBuffersForCopy[i], VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT, VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT, 0, 0, null, 0, null, 1, &barrier_from_present_to_draw);
				}
				*/
				
				
				 // NOTE< not 100% sure if this is right for multiple queues, test on hardware where the queues are different ones > 
				VkImageMemoryBarrier barrierFromPresentToClear = VkImageMemoryBarrier.init;
				with (barrierFromPresentToClear) {
					sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
					srcAccessMask = VK_ACCESS_MEMORY_READ_BIT;
					dstAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
					oldLayout = VK_IMAGE_LAYOUT_UNDEFINED;
					newLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
					srcQueueFamilyIndex = graphicsQueueFamilyIndex;
					dstQueueFamilyIndex = presentQueueFamilyIndex;
					image = vulkanContext.swapChain.swapchainImages[i];
					subresourceRange = imageSubresourceRange;
				}
				
				VkImageMemoryBarrier barrierFromClearToPresent = VkImageMemoryBarrier.init;
				with (barrierFromClearToPresent) {
					sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
					srcAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
					dstAccessMask = VK_ACCESS_MEMORY_READ_BIT;
					oldLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
					newLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;
					srcQueueFamilyIndex = presentQueueFamilyIndex;
					dstQueueFamilyIndex = graphicsQueueFamilyIndex;
					image = vulkanContext.swapChain.swapchainImages[i];
					subresourceRange = imageSubresourceRange;	
				}
				
				VkImageSubresourceRange imageSubresourceRangeForCopy = {VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1 };
				
				VkClearColorValue clear_color;
				clear_color.float32 = [1.0f, 0.8f, 0.4f, 0.0f];
				
				
				vkCmdPipelineBarrier(cast(VkCommandBuffer)commandBuffersForCopy[i], VK_PIPELINE_STAGE_TRANSFER_BIT, VK_PIPELINE_STAGE_TRANSFER_BIT, 0, 0, null, 0, null, 1, &barrierFromPresentToClear);
				vkCmdClearColorImage(cast(VkCommandBuffer)commandBuffersForCopy[i], vulkanContext.swapChain.swapchainImages[i], VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, &clear_color, 1, &imageSubresourceRangeForCopy);
				
				VkImageSubresourceLayers imageSubresourceLayersForCopy;
				with(imageSubresourceLayersForCopy) {
					aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
					mipLevel = 0;
					baseArrayLayer = 0;
					layerCount = 1;
				}
				
				VkImageCopy[1] imageCopyRegions;
				with(imageCopyRegions[0]) {
					srcSubresource = imageSubresourceLayersForCopy;
					with(srcOffset) {x=y=z=0;}
					dstSubresource = imageSubresourceLayersForCopy;
					with(dstOffset) {x=y=z=0;}
					with(extent) {width=300,height=300,depth=0;};
				}
				
				
				
				vkCmdCopyImage(
					cast(VkCommandBuffer)commandBuffersForCopy[i], // commandBuffer
					cast(VkImage)framebufferImageResource.resource.value, // srcImage
					VK_IMAGE_LAYOUT_GENERAL, // srcImageLayout
					vulkanContext.swapChain.swapchainImages[i], // dstImage
					VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, // dstImageLayout
					1, // regionCount
					imageCopyRegions.ptr// pRegions
				);
				
				vkCmdPipelineBarrier(cast(VkCommandBuffer)commandBuffersForCopy[i], VK_PIPELINE_STAGE_TRANSFER_BIT, VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT, 0, 0, null, 0, null, 1, &barrierFromClearToPresent);
				
				
				
				
				if( vkEndCommandBuffer(cast(VkCommandBuffer)commandBuffersForCopy[i]) != VK_SUCCESS ) {
					throw new EngineException(true, true, "Couldn't record command buffer [vkEndCommandBuffer]");
				}
			}
			
			
			// for actual rendering
			{
				vkBeginCommandBuffer(cast(VkCommandBuffer)commandBufferForRendering, &graphicsCommandBufferBeginInfo);
				
				
				TypesafeVkFramebuffer framebuffer = (cast(VulkanResourceDagResource!TypesafeVkFramebuffer)framebufferFramebufferResourceNodes[0].resource).resource;
				
				VkRenderPassBeginInfo render_pass_begin_info = {
					VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO,     // VkStructureType                sType
					null,                                      // const void                    *pNext
					cast(VkRenderPass)renderPass,                            // VkRenderPass                   renderPass
					cast(VkFramebuffer)framebuffer,          // VkFramebuffer                  framebuffer
					{                                             // VkRect2D                       renderArea
						{                                           // VkOffset2D                     offset
							0,                                          // int32_t                        x
							0                                           // int32_t                        y
						},
						{                                           // VkExtent2D                     extent
							300,                                        // int32_t                        width
							300,                                        // int32_t                        height
						}
					},
					1,                                            // uint32_t                       clearValueCount
					cast(immutable(VkClearValue)*)&clear_value                                  // const VkClearValue            *pClearValues
				};
				

				vkCmdBeginRenderPass(cast(VkCommandBuffer)commandBufferForRendering, &render_pass_begin_info, VK_SUBPASS_CONTENTS_INLINE);
				
				vkCmdBindPipeline(cast(VkCommandBuffer)commandBufferForRendering, VK_PIPELINE_BIND_POINT_GRAPHICS, cast(VkPipeline)graphicsPipeline);
				
				vkCmdDraw(cast(VkCommandBuffer)commandBufferForRendering, 3, 1, 0, 0);
				
				vkCmdEndRenderPass(cast(VkCommandBuffer)commandBufferForRendering);
				
				if( vkEndCommandBuffer(cast(VkCommandBuffer)commandBufferForRendering) != VK_SUCCESS ) {
					throw new EngineException(true, true, "Couldn't record command buffer [vkEndCommandBuffer]");
				}
			}

		}
		
		void loop() {
			VkResult vulkanResult;
			
			uint semaphorePairIndex = 0;
			do {
				uint32_t imageIndex = UINT32_MAX;
				
				// get the next available swapchain image
				vulkanResult = vulkanContext.swapChain.acquireNextImage(vulkanContext.swapChain.semaphorePairs[semaphorePairIndex].imageAcquiredSemaphore, &imageIndex);
				switch(vulkanResult) {
					case VK_SUCCESS:
					break;
					
					case VK_ERROR_OUT_OF_DATE_KHR:
					case VK_SUBOPTIMAL_KHR:
					// TODO< window size changed > 
					break;
					
					default:
					throw new EngineException(true, true, "Problem occurred during image presentation!");
				}
				
				
				{ // present
					VkPipelineStageFlags[1] waitDstStageMasks = [VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT];
					TypesafeVkSemaphore[1] waitSemaphores = [cast(TypesafeVkSemaphore)vulkanContext.swapChain.semaphorePairs[semaphorePairIndex].imageAcquiredSemaphore];
					TypesafeVkSemaphore[1] signalSemaphores = [cast(TypesafeVkSemaphore)vulkanContext.swapChain.semaphorePairs[semaphorePairIndex].chainSemaphore];
					TypesafeVkCommandBuffer[0] commandBuffers;
					DevicelessFacade.queueSubmit(
						cast(TypesafeVkQueue)vulkanContext.queueManager.getQueueByName("present"),
						waitSemaphores, signalSemaphores, commandBuffers, waitDstStageMasks,
						cast(TypesafeVkFence)vulkanContext.swapChain.context.additionalFence
					);
					vkDevFacade.fenceWaitAndReset(cast(TypesafeVkFence)vulkanContext.swapChain.context.additionalFence);
				}
				
				{ // do rendering work and wait for it
					VkPipelineStageFlags[1] waitDstStageMasks = [VK_PIPELINE_STAGE_ALL_GRAPHICS_BIT];
					TypesafeVkSemaphore[1] waitSemaphores = [cast(TypesafeVkSemaphore)vulkanContext.swapChain.semaphorePairs[semaphorePairIndex].chainSemaphore];
					TypesafeVkSemaphore[1] signalSemaphores = [chainSemaphore2];
					TypesafeVkCommandBuffer[1] commandBuffers = [cast(TypesafeVkCommandBuffer)commandBufferForRendering];
					DevicelessFacade.queueSubmit(
						cast(TypesafeVkQueue)vulkanContext.queueManager.getQueueByName("graphics"),
						waitSemaphores, signalSemaphores, commandBuffers, waitDstStageMasks,
						cast(TypesafeVkFence)vulkanContext.swapChain.context.additionalFence
					);
					vkDevFacade.fenceWaitAndReset(cast(TypesafeVkFence)vulkanContext.swapChain.context.additionalFence);
				}
				
				{ // do copy
					VkPipelineStageFlags[1] waitDstStageMasks = [VK_PIPELINE_STAGE_TRANSFER_BIT];
					TypesafeVkSemaphore[1] waitSemaphores = [chainSemaphore2];
					TypesafeVkSemaphore[1] signalSemaphores = [cast(TypesafeVkSemaphore)vulkanContext.swapChain.semaphorePairs[semaphorePairIndex].renderingCompleteSemaphore];
					TypesafeVkCommandBuffer[1] commandBuffers = [cast(TypesafeVkCommandBuffer)commandBuffersForCopy[imageIndex]];
					DevicelessFacade.queueSubmit(
						cast(TypesafeVkQueue)vulkanContext.queueManager.getQueueByName("graphics"),
						waitSemaphores, signalSemaphores, commandBuffers, waitDstStageMasks,
						cast(TypesafeVkFence)vulkanContext.swapChain.context.additionalFence
					);
					vkDevFacade.fenceWaitAndReset(cast(TypesafeVkFence)vulkanContext.swapChain.context.additionalFence);
				}
				
				
				
				// Submit present operation to present queue
				vulkanResult = vulkanContext.swapChain.queuePresent(
					vulkanContext.queueManager.getQueueByName("present"),
					vulkanContext.swapChain.semaphorePairs[semaphorePairIndex].renderingCompleteSemaphore,
					imageIndex
				);
				
				switch(vulkanResult) {
					case VK_SUCCESS:
					break;
					
					case VK_ERROR_OUT_OF_DATE_KHR:
					case VK_SUBOPTIMAL_KHR:
					// TODO< window size changed > 
					break;
					
					default:
					throw new EngineException(true, true, "Problem occurred during image presentation!");
				}
				
				semaphorePairIndex = (semaphorePairIndex+1) % vulkanContext.swapChain.semaphorePairs.length;
			} while (vulkanResult >= 0);
		
		}
		
		
		
		
		// resource managment helpers
		void releaseRenderpassResources() {
			renderPassResourceNode.decrementExternalReferenceCounter();
		}
		
		void releaseFramebufferResources() {
			scope(exit) vkDevFacade.destroyImage(framebufferImageResource.resource.value);
			
			scope(exit) {
				foreach( iterationImageView; framebufferImageViewsResourceNodes ) {
					iterationImageView.decrementExternalReferenceCounter();
				}
			}
			
		}
		
		void releasePipelineResources() {
			pipelineResourceNode.decrementExternalReferenceCounter();
		}
		
		
		
		
		
		
		scope(exit) checkForReleasedResourcesAndRelease();
		
		chainSemaphore2 = vkDevFacade.createSemaphore();
		scope(exit) {
			// before destruction of vulkan resources we have to ensure that the decive idles
			vkDeviceWaitIdle(vulkanContext.chosenDevice.logicalDevice);
			
			vkDevFacade.destroySemaphore(chainSemaphore2);
		}
		
		
		//////////////////
		// allocate setup command buffer and fence
		
		setupCommandBuffer = vkDevFacade.allocateCommandBuffer(cast(TypesafeVkCommandPool)vulkanContext.commandPoolsByQueueName["graphics"].value);
		scope(exit) {
			// before destruction of vulkan resources we have to ensure that the decive idles
			vkDeviceWaitIdle(vulkanContext.chosenDevice.logicalDevice);
			
			vkDevFacade.freeCommandBuffer(setupCommandBuffer, cast(TypesafeVkCommandPool)vulkanContext.commandPoolsByQueueName["graphics"].value);
		}
		
		
		setupCommandBufferFence = vkDevFacade.createFence();
		scope (exit) {
			vkDevFacade.destroyFence(setupCommandBufferFence);
		}
		
		
		//////////////////
		// create renderpass
		//////////////////

		createRenderpass();
		scope(exit) releaseRenderpassResources();
		
		/////////////////
		// create framebuffer
		/////////////////

		createFramebuffer();
		scope(exit) releaseFramebufferResources();

		//////////////////
		// create graphics pipeline
		//////////////////

		createPipeline();
		scope(exit) releasePipelineResources();
		
		
		//////////////////
		// allocate command buffers for swapchain image copy and rendering
		//////////////////
		
		uint count = vulkanContext.swapChain.swapchainImages.length;
		commandBuffersForCopy = vkDevFacade.allocateCommandBuffers(cast(TypesafeVkCommandPool)vulkanContext.commandPoolsByQueueName["graphics"].value, count);
		scope(exit) {
			// before destruction of vulkan resources we have to ensure that the decive idles
			vkDeviceWaitIdle(vulkanContext.chosenDevice.logicalDevice);
			
			vkDevFacade.freeCommandBuffers(commandBuffersForCopy, cast(TypesafeVkCommandPool)vulkanContext.commandPoolsByQueueName["graphics"].value);
		}
		
		commandBufferForRendering = vkDevFacade.allocateCommandBuffer(cast(TypesafeVkCommandPool)vulkanContext.commandPoolsByQueueName["graphics"].value);
		scope(exit) {
			// before destruction of vulkan resources we have to ensure that the decive idles
			vkDeviceWaitIdle(vulkanContext.chosenDevice.logicalDevice);
			
			vkDevFacade.freeCommandBuffer(commandBufferForRendering, cast(TypesafeVkCommandPool)vulkanContext.commandPoolsByQueueName["graphics"].value);
		}

		
		//////////////////
		// record command buffers
		//////////////////
		
		recordingCommandBuffers();
		
		
		
		//////////////////
		// create buffer for vertex information and fill it 
		//////////////////
		VulkanDeviceFacade.CreateBufferArguments createBufferArguments = VulkanDeviceFacade.CreateBufferArguments.init;
		createBufferArguments.size = /*vertex.sizeof*/16   * 3;
		createBufferArguments.usage = VK_BUFFER_USAGE_VERTEX_BUFFER_BIT;
		createBufferArguments.sharingMode = VK_SHARING_MODE_EXCLUSIVE;
		vboPositionBufferResource.resource = vkDevFacade.createBuffer(createBufferArguments);
		scope(exit) {
			// before destruction of vulkan resources we have to ensure that the decive idles
		    vkDeviceWaitIdle(vulkanContext.chosenDevice.logicalDevice);
			
			vkDevFacade.destroyBuffer(vboPositionBufferResource.resource.value);
		}
		
		resourceQueryAllocate(vboPositionBufferResource, VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT, "buffer");
		
		


		// TODO< call next function for initialisation >
		//TODO();
		loop();
	}
	
	protected final void checkForReleasedResourcesAndRelease() {
		// before destruction of vulkan resources we have to ensure that the decive idles
	    vkDeviceWaitIdle(vulkanContext.chosenDevice.logicalDevice);

		
		// TODO< invoke resourceDag >
	}
	
	
	protected final VulkanMemoryAllocator.AllocatorConfiguration getDefaultAllocatorConfigurationByTypeIndexAndUsage(uint32_t typeIndex, string usage) {
		// we ignore the usag and just return the standardconfiguration
		VulkanMemoryAllocator.AllocatorConfiguration resultAllocatorConfiguration = new VulkanMemoryAllocator.AllocatorConfiguration();
		resultAllocatorConfiguration.initialSize = 1 << 26; // ~ 66 MB
		resultAllocatorConfiguration.linearGrowthRate = 1 << 26; // ~ 66 MB
		resultAllocatorConfiguration.memoryTypeIndex = typeIndex;
		return resultAllocatorConfiguration;
	}
	
	
	
	
	
	// the internal helper returns the used allocator
	protected /*protected*/ final VulkanMemoryAllocator resourceQueryAllocateInternal(VulkanResourceType)(VulkanResourceWithMemoryDecoration!VulkanResourceType resourceWithMemDeco, VkFlags requiredMemoryProperties, string usage)
	in {
		assert(resourceWithMemDeco.resource.isValid);
		assert(!resourceWithMemDeco.derivedInformation.isValid);
	}
	body {
		/////
		// validation
		
		if( !resourceWithMemDeco.resource.isValid ) { // if there is no resource
			// TODO< maybe we should log this, as a nonfatal error >
			return null;
		}
		
		if( resourceWithMemDeco.derivedInformation.isValid ) { // if the resource was already allocated and bound
			// TODO< maybe we should log this, as a nonfatal error >
			return null;
		}
		
		/////
		// body
		
		{	auto initValue = VulkanResourceWithMemoryDecoration!VulkanResourceType.DerivedInformation.init;
			resourceWithMemDeco.derivedInformation = initValue;
		}
		
		// see https://av.dfki.de/~jhenriques/development.html#tutorial_011 to know on how the query and allocation and binding works and what the core of the algorithm is
		VkMemoryRequirements memRequirements;
		vkDevFacade.getMemoryRequirements(resourceWithMemDeco.resource.value, /*out*/ memRequirements);
		// search for heap index that match requirements
		resourceWithMemDeco.derivedInformation.value.typeIndex = searchBestIndexOfMemoryTypeThrows(vulkanContext.chosenDevice.physicalDeviceMemoryProperties, memRequirements.memoryTypeBits, requiredMemoryProperties);
		
		// allocate
		VulkanMemoryAllocator.AllocatorConfiguration allocatorConfiguration = getDefaultAllocatorConfigurationByTypeIndexAndUsage(resourceWithMemDeco.derivedInformation.value.typeIndex, usage);
		VulkanMemoryAllocator allocatorForResource = vulkanContext.retriveOrCreateMemoryAllocatorByTypeIndex(resourceWithMemDeco.derivedInformation.value.typeIndex, allocatorConfiguration);
		resourceWithMemDeco.derivedInformation.value.offset = allocatorForResource.allocate(memRequirements.size, memRequirements.alignment, /* out */resourceWithMemDeco.derivedInformation.value.hintAllocatedSize);
		
		return allocatorForResource;
	}
	
	/**
	 * * query the size and required memory attributes of the vulkan handle
	 * * find a suitable allocator or create a new one for the memory
	 * * allocate the memory from the allocator
	 */
	protected final void resourceQueryAllocate(VulkanResourceType)(VulkanResourceWithMemoryDecoration!VulkanResourceType resourceWithMemDeco, VkFlags requiredMemoryProperties, string usage) {
		resourceQueryAllocateInternal(resourceWithMemDeco, requiredMemoryProperties, usage);
	}
	
	protected final void resourceQueryAllocateBind(VulkanResourceType)(VulkanResourceWithMemoryDecoration!VulkanResourceType resourceWithMemDeco, VkFlags requiredMemoryProperties, string usage) {
		VulkanMemoryAllocator allocatorForMemoryOfResource = resourceQueryAllocateInternal(resourceWithMemDeco, requiredMemoryProperties, usage);
		
		// bind
		vkDevFacade.bind(resourceWithMemDeco.resource.value, allocatorForMemoryOfResource.deviceMemory, resourceWithMemDeco.derivedInformation.value.offset);
	}
	
	// we need this here for the resource* method family
	protected VulkanDeviceFacade vkDevFacade;
}

