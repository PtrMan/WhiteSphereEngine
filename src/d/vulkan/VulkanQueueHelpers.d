module vulkan.VulkanQueueHelpers;

import std.stdint;

import api.vulkan.Vulkan;
import vulkan.VulkanHelpers;
import vulkan.VulkanTools;
import helpers.VariableValidator : VariableValidator;

class QueueInfo {
	public uint32_t queueFamilyIndex = UINT32_MAX;
	public ExtendedQueueFamilyProperty queueFamilyProperty;
	public VariableValidator!VkQueue queue;
	
	public float priority; // used mainly for retrival of queues
}

class DeviceQueueInfoHelper {
	public uint32_t queueFamilyIndex;
	public float[] priorities;
	
	public VkQueue[] queues; // the queues, must have the same length as priorities at the end of the initialisation and retrival
	
	final public @property uint count() {
		return priorities.length;
	}
	
	public static DeviceQueueInfoHelper[] createQueueInfoForQueues(QueueInfo[] queues) {
		DeviceQueueInfoHelper[] uniqueQueueFamilies;
		
		DeviceQueueInfoHelper getWithSameFamily(uint32_t queueFamilyIndex, out bool found) {
			found = false;
			foreach( DeviceQueueInfoHelper iterationHelper; uniqueQueueFamilies) {
				if( iterationHelper.queueFamilyIndex == queueFamilyIndex) {
					found = true;
					return iterationHelper;
				}
			}
			
			return null;
		}
		
		foreach( QueueInfo iterationQueue; queues ) {
			bool found;
			DeviceQueueInfoHelper helperWithSameFamily = getWithSameFamily(iterationQueue.queueFamilyIndex, found);
			if( !found ) {
				DeviceQueueInfoHelper createdHelper = new DeviceQueueInfoHelper();
				createdHelper.queueFamilyIndex = iterationQueue.queueFamilyIndex;
				createdHelper.priorities = [iterationQueue.priority];
				uniqueQueueFamilies ~= createdHelper;
			}
			else {
				assert(helperWithSameFamily.queueFamilyIndex == iterationQueue.queueFamilyIndex);
				helperWithSameFamily.priorities ~= iterationQueue.priority;
			}
		}
		
		return uniqueQueueFamilies;
	}
	
	public static VkDeviceQueueCreateInfo[] translateDeviceQueueCreateInfoHelperToVk(DeviceQueueInfoHelper[] queues) {
		VkDeviceQueueCreateInfo[] result;
		result.length = queues.length;
		
		foreach( i; 0..queues.length ) {
			initDeviceQueueCreateInfo(&(result[i]));
			result[i].queueFamilyIndex = queues[i].queueFamilyIndex;
			result[i].queueCount = queues[i].count;
			result[i].pQueuePriorities = cast(immutable(float)*)queues[i].priorities.ptr;
		}
		
		return result;
	}
}