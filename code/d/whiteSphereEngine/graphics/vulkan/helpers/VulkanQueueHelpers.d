module whiteSphereEngine.graphics.vulkan.helpers.VulkanQueueHelpers;

import std.stdint;
import std.typecons : Tuple;

import api.vulkan.Vulkan;
import whiteSphereEngine.graphics.vulkan.helpers.VulkanHelpers;
import whiteSphereEngine.graphics.vulkan.helpers.VulkanTools;
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
	
	public alias Tuple!(DeviceQueueInfoHelper, uint) DeviceQueueInfoAndIndexType;
	
	final public @property uint count() {
		return priorities.length;
	}
	
	public static DeviceQueueInfoHelper[] createQueueInfoForQueues(QueueInfo[] queues, out DeviceQueueInfoAndIndexType[] queueDeviceQueueInfoAndQueueIndices) {
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
		
		queueDeviceQueueInfoAndQueueIndices.length = 0;
		
		foreach( QueueInfo iterationQueue; queues ) {
			bool found;
			DeviceQueueInfoHelper helperWithSameFamily = getWithSameFamily(iterationQueue.queueFamilyIndex, found);
			if( !found ) {
				DeviceQueueInfoHelper createdHelper = new DeviceQueueInfoHelper();
				createdHelper.queueFamilyIndex = iterationQueue.queueFamilyIndex;
				createdHelper.priorities = [iterationQueue.priority];
				uniqueQueueFamilies ~= createdHelper;
				
				queueDeviceQueueInfoAndQueueIndices ~= DeviceQueueInfoAndIndexType(createdHelper, 0);
			}
			else {
				assert(helperWithSameFamily.queueFamilyIndex == iterationQueue.queueFamilyIndex);
				helperWithSameFamily.priorities ~= iterationQueue.priority;
				
				queueDeviceQueueInfoAndQueueIndices ~= DeviceQueueInfoAndIndexType(helperWithSameFamily, helperWithSameFamily.priorities.length-1);
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