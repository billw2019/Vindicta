removeAllWeapons this;
removeAllItems this;
removeAllAssignedItems this;
removeUniform this;
removeVest this;
removeBackpack this;
removeHeadgear this;
removeGoggles this;

_RandomUniform = selectRandom ["U_O_R_Gorka_01_F", "U_O_R_Gorka_01_brown_F"];
this addUniform _RandomUniform;
_RandomHeadgear = selectRandom ["rhssaf_booniehat_digital", "rhssaf_bandana_digital", "rhs_beanie_green", "H_MilCap_grn"];
this addHeadgear _RandomHeadgear;
_RandomGoggles = selectRandom ["G_Bandanna_khk", "G_Bandanna_oli", "" ];
this addGoggles _RandomGoggles;
this addVest "rhssaf_vest_md12_digital";

this addWeapon "rhs_weap_ak103_zenitco01";
this addPrimaryWeaponItem "rhs_acc_dtk4screws";
this addPrimaryWeaponItem "rhs_acc_perst1ik";
this addPrimaryWeaponItem "rhsusf_acc_mrds_fwd";
this addPrimaryWeaponItem "rhs_30Rnd_762x39mm_polymer";
this addPrimaryWeaponItem "rhsusf_acc_kac_grip";
this addWeapon "rhs_weap_rshg2";
this addWeapon "rhs_weap_pb_6p9";
this addHandgunItem "rhs_acc_6p9_suppressor";
this addHandgunItem "rhs_mag_9x18_8_57N181S";
this addWeapon "rhs_pdu4";

this addItemToUniform "FirstAidKit";
this addItemToUniform "rhs_acc_1pn93_1";
this addItemToUniform "rhs_30Rnd_762x39mm_polymer_tracer";
for "_i" from 1 to 2 do {this addItemToVest "rhs_30Rnd_762x39mm_polymer_U";};
for "_i" from 1 to 2 do {this addItemToVest "rhs_mag_9x18_8_57N181S";};
for "_i" from 1 to 2 do {this addItemToVest "rhs_mag_zarya2";};
this addItemToVest "rhssaf_mag_br_m84";
this addItemToVest "rhssaf_mag_br_m75";
this addItemToVest "rhs_mag_rdg2_white";
this addItemToVest "rhs_30Rnd_762x39mm_polymer_tracer";
this addItemToVest "I_E_IR_Grenade";
this linkItem "ItemMap";
this linkItem "ItemCompass";
this linkItem "ItemWatch";
this linkItem "ItemRadio";
this linkItem "NVGoggles_OPFOR";

