// --------------------------------------------------------------------------
// Pistol 
//
// The rebalanced pistol is very similar - pinpoint precision, low damage.
// Cyclic rate has been slightly increased, and it now uses 9mm +P loads.
// --------------------------------------------------------------------------

class RBLPistol : EQCWeapon replaces Pistol {
	
	Default {
		Weapon.Kickback 100;
		weapon.slotNumber 2;
		Weapon.SelectionOrder 1900;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 20;
		Weapon.AmmoType "Clip";
		Obituary "$OB_MPPISTOL";
		+WEAPON.WIMPY_WEAPON
		Inventory.Pickupmessage "$PICKUP_PISTOL_DROPPED";
		Tag "$TAG_PISTOL";
		Decal "BulletChip";
	}
	
	States {
		Ready:
			PISG A 1 A_WeaponReady;
			Loop;
		Deselect:
			PISG A 1 A_Lower;
			Loop;
		Select:
			PISG A 1 A_Raise;
			Loop;
		Fire:
			PISG A 1;
			PISG B 2 {
				A_PlaySound ("weapons/pistol", CHAN_WEAPON);
				A_AlertMonsters();
				A_FireBullets(0.5, 0.5, 1, 12, "BulletPuff", flags: FBF_USEAMMO|FBF_NORANDOM); //pistol has no damage variance
				//A_FireProjectile("PistolBullet", FRandom(-0.8, 0.8), 1, 0, 8, 0, FRandom(-0.8, 0.8));
				A_GunFlash();
			}
			PISG E 4;
			PISG C 3;
			PISG D 2;
			TNT1 A 0 A_ReFire();
			Goto Ready;
		Flash:
			PISF A 2 Bright A_Light1;
			Goto LightDone;
		Spawn:
			PIST A -1;
			Stop;
	}
}