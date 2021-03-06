// Include this after OOP_Light.h !

#define OWNER_CHANGE_ACK(_ID) "ownerChangeAck_"+(str _ID)

// Timeout in seconds, how long we want for an ACK from the remote machine when changing owner
#define OWNER_CHANGE_ACK_TIMEOUT 2

#define MESSAGE_ID_INVALID -66.6

MessageReceiver_getThread = {
	params ["_object"];
	GETV(CALLM0(_object, "getMessageLoop"), "scriptHandle")
};

// Macro to ensure it is being called in proper thread
#ifdef OOP_ASSERT
#define ASSERT_THREAD(objNameStr) \
try { \
	private _properThread = (isNil "_thisScript") or {(([objNameStr] call MessageReceiver_getThread) isEqualTo _thisScript)} or {!canSuspend}; \
	private _msg = format ["method is called in wrong thread. File: %1, line: %2", __FILE__, __LINE__]; \
	ASSERT_MSG(_properThread, _msg); \
} catch { \
	terminate _thisScript; \
}
#else
#define ASSERT_THREAD(objNameStr)
#endif
#ifdef _SQF_VM
#undef ASSERT_THREAD
#define ASSERT_THREAD(objNameStr)
#endif