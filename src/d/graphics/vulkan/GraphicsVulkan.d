module graphics.vulkan.GraphicsVulkan;

import std.stdint;

import Exceptions;
import api.vulkan.Vulkan;
import graphics.vulkan.VulkanContext;
import vulkan.VulkanHelpers;
import vulkan.VulkanTools;
import common.IDisposable;

import common.ResourceDag;
//import common.GenericResourceDagResource;
import graphics.vulkan.resourceDag.VulkanResourceDagResource;


class GraphicsVulkan {
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
		
		VkCommandBuffer[] commandBuffersForRendering; // no need to manage this with the resource dag, because we need it just once
		
		// code taken from https://software.intel.com/en-us/articles/api-without-secrets-introduction-to-vulkan-part-3
		// at first commit time
		// license seem to be without license

		






		void createRenderpass() {
			VkResult vulkanResult;
			
			VkAttachmentDescription attachment_descriptions[] = [
				{
					0,                                   // VkAttachmentDescriptionFlags   flags
					vulkanContext.swapChain.swapchainFormat,               // VkFormat                       format
					VK_SAMPLE_COUNT_1_BIT,               // VkSampleCountFlagBits          samples
					VK_ATTACHMENT_LOAD_OP_CLEAR,         // VkAttachmentLoadOp             loadOp
					VK_ATTACHMENT_STORE_OP_STORE,        // VkAttachmentStoreOp            storeOp
					VK_ATTACHMENT_LOAD_OP_DONT_CARE,     // VkAttachmentLoadOp             stencilLoadOp
					VK_ATTACHMENT_STORE_OP_DONT_CARE,    // VkAttachmentStoreOp            stencilStoreOp
					VK_IMAGE_LAYOUT_PRESENT_SRC_KHR,     // VkImageLayout                  initialLayout;
					VK_IMAGE_LAYOUT_PRESENT_SRC_KHR      // VkImageLayout                  finalLayout
				}
			];


			// subpass description

			VkAttachmentReference color_attachment_references[] = [
				{
					0,                                          // uint32_t                       attachment
					VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL    // VkImageLayout                  layout
				}
			];
			 
			VkSubpassDescription subpass_descriptions[] = [
				{
					0,                                          // VkSubpassDescriptionFlags      flags
					VK_PIPELINE_BIND_POINT_GRAPHICS,            // VkPipelineBindPoint            pipelineBindPoint
					0,                                          // uint32_t                       inputAttachmentCount
					null,                                    // const VkAttachmentReference   *pInputAttachments
					1,                                          // uint32_t                       colorAttachmentCount
					cast(immutable(VkAttachmentReference)*)color_attachment_references.ptr,                // const VkAttachmentReference   *pColorAttachments
					null,                                    // const VkAttachmentReference   *pResolveAttachments
					null,                                    // const VkAttachmentReference   *pDepthStencilAttachment
					0,                                          // uint32_t                       preserveAttachmentCount
					null                                     // const uint32_t*                pPreserveAttachments
				}
			];


			VkRenderPassCreateInfo render_pass_create_info = {
				VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO,    // VkStructureType                sType
				null,                                      // const void                    *pNext
				0,                                            // VkRenderPassCreateFlags        flags
				1,                                            // uint32_t                       attachmentCount
				cast(immutable(VkAttachmentDescription)*)attachment_descriptions.ptr,                      // const VkAttachmentDescription *pAttachments
				1,                                            // uint32_t                       subpassCount
				cast(immutable(VkSubpassDescription)*)subpass_descriptions.ptr,                         // const VkSubpassDescription    *pSubpasses
				0,                                            // uint32_t                       dependencyCount
				null                                       // const VkSubpassDependency     *pDependencies
			};
			
			const(VkAllocationCallbacks*) allocator = null;
			
			VkRenderPass renderpass;
			vulkanResult = vkCreateRenderPass(vulkanContext.chosenDevice.logicalDevice, &render_pass_create_info, allocator, &renderpass);
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Couldn't create render pass [vkCreateRenderPass]!");
			}
			
			
			VulkanResourceDagResource!VkRenderPass renderPassDagResource = new VulkanResourceDagResource!VkRenderPass(vulkanContext.chosenDevice.logicalDevice, renderpass, allocator, &disposeRenderPass);
			renderPassResourceNode = resourceDag.createNode(renderPassDagResource);
			
			// we hold this because else the resourceDag would dispose them
			renderPassResourceNode.incrementExternalReferenceCounter();
		}
		
		
		void createFramebuffer() {
			VkResult vulkanResult;
			
			// create image views
			
			foreach( i; 0..vulkanContext.swapChain.swapchainImages.length ) {
				VkImageViewCreateInfo image_view_create_info = {
					VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO,   // VkStructureType                sType
					null,                                    // const void                    *pNext
					0,                                          // VkImageViewCreateFlags         flags
					vulkanContext.swapChain.swapchainImages[i],                       // VkImage                        image
					VK_IMAGE_VIEW_TYPE_2D,                      // VkImageViewType                viewType
					vulkanContext.swapChain.swapchainFormat,                      // VkFormat                       format
					{                                           // VkComponentMapping             components
						VK_COMPONENT_SWIZZLE_IDENTITY,              // VkComponentSwizzle             r
						VK_COMPONENT_SWIZZLE_IDENTITY,              // VkComponentSwizzle             g
						VK_COMPONENT_SWIZZLE_IDENTITY,              // VkComponentSwizzle             b
						VK_COMPONENT_SWIZZLE_IDENTITY               // VkComponentSwizzle             a
					},
					{                                           // VkImageSubresourceRange        subresourceRange
						VK_IMAGE_ASPECT_COLOR_BIT,                  // VkImageAspectFlags             aspectMask
						0,                                          // uint32_t                       baseMipLevel
						1,                                          // uint32_t                       levelCount
						0,                                          // uint32_t                       baseArrayLayer
						1                                           // uint32_t                       layerCount
					}
				};
				
				ResourceDag.ResourceNode imageViewResourceNode;
				{ // brace to scope the allocator
					const(VkAllocationCallbacks*) allocator = null;
					
					VkImageView createdImageView;
					vulkanResult = vkCreateImageView(vulkanContext.chosenDevice.logicalDevice, &image_view_create_info, allocator, &createdImageView);
					if( !vulkanSuccess(vulkanResult) ) {
						throw new EngineException(true, true, "Couldn't create image view for framebuffer [vkCreateImageView]!");
					}
						
					VulkanResourceDagResource!VkImageView imageViewDagResource = new VulkanResourceDagResource!VkImageView(vulkanContext.chosenDevice.logicalDevice, createdImageView, allocator, &disposeImageView);
					imageViewResourceNode = resourceDag.createNode(imageViewDagResource);
					
					// we hold this because else the resourceDag would dispose them
					imageViewResourceNode.incrementExternalReferenceCounter();
					
					framebufferImageViewsResourceNodes ~= imageViewResourceNode;
				}



				VkImageView imageViewForFramebuffer = (cast(VulkanResourceDagResource!VkImageView)imageViewResourceNode.resource).resource;
				// specifiy framebuffer parameters
				VkFramebufferCreateInfo framebuffer_create_info = {
					VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO,  // VkStructureType                sType
					null,                                    // const void                    *pNext
					0,                                          // VkFramebufferCreateFlags       flags
					(cast(VulkanResourceDagResource!VkRenderPass)renderPassResourceNode.resource).resource,                          // VkRenderPass                   renderPass
					1,                                          // uint32_t                       attachmentCount
					cast(immutable(ulong)*)&imageViewForFramebuffer,    // const VkImageView             *pAttachments
					300,                                        // uint32_t                       width
					300,                                        // uint32_t                       height
					1                                           // uint32_t                       layers
				};
				
				{ // brace to scope the allocator
					const(VkAllocationCallbacks*) allocator = null;

					VkFramebuffer createdFramebuffer;
					vulkanResult = vkCreateFramebuffer(vulkanContext.chosenDevice.logicalDevice, &framebuffer_create_info, allocator, &createdFramebuffer);
					if( !vulkanSuccess(vulkanResult) ) {
						throw new EngineException(true, true, "Couldn't create a framebuffer [vkCreateFramebuffer]!");
					}
					
					VulkanResourceDagResource!VkFramebuffer framebufferDagResource = new VulkanResourceDagResource!VkFramebuffer(vulkanContext.chosenDevice.logicalDevice, createdFramebuffer, allocator, &disposeFramebuffer);
					ResourceDag.ResourceNode framebufferResourceNode = resourceDag.createNode(framebufferDagResource);
					imageViewResourceNode.addChild(framebufferResourceNode); // link it so if the imageView gets disposed the framebuffer gets disposed too
					framebufferResourceNode.addChild(renderPassResourceNode); // link it because it depends on the renderpass
	
					framebufferFramebufferResourceNodes ~= framebufferResourceNode;
				}
			}
		}

		/+
		nonvoid createShaderModule() {
			const std::vector<char> code = Tools::GetBinaryFileContents( filename );
			if( code.size() == 0 ) {
				return Tools::AutoDeleter<VkShaderModule, PFN_vkDestroyShaderModule>();
			}

			VkShaderModuleCreateInfo shader_module_create_info = {
				VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO,    // VkStructureType                sType
				null,                                        // const void                    *pNext
				0,                                              // VkShaderModuleCreateFlags      flags
				code.size(),                                    // size_t                         codeSize
				reinterpret_cast<const uint32_t*>(&code[0])     // const uint32_t                *pCode
			};
			 
			VkShaderModule shader_module;
			if( vkCreateShaderModule( GetDevice(), &shader_module_create_info, nullptr, &shader_module ) != VK_SUCCESS ) {
				printf( "Could not create shader module from a %s file!\n", filename );
				return Tools::AutoDeleter<VkShaderModule, PFN_vkDestroyShaderModule>();
			}
			return Tools::AutoDeleter<VkShaderModule, PFN_vkDestroyShaderModule>( shader_module, vkDestroyShaderModule, GetDevice() );
		}+/
		
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

			//Tools::AutoDeleter<VkShaderModule, PFN_vkDestroyShaderModule> vertex_shader_module = CreateShaderModule( "Data03/vert.spv" );
			//Tools::AutoDeleter<VkShaderModule, PFN_vkDestroyShaderModule> fragment_shader_module = CreateShaderModule( "Data03/frag.spv" );


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


			// setting multisample state description

			VkPipelineMultisampleStateCreateInfo multisample_state_create_info = {
				VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO,     // VkStructureType                                sType
				null,                                                      // const void                                    *pNext
				0,                                                            // VkPipelineMultisampleStateCreateFlags          flags
				VK_SAMPLE_COUNT_1_BIT,                                        // VkSampleCountFlagBits                          rasterizationSamples
				VK_FALSE,                                                     // VkBool32                                       sampleShadingEnable
				1.0f,                                                         // float                                          minSampleShading
				null,                                                      // const VkSampleMask                            *pSampleMask
				VK_FALSE,                                                     // VkBool32                                       alphaToCoverageEnable
				VK_FALSE                                                      // VkBool32                                       alphaToOneEnable
			};


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
			VkPipelineLayout pipelineLayout = createPipelineLayout();
			scope(exit) vkDestroyPipelineLayout(vulkanContext.chosenDevice.logicalDevice, pipelineLayout, null);
			
			VkRenderPass renderPass = (cast(VulkanResourceDagResource!VkRenderPass)renderPassResourceNode.resource).resource;
			
			VkGraphicsPipelineCreateInfo pipeline_create_info = {
				VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO,              // VkStructureType                                sType
				null,                                                      // const void                                    *pNext
				0,                                                            // VkPipelineCreateFlags                          flags
				cast(uint32_t)shader_stage_create_infos.length,      // uint32_t                                       stageCount
				cast(immutable(VkPipelineShaderStageCreateInfo)*)&shader_stage_create_infos[0],                                // const VkPipelineShaderStageCreateInfo         *pStages
				cast(immutable(VkPipelineVertexInputStateCreateInfo)*)&vertex_input_state_create_info,                              // const VkPipelineVertexInputStateCreateInfo    *pVertexInputState;
				cast(immutable(VkPipelineInputAssemblyStateCreateInfo)*)&input_assembly_state_create_info,                            // const VkPipelineInputAssemblyStateCreateInfo  *pInputAssemblyState
				null,                                                      // const VkPipelineTessellationStateCreateInfo   *pTessellationState
				cast(immutable(VkPipelineViewportStateCreateInfo)*)&viewport_state_create_info,                                  // const VkPipelineViewportStateCreateInfo       *pViewportState
				cast(immutable(VkPipelineRasterizationStateCreateInfo)*)&rasterization_state_create_info,                             // const VkPipelineRasterizationStateCreateInfo  *pRasterizationState
				cast(immutable(VkPipelineMultisampleStateCreateInfo)*)&multisample_state_create_info,                               // const VkPipelineMultisampleStateCreateInfo    *pMultisampleState
				null,                                                      // const VkPipelineDepthStencilStateCreateInfo   *pDepthStencilState
				cast(immutable(VkPipelineColorBlendStateCreateInfo)*)&color_blend_state_create_info,                               // const VkPipelineColorBlendStateCreateInfo     *pColorBlendState
				null,                                                      // const VkPipelineDynamicStateCreateInfo        *pDynamicState
				pipelineLayout,                                        // VkPipelineLayout                               layout
				renderPass,                                            // VkRenderPass                                   renderPass
				0,                                                            // uint32_t                                       subpass
				0,                                               // VkPipeline                                     basePipelineHandle
				-1                                                            // int32_t                                        basePipelineIndex
			};
			
			VkPipeline createdGraphicsPipeline;
			vulkanResult = vkCreateGraphicsPipelines(vulkanContext.chosenDevice.logicalDevice, VK_NULL_HANDLE, 1, &pipeline_create_info, null, &createdGraphicsPipeline );
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Couldn't create graphics pipeline [vkCreateGraphicsPipelines]");
			}
			
			const(VkAllocationCallbacks*) allocator = null;
			
			VulkanResourceDagResource!VkPipeline pipelineDagResource = new VulkanResourceDagResource!VkPipeline(vulkanContext.chosenDevice.logicalDevice, createdGraphicsPipeline, allocator, &disposePipeline);
			pipelineResourceNode = resourceDag.createNode(pipelineDagResource);
			
			// we hold this because else the resourceDag would dispose them
			pipelineResourceNode.incrementExternalReferenceCounter();
		}
		
		// function just for the example code, eeds to get refactored later
		void recordingCommandBuffers() {
			VkResult vulkanResult;
			
			
			VkCommandBufferBeginInfo graphics_commandd_buffer_begin_info = {
				VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,    // VkStructureType                        sType
				null,                                        // const void                            *pNext
				VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT,   // VkCommandBufferUsageFlags              flags
				null                                         // const VkCommandBufferInheritanceInfo  *pInheritanceInfo
			};

			VkImageSubresourceRange image_subresource_range = {
				VK_IMAGE_ASPECT_COLOR_BIT,                      // VkImageAspectFlags             aspectMask
				0,                                              // uint32_t                       baseMipLevel
				1,                                              // uint32_t                       levelCount
				0,                                              // uint32_t                       baseArrayLayer
				1                                               // uint32_t                       layerCount
			};

			VkClearValue clear_value;
			clear_value.color.float32 =
				[ 1.0f, 0.8f, 0.4f, 0.0f ];

			VkImage[] swap_chain_images = vulkanContext.swapChain.swapchainImages;

			uint32_t graphicsQueueFamilyIndex = vulkanContext.queueManager.getDeviceQueueInfoByName("graphics").queueFamilyIndex;
			uint32_t presentQueueFamilyIndex = vulkanContext.queueManager.getDeviceQueueInfoByName("present").queueFamilyIndex;
			VkQueue graphicsQueue = vulkanContext.queueManager.getQueueByName("graphics");
			VkQueue presentQueue = vulkanContext.queueManager.getQueueByName("present");;
			
			VkRenderPass renderPass = (cast(VulkanResourceDagResource!VkRenderPass)renderPassResourceNode.resource).resource;
			VkPipeline graphicsPipeline = (cast(VulkanResourceDagResource!VkPipeline)pipelineResourceNode.resource).resource;

			for( size_t i = 0; i < commandBuffersForRendering.length; ++i ) {
				vkBeginCommandBuffer( commandBuffersForRendering[i], &graphics_commandd_buffer_begin_info);
				
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
					
					vkCmdPipelineBarrier(commandBuffersForRendering[i], VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT, VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT, 0, 0, null, 0, null, 1, &barrier_from_present_to_draw);
				}
				*/
				
				
				 // NOTE< not 100% sure if this is right for multiple queues, test on hardware where the queues are different ones > 
				VkImageMemoryBarrier barrier_from_present_to_clear;
				with (barrier_from_present_to_clear) {
					sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
					pNext = null;
					srcAccessMask = VK_ACCESS_MEMORY_READ_BIT;
					dstAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
					oldLayout = VK_IMAGE_LAYOUT_UNDEFINED;
					newLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
					srcQueueFamilyIndex = graphicsQueueFamilyIndex;
					dstQueueFamilyIndex = presentQueueFamilyIndex;
					image = vulkanContext.swapChain.swapchainImages[i];
					subresourceRange = image_subresource_range;
				}
				
				VkImageMemoryBarrier barrier_from_clear_to_present;
				with (barrier_from_clear_to_present) {
					sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
					pNext = null;
					srcAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
					dstAccessMask = VK_ACCESS_MEMORY_READ_BIT;
					oldLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
					newLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;
					srcQueueFamilyIndex = presentQueueFamilyIndex;
					dstQueueFamilyIndex = graphicsQueueFamilyIndex;
					image = vulkanContext.swapChain.swapchainImages[i];
					subresourceRange = image_subresource_range;	
				}
				
				VkImageSubresourceRange imageSubresourceRangeForCopy = {VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1 };
				
				VkClearColorValue clear_color;
				clear_color.float32 = [1.0f, 0.8f, 0.4f, 0.0f];
				
				
				vkCmdPipelineBarrier(commandBuffersForRendering[i], VK_PIPELINE_STAGE_TRANSFER_BIT, VK_PIPELINE_STAGE_TRANSFER_BIT, 0, 0, null, 0, null, 1, &barrier_from_present_to_clear);
				vkCmdClearColorImage(commandBuffersForRendering[i], vulkanContext.swapChain.swapchainImages[i], VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, &clear_color, 1, &imageSubresourceRangeForCopy);
				vkCmdPipelineBarrier(commandBuffersForRendering[i], VK_PIPELINE_STAGE_TRANSFER_BIT, VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT, 0, 0, null, 0, null, 1, &barrier_from_clear_to_present);
				
				
				
				
				/+
				VkFramebuffer framebuffer = (cast(VulkanResourceDagResource!VkFramebuffer)framebufferFramebufferResourceNodes[i].resource).resource;

				VkRenderPassBeginInfo render_pass_begin_info = {
					VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO,     // VkStructureType                sType
					null,                                      // const void                    *pNext
					renderPass,                            // VkRenderPass                   renderPass
					framebuffer,          // VkFramebuffer                  framebuffer
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
				
				vkCmdBeginRenderPass(commandBuffersForRendering[i], &render_pass_begin_info, VK_SUBPASS_CONTENTS_INLINE);
				
				vkCmdBindPipeline(commandBuffersForRendering[i], VK_PIPELINE_BIND_POINT_GRAPHICS, graphicsPipeline);
				
				vkCmdDraw(commandBuffersForRendering[i], 3, 1, 0, 0);
				
				vkCmdEndRenderPass(commandBuffersForRendering[i]);
				
				/* uncommented because its impossible to test with this hardware of the developer ;)
				if( presentQueue != graphicsQueue ) {
					VkImageMemoryBarrier barrier_from_draw_to_present = {
						VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,       // VkStructureType              sType
						null,                                      // const void                  *pNext
						VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT,         // VkAccessFlags                srcAccessMask
						VK_ACCESS_MEMORY_READ_BIT,                    // VkAccessFlags                dstAccessMask
						VK_IMAGE_LAYOUT_PRESENT_SRC_KHR,              // VkImageLayout                oldLayout
						VK_IMAGE_LAYOUT_PRESENT_SRC_KHR,              // VkImageLayout                newLayout
						graphicsQueueFamilyIndex,               // uint32_t                     srcQueueFamilyIndex
						presentQueueFamilyIndex,               // uint32_t                     dstQueueFamilyIndex
						swap_chain_images[i],                         // VkImage                      image
						image_subresource_range                       // VkImageSubresourceRange      subresourceRange
					};
					vkCmdPipelineBarrier(commandBuffersForRendering[i], VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT, VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT, 0, 0, null, 0, null, 1, &barrier_from_draw_to_present);
				}*/
				
				+/

				if( vkEndCommandBuffer(commandBuffersForRendering[i]) != VK_SUCCESS ) {
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

				{
					immutable VkPipelineStageFlags waitDstStageMask = VK_PIPELINE_STAGE_TRANSFER_BIT;
					VkSubmitInfo submitInfo;
					initSubmitInfo(&submitInfo);
					with (submitInfo) {
						waitSemaphoreCount = 1;
						pWaitSemaphores = cast(const(immutable(VkSemaphore)*))&vulkanContext.swapChain.semaphorePairs[semaphorePairIndex].imageAcquiredSemaphore;
						pWaitDstStageMask = cast(immutable(VkPipelineStageFlags)*)&waitDstStageMask;
						commandBufferCount = 1;
						pCommandBuffers = cast(immutable(VkCommandBuffer_T*)*)&commandBuffersForRendering[imageIndex];
						signalSemaphoreCount = 1;
					pSignalSemaphores = cast(const(immutable(VkSemaphore)*))&vulkanContext.swapChain.semaphorePairs[semaphorePairIndex].chainSemaphore;
				}
				
					vulkanResult = vkQueueSubmit(vulkanContext.queueManager.getQueueByName("graphics"), 1, &submitInfo, vulkanContext.swapChain.context.additionalFence);
					if( !vulkanSuccess(vulkanResult) ) {
						throw new EngineException(true, true, "Queue submit failed! [vkQueueSubmit]");
					}
					
					vulkanResult = vkWaitForFences(vulkanContext.chosenDevice.logicalDevice, 1, &vulkanContext.swapChain.context.additionalFence, VK_TRUE, UINT64_MAX);
					if( !vulkanSuccess(vulkanResult) ) {
						throw new EngineException(true, true, "Wait for fences failed! [vkWaitForFences]");
					}
					
					vulkanResult = vkResetFences(vulkanContext.chosenDevice.logicalDevice, 1, &vulkanContext.swapChain.context.additionalFence);
					if( !vulkanSuccess(vulkanResult) ) {
						throw new EngineException(true, true, "Fence reset failed! [vkResetFrences]");
					}
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
			foreach( iterationImageView; framebufferImageViewsResourceNodes ) {
				iterationImageView.decrementExternalReferenceCounter();
			}
		}
		
		void releasePipelineResources() {
			pipelineResourceNode.decrementExternalReferenceCounter();
		}
		
		
		
		
		scope(exit) checkForReleasedResourcesAndRelease();

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
		// allocate command buffers for swapchain images(?)
		//////////////////
		
		uint count = vulkanContext.swapChain.swapchainImages.length;
		commandBuffersForRendering = allocateCommandBuffers(vulkanContext.commandPoolsByQueueName["graphics"].value, count);
		scope(exit) {
			// before destruction of vulkan resources we have to ensure that the decive idles
			vkDeviceWaitIdle(vulkanContext.chosenDevice.logicalDevice);

			vkFreeCommandBuffers(
				vulkanContext.chosenDevice.logicalDevice,
				vulkanContext.commandPoolsByQueueName["graphics"].value,
				cast(uint32_t)commandBuffersForRendering.length,
				commandBuffersForRendering.ptr
			);
		}
		//////////////////
		// record command buffers
		//////////////////
		
		recordingCommandBuffers();
		
		


		// TODO< call next function for initialisation >
		//TODO();
		loop();
	}
	
	protected final void checkForReleasedResourcesAndRelease() {
		// before destruction of vulkan resources we have to ensure that the decive idles
	    vkDeviceWaitIdle(vulkanContext.chosenDevice.logicalDevice);

		
		// TODO< invoke resourceDag >
	}
	
	protected final VkCommandBuffer[] allocateCommandBuffers(VkCommandPool pool, uint count) {
		VkResult vulkanResult;
		
		// from https://software.intel.com/en-us/articles/api-without-secrets-introduction-to-vulkan-part-3
		// chapter "allocating command buffers"
		
		VkCommandBuffer[] commandBuffers;
		commandBuffers.length = count;
		
		VkCommandBufferAllocateInfo command_buffer_allocate_info = {			
			VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO, // VkStructureType                sType
			null,                                        // const void                    *pNext
			pool,                                           // VkCommandPool                  commandPool
			VK_COMMAND_BUFFER_LEVEL_PRIMARY,                // VkCommandBufferLevel           level
			cast(uint32_t)count                                           // uint32_t                       bufferCount
		};
			
		vulkanResult = vkAllocateCommandBuffers(vulkanContext.chosenDevice.logicalDevice, &command_buffer_allocate_info, commandBuffers.ptr);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't allocate command buffers [vkAllocateCommandBuffers]");
		}
		
		return commandBuffers;
	}
}

