#include "common.hpp"

/*
Should be used for a vehicle driver that drives the lead vehicle of a convoy.
Parameters: TAG_POS - position where to move to
Author: Sparker 13.02.2019
*/

#define pr private

// How much time it's allowed to stand at one place without being considered 'stuck'
#define TIMER_STUCK_THRESHOLD 30

CLASS("ActionUnitMoveLeaderVehicle", "ActionUnit")
	
	VARIABLE("pos");
	VARIABLE("stuckTimer");
	VARIABLE("time");
	VARIABLE("triedRoads"); // Array with road pieces unit tried to achieve when it got stuck
	VARIABLE("stuckCounter"); // How many times this has been stuck
	
	// ------------ N E W ------------
	
	METHOD("new") {
		params [["_thisObject", "", [""]], ["_AI", "", [""]], ["_parameters", [], []] ];
		
		pr _pos = CALLSM2("Action", "getParameterValue", _parameters, TAG_POS);
		T_SETV("pos", _pos);
		
		T_SETV("stuckTimer", 0);
		T_SETV("time", time);
		T_SETV("triedRoads", []);
		T_SETV("stuckCounter", 0);
		
	} ENDMETHOD;
	
	// logic to run when the goal is activated
	METHOD("activate") {
		params [["_thisObject", "", [""]]];
		
		pr _hO = GETV(_thisObject, "hO");
		pr _hG = group _hO;
		pr _pos = T_GETV("pos");
		
		// Order to move
		// Delete all previous waypoints
		while {(count (waypoints _hG)) > 0} do { deleteWaypoint ((waypoints _hG) select 0); };
		
		// Give a waypoint to move
		pr _wp = _hG addWaypoint [_pos, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointFormation "COLUMN";
		_wp setWaypointBehaviour "SAFE";
		_wp setWaypointCombatMode "GREEN";
		_hG setCurrentWaypoint _wp;
		
		T_SETV("state", ACTION_STATE_ACTIVE);
		ACTION_STATE_ACTIVE
	} ENDMETHOD;
	
	// logic to run each update-step
	METHOD("process") {
		params [["_thisObject", "", [""]]];
		
		pr _state = CALLM(_thisObject, "activateIfInactive", []);
		
		pr _hO = GETV(_thisObject, "hO");
		pr _dt = time - T_GETV("time"); // Time that has passed since previous call
		
		// My speed is small AF
		if (speed _hO < 4) then {
			pr _timer = T_GETV("stuckTimer");
			_timer = _timer + _dt;
			T_SETV("stuckTimer", _timer);
			
			OOP_WARNING_1("Leader vehicle is probably stuck: %1", _timer);
			
			if (_timer > TIMER_STUCK_THRESHOLD) then {
				OOP_WARNING_0("Is totally stuck now!");
				
				pr _stuckCounter = T_GETV("stuckCounter");
				
				if (_stuckCounter < 3) then {
					// Try to doMove to some of the nearest roads
					pr _triedRoads = T_GETV("triedRoads");
					pr _nr = (_ho nearRoads 200) select {! (_x in _triedRoads)};
					if (count _nr > 0) then {
						OOP_WARNING_0("Moving the leader vehicle to the nearest road...");
					
						// Sort roads by distance
						_nr = (_nr apply {[_x, _x distance2D _hO]});
						_nr sort true; // Ascending
						
						// do move to the nearest road piece we didn't visit yet
						pr _road = (_nr select 0) select 0;
						_hO doMove (getpos _road);
						_triedRoads pushBack _road;
						T_SETV("stuckTimer", 0);
					};
				} else {
					OOP_WARNING_0("Tried to move to nearest road too many times!");
					// Allright this shit is serious
					// We need serious measures now :/
					if (_stuckCounter < 4) then {
						OOP_WARNING_0("Rotating the leader vehicle!");
						// Let's just try to rotate you?
						pr _hVeh = vehicle _hO;
						_hVeh setDir ((getDir _hVeh) + 180);
						_hVeh setPosWorld ((getPosWorld _hVeh) vectorAdd [0, 0, 1]);
					} else {
						// Let's try to teleport you somewhere >_<
						OOP_WARNING_0("Teleporting the leader vehicle!");
						pr _hVeh = vehicle _hO;
						pr _defaultPos = getPos _hVeh;
						pr _newPos = [_hVeh, 0, 100, 7, 0, 100, 0, [], [_defaultPos, _defaultPos]] call BIS_fnc_findSafePos;
						_hVeh setPos _newPos;
					};

					
				};
				
				// Set state to inactive so that the action gets reactivated
				_state = ACTION_STATE_INACTIVE;
				
				T_SETV("stuckCounter", _stuckCounter + 1);
			};
		} else {
			// Reset the timer
			T_SETV("stuckTimer", 0);
		};
		
		T_SETV("time", time);
		
		T_SETV("state", _state);
		_state
	} ENDMETHOD;
	
	// logic to run when the goal is satisfied
	METHOD("terminate") {
		params [["_thisObject", "", [""]]];
		
		// Stop the car from driving around
		pr _hO = GETV(_thisObject, "hO");
		doStop _hO;
	} ENDMETHOD; 

ENDCLASS;