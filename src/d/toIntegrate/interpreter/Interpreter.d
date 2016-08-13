module Interpreter.Interpreter;



/*
 class OpcodeType has to have the userprovided static methods

 conditionFulfilled(Opcode, State) : checks if the condition of opcode is fulfilled reading the state


 */

alias uint InstructionPointerType;

// context of a stackframe, points at an instruction in the coresponding function
class StackFrame {
	public uint functionIndex;
	public InstructionPointerType instructionPointer;
}

abstract class State {
	public bool takebranch;

	public final @property topContext() {
		return stackFrames[$-1];
	}

	public StackFrame[] stackFrames;
}

abstract class Opcode {
	public InstructionPointerType jumpDestination;
}

// mixin template to check condition of an opcode
mixin template CheckCondition(StateType, OpcodeType) {
	void checkCondition(StateType state, OpcodeType opcode) {
		state.takebranch = OpcodeType.conditionFulfilled(opcode, state);
	}
}

mixin template ConditionalBranch(StateType, OpcodeType) {
	void conditionalBranch(StateType state, OpcodeType opcode) {
		if( state.takebranch ) {
			state.topContext.instructionPointer = opcode.jumpDestination;
		}
	}
}

mixin template Branch(StateType, OpcodeType) {
	void branch(StateType state, OpcodeType opcode) {
		state.topContext.instructionPointer = opcode.jumpDestination;
	}
}

// used for mixins
public string binaryOperationOnSeperatedSourceAndDestination(string sourceLeft, string sourceRight, string destination, string operation) {
	return destination ~ " = " ~ sourceLeft ~ " " ~ operation ~ " " ~ sourceRight ~ ";";
}

// used for mixins
public string binaryOperationOnSameSource(string source, string destination, string operation) {
	return destination ~ " " ~ operation ~ "= " ~ source ~ ";";
}


// main class which puts it all together, is the main interpreter entry point			
template InterpreterContext(ControlType, OpcodeType, StateType) {
	class InterpreterContext {
		public final void step() {
			StackFrame topStackFrame = protectedState.topStackFrame;
			InstructionPointerType currentInstructionPointer = topStackFrame.instructionPointer;
			topStackFrame.instructionPointer++;
			ControlType.dispatchOpcode(/* TODO< retrive opcode from function */opcodes[currentInstructionPointer], protectedState);
		}

		public final @property StateType state() {
			return protectedState;
		}

		protected StateType protectedState;
		protected OpcodeType[] opcodes;
	}
}

class InterpreterException : Exception  {
	public final this(string msg) {
        super(msg);
    }
}


unittest {
	import std.algorithm.iteration : map;
	import std.array : array;
	import std.variant : Variant;

	const uint NUMBEROFREGISTERS = 8;

	final class State2 : State {
		public static class Register {
			Variant variant;

			public final @property bool isSet() {
				return variant.hasValue;
			}
		}

		public Register[NUMBEROFREGISTERS] registers;

		public alias Variant delegate(State2 state, Variant[] arguments) FunctionType;

		public FunctionType[string] functions;
	}

	final class Opcode2 : Opcode {
		public enum EnumType {
			CONDITION = 1, // must be 1
			BRANCH = 2, // can be ored together with CONDITION
			FUNCTIONINVOCATION = 4, // can be ored together with CONDITION

			SETCONSTANT,

			//ADD,
			//SUB,
			//MUL,
			//DIV,
			/// SQRT

			BINARYPRIMITIVEMATH,


			CONDITION_GREATER = 1024<<0,
			CONDITION_EQUAL = 1024<<1,
			CONDITION_LESS = 1024<<2,
			CONDITION_NEGATE = 1024<<3,
		}

		public EnumType type;
		public uint registerA, registerB, registerTarget;
		public Variant constant;

		public enum EnumFunctioncallType {
			EXTERNAL, // calls into D function lookup by name
			INTERNAL // calls into internal function looked up by index constant (as uint)
		}

		public EnumFunctioncallType functioncallType;
		public uint[] functionCallParameterRegisters;
		// registerTarget will be set with the result value

		public static bool conditionFulfilled(Opcode2 opcode, State2 state) {
			assert(opcode.type & EnumType.CONDITION);

			assert(opcode.registerA < state.registers.length);
			assert(opcode.registerB < state.registers.length);
			if( !state.registers[opcode.registerA].isSet ) {
				throw new InterpreterException("RegisterA has to be set for conditionFulfilled()!");
			}
			if( !state.registers[opcode.registerB].isSet ) {
				throw new InterpreterException("RegisterB has to be set for conditionFulfilled()!");
			}


			bool conditionSatisfied = false;
			conditionSatisfied |= ((opcode.type & EnumType.CONDITION_GREATER) && state.registers[opcode.registerA].variant > state.registers[opcode.registerB].variant );
			conditionSatisfied |= ((opcode.type & EnumType.CONDITION_EQUAL) && state.registers[opcode.registerA].variant == state.registers[opcode.registerB].variant );
			conditionSatisfied |= ((opcode.type & EnumType.CONDITION_LESS) && state.registers[opcode.registerA].variant < state.registers[opcode.registerB].variant );
			if( opcode.type & EnumType.CONDITION_NEGATE ) {
				conditionSatisfied = !conditionSatisfied;
			}
			return conditionSatisfied;
		}

		public final @property bool isCondition() {
			return checkTypeForFlag(EnumType.CONDITION);
		}

		public final @property bool isBranch() {
			return checkTypeForFlag(EnumType.BRANCH) && !checkTypeForFlag(EnumType.CONDITION);
		}

		public final @property bool isConditionalBranch() {
			return checkTypeForFlag(EnumType.BRANCH) && checkTypeForFlag(EnumType.CONDITION);
		}

		public final @property bool isFunctionInvocation() {
			return checkTypeForFlag(EnumType.FUNCTIONINVOCATION) && !checkTypeForFlag(EnumType.CONDITION);
		}

		public final @property bool isConditionalFunctionInvocation() {
			return checkTypeForFlag(EnumType.FUNCTIONINVOCATION) && checkTypeForFlag(EnumType.CONDITION);
		}

		public final @property bool isSetConstant() {
			return checkTypeForFlag(EnumType.SETCONSTANT);
		}

		public final @property bool isBinaryPrimitiveMath() {
			return checkTypeForFlag(EnumType.BINARYPRIMITIVEMATH);
		}

		protected final bool checkTypeForFlag(EnumType flag) {
			return (type & flag) != 0;
		}

		public final @property Variant mathOperation() {
			return constant;
		}


	}

	final class Control {
		public static void dispatchOpcode(Opcode2 opcode, State2 state) {
			if( opcode.isCondition ) {
				mixin CheckCondition!(State2, Opcode2);
				checkCondition(state, opcode);
			}
			else if( opcode.isConditionalBranch ) {
				mixin ConditionalBranch!(State2, Opcode2);
				conditionalBranch(state, opcode);
			}
			else if( opcode.isBranch ) {
				mixin Branch!(State2, Opcode2);
				branch(state, opcode);
			}
			else if( opcode.isFunctionInvocation ) {
				dispatchFunctionCall(opcode, state);
			}
			else if( opcode.isConditionalFunctionInvocation ) {
				if( state.takebranch ) {
					dispatchFunctionCall(opcode, state);
				}
			}
			else if( opcode.isSetConstant ) {
				state.registers[opcode.registerTarget].variant = opcode.constant;
			}
			else if( opcode.isBinaryPrimitiveMath ) {
				string mathOperation = opcode.mathOperation.get!string();

				// TODO< register validation >

				bool isOnSameSource = mathOperation == "+=" || mathOperation == "-=" || mathOperation == "*=" ||  mathOperation == "/=";
				if( !isOnSameSource ) {
					// TODO< register validation >
				}

				if( mathOperation == "+=" ) {
					mixin(binaryOperationOnSameSource("state.registers[opcode.registerTarget].variant", "state.registers[opcode.registerTarget].variant", "+"));
				}
				else if( mathOperation == "-=" ) {
					mixin(binaryOperationOnSameSource("state.registers[opcode.registerTarget].variant", "state.registers[opcode.registerTarget].variant", "-"));
				}
				else if( mathOperation == "*=" ) {
					mixin(binaryOperationOnSameSource("state.registers[opcode.registerTarget].variant", "state.registers[opcode.registerTarget].variant", "*"));
				}
				else if( mathOperation == "/=" ) {
					mixin(binaryOperationOnSameSource("state.registers[opcode.registerTarget].variant", "state.registers[opcode.registerTarget].variant", "/"));
				}

				else if( mathOperation == "+" ) {
					mixin(binaryOperationOnSeperatedSourceAndDestination("state.registers[opcode.registerTarget].variant", "state.registers[opcode.registerTarget].variant", "state.registers[opcode.registerTarget].variant", "+"));
				}
				else if( mathOperation == "-" ) {
					mixin(binaryOperationOnSeperatedSourceAndDestination("state.registers[opcode.registerTarget].variant", "state.registers[opcode.registerTarget].variant", "state.registers[opcode.registerTarget].variant", "-"));
				}
				else if( mathOperation == "*" ) {
					mixin(binaryOperationOnSeperatedSourceAndDestination("state.registers[opcode.registerTarget].variant", "state.registers[opcode.registerTarget].variant", "state.registers[opcode.registerTarget].variant", "*"));
				}
				else if( mathOperation == "/" ) {
					mixin(binaryOperationOnSeperatedSourceAndDestination("state.registers[opcode.registerTarget].variant", "state.registers[opcode.registerTarget].variant", "state.registers[opcode.registerTarget].variant", "/"));
				}
				else {
					// TODO< throw >
				}
			}
			else {
				throw new InterpreterException("Dispatch internal error!");
			}
		}

		// doesn't check condition
		protected static void dispatchFunctionCall(Opcode2 opcode, State2 state) {
			Variant[] retriveFunctioncallParameters() {
				Variant retriveParameter(uint register) {
					assert(register < state.registers.length);
					Variant registerValue = state.registers[register];
					if( !registerValue.hasValue ) {
						throw new InterpreterException("Register for function call is not set!");
					}
					return registerValue;
				}

				return array(map!(retriveParameter)(opcode.functionCallParameterRegisters));
			}

			if( opcode.functioncallType == Opcode2.EnumFunctioncallType.EXTERNAL ) {
				State2.FunctionType lookedupFunction = state.functions[opcode.constant.get!string()];
				Variant[] parameters = retriveFunctioncallParameters();

				Variant result = lookedupFunction(state, parameters);

				// writeback result
				assert(opcode.registerTarget < state.registers.length);
				state.registers[opcode.registerTarget].variant = result;
			}
			else { // internal function
				assert( opcode.constant.get!int() >= 0);
				uint functionIndex = cast(uint)opcode.constant.get!int();

				// TODO
				assert(false, "TODO");
			}

			
		}
	}
}

// example of a very simple interpreter which checks a variable
unittest {

}