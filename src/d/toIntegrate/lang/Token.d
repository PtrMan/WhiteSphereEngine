module lang.Token;

import std.stdio : writeln;

// exceptions?
import std.conv : to;

//import lang.EscapedString : EscapedString;

class Token(EnumOperationType) {
   public enum EnumType {
      NUMBER = 0,
      IDENTIFIER,
      KEYWORD,       // example: if do end then
      OPERATION,     // example: := > < >= <=
      
      ERROR,         // if Lexer found an error
      INTERNALERROR, // if token wasn't initialized by Lexer
      STRING,        // "..."
      
      EOF            // end of file
      // TODO< more? >
   }

   final public void debugIt() {
      writeln("Type: " ~ to!string(type));

      if( type == EnumType.OPERATION ) {
         writeln("Operation: " ~ to!string(contentOperation));
      }
      else if( type == EnumType.NUMBER ) {
         writeln(contentNumber);
      }
      else if( type == EnumType.IDENTIFIER ) {
         writeln(contentString);
      }
      else if( type == EnumType.STRING ) {
         writeln(contentString);
      }

      writeln("Line   : ", line);
      writeln("Column : ", column);

      writeln("===");
   }

   final public string getRealString() {
      if( type == EnumType.OPERATION ) {
         return to!string(this.contentOperation);
      }
      else if( type == EnumType.IDENTIFIER ) {
         return this.contentString;
      }
      else if( type == EnumType.NUMBER ) {
         // TODO< catch exceptions >
         return to!string(contentNumber);
      }
      else if( type == EnumType.STRING ) {
         return contentString;
      }
      

      return "";
   }

   final public Token!EnumOperationType copy() {
      Token!EnumOperationType result = new Token!EnumOperationType();
      result.contentString = this.contentString;
      result.contentOperation = this.contentOperation;
      result.contentNumber = this.contentNumber;
      result.type = this.type;
      result.line = this.line;
      result.column = this.column;
      return result;
   }

   public string contentString;
   public EnumOperationType contentOperation = cast(EnumOperationType)0; // set to internalerror
   public int contentNumber = 0;

   public EnumType type = EnumType.INTERNALERROR;
   public uint line = 0;
   public uint column = 0; // Spalte
   // public string Filename;
}
