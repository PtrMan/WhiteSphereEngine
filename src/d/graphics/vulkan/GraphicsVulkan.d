module graphics.vulkan.GraphicsVulkan;

import Exceptions;
import api.vulkan.Vulkan;
import graphics.vulkan.VulkanContext;
import vulkan.VulkanHelpers;

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
		
		// code taken from https://software.intel.com/en-us/articles/api-without-secrets-introduction-to-vulkan-part-3
		// at first commit time
		// license seem to be without license

		






		void createRenderpass() {
			VkResult vulkanResult;
			
			VkAttachmentDescription attachment_descriptions[] = [  {
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
		}

		void createPipeline() {
			// prepare description of stages

			Tools::AutoDeleter<VkShaderModule, PFN_vkDestroyShaderModule> vertex_shader_module = CreateShaderModule( "Data03/vert.spv" );
			Tools::AutoDeleter<VkShaderModule, PFN_vkDestroyShaderModule> fragment_shader_module = CreateShaderModule( "Data03/frag.spv" );

			if( !vertex_shader_module || !fragment_shader_module ) {
			  return false;
			}


			std::vector<VkPipelineShaderStageCreateInfo> shader_stage_create_infos = {
			  // Vertex shader
			  {
			    VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,        // VkStructureType                                sType
			    nullptr,                                                    // const void                                    *pNext
			    0,                                                          // VkPipelineShaderStageCreateFlags               flags
			    VK_SHADER_STAGE_VERTEX_BIT,                                 // VkShaderStageFlagBits                          stage
			    vertex_shader_module.Get(),                                 // VkShaderModule                                 module
			    "main",                                                     // const char                                    *pName
			    nullptr                                                     // const VkSpecializationInfo                    *pSpecializationInfo
			  },

			  // Fragment shader
			  {
			    VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,        // VkStructureType                                sType
			    nullptr,                                                    // const void                                    *pNext
			    0,                                                          // VkPipelineShaderStageCreateFlags               flags
			    VK_SHADER_STAGE_FRAGMENT_BIT,                               // VkShaderStageFlagBits                          stage
			    fragment_shader_module.Get(),                               // VkShaderModule                                 module
			    "main",                                                     // const char                                    *pName
			    nullptr                                                     // const VkSpecializationInfo                    *pSpecializationInfo
			  }
			};



			// prepare description of vertex input

			VkPipelineVertexInputStateCreateInfo vertex_input_state_create_info = {
			  VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO,    // VkStructureType                                sType
			  nullptr,                                                      // const void                                    *pNext
			  0,                                                            // VkPipelineVertexInputStateCreateFlags          flags;
			  0,                                                            // uint32_t                                       vertexBindingDescriptionCount
			  nullptr,                                                      // const VkVertexInputBindingDescription         *pVertexBindingDescriptions
			  0,                                                            // uint32_t                                       vertexAttributeDescriptionCount
			  nullptr                                                       // const VkVertexInputAttributeDescription       *pVertexAttributeDescriptions
			};



			// prepare description of input assembly

			VkPipelineInputAssemblyStateCreateInfo input_assembly_state_create_info = {
			  VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO,  // VkStructureType                                sType
			  nullptr,                                                      // const void                                    *pNext
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
			  nullptr,                                                      // const void                                    *pNext
			  0,                                                            // VkPipelineViewportStateCreateFlags             flags
			  1,                                                            // uint32_t                                       viewportCount
			  &viewport,                                                    // const VkViewport                              *pViewports
			  1,                                                            // uint32_t                                       scissorCount
			  &scissor                                                      // const VkRect2D                                *pScissors
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
			  nullptr,                                                      // const void                                    *pNext
			  0,                                                            // VkPipelineMultisampleStateCreateFlags          flags
			  VK_SAMPLE_COUNT_1_BIT,                                        // VkSampleCountFlagBits                          rasterizationSamples
			  VK_FALSE,                                                     // VkBool32                                       sampleShadingEnable
			  1.0f,                                                         // float                                          minSampleShading
			  nullptr,                                                      // const VkSampleMask                            *pSampleMask
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
			  nullptr,                                                      // const void                                    *pNext
			  0,                                                            // VkPipelineColorBlendStateCreateFlags           flags
			  VK_FALSE,                                                     // VkBool32                                       logicOpEnable
			  VK_LOGIC_OP_COPY,                                             // VkLogicOp                                      logicOp
			  1,                                                            // uint32_t                                       attachmentCount
			  &color_blend_attachment_state,                                // const VkPipelineColorBlendAttachmentState     *pAttachments
			  { 0.0f, 0.0f, 0.0f, 0.0f }                                    // float                                          blendConstants[4]
			};


			// create graphics pipeline

			Tools::AutoDeleter<VkPipelineLayout, PFN_vkDestroyPipelineLayout> pipeline_layout = CreatePipelineLayout();
			if( !pipeline_layout ) {
			  return false;
			}

			VkGraphicsPipelineCreateInfo pipeline_create_info = {
			  VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO,              // VkStructureType                                sType
			  nullptr,                                                      // const void                                    *pNext
			  0,                                                            // VkPipelineCreateFlags                          flags
			  static_cast<uint32_t>(shader_stage_create_infos.size()),      // uint32_t                                       stageCount
			  &shader_stage_create_infos[0],                                // const VkPipelineShaderStageCreateInfo         *pStages
			  &vertex_input_state_create_info,                              // const VkPipelineVertexInputStateCreateInfo    *pVertexInputState;
			  &input_assembly_state_create_info,                            // const VkPipelineInputAssemblyStateCreateInfo  *pInputAssemblyState
			  nullptr,                                                      // const VkPipelineTessellationStateCreateInfo   *pTessellationState
			  &viewport_state_create_info,                                  // const VkPipelineViewportStateCreateInfo       *pViewportState
			  &rasterization_state_create_info,                             // const VkPipelineRasterizationStateCreateInfo  *pRasterizationState
			  &multisample_state_create_info,                               // const VkPipelineMultisampleStateCreateInfo    *pMultisampleState
			  nullptr,                                                      // const VkPipelineDepthStencilStateCreateInfo   *pDepthStencilState
			  &color_blend_state_create_info,                               // const VkPipelineColorBlendStateCreateInfo     *pColorBlendState
			  nullptr,                                                      // const VkPipelineDynamicStateCreateInfo        *pDynamicState
			  pipeline_layout.Get(),                                        // VkPipelineLayout                               layout
			  Vulkan.RenderPass,                                            // VkRenderPass                                   renderPass
			  0,                                                            // uint32_t                                       subpass
			  VK_NULL_HANDLE,                                               // VkPipeline                                     basePipelineHandle
			  -1                                                            // int32_t                                        basePipelineIndex
			};

			if( vkCreateGraphicsPipelines( GetDevice(), VK_NULL_HANDLE, 1, &pipeline_create_info, nullptr, &Vulkan.GraphicsPipeline ) != VK_SUCCESS ) {
			  printf( "Could not create graphics pipeline!\n" );
			}
		}

		Todotype createPipelineLayout() {
			VkPipelineLayoutCreateInfo layout_create_info = {
			  VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,  // VkStructureType                sType
			  nullptr,                                        // const void                    *pNext
			  0,                                              // VkPipelineLayoutCreateFlags    flags
			  0,                                              // uint32_t                       setLayoutCount
			  nullptr,                                        // const VkDescriptorSetLayout   *pSetLayouts
			  0,                                              // uint32_t                       pushConstantRangeCount
			  nullptr                                         // const VkPushConstantRange     *pPushConstantRanges
			};

			VkPipelineLayout pipeline_layout;
			if( vkCreatePipelineLayout( GetDevice(), &layout_create_info, nullptr, &pipeline_layout ) != VK_SUCCESS ) {
			  printf( "Could not create pipeline layout!\n" );
			  return Tools::AutoDeleter<VkPipelineLayout, PFN_vkDestroyPipelineLayout>();
			}

			return Tools::AutoDeleter<VkPipelineLayout, PFN_vkDestroyPipelineLayout>( pipeline_layout, vkDestroyPipelineLayout, GetDevice() );
		}
		+/
		
		
		
		// resource managment helpers
		void releaseRenderpassResources() {
			// TODO
		}
		
		// resource mangement helpers
		void releaseFramebufferResources() {
			// TODO
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

		// TODO



		// TODO< call next function for initialisation >
		//TODO();

	}
	
	protected final void checkForReleasedResourcesAndRelease() {
		// TODO
	}
}