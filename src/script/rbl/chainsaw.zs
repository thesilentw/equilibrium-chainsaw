// --------------------------------------------------------------------------
// Chainsaw
//
// Unlike the normal Chainsaw, this is a carbide-toothed rescue saw, intended
// to cut metals and other man-made obstacles. This, of course, greatly improves
// its demon-shredding power.
// --------------------------------------------------------------------------

class RBLChainsaw : EQCWeapon replaces Chainsaw
{
	Default
	{
		Weapon.SlotNumber 1;
		Weapon.Kickback 0;
		Weapon.SelectionOrder 2200;
		Weapon.UpSound "weapons/sawup";
		Weapon.ReadySound "weapons/sawidle";
		Inventory.PickupMessage "$GOTCHAINSAW";
		Weapon.AmmoType "None";
		Obituary "$OB_MPCHAINSAW";
		Tag "$TAG_CHAINSAW";
		+WEAPON.MELEEWEAPON
		+weapon.Ammo_Optional
	}
	States
	{
	Ready:
		SAWG CD 4 A_WeaponReady;
		Loop;
	Deselect:
		SAWG C 1 A_Lower;
		Loop;
	Select:
		SAWG C 1 A_Raise;
		Loop;
	Fire:
		//SAWG AB 4 A_Saw;	
		SAWG A 2 A_WeaponOffset(5, 0, WOF_ADD);
		SAWG A 2 {
			A_Saw(damage: 7);
			A_QuakeEx(4, 4, 4, 4, 0, 30, "", flags: QF_RELATIVE|QF_SCALEDOWN);
			A_WeaponOffset(-5, 4, WOF_ADD);
		}
		SAWG B 2 A_WeaponOffset(5, -4, WOF_ADD);
		SAWG B 2 {
			A_Saw(damage: 7);
			A_QuakeEx(3, 3, 3, 4, 0, 30, "", flags: QF_RELATIVE|QF_SCALEDOWN);
			A_WeaponOffset(-5, 0, WOF_ADD);
		}
		SAWG B 0 A_ReFire();
		Goto Ready;
	Spawn:
		CSAW A -1;
		Stop;
	}

	action void A_Saw(sound fullsound = "weapons/sawfull", sound hitsound = "weapons/sawhit", int damage = 2, class<Actor> pufftype = "BulletPuff", int flags = 0, double range = 0, double spread_xy = 2.8125, double spread_z = 0, double lifesteal = 0, int lifestealmax = 0, class<BasicArmorBonus> armorbonustype = "ArmorBonus")
	{
		FTranslatedLineTarget t;

		if (player == null)
		{
			return;
		}

		if (pufftype == null)
		{
			pufftype = 'BulletPuff';
		}
		if (damage == 0)
		{
			damage = 2;
		}
		if (!(flags & SF_NORANDOM))
		{
			damage *=  random[Saw](1, 10);
		}
		if (range == 0)
		{ 
			range = SAWRANGE;
		}

		double ang = angle + spread_xy * (Random2[Saw]() / 255.);
		double slope = AimLineAttack (ang, range, t) + spread_z * (Random2[Saw]() / 255.);

		Weapon weap = player.ReadyWeapon;
		if (weap != null && !(flags & SF_NOUSEAMMO) && !(!t.linetarget && (flags & SF_NOUSEAMMOMISS)) && !weap.bDehAmmo &&
			invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
		{
			if (!weap.DepleteAmmo (weap.bAltFire))
				return;
		}

		Actor puff;
		int actualdamage;
		[puff, actualdamage] = LineAttack (ang, range, slope, damage, 'Melee', pufftype, false, t);

		if (!t.linetarget)
		{
			if ((flags & SF_RANDOMLIGHTMISS) && (Random[Saw]() > 64))
			{
				player.extralight = !player.extralight;
			}
			A_PlaySound (fullsound, CHAN_WEAPON);
			return;
		}

		if (flags & SF_RANDOMLIGHTHIT)
		{
			int randVal = Random[Saw]();
			if (randVal < 64)
			{
				player.extralight = 0;
			}
			else if (randVal < 160)
			{
				player.extralight = 1;
			}
			else
			{
				player.extralight = 2;
			}
		}

		if (lifesteal && !t.linetarget.bDontDrain)
		{
			if (flags & SF_STEALARMOR)
			{
				if (armorbonustype == null)
				{
					armorbonustype = "ArmorBonus";
				}
				if (armorbonustype != null)
				{
					BasicArmorBonus armorbonus = BasicArmorBonus(Spawn(armorbonustype));
					armorbonus.SaveAmount = int(armorbonus.SaveAmount * actualdamage * lifesteal);
					armorbonus.MaxSaveAmount = lifestealmax <= 0 ? armorbonus.MaxSaveAmount : lifestealmax;
					armorbonus.bDropped = true;
					armorbonus.ClearCounters();

					if (!armorbonus.CallTryPickup (self))
					{
						armorbonus.Destroy ();
					}
				}
			}

			else
			{
				GiveBody (int(actualdamage * lifesteal), lifestealmax);
			}
		}

		A_PlaySound (hitsound, CHAN_WEAPON);
			
		// turn to face target
		if (!(flags & SF_NOTURN))
		{
			double anglediff = deltaangle(angle, t.angleFromSource);

			if (anglediff < 0.0)
			{
				if (anglediff < -4.5)
					angle = t.angleFromSource + 90.0 / 21;
				else
					angle -= 4.5;
			}
			else
			{
				if (anglediff > 4.5)
					angle = t.angleFromSource - 90.0 / 21;
				else
					angle += 4.5;
			}
		}
		if (!(flags & SF_NOPULLIN))
			bJustAttacked = true;
	}
}
