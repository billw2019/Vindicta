#define OOP_INFO
#define OOP_DEBUG
#include "OOP_Light\OOP_Light.h"

#ifndef _SQF_VM
// No saving
enableSaving [ false, false ]; // Saving disabled without autosave.

// If a client, wait for the server to finish its initialization
if (!IS_SERVER) then {
	private _str = format ["Waiting for server init, time: %1", diag_tickTime];
	systemChat _str;
	OOP_INFO_0(_str);

	waitUntil {! isNil "serverInitDone"};

	_str = format ["Server initialization completed at time: %1", diag_tickTime];
	systemChat _str;
	OOP_INFO_0(_str);
};
#endif

CRITICAL_SECTION {
	switch (PROFILE_NAME) do {
		case "Sparker": { gGameMode = NEW("GameModeRandom", []); };
		case "billw": 	{ gGameMode = NEW("StatusQuoGameMode", []); };
		default 		{ gGameMode = NEW("RedVsGreenGameMode", []); };
	};

	diag_log format["Initializing game mode %1", GETV(gGameMode, "name")];
	CALLM(gGameMode, "init", []);
	diag_log format["Initialized game mode %1", GETV(gGameMode, "name")];

	serverInitDone = 1;
	PUBLIC_VARIABLE "serverInitDone";
};
