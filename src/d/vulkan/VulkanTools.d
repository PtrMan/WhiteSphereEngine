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

import common.IDisposable;

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







//////////////////////////////////
// helper for querying and deciding the used queue families
//////////////////////////////////

import core.stdc.stdlib : malloc, free;
import helpers.VariableValidator;

class ExtendedQueueFamilyProperty {
	public final this(bool graphicsBit, bool computeBit, bool sparseBindingBit, bool supportPresent) {
		this.graphicsBit = graphicsBit;
		this.computeBit = computeBit;
		this.sparseBindingBit = sparseBindingBit;
		this.supportPresent = supportPresent;
	}
	
	public final this() {
	}
	
	public final bool isEqual(ExtendedQueueFamilyProperty other) {
		return graphicsBit == other.graphicsBit && computeBit == other.computeBit && sparseBindingBit == other.sparseBindingBit && supportPresent == other.supportPresent;
	}
	
	public bool graphicsBit;
	public bool computeBit;
	public bool sparseBindingBit;
	public bool supportPresent; // special bit, its not directly a queue family bit
}


ExtendedQueueFamilyProperty[] getSupportPresentForAllQueueFamiliesAndQueueInfo(VariableValidator!VkPhysicalDevice physicalDevice, VariableValidator!VkSurfaceKHR surface) {
	assert(surface.isValid());
	
	ExtendedQueueFamilyProperty[] result;
	
	uint32_t queueFamilyCount;
	{
		vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice.value, &queueFamilyCount, null);
		result.length = queueFamilyCount;
	}
	
	for( uint i = 0; i < result.length; i++ ) {
		result[i] = new ExtendedQueueFamilyProperty();
	}
	
    VkQueueFamilyProperties* mainQueueInfo = cast(VkQueueFamilyProperties*)malloc(queueFamilyCount * VkQueueFamilyProperties.sizeof);
    // TODO< catch zero pointer >
    scope(exit) free(mainQueueInfo);
    
	
    vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice.value, &queueFamilyCount, mainQueueInfo);
	
	// transfer properties
	for( uint i = 0; i < queueFamilyCount; i++ ) {
		VkBool32 supportsPresent;
		
		result[i].graphicsBit = (mainQueueInfo[i].queueFlags & VK_QUEUE_GRAPHICS_BIT) != 0;
		result[i].computeBit = (mainQueueInfo[i].queueFlags & VK_QUEUE_COMPUTE_BIT) != 0;
		result[i].sparseBindingBit = (mainQueueInfo[i].queueFlags & VK_QUEUE_SPARSE_BINDING_BIT) != 0;
		
		vkGetPhysicalDeviceSurfaceSupportKHR(physicalDevice.value, i, surface.value, &supportsPresent);
		result[i].supportPresent = supportsPresent == VK_TRUE;
	}
	
	return result;
}



class QueryQueueResult {
	public final this(ExtendedQueueFamilyProperty requiredProperties, uint queueFamilyIndex) {
		this.requiredProperties = requiredProperties;
		this.queueFamilyIndex = queueFamilyIndex;
	}
	
	public uint queueFamilyIndex;
	public ExtendedQueueFamilyProperty requiredProperties;
}

/**
 * checks which queue family indices support the required families,
 * if no match for one entry is found it doesn't appear in the result
 *
 * doesn't take the queue count into account!
 */
QueryQueueResult[] queryPossibleQueueFamilies(ExtendedQueueFamilyProperty[] availableQueueFamilyProperties, ExtendedQueueFamilyProperty[] requestedQueueFamilyProperties) {
	bool satisfiesQueue(ExtendedQueueFamilyProperty availableQueue, ExtendedQueueFamilyProperty requested) {
		bool satisfies(bool available, bool requested) {
			return available || (available && requested) || !requested;
		}
		
		bool matchesGraphicsBit = satisfies(availableQueue.graphicsBit, requested.graphicsBit);
		bool matchesComputeBit = satisfies(availableQueue.computeBit, requested.computeBit);
		bool matchesSparseBindingBit = satisfies(availableQueue.sparseBindingBit, requested.sparseBindingBit);
		bool matchesSupportPresent = satisfies(availableQueue.supportPresent, requested.supportPresent);
		
		return matchesGraphicsBit && matchesComputeBit && matchesSparseBindingBit && matchesSupportPresent;
	}
	
	QueryQueueResult[] queryQueueResult;
	foreach( ExtendedQueueFamilyProperty currentRequestedQueueFamilyProperty; requestedQueueFamilyProperties ) {
		for( uint queueFamilyIndex = 0; queueFamilyIndex < availableQueueFamilyProperties.length; queueFamilyIndex++ ) {
			ExtendedQueueFamilyProperty availablePropertyOfQueueFamily = availableQueueFamilyProperties[queueFamilyIndex];
			
			// check if it satisfies all required queue family properties
			// if this is the case we add it to the result
			if( satisfiesQueue(availablePropertyOfQueueFamily, currentRequestedQueueFamilyProperty) ) {
				queryQueueResult ~= new QueryQueueResult(currentRequestedQueueFamilyProperty, queueFamilyIndex);
				break;
			} 
		}
	}
	
	return queryQueueResult;
}

// test that not satisfied requests get filtered out
unittest {
	ExtendedQueueFamilyProperty[] availableQueueFamilyProperties;
	ExtendedQueueFamilyProperty[] requestedQueueFamilyProperties;
	QueryQueueResult[] result;
	
	availableQueueFamilyProperties.length = 0;
	availableQueueFamilyProperties ~= new ExtendedQueueFamilyProperty();
	
	requestedQueueFamilyProperties.length = 0;
	requestedQueueFamilyProperties ~= new ExtendedQueueFamilyProperty();
	requestedQueueFamilyProperties[0].graphicsBit = true;

	result = queryPossibleQueueFamilies(availableQueueFamilyProperties, requestedQueueFamilyProperties);
	assert(result.length == 0);
	
	
	availableQueueFamilyProperties.length = 0;
	availableQueueFamilyProperties ~= new ExtendedQueueFamilyProperty();
	
	requestedQueueFamilyProperties.length = 0;
	requestedQueueFamilyProperties ~= new ExtendedQueueFamilyProperty();
	requestedQueueFamilyProperties[0].computeBit = true;

	result = queryPossibleQueueFamilies(availableQueueFamilyProperties, requestedQueueFamilyProperties);
	assert(result.length == 0);
	
	
	availableQueueFamilyProperties.length = 0;
	availableQueueFamilyProperties ~= new ExtendedQueueFamilyProperty();
	
	requestedQueueFamilyProperties.length = 0;
	requestedQueueFamilyProperties ~= new ExtendedQueueFamilyProperty();
	requestedQueueFamilyProperties[0].sparseBindingBit = true;

	result = queryPossibleQueueFamilies(availableQueueFamilyProperties, requestedQueueFamilyProperties);
	assert(result.length == 0);
	
	
	availableQueueFamilyProperties.length = 0;
	availableQueueFamilyProperties ~= new ExtendedQueueFamilyProperty();
	
	requestedQueueFamilyProperties.length = 0;
	requestedQueueFamilyProperties ~= new ExtendedQueueFamilyProperty();
	requestedQueueFamilyProperties[0].supportPresent = true;

	result = queryPossibleQueueFamilies(availableQueueFamilyProperties, requestedQueueFamilyProperties);
	assert(result.length == 0);		
}

// test that set features which don't care get included in the result
unittest {
	ExtendedQueueFamilyProperty[] availableQueueFamilyProperties;
	ExtendedQueueFamilyProperty[] requestedQueueFamilyProperties;
	QueryQueueResult[] result;
	
	availableQueueFamilyProperties.length = 0;
	availableQueueFamilyProperties ~= new ExtendedQueueFamilyProperty();
	availableQueueFamilyProperties[0].graphicsBit = true;
	
	requestedQueueFamilyProperties.length = 0;
	requestedQueueFamilyProperties ~= new ExtendedQueueFamilyProperty();
	
	result = queryPossibleQueueFamilies(availableQueueFamilyProperties, requestedQueueFamilyProperties);
	assert(result.length == 1);
	
	
	availableQueueFamilyProperties.length = 0;
	availableQueueFamilyProperties ~= new ExtendedQueueFamilyProperty();
	availableQueueFamilyProperties[0].computeBit = true;
	
	requestedQueueFamilyProperties.length = 0;
	requestedQueueFamilyProperties ~= new ExtendedQueueFamilyProperty();
	
	result = queryPossibleQueueFamilies(availableQueueFamilyProperties, requestedQueueFamilyProperties);
	assert(result.length == 1);
	
	
	availableQueueFamilyProperties.length = 0;
	availableQueueFamilyProperties ~= new ExtendedQueueFamilyProperty();
	availableQueueFamilyProperties[0].sparseBindingBit = true;
	
	requestedQueueFamilyProperties.length = 0;
	requestedQueueFamilyProperties ~= new ExtendedQueueFamilyProperty();
	
	result = queryPossibleQueueFamilies(availableQueueFamilyProperties, requestedQueueFamilyProperties);
	assert(result.length == 1);
	
	
	availableQueueFamilyProperties.length = 0;
	availableQueueFamilyProperties ~= new ExtendedQueueFamilyProperty();
	availableQueueFamilyProperties[0].supportPresent = true;
	
	requestedQueueFamilyProperties.length = 0;
	requestedQueueFamilyProperties ~= new ExtendedQueueFamilyProperty();
	
	result = queryPossibleQueueFamilies(availableQueueFamilyProperties, requestedQueueFamilyProperties);
	assert(result.length == 1);
}

