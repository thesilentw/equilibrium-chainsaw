// --------------------------------------------------------------------------
// Plasma Rifle
//
// The rebalanced Plasma Rifle uses an upgraded magnetic field to fire a
// faster projectile. The field dissapates more slowly, giving the projectiles
// a chance to bounce off walls. This also results in occasional chain-firing
// of surplus ionized gas in the firing chamber, effectively giving 'free' shots.
// --------------------------------------------------------------------------

class RBLPlasmaRifle : EQCWeapon replaces PlasmaRifle {
	bool flashTracker;
	
	Default {
		Weapon.slotNumber 6;
		Weapon.SelectionOrder 100;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 40;
		Weapon.AmmoType "Cell";
		Inventory.PickupMessage "$GOTPLASMA";
		Tag "$TAG_PLASMARIFLE";
	}
	
	States {
		Ready:
			PLSG A 1 {
				A_WeaponReady();
				invoker.flashTracker = true;
			}
			Loop;
		Deselect:
			PLSG A 1 A_Lower;
			Loop;
		Select:
			PLSG A 1 A_Raise;
			Loop;
		Fire:
			PLSG A 3 {
				A_GunFlash();
				switch(random(1,4)) {
					case 1:
						A_FireProjectile("RBLPlasmaBall", 0, 1, spawnheight: -10);
						break;
					case 2:
						A_FireProjectile("RBLPlasmaBall1", 0, 1, spawnheight: -10);
						break;
					case 3:
						A_FireProjectile("RBLPlasmaBall2", 0, 1, spawnheight: -10);
						break;
					case 4: 
						A_FireProjectile("RBLPlasmaBall", 0, 0, spawnheight: -10);
						break;
				}
				A_AlertMonsters();
			}
			PLSG B 15 A_ReFire;
			Goto Ready;
		Flash:
			TNT1 A 0 {
				if (invoker.flashTracker) {
					invoker.flashTracker = !invoker.flashTracker;
					return ResolveState("Flash1");
				}
				else {
					invoker.flashTracker = !invoker.flashTracker;
					return ResolveState("Flash2");
				}
				return ResolveState("Null");
			}
		Flash1:
			PLSF A 4 Bright A_Light1;
			Goto LightDone;
		Flash2:
			PLSF B 4 Bright A_Light1;
			Goto LightDone;
		Spawn:
			PLAS A -1;
			Stop;
	}
}

class RBLPlasmaBall : Actor {

	Default {
		Radius 13;
		Height 8;
		Speed 45;
		DamageFunction (Random(1,3)*18);
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
		SeeSound "weapons/plasmaf";
		BounceSound "weapons/plasma_bounce";
		DeathSound "weapons/plasmax";
		Obituary "$OB_MPPLASMARIFLE";
		Translation "0:255=%[0.1, 0.1, 0.9]:[1.0, 1.0, 1.0]";
		Decal "Scorch";
	}
	
	States {
		Spawn:
			PLSS AB 6 Bright;
			Loop;
		Death:
			PLSE ABCDE 4 Bright;
			Stop;
	}
}

class RBLPlasmaBall1 : RBLPlasmaBall {

	Default {
		Damage 4;
		BounceType "Hexen";
		BounceFactor 1.5;
		BounceCount 5;
		Obituary "$OB_MPBFG_MBF";
	}
	
	States {
		Spawn:
			PLS1 AB 6 Bright;
			Loop;
		Death:
			PLS1 CDEFG 4 Bright;
			Stop;
	}
}
	
class RBLPlasmaBall2 : RBLPlasmaBall1 {
	
	States {
		Spawn:
			PLS2 AB 6 Bright;
			Loop;
		Death:
			PLS2 CDE 4 Bright;
			Stop;
	}
}