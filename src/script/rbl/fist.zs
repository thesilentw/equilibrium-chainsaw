// --------------------------------------------------------------------------
// 	Fist 
//
//	The Marine has been paying better attention to his striking training, and
//  his knuckle dusters are now quite a force to be reckoned with.
// --------------------------------------------------------------------------

class RBLFist : EQCWeapon replaces Fist {
	
	Default {
		Weapon.SlotNumber 1;
		Weapon.SelectionOrder 3700;
		Weapon.Kickback 100;
		Weapon.AmmoUse 0;
		Weapon.AmmoType "";
		Obituary "$OB_MPFIST";
		Tag "$TAG_FIST";
		AttackSound "weapons/punch";
		+WEAPON.WIMPY_WEAPON
		+WEAPON.MELEEWEAPON
	}
	
	States {
		Spawn:
			TNT1 A -1;
			Loop;
		Ready:
			PUNG A 1 A_WeaponReady;
			Loop;
		Deselect:
			PUNG A 1 A_Lower;
			Loop;
		Select:
			PUNG A 1 A_Raise;
			Loop;
		Fire:
			PUNG A 4 A_WeaponOffset(24, 42, WOF_ADD);
			PUNG B 3 A_WeaponOffset(-24, -42, WOF_ADD);
			PUNG C 2 {
				if (A_PunchWithResult()) {
					return ResolveState("Hitstop");
				}
				else {
					return ResolveState("PostSwing");
				}
			}
		Hold:
			PUNG B 3;
			PUNG C 2 {
				if (A_PunchWithResult()) {
					return ResolveState("Hitstop");
				}
				else {
					return ResolveState("PostSwing");
				}
			}
		Hitstop:
			PUNG D 1 A_QuakeEx(4, 4, 3, 4, 0, 30, "", flags: QF_RELATIVE|QF_SCALEDOWN);
			Goto PostSwing;
		PostSwing:
			PUNG D 3;
			PUNG C 5;
			PUNG B 6 A_ReFire("Hold"); 
			PUNG B 4 A_WeaponOffset(0, 42, WOF_ADD);
			PUNG A 4 A_WeaponOffset(0, -42, WOF_ADD);
			Goto Ready;
	}

	action bool	A_PunchWithResult() {
		FTranslatedLineTarget t;
		
		int damage = (random(1,2)*15);		
		
		if (FindInventory("PowerStrength")) {
			damage = (random(1,3)*80);
		}
		
		double ang = angle + Random2[Punch]() * (5.625 / 256);
		double pitch = AimLineAttack (ang, DEFMELEERANGE, null, 0., ALF_CHECK3D);

		LineAttack (ang, DEFMELEERANGE, pitch, damage, 'Melee', "BulletPuff", LAF_ISMELEEATTACK, t);

		// turn to face target
		if (t.linetarget)
		{
			A_PlaySound ("*fist", CHAN_WEAPON);
			angle = t.angleFromSource;
			return true;
		}
		else {
			return false;
		}
	}
}