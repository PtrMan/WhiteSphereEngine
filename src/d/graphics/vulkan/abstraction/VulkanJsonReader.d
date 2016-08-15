module graphics.vulkan.abstraction.VulkanJsonReader;

import std.string : strip, split;
import std.conv : to;
import std.json : JsonValue = JSONValue, parseJson = parseJSON, JsonException = JSONException, ConvException;

static import erupted.types;
import api.vulkan.Vulkan;

import Exceptions;

VkPipelineColorBlendAttachmentState convertForPipelineColorBlendAttachmentState(JsonValue jsonValue) {
	static uint convertColorComponentFlagToNumber(string str) {
		return cast(uint)str.to!(erupted.types.VkColorComponentFlagBits);
	}
	
	VkPipelineColorBlendAttachmentState result;
	try {
		with( result ) {
			blendEnable = toBool(jsonValue["blendEnable"].str);
			srcColorBlendFactor = cast(VkBlendFactor)jsonValue["srcColorBlendFactor"].str.to!(erupted.types.VkBlendFactor);
			dstColorBlendFactor = cast(VkBlendFactor)jsonValue["dstColorBlendFactor"].str.to!(erupted.types.VkBlendFactor);
			colorBlendOp = cast(VkBlendOp)jsonValue["colorBlendOp"].str.to!(erupted.types.VkBlendOp);
			srcAlphaBlendFactor = cast(VkBlendFactor)jsonValue["srcAlphaBlendFactor"].str.to!(erupted.types.VkBlendFactor);
			dstAlphaBlendFactor = cast(VkBlendFactor)jsonValue["dstAlphaBlendFactor"].str.to!(erupted.types.VkBlendFactor);
			alphaBlendOp = cast(VkBlendOp)jsonValue["alphaBlendOp"].str.to!(erupted.types.VkBlendOp);
			colorWriteMask = cast(VkColorComponentFlags)or(jsonValue["colorWriteMask"].str, &convertColorComponentFlagToNumber);
		}
	}
	catch( JsonException exception ) {
		throw new EngineException(false, true, "Json conversion for VkPipelineColorBlendAttachmentState failed with '" ~ exception.msg ~ "'!");
	}
	catch( ConvException exception ) {
		throw new EngineException(false, true, "Json conversion for VkPipelineColorBlendAttachmentState failed with '" ~ exception.msg ~ "'!");
	}
 
	return result;
}

private uint or(string input, uint function(string) convertToEnum) {
	uint result = 0;
	
	foreach( splitResult; input.split("|") ) {
		result |= convertToEnum(splitResult.strip);
	}
	return result;
}

private VkBool32 toBool(string str) {
	if( str == "VK_TRUE" ) {
		return VK_TRUE;
	}
	else if( str == "VK_FALSE" ) {
		return VK_FALSE;
	}
	else {
		throw new EngineException(false, true, "");
	}
}
