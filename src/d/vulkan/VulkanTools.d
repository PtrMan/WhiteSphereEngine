module vulkan.VulkanTools;

import std.stdint;

import api.vulkan.Vulkan;
import vulkan.VulkanHelpers;
import Exceptions;

// from https://github.com/SaschaWillems/Vulkan/blob/master/base/vulkantools.cpp
// license MIT

// Create an image memory barrier for changing the layout of
// an image and put it into an active command buffer
// See chapter 11.4 "Image Layout" for details
//todo : rename
void setImageLayout(VkCommandBuffer cmdbuffer, VkImage image, VkImageAspectFlags aspectMask, VkImageLayout oldImageLayout, VkImageLayout newImageLayout) {
	// Create an image barrier object
	VkImageMemoryBarrier imageMemoryBarrier;
	initImageMemoryBarrier(&imageMemoryBarrier);
	imageMemoryBarrier.oldLayout = oldImageLayout;
	imageMemoryBarrier.newLayout = newImageLayout;
	imageMemoryBarrier.image = image;
	imageMemoryBarrier.subresourceRange.aspectMask = aspectMask;
	imageMemoryBarrier.subresourceRange.baseMipLevel = 0;
	imageMemoryBarrier.subresourceRange.levelCount = 1;
	imageMemoryBarrier.subresourceRange.layerCount = 1;

	// Source layouts (old)

	// Undefined layout
	// Only allowed as initial layout!
	// Make sure any writes to the image have been finished
	if (oldImageLayout == VK_IMAGE_LAYOUT_UNDEFINED) {
		imageMemoryBarrier.srcAccessMask = VK_ACCESS_HOST_WRITE_BIT | VK_ACCESS_TRANSFER_WRITE_BIT;
	}

	// Old layout is color attachment
	// Make sure any writes to the color buffer have been finished
	if (oldImageLayout == VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL) {
		imageMemoryBarrier.srcAccessMask = VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;
	}

	// Old layout is transfer source
	// Make sure any reads from the image have been finished
	if (oldImageLayout == VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL) {
		imageMemoryBarrier.srcAccessMask = VK_ACCESS_TRANSFER_READ_BIT;
	}

	// Old layout is shader read (sampler, input attachment)
	// Make sure any shader reads from the image have been finished
	if (oldImageLayout == VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL) {
		imageMemoryBarrier.srcAccessMask = VK_ACCESS_SHADER_READ_BIT;
	}

	// Target layouts (new)

	// New layout is transfer destination (copy, blit)
	// Make sure any copyies to the image have been finished
	if (newImageLayout == VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL) {
		imageMemoryBarrier.dstAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
	}

	// New layout is transfer source (copy, blit)
	// Make sure any reads from and writes to the image have been finished
	if (newImageLayout == VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL) {
		imageMemoryBarrier.srcAccessMask = imageMemoryBarrier.srcAccessMask | VK_ACCESS_TRANSFER_READ_BIT;
		imageMemoryBarrier.dstAccessMask = VK_ACCESS_TRANSFER_READ_BIT;
	}

	// New layout is color attachment
	// Make sure any writes to the color buffer hav been finished
	if (newImageLayout == VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL) {
		imageMemoryBarrier.dstAccessMask = VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;
		imageMemoryBarrier.srcAccessMask = VK_ACCESS_TRANSFER_READ_BIT;
	}

	// New layout is depth attachment
	// Make sure any writes to depth/stencil buffer have been finished
	if (newImageLayout == VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL) {
		imageMemoryBarrier.dstAccessMask = imageMemoryBarrier.dstAccessMask | VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT;
	}

	// New layout is shader read (sampler, input attachment)
	// Make sure any writes to the image have been finished
	if (newImageLayout == VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL) {
		imageMemoryBarrier.srcAccessMask = VK_ACCESS_HOST_WRITE_BIT | VK_ACCESS_TRANSFER_WRITE_BIT;
		imageMemoryBarrier.dstAccessMask = VK_ACCESS_SHADER_READ_BIT;
	}


	// Put barrier on top
	VkPipelineStageFlags srcStageFlags = VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT;
	VkPipelineStageFlags destStageFlags = VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT;

	// Put barrier inside setup command buffer
	vkCmdPipelineBarrier(
		cmdbuffer, 
		srcStageFlags, 
		destStageFlags, 
		0, 
		0, null,
		0, null,
		1, &imageMemoryBarrier);
}


VkFormat vulkanHelperFindBestFormatTry(VkPhysicalDevice physicalDevice, VkFormat[] preferedFormats, VkFormatFeatureFlags formatFeatureMask, out bool calleeSuccess) {
	calleeSuccess = false;

	foreach( VkFormat preferedFormat; preferedFormats ) {
		VkFormatProperties formatProperties;
		vkGetPhysicalDeviceFormatProperties(physicalDevice, preferedFormat, &formatProperties);
		// Format must support depth stencil attachment for optimal tiling
		if (formatProperties.optimalTilingFeatures & formatFeatureMask) {
			calleeSuccess = true;
			return preferedFormat;
		}
	}

	return 0;
}

// see Vulkan 1.0.0 reference page 181
uint32_t vulkanHelperSearchBestIndexOfMemoryType(VkPhysicalDeviceMemoryProperties* physicalDeviceMemoryProperties, uint32_t typeBits, VkFlags queriedProperties, out bool calleeSuccess) {
	calleeSuccess = false;

	for( uint32_t i = 0; i < 32; i++ ) {
		if( typeBits & 1 ) {
			if ((physicalDeviceMemoryProperties.memoryTypes[i].propertyFlags & queriedProperties) == queriedProperties) {
				calleeSuccess = true;
				return i;
			}
		}
		typeBits >>= 1;
	}
	return 0;
}

// https://github.com/SaschaWillems/Vulkan/blob/f5919fc988b61ed0c91372870a257c174147de00/base/vulkantools.cpp
// MIT license
/* doesn't work correctly, crashes in the application vulkan layer, doesn't matter

VkShaderModule loadShaderGlSl(string fileName, VkDevice device, VkShaderStageFlagBits stage) {
	import std.file : readText;
	import core.stdc.string : memcpy;
	import core.stdc.stdlib : malloc, free;

	string shaderSrc = readText(fileName);
	//assert(shaderSrc.length > 0);
	
	writeln(shaderSrc);
	writeln("done reading file");
	
	
	
	import std.string : toStringz;
	immutable(char)* layerArray;
	layerArray = toStringz(shaderSrc);
	
	VkShaderModule shaderModule;
	
	VkResult vulkanResult;

	VkShaderModuleCreateInfo moduleCreateInfo;
	initShaderModuleCreateInfo(&moduleCreateInfo);

	moduleCreateInfo.codeSize = 3 * uint32_t.sizeof + shaderSrc.length + 1;
	moduleCreateInfo.pCode = cast(immutable(uint32_t)*)malloc(moduleCreateInfo.codeSize);
	scope(exit) free(cast(void*)moduleCreateInfo.pCode);
	moduleCreateInfo.flags = 0;

	// Magic SPV number
	(cast(uint32_t*)moduleCreateInfo.pCode)[0] = 0x07230203; 
	(cast(uint32_t*)moduleCreateInfo.pCode)[1] = 0;
	(cast(uint32_t*)moduleCreateInfo.pCode)[2] = stage;
	
	writeln(moduleCreateInfo.pCode);
	writeln(cast(uint32_t*)moduleCreateInfo.pCode + 3);
	writeln(3 * uint32_t.sizeof + shaderSrc.length + 1);
	
	memcpy((cast(uint32_t*)moduleCreateInfo.pCode + 3), toStringz(shaderSrc), shaderSrc.length + 1);
	
	writeln("create");
	
	vulkanResult = vkCreateShaderModule(device, &moduleCreateInfo, null, &shaderModule);
	
	writeln("vulkanSuccess(vulkanResult)");
	
	if( !vulkanSuccess(vulkanResult) ) {
		writeln("Failed to load GLSL shader!");
		return shaderModule;
	}
	
	writeln("return");

	return shaderModule;
}
*/

import IDisposable;

// returns a IDisposable object which hold the memory of the shader, must be freed by application after the creation of the renderpass
IDisposable loadShader(string fileName, VkDevice device, VkShaderStageFlagBits stage, VkShaderModule* ptrDestintionShaderModule) {
	import MemoryAccessor;
	
	class MemoryReference : IDisposable {
		public final this(void* ptr) {
			this.protectedPtr = ptr;
		}
		
		public final void dispose() {
			if( protectedPtr is null ) {
				return;
			}
			MemoryAccessor.freeMemory(protectedPtr);
			protectedPtr = null;
		}
		
		public @property void* ptr() {
			return protectedPtr;
		}
		
		protected void* protectedPtr;
	}
	
	import std.file : read;
	import core.stdc.string : memcpy;

	void[] data = read(fileName);
	assert((data.length % 4) == 0);
	assert(data.length > 0);
	
	MemoryReference memoryReference;
	{
		void* memoryRawPtr = MemoryAccessor.allocateMemoryNoScanNoMove(data.length);
		memcpy(memoryRawPtr, data.ptr, data.length);
		memoryReference = new MemoryReference(memoryRawPtr);
	}
	
	VkShaderModuleCreateInfo moduleCreateInfo;
	initShaderModuleCreateInfo(&moduleCreateInfo);
	
	moduleCreateInfo.codeSize = data.length;
	moduleCreateInfo.pCode = cast(immutable(uint)*)memoryReference.ptr;
	moduleCreateInfo.flags = 0;

	{
		import std.stdio : writeln;
		writeln("HERE");
	}

	
	VkResult vulkanResult = vkCreateShaderModule(device, &moduleCreateInfo, null, ptrDestintionShaderModule);
	
	{
		import std.stdio : writeln;
		writeln("HERE");
	}
	
	if( !vulkanSuccess(vulkanResult) ) {
		memoryReference.dispose();
		
		throw new EngineException(false, false, "Failed to load GLSL shader!");
	}
	
	return memoryReference;
}

