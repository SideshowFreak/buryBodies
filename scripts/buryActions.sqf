private ["_action","_backPackMag","_backPackWpn","_crate","_corpse","_cross","_gain","_humanity","_humanityAmount","_isBury","_grave","_name","_backPack","_position","_sound","_crosstype"];

if (dayz_actionInProgress) exitWith {"You are already performing an action, wait for the current action to finish." call dayz_rollingMessages;};
dayz_actionInProgress = true;

_corpse = (_this select 3) select 0;
_action = (_this select 3) select 1;

player removeAction s_player_bury_human;
s_player_bury_human = -1;
player removeAction s_player_butcher_human;
s_player_butcher_human = -1;

if (isNull _corpse) exitWith {dayz_actionInProgress = false; systemChat "cursorTarget isNull!";};

_humanityAmount = 25; // Amount of humanity you will gain by buring a body and the amount you will lose if you butcher a body.

_corpse setVariable["isBuried",true,true];

_isBury = _action == "bury";
_position = getPosATL _corpse;
_backPack = typeOf (unitBackPack _corpse);

_crate = createVehicle ["USOrdnanceBox_EP1",_position,[],0,"CAN_COLLIDE"];
_crate setposATL [(_position select 0)+1,(_position select 1)+1.5,_position select 2];
_crate setVariable ["permaLoot",true,true];
_crate setVariable ["bury",true,true];

if (_isBury) then {
	_grave = createVehicle ["Grave",_position,[],0,"CAN_COLLIDE"];
	_grave setposATL [(_position select 0)+1,_position select 1,_position select 2];
	_grave setVariable ["bury",true,true];
} else {
	_grave = createVehicle ["Body",_position,[],0,"CAN_COLLIDE"];
	_grave setposATL [(_position select 0)+1,_position select 1,_position select 2];
	_grave setVariable ["bury",true,true];
};
if (_isBury) then {
	_name = _corpse getVariable["bodyName","unknown"];
	//_cross = createVehicle ["GraveCross1",_position,[],0,"CAN_COLLIDE"];
	_crosstype = ["GraveCross1","GraveCross2","GraveCrossHelmet"]  call BIS_fnc_selectRandom;
	_cross = createVehicle [_crosstype, _position, [], 0, "CAN_COLLIDE"];
	_cross setposATL [(_position select 0)+1,(_position select 1)-1.2,_position select 2];
	_cross setVariable ["bury",true,true];
};



clearWeaponCargoGlobal _crate;
clearMagazineCargoGlobal _crate;

{_crate addWeaponCargoGlobal [_x, 1]} forEach weapons _corpse;
{_crate addMagazineCargoGlobal [_x ,1]} forEach magazines _corpse;

if (_backPack != "") then {
	_backPackWpn = getWeaponCargo unitBackpack _corpse;
	_backPackMag = getMagazineCargo unitBackpack _corpse;

	if (count _backPackWpn > 0) then {{_crate addWeaponCargoGlobal [_x,(_backPackWpn select 1) select _forEachIndex]} forEach (_backPackWpn select 0);};
	if (count _backPackMag > 0) then {{_crate addMagazineCargoGlobal [_x,(_backPackMag select 1) select _forEachIndex]} forEach (_backPackMag select 0);};

	_crate addBackpackCargoGlobal [_backPack,1];
};

_sound = _corpse getVariable ["sched_co_fliesSource",nil];
if (!isNil "_sound") then {
	detach _sound;
	deleteVehicle _sound;
};

deleteVehicle _corpse;

player playActionNow "Medic";
uiSleep 8;

if (_isBury) then {
	if (_name != "unknown") then {
		format["Rest in peace, %1...",_name] call dayz_rollingMessages;
	} else {
		"Rest in peace, unknown soldier...." call dayz_rollingMessages;
	};
} else {
"You Feel Your Humanity Lower as You Gut this Poor Bastard" call dayz_rollingMessages;
};

_humanity = player getVariable ["humanity",0];
_gain = if (_isBury) then {+_humanityAmount} else {-_humanityAmount};
player setVariable ["humanity",(_humanity + _gain),true];

dayz_actionInProgress = false;

	if (count _backPackWpn > 0) then {{_box addWeaponCargoGlobal [_x,(_backPackWpn select 1) select _forEachIndex]} forEach (_backPackWpn select 0);};
	if (count _backPackMag > 0) then {{_box addMagazineCargoGlobal [_x,(_backPackMag select 1) select _forEachIndex]} forEach (_backPackMag select 0);};

	_box addBackpackCargoGlobal [_backPack,1];
};

_sound = _corpse getVariable ["sched_co_fliesSource",nil];
if (!isNil "_sound") then {
	detach _sound;
	deleteVehicle _sound;
};

deleteVehicle _corpse;

player playActionNow "Medic";
uiSleep 8;

if (_isBury) then {
	if (_name != "unknown") then {
		format["Rest in peace, %1...",_name] call dayz_rollingMessages;
	} else {
		"Rest in peace, unknown soldier...." call dayz_rollingMessages;
	};
};

_humanity = player getVariable ["humanity",0];
_gain = if (_isBury) then {+_humanityAmount} else {-_humanityAmount};
player setVariable ["humanity",(_humanity + _gain),true];

dayz_actionInProgress = false;
