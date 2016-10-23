module whiteSphereEngine.graphics.vulkan.helpers.InitializationHelpers;

import std.string : toStringz;
import std.stdint;

import api.vulkan.Vulkan;
import whiteSphereEngine.graphics.vulkan.helpers.VulkanHelpers;
import whiteSphereEngine.graphics.vulkan.VulkanDevice;
import TypedPointerWithLength : TypedPointerWithLength;
import Exceptions;

/**
 * helpers for the initialisation and deinitialisation of the vulkan environment.
 * Query for the available hardware are also included
 */

/**
 *
 * \param withSurface do we want to render to a surface?
 *
 */ 
public void initializeInstance(string[] layersToLoadGced, string[] extensionsToLoadGced, string[] deviceExtensionsToLoadGced, bool withSurface, out VkInstance instance) {
	VkResult vulkanResult;
	
	// TODO< get rid of nongced memory >
	TypedPointerWithLength!(immutable(char)*) layersNonGced = TypedPointerWithLength!(immutable(char)*).allocate(layersToLoadGced.length);
	for( uint i = 0; i < layersNonGced.length; i++ ) {
		layersNonGced.ptr[i] = toStringz(layersToLoadGced[i]);
	}
	
	TypedPointerWithLength!(immutable(char)*) extensionsNonGced = TypedPointerWithLength!(immutable(char)*).allocate(extensionsToLoadGced.length);
	for( uint i = 0; i < extensionsNonGced.length; i++ ) {
		extensionsNonGced.ptr[i] = toStringz(extensionsToLoadGced[i]);
	}
	
	TypedPointerWithLength!(immutable(char)*) deviceExtensionsNonGced = TypedPointerWithLength!(immutable(char)*).allocate(deviceExtensionsToLoadGced.length);
	for( uint i = 0; i < deviceExtensionsNonGced.length; i++ ) {
		deviceExtensionsNonGced.ptr[i] = toStringz(deviceExtensionsToLoadGced[i]);
	}
	
	
	
	VkApplicationInfo appInfo;
	initApplicationInfo(&appInfo);
	appInfo.pApplicationName = "PtrEngine";
	appInfo.pEngineName = "PtrEngine";
	// todo : Use VK_API_VERSION 
	appInfo.apiVersion = VK_MAKE_VERSION(1, 0, 2); // because driver doesn't jet support higher version
	
	// TODO< use array initialisation notation >
	VkInstanceCreateInfo instanceCreateInfo;
	initInstanceCreateInfo(&instanceCreateInfo);

	instanceCreateInfo.enabledLayerCount = cast(uint32_t)layersNonGced.length;
	instanceCreateInfo.ppEnabledLayerNames = layersNonGced.ptr;
	
	instanceCreateInfo.enabledExtensionCount = cast(uint32_t)extensionsNonGced.length;
	instanceCreateInfo.ppEnabledExtensionNames = extensionsNonGced.ptr;
	
	instanceCreateInfo.pApplicationInfo = cast(immutable(VkApplicationInfo)*)&appInfo;
	
	VkInstance temporaryInstance;
	vulkanResult = vkCreateInstance(&instanceCreateInfo, null, &temporaryInstance);
	
	{
		import std.stdio;
		writeln("initializeInstance() instance result is ", temporaryInstance);
	}
	
	instance = temporaryInstance;
	if( !vulkanSuccess(vulkanResult) ) {
		throw new EngineException(true, true, "vkCreateInstance failed!");
	}
}

public void cleanupInstance(VkInstance instance) {
	vkDestroyInstance(instance, null);
}


public VulkanDevice[] enumerateAllPossibleDevices(VkInstance instance) {
	VkResult vulkanResult;
	
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
	
	return vulkanDevices;
}

