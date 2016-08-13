module liszed.LiszedParser;

import std.typecons : Nullable, Tuple;

import lang.Parser : AbstractParser = Parser;
import lang.Token; // : Token;
import lang.Lexer; // : Lexer;

enum EnumOperationType {
	BRACEOPEN,
	BRACECLOSE,
	BRACKETOPEN,
	BRACKETCLOSE,
	NAME,
	INTEGER,
	// TODO< float number >

	INVALID // special
}


class RuleLexer : Lexer!EnumOperationType {
	override protected Token!EnumOperationType createToken(uint ruleIndex, string matchedString) {
		import std.stdio;
		//writeln(matchedString);

		Token!EnumOperationType token = new Token!EnumOperationType();

		if( ruleIndex == 1 ) {
			token.type = Token!EnumOperationType.EnumType.OPERATION;
			token.contentOperation = EnumOperationType.BRACEOPEN;
		}
		else if( ruleIndex == 2 ) {
			token.type = Token!EnumOperationType.EnumType.OPERATION;
			token.contentOperation = EnumOperationType.BRACECLOSE;
		}
		else if( ruleIndex == 3 ) {
			token.type = Token!EnumOperationType.EnumType.OPERATION;
			token.contentOperation = EnumOperationType.BRACKETOPEN;
		}
		else if( ruleIndex == 4 ) {
			token.type = Token!EnumOperationType.EnumType.OPERATION;
			token.contentOperation = EnumOperationType.BRACKETCLOSE;
		}
		else if( ruleIndex == 5 ) {
			token.type = Token!EnumOperationType.EnumType.OPERATION;
			token.contentOperation = EnumOperationType.NAME;
			token.contentString = matchedString;
		}
		else if( ruleIndex == 6 ) {
			token.type = Token!EnumOperationType.EnumType.OPERATION;
			token.contentOperation = EnumOperationType.INTEGER;
			token.contentString = matchedString;
		}

		return token;
	}

	override protected void fillRules() {
		tokenRules ~= Lexer!EnumOperationType.Rule(r"^([ \n\r]+)");
		tokenRules ~= Lexer!EnumOperationType.Rule(r"^(\()");
		tokenRules ~= Lexer!EnumOperationType.Rule(r"^(\))");
		tokenRules ~= Lexer!EnumOperationType.Rule(r"^(\[)");
		tokenRules ~= Lexer!EnumOperationType.Rule(r"^(\])");
		tokenRules ~= Lexer!EnumOperationType.Rule(r"^([a-zA-Z/\+\-\*/\?!=]+)");
		tokenRules ~= Lexer!EnumOperationType.Rule(r"^([0-9]+)");

		/*
		tokenRules ~= Lexer!EnumOperationType.Rule(r"^(#)");
		tokenRules ~= Lexer!EnumOperationType.Rule(r"^(<->)");
		tokenRules ~= Lexer!EnumOperationType.Rule(r"^(-->)");
		tokenRules ~= Lexer!EnumOperationType.Rule(r"^(\|-)");
		tokenRules ~= Lexer!EnumOperationType.Rule(r"^([a-zA-Z][0-9A-Za-z]*)");
		*/
	}
}

import std.variant : Variant;
import ArrayStack;

class Parser : AbstractParser!EnumOperationType {
	Token!EnumOperationType[] tokensInsideBrace;

	override protected void fillArcs() {
		void nothing(AbstractParser!EnumOperationType parserObj, Token!EnumOperationType currentToken) {
		}

		void beginBrace(AbstractParser!EnumOperationType parserObj, Token!EnumOperationType currentToken) {
        	//tokensInsideBrace.length = 0;
        	Brace createdBrace = new Brace(Brace.EnumType.BRACE);
        	topBrace.children ~= createdBrace;

        	braceStack.push(createdBrace);
		}

		void pushName(AbstractParser!EnumOperationType parserObj, Token!EnumOperationType currentToken) {
			Brace createdBrace = new Brace(Brace.EnumType.NAME);
        	createdBrace.payload = currentToken.contentString;
        	topBrace.children ~= createdBrace;
		}

		void pushInteger(AbstractParser!EnumOperationType parserObj, Token!EnumOperationType currentToken) {
			Brace createdBrace = new Brace(Brace.EnumType.INTEGER);
        	createdBrace.payload = currentToken.contentString;
        	topBrace.children ~= createdBrace;	
		}


		void endBrace(AbstractParser!EnumOperationType parserObj, Token!EnumOperationType currentToken) {
			braceStack.pop();
		}

		Nullable!uint nullUint;





		// - check for name, else
		/*   0 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.NAME              , &pushName          , 4, Nullable!uint(1));
		// - check for integer, else
		/*   1 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.INTEGER           , &pushInteger          , 4, Nullable!uint(2));
		// brace open -> goto 3, no else
		/*   2 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.BRACEOPEN         , &beginBrace         , 3, nullUint);
		// arc +10, goto 4
		/*   3 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ARC      , 10                                            , &nothing, 4, nullUint);
		// end
		/*   4 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.END      , 0                                                    , &nothing, 0, nullUint                   );

		/*   5 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ERROR    , 0                                                    , &nothing, 0, nullUint                   );
		/*   6 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ERROR    , 0                                                    , &nothing, 0, nullUint                   );
		/*   7 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ERROR    , 0                                                    , &nothing, 0, nullUint                   );
		/*   8 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ERROR    , 0                                                    , &nothing, 0, nullUint                   );
		/*   9 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ERROR    , 0                                                    , &nothing, 0, nullUint                   );


		// 10  eat brace close -> goto 15
		/*  10 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.BRACECLOSE              , &nothing       , 15, Nullable!uint(11));
		// 11  eat name -> +10
		/*  11 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.NAME              , &pushName          , 10, Nullable!uint(12));
		// 12  eat integer -> +10
		/*  12 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.INTEGER           , &pushInteger          , 10, Nullable!uint(13));
		// 13  eat brace open -> 14
		/*  13 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.BRACEOPEN         , &beginBrace         , 14, nullUint);

		// 14  arc +10, next +10
		/*  14 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ARC      , 10                                            , &nothing, 10, nullUint);
		// 15  end
		/*  15 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.END      , 0                                                    , &nothing, 0, nullUint                   );

	}

	override protected void setupBeforeParsing() {
	}

	public final void reset() {
		braceStack = [new Brace(Brace.EnumType.BRACE)];
	}

	public final @property Brace rootBrace() {
		return braceStack[0];
	}

	public static class Brace {
		enum EnumType {
			BRACE,
			NAME,
			INTEGER
		}

		public final this(EnumType type) {
			this.protectedType = type;
		}

		public final @property EnumType type() {
			return protectedType;
		}

		Brace[] children;

		string payload;

		protected EnumType protectedType;
	}

	protected final @property Brace topBrace() {
		return braceStack.top();
	}

	protected Brace[] braceStack;
}
