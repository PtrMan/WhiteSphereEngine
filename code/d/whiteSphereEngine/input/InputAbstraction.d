module whiteSphereEngine.input.InputAbstraction;

import core.sys.windows.windows;

import std.string;

import whiteSphereEngine.misc.ComManager : initilize = comInitilize, deinitilize = comDeinitilize;
import whiteSphereEngine.api.directX.DirectxInput;

// for debugging
import std.stdio : writeln, write;

/** \brief Hides OS specific details of Keyboard input
 *
 */
class InputAbstraction {
   private IDirectInput8A DirectInputObj;
   private IDirectInputDevice8A KeyboardObj;

   private bool LastState[256];

   enum EnumMode {
      TEXTUAL,    // user is doing textual input
      INTERACTIVE // user is doing interactive input
   }

   private EnumMode Mode = EnumMode.INTERACTIVE;

   private static struct KeySign {
      uint Key;
      char Sign;
   }

   // TODO< other buttons >
   static private const KeySign[] KeySignArray = [
      {DIK_A, 'a'},
      {DIK_B, 'b'},
      {DIK_C, 'c'},
      {DIK_D, 'd'},
      {DIK_E, 'e'},
      {DIK_F, 'f'},
      {DIK_G, 'g'},
      {DIK_H, 'h'},
      {DIK_I, 'i'},
      {DIK_J, 'j'},
      {DIK_K, 'k'},
      {DIK_L, 'l'},
      {DIK_M, 'm'},
      {DIK_N, 'n'},
      {DIK_O, 'o'},
      {DIK_P, 'p'},
      {DIK_Q, 'q'},
      {DIK_R, 'r'},
      {DIK_S, 's'},
      {DIK_T, 't'},
      {DIK_U, 'u'},
      {DIK_V, 'v'},
      {DIK_W, 'w'},
      {DIK_X, 'x'},
      {DIK_Y, 'y'},
      {DIK_Z, 'z'},
      {DIK_0, '0'},
      {DIK_1, '1'},
      {DIK_1, '2'},
      {DIK_1, '3'},
      {DIK_1, '4'},
      {DIK_1, '5'},
      {DIK_1, '6'},
      {DIK_1, '7'},
      {DIK_1, '8'},
      {DIK_1, '9'}
   ];

   // the numbers are different for linux
   enum EnumKeys {
      UP = DIK_UP,
      DOWN = DIK_DOWN,
      LEFT = DIK_LEFT,
      RIGHT = DIK_RIGHT
   }

   private uint []SignQueue;

   /** \brief ...
    */
   final this() {
      comInitilize();
   }

   /** \brief must be called before usage
    *
    * Is only called like this on windows
    *
    * \param Instance is the Instance of Windows
    * \param Hwnd is the Hwnd of the Window
    */
   final bool create(HINSTANCE Instance, HWND Hwnd) {
      alias extern(Windows) bool function(void*) TYPEXX;
      TYPEXX setDataformatFunction;

      HMODULE InputDll;
      uint FunctionPtr;

      InputDll = LoadLibraryA("InputDll.dll");

      if( InputDll is null ) {
         return false;
      }

      // TODO< unload library before function exit >

      setDataformatFunction = cast(TYPEXX)GetProcAddress(InputDll, "setDataFormat");

      if( setDataformatFunction is null ) {
         return false;
      }

      if( this.DirectInputObj is null ) {
         // TODO< remove instance >
         if( DirectInput8Create(Instance, 0x800, &IID_IDirectInput8A, cast(void**)&(this.DirectInputObj), null) != S_OK ) {
            return false;
         }

         
         if( this.DirectInputObj.CreateDevice(&GUID_SysKeyboard, cast(void**)&(this.KeyboardObj), null) != S_OK ) {
            return false;
         }

         if( setDataformatFunction(cast(void*)this.KeyboardObj) ) {
            return false;
         }

         if( this.KeyboardObj.SetCooperativeLevel(Hwnd, DISCL_NONEXCLUSIVE | DISCL_FOREGROUND ) != S_OK ) {
            return false;
         }

         if( this.KeyboardObj.Acquire() != S_OK ) {
            return false;
         }

         return true;
      }

      return false;
   }

   /** \brief must be called before the application exits
    *
    */
   final void deinitialize() {
      if( this.DirectInputObj !is null ) {
         this.DirectInputObj.Release();

         this.DirectInputObj = null;

         comDeinitilize();
      }
   }

   /** \brief Retives the current state of all Keys
    *
    * (Only for windows?)
    * \param Keys Array with key press information
    * \param Success is true if the call was successfull
    */
   final private void getKeys(out bool[256] Keys, out bool Success) {
      ubyte KeysRaw[256];
      uint i;

      Success = false;

      if( this.KeyboardObj is null ) {
         return;
      }

      // aquire? 

      if( this.KeyboardObj.GetDeviceState(256, KeysRaw.ptr) != S_OK ) {
         if( this.KeyboardObj.Acquire() != S_OK ) {
            return;
         }

         return;
      }

      for( i = 0; i < 256; i++ ) {
         Keys[i] = ((KeysRaw[i] & 0x80) != 0);
      }

      Success = true;
   }

   // TODO< must be overhauled >
   /*
   final bool keyPressed(uint Code)
   {
      bool Keys[256];
      bool CalleeSuccess;

      this.getKeys(Keys, CalleeSuccess);

      if( !CalleeSuccess )
      {
         return false;
      }

      return Keys[Code];
   }
   */

   /** \brief sets the Mode of the Input
    *
    * \param Mode is the new Mode of the Input
    */
   final void setMode(EnumMode Mode) {
      this.Mode = Mode;
   }

   /** \brief return an array with the signs which had been pressed
    *
    * only useful for the TEXTUAL mode
    */
   final uint[] getLastSigns() {
      uint []LastSigns;

      LastSigns = this.SignQueue;
      this.SignQueue.length = 0;

      return LastSigns;
   }

   /** \brief does all input related stuff
    *
    * must be called in the mainloop
    */
   final void doIt() {
      bool NewState[256];
      bool CalleeSuccess;

      if( this.Mode == EnumMode.INTERACTIVE ) {
         this.getKeys(this.LastState, CalleeSuccess);

         if( !CalleeSuccess ) {
            return;
         }
      }
      else if( this.Mode == EnumMode.TEXTUAL ) {
         this.getKeys(NewState, CalleeSuccess);

         if( !CalleeSuccess ) {
            return;
         }

         foreach( KeySign KeySignObj; InputAbstraction.KeySignArray ) {
            if( !this.LastState[KeySignObj.Key] && NewState[KeySignObj.Key] ) {
               char Sign = KeySignObj.Sign;

               // TODO< other code for linux >
               if( NewState[DIK_LSHIFT] || NewState[DIK_RSHIFT] ) {
                  // convert to big sign
                  Sign -= 0x20;
               }

               this.SignQueue ~= cast(uint)Sign;
            }
         }

         this.LastState = NewState;
      }
      else {
         return;
      }
   }

   // TOUML
   /** \brief checks if a key for a sign is pressed
    *
    * \note doesn't check for input mode
    *
    * \param Sign ...
    * \return ...
    */
   final bool isSignPressed(char Sign) {
      foreach( KeySign KeySignObj; InputAbstraction.KeySignArray ) {
         if( KeySignObj.Sign == Sign ) {
            return this.LastState[KeySignObj.Key];
         }
      }
      
      return false;
   }
}
