module graphics.vulkan.abstraction.VulkanJsonReader;

import core.stdc.stdint;
import std.string : strip, split;
import std.conv : to;
import std.json : JsonValue = JSONValue, parseJson = parseJSON, JsonException = JSONException, ConvException;

static import erupted.types;
import api.vulkan.Vulkan;

import Exceptions;

// used with flag components
private uint convertFlagToNumber(Type)(string str) {
	if( str == "0" ) { // 0 is special
		return 0;
	}
	else {
		return cast(uint)str.to!Type;
	}
}

VkPipelineColorBlendAttachmentState convertForPipelineColorBlendAttachmentState(JsonValue jsonValue) {
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
			colorWriteMask = cast(VkColorComponentFlags)or(jsonValue["colorWriteMask"].str, &convertFlagToNumber!(erupted.types.VkColorComponentFlagBits));
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

// does create the inner array and fill it automatically
VkPipelineColorBlendStateCreateInfo convertForPipelineColorBlendStateCreateInfo(JsonValue jsonValue) {
	try {
		VkPipelineColorBlendAttachmentState[] attachments;
		
		JsonValue[] arr = jsonValue["attachments"].array;
		
		
		foreach( iterationJsonAttachment; arr ) {
			attachments ~= convertForPipelineColorBlendAttachmentState(iterationJsonAttachment);
		}
		
		VkPipelineColorBlendStateCreateInfo result = VkPipelineColorBlendStateCreateInfo.init;
		with( result ) {
			sType = VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO;
			flags = 0; // hardcoded because reserved for future use
			logicOpEnable = jsonValue["logicOpEnable"].str.toBool;
			logicOp = cast(VkLogicOp)jsonValue["logicOp"].str.to!(erupted.types.VkLogicOp);
			attachmentCount = cast(uint32_t)attachments.length;
			pAttachments = cast(immutable(VkPipelineColorBlendAttachmentState)*)attachments.ptr;
			blendConstants = convertStaticFloatArray!4(jsonValue["blendConstants"]);
		}
		return result;
	}
	catch( JsonException exception ) {
		throw new EngineException(false, true, "Json conversion for VkPipelineColorBlendStateCreateInfo failed with '" ~ exception.msg ~ "'!");
	}
	catch( ConvException exception ) {
		throw new EngineException(false, true, "Json conversion for VkPipelineColorBlendStateCreateInfo failed with '" ~ exception.msg ~ "'!");
	}
}

VkAttachmentDescription convertForAtachmentDescription(JsonValue jsonValue) {
	return jsonReaderForVulkanStructureWithOnlySpecifiedFields!(VkAttachmentDescription, 
		[
			"flags":"VkAttachmentDescriptionFlags",
			"format":"VkFormat",
			"samples":"VkSampleCountFlagBits",
			"loadOp":"VkAttachmentLoadOp",
			"storeOp":"VkAttachmentStoreOp",
			"stencilLoadOp":"VkAttachmentLoadOp",
			"stencilStoreOp":"VkAttachmentStoreOp",
			"initialLayout":"VkImageLayout",
			"finalLayout":"VkImageLayout",
		]
	)(jsonValue);
}

VkAttachmentReference convertForAttachmentReference(JsonValue jsonValue) {
	return jsonReaderForVulkanStructureWithOnlySpecifiedFields!(VkAttachmentReference, 
		[
		"attachment":"uint32_t",
		"layout":"VkImageLayout"
		]
	)(jsonValue);
}


Type jsonReaderForVulkanStructureWithOnlySpecifiedFields(Type, string[string] typeLookup)(JsonValue jsonValue) {
	import std.format : format;
	
	string currentField;
	try {
		Type resultStructure;
		with(resultStructure) {
			foreach( iterationMemberName; __traits(allMembers, Type) ) {
				currentField = iterationMemberName;
				
				// TODO< special case for bool>
				
				enum typeOfIterationName = typeLookup[iterationMemberName];
				enum isNativeType = typeOfIterationName == "uint32";
				enum isEnum = iterationMemberName == "flags" || (typeOfIterationName.length >= 4 && typeOfIterationName[$-4..$] == "Bits");
				static if( isEnum ) {
					mixin("resultStructure.%1$s = cast(%2$s)or(jsonValue[\"%1$s\"].str, &convertFlagToNumber!(erupted.types.%2$s));\n".format(iterationMemberName, typeLookup[iterationMemberName]));
				}
				else {
					enum convertToType = isNativeType ? typeOfIterationName : "erupted.types." ~ typeOfIterationName;
					
					mixin("resultStructure.%1$s = cast(%2$s)jsonValue[\"%1$s\"].str.to!(%3$s);\n".format(iterationMemberName, typeLookup[iterationMemberName], convertToType));
					
					// for debugging
					//import std.stdio;
					//writeln(typeof(__traits(getMember, resultStructure, iterationMemberName)).stringof, " ", typeLookup[iterationMemberName]);
				}
			}
		}
		return resultStructure;
	}
	catch( JsonException exception ) {
		throw new EngineException(false, true, "Json conversion of " ~ Type.stringof ~ " for the field '" ~ currentField ~ "' failed with '" ~ exception.msg ~ "'!");
	}
	catch( ConvException exception ) {
		throw new EngineException(false, true, "Json conversion of " ~ Type.stringof ~ " for the field '" ~ currentField ~ "' failed with '" ~ exception.msg ~ "'!");
	}

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

private float[ArraySize] convertStaticFloatArray(size_t ArraySize)(JsonValue jsonValue) {
	float[ArraySize] result;
	
	JsonValue[] arr = jsonValue.array;
	if( arr.length != ArraySize ) {
		throw new EngineException(false, true, "convertStaticFloatArray() got wrong json array size!");
	}
	
	foreach( i; 0..ArraySize ) {
		result[i] = arr[i].floating;
	}
	
	return result;
}
