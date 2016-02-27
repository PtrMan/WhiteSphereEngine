module vulkan.Validation;

import std.stdio;

import api.vulkan.Vulkan;
import helpers.Conversion : convertCStringToD;


// used for validating vkCreateGraphicsPipelines
void validateVkGraphicsPipelineCreateInfo(uint depth, VkGraphicsPipelineCreateInfo graphicsPipelineCreateInfo) {
	writeln(spaceDepth(depth) ~ "VkGraphicsPipelineCreateInfo");
	writeln(spaceDepth(depth+1) ~ "sType = ", graphicsPipelineCreateInfo.sType);
	writeln(spaceDepth(depth+1) ~ "pNext = ", graphicsPipelineCreateInfo.pNext);
	writeln(spaceDepth(depth+1) ~ "flags = ", graphicsPipelineCreateInfo.flags);
	writeln(spaceDepth(depth+1) ~ "stageCount = ", graphicsPipelineCreateInfo.stageCount);
	
	if( graphicsPipelineCreateInfo.pStages is null ) {
		writeln(spaceDepth(depth+1) ~ "pStages = ", "NULL<error>"); // after spec tis must be a valid pointer
	}
	else {
		for( uint stageI = 0; stageI < graphicsPipelineCreateInfo.stageCount; stageI++ ) {
			writeln(spaceDepth(depth+1) ~ "pStages[", stageI ,"] = ");
			
			validateVkPipelineShaderStageCreateInfo(depth+1, graphicsPipelineCreateInfo.pStages[stageI]);
		}
	}
	
	if( graphicsPipelineCreateInfo.pVertexInputState is null ) {
		writeln(spaceDepth(depth+1) ~ "pVertexInputState = ", "NULL<unknown>");
	}
	else {
		writeln(spaceDepth(depth+1) ~ "pVertexInputState = ", "TODO");

		// TODO
		// dump all stages
	}
	
	if( graphicsPipelineCreateInfo.pInputAssemblyState is null ) {
		writeln(spaceDepth(depth+1) ~ "pInputAssemblyState = ", "NULL<unknown>");
	}
	else {
		writeln(spaceDepth(depth+1) ~ "pInputAssemblyState = ", "TODO");

		// TODO
		// dump all stages
	}
    
    if( graphicsPipelineCreateInfo.pTessellationState is null ) {
		writeln(spaceDepth(depth+1) ~ "pTessellationState = ", "NULL<valid>"); // after spec valid
	}
	else {
		writeln(spaceDepth(depth+1) ~ "pTessellationState = ", "TODO");

		// TODO
		// dump all stages
	}
    
    if( graphicsPipelineCreateInfo.pViewportState is null ) {
		writeln(spaceDepth(depth+1) ~ "pViewportState = ", "NULL<unknown>");
	}
	else {
		writeln(spaceDepth(depth+1) ~ "pViewportState = ", "TODO");

		// TODO
		// dump all stages
	}

    if( graphicsPipelineCreateInfo.pRasterizationState is null ) {
		writeln(spaceDepth(depth+1) ~ "pRasterizationState = ", "NULL<unknown>");
	}
	else {
		writeln(spaceDepth(depth+1) ~ "pRasterizationState = ", "TODO");

		// TODO
		// dump all stages
	}

	if( graphicsPipelineCreateInfo.pMultisampleState is null ) {
		writeln(spaceDepth(depth+1) ~ "pMultisampleState = ", "NULL<unknown>");
	}
	else {
		writeln(spaceDepth(depth+1) ~ "pMultisampleState = ", "TODO");

		// TODO
		// dump all stages
	}
	
	if( graphicsPipelineCreateInfo.pDepthStencilState is null ) {
		writeln(spaceDepth(depth+1) ~ "pDepthStencilState = ", "NULL<unknown>");
	}
	else {
		writeln(spaceDepth(depth+1) ~ "pDepthStencilState = ", "TODO");

		// TODO
		// dump all stages
	}

	if( graphicsPipelineCreateInfo.pColorBlendState is null ) {
		writeln(spaceDepth(depth+1) ~ "pColorBlendState = ", "NULL<unknown>");
	}
	else {
		writeln(spaceDepth(depth+1) ~ "pColorBlendState = ", "TODO");

		// TODO
		// dump all stages
	}
	
	if( graphicsPipelineCreateInfo.pDynamicState is null ) {
		writeln(spaceDepth(depth+1) ~ "pDynamicState = ", "NULL<valid>"); // after spec valid
	}
	else {
		writeln(spaceDepth(depth+1) ~ "pDynamicState = ", "TODO");

		// TODO
		// dump all stages
	}

	{
		writeln(spaceDepth(depth+1) ~ "layout = ", "TODO");
	}
	
	{
		writeln(spaceDepth(depth+1) ~ "renderPass = ", "TODO");
	}
	
	{
		writeln(spaceDepth(depth+1) ~ "subpass = ", graphicsPipelineCreateInfo.subpass);
	}

	{
		writeln(spaceDepth(depth+1) ~ "basePipelineHandle = ", graphicsPipelineCreateInfo.basePipelineHandle);
	}
	
	{
		writeln(spaceDepth(depth+1) ~ "basePipelineIndex = ", graphicsPipelineCreateInfo.basePipelineIndex);
	}
}

private void validateVkPipelineShaderStageCreateInfo(uint depth, immutable(VkPipelineShaderStageCreateInfo) pipelineShaderStageCreateInfo) {
	writeln(spaceDepth(depth) ~ "VkPipelineShaderStageCreateInfo");
	writeln(spaceDepth(depth+1) ~ "sType = ", pipelineShaderStageCreateInfo.sType);
	writeln(spaceDepth(depth+1) ~ "pNext = ", pipelineShaderStageCreateInfo.pNext);
	writeln(spaceDepth(depth+1) ~ "flags = ", pipelineShaderStageCreateInfo.flags);
	writeln(spaceDepth(depth+1) ~ "stage = ", pipelineShaderStageCreateInfo.stage); // TODO< decode >
	
	{
		writeln(spaceDepth(depth+1) ~ "module = ");
		// TODO
	}
	
	
	writeln(spaceDepth(depth+1) ~ "pName = ", convertCStringToD(pipelineShaderStageCreateInfo.pName));
	
	if( pipelineShaderStageCreateInfo.pSpecializationInfo is null ) {
		writeln(spaceDepth(depth+1) ~ "pSpecializationInfo = NULL<unknown>");
	}
	else {
		// TODO
	}
}

private string spaceDepth(uint depth) {
	string result;
	
	for( uint i = 0; i < depth; i++ ) {
		result ~= "   ";
	}
	
	return result;
}