// --------------------------------------------------------------------------
// Shotgun
//
// The rebalanced shotgun trades in the duckbill for a more conventional
// barrel. In addition, it now fires a hotter buckshot loading with more  
// pellets. This model does require a more deliberate stroke of the pump 
// to load the next round, but the additonal power is well worth it.
// --------------------------------------------------------------------------

class RBLShotgun : EQCWeapon replaces Shotgun {
	
	Default {
		Weapon.Kickback 100;
		weapon.slotNumber 3;
		Weapon.SelectionOrder 1300;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 16;
		Weapon.AmmoType "Shell";
		Inventory.PickupMessage "$GOTSHOTGUN";
		Obituary "$OB_MPSHOTGUN";
		Tag "$TAG_SHOTGUN";
		Decal "BulletChip";
	}
	
	States {
		Ready:
			SHTG A 1 A_WeaponReady;
			Loop;
		Deselect:
			SHTG A 1 A_Lower;
			Loop;
		Select:
			SHTG A 1 A_Raise;
			Loop;
		Fire:
			// shotgun fire sound is 20 tics long, it must cut after that
			// pump sound is ~14 tics and needs to sync to the anim
			SHTG A 5 {
				A_GunFlash();
				A_PlaySound("weapons/shotgun_fire", CHAN_WEAPON);
				A_FireBullets(3, 1.5, 12, 7, "BulletPuff"); // default multiplier is ok
				A_AlertMonsters();
				A_WeaponOffset(0, 7, WOF_ADD);
			}
			SHTG A 7 A_WeaponOffset(0, -7, WOF_ADD);
			// begin pumping anim
			SHTG B 5 A_WeaponOffset(-12, 0, WOF_ADD);
			TNT1 A 0 A_PlaySound("weapons/shotgun_pump2", CHAN_7); // start pump sound
			SHTG C 3 A_WeaponOffset(-7, 0, WOF_ADD);
			TNT1 A 0 A_StopSound(CHAN_WEAPON); // stop fire sound
			SHTG D 6 A_WeaponOffset(5, 0, WOF_ADD);
			SHTG C 5;
			// pump anim done
			SHTG B 5 A_WeaponOffset(14, 0, WOF_ADD);
			SHTG A 5;
			TNT1 A 0 A_ReFire();
			Goto Ready;
		Flash:
			SHTF A 3 Bright A_Light1;
			SHTF B 2 Bright A_Light2;
			Goto LightDone;
		Spawn:
			SHOT A -1;
			Stop;
	}
}