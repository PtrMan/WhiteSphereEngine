module ShaderUtilities;

import std.file : readText;

import Shader : Shader;
import ErrorStack : ErrorStack;
import ShaderProgram : ShaderProgram;

class ShaderUtilities {
	public static class BindingLocation {
		uint Location;
		string Attribute;

		this(uint Location, string Attribute) {
			this.Location = Location;
			this.Attribute = Attribute;
		}
	}

	public static ShaderProgram createProgramLinkedCompileFromFiles(string vertexShaderPath, string fragmentShaderPath, BindingLocation[] BindingLocations, ErrorStack errorStack) {
		errorStack.push(__FILE__, __LINE__);
		scope(exit) errorStack.pop();

		ShaderProgram program = createProgramUnlinked(vertexShaderPath, fragmentShaderPath, errorStack);
		if( !errorStack.inNormalState ) {
			return null;
		}

		foreach( IterationBindingLocation; BindingLocations ) {
			program.bindAttribLocation(IterationBindingLocation.Location, IterationBindingLocation.Attribute);
		}

		ShaderProgram.EnumReturnCode shaderProgramReturnCode;
		string errorMessage, LinkerLog;
      	program.link(shaderProgramReturnCode, errorMessage, LinkerLog);
      	if( shaderProgramReturnCode == ShaderProgram.EnumReturnCode.OUTOFMEMORY ) {
      		errorStack.setFatalError("Outofmemory", [], __FILE__, __LINE__);
      		return null;
      	}
      	else if( shaderProgramReturnCode == ShaderProgram.EnumReturnCode.FAILED ) {
      		errorStack.setRecoverableError("Linking of glsl program failed!", [errorMessage], __FILE__, __LINE__);
      		return null;
      	}

      	return program;
	}

	/** \brief tries to create a shader program
    *
    * \param VertexShaderPath ...
    * \param FragmentShaderPath ...
    * \param Success will be true if everything was successful
    * \return ShaderProgram if successful, null otherwise
    */
	public static ShaderProgram createProgramUnlinked(string VertexShaderPath, string FragmentShaderPath, ErrorStack errorStack) {
		Shader.EnumReturnCodes ReturnCode;

		string VertexContent;
		string FragmentContent;
		string CompileErrorMessage;

		errorStack.push(__FILE__, __LINE__);
		scope(exit) errorStack.pop();

		// TODO< save the shader objects after successful loading into a map >
		Shader VertexShader = new Shader();
		Shader FragmentShader = new Shader();

		// load all files

		// TODO< only if they hasn't allready been loaded >

		// TODO< catch errors >
		VertexContent = readText(VertexShaderPath);

		// TODO< catch errors >
		FragmentContent = readText(FragmentShaderPath);


		VertexShader.compile(VertexContent, Shader.EnumShaderType.VERTEXSHADER, ReturnCode, CompileErrorMessage);

		if( ReturnCode == Shader.EnumReturnCodes.OK )
		{
		}
		else if( ReturnCode == Shader.EnumReturnCodes.COMPILATIONERROR ) {
			errorStack.setRecoverableError("Can't compile glsl shader!", ["vertexshader", CompileErrorMessage], __FILE__, __LINE__);
			return null;
		}
		else if( ReturnCode == Shader.EnumReturnCodes.OUTOFMEMORY ) {
			errorStack.setFatalError("Outofmemory", [], __FILE__, __LINE__);
			return null;
		}
		else if( ReturnCode == Shader.EnumReturnCodes.OK_SOFTWARE ) {
		 	errorStack.setRecoverableError("Shader was compiled in Software Mode!", [], __FILE__, __LINE__);
			return null;
		}
		else if( ReturnCode == Shader.EnumReturnCodes.FAILED ) {
		 	errorStack.setRecoverableError("Compilation failed!", [], __FILE__, __LINE__);
			return null;
		}
		else {
		 	errorStack.setRecoverableError("Unknown Error!", [], __FILE__, __LINE__);
			return null;
		}

		FragmentShader.compile(FragmentContent, Shader.EnumShaderType.FRAGMENTSHADER, ReturnCode, CompileErrorMessage);
		if( ReturnCode == Shader.EnumReturnCodes.OK ) {
		}
		else if( ReturnCode == Shader.EnumReturnCodes.COMPILATIONERROR ) {
			errorStack.setRecoverableError("Can't compile glsl shader!", ["fragmentShader", CompileErrorMessage], __FILE__, __LINE__);
			return null;
		}
		else if( ReturnCode == Shader.EnumReturnCodes.OUTOFMEMORY ) {
			errorStack.setFatalError("Outofmemory", [], __FILE__, __LINE__);
			return null;
		}
		else {
		 	errorStack.setRecoverableError("Unknown Error!", [], __FILE__, __LINE__);
			return null;
		}

		ShaderProgram Program = new ShaderProgram();

		Program.create();
		Program.attach(VertexShader);
		Program.attach(FragmentShader);

		return Program;
	}
}
