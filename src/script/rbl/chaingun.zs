// --------------------------------------------------------------------------
// Chaingun
//
// The rebalanced Chaingun is actually an earlier model - it fires 4.5mm
// duplex rounds in bursts of 4, but with no refire delay. Although it's no
// longer quite as accurate at long range, the 4.5mm duplex is substantially
// more powerful than its successor.
// --------------------------------------------------------------------------

class RBLChaingun : EQCWeapon replaces Chaingun {
	
	Default {
		Weapon.slotNumber 4;
		Weapon.SelectionOrder 700;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 40;
		Weapon.AmmoType "Clip";
		Inventory.PickupMessage "$GOTCHAINGUN";
		Obituary "$OB_MPCHAINGUN";
		Tag "$TAG_CHAINGUN";
		Decal "BulletChip";
	}
	
	States {
		Ready:
			CHGG A 1 A_WeaponReady;
			Loop;
		Deselect:
			CHGG A 1 A_Lower;
			Loop;
		Select:
			CHGG A 1 A_Raise;
			Loop;
		Fire:
			TNT1 A 0 A_GunFlash();
			CHGG ABAB 4 {
				A_PlaySound ("weapons/chngun", CHAN_WEAPON);
				A_FireBullets(0.9, 0.9, -1, (11*Random(1,2)), flags: FBF_USEAMMO|FBF_NORANDOM);
				A_AlertMonsters();
			}
			CHGG B 0 A_ReFire();
			Goto Ready;
		Flash:
			CHGF A 4 Bright A_Light1;
			CHGF B 4 Bright A_Light2;
			CHGF A 4 Bright A_Light1;
			CHGF B 4 Bright A_Light2;
			Goto LightDone;
		Spawn:
			MGUN A -1;
			Stop;
	}
}