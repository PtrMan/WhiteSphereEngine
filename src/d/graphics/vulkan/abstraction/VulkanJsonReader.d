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

// context which holds helpervariables for special functionality
struct AttachmentDescriptionContext {
	VkFormat depthFormat; // the format of the depth image
}

VkAttachmentDescription convertForAtachmentDescription(JsonValue jsonValue, AttachmentDescriptionContext attachmentDescriptionContext) {
	VkAttachmentDescription result = jsonReaderForVulkanStructureWithOnlySpecifiedFields!(VkAttachmentDescription, 
		[
			"flags":"VkAttachmentDescriptionFlags",
			"samples":"VkSampleCountFlagBits",
			"loadOp":"VkAttachmentLoadOp",
			"storeOp":"VkAttachmentStoreOp",
			"stencilLoadOp":"VkAttachmentLoadOp",
			"stencilStoreOp":"VkAttachmentStoreOp",
			"initialLayout":"VkImageLayout",
			"finalLayout":"VkImageLayout",
		],
		"format" // ignore
	)(jsonValue);

	if( jsonValue["format"].str == "depthFormat()" ) {
		result.format = attachmentDescriptionContext.depthFormat;
	}
	else {
		result.format = cast(VkFormat)jsonValue["format"].str.to!(erupted.types.VkFormat);
	}

	return result;
}

VkAttachmentReference convertForAttachmentReference(JsonValue jsonValue) {
	return jsonReaderForVulkanStructureWithOnlySpecifiedFields!(VkAttachmentReference, 
		[
		"attachment":"uint32_t",
		"layout":"VkImageLayout"
		]
	)(jsonValue);
}

// mixture which uses the template and some custom logic
VkSubpassDescription convertForSubpassDescription(JsonValue jsonValue) {
	VkSubpassDescription result = jsonReaderForVulkanStructureWithOnlySpecifiedFields!(VkSubpassDescription,
		[
		"flags":"VkSubpassDescriptionFlags",
		"pipelineBindPoint":"VkPipelineBindPoint",
		]
	)(jsonValue);
	
	JsonValue[] jsonArray;
	
	VkAttachmentReference[] InputAttachments; // TODO< fill >
	
	VkAttachmentReference[] colorAttachments;
	{
		jsonArray = jsonValue["colorAttachments"].array;
		
		foreach( iterationJson; jsonArray ) {
			colorAttachments ~= convertForAttachmentReference(iterationJson);
		}
	}

	
	with(result) {
		inputAttachmentCount = cast(uint32_t)InputAttachments.length;
		pInputAttachments = cast(immutable(VkAttachmentReference)*)InputAttachments.ptr;
		colorAttachmentCount = cast(uint32_t)colorAttachments.length;
		pColorAttachments = cast(immutable(VkAttachmentReference)*)colorAttachments.ptr;
		pResolveAttachments = null; // TODO< read from json >
		pDepthStencilAttachment = null; // TODO< read from json >
		preserveAttachmentCount = 0; // TODO< read from json >
		pPreserveAttachments = null; // TODO< read from json >
	}
	return result;
}

VkVertexInputBindingDescription convertForVertexInputBindingDescription(JsonValue jsonValue) {
	return jsonReaderForVulkanStructureWithOnlySpecifiedFields!(VkVertexInputBindingDescription,
		[
		"binding":"uint32_t",
		"stride":"uint32_t",
		"inputRate" : "VkVertexInputRate"
		]
	)(jsonValue);
}

VkVertexInputAttributeDescription convertForVertexInputAttributeDescription(JsonValue jsonValue) {
	return jsonReaderForVulkanStructureWithOnlySpecifiedFields!(VkVertexInputAttributeDescription,
		[
		"location":"uint32_t",
		"binding":"uint32_t",
		"format" : "VkFormat",
		"offset":"uint32_t"
		]
	)(jsonValue);
}

VkPipelineVertexInputStateCreateInfo convertForPipelineVertexInputState(JsonValue jsonValue) {
	VkVertexInputBindingDescription[] vertexInputBindingDescriptions = [];
	foreach( iterationJsonValue; jsonValue["vertexInputBindingDescriptions"].array ) {
		vertexInputBindingDescriptions ~= convertForVertexInputBindingDescription(iterationJsonValue);
	}
	
	VkVertexInputAttributeDescription[] vertexInputAttributeDescriptions = [];
	foreach( iterationJsonValue; jsonValue["vertexInputAttributeDescriptions"].array ) {
		vertexInputAttributeDescriptions ~= convertForVertexInputAttributeDescription(iterationJsonValue);
	}
	
	assert(vertexInputBindingDescriptions.length == vertexInputAttributeDescriptions.length);
	VkPipelineVertexInputStateCreateInfo vertexInputStateCreateInfo = VkPipelineVertexInputStateCreateInfo.init;
	with(vertexInputStateCreateInfo) {
		sType = VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;
		flags = 0; // reserved for future use
		vertexBindingDescriptionCount = cast(uint32_t)vertexInputBindingDescriptions.length;
		pVertexBindingDescriptions = cast(immutable(VkVertexInputBindingDescription)*)vertexInputBindingDescriptions.ptr;                                                            // uint32_t                                       vertexBindingDescriptionCount
		vertexAttributeDescriptionCount = cast(uint32_t)vertexInputAttributeDescriptions.length;
		pVertexAttributeDescriptions = cast(immutable(VkVertexInputAttributeDescription)*)vertexInputAttributeDescriptions.ptr;
	}
	
	return vertexInputStateCreateInfo;
}


VkPipelineRasterizationStateCreateInfo convertForPipelineRasterizationStateCreateInfo(JsonValue jsonValue) {
	VkPipelineRasterizationStateCreateInfo result = jsonReaderForVulkanStructureWithOnlySpecifiedFields!(VkPipelineRasterizationStateCreateInfo,
		[
		"depthClampEnable":"VkBool32",
		"rasterizerDiscardEnable":"VkBool32",
		"polygonMode":"VkPolygonMode",
		"cullMode":"VkCullModeFlags",
		"frontFace":"VkFrontFace",
		"depthBiasEnable":"VkBool32",
		"depthBiasConstantFactor":"float",
		"depthBiasClamp":"float",
		"depthBiasSlopeFactor":"float",
		"lineWidth":"float"
		],"flags"
	)(jsonValue);
	
	with(result) {
		sType = VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO;
		pNext = null;
		flags = 0; // reserved for future use
	}
	return result;
}


private Type jsonReaderForVulkanStructureWithOnlySpecifiedFields(Type, string[string] typeLookup, string ignore = "")(JsonValue jsonValue) {
	import std.format : format;
	
	string currentField;
	try {
		Type resultStructure;
		with(resultStructure) {
			foreach( iterationMemberName; __traits(allMembers, Type) ) {
				import std.ascii : isUpper;
				enum isPointer = iterationMemberName[0] == 'p' && iterationMemberName[1].isUpper; // pointers are indicated by a p followed by an uppercase letter
				enum isCount = iterationMemberName.length > 5 && iterationMemberName[$-5..$] == "Count";
				enum otherIgnoreFields = iterationMemberName == "sType" || iterationMemberName == ignore;
				enum ignore = isCount || isPointer || otherIgnoreFields; // ignore count fields and pointer fields
				
				static if( !ignore ) {// we ignore certain fields
					currentField = iterationMemberName;
					
					// TODO< special case for bool>
					
					enum typeOfIterationName = typeLookup[iterationMemberName];
					enum isNativeType = typeOfIterationName == "uint32_t" || typeOfIterationName == "float";
					enum isEnum = /*iterationMemberName == "flags" || */(typeOfIterationName.length >= 4 && typeOfIterationName[$-4..$] == "Bits") || (typeOfIterationName.length >= 8 && typeOfIterationName[$-8..$] == "FlagBits");
					enum isBool = typeOfIterationName == "VkBool32";
					enum isFlags =
						/* ignore the field called flags */iterationMemberName != "flags" &&
						typeOfIterationName.length > 5 && typeOfIterationName[$-5..$] == "Flags";
					
					static if( isFlags || isEnum ) {
						enum enumTypeName = isEnum ? typeLookup[iterationMemberName] : /* remove "Flags"*/typeOfIterationName[0..$-5] ~ "FlagBits";
						mixin("resultStructure.%1$s = cast(%2$s)or(jsonValue[\"%1$s\"].str, &convertFlagToNumber!(erupted.types.%3$s));\n".format(iterationMemberName, typeLookup[iterationMemberName], enumTypeName));
					}
					else static if( isBool ) {
						mixin("resultStructure.%1$s = cast(%2$s)(jsonValue[\"%1$s\"].str == \"VK_TRUE\" ? VK_TRUE : VK_FALSE);\n".format(iterationMemberName, typeLookup[iterationMemberName]));
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
