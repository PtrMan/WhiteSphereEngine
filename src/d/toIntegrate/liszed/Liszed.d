module liszed.Liszed;

class LizedInternalException : Exception {
	public this(string message) {
		super(message);
		this.message = message;
	}
		
	public final @property string getMessage() {
		return message;
	}
	
	
	protected string message;
}

class FunctionalName {
	public final this(string name) {
		this.protectedName = name;
	}

	public final @property string nameAsString() {
		return protectedName;
	}

	protected string protectedName;
}

// TODO< represent array and other special structures >
// is the representation for the instruction in the functional language
class FunctionalTuple {
	public static FunctionalTuple makeName(string name) {
		FunctionalTuple resultTuple = new FunctionalTuple(EnumType.NAME);
		resultTuple.protectedName = new FunctionalName(name);
		return resultTuple;
	}

	public static FunctionalTuple makeTuple(FunctionalTuple[] children) {
		FunctionalTuple resultTuple = new FunctionalTuple(EnumType.TUPLE);
		resultTuple.protectedTuple = children;
		return resultTuple;
	}

	public static FunctionalTuple makeInteger(int integer) {
		FunctionalTuple resultTuple = new FunctionalTuple(EnumType.INTEGER);
		resultTuple.protectedInteger = integer;
		return resultTuple;
	}

	protected final this(EnumType type) {
		this.type = type;
	}

	public final @property FunctionalName firstAsName() {
		return tuple[0].name;
	}

	public final @property FunctionalTuple[] secondAndFollowing() {
		return tuple[1..$];
	}

	public final @property FunctionalName name() {
		assert(type == EnumType.NAME);
		return protectedName;
	}

	public final @property FunctionalTuple[] tuple() {
		assert(type == EnumType.TUPLE);
		return protectedTuple;
	}

	// TODO< overload reading [] >

	enum EnumType {
		NAME,
		INTEGER,
		TUPLE
	}

	protected EnumType type;
	protected FunctionalName protectedName;
	protected FunctionalTuple[] protectedTuple;
	protected int protectedInteger;
}



// decorates the FunctionalTuple with informations required in the optimisation and codegen
class DecoratedFunctionalTuple {
	
	/*
	protected static class DecoratedSingleElement {
		public final this(FunctionalTuple functionalTuple) {
			this.functionalTuple = functionalTuple;
		}

		public FunctionalTuple functionalTuple;

	}

	protected final this(DecoratedSingleElement[] decoratedSingleElements) {
		this.decoratedSingleElements = decoratedSingleElements;
	}

	public static DecoratedFunctionalTuple makeFromFunctionalTuple(FunctionalTuple functionalTuple) {
		DecoratedSingleElement[] decoratedSingleElements;

		foreach( iterationChildElement; functionalTuple ) {
			decoratedSingleElements ~= new DecoratedSingleElement(iterationChildElement);
		}

		return new DecoratedFunctionalTuple(decoratedSingleElements);
	}

	public final this(FunctionalTuple functionalTuple) {
		this.functionalTuple = functionalTuple;
	}

	public final @property FunctionalName name() {
		assert(type == EnumType.NAME);
		return protectedName;
	}

	public final @property FunctionalTuple[] tuple() {
		assert(type == EnumType.TUPLE);
		return protectedTuple;
	}




	protected DecoratedSingleElement[] decoratedSingleElements;
	*/

	public final this(DecoratedFunctionalTuple[] children, FunctionalTuple wrapedFunctionalTuple) {
		this.protectedChildren = children;
		this.protectedWrapedFunctionalTuple = wrapedFunctionalTuple;
	}

	public final @property FunctionalName firstAsName() {
		return protectedChildren[0].protectedWrapedFunctionalTuple.name;
	}

	public final @property DecoratedFunctionalTuple[] secondAndFollowing() {
		return protectedChildren[1..$];
	}

	public final @property TypeDescriptor[] secondAndFollowingResultTypeDescriptors() {
		TypeDescriptor[] result;
		foreach( iterationArgument; secondAndFollowing ) {
			result ~= iterationArgument.resultDescriptor.typeDescriptor;
		}
		return result;
	}


	public final DecoratedFunctionalTuple opIndex(size_t index) {
		return protectedChildren[index];
	}

	protected DecoratedFunctionalTuple[] protectedChildren;

	protected FunctionalTuple protectedWrapedFunctionalTuple;

	public ResultDescriptor resultDescriptor; // describes information about the computed result of this FunctionalTuple, can be null
	public VariableScopeDescriptor variableScopeDescriptor; // describes variables in this scope of this expression, links to the variable scope of the parent
}

/+

final protected void emitSingle(FunctionalTuple currentNode) {
	string firstName = currentNode.firstAsName;

	TransformedFunctionEntry transformedFunctionEntry;

	if( firstName == "seq" ) {
		transformedFunctionEntry = emitSequence(currentNode.secondAndFollowing);
	}
	else if( firstName == "if" ) {
		transformedFunctionEntry = emitCondition(currentNode.secondAndFollowing);
	}

	return transformedFunctionEntry;
}+/


// TODO< composite type descriptors >
class TypeDescriptor {
	public enum EnumPrimitiveType {
		INT,
		DOUBLE,
		BOOL
	}

	public static TypeDescriptor makePrimitive(EnumPrimitiveType primitiveType) {
		TypeDescriptor result = new TypeDescriptor();
		result.protectedPrimitiveType = primitiveType;
		return result;
	}

	public final @property isPrimitive() {
		return true; // currently no composed or other types are implemented!
	}

	public final @property EnumPrimitiveType primitiveType() {
		assert(isPrimitiveType);
		return protectedPrimitiveType;
	}

	public final bool comparePrimitiveType(EnumPrimitiveType primitiveType) {
		assert(isPrimitiveType);
		return this.primitiveType == primitiveType;
	}

	public final @property bool isNumeric() {
		with(EnumPrimitiveType) {
			return protectedPrimitiveType == INT || protectedPrimitiveType == DOUBLE;
		}
	}

	protected final this() {}

	protected EnumPrimitiveType protectedPrimitiveType;
}

class TypeInferenceRules {
	public static TypeDescriptor.EnumPrimitiveType getImplicitlyConvertableResultOfNumeric(TypeDescriptor.EnumPrimitiveType a, TypeDescriptor.EnumPrimitiveType b) {
		with(TypeDescriptor.EnumPrimitiveType) {
			assert(a.isNumeric && b.isNumeric);

			if( a == b ) {
				return a;
			}
			else if( a == DOUBLE || b == DOUBLE ) {
				return DOUBLE;
			}
			else {
				return INT;
			}
		}
	}

	public static TypeDescriptor.EnumPrimitiveType getImplicitlyConvertableResultOfNumeric(TypeDescriptor.EnumPrimitiveType[] arr) {
		import std.algorithm.iteration : fold;
		return arr.fold!((a, b) => getImplicitlyConvertableResultOfNumeric(a, b));
	}
}

class ResultDescriptor {
	public final this(VariableDescriptor variable) {
		this.variable = variable;
	}

	public VariableDescriptor variable;
}

class VariableDescriptor {
	// is the variable a temporary variable (just used inside a fixed scope)
	enum EnumTemporary {
		NOTEMPORARY,
		TEMPORARY
	}

	public final this(TypeDescriptor type, string referencedName) {
		this.type = type;
		this.referencedName = referencedName;
	}

	public static VariableDescriptor makeTemporary(TypeDescriptor type) {
		VariableDescriptor result = new VariableDescriptor(type, "");
		result.temporary = EnumTemporary.TEMPORARY;
		return result;
	}

	public final @property bool isTemporary() {
		return temporary == EnumTemporary.TEMPORARY;
	}

	// TODO< allocated struct it can be found in >
	// TODO< maybe we need here more indirection >
	public string referencedStructName; // references the name of the struct in which this variable can be found

	public EnumTemporary temporary = EnumTemporary.NOTEMPORARY;

	public TypeDescriptor type;

	protected string referencedName; // name of the variable as used in the functional code, is _not_ the name in the struct

	// used to reference in struct
	public final @property string nameInStruct() {
		assert(!isTemporary);

		return "var" ~ referencedName;
	}
}





class VariableScopeDescriptor {
	enum EnumRecursive {
		NONRECURSIVE,
		RECURSIVE
	}

	public final VariableDescriptor lookupByNameRecursive(string name, out bool found, EnumRecursive recursive = EnumRecursive.RECURSIVE) {
		found = false;

		if( name in protectedVariableDescriptorsByName ) {
			found = true;
			return protectedVariableDescriptorsByName[name];
		}

		if( recursive == EnumRecursive.NONRECURSIVE ) {
			return null;
		}

		if( parent is null ) {
			return null;
		}

		return parent.lookupByNameRecursive(name, found);
	}

	public final @property variableDescriptorsByName() {
		return protectedVariableDescriptorsByName;
	}

	protected VariableDescriptor[string] protectedVariableDescriptorsByName;
	protected VariableScopeDescriptor parent; // can be null
}


class GeneralHelpers {
	public final VariableDescriptor createTemporaryVariableWithPrimitiveType(TypeDescriptor.EnumPrimitiveType primitiveType) {
		return createTemporaryVariableWithType(TypeDescriptor.makePrimitive(primitiveType));
	}

	public final VariableDescriptor createTemporaryVariableWithType(TypeDescriptor dataType) {
		return VariableDescriptor.makeTemporary(dataType);
	}



}

abstract class AbstractStructureEmitter {
	public abstract void emitStructureForVariableScope(VariableScopeDescriptor variableScopeDescriptor);
}

import std.array : Appender;

class CppStructureEmitter : AbstractStructureEmitter {
	public final this(Appender!string appender) {
		this.appender = appender;
	}

	public void emitStructureForVariableScope(VariableScopeDescriptor variableScopeDescriptor) {
		appendLine("struct TODONAMEME {");

		foreach( iterationVariableDescriptor; variableScopeDescriptor.variableDescriptorsByName.values ) {
			appendLine(getTypeAsStringOf(iterationVariableDescriptor.type) ~ " " ~ iterationVariableDescriptor.nameInStruct ~ ";");
		}

		appendLine("};");
		appendLine("");
	}

	protected final string getTypeAsStringOf(TypeDescriptor typeDescriptor) {
		final switch(typeDescriptor.primitiveType) with (TypeDescriptor.EnumPrimitiveType) {
			case DOUBLE: return "double";
			case INT: return "int";
			case BOOL: return "bool";
		}
	}

	protected final void appendLine(string value) {
		appender ~= value;
		appender ~= "\n";
	}

	protected final void append(string value) {
		appender ~= value;
	}

	protected Appender!string appender;
}


abstract class AbstractInstructionEmitter {
	public enum EnumPrimitveMathOp {
		ADD,
		SUB,
		MUL,
		DIV
	}

	struct Comparision {
		public enum EnumComparisionType {
			GREATER,
			GREATEREQUAL,
			LESS,
			LESSEQUAL,
			EQUAL,
			NONEQUAL
		}

		public final @property bool checkGreater() {
			with(EnumComparisionType) {
				return comparisionType == GREATER || comparisionType == GREATEREQUAL;
			}
		}

		public final @property bool checkLess() {
			with(EnumComparisionType) {
				return comparisionType == LESS || comparisionType == LESSEQUAL;
			}
		}

		public final @property bool checkEqual() {
			with(EnumComparisionType) {
				return comparisionType == EQUAL || comparisionType == LESSEQUAL || comparisionType == GREATEREQUAL;
			}
		}

		public EnumComparisionType comparisionType;
	}

	public final this(GeneralHelpers generalHelpers) {
		this.generalHelpers = generalHelpers;
	}

	// root is output
	public abstract void emitPrimitiveMath(EnumPrimitveMathOp mathOp, DecoratedFunctionalTuple[] args, DecoratedFunctionalTuple root);

	// root is output
	public abstract void emitComparision(Comparision comparision, DecoratedFunctionalTuple argLeft, DecoratedFunctionalTuple argRight, DecoratedFunctionalTuple root);

	// root is output
	public void emitNth(DecoratedFunctionalTuple argVariable, DecoratedFunctionalTuple argIndex, DecoratedFunctionalTuple root);


	// just to simplify the using code a bit
	protected final VariableDescriptor createTemporaryVariableWithPrimitiveType(TypeDescriptor.EnumPrimitiveType primitiveType) {
		return generalHelpers.createTemporaryVariableWithPrimitiveType(primitiveType);
	}

	protected final VariableDescriptor createTemporaryVariableWithType(TypeDescriptor variableType) {
		return generalHelpers.createTemporaryVariableWithType(variableType);
	}


	protected GeneralHelpers generalHelpers;

}

import std.format : format;

class EmitInstructionsCpp : AbstractInstructionEmitter {
	public final this(Appender!string appender, GeneralHelpers generalHelpers) {
		super(generalHelpers);
		this.appender = appender;
	}

	public void emitPrimitiveMath(AbstractInstructionEmitter.EnumPrimitveMathOp mathOp, DecoratedFunctionalTuple[] args, DecoratedFunctionalTuple root) {
		assert(args.length > 0);

		VariableDescriptor accumulatorDescriptor = createTemporaryVariableWithType(args[0].resultDescriptor.variable.type);
		operationMoveValue(accumulatorDescriptor, args[0].resultDescriptor.variable);

		foreach( DecoratedFunctionalTuple iterationArg; args[1..$] ) {
			final switch( mathOp ) with (EnumPrimitveMathOp) {
				case ADD: operationPrimitiveAdd(accumulatorDescriptor, iterationArg.resultDescriptor.variable, accumulatorDescriptor); break;
				case SUB: operationPrimitiveSub(accumulatorDescriptor, iterationArg.resultDescriptor.variable, accumulatorDescriptor); break;
				case MUL: operationPrimitiveMul(accumulatorDescriptor, iterationArg.resultDescriptor.variable, accumulatorDescriptor); break;
				case DIV: operationPrimitiveDiv(accumulatorDescriptor, iterationArg.resultDescriptor.variable, accumulatorDescriptor); break;
			}
		}

		root.resultDescriptor = new ResultDescriptor(accumulatorDescriptor);
	}

	public void emitComparision(Comparision comparision, DecoratedFunctionalTuple argLeft, DecoratedFunctionalTuple argRight, DecoratedFunctionalTuple root) {
		// just assert because errors should get catched by checker
		// TODO< implement implicit conversations >
		assert(argLeft.resultDescriptor.variable.type == argRight.resultDescriptor.variable.type);

		VariableDescriptor resultDescriptor = createTemporaryVariableWithPrimitiveType(TypeDescriptor.EnumPrimitiveType.BOOL);
		operationCompare(argLeft.resultDescriptor.variable, argRight.resultDescriptor.variable, comparision, resultDescriptor);
		
		root.resultDescriptor = new ResultDescriptor(resultDescriptor);
	}

	public void emitNth(DecoratedFunctionalTuple argVariable, DecoratedFunctionalTuple argIndex, DecoratedFunctionalTuple root) {
		assert(argIndex.resultDescriptor.variable.type.comparePrimitiveType(TypeDescriptor.EnumPrimitiveType.INT));

		VariableDescriptor resultVariable = createTemporaryVariableWithType(argVariable.resultDescriptor.variable.type);
		operationAccessNth(argVariable.resultDescriptor.variable, argIndex.resultDescriptor.variable, resultVariable);

		root.resultDescriptor = new ResultDescriptor(resultVariable);
	}





	// writeoutes out the operations

	protected final void operationCompare(VariableDescriptor sourceLeft, VariableDescriptor sourceRight, Comparision comparision, VariableDescriptor destination) {
		// TODO< check types and types for equality >

		assert(sourceLeft.referencedStructName != "");
		assert(sourceLeft.nameInStruct != "");
		assert(sourceRight.referencedStructName != "");
		assert(sourceRight.nameInStruct != "");
		assert(destination.referencedStructName != "");
		assert(destination.nameInStruct != "");

		string comparisionString;

		final switch (comparision.comparisionType) with (Comparision.EnumComparisionType) {
			case GREATER: comparisionString = ">"; break;
			case GREATEREQUAL: comparisionString = ">="; break;
			case LESS: comparisionString = "<"; break;
			case LESSEQUAL: comparisionString = "<="; break;
			case EQUAL: comparisionString = "=="; break;
			case NONEQUAL: comparisionString = "!="; break;
		}

		appender ~= "%s->%s = %s->%s %s %s->%s;\n".format(
			destination.referencedStructName,
			destination.nameInStruct,
			sourceLeft.referencedStructName,
			sourceLeft.nameInStruct,
			sourceRight.referencedStructName,
			sourceRight.nameInStruct,
			comparisionString
		);
	}


	protected final void operationMoveValue(VariableDescriptor destination, VariableDescriptor source) {
		// TODO< check types for equality >
		
		assert(source.referencedStructName != "");
		assert(source.nameInStruct != "");
		assert(destination.referencedStructName != "");
		assert(destination.nameInStruct != "");

		appender ~= "// EMITTED BY: operationMoveValue\n";
		appender ~= "%s->%s = %s->%s;\n".format(
			destination.referencedStructName,
			destination.nameInStruct,
			source.referencedStructName,
			source.nameInStruct
		);
	}

	protected final void operationPrimitiveAdd(VariableDescriptor sourceLeft, VariableDescriptor sourceRight, VariableDescriptor destination) {
		// TODO< check types for equality >
		appender ~= "// EMITTED BY: operationPrimitiveAdd\n";
		operationPrimitiveBinaryString("+", sourceLeft, sourceRight, destination);
	}

	protected final void operationPrimitiveSub(VariableDescriptor sourceLeft, VariableDescriptor sourceRight, VariableDescriptor destination) {
		// TODO< check types for equality >
		appender ~= "// EMITTED BY: operationPrimitiveSub\n";
		operationPrimitiveBinaryString("-", sourceLeft, sourceRight, destination);
	}

	protected final void operationPrimitiveMul(VariableDescriptor sourceLeft, VariableDescriptor sourceRight, VariableDescriptor destination) {
		// TODO< check types for equality >
		appender ~= "// EMITTED BY: operationPrimitiveMul\n";
		operationPrimitiveBinaryString("*", sourceLeft, sourceRight, destination);
	}

	protected final void operationPrimitiveDiv(VariableDescriptor sourceLeft, VariableDescriptor sourceRight, VariableDescriptor destination) {
		// TODO< check types for equality >
		appender ~= "// EMITTED BY: operationPrimitiveDiv\n";
		operationPrimitiveBinaryString("/", sourceLeft, sourceRight, destination);
	}

	// used just as an helper
	protected final void operationPrimitiveBinaryString(string operationString, VariableDescriptor sourceLeft, VariableDescriptor sourceRight, VariableDescriptor destination) {
		// TODO< check types for equlity

		assert(sourceLeft.referencedStructName != "");
		assert(sourceLeft.nameInStruct != "");
		assert(sourceRight.referencedStructName != "");
		assert(sourceRight.nameInStruct != "");
		assert(destination.referencedStructName != "");
		assert(destination.nameInStruct != "");


		appender ~= "%s->%s = %s->%s %s %s->%s;\n".format(
			sourceLeft.referencedStructName,
			sourceLeft.nameInStruct,
			sourceRight.referencedStructName,
			sourceRight.nameInStruct,
			operationString,
			destination.referencedStructName,
			destination.nameInStruct
		);
	}

	protected final void operationAccessNth(VariableDescriptor argVariable, VariableDescriptor argIndex, VariableDescriptor resultVariable) {
		// TODO< check types >

		assert(resultVariable.referencedStructName != "");
		assert(resultVariable.nameInStruct != "");
		assert(argVariable.referencedStructName != "");
		assert(argVariable.nameInStruct != "");
		assert(argIndex.referencedStructName != "");
		assert(argIndex.nameInStruct != "");


		appender ~= "// EMITTED BY: operationAccessNth\n";
		appender ~= "%s->%s = %s->%s[%s->%s];\n".format(
			resultVariable.referencedStructName,
			resultVariable.nameInStruct,

			argVariable.referencedStructName,
			argVariable.nameInStruct,

			argIndex.referencedStructName,
			argIndex.nameInStruct
		);
		appender ~= "\n";
	}




	protected Appender!string appender;
}

// TODO< checker (class) for types and # of arguments >





class CodeEmitters {
	AbstractInstructionEmitter instructionEmitter;
	AbstractStructureEmitter structureEmitter;
}

import ArrayQueue;

// see https://en.wikipedia.org/wiki/Tree_traversal#Post-order
//     https://en.wikipedia.org/wiki/Tree_traversal#Pre-order
class GenericIterator(TreeType, ElementType) {
	public enum EnumTraversalType {
		POST,
		PRE,
		BREADTHFIRST
	}

	public static void walkRecursive(
		EnumTraversalType traversalType,
		ElementType delegate(TreeType element, size_t index) getChildren,
		size_t delegate(TreeType element) getNumberOfChildrens,
		void delegate(TreeType element) callback,
		TreeType entry
	) {
		if( traversalType == EnumTraversalType.BREADTHFIRST ) {
			walkRecursiveBreadthfirstOrder(traversalType, getChildren, getNumberOfChildrens, callback, entry);
		}
		else {
			walkRecursivePostOrPreOrder(traversalType, getChildren, getNumberOfChildrens, callback, entry);
		}
	}

	protected static void walkRecursivePostOrPreOrder(
		EnumTraversalType traversalType,
		ElementType delegate(TreeType element, size_t index) getChildren,
		size_t delegate(TreeType element) getNumberOfChildrens,
		void delegate(TreeType element) callback,
		TreeType entry
	) {
		if( traversalType == EnumTraversalType.PRE ) {
			callback(entry);
		}

		foreach( i; 0..getNumberOfChildrens(entry) ) {
			walkRecursive(traversalType, getChildren, getNumberOfChildrens, callback, getChildren(entry, i));
		}

		if( traversalType == EnumTraversalType.POST ) {
			callback(entry);
		}
	}

	// see https://en.wikipedia.org/wiki/Tree_traversal#Breadth-first_search_2
	protected static void walkRecursiveBreadthfirstOrder(
		EnumTraversalType traversalType,
		ElementType delegate(TreeType element, size_t index) getChildren,
		size_t delegate(TreeType element) getNumberOfChildrens,
		void delegate(TreeType element) callback,
		TreeType entry
	) {
		TreeType[] queue;
		queue.enqueue(entry);

		while( !(queue.length == 0) ) {
			TreeType node = queue.dequeue();
			callback(node);

			foreach( i; 0..getNumberOfChildrens(entry) ) {
				queue.enqueue(getChildren(entry, i));
			}
		}
	}
}


// emitter class
// 
// emits code in an postorder (see https://en.wikipedia.org/wiki/Tree_traversal#Post-order) fashion
// used for mathematical/logical functions we have no control flow (but its not checked in this class)
class PostOrderCodeEmitter {
	public final emit(DecoratedFunctionalTuple entry, CodeEmitters codeEmitters) {
		DecoratedFunctionalTuple getChildrenCallback(DecoratedFunctionalTuple element, size_t index) {
			return element.secondAndFollowing[index];
		}

		size_t getNumberOfChildrenCallback(DecoratedFunctionalTuple element) {
			return element.secondAndFollowing.length;
		}
		
		void emitCallback(DecoratedFunctionalTuple element) {
			void emitPrimitiveMath(AbstractInstructionEmitter.EnumPrimitveMathOp mathOp) {
				codeEmitters.instructionEmitter.emitPrimitiveMath(mathOp, element.secondAndFollowing, element);
			}

			void emitNth() {
				codeEmitters.instructionEmitter.emitNth(element.secondAndFollowing[0], element.secondAndFollowing[1], element);
			}



			string nameOfOperationAsString = element.firstAsName.nameAsString;
			switch( nameOfOperationAsString ) {
				case "+": emitPrimitiveMath(AbstractInstructionEmitter.EnumPrimitveMathOp.ADD); return;
				case "-": emitPrimitiveMath(AbstractInstructionEmitter.EnumPrimitveMathOp.SUB); return;
				case "*": emitPrimitiveMath(AbstractInstructionEmitter.EnumPrimitveMathOp.MUL); return;
				case "/": emitPrimitiveMath(AbstractInstructionEmitter.EnumPrimitveMathOp.DIV); return;
				case "nth": emitNth(); return;
				default: 
				// let fall through
			}

			// if we are here the default operations didn't apply

			// TODO< lookup library or userefined function >

			// if we land here then this means that something is missing in the checks of the semantics checker which is invoked before then code emission phase
			// or something different gone wrong
			throw new LizedInternalException("Invalid function lookups should be reported to the user by the semantics checker!");
		}
		
		alias GenericIterator!(DecoratedFunctionalTuple, DecoratedFunctionalTuple) GenericIteratorType;

		// we walk the tree in postorder and generate the code with the callback "emitCallback()"
		GenericIteratorType.walkRecursive(
			GenericIteratorType.EnumTraversalType.POST,
			&getChildrenCallback,
			&getNumberOfChildrenCallback,
			&emitCallback,
			entry
		);
	}
}

import std.format : format;

// type inference does also check if the types are equal/convertable for operations
// calculates the types of the results and drags them down, has to happen from the bottom of the root to the top (reversed level order)
class TypeInference {
	public static void entry(DecoratedFunctionalTuple root) {
		// we walk the tree in a breadth first fashion and store the nodes in a list, then we do walk the stored list in rese oder
		// so effectivly we walk from the bottom of the tree to the top

		DecoratedFunctionalTuple[] recordedList;

		DecoratedFunctionalTuple getChildrenCallback(DecoratedFunctionalTuple element, size_t index) {
			return element.secondAndFollowing[index];
		}

		size_t getNumberOfChildrenCallback(DecoratedFunctionalTuple element) {
			return element.secondAndFollowing.length;
		}

		void visitCallback(DecoratedFunctionalTuple element) {
			recordedList ~= element;
		}

		alias GenericIterator!(DecoratedFunctionalTuple, DecoratedFunctionalTuple) GenericIteratorType;

		GenericIteratorType.walkRecursive(
			GenericIteratorType.EnumTraversalType.BREADTHFIRST,
			&getChildrenCallback,
			&getNumberOfChildrenCallback,
			&emitCallback,
			root
		);

		foreach( iterationElement; recordedList.reversed ) {
			checkAndPropagateTypeForFunctionalTuple(iterationElement);
		}
	}

	private static void checkAndPropagateTypeForFunctionalTuple(DecoratedFunctionalTuple functionalTuple) {
		checkTypeForFunctionalTuple(functionalTuple);
		propagateTypeForFunctionalTuple(functionalTuple);
	}


	private static void checkTypeForFunctionalTuple(DecoratedFunctionalTuple functionalTuple) {
		string name = functionalTuple.firstAsName;

		if( name == "+" || name == "-" || name == "*" || name == "/" ) {
			bool areNumericTypesResult = functionalTuple.secondAndFollowingResultTypeDescriptors.areNumericTypes;
			if( !areNumericTypesResult ) {
				throw new LizedTypeException(format("One or many parameters of a function which takes %s arguments is %s", "numeric", "nonnumeric"));
			}
		}
		// TODO< else if (try to lookup name) >
		else {
			throw new LizedTypeException(format("Unrecognized functionname \"%s\"!", name));
		}
	}

	private static void propagateTypeForFunctionalTuple(DecoratedFunctionalTuple functionalTuple) {
		string name = functionalTuple.firstAsName;

		if( name == "+" || name == "-" || name == "*" || name == "/" ) {
			// TODO
			assert(false, "TODO TODO");
		}
		// TODO< else if (try to lookup name) >
		else {
			throw new LizedTypeException(format("Unrecognized functionname \"%s\"!", name));
		}
	}

	private static bool areNumericTypes(TypeDescriptor[] typedescriptors) {
		import std.algorithm.searching : all;
		return typedescriptors.all!"a.isNumeric";
	}
}


// TODO< class >
// TODO< checker for valid functions and function invocations >





/*
final protected void touchCondition(Touch[] args, Touch.EnumEvaluation topEvaluation) {
	assert(args.length >= 2 && args.length <= 3);
	args[0].value = Touch.EnumEvaluation.EVALUATION;
	args[1].value = topEvaluation;
	if( args.length == 3 ) {
		args[2].value = topEvaluation;
	}
}
*/

/*
final protected void touchAll(Touch[] args) {
	foreach( Touch iterationTouch; args ) {
		iterationTouch.setRequiresEvaluation();
	}
}
*/

struct EvaluationAttributeDecoration {
	public enum EnumEvaluation {
		ISFUNCTION = 1, // is itself a direct function
		ASFUNCTION = 2, // is itself not a function but for most backends its required that it gets translated as a function
		EVALUATION = 4, // is a mathematica operation
	}

	/*
	public final void setRequiresEvaluation() {
		value |= EnumEvaluation.EVALUATION;
	}
	*/

	public final @property bool isDirectOrIndirectFunction() {
		return (value & EnumEvaluation.ISFUNCTION) != 0 || (value & EnumEvaluation.ASFUNCTION) != 0;
	}

	protected EnumEvaluation value = cast(EnumEvaluation)0;
}

/+

void main() {
	Appender!string instructionAppender;

	GeneralHelpers generalHelpers = new GeneralHelpers();

	EmitInstructionsCpp emitInstructionsCpp = new EmitInstructionsCpp(instructionAppender, generalHelpers);

	// test emit nth
	/* no long working code
	{
		DecoratedFunctionalTuple argVariable = new DecoratedFunctionalTuple();
		argVariable.resultDescriptor = new ResultDescriptor(new VariableDescriptor(TypeDescriptor.makePrimitive(TypeDescriptor.EnumPrimitiveType.INT), "argVar"));
		DecoratedFunctionalTuple argIndex = new DecoratedFunctionalTuple();
		argIndex.resultDescriptor = new ResultDescriptor(new VariableDescriptor(TypeDescriptor.makePrimitive(TypeDescriptor.EnumPrimitiveType.INT), "argIndex"));

		DecoratedFunctionalTuple root = new DecoratedFunctionalTuple();

		emitInstructionsCpp.emitNth(argVariable, argIndex, root);
	}
	*/

}
+/



import liszed.LiszedParser;



// TODO< test >
FunctionalTuple translateParsingResultToFunctionalTuple(Parser.Brace rootBrace) {
	import std.stdio;
	writeln("translateParsingResultToFunctionalTuple()");

	if( rootBrace.type == liszed.LiszedParser.Parser.Brace.EnumType.BRACE ) {
		FunctionalTuple[] childrenTuples;
		foreach( iterationChildrenBrace; rootBrace.children ) {
			childrenTuples ~= translateParsingResultToFunctionalTuple(iterationChildrenBrace);
		}
		return FunctionalTuple.makeTuple(childrenTuples);
	}
	else if( rootBrace.type == liszed.LiszedParser.Parser.Brace.EnumType.NAME ) {
		return FunctionalTuple.makeName(rootBrace.payload);
	}
	else if( rootBrace.type == liszed.LiszedParser.Parser.Brace.EnumType.INTEGER ) {
		import std.conv : to;
		return FunctionalTuple.makeInteger(to!int(rootBrace.payload));
	}
	else {
		assert(false, "TODO/internal error");
	}
}

string testSimpleMath0Code() {
	string code = """(+ 5 a)""";
	return code;
}

string testSimpleMath1Code() {
	string code = """(Math/sqrt (+ (* (nth vec3 0) (nth vec3 0))  (* (nth vec3 1) (nth vec3 1))  (* (nth vec3 2) (nth vec3 2))))""";
	return code;
}

void main() {
	string code = testSimpleMath1Code();

	RuleLexer lexer = new RuleLexer();
	Parser parser = new Parser();

	lexer.setSource(code);

	parser.setLexer(lexer);
   	parser.reset();

   	string errorMessage;
    bool parsingSuccess = parser.parse(errorMessage);

	if( !parsingSuccess ) {
		errorMessage = "Parsing Failed: " ~ errorMessage;
		import std.stdio;
		writeln(errorMessage);

		return;
	}

	FunctionalTuple rootFunctionalTuple = translateParsingResultToFunctionalTuple(parser.rootBrace);

	// TODO
}
