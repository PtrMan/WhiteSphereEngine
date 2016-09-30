module whiteSphereEngine.graphics.font.Hershey;

enum EnumType : bool {
	MOVE,
	DRAW,
}

import std.stdio;

struct DebugDriver {
	final void raise() {
		writeln("raise");
	}

	final void command(EnumType commandType, float x, float y) {
		writeln("command ", commandType, " x=", x, " y=", y);
	}
}

// interpreter for hershey fonts
// see http://paulbourke.net/dataformats/hershey/
// sends commands to an driver which can do the drawing
void hersheyInterpreter(DriverType)(string commands, DriverType driver) {
	// translate a char to a value it encodes
	static float translate(char p) {
		return cast(float)(p - 'R');
	}

	float readAndTranslate(uint index) {
		return translate(commands[index]);
	}

	void readAndTranslateCoordinate(uint index, out float x, out float y) {
		x = readAndTranslate(index);
		y = readAndTranslate(index+1);
	}

	bool isRaiseCommand(uint index) {
		return commands[index] == ' ' && commands[index+1] == 'R';
	}

	/* uncommented because ignored
	static uint convertCharToNumber(char p) {
		if( p == ' ' ) {
			return 0;
		}

		assert(p >= '0' && p <= '9');
		return p - '0';
	}

	uint numberOfCoordinatePairs = convertCharToNumber(input[7]) + convertCharToNumber(input[6])*10; // is ignored
	*/

	float leftHandPosition = readAndTranslate(8);
	float rightHandPosition = readAndTranslate(9);

	EnumType commandType = EnumType.MOVE;

	for(uint i = 0;; i++ ) {
		const uint i2 = 10+i*2;

		assert( i2 <= commands.length );
		if( i2 == commands.length ) {
			break;
		}

		if( isRaiseCommand(i2) ) {
			driver.raise();
			commandType = EnumType.MOVE;
		}
		else {
			float x, y;
			readAndTranslateCoordinate(i2, /*out*/ x, /*out*/ y);
			driver.command(commandType, x, y);
			commandType = EnumType.DRAW;
		}
	}
}

// just for testing
void main() {
	DebugDriver driver;
	hersheyInterpreter("    8  9MWOMOV RUMUV ROQUQ", driver);
}
