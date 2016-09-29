module whiteSphereEngine.api.directX.DirectxInput;

public import std.c.windows.com;
public import core.sys.windows.windows;

//const uint DI8DEVCLASS_KEYBOARD = 3;

const uint MAX_PATH = 260;

struct DIDATAFORMAT
{
   DWORD   dwSize;
   DWORD   dwObjSize;
   DWORD   dwFlags;
   DWORD   dwDataSize;
   DWORD   dwNumObjs;
   /*LPDIOBJECTDATAFORMAT*/void *rgodf;
}

struct DIDEVICEOBJECTINSTANCE
{ 
   DWORD dwSize; 
   GUID  guidType; 
   DWORD dwOfs; 
   DWORD dwType; 
   DWORD dwFlags; 
   ubyte tszName[MAX_PATH]; 
   DWORD dwFFMaxForce; 
   DWORD dwFFForceResolution; 
   WORD  wCollectionNumber;
   WORD  wDesignatorIndex;
   WORD  wUsagePage;
   WORD  wUsage;
   DWORD dwDimension;
   WORD  wExponent;
   WORD  wReportId;
}

//extern (Windows) const DIDATAFORMAT c_dfDIKeyboardXXX;

static IID IID_IDirectInputA = {0x89521360, 0xAA8A, 0x11CF, [0xBF,0xC7,0x44,0x45,0x53,0x54,0x00,0x00]};
static CLSID CLSID_DirectInput = {0x25E609E0, 0xB259, 0x11CF, [0xBF,0xC7,0x44,0x45,0x53,0x54,0x00,0x00]};

static GUID GUID_SysKeyboard = {0x6F1D2B61, 0xD5A0, 0x11CF, [0xBF,0xC7,0x44,0x45,0x53,0x54,0x00,0x00]};

static IID IID_IDirectInput8A = {0xBF798030, 0x483A, 0x4DA2 ,[0xAA ,0x99 ,0x5D ,0x64 ,0xED,0x36,0x97,0x00]};

static GUID GUID_Key = {0x55728220,0xD33C,0x11CF, [0xBF,0xC7,0x44,0x45,0x53,0x54,0x00,0x00]};

const uint DIDFT_ALL = 0x00000000;

const uint DISCL_NONEXCLUSIVE = 0x00000002;
const uint DISCL_FOREGROUND = 0x00000004;

const uint DIK_ESCAPE         = 0x01;
const uint DIK_1              = 0x02;
const uint DIK_2              = 0x03;
const uint DIK_3              = 0x04;
const uint DIK_4              = 0x05;
const uint DIK_5              = 0x06;
const uint DIK_6              = 0x07;
const uint DIK_7              = 0x08;
const uint DIK_8              = 0x09;
const uint DIK_9              = 0x0A;
const uint DIK_0              = 0x0B;
const uint DIK_MINUS          = 0x0C;    /* - on main keyboard */
const uint DIK_EQUALS         = 0x0D;
const uint DIK_BACK           = 0x0E;    /* backspace */
const uint DIK_TAB            = 0x0F;
const uint DIK_Q              = 0x10;
const uint DIK_W              = 0x11;
const uint DIK_E              = 0x12;
const uint DIK_R              = 0x13;
const uint DIK_T              = 0x14;
const uint DIK_Y              = 0x15;
const uint DIK_U              = 0x16;
const uint DIK_I              = 0x17;
const uint DIK_O              = 0x18;
const uint DIK_P              = 0x19;
const uint DIK_LBRACKET       = 0x1A;
const uint DIK_RBRACKET       = 0x1B;
const uint DIK_RETURN         = 0x1C;    /* Enter on main keyboard */
const uint DIK_LCONTROL       = 0x1D;
const uint DIK_A              = 0x1E;
const uint DIK_S              = 0x1F;
const uint DIK_D              = 0x20;
const uint DIK_F              = 0x21;
const uint DIK_G              = 0x22;
const uint DIK_H              = 0x23;
const uint DIK_J              = 0x24;
const uint DIK_K              = 0x25;
const uint DIK_L              = 0x26;
const uint DIK_SEMICOLON      = 0x27;
const uint DIK_APOSTROPHE     = 0x28;
const uint DIK_GRAVE          = 0x29;    /* accent grave */
const uint DIK_LSHIFT         = 0x2A;
const uint DIK_BACKSLASH      = 0x2B;
const uint DIK_Z              = 0x2C;
const uint DIK_X              = 0x2D;
const uint DIK_C              = 0x2E;
const uint DIK_V              = 0x2F;
const uint DIK_B              = 0x30;
const uint DIK_N              = 0x31;
const uint DIK_M              = 0x32;
const uint DIK_COMMA          = 0x33;
const uint DIK_PERIOD         = 0x34;    /* . on main keyboard */
const uint DIK_SLASH          = 0x35;    /* / on main keyboard */
const uint DIK_RSHIFT         = 0x36;
const uint DIK_MULTIPLY       = 0x37;    /* * on numeric keypad */
const uint DIK_LMENU          = 0x38;    /* left Alt */
const uint DIK_SPACE          = 0x39;
const uint DIK_CAPITAL        = 0x3A;
const uint DIK_F1             = 0x3B;
const uint DIK_F2             = 0x3C;
const uint DIK_F3             = 0x3D;
const uint DIK_F4             = 0x3E;
const uint DIK_F5             = 0x3F;
const uint DIK_F6             = 0x40;
const uint DIK_F7             = 0x41;
const uint DIK_F8             = 0x42;
const uint DIK_F9             = 0x43;
const uint DIK_F10            = 0x44;
const uint DIK_NUMLOCK        = 0x45;
const uint DIK_SCROLL         = 0x46;    /* Scroll Lock */
const uint DIK_NUMPAD7        = 0x47;
const uint DIK_NUMPAD8        = 0x48;
const uint DIK_NUMPAD9        = 0x49;
const uint DIK_SUBTRACT       = 0x4A;    /* - on numeric keypad */
const uint DIK_NUMPAD4        = 0x4B;
const uint DIK_NUMPAD5        = 0x4C;
const uint DIK_NUMPAD6        = 0x4D;
const uint DIK_ADD            = 0x4E;    /* + on numeric keypad */
const uint DIK_NUMPAD1        = 0x4F;
const uint DIK_NUMPAD2        = 0x50;
const uint DIK_NUMPAD3        = 0x51;
const uint DIK_NUMPAD0        = 0x52;
const uint DIK_DECIMAL        = 0x53;    /* . on numeric keypad */
const uint DIK_OEM_102        = 0x56;    /* <> or \| on RT 102-key keyboard (Non-U.S.) */
const uint DIK_F11            = 0x57;
const uint DIK_F12            = 0x58;
const uint DIK_F13            = 0x64;    /*                     (NEC PC98) */
const uint DIK_F14            = 0x65;    /*                     (NEC PC98) */
const uint DIK_F15            = 0x66;    /*                     (NEC PC98) */
const uint DIK_KANA           = 0x70;    /* (Japanese keyboard)            */
const uint DIK_ABNT_C1        = 0x73;    /* /? on Brazilian keyboard */
const uint DIK_CONVERT        = 0x79;    /* (Japanese keyboard)            */
const uint DIK_NOCONVERT      = 0x7B;    /* (Japanese keyboard)            */
const uint DIK_YEN            = 0x7D;    /* (Japanese keyboard)            */
const uint DIK_ABNT_C2        = 0x7E;    /* Numpad . on Brazilian keyboard */
const uint DIK_NUMPADEQUALS   = 0x8D;    /* = on numeric keypad (NEC PC98) */
const uint DIK_PREVTRACK      = 0x90;    /* Previous Track (DIK_CIRCUMFLEX on Japanese keyboard) */
const uint DIK_AT             = 0x91;    /*                     (NEC PC98) */
const uint DIK_COLON          = 0x92;    /*                     (NEC PC98) */
const uint DIK_UNDERLINE      = 0x93;    /*                     (NEC PC98) */
const uint DIK_KANJI          = 0x94;    /* (Japanese keyboard)            */
const uint DIK_STOP           = 0x95;    /*                     (NEC PC98) */
const uint DIK_AX             = 0x96;    /*                     (Japan AX) */
const uint DIK_UNLABELED      = 0x97;    /*                        (J3100) */
const uint DIK_NEXTTRACK      = 0x99;    /* Next Track */
const uint DIK_NUMPADENTER    = 0x9C;    /* Enter on numeric keypad */
const uint DIK_RCONTROL       = 0x9D;
const uint DIK_MUTE           = 0xA0;    /* Mute */
const uint DIK_CALCULATOR     = 0xA1;    /* Calculator */
const uint DIK_PLAYPAUSE      = 0xA2;    /* Play / Pause */
const uint DIK_MEDIASTOP      = 0xA4;    /* Media Stop */
const uint DIK_VOLUMEDOWN     = 0xAE;    /* Volume - */
const uint DIK_VOLUMEUP       = 0xB0;    /* Volume + */
const uint DIK_WEBHOME        = 0xB2;    /* Web home */
const uint DIK_NUMPADCOMMA    = 0xB3;    /* , on numeric keypad (NEC PC98) */
const uint DIK_DIVIDE         = 0xB5;    /* / on numeric keypad */
const uint DIK_SYSRQ          = 0xB7;
const uint DIK_RMENU          = 0xB8;    /* right Alt */
const uint DIK_PAUSE          = 0xC5;    /* Pause */
const uint DIK_HOME           = 0xC7;    /* Home on arrow keypad */
const uint DIK_UP             = 0xC8;    /* UpArrow on arrow keypad */
const uint DIK_PRIOR          = 0xC9;    /* PgUp on arrow keypad */
const uint DIK_LEFT           = 0xCB;    /* LeftArrow on arrow keypad */
const uint DIK_RIGHT          = 0xCD;    /* RightArrow on arrow keypad */
const uint DIK_END            = 0xCF;    /* End on arrow keypad */
const uint DIK_DOWN           = 0xD0;    /* DownArrow on arrow keypad */
const uint DIK_NEXT           = 0xD1;    /* PgDn on arrow keypad */
const uint DIK_INSERT         = 0xD2;    /* Insert on arrow keypad */
const uint DIK_DELETE         = 0xD3;    /* Delete on arrow keypad */
const uint DIK_LWIN           = 0xDB;    /* Left Windows key */
const uint DIK_RWIN           = 0xDC;    /* Right Windows key */
const uint DIK_APPS           = 0xDD;    /* AppMenu key */
const uint DIK_POWER          = 0xDE;    /* System Power */
const uint DIK_SLEEP          = 0xDF;    /* System Sleep */
const uint DIK_WAKE           = 0xE3;    /* System Wake */
const uint DIK_WEBSEARCH      = 0xE5;    /* Web Search */
const uint DIK_WEBFAVORITES   = 0xE6;    /* Web Favorites */
const uint DIK_WEBREFRESH     = 0xE7;    /* Web Refresh */
const uint DIK_WEBSTOP        = 0xE8;    /* Web Stop */
const uint DIK_WEBFORWARD     = 0xE9;    /* Web Forward */
const uint DIK_WEBBACK        = 0xEA;    /* Web Back */
const uint DIK_MYCOMPUTER     = 0xEB;    /* My Computer */
const uint DIK_MAIL           = 0xEC;    /* Mail */
const uint DIK_MEDIASELECT    = 0xED;    /* Media Select */

extern( Windows )
{
   //HRESULT DirectInputCreate(HINSTANCE hinst, DWORD dwVersion, /*IDirectInputA*/void **ppDI, /*LPUNKNOWN*/void *punkOuter);

   HRESULT DirectInput8Create(
         HINSTANCE hinst,
         DWORD dwVersion,
         /*REFIID*/ IID *riidltf,
         LPVOID * ppvOut,
         /*LPUNKNOWN*/void *punkOuter
   );

   /+
	interface IDirectInputA : IUnknown
   {
      HRESULT CreateDevice(/*REFGUID*/GUID,/*DIRECTINPUTDEVICEA ***/void**,/*LPUNKNOWN*/void*);
      HRESULT EnumDevices(uint, /*DIENUMDEVICESCALLBACKA*/void*, void*, uint);
      HRESULT GetDeviceStatus(/*REFGUID*/void *rguidInstance);
      HRESULT RunControlPanel(HWND hwndOwner, DWORD dwFlags);
      HRESULT Initialize(HINSTANCE hinst, DWORD dwVersion);
   }+/


   interface IDirectInput8A : IUnknown
   {
      HRESULT CreateDevice(/*REFGUID*/GUID*,/*DIRECTINPUTDEVICE8A ***/void**,/*LPUNKNOWN*/void*);
      HRESULT EnumDevices(uint, /*DIENUMDEVICESCALLBACKA*/void*, void*, DWORD);
      HRESULT GetDeviceStatus(/*REFGUID*/void *rguidInstance);
      HRESULT RunControlPanel(HWND hwndOwner, DWORD dwFlags);
      HRESULT Initialize(HINSTANCE hinst, DWORD dwVersion);
      HRESULT FindDevice(/*REFGUID*/void*,/*LPCWSTR*/ubyte*,/*LPGUID*/void *);
      HRESULT EnumDevicesBySemantics(/*LPCWSTR*/void*,/*LPDIACTIONFORMATA*/void*,/*LPDIENUMDEVICESBYSEMANTICSCBA*/void*,LPVOID,DWORD);
      HRESULT ConfigureDevices(/*LPDICONFIGUREDEVICESCALLBACK*/void*,/*LPDICONFIGUREDEVICESPARAMSW*/void*,DWORD,LPVOID);
   }

   /+
   interface IDirectInputDeviceA : IUnknown
   {
      HRESULT GetCapabilities(/*LPDIDEVCAPS*/void*);
      HRESULT EnumObjects(/*LPDIENUMDEVICEOBJECTSCALLBACK*/void *lpCallback, void *pvRef, DWORD dwFlags);
      HRESULT GetProperty(/*REFGUID*/ void *rguidProp, /*LPDIPROPHEADER*/void *pdiph);
      HRESULT SetProperty(/*REFGUID*/ void *rguidProp, /*LPCDIPROPHEADER*/void *pdiph);
      HRESULT Acquire();
      HRESULT Unacquire();
      HRESULT GetDeviceState(DWORD cbData, LPVOID lpvData);
      HRESULT GetDeviceData(DWORD cbObjectData,/*LPDIDEVICEOBJECTDATA*/void *rgdod, LPDWORD pdwInOut, DWORD dwFlags);
      HRESULT SetDataFormat(/*LPCDIDATAFORMAT*/void *lpdf);
      HRESULT SetEventNotification(HANDLE hEvent);
      HRESULT SetCooperativeLevel(HWND hwnd, DWORD dwFlags);
      HRESULT GetObjectInfo(/*LPDIDEVICEOBJECTINSTANCE*/void *pdidoi, DWORD dwObj, DWORD dwHow);
      HRESULT GetDeviceInfo(/*LPDIDEVICEINSTANCE*/void *pdidi);
      HRESULT RunControlPanel(HWND hwndOwner, DWORD dwFlags);
      HRESULT Initialize(HINSTANCE hinst, DWORD dwVersion, /*REFGUID*/void *rguid);
   }+/

   interface IDirectInputDevice8A : IUnknown
   {
      HRESULT GetCapabilities(/*LPDIDEVCAPS*/void*);
      HRESULT EnumObjects(/*LPDIENUMDEVICEOBJECTSCALLBACK*/void *lpCallback, void *pvRef, DWORD dwFlags);
      HRESULT GetProperty(/*REFGUID*/ void *rguidProp, /*LPDIPROPHEADER*/void *pdiph);
      HRESULT SetProperty(/*REFGUID*/ void *rguidProp, /*LPCDIPROPHEADER*/void *pdiph);
      HRESULT Acquire();
      HRESULT Unacquire();
      HRESULT GetDeviceState(DWORD cbData, LPVOID lpvData);
      HRESULT GetDeviceData(DWORD cbObjectData,/*LPDIDEVICEOBJECTDATA*/void *rgdod, LPDWORD pdwInOut, DWORD dwFlags);
      HRESULT SetDataFormat(DIDATAFORMAT *lpdf);
      HRESULT SetEventNotification(HANDLE hEvent);
      HRESULT SetCooperativeLevel(HWND hwnd, DWORD dwFlags);
      HRESULT GetObjectInfo(/*LPDIDEVICEOBJECTINSTANCE*/void *pdidoi, DWORD dwObj, DWORD dwHow);
      HRESULT GetDeviceInfo(/*LPDIDEVICEINSTANCE*/void *pdidi);
      HRESULT RunControlPanel(HWND hwndOwner, DWORD dwFlags);
      HRESULT Initialize(HINSTANCE hinst, DWORD dwVersion, /*REFGUID*/void *rguid);
      HRESULT CreateEffect(/*REFGUID*/void *rguid, /*LPCDIEFFECT*/void *lpeff, /*LPDIRECTINPUTEFFECT*/void **ppdeff, /*LPUNKNOWN*/void *punkOuter);
      HRESULT EnumEffects(/*LPDIENUMEFFECTSCALLBACK*/void *lpCallback, LPVOID pvRef, DWORD dwEffType);
      HRESULT GetEffectInfo(/*LPDIEffectInfo*/void *pdei, /*REFGUID*/void *rguid);
      HRESULT GetForceFeedbackState(LPDWORD pdwOut);
      HRESULT SendForceFeedbackCommand(DWORD dwFlags);
      HRESULT EnumCreatedEffectObjects(/*LPDIENUMCREATEDEFFECTOBJECTSCALLBACK*/void *lpCallback, LPVOID pvRef, DWORD fl);
      HRESULT Escape(/*LPDIEFFESCAPE*/void *pesc);
      HRESULT Poll();
      HRESULT SendDeviceData(DWORD cbObjectData, /*LPCDIDEVICEOBJECTDATA*/void *rgdod, LPDWORD pdwInOut, DWORD fl);
      HRESULT EnumEffectsInFile(/*LPCSTR*/void *lpszFileName, /*LPENUMEFFECTSINFILECALLBACK*/void *pec, LPVOID pvRef, DWORD dwFlags);
      HRESULT WriteEffectToFile(/*LPCSTR*/void *lpszFileName, DWORD dwEntries, /*LPCDIFILEEFFECT*/void *rgDiFileEft, DWORD dwFlags);
      HRESULT BuildActionMap(/*LPDIACTIONFORMAT*/void *lpdiaf, /*LPCTSTR*/void *lpszUserName, DWORD dwFlags);
      HRESULT SetActionMap(/*LPCDIACTIONFORMAT*/void *lpdiActionFormat, /*LPCTSTR*/void *lptszUserName, DWORD dwFlags);
      HRESULT GetImageInfo(/*LPDIDEVICEIMAGEINFOHEADER*/void *lpdiDevImageInfoHeader);
   }
}
