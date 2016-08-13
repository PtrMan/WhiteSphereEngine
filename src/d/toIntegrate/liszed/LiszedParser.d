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

		/*
		else if( ruleIndex == 7 ) {
			token.type = Token!EnumOperationType.EnumType.OPERATION;
			token.contentOperation = EnumOperationType.SIMILARITY;
		}
		else if( ruleIndex == 8 ) {
			token.type = Token!EnumOperationType.EnumType.OPERATION;
			token.contentOperation = EnumOperationType.INHERITANCE;
		}
		else if( ruleIndex == 9 ) {
			token.type = Token!EnumOperationType.EnumType.OPERATION;
			token.contentOperation = EnumOperationType.HALFH;
		}
		else if( ruleIndex == 10 ) {
			token.type = Token!EnumOperationType.EnumType.IDENTIFIER;
			token.contentString = matchedString;
		}
		*/

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







		// - check for name
		// - check for integer
		// - jump to next free space

		// open new brace -> go to +2
		// end

		// +2 : check for brace open
		//      true
		//        

		// - eat brace close












		// - check name, if so -> end
		// - check integer, if so -> end
		// else
		//   +10

		// +10
		// - try to eat brace open
		//    if so -> arc +0
		//             read ), alternative is go to +0
		//             if so, end
		//    else  -> end



		// old buggy broken
		/+
		/*  0 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ARC      , 2                                                    , &nothing, 0, nullUint);
		/*  1 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.END      , 0                                                    , &nothing,10, nullUint                   );
		

		/*  2 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.NAME              , &pushName          , 5, Nullable!uint(3));
		/*  3 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.INTEGER             , &pushInteger          , 5, Nullable!uint(4));

		/*  4 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ARC      , 6                                                    , &nothing, 5, nullUint);
		/*  5 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.END      , 0                                                    , &nothing, 0, nullUint                   );

		/*  6 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.BRACEOPEN              , &beginBrace         , 7, nullUint);
		/*  7 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ARC      , 2                                                    , &nothing, 7, Nullable!uint(8));
		/*  8 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.BRACECLOSE              , &nothing       , 9, nullUint);
		/*  9 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.END      , 0                                                    , &nothing,0, nullUint                   );

		/*  10 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.END      , 0                                                    , &nothing,10, nullUint                   );
		+/






		/+
		/* 15 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.END      , 0                                                    , &nothing,0, nullUint                   );


		/*  5 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ARC      , 20  , &nothing, 6, nullUint);
		/*  6 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.BRACKETCLOSE             , &nothing       , 1, nullUint);

		/*  7 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ERROR    , 0                                                    , &nothing             , 0                     , nullUint                     );
		/*  8 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ERROR    , 0                                                    , &nothing             , 0                     , nullUint                     );
		/*  9 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ERROR    , 0                                                    , &nothing             , 0                     , nullUint                     );

		// ARC for ([KEY SYM <-> -->]), brace open got already eaten
		/* 10 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.TOKEN    , cast(uint)Token!EnumOperationType.EnumType.IDENTIFIER, &pushToken          , 10, Nullable!uint(11));
		/* 11 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.KEY                      , &pushToken          , 10, Nullable!uint(12));
		/* 12 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.SIMILARITY               , &pushToken          , 10, Nullable!uint(13));
		/* 13 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.INHERITANCE              , &pushToken          , 10, Nullable!uint(14));

		/* 14 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.BRACECLOSE               , &endBrace         , 15, nullUint);
		
		/* 15 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.END      , 0                                                    , &nothing,0, nullUint                   );

		/* 16 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.END      , 0                                                    , &nothing,0, nullUint                   );
		/* 17 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.END      , 0                                                    , &nothing,0, nullUint                   );
		/* 18 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ERROR    , 0                                                    , &nothing             , 0                     , nullUint                     );
		/* 19 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ERROR    , 0                                                    , &nothing             , 0                     , nullUint                     );
		
		// ARC which parses the mail sequence (SYM --> SYM) ... |- (SYM --> SYM)    :NAME (...) ...
		//  entry
		/* 20 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.BRACEOPEN                , &beginBrace         , 22, Nullable!uint(21));
		/* 21 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.HALFH                    , &nothing         , 24, nullUint);
		/* 22 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ARC      , 10                                                   , &nothing, 23, nullUint);
		/* 23 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.NIL      , 0                                                    , &storeTokensToBraceAndAddToRule, 20, nullUint);
		
		//  HALFH was read, this handles the 2nd part
		/* 24 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.NIL      , 0                                                    , &setToTransformationResult         , 25, nullUint);

		// TODO
		/* 25 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.BRACEOPEN                , &beginBrace         , 26, nullUint);
		/* 26 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ARC      , 10                                                   , &nothing, 27, nullUint);
		/* 27 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.NIL      , 0                                                    , &storeTokensToBraceAndAddToRule         , 30, nullUint);

		/* 28 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ERROR    , 0                                                    , &nothing             , 0                     , nullUint                     );
		/* 29 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ERROR    , 0                                                    , &nothing             , 0                     , nullUint                     );
		
		//  the dirctionary part is handled here
		//    read the key and add a new element
		/* 30 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.KEY                      , &addAndSetNewDictionaryElement         , 32, Nullable!uint(31));
		/* 31 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.END      , 0                                                    , &nothing,0, nullUint                   );


		// parse braces and brace content of key-value
		/* 32 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.BRACEOPEN                , &nothing         , 33, nullUint);
		/* 33 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ARC      , 40                                                   , &nothing, 34, nullUint);
		/* 34 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.BRACECLOSE               , &nothing         , 30, nullUint);

		/* 35 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ERROR    , 0                                                    , &nothing             , 0                     , nullUint                     );
		/* 36 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ERROR    , 0                                                    , &nothing             , 0                     , nullUint                     );
		/* 37 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ERROR    , 0                                                    , &nothing             , 0                     , nullUint                     );
		/* 38 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ERROR    , 0                                                    , &nothing             , 0                     , nullUint                     );
		/* 39 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ERROR    , 0                                                    , &nothing             , 0                     , nullUint                     );
		
		//   read the value for the key inside the praces, braces got already read
		/* 40 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.KEY                 , &storeKey, 40, Nullable!uint(41));
		/* 41 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.OPERATION, cast(uint)EnumOperationType.BRACEOPEN                , &beginBrace         , 43,  Nullable!uint(42));
		/* 42 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.END      , 0                                                    , &nothing,0, nullUint                   );

		//     brace got opened
		//     stores the data in the brace into the dictionary
		/* 43 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.ARC      , 10                                                   , &nothing, 44, nullUint);
		/* 44 */this.Arcs ~= new Arc(AbstractParser!EnumOperationType.Arc.EnumType.NIL      , 0                                                    , &storeTokensToBraceAndAddToDict         , 40, nullUint);
		+/
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
