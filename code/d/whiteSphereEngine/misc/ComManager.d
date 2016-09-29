module whiteSphereEngine.misc.ComManager;

public import std.c.windows.com;

static private uint refCounter = 0;

void initilize() {
   if( refCounter == 0 ) {
      CoInitialize(null); // init COM-Interface
   }

   refCounter++;
}

void deinitilize() {
   assert(refCounter > 0);

   refCounter--;

   if( refCounter == 0 ) {
      CoUninitialize();
   }
}
