/// EQCWeapon.zsc
/// Prototype weapon
///
Class EQCWeapon : DoomWeapon abstract {
	default {
		inventory.pickupMessage "OBTAINED DEFAULT WEAPON - THIS IS A BUG";
		weapon.slotNumber 9;
		weapon.SelectionOrder 1000;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 10;
		Weapon.AmmoType "Clip";
		Weapon.BobStyle "Normal";
		Weapon.BobRangeX 1.0;
		Weapon.BobRangeY 0.5;
		+WEAPON.NODEATHINPUT;
		Decal "BulletChip";
	}	
	
	states {
		Ready:
			SHTG A 1 A_WeaponReady();
			Loop;
		Select:
			SHTG A 1 A_Raise();
			Loop;
		Deselect:
			SHTG A 1 A_Lower();
			Loop;
		Fire:
			SHTG A 10 A_FireBullets(1, 1, 1, 10);
			SHTG A 1 A_WeaponReady();
			Goto Ready;
		Spawn:
			TLGL A -1;
			Stop;
	}
}

//eof