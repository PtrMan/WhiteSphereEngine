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
import graphics.vulkan.abstraction.VulkanJsonReader;
import graphics.vulkan.resourceManagement.StackResourceAllocator;
import graphics.vulkan.VulkanResourceWithMemoryDecoration;
import graphics.vulkan.VulkanDecoratedMesh;

import common.ResourceDag;
import graphics.vulkan.resourceDag.VulkanResourceDagResource;

// API independent graphics classes
import graphics;

import math.Matrix44;
import linopterixed.linear.Matrix;
import linopterixed.linear.Vector;
import linopterixed.linear.MatrixCommonOperations;
import whiteSphereEngine.graphics.vulkan.Projection;
import math.VectorAlias;

alias Matrix!(float, 4, 4) Matrix44Type;


// some parts are from
// https://av.dfki.de/~jhenriques/development.html#tutorial_011
// (really copyleft as stated on the site)

class GraphicsVulkan {
	// calculate the size in bytes of a 4x4 matrix
	protected enum size_t SIZEOFMATRIXDATA = Matrix44Type.Type.sizeof * Matrix44Type.RAWDATALENGTH;
	
	
	
	
	public final this(ResourceDag resourceDag) {
		this.resourceDag = resourceDag;
	}
	
	public void setVulkanContext(VulkanContext vulkanContext) {
		this.vulkanContext = vulkanContext;
	}
	
	protected ResourceDag resourceDag;
	protected VulkanContext vulkanContext;

	private {
		TypesafeVkCommandBuffer setupCommandBuffer; // used for setup of images and such
		TypesafeVkFence setupCommandBufferFence; // fence to secure setupCommandBuffer
	}
	
	public final void initialisationEntry() {
		vulkanSetupRendering();
	}
	
	protected final void vulkanSetupRendering() {
		Matrix44Type projectionMatrix = new Matrix44Type();

		
		ResourceDag.ResourceNode[] framebufferImageViewsResourceNodes;
		ResourceDag.ResourceNode[] framebufferFramebufferResourceNodes;
		
		ResourceDag.ResourceNode renderPassReset;
		ResourceDag.ResourceNode renderPassDrawover;
		
		
		ResourceDag.ResourceNode pipelineResourceNode;
		ResourceDag.ResourceNode pipelineLayoutResourceNode;
		
		VulkanResourceWithMemoryDecoration!TypesafeVkImage framebufferImageResource = new VulkanResourceWithMemoryDecoration!TypesafeVkImage;
		
		TypesafeVkCommandBuffer[] commandBuffersForCopy; // no need to manage this with the resource dag, because we need it just once
		TypesafeVkCommandBuffer commandBufferForRendering;
		TypesafeVkCommandBuffer commandBufferForClear;
		
		
		

		VulkanResourceWithMemoryDecoration!TypesafeVkImage depthbufferImageResource = new VulkanResourceWithMemoryDecoration!TypesafeVkImage;
		TypesafeVkImageView depthBufferImageView;
		VkFormat depthImageFormat;


		// TODO< dictionary array for the staging images, indexed by format and size
		VulkanResourceWithMemoryDecoration!TypesafeVkImage textureStaging256ImageResource = new VulkanResourceWithMemoryDecoration!TypesafeVkImage;


		// texture for testing
		VulkanResourceWithMemoryDecoration!TypesafeVkImage testingTextureImageResource = new VulkanResourceWithMemoryDecoration!TypesafeVkImage;




		// calculate projection matrix
		{
			float near = 0.1f;
			float far = 5000.0f;
			float r = 1.0f;
			float t = 1.0f;
			projectionMatrix = .projectionMatrix!float(near, far, r, t);
		}



		
		// just for testing in here
		Mesh testMesh;
		
		
		
		// TODO< initialize this somewhere outside and only once >
		vkDevFacade = new VulkanDeviceFacade(vulkanContext.chosenDevice.logicalDevice);
		
		VulkanDecoratedMesh decoratedMeshes[];
		
		
		
		///VulkanResourceWithMemoryDecoration!TypesafeVkBuffer vboPositionBufferResource = new VulkanResourceWithMemoryDecoration!TypesafeVkBuffer;
		///VulkanResourceWithMemoryDecoration!TypesafeVkBuffer vboIndexBufferResource = new VulkanResourceWithMemoryDecoration!TypesafeVkBuffer;
		
		
		
		
		TypesafeVkSemaphore[] allocateSemaphores(size_t count) {
			TypesafeVkSemaphore[] resultSemaphores;
			foreach( i; 0..count) {
				resultSemaphores ~= vkDevFacade.createSemaphore();
			}
			return resultSemaphores;
		}
		
		void destroySemaphores(TypesafeVkSemaphore[] semaphores) {
			vkDevFacade.destroySemaphores(semaphores);
		}
		
		size_t semaphoresInitialAllocationSize = 5;
		StackResourceAllocator!TypesafeVkSemaphore chainingSemaphoreAllocator = new StackResourceAllocator!TypesafeVkSemaphore(&allocateSemaphores, &destroySemaphores, semaphoresInitialAllocationSize);
		scope(exit) {
			// before destruction of vulkan resources we have to ensure that the decive idles
			vkDeviceWaitIdle(vulkanContext.chosenDevice.logicalDevice);
			
			chainingSemaphoreAllocator.dispose();
		}




		void createDepthResources() {
			VkExtent3D depthImageExtent = {300, 300, 1};

			uint32_t graphicsQueueFamilyIndex = vulkanContext.queueManager.getDeviceQueueInfoByName("graphics").queueFamilyIndex;
			uint32_t presentQueueFamilyIndex = vulkanContext.queueManager.getDeviceQueueInfoByName("present").queueFamilyIndex;
			
			VkQueue graphicsQueue = vulkanContext.queueManager.getQueueByName("graphics");

			VkFormatFeatureFlagBits requiredDepthImageFormatFeatures =
				VK_FORMAT_FEATURE_DEPTH_STENCIL_ATTACHMENT_BIT;
			VkImageUsageFlagBits usageFlags =
				VK_IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT;
			
			// TODO< we have to handle things differently for formats with stencil
			//       TODO< investigate and test for cases where it has chosen the formats with stencil > >

			// search best format
			depthImageFormat = vulkanHelperFindBestFormatTryThrows(vulkanContext.chosenDevice.physicalDevice, [VK_FORMAT_D32_SFLOAT, VK_FORMAT_D32_SFLOAT_S8_UINT, VK_FORMAT_D24_UNORM_S8_UINT, ], requiredDepthImageFormatFeatures, "Depthbuffer");
			
			VulkanDeviceFacade.CreateImageArguments createImageArguments;
			createImageArguments.format = depthImageFormat;
			createImageArguments.extent = depthImageExtent;
			createImageArguments.usage = usageFlags;
			createImageArguments.queueFamilyIndexCount = 2;
			createImageArguments.pQueueFamilyIndices = cast(immutable(uint32_t)*)[graphicsQueueFamilyIndex, presentQueueFamilyIndex].ptr;
			
			depthbufferImageResource.resource = vkDevFacade.createImage(createImageArguments);

			/////
			// allocate and bind memory
			resourceQueryAllocateBind(depthbufferImageResource, VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT, "image");
			
			////////////////////
			// transition layout
			transitionImageLayout(depthbufferImageResource.resource.value, VK_IMAGE_ASPECT_DEPTH_BIT, VK_IMAGE_LAYOUT_UNDEFINED, VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL);


			VulkanDeviceFacade.CreateImageViewArguments createImageViewArguments = VulkanDeviceFacade.CreateImageViewArguments.make();
			with(createImageViewArguments) {
				flags = 0;
				image = depthbufferImageResource.resource.value;
				viewType = VK_IMAGE_VIEW_TYPE_2D;
				subresourceRange.aspectMask = VK_IMAGE_ASPECT_DEPTH_BIT;
				format = depthImageFormat;
			}

			depthBufferImageView = vkDevFacade.createImageView(createImageViewArguments);
		}

		void releaseDepthResources() {
			vkDevFacade.destroyImageView(depthBufferImageView);

			// TODO< release memory of depthbufferImageResource and destroy image >
		}


		void createRenderpass(JsonValue jsonValue, out ResourceDag.ResourceNode renderPassResourceNode) {
			VkResult vulkanResult;
			
			AttachmentDescriptionContext attachmentDescriptionContext; // helper which contains some context for the conversion of the attachment description for special json values
			attachmentDescriptionContext.depthFormat = depthImageFormat;
			
			VkAttachmentDescription[] attachmentDescriptions;
			foreach( iterationJsonValue; jsonValue["attachmentDescriptions"].array ) {
				attachmentDescriptions ~= convertForAtachmentDescription(iterationJsonValue, attachmentDescriptionContext);
			}
			
			VkSubpassDescription[] subpassDescriptions;
			foreach( iterationJsonValue; jsonValue["subpassDescriptions"].array ) {
				subpassDescriptions ~= convertForSubpassDescription(iterationJsonValue);
			}
			
			
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
		
		
		void createFramebuffer(ResourceDag.ResourceNode renderPassResourceNode) {
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

				VulkanDeviceFacade.CreateImageArguments createImageArguments;
				createImageArguments.format = framebufferImageFormat;
				createImageArguments.extent = framebufferImageExtent;
				createImageArguments.usage = usageFlags;
				createImageArguments.queueFamilyIndexCount = 2;
				createImageArguments.pQueueFamilyIndices = cast(immutable(uint32_t)*)[graphicsQueueFamilyIndex, presentQueueFamilyIndex].ptr;

				framebufferImageResource.resource = vkDevFacade.createImage(createImageArguments);
				
				/////
				// allocate and bind memory
				resourceQueryAllocateBind(framebufferImageResource, VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT, "image");
				
				////////////////////
				// transition layout
				transitionImageLayout(framebufferImageResource.resource.value, VK_IMAGE_ASPECT_COLOR_BIT, VK_IMAGE_LAYOUT_UNDEFINED, VK_IMAGE_LAYOUT_GENERAL);
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
					attachments = [imageViewForFramebuffer, depthBufferImageView];
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
		
		/+ uncommented because its incomplete
		void createDescriptorSetLayout() {
			VkDescriptorSetLayoutBinding uboLayoutBinding = VkDescriptorSetLayoutBinding.init;
			uboLayoutBinding.binding = 0;
			uboLayoutBinding.descriptorType = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
			uboLayoutBinding.descriptorCount = 1;
			uboLayoutBinding.stageFlags = VK_SHADER_STAGE_VERTEX_BIT;
			uboLayoutBinding.pImmutableSamplers = null; // Optional
			
			VkDescriptorSetLayout descriptorSetLayout;
			VkDescriptorSetLayoutCreateInfo layoutInfo = VkDescriptorSetLayoutCreateInfo.init;
			layoutInfo.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
			layoutInfo.bindingCount = 1;
			layoutInfo.pBindings = &uboLayoutBinding;

			if (!vkCreateDescriptorSetLayout(device, &layoutInfo, null, &descriptorSetLayout).vulkanSuccess) {
				throw new EngineException(true, true, "Couldn't create an descriptor set layout [vkCreateDescriptorSetLayout]!");
			}
			//scope(exit) vkDestroyDescriptorSetLayout(device, descriptorSetLayout, null);
			
			VkDescriptorSetLayout setLayouts[] = {descriptorSetLayout};
			VkPipelineLayoutCreateInfo pipelineLayoutInfo = {};
			pipelineLayoutInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
			pipelineLayoutInfo.setLayoutCount = cast(uint32_t)setLayouts.length;
			pipelineLayoutInfo.pSetLayouts = setLayouts.ptr;
			
			// TODO< remaining part 
		}+/
		
		
		void createPipelineWithRenderPass(JsonValue jsonValue, TypesafeVkRenderPass renderPass, out ResourceDag.ResourceNode pipelineResourceNode, out ResourceDag.ResourceNode pipelineLayoutResourceNode) {
			VkResult vulkanResult;
			
			VkPipelineLayout createPipelineLayout() {
				
				
				VkDescriptorSetLayout[] setLayouts;
				VkPushConstantRange[] pushConstantRanges;
				
				VkPushConstantRange pushConstantInfo = VkPushConstantRange.init;
				pushConstantInfo.stageFlags = VK_SHADER_STAGE_VERTEX_BIT;
				pushConstantInfo.offset = 0;
				pushConstantInfo.size = SIZEOFMATRIXDATA;
				
				pushConstantRanges ~= pushConstantInfo; // add push constant
				
				VkPipelineLayoutCreateInfo layoutCreateInfo = VkPipelineLayoutCreateInfo.init;
				with(layoutCreateInfo) {
					sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
					flags = 0;
					setLayoutCount = cast(uint32_t)setLayouts.length;
					pSetLayouts = cast(immutable(ulong)*)setLayouts.ptr;
					pushConstantRangeCount = cast(uint32_t)pushConstantRanges.length;
					pPushConstantRanges = cast(immutable(VkPushConstantRange)*)pushConstantRanges.ptr;
				};
				
				VkPipelineLayout pipelineLayout;
				vulkanResult = vkCreatePipelineLayout(vulkanContext.chosenDevice.logicalDevice, &layoutCreateInfo, null, &pipelineLayout);
				if( !vulkanSuccess(vulkanResult) ) {
					throw new EngineException(true, true, "Couldn't create pipeline layout! [vkCreatePipelineLayout]");
				}
				
				return pipelineLayout;
			}
			
			
			VkShaderModule vertexShaderModule, fragmentShaderModule;
			IDisposable vertexShaderMemory = loadShader(jsonValue["stages"]["vertex"].str, vulkanContext.chosenDevice.logicalDevice, VK_SHADER_STAGE_VERTEX_BIT, &vertexShaderModule);
			scope(exit) vertexShaderMemory.dispose();
			scope(exit) vkDestroyShaderModule(vulkanContext.chosenDevice.logicalDevice, vertexShaderModule, null);
			IDisposable fragmentShaderMemory = loadShader(jsonValue["stages"]["fragment"].str, vulkanContext.chosenDevice.logicalDevice, VK_SHADER_STAGE_FRAGMENT_BIT, &fragmentShaderModule);
			scope(exit) fragmentShaderMemory.dispose();
			scope(exit) vkDestroyShaderModule(vulkanContext.chosenDevice.logicalDevice, fragmentShaderModule, null);
			
			VkPipelineShaderStageCreateInfo[] shaderStageCreateInfo = [
				DevicelessFacade.makeVkPipelineShaderStageCreateInfo(vertexShaderModule, VK_SHADER_STAGE_VERTEX_BIT, "main"),
				DevicelessFacade.makeVkPipelineShaderStageCreateInfo(fragmentShaderModule, VK_SHADER_STAGE_FRAGMENT_BIT, "main")
			];
			
			
			
			// prepare description of input assembly
			VkPipelineInputAssemblyStateCreateInfo inputAssemblyStateCreateInfo = VkPipelineInputAssemblyStateCreateInfo.init;
			inputAssemblyStateCreateInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO;
			inputAssemblyStateCreateInfo.flags = 0;
			inputAssemblyStateCreateInfo.topology = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST;
			inputAssemblyStateCreateInfo.primitiveRestartEnable = VK_FALSE;
			
			
			
			VkViewport viewport = DevicelessFacade.makeVkViewport(SpatialVectorStruct!(2, float).make(cast(float)300, cast(float)300));
			
			VkRect2D scissor;
			scissor.offset = DevicelessFacade.makeVkOffset2D(0, 0);
			scissor.extent = DevicelessFacade.makeVkExtent2D(300, 300);
			
			VkViewport[1] viewports = [viewport];
			VkRect2D[1] scissors = [scissor];
			
			VkPipelineViewportStateCreateInfo viewportStateCreateInfo = VkPipelineViewportStateCreateInfo.init;
			with(viewportStateCreateInfo) {
				sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO;
				flags = 0;
				viewportCount = cast(uint32_t)viewports.length,
				pViewports = cast(immutable(VkViewport)*)viewports.ptr,
				scissorCount = cast(uint32_t)scissors.length;
				pScissors = cast(immutable(VkRect2D)*)scissors.ptr;
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

			VkPipelineDepthStencilStateCreateInfo depthStencilCreateInfo = VkPipelineDepthStencilStateCreateInfo.init;
			with(depthStencilCreateInfo) {
				sType = VK_STRUCTURE_TYPE_PIPELINE_DEPTH_STENCIL_STATE_CREATE_INFO;
				depthTestEnable = VK_TRUE;
				depthWriteEnable = VK_TRUE;
				depthCompareOp = VK_COMPARE_OP_LESS;
				depthBoundsTestEnable = VK_FALSE;
				minDepthBounds = 0.0f; // Optional
				maxDepthBounds = 1.0f; // Optional
				stencilTestEnable = VK_FALSE;
				front = VkStencilOpState.init; // Optional
				back = VkStencilOpState.init; // Optional
			}
			
			
			
			// create graphics pipeline
			TypesafeVkPipelineLayout pipelineLayout = createPipelineLayout();
			
			{ // setup resource node for pipelineLayout
				const(VkAllocationCallbacks*) allocator = null;
				
				VulkanResourceDagResource!TypesafeVkPipelineLayout pipelineLayoutDagResource = new VulkanResourceDagResource!TypesafeVkPipelineLayout(vkDevFacade, pipelineLayout, allocator, &disposePipelineLayout);
				/* out */pipelineLayoutResourceNode = resourceDag.createNode(pipelineLayoutDagResource);
				
				// TODO< make destruction of this dependend on destruction of renderpass ? >
				
				// we hold this because else the resourceDag would dispose them
				/*out */pipelineLayoutResourceNode.incrementExternalReferenceCounter();
			}
			
			
			
			
			VulkanDeviceFacade.CreateGraphicsPipelineArguments createGraphicsPipelineArguments = VulkanDeviceFacade.CreateGraphicsPipelineArguments.init;
			with(createGraphicsPipelineArguments) {
				flags = 0;
				stages = shaderStageCreateInfo;
				vertexInputState = convertForPipelineVertexInputState(jsonValue["vertexInputState"]);
				inputAssemblyState = inputAssemblyStateCreateInfo;
				tessellationState = null;
				viewportState = viewportStateCreateInfo;
				rasterizationState = convertForPipelineRasterizationStateCreateInfo(jsonValue["rasterizationState"]);
				multisampleState = multisampleStateCreateInfo;
				depthStencilState = depthStencilCreateInfo;
				colorBlendState = convertForPipelineColorBlendStateCreateInfo(jsonValue["colorBlendState"]);
				dynamicState = null;
				
				layout = pipelineLayout;
				
				// all others are default
			}
			createGraphicsPipelineArguments.renderPass = renderPass;
			
			
			const(VkAllocationCallbacks*) allocator = null;
			TypesafeVkPipeline createdGraphicsPipeline = vkDevFacade.createGraphicsPipeline(createGraphicsPipelineArguments, allocator);
			
			
			VulkanResourceDagResource!TypesafeVkPipeline pipelineDagResource = new VulkanResourceDagResource!TypesafeVkPipeline(vkDevFacade, createdGraphicsPipeline, allocator, &disposePipeline);
			
			/* out */pipelineResourceNode = resourceDag.createNode(pipelineDagResource);
			
			// we hold this because else the resourceDag would dispose them
			/* out */pipelineResourceNode.incrementExternalReferenceCounter();
		}
		
		
		//
		void refillCommandBufferForTransform(Matrix44Type mvpMatrix) {
			VkResult vulkanResult;
			
			VkClearValue clearValues[2];
			clearValues[0].color.float32 = [ 1.0f, 0.8f, 0.4f, 0.0f ];
			clearValues[1].depthStencil.depth = 1.0f;
			clearValues[1].depthStencil.stencil = 0;
			
			
			TypesafeVkRenderPass renderPassDrawover = (cast(VulkanResourceDagResource!TypesafeVkRenderPass)renderPassDrawover.resource).resource;
			
			TypesafeVkPipeline graphicsPipeline = (cast(VulkanResourceDagResource!TypesafeVkPipeline)pipelineResourceNode.resource).resource;
			
			TypesafeVkPipelineLayout pipelineLayout = (cast(VulkanResourceDagResource!TypesafeVkPipelineLayout)pipelineLayoutResourceNode.resource).resource;
			
			VkCommandBufferBeginInfo graphicsCommandBufferBeginInfo = VkCommandBufferBeginInfo.init;
			with(graphicsCommandBufferBeginInfo) {
				sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
				flags = VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT;
				pInheritanceInfo = null;
			}
			
				// for actual rendering
			{ // to scope command buffer filling
				vkBeginCommandBuffer(cast(VkCommandBuffer)commandBufferForRendering, &graphicsCommandBufferBeginInfo);
				scope(success) {
					if( !vkEndCommandBuffer(cast(VkCommandBuffer)commandBufferForRendering).vulkanSuccess ) {
						throw new EngineException(true, true, "Couldn't record command buffer [vkEndCommandBuffer]");
					}
				} 
				
				TypesafeVkFramebuffer framebuffer = (cast(VulkanResourceDagResource!TypesafeVkFramebuffer)framebufferFramebufferResourceNodes[0].resource).resource;
				
				VkRenderPassBeginInfo renderPassBeginInfo = VkRenderPassBeginInfo.init;
				with(renderPassBeginInfo) {
					sType = VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO;
					renderArea.offset = DevicelessFacade.makeVkOffset2D(0, 0);
					renderArea.extent = DevicelessFacade.makeVkExtent2D(300, 300);
					clearValueCount = cast(uint32_t)clearValues.length;
					pClearValues = cast(immutable(VkClearValue)*)&clearValues;
				}
				renderPassBeginInfo.renderPass = cast(VkRenderPass)renderPassDrawover;
				renderPassBeginInfo.framebuffer = cast(VkFramebuffer)framebuffer;
				
				
				vkCmdBeginRenderPass(cast(VkCommandBuffer)commandBufferForRendering, &renderPassBeginInfo, VK_SUBPASS_CONTENTS_INLINE);
				
				vkCmdBindPipeline(cast(VkCommandBuffer)commandBufferForRendering, VK_PIPELINE_BIND_POINT_GRAPHICS, cast(VkPipeline)graphicsPipeline);
				
				// for testing we render the first decorated mesh
				VulkanDecoratedMesh currentDecoratedMeshToRender = decoratedMeshes[0];
				
				VkBuffer[1] vertexBuffersToBind = [cast(VkBuffer)currentDecoratedMeshToRender.decoration.vbosOfBuffers[0].resource.value];
				VkDeviceSize[1] offsets = [0];
				assert(vertexBuffersToBind.length == offsets.length);
				vkCmdBindVertexBuffers(cast(VkCommandBuffer)commandBufferForRendering, 0, vertexBuffersToBind.length, vertexBuffersToBind.ptr, offsets.ptr);
				
				float[16] mvpArray;
				import math.ConvertMatrix;
				mvpMatrix.translateToArrayColumRow!(float, 4, 4)(mvpArray);

				vkCmdPushConstants(cast(VkCommandBuffer)commandBufferForRendering, cast(VkPipelineLayout)pipelineLayout, VK_SHADER_STAGE_VERTEX_BIT, 0, SIZEOFMATRIXDATA, cast(immutable(void)*)mvpArray.ptr);
				
				if( currentDecoratedMeshToRender.decoratedMesh.indexBufferMeshComponent.dataType == AbstractMeshComponent.EnumDataType.UINT32 ) {
					vkCmdBindIndexBuffer(cast(VkCommandBuffer)commandBufferForRendering, cast(VkBuffer)currentDecoratedMeshToRender.decoration.vboIndexBufferResource.resource.value, 0, VK_INDEX_TYPE_UINT32);
				}
				else {
					throw new EngineException(true, true, "Vulkan Renderer - index buffer not implemented for non-uint32bit !");
				}
				
				vkCmdDrawIndexed(cast(VkCommandBuffer)commandBufferForRendering, currentDecoratedMeshToRender.decoratedMesh.indexBufferMeshComponent.length, 1, 0, 0, 0);
				
				
				vkCmdEndRenderPass(cast(VkCommandBuffer)commandBufferForRendering);
			}
			
		}

		void createTextureImage() {
			VkFormat stagingFormat = VK_FORMAT_R8G8B8A8_UNORM;// TODO< search for format which the GPU supports, we take R8G8B8A8_UNORM because a lot of cards should support it by default >
			VkFormat textureFormat = VK_FORMAT_R8G8B8A8_UNORM;// TODO< search for format which the GPU supports, we take R8G8B8A8_UNORM because a lot of cards should support it by default >

			uint32_t graphicsQueueFamilyIndex = vulkanContext.queueManager.getDeviceQueueInfoByName("graphics").queueFamilyIndex;

			// create staging image
			{
				VkExtent3D imageExtent = {256, 256, 1};

				VulkanDeviceFacade.CreateImageArguments createImageArguments;
				createImageArguments.format = stagingFormat; 
				createImageArguments.extent = imageExtent;
				createImageArguments.tiling = VK_IMAGE_TILING_LINEAR; // because we use this image for staging
				createImageArguments.usage = VK_IMAGE_USAGE_TRANSFER_SRC_BIT; // because we use it for staging
				createImageArguments.sharingMode = VK_SHARING_MODE_EXCLUSIVE;
				
				createImageArguments.queueFamilyIndexCount = 1;
				createImageArguments.pQueueFamilyIndices = cast(immutable(uint32_t)*)[graphicsQueueFamilyIndex,].ptr;
				createImageArguments.initialLayout = VK_IMAGE_LAYOUT_PREINITIALIZED;
				
				textureStaging256ImageResource.resource = vkDevFacade.createImage(createImageArguments);
			}
			

			/////
			// allocate and bind memory
			resourceQueryAllocateBind(textureStaging256ImageResource, VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT | VK_MEMORY_PROPERTY_HOST_COHERENT_BIT, "image");
			
			// map, copy texture data into staging memory, unmap
			{ // scope to automatically unmap
				void *hostPtr = vkDevFacade.map(
					textureStaging256ImageResource.derivedInformation.value.allocatorForResource.deviceMemory,
					textureStaging256ImageResource.derivedInformation.value.offset,
					textureStaging256ImageResource.derivedInformation.value.allocatedSize,
					0 /* flags */
				);
				scope(exit) vkDevFacade.unmap(textureStaging256ImageResource.derivedInformation.value.allocatorForResource.deviceMemory);
				
				ubyte* textureUbytePtr = cast(ubyte*)hostPtr;
				// TODO< fill with memory >
			}



			// create the real image
			{
				VkExtent3D imageExtent = {256, 256, 1};

				VulkanDeviceFacade.CreateImageArguments createImageArguments;
				createImageArguments.format = textureFormat;
				createImageArguments.extent = imageExtent;
				createImageArguments.usage = VK_IMAGE_USAGE_TRANSFER_DST_BIT | VK_IMAGE_USAGE_SAMPLED_BIT;
				createImageArguments.sharingMode = VK_SHARING_MODE_EXCLUSIVE;

				createImageArguments.queueFamilyIndexCount = 1;
				createImageArguments.pQueueFamilyIndices = cast(immutable(uint32_t)*)[graphicsQueueFamilyIndex,].ptr;
				createImageArguments.initialLayout = VK_IMAGE_LAYOUT_PREINITIALIZED;

				testingTextureImageResource.resource = vkDevFacade.createImage(createImageArguments);
			}

			/////
			// allocate and bind memory
			resourceQueryAllocateBind(testingTextureImageResource, VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT, "image");
			


			/////
			// now we do the transitions, copy it, and do the other transitions

			transitionImageLayout(textureStaging256ImageResource.resource.value, VK_IMAGE_ASPECT_COLOR_BIT, VK_IMAGE_LAYOUT_PREINITIALIZED, VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL);
			transitionImageLayout(testingTextureImageResource.resource.value, VK_IMAGE_ASPECT_COLOR_BIT, VK_IMAGE_LAYOUT_PREINITIALIZED, VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL);

			CommandCopyImageArguments commandCopyImageArguments;
			with(commandCopyImageArguments) {
				sourceImage = textureStaging256ImageResource.resource.value;
				destinationImage = testingTextureImageResource.resource.value;
				sourceImageLayout = VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL;
				destinationImageLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
				extent = Vector2ui.make(256, 256);
			}
			copyImage(commandCopyImageArguments);



			// to be able to sample from it we need one more transition
			transitionImageLayout(testingTextureImageResource.resource.value, VK_IMAGE_ASPECT_COLOR_BIT, VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL);

			// and we need to transition the layout of the staging image back to VK_IMAGE_LAYOUT_PREINITIALIZED for the next transfer
			transitionImageLayout(textureStaging256ImageResource.resource.value, VK_IMAGE_ASPECT_COLOR_BIT, VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL, VK_IMAGE_LAYOUT_PREINITIALIZED);
		}
		
		// function just for the example code, needs to get refactored later
		void recordingCommandBuffers() {
			VkResult vulkanResult;
			
			VkCommandBufferBeginInfo graphicsCommandBufferBeginInfo = VkCommandBufferBeginInfo.init;
			with(graphicsCommandBufferBeginInfo) {
				sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
				flags = VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT;
				pInheritanceInfo = null;
			}
			
			VkImageSubresourceRange imageSubresourceRange;
			with(imageSubresourceRange) {
				aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
				baseMipLevel = 0;
				levelCount = 1;
				baseArrayLayer = 0;
				layerCount = 1;
			}

			VkClearValue clearValues[2];
			clearValues[0].color.float32 = [ 1.0f, 0.8f, 0.4f, 0.0f ];
			clearValues[1].depthStencil.depth = 1.0f;
			clearValues[1].depthStencil.stencil = 0;

			
			uint32_t graphicsQueueFamilyIndex = vulkanContext.queueManager.getDeviceQueueInfoByName("graphics").queueFamilyIndex;
			uint32_t presentQueueFamilyIndex = vulkanContext.queueManager.getDeviceQueueInfoByName("present").queueFamilyIndex;
			VkQueue graphicsQueue = vulkanContext.queueManager.getQueueByName("graphics");
			VkQueue presentQueue = vulkanContext.queueManager.getQueueByName("present");
			
			TypesafeVkRenderPass renderPassReset = (cast(VulkanResourceDagResource!TypesafeVkRenderPass)renderPassReset.resource).resource;
			TypesafeVkRenderPass renderPassDrawover = (cast(VulkanResourceDagResource!TypesafeVkRenderPass)renderPassDrawover.resource).resource;
			
			TypesafeVkPipeline graphicsPipeline = (cast(VulkanResourceDagResource!TypesafeVkPipeline)pipelineResourceNode.resource).resource;

			foreach( i; 0..commandBuffersForCopy.length ) {
				vkBeginCommandBuffer(cast(VkCommandBuffer)commandBuffersForCopy[i], &graphicsCommandBufferBeginInfo);
				
				/* uncommented because its impossible to test with this hardware of the developer ;)
				if( presentQueue != graphicsQueue ) {
					VkImageMemoryBarrier barrier_from_present_to_draw = VkImageMemoryBarrier.init
					
					with(barrier_from_present_to_draw) {
						sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
						pNext = null;
						srcAccessMask = VK_ACCESS_MEMORY_READ_BIT;
						dstAccessMask = VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;
						oldLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;
						newLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;
						srcQueueFamilyIndex = presentQueueFamilyIndex;
						dstQueueFamilyIndex = graphicsQueueFamilyIndex;
						image = swap_chain_images[i];
						subresourceRange = image_subresource_range;
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
				
				VkClearColorValue clearColor;
				clearColor.float32 = [1.0f, 0.8f, 0.4f, 0.0f];
				
				
				vkCmdPipelineBarrier(cast(VkCommandBuffer)commandBuffersForCopy[i], VK_PIPELINE_STAGE_TRANSFER_BIT, VK_PIPELINE_STAGE_TRANSFER_BIT, 0, 0, null, 0, null, 1, &barrierFromPresentToClear);
				vkCmdClearColorImage(cast(VkCommandBuffer)commandBuffersForCopy[i], vulkanContext.swapChain.swapchainImages[i], VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, &clearColor, 1, &imageSubresourceRangeForCopy);

				CommandCopyImageArguments commandCopyImageArguments;
				with(commandCopyImageArguments) {
					sourceImage = framebufferImageResource.resource.value;
					destinationImage = cast(TypesafeVkImage)vulkanContext.swapChain.swapchainImages[i];
					sourceImageLayout = VK_IMAGE_LAYOUT_GENERAL;
					destinationImageLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
					extent = Vector2ui.make(300, 300);
				}
				commandCopyImage(commandBuffersForCopy[i], commandCopyImageArguments);
				
				vkCmdPipelineBarrier(cast(VkCommandBuffer)commandBuffersForCopy[i], VK_PIPELINE_STAGE_TRANSFER_BIT, VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT, 0, 0, null, 0, null, 1, &barrierFromClearToPresent);
				
				
				
				
				if( vkEndCommandBuffer(cast(VkCommandBuffer)commandBuffersForCopy[i]) != VK_SUCCESS ) {
					throw new EngineException(true, true, "Couldn't record command buffer [vkEndCommandBuffer]");
				}
			}
			
			
			
			
			{ // for clearing the screen
				vkBeginCommandBuffer(cast(VkCommandBuffer)commandBufferForClear, &graphicsCommandBufferBeginInfo);
				scope(success) {
					if( vkEndCommandBuffer(cast(VkCommandBuffer)commandBufferForClear) != VK_SUCCESS ) {
						throw new EngineException(true, true, "Couldn't record command buffer [vkEndCommandBuffer]");
					}
				} 
				
				TypesafeVkFramebuffer framebuffer = (cast(VulkanResourceDagResource!TypesafeVkFramebuffer)framebufferFramebufferResourceNodes[0].resource).resource;
				
				VkRenderPassBeginInfo renderPassBeginInfo = VkRenderPassBeginInfo.init;
				with(renderPassBeginInfo) {
					sType = VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO;
					renderArea.offset = DevicelessFacade.makeVkOffset2D(0, 0);
					renderArea.extent = DevicelessFacade.makeVkExtent2D(300, 300);
					clearValueCount = cast(uint32_t)clearValues.length;
					pClearValues = cast(immutable(VkClearValue)*)&clearValues;
				}
				renderPassBeginInfo.renderPass = cast(VkRenderPass)renderPassReset;
				renderPassBeginInfo.framebuffer = cast(VkFramebuffer)framebuffer;
				
				
				vkCmdBeginRenderPass(cast(VkCommandBuffer)commandBufferForClear, &renderPassBeginInfo, VK_SUBPASS_CONTENTS_INLINE);
				vkCmdBindPipeline(cast(VkCommandBuffer)commandBufferForClear, VK_PIPELINE_BIND_POINT_GRAPHICS, cast(VkPipeline)graphicsPipeline);
				
				vkCmdEndRenderPass(cast(VkCommandBuffer)commandBufferForClear);
			}
			
			
			
			
			
			TypesafeVkPipelineLayout pipelineLayout = (cast(VulkanResourceDagResource!TypesafeVkPipelineLayout)pipelineLayoutResourceNode.resource).resource;

			/+ uncommented because its done by the rebuildCommandBuffer??() method
			// for actual rendering
			{ // to scope command buffer filling
				vkBeginCommandBuffer(cast(VkCommandBuffer)commandBufferForRendering, &graphicsCommandBufferBeginInfo);
				scope(success) {
					if( vkEndCommandBuffer(cast(VkCommandBuffer)commandBufferForRendering) != VK_SUCCESS ) {
						throw new EngineException(true, true, "Couldn't record command buffer [vkEndCommandBuffer]");
					}
				} 
				
				TypesafeVkFramebuffer framebuffer = (cast(VulkanResourceDagResource!TypesafeVkFramebuffer)framebufferFramebufferResourceNodes[0].resource).resource;
				
				VkRenderPassBeginInfo renderPassBeginInfo = VkRenderPassBeginInfo.init;
				with(renderPassBeginInfo) {
					sType = VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO;
					renderArea.offset = DevicelessFacade.makeVkOffset2D(0, 0);
					renderArea.extent = DevicelessFacade.makeVkExtent2D(300, 300);
					clearValueCount = cast(uint32_t)1;
					pClearValues = cast(immutable(VkClearValue)*)&clear_value;
				}
				renderPassBeginInfo.renderPass = cast(VkRenderPass)renderPassDrawover;
				renderPassBeginInfo.framebuffer = cast(VkFramebuffer)framebuffer;
				
				
				vkCmdBeginRenderPass(cast(VkCommandBuffer)commandBufferForRendering, &renderPassBeginInfo, VK_SUBPASS_CONTENTS_INLINE);
				
				vkCmdBindPipeline(cast(VkCommandBuffer)commandBufferForRendering, VK_PIPELINE_BIND_POINT_GRAPHICS, cast(VkPipeline)graphicsPipeline);
				
				VkBuffer[1] vertexBuffersToBind = [cast(VkBuffer)vboPositionBufferResource.resource.value];
				VkDeviceSize[1] offsets = [0];
				assert(vertexBuffersToBind.length == offsets.length);
				vkCmdBindVertexBuffers(cast(VkCommandBuffer)commandBufferForRendering, 0, vertexBuffersToBind.length, vertexBuffersToBind.ptr, offsets.ptr);
				
				vkCmdPushConstants(cast(VkCommandBuffer)commandBufferForRendering, cast(VkPipelineLayout)pipelineLayout, VK_SHADER_STAGE_VERTEX_BIT, 0, SIZEOFMATRIXDATA, mvpMatrix.ptr);
				
				if( testMesh.indexBufferMeshComponent.dataType == AbstractMeshComponent.EnumDataType.UINT32 ) {
					vkCmdBindIndexBuffer(cast(VkCommandBuffer)commandBufferForRendering, cast(VkBuffer)vboIndexBufferResource.resource.value, 0, VK_INDEX_TYPE_UINT32);
				}
				else {
					throw new EngineException(true, true, "Vulkan Renderer - index buffer not implemented for non-uint32bit !");
				}
				
				vkCmdDrawIndexed(cast(VkCommandBuffer)commandBufferForRendering, testMesh.indexBufferMeshComponent.length, 1, 0, 0, 0);
				
				
				vkCmdEndRenderPass(cast(VkCommandBuffer)commandBufferForRendering);
			}+/

		}
		
		void loop() {
			VkResult vulkanResult;
			
			Matrix44Type mvpMatrix;
			// fill mvp with identity
			mvpMatrix = createIdentity!float();
			
			
			uint semaphorePairIndex = 0;
			do {
				chainingSemaphoreAllocator.reset();
				
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
				
				
				TypesafeVkSemaphore chainSemaphore1 = chainingSemaphoreAllocator.allocateOne();
				
				
				
				TypesafeVkSemaphore[2] doublebufferedChainSemaphores = [chainingSemaphoreAllocator.allocateOne(), chainingSemaphoreAllocator.allocateOne()];
				size_t doublebufferedChainSemaphoresIndex = 0;
				
				
				{ // do clearing work and wait for it
					VkPipelineStageFlags[1] waitDstStageMasks = [VK_PIPELINE_STAGE_ALL_GRAPHICS_BIT];
					TypesafeVkSemaphore[1] waitSemaphores = [cast(TypesafeVkSemaphore)vulkanContext.swapChain.semaphorePairs[semaphorePairIndex].chainSemaphore];
					TypesafeVkSemaphore[1] signalSemaphores = [doublebufferedChainSemaphores[0]];
					TypesafeVkCommandBuffer[1] commandBuffers = [cast(TypesafeVkCommandBuffer)commandBufferForClear];
					DevicelessFacade.queueSubmit(
						cast(TypesafeVkQueue)vulkanContext.queueManager.getQueueByName("graphics"),
						waitSemaphores, signalSemaphores, commandBuffers, waitDstStageMasks,
						cast(TypesafeVkFence)vulkanContext.swapChain.context.additionalFence
					);
					vkDevFacade.fenceWaitAndReset(cast(TypesafeVkFence)vulkanContext.swapChain.context.additionalFence);
				}
				
				
				//TypesafeVkSemaphore chainSemaphore2 = chainingSemaphoreAllocator.allocateOne();
				
				Matrix44Type modelMatrix = createTranslation!float(0.0f, 0.0f, -1.5f);//uncommented because we want to test projection  createIdentity!float();

				// a testloop to draw two times
				foreach( iteration; 0..2) {
					mvpMatrix = new Matrix44Type;
					mul(projectionMatrix, modelMatrix, mvpMatrix);

					refillCommandBufferForTransform(mvpMatrix);
					
					VkPipelineStageFlags[1] waitDstStageMasks = [VK_PIPELINE_STAGE_ALL_GRAPHICS_BIT];
					TypesafeVkSemaphore[1] waitSemaphores = [doublebufferedChainSemaphores[doublebufferedChainSemaphoresIndex % 2]];
					TypesafeVkSemaphore[1] signalSemaphores = [doublebufferedChainSemaphores[(doublebufferedChainSemaphoresIndex+1) % 2]];
					TypesafeVkCommandBuffer[1] commandBuffers = [cast(TypesafeVkCommandBuffer)commandBufferForRendering];
					DevicelessFacade.queueSubmit(
						cast(TypesafeVkQueue)vulkanContext.queueManager.getQueueByName("graphics"),
						waitSemaphores, signalSemaphores, commandBuffers, waitDstStageMasks,
						cast(TypesafeVkFence)vulkanContext.swapChain.context.additionalFence
					);
					vkDevFacade.fenceWaitAndReset(cast(TypesafeVkFence)vulkanContext.swapChain.context.additionalFence);
					
					
					doublebufferedChainSemaphoresIndex++; // doublebufferedCahinSemaphores.swap();
				
					// we do it here so the transformation for the 2nd draw should be different
					// uncommented to seperate effects modelMatrix = createRotationZ!float(0.2f);
				}

				
				
				TypesafeVkSemaphore chainSemaphore3 = chainingSemaphoreAllocator.allocateOne();
				
				
				{ // do copy
					VkPipelineStageFlags[1] waitDstStageMasks = [VK_PIPELINE_STAGE_TRANSFER_BIT];
					TypesafeVkSemaphore[1] waitSemaphores = [doublebufferedChainSemaphores[doublebufferedChainSemaphoresIndex % 2]];
					TypesafeVkSemaphore[1] signalSemaphores = [chainSemaphore3];
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
					cast(VkSemaphore)chainSemaphore3,
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
		static void releaseResourceNodes(ResourceDag.ResourceNode[] resourceNodes) {
			foreach( iterationResourceNode; resourceNodes ) {
				iterationResourceNode.decrementExternalReferenceCounter();
			}
		}

		
		
		void releaseFramebufferResources() {
			scope(exit) vkDevFacade.destroyImage(framebufferImageResource.resource.value);
			
			scope(exit) releaseResourceNodes(framebufferImageViewsResourceNodes);
		}
		
		
		
		
		
		
		scope(exit) checkForReleasedResourcesAndRelease();
		
		
		
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
		// create test texture
		//////////////////
		createTextureImage();


		//////////////////
		// create depth resources
		//////////////////
		createDepthResources();
		scope(exit) releaseDepthResources();
		
		
		
		
		
		//////////////////
		// create renderPasses
		//////////////////
		
		{
			string path = "resources/engine/graphics/configuration/preset/renderpassResetWithdepth.json";
			JsonValue jsonValue = readJsonEngineResource(path);
			createRenderpass(jsonValue, /*out*/ renderPassReset);
		}
		scope(exit) releaseResourceNodes([renderPassReset]);
		
		{
			string path = "resources/engine/graphics/configuration/preset/renderpassDrawoverWithdepth.json";
			JsonValue jsonValue = readJsonEngineResource(path);
			createRenderpass(jsonValue, /*out*/ renderPassDrawover);
		}
		scope(exit) releaseResourceNodes([renderPassDrawover]);
		
		
		/////////////////
		// create framebuffer
		/////////////////

		// we only give it the renderPass of the reset because 
		// renderPass for the reset and the actually drawing are comptible to each other
		createFramebuffer(renderPassReset);
		scope(exit) releaseFramebufferResources();
		
		
		
		//////////////////
		// create graphics pipeline
		//////////////////

		{
			string path = "resources/engine/graphics/configuration/preset/pipelineReset.json";
			JsonValue jsonValue = readJsonEngineResource(path);
			createPipelineWithRenderPass(
				jsonValue,
				(cast(VulkanResourceDagResource!TypesafeVkRenderPass)renderPassReset.resource).resource,
				/*out*/ pipelineResourceNode,
				/*out*/ pipelineLayoutResourceNode
			);
			
			// TODO TODO TODO< look for hardcoded uses of
			// -renderpass
			// -pipeline
			// -other things in regards to renderpass and pipeline
			// and rewrite it so its more flexible and works fine with multiple renderpasses/pipelines
			
		}
		scope(exit) releaseResourceNodes([pipelineLayoutResourceNode, pipelineResourceNode]);
		
		
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
		
		commandBufferForClear = vkDevFacade.allocateCommandBuffer(cast(TypesafeVkCommandPool)vulkanContext.commandPoolsByQueueName["graphics"].value);
		scope(exit) {
			// before destruction of vulkan resources we have to ensure that the decive idles
			vkDeviceWaitIdle(vulkanContext.chosenDevice.logicalDevice);
			
			vkDevFacade.freeCommandBuffer(commandBufferForClear, cast(TypesafeVkCommandPool)vulkanContext.commandPoolsByQueueName["graphics"].value);
		}
		
		
		//////////////////
		// allocate and bind resources
		
		// binding must happen before the filling of the command buffers
		
		{ // build mesh
			SpatialVectorStruct!(4, float)[] positions;
			positions.length = 4;
			// on screen:                                 y       x
			positions[0] = SpatialVectorStruct!(4, float).make(-1.0f, 0.0f, 0, 1.0f);
			positions[1] = SpatialVectorStruct!(4, float).make(1.0f,  1.0f, 0, 1.0f);
			positions[2] = SpatialVectorStruct!(4, float).make(1.0f,  0.0f, 0, 1.0f);
			positions[3] = SpatialVectorStruct!(4, float).make(1.0f, 1.0f, 0, 1.0f);
			
			
			//uint32_t[] indexBuffer = [0, 1, 2, 1, 2, 3];
			uint32_t[] indexBuffer = [0, 1, 2, 3, 1, 2];
			
			
			// translate to MeshComponent
			
			AbstractMeshComponent componentPosition = toImmutableMeshComponent(positions);
			AbstractMeshComponent componentIndex = ImmutableMeshComponent.makeUint32(indexBuffer);
			
			testMesh = new Mesh([componentPosition], componentIndex, 0);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		// create decorated mesh from mesh and add it
		import std.stdio;
		writeln("!");
		
		VulkanDecoratedMesh createdDecoratedMesh = createDecoratedMesh(testMesh);
		writeln("!!");
		decoratedMeshes ~= createdDecoratedMesh;
		
		
		
		scope(success) {
			// before destruction of vulkan resources we have to ensure that the decive idles
		    vkDeviceWaitIdle(vulkanContext.chosenDevice.logicalDevice);
			
			foreach( iterationDecoratedMesh; decoratedMeshes ) {
				iterationDecoratedMesh.decoration.dispose(vkDevFacade, vulkanContext);
			}
			decoratedMeshes.length = 0;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		//////////////////
		// record command buffers
		
		recordingCommandBuffers();
		
		
		
		
		
		


		// TODO< call next function for initialisation >
		//TODO();
		loop();
	}
	
	
	
	public final VulkanDecoratedMesh createDecoratedMesh(Mesh mesh) {
		VulkanDecoratedMesh resultDecoratedMesh = new VulkanDecoratedMesh(mesh);
		
		resultDecoratedMesh.decoration = new VulkanMeshDecoration();
		
		resultDecoratedMesh.decoration.vbosOfBuffers.length = mesh.numberOfComponents;
		
		// create objects
		foreach( componentIndex; 0..mesh.numberOfComponents ) {
			resultDecoratedMesh.decoration.vbosOfBuffers[componentIndex] = new VulkanResourceWithMemoryDecoration!TypesafeVkBuffer();
		}
		resultDecoratedMesh.decoration.vboIndexBufferResource = new VulkanResourceWithMemoryDecoration!TypesafeVkBuffer();
		
		// create buffer & & map & fill & bind for components
		foreach( componentIndex; 0..mesh.numberOfComponents ) {
			VulkanResourceWithMemoryDecoration!TypesafeVkBuffer resourceWithMemoryDecoration = resultDecoratedMesh.decoration.vbosOfBuffers[componentIndex];
			
			/////
			// create buffer and fill
			VulkanDeviceFacade.CreateBufferArguments createBufferArguments = VulkanDeviceFacade.CreateBufferArguments.init;
			createBufferArguments.size = /*vertex.sizeof*/16   * mesh.numberOfVertices;
			createBufferArguments.usage = VK_BUFFER_USAGE_VERTEX_BUFFER_BIT;
			createBufferArguments.sharingMode = VK_SHARING_MODE_EXCLUSIVE;
			resourceWithMemoryDecoration.resource = vkDevFacade.createBuffer(createBufferArguments);
			
			
			resourceQueryAllocate(resultDecoratedMesh.decoration.vbosOfBuffers[componentIndex], VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT, "buffer");
			
			/////
			// map & bind
			
			// map and copy vertex
			{ // scope to automatically unmap
				void *hostPtr = vkDevFacade.map(
					resourceWithMemoryDecoration.derivedInformation.value.allocatorForResource.deviceMemory,
					resourceWithMemoryDecoration.derivedInformation.value.offset,
					resourceWithMemoryDecoration.derivedInformation.value.allocatedSize,
					0 /* flags */
				);
				scope(exit) vkDevFacade.unmap(resourceWithMemoryDecoration.derivedInformation.value.allocatorForResource.deviceMemory);
				
				float[4]* float4HostPtr = cast(float[4]*)hostPtr;
				foreach( vertexI; 0..mesh.numberOfVertices ) {
					float4HostPtr[vertexI] = mesh.getFloat4AccessorByComponentIndex(0)[vertexI];
				}
			}
			
			vkDevFacade.bind(resourceWithMemoryDecoration.resource.value, resourceWithMemoryDecoration.derivedInformation.value.allocatorForResource.deviceMemory, resourceWithMemoryDecoration.derivedInformation.value.offset);
		}
		
		
		
		
		
		
		
		
		VulkanResourceWithMemoryDecoration!TypesafeVkBuffer vboIndexBufferResource = resultDecoratedMesh.decoration.vboIndexBufferResource;
		
		/////
		// create buffer & & map & fill & bind for index information
		{
			VulkanDeviceFacade.CreateBufferArguments createBufferArguments = VulkanDeviceFacade.CreateBufferArguments.init;
			createBufferArguments.size = uint32_t.sizeof * mesh.indexBufferMeshComponent.length;
			createBufferArguments.usage = VK_BUFFER_USAGE_INDEX_BUFFER_BIT;
			createBufferArguments.sharingMode = VK_SHARING_MODE_EXCLUSIVE;
			vboIndexBufferResource.resource = vkDevFacade.createBuffer(createBufferArguments);
		}
		
		resourceQueryAllocate(vboIndexBufferResource, VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT, "buffer");
		
		
		// map and copy index buffer
		{ // scope to automatically unmap
			void *hostPtr = vkDevFacade.map(
				vboIndexBufferResource.derivedInformation.value.allocatorForResource.deviceMemory,
				vboIndexBufferResource.derivedInformation.value.offset,
				vboIndexBufferResource.derivedInformation.value.allocatedSize,
				0 /* flags */
			);
			scope(exit) vkDevFacade.unmap(vboIndexBufferResource.derivedInformation.value.allocatorForResource.deviceMemory);
			
			uint32_t* uint32HostPtr = cast(uint32_t*)hostPtr;
			foreach( indexBufferI; 0..mesh.indexBufferMeshComponent.length ) {
				uint32HostPtr[indexBufferI] = mesh.indexBufferMeshComponent.getUint32Accessor()[indexBufferI];
			}
		}
		
		vkDevFacade.bind(vboIndexBufferResource.resource.value, vboIndexBufferResource.derivedInformation.value.allocatorForResource.deviceMemory, vboIndexBufferResource.derivedInformation.value.offset);
		
		
		return resultDecoratedMesh;
	}
	
	final disposeDecoratedMesh(AbstractDecoratedMesh decoratedMesh) {
		(cast(VulkanDecoratedMesh)decoratedMesh).decoration.dispose(vkDevFacade, vulkanContext);
		(cast(VulkanDecoratedMesh)decoratedMesh).decoration = null; // for safety against double free
	}
	
	
	
	
	protected final void checkForReleasedResourcesAndRelease() {
		// before destruction of vulkan resources we have to ensure that the decive idles
	    vkDeviceWaitIdle(vulkanContext.chosenDevice.logicalDevice);

		
		// TODO< invoke resourceDag >
	}






	// inspired by https://vulkan-tutorial.com/Texture_mapping#page_Layout_transitions
	final private void transitionImageLayout(TypesafeVkImage image, VkImageAspectFlags aspectMask, VkImageLayout oldLayout, VkImageLayout newLayout) {
		VkResult vulkanResult;

		VkQueue graphicsQueue = vulkanContext.queueManager.getQueueByName("graphics");

		{ // scope for beginCommandBuffer/end
			VkCommandBufferBeginInfo beginInfo = {};
			beginInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
			beginInfo.flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;
			vkBeginCommandBuffer(cast(VkCommandBuffer)setupCommandBuffer, &beginInfo);
			scope(success) vkEndCommandBuffer(cast(VkCommandBuffer)setupCommandBuffer);
			
			setImageLayout(
				cast(VkCommandBuffer)setupCommandBuffer, // cmdBuffer
				cast(VkImage)image, // image
				aspectMask, // aspectMask
				oldLayout, // oldImageLayout
				newLayout // newImageLayout
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

	static struct CommandCopyImageArguments {
		TypesafeVkImage sourceImage, destinationImage;
		VkImageLayout sourceImageLayout, destinationImageLayout;
		Vector2ui extent;
	}

	// inspired by https://vulkan-tutorial.com/Texture_mapping#page_Copying_images
	// just adds a command
	final private static void commandCopyImage(TypesafeVkCommandBuffer commandBuffer, CommandCopyImageArguments arguments) {
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
			with(extent) {width=arguments.extent.x,height=arguments.extent.y,depth=0;};
		}
		
		vkCmdCopyImage(
			cast(VkCommandBuffer)commandBuffer,
			cast(VkImage)arguments.sourceImage,
			arguments.sourceImageLayout,
			cast(VkImage)arguments.destinationImage,
			arguments.destinationImageLayout,
			1, // regionCount
			imageCopyRegions.ptr// pRegions
		);
	}

	// encapsulates and uses the setupCommandBuffer
	final private void copyImage(CommandCopyImageArguments arguments) {
		VkResult vulkanResult;

		VkQueue graphicsQueue = vulkanContext.queueManager.getQueueByName("graphics");

		{ // scope for beginCommandBuffer/end
			VkCommandBufferBeginInfo beginInfo = {};
			beginInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
			beginInfo.flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;
			vkBeginCommandBuffer(cast(VkCommandBuffer)setupCommandBuffer, &beginInfo);
			scope(success) vkEndCommandBuffer(cast(VkCommandBuffer)setupCommandBuffer);
			
			commandCopyImage(setupCommandBuffer, arguments);
		}


		VkSubmitInfo submitInfo = {};
		with(submitInfo) {
			sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
			waitSemaphoreCount = 0;
			commandBufferCount = 1;
			pCommandBuffers = cast(immutable(VkCommandBuffer)*)&setupCommandBuffer;
			signalSemaphoreCount = 0;
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
		VulkanMemoryAllocator allocatorForResource = resourceWithMemDeco.derivedInformation.value.allocatorForResource = vulkanContext.retriveOrCreateMemoryAllocatorByTypeIndex(resourceWithMemDeco.derivedInformation.value.typeIndex, allocatorConfiguration);
		resourceWithMemDeco.derivedInformation.value.offset = allocatorForResource.allocate(memRequirements.size, memRequirements.alignment, /* out */resourceWithMemDeco.derivedInformation.value.hintAllocatedSize);
		resourceWithMemDeco.derivedInformation.value.allocatedSize = memRequirements.size;
		
		return allocatorForResource;
	}
	
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
	
	
	
	// TODO< move this into an helper of the engine >
	static protected JsonValue readJsonEngineResource(string path) {
		try {
			// TODO< catch file exceptions >
			import std.file : read;
			string str = cast(string)read(path);
			return parseJson(str);
		}
		catch( JsonException exception ) {
			import std.format : format;
			throw new EngineException(false, true, "Couldn't parse json file \"%s\"!".format(path));
		}
	}
}

