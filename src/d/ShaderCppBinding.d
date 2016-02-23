module ShaderCppBinding;

import core.stdc.stdlib : malloc;
import core.stdc.string : memcpy, strlen;
import std.string; // for tostringz

import Shader : Shader;

extern (C++) void *ShaderCppBindingCTOR() {
	Shader ptr = new Shader();
	return cast(void*)ptr;
}

extern (C++) void ShaderCppBindingcompile(void *ptr, char *source, int type, int *returnCode, char **compileErrorMessage) {
	Shader.EnumReturnCodes returnCodeD;
	string CompileErrorMessage;
	string sourceDString = cast(string)source[0 .. strlen(source)];
	(cast(Shader)ptr).compile(sourceDString, cast(Shader.EnumShaderType)type, returnCodeD, CompileErrorMessage);
	*returnCode = cast(int)returnCodeD;

	// convert compileErrorMessage to c string
	auto cstring = toStringz(CompileErrorMessage);
	*compileErrorMessage = cast(char*)malloc(CompileErrorMessage.length+1);
	memcpy(*compileErrorMessage, cstring, CompileErrorMessage.length+1);
}

extern (C++) int ShaderCppBindinggetHandle(void *ptr) {
	return cast(int)(cast(Shader)ptr.getHandle());
}
