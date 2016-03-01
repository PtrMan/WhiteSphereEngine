module vulkan.VulkanPlatform;

import Exceptions;
import api.vulkan.Vulkan;

// just for windows
version(Win32) {
	import core.sys.windows.windows;

	static private HMODULE handleOfLibrary;
}

// helper for retriving the adress of a vulkan function

// its fine to first try with vkGetInstanceProcAddr and then the system specific mechanism (for windows GetProcAdress)
// see
// http://www.glfw.org/docs/3.2/vulkan.html
public void* helperGetVulkanFunctionAdressByInstance(VkInstance instance, immutable(char*)name) {
	void* resultFromVulkan = vkGetInstanceProcAddr(instance, name);
	if( resultFromVulkan !is null ) {
		return resultFromVulkan;
	}
	
	version(Win32) {
	return GetProcAddress(handleOfLibrary, name);
	}
}

public void* helperGetVulkanFunctionAdressByDevice(VkDevice device, immutable(char*)name) {
	
	if( device !is null ) { // quick hack for hack...
	void* resultFromVulkan = vkGetDeviceProcAddr(device, name);
	if( resultFromVulkan !is null ) {
		return resultFromVulkan;
	}
	}
	
	version(Win32) {
	return GetProcAddress(handleOfLibrary, name);
	}
}


import Exceptions;

// tries to retrive the adress
// inspired by the function bindGLfunc of derelict
public void bindVulkanFunctionByInstance(void** functionPtrPtr, VkInstance instance, string name) {
	import std.string : toStringz;
	
	*functionPtrPtr = helperGetVulkanFunctionAdressByInstance(instance, toStringz(name));
	if( *functionPtrPtr is null ) {
		throw new EngineException(true, true, "Init of entrypoint of " ~ name ~ " failed!");
	}
}







public void initializeVulkanPointers() {
	FARPROC fp;
 
        
    handleOfLibrary = cast(HMODULE)LoadLibraryA("vulkan-1.dll");
    if (handleOfLibrary is null) {
    	throw new EngineException(true, true, "Can't load Vulkan library! vulkan-1.dll");
    }
 
    fp = GetProcAddress(handleOfLibrary, "vkGetInstanceProcAddr");
    // TODO< test is wrong! >
    if (fp is null) {
    	throw new EngineException(true, true, "Failed to get proc adress of 'vkGetInstanceProcAddr'");
    }
    vkGetInstanceProcAddr = cast(VKGETINSTANCEPROCADDRTYPE)fp;

    bindVulkanFunctionByInstance(cast(void**)&vkCreateInstance, null, "vkCreateInstance");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyInstance, null, "vkDestroyInstance");
	bindVulkanFunctionByInstance(cast(void**)&vkEnumeratePhysicalDevices, null, "vkEnumeratePhysicalDevices");
	bindVulkanFunctionByInstance(cast(void**)&vkGetPhysicalDeviceFeatures, null, "vkGetPhysicalDeviceFeatures");
	bindVulkanFunctionByInstance(cast(void**)&vkGetPhysicalDeviceFormatProperties, null, "vkGetPhysicalDeviceFormatProperties");
	bindVulkanFunctionByInstance(cast(void**)&vkGetPhysicalDeviceImageFormatProperties, null, "vkGetPhysicalDeviceImageFormatProperties");
	bindVulkanFunctionByInstance(cast(void**)&vkGetPhysicalDeviceProperties, null, "vkGetPhysicalDeviceProperties");
	bindVulkanFunctionByInstance(cast(void**)&vkGetPhysicalDeviceQueueFamilyProperties, null, "vkGetPhysicalDeviceQueueFamilyProperties");
	bindVulkanFunctionByInstance(cast(void**)&vkGetPhysicalDeviceMemoryProperties, null, "vkGetPhysicalDeviceMemoryProperties");
	bindVulkanFunctionByInstance(cast(void**)&vkGetInstanceProcAddr, null, "vkGetInstanceProcAddr");
	bindVulkanFunctionByInstance(cast(void**)&vkGetDeviceProcAddr, null, "vkGetDeviceProcAddr");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateDevice, null, "vkCreateDevice");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyDevice, null, "vkDestroyDevice");
	bindVulkanFunctionByInstance(cast(void**)&vkEnumerateInstanceExtensionProperties, null, "vkEnumerateInstanceExtensionProperties");
	bindVulkanFunctionByInstance(cast(void**)&vkEnumerateDeviceExtensionProperties, null, "vkEnumerateDeviceExtensionProperties");
	bindVulkanFunctionByInstance(cast(void**)&vkEnumerateInstanceLayerProperties, null, "vkEnumerateInstanceLayerProperties");
	bindVulkanFunctionByInstance(cast(void**)&vkEnumerateDeviceLayerProperties, null, "vkEnumerateDeviceLayerProperties");
	bindVulkanFunctionByInstance(cast(void**)&vkGetDeviceQueue, null, "vkGetDeviceQueue");
	bindVulkanFunctionByInstance(cast(void**)&vkQueueSubmit, null, "vkQueueSubmit");
	bindVulkanFunctionByInstance(cast(void**)&vkQueueWaitIdle, null, "vkQueueWaitIdle");
	bindVulkanFunctionByInstance(cast(void**)&vkDeviceWaitIdle, null, "vkDeviceWaitIdle");
	bindVulkanFunctionByInstance(cast(void**)&vkAllocateMemory, null, "vkAllocateMemory");
	bindVulkanFunctionByInstance(cast(void**)&vkFreeMemory, null, "vkFreeMemory");
	bindVulkanFunctionByInstance(cast(void**)&vkMapMemory, null, "vkMapMemory");
	bindVulkanFunctionByInstance(cast(void**)&vkUnmapMemory, null, "vkUnmapMemory");
	bindVulkanFunctionByInstance(cast(void**)&vkFlushMappedMemoryRanges, null, "vkFlushMappedMemoryRanges");
	bindVulkanFunctionByInstance(cast(void**)&vkInvalidateMappedMemoryRanges, null, "vkInvalidateMappedMemoryRanges");
	bindVulkanFunctionByInstance(cast(void**)&vkGetDeviceMemoryCommitment, null, "vkGetDeviceMemoryCommitment");
	bindVulkanFunctionByInstance(cast(void**)&vkBindBufferMemory, null, "vkBindBufferMemory");
	bindVulkanFunctionByInstance(cast(void**)&vkBindImageMemory, null, "vkBindImageMemory");
	bindVulkanFunctionByInstance(cast(void**)&vkGetBufferMemoryRequirements, null, "vkGetBufferMemoryRequirements");
	bindVulkanFunctionByInstance(cast(void**)&vkGetImageMemoryRequirements, null, "vkGetImageMemoryRequirements");
	bindVulkanFunctionByInstance(cast(void**)&vkGetImageSparseMemoryRequirements, null, "vkGetImageSparseMemoryRequirements");
	bindVulkanFunctionByInstance(cast(void**)&vkGetPhysicalDeviceSparseImageFormatProperties, null, "vkGetPhysicalDeviceSparseImageFormatProperties");
	bindVulkanFunctionByInstance(cast(void**)&vkQueueBindSparse, null, "vkQueueBindSparse");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateFence, null, "vkCreateFence");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyFence, null, "vkDestroyFence");
	bindVulkanFunctionByInstance(cast(void**)&vkResetFences, null, "vkResetFences");
	bindVulkanFunctionByInstance(cast(void**)&vkGetFenceStatus, null, "vkGetFenceStatus");
	bindVulkanFunctionByInstance(cast(void**)&vkWaitForFences, null, "vkWaitForFences");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateSemaphore, null, "vkCreateSemaphore");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroySemaphore, null, "vkDestroySemaphore");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateEvent, null, "vkCreateEvent");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyEvent, null, "vkDestroyEvent");
	bindVulkanFunctionByInstance(cast(void**)&vkGetEventStatus, null, "vkGetEventStatus");
	bindVulkanFunctionByInstance(cast(void**)&vkSetEvent, null, "vkSetEvent");
	bindVulkanFunctionByInstance(cast(void**)&vkResetEvent, null, "vkResetEvent");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateQueryPool, null, "vkCreateQueryPool");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyQueryPool, null, "vkDestroyQueryPool");
	bindVulkanFunctionByInstance(cast(void**)&vkGetQueryPoolResults, null, "vkGetQueryPoolResults");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateBuffer, null, "vkCreateBuffer");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyBuffer, null, "vkDestroyBuffer");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateBufferView, null, "vkCreateBufferView");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyBufferView, null, "vkDestroyBufferView");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateImage, null, "vkCreateImage");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyImage, null, "vkDestroyImage");
	bindVulkanFunctionByInstance(cast(void**)&vkGetImageSubresourceLayout, null, "vkGetImageSubresourceLayout");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateImageView, null, "vkCreateImageView");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyImageView, null, "vkDestroyImageView");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateShaderModule, null, "vkCreateShaderModule");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyShaderModule, null, "vkDestroyShaderModule");
	bindVulkanFunctionByInstance(cast(void**)&vkCreatePipelineCache, null, "vkCreatePipelineCache");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyPipelineCache, null, "vkDestroyPipelineCache");
	bindVulkanFunctionByInstance(cast(void**)&vkGetPipelineCacheData, null, "vkGetPipelineCacheData");
	bindVulkanFunctionByInstance(cast(void**)&vkMergePipelineCaches, null, "vkMergePipelineCaches");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateGraphicsPipelines, null, "vkCreateGraphicsPipelines");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateComputePipelines, null, "vkCreateComputePipelines");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyPipeline, null, "vkDestroyPipeline");
	bindVulkanFunctionByInstance(cast(void**)&vkCreatePipelineLayout, null, "vkCreatePipelineLayout");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyPipelineLayout, null, "vkDestroyPipelineLayout");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateSampler, null, "vkCreateSampler");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroySampler, null, "vkDestroySampler");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateDescriptorSetLayout, null, "vkCreateDescriptorSetLayout");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyDescriptorSetLayout, null, "vkDestroyDescriptorSetLayout");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateDescriptorPool, null, "vkCreateDescriptorPool");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyDescriptorPool, null, "vkDestroyDescriptorPool");
	bindVulkanFunctionByInstance(cast(void**)&vkResetDescriptorPool, null, "vkResetDescriptorPool");
	bindVulkanFunctionByInstance(cast(void**)&vkAllocateDescriptorSets, null, "vkAllocateDescriptorSets");
	bindVulkanFunctionByInstance(cast(void**)&vkFreeDescriptorSets, null, "vkFreeDescriptorSets");
	bindVulkanFunctionByInstance(cast(void**)&vkUpdateDescriptorSets, null, "vkUpdateDescriptorSets");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateFramebuffer, null, "vkCreateFramebuffer");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyFramebuffer, null, "vkDestroyFramebuffer");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateRenderPass, null, "vkCreateRenderPass");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyRenderPass, null, "vkDestroyRenderPass");
	bindVulkanFunctionByInstance(cast(void**)&vkGetRenderAreaGranularity, null, "vkGetRenderAreaGranularity");
	bindVulkanFunctionByInstance(cast(void**)&vkCreateCommandPool, null, "vkCreateCommandPool");
	bindVulkanFunctionByInstance(cast(void**)&vkDestroyCommandPool, null, "vkDestroyCommandPool");
	bindVulkanFunctionByInstance(cast(void**)&vkResetCommandPool, null, "vkResetCommandPool");
	bindVulkanFunctionByInstance(cast(void**)&vkAllocateCommandBuffers, null, "vkAllocateCommandBuffers");
	bindVulkanFunctionByInstance(cast(void**)&vkFreeCommandBuffers, null, "vkFreeCommandBuffers");
	bindVulkanFunctionByInstance(cast(void**)&vkBeginCommandBuffer, null, "vkBeginCommandBuffer");
	bindVulkanFunctionByInstance(cast(void**)&vkEndCommandBuffer, null, "vkEndCommandBuffer");
	bindVulkanFunctionByInstance(cast(void**)&vkResetCommandBuffer, null, "vkResetCommandBuffer");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdBindPipeline, null, "vkCmdBindPipeline");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdSetViewport, null, "vkCmdSetViewport");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdSetScissor, null, "vkCmdSetScissor");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdSetLineWidth, null, "vkCmdSetLineWidth");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdSetDepthBias, null, "vkCmdSetDepthBias");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdSetBlendConstants, null, "vkCmdSetBlendConstants");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdSetDepthBounds, null, "vkCmdSetDepthBounds");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdSetStencilCompareMask, null, "vkCmdSetStencilCompareMask");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdSetStencilWriteMask, null, "vkCmdSetStencilWriteMask");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdSetStencilReference, null, "vkCmdSetStencilReference");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdBindDescriptorSets, null, "vkCmdBindDescriptorSets");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdBindIndexBuffer, null, "vkCmdBindIndexBuffer");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdBindVertexBuffers, null, "vkCmdBindVertexBuffers");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdDraw, null, "vkCmdDraw");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdDrawIndexed, null, "vkCmdDrawIndexed");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdDrawIndirect, null, "vkCmdDrawIndirect");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdDrawIndexedIndirect, null, "vkCmdDrawIndexedIndirect");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdDispatch, null, "vkCmdDispatch");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdDispatchIndirect, null, "vkCmdDispatchIndirect");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdCopyBuffer, null, "vkCmdCopyBuffer");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdCopyImage, null, "vkCmdCopyImage");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdBlitImage, null, "vkCmdBlitImage");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdCopyBufferToImage, null, "vkCmdCopyBufferToImage");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdCopyImageToBuffer, null, "vkCmdCopyImageToBuffer");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdUpdateBuffer, null, "vkCmdUpdateBuffer");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdFillBuffer, null, "vkCmdFillBuffer");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdClearColorImage, null, "vkCmdClearColorImage");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdClearDepthStencilImage, null, "vkCmdClearDepthStencilImage");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdClearAttachments, null, "vkCmdClearAttachments");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdResolveImage, null, "vkCmdResolveImage");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdSetEvent, null, "vkCmdSetEvent");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdResetEvent, null, "vkCmdResetEvent");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdWaitEvents, null, "vkCmdWaitEvents");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdPipelineBarrier, null, "vkCmdPipelineBarrier");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdBeginQuery, null, "vkCmdBeginQuery");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdEndQuery, null, "vkCmdEndQuery");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdResetQueryPool, null, "vkCmdResetQueryPool");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdWriteTimestamp, null, "vkCmdWriteTimestamp");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdCopyQueryPoolResults, null, "vkCmdCopyQueryPoolResults");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdPushConstants, null, "vkCmdPushConstants");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdBeginRenderPass, null, "vkCmdBeginRenderPass");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdNextSubpass, null, "vkCmdNextSubpass");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdEndRenderPass, null, "vkCmdEndRenderPass");
	bindVulkanFunctionByInstance(cast(void**)&vkCmdExecuteCommands, null, "vkCmdExecuteCommands");

	bindVulkanFunctionByInstance(cast(void**)&vkDestroySurfaceKHR, null, "vkDestroySurfaceKHR");
    bindVulkanFunctionByInstance(cast(void**)&vkGetPhysicalDeviceSurfaceSupportKHR, null, "vkGetPhysicalDeviceSurfaceSupportKHR");
    bindVulkanFunctionByInstance(cast(void**)&vkGetPhysicalDeviceSurfaceCapabilitiesKHR, null, "vkGetPhysicalDeviceSurfaceCapabilitiesKHR");
    bindVulkanFunctionByInstance(cast(void**)&vkGetPhysicalDeviceSurfaceFormatsKHR, null, "vkGetPhysicalDeviceSurfaceFormatsKHR");
    bindVulkanFunctionByInstance(cast(void**)&vkGetPhysicalDeviceSurfacePresentModesKHR, null, "vkGetPhysicalDeviceSurfacePresentModesKHR");
    
    version(Win32) {
    	bindVulkanFunctionByInstance(cast(void**)&vkCreateWin32SurfaceKHR, null, "vkCreateWin32SurfaceKHR");
		bindVulkanFunctionByInstance(cast(void**)&vkGetPhysicalDeviceWin32PresentationSupportKHR, null, "vkGetPhysicalDeviceWin32PresentationSupportKHR");
    }
    
    //bindVulkanFunctionByInstance(cast(void**)&vkCreateDebugReportCallbackEXT, null, "vkCreateDebugReportCallbackEXT");
	//bindVulkanFunctionByInstance(cast(void**)&vkDestroyDebugReportCallbackEXT, null, "vkDestroyDebugReportCallbackEXT");
	//bindVulkanFunctionByInstance(cast(void**)&vkDebugReportMessageEXT, null, "vkDebugReportMessageEXT");

}

public void releaseVulkanLibrary() {
	FreeLibrary(handleOfLibrary);
	handleOfLibrary = null;
}
