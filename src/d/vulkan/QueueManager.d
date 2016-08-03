module vulkan.QueueManager;

import std.typecons : Tuple;

import api.vulkan.Vulkan;
import vulkan.VulkanQueueHelpers;

// bundles the queues and a mechanism to adress them by name
class QueueManager {
	public DeviceQueueInfoHelper[] queueInfos;
	
	
	// used to adress the specific queue in the DeviceQueueInfoHelper, by name of the queue
	protected Tuple!(DeviceQueueInfoHelper, uint)[string] deviceQueueInfoAndIndexForQueueByName;
	//protected DeviceQueueInfoHelper[string] queueInfosByString; // used to adress specific queues by (type)name
	
	public final void addQueueByName(string name, DeviceQueueInfoHelper deviceQueueInfo, uint queueIndex) {
		deviceQueueInfoAndIndexForQueueByName[name] = Tuple!(DeviceQueueInfoHelper, uint)(deviceQueueInfo, queueIndex);
	}
	
	public final DeviceQueueInfoHelper getDeviceQueueInfoByName(string name) {
		Tuple!(DeviceQueueInfoHelper, uint) deviceQueueInfoAndIndexTuple = deviceQueueInfoAndIndexForQueueByName[name];
		DeviceQueueInfoHelper deviceQueueInfo = deviceQueueInfoAndIndexTuple[0];
		return deviceQueueInfo;
	}
	
	public final VkQueue getQueueByName(string name) {
		Tuple!(DeviceQueueInfoHelper, uint) deviceQueueInfoAndIndexTuple = deviceQueueInfoAndIndexForQueueByName[name];
		DeviceQueueInfoHelper deviceQueueInfo = deviceQueueInfoAndIndexTuple[0];
		uint queueIndex = deviceQueueInfoAndIndexTuple[1];
		
		return deviceQueueInfo.queues[queueIndex];
	}
}
