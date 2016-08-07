module lang.Lexer;

import std.regex;

import lang.Token : Token;

abstract class Lexer(EnumTokenOperationType) {
   public enum EnumLexerCode {
      OK,
      INVALID
   }
   
   final public void setSource(string source) {
      this.remainingSource = source;
   }
   
   final EnumLexerCode nextToken(out Token!EnumTokenOperationType resultToken) {
      import std.stdio : writeln;

      for(;;) {
         size_t index;
         EnumLexerCode lexerCode = nextTokenInternal(resultToken, index);
         if( lexerCode != EnumLexerCode.OK ) {
            return lexerCode;
         }

         if( resultToken.type == Token!EnumTokenOperationType.EnumType.EOF ) {
            return lexerCode;
         }

         if( index == 0 ) {
            continue;
         }

         return lexerCode;
      }
   }

   final protected EnumLexerCode nextTokenInternal(out Token!EnumTokenOperationType resultToken, out size_t index) {
      bool endReached = remainingSource.length == 0;
      if( endReached ) {
         resultToken = new Token!EnumTokenOperationType();
         resultToken.type = Token!EnumTokenOperationType.EnumType.EOF;
         return EnumLexerCode.OK;
      }

      foreach( iindex, iterationTokenRule; tokenRules ) {
         auto match = matchFirst(remainingSource, iterationTokenRule.regularExpression);

         if( match ) {
            string matchedString = match[1];
            remainingSource = remainingSource[matchedString.length..$];

            index = iindex;
            resultToken = createToken(iindex, matchedString);
            return EnumLexerCode.OK;
         }
      }

      import std.stdio;
      writeln("<INVALID>");

      return EnumLexerCode.INVALID;
   }

   final this() {
      fillRules();
   }

   abstract protected Token!EnumTokenOperationType createToken(uint ruleIndex, string matchedString);

   abstract protected void fillRules();

   static struct Rule {
      string regularExpression; // regular expression its matched with

      final this(string regularExpression) {
         this.regularExpression = regularExpression;
      }
   }


   public Rule[] tokenRules;
   // token rule #0 is ignored, because it contains the pattern for spaces

   private string remainingSource;

   // position in Source File
   private string actualFilename = "<stdin>";
   private uint actualLine = 1;
   private uint actualColumn = 0;
}
