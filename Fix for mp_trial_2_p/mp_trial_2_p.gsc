/*
                   _____     ______     __   __     ______   __  __     ______     __    __     ______     __   __
                  /\  __-.  /\  __ \   /\ "-.\ \   /\__  _\ /\ \_\ \   /\  ___\   /\ "-./  \   /\  __ \   /\ "-.\ \
                  \ \ \/\ \ \ \  __ \  \ \ \-.  \  \/_/\ \/ \ \  __ \  \ \  __\   \ \ \-./\ \  \ \  __ \  \ \ \-.  \
          _______  \ \____-  \ \_\ \_\  \ \_\\"\_\    \ \_\  \ \_\ \_\  \ \_____\  \ \_\ \ \_\  \ \_\ \_\  \ \_\\"\_\  _______
         /\______\  \/____/   \/_/\/_/   \/_/ \/_/     \/_/   \/_/\/_/   \/_____/   \/_/  \/_/   \/_/\/_/   \/_/ \/_/ /\______\
         \/______/                                                                                                    \/______/


 ______     ______     _____       __     __  __     __    __     ______   ______     ______           ______     ______     __    __
/\  ___\   /\  __ \   /\  __-.    /\ \   /\ \/\ \   /\ "-./  \   /\  == \ /\  ___\   /\  == \         /\  ___\   /\  __ \   /\ "-./  \
\ \ \____  \ \ \/\ \  \ \ \/\ \  _\_\ \  \ \ \_\ \  \ \ \-./\ \  \ \  _-/ \ \  __\   \ \  __<     __  \ \ \____  \ \ \/\ \  \ \ \-./\ \
 \ \_____\  \ \_____\  \ \____- /\_____\  \ \_____\  \ \_\ \ \_\  \ \_\    \ \_____\  \ \_\ \_\  /\_\  \ \_____\  \ \_____\  \ \_\ \ \_\
  \/_____/   \/_____/   \/____/ \/_____/   \/_____/   \/_/  \/_/   \/_/     \/_____/   \/_/ /_/  \/_/   \/_____/   \/_____/   \/_/  \/_/


                              _____________________________________________________________________________
                             //______________- Trial 2 - Scripted and Mapped by _DanTheMan_ -_____________\\
                             \\ If you have a question about the following code, X-Fire me at 7dantheman7 //
                              \\ Please do not use this code or any variant of it without my permission  //
                               \\¯¯¯¯¯¯¯¯¯¯¯¯¯CoDJumper.com - For all your CoDJumping needs!¯¯¯¯¯¯¯¯¯¯¯¯//
                                ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

// PATCHED

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
	level.jump3r = loadFX("jump3r/jump");

	maps\mp\_load::main();
	ambientPlay("ambient_hill");
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	level.airstrikeHeightScale = 1.8;

	localVar = int(randomIntRange(5593849, 9593850)/randomIntRange(1593849, 5593848));

	teleporter = getEntArray("teleport", "targetname");

	for(i = 0;i < teleporter.size;i++)
	{
		if(isDefined(teleporter[i].target))
			teleporter[i] thread teleportation(getEnt(teleporter[i].target, "targetname"));
	}

	getEnt("no_rpg", "targetname") thread no_rpg(undefined, localVar);
	getEnt("yes_rpg", "targetname") thread yes_rpg(localVar);

	thread onEndPlayer("Beginner", localVar + "b");
	thread onEndPlayer("Intermediate", localVar + "i");
	thread onEndPlayer("Advanced", localVar + "a");
	thread onConnectedPlayer(localVar);

	thread bonus();
}

teleportation(target)
{
	for(;;)
	{
		self waittill("trigger", p);

		p setOrigin(target.origin);
		p setPlayerAngles(target.angles);
	}
}

no_rpg(p, localVar)
{
	if(!isDefined(p))
	{
		for(;;)
		{
			self waittill("trigger", p);

			if(!isDefined(p.no_rpg) && !isDefined(p.yes_rpg))
				self thread no_rpg(p, localVar);
		}
	}

	else
	{
		p endon("disconnect");

		p.no_rpg = true;

		while(p isTouching(self) && ((!isDefined(p.yes_rpg)) || (isDefined(p.yes_rpg) && p.yes_rpg != localVar)))
		{
			if(!p isOnLadder() && !p isMantling() && weaponType(p getCurrentWeapon()) == "projectile")
			{
				p iPrintLn("You cannot use an RPG on ^1Advanced^7!");
				if(p hasWeapon("beretta_mp"))
					p switchToWeapon("beretta_mp");
				else if(!p hasWeapon("beretta_mp") && p hasWeapon("deserteaglegold_mp"))
					p switchToWeapon("deserteaglegold_mp");
				else if(!p hasWeapon("beretta_mp") && !p hasWeapon("deserteaglegold_mp") && p hasWeapon("colt45_mp"))
					p switchToWeapon("colt45_mp");
				else if(!p hasWeapon("beretta_mp") && !p hasWeapon("deserteaglegold_mp") && !p hasWeapon("colt45_mp") && p hasWeapon("usp_mp"))
					p switchToWeapon("usp_mp");
				else
				{
					p giveWeapon("beretta_mp");
					p switchToWeapon("beretta_mp");
				}

				wait 1;
			}

			wait 0.75;
		}

		p.no_rpg = undefined;
	}
}

yes_rpg(localVar)
{
	for(;;)
	{
		self waittill("trigger", p);

		if(!isDefined(p.yes_rpg))
		{
			p iPrintLn("You can now use your RPG");
			p.yes_rpg = localVar;
		}
	}
}

onEndPlayer(str, localVar)
{
	end = getEnt("mapend_" + tolower(str), "targetname");

	number = [];
	for(i = 0;i < 4;i++)
	{
		top = getEnt(tolower(str) + "_" + i + "_14", "targetname");

		upleft   = getEnt(tolower(str) + "_" + i + "_1237", "targetname");
		midleft  = getEnt(tolower(str) + "_" + i + "_137", "targetname");
		lowleft  = getEnt(tolower(str) + "_" + i + "_134579", "targetname");

		center   = getEnt(tolower(str) + "_" + i + "_017", "targetname");

		upright  = getEnt(tolower(str) + "_" + i + "_56", "targetname");
		midright = getEnt(tolower(str) + "_" + i, "targetname");
		lowright = getEnt(tolower(str) + "_" + i + "_2", "targetname");

		bottom   = getEnt(tolower(str) + "_" + i + "_1479", "targetname");

		number[i][0] = top;
		number[i][1] = upleft;
		number[i][2] = midleft;
		number[i][3] = lowleft;
		number[i][4] = center;
		number[i][5] = upright;
		number[i][6] = midright;
		number[i][7] = lowright;
		number[i][8] = bottom;

		for(n = 0;n < 9;n++)
		{
			number[i][n] hide();
			number[i][n] notSolid();
		}
	}

	colon = getEnt(tolower(str) + "_colon", "targetname");
	colon hide();
	colon notSolid();

	for(;;)
	{
		end waittill("trigger", p);

		if(!isDefined(p.finished))
		{
			p.finished = true;

			t = (maps\mp\gametypes\_globallogic::getTimePassed() - p.connectionTime)/1000;

			m = t/60;
			s = 0;
			if(isSubStr(m + "", "."))
			{
				s = getSubStr(strTok(m + "", ".")[1], 0, 2);
				m = int(strTok(m + "", ".")[0]);
			}

			if(isDefined(s) && s != "")
				s = int(s)/166.66666666666666666666666666667;
			else
				s = 0;

			t = m + s;

			t = strTok(t + "", ".");
			t[3] = getSubStr(t[1], 1, 2);
			t[2] = getSubStr(t[1], 0, 1);
			t[1] = getSubStr(t[0], 1, 2);
			t[0] = getSubStr(t[0], 0, 1);
			if(!isDefined(t[3]) || t[3] == "")
				t[3] = "0";
			if(!isDefined(t[2]) || t[2] == "")
				t[2] = "0";
			if(!isDefined(t[0]) || t[0] == "")
				t[0] = "0";
			if(!isDefined(t[1]) || t[1] == "")
			{
				t[1] = t[0];
				t[0] = "0";
			}

			temp = t[0] + "" + t[1];

			if(int(temp) > 99)
			{
				t[0] = "9";
				t[1] = "9";
				t[2] = "6";
				t[3] = "0";
			}

			if(t[0] == "0")
				temp = t[1];

			iPrintLn(p.name + "^7 finished ^1" + str + "^7 in " + temp + ":" + t[2] + "" + t[3]);

			if(t[0] != "0")
			{
				for(n = 0;n < 9;n++)
				{
					hide = strTok(number[0][n].targetname, "_")[2];

					if(!isDefined(hide) || (isDefined(hide) && !isSubStr(hide, t[0] + "")))
					{
						number[0][n] show();
						number[0][n] solid();
					}
				}
			}

			for(i = 1;i < 4;i++)
			{
				for(n = 0;n < 9;n++)
				{
					hide = strTok(number[i][n].targetname, "_")[2];

					if(!isDefined(hide) || (isDefined(hide) && !isSubStr(hide, t[i] + "")))
					{
						number[i][n] show();
						number[i][n] solid();
					}
				}
			}

			colon show();
			colon solid();

			wait 7.5;

			colon hide();
			colon notSolid();

			if(t[0] != "0")
			{
				for(n = 0;n < 9;n++)
				{
					hide = strTok(number[0][n].targetname, "_")[2];

					if(!isDefined(hide) || (isDefined(hide) && !isSubStr(hide, t[0] + "")))
					{
						number[0][n] hide();
						number[0][n] notSolid();
					}
				}
			}

			for(i = 1;i < 4;i++)
			{
				for(n = 0;n < 9;n++)
				{
					hide = strTok(number[i][n].targetname, "_")[2];

					if(!isDefined(hide) || (isDefined(hide) && !isSubStr(hide, t[i] + "")))
					{
						number[i][n] hide();
						number[i][n] notSolid();
					}
				}
			}

			p notify(localVar);
		}
	}
}

// still leaving this as a bonus for completing advanced, but not possible to attain any other way
jump3r(authentication)
{
	self endon("disconnect");

	self waittill(authentication);

	if(!isDefined(self.gifted))
		self.gifted = true;

	else return;

	self iPrintLn("Double-tap ^1FRAG ^7to teleport");

	for(;;)
	{
		if(self fragButtonPressed())
		{
			frag = false;
			for(i = 0;i < 0.5;i += 0.05)
			{
				if(self fragButtonPressed() && frag)
				{
					self.originSucks = false;

					eye = self eye();

					lookAtOrigin = bulletTrace(eye, eye + maps\mp\_utility::vector_Scale(anglesToForward(self getPlayerAngles()), 999999), false, self)["position"];
					lookAtOrigin = self fixOriginForPlayer(lookAtOrigin);

					if(self.originSucks)
						self iPrintLn("Position is too close to two or more walls");

					else
					{
						playFX(level.jump3r, self.origin);

						self setOrigin(lookAtOrigin);
					}

					break;
				}
				
				else if(!self fragButtonPressed() && !frag)
					frag = true;

				wait 0.05;
			}
		}

		wait 0.05;
	}
}

jump()
{
	self.originSucks = false;

	eye = self eye();

	lookAtOrigin = bulletTrace(eye, eye + maps\mp\_utility::vector_Scale(anglesToForward(self getPlayerAngles()), 999999), false, self)["position"];
	lookAtOrigin = self fixOriginForPlayer(lookAtOrigin);

	if(self.originSucks)
		self iPrintLn("Position is too close to two or more walls");

	else
	{
		playFX(level.jump3r, self.origin);

		self setOrigin(lookAtOrigin);
	}
}


fixOriginForPlayer(origin)
{
	x = false;
	y = false;

	if(self simpleTrace(origin, (1, 0, 0)))
	{
		if(self simpleTrace(origin, (-33, 0, 0)))
		{
			self.originSucks = true;
			return false;
		}

		origin -= (16, 0, 0);
	}

	if(self simpleTrace(origin, (-1, 0, 0)))
	{
		if(self simpleTrace(origin, (33, 0, 0)))
		{
			self.originSucks = true;
			return false;
		}

		origin += (16, 0, 0);
	}

	if(self simpleTrace(origin, (0, 1, 0)))
	{
		if(self simpleTrace(origin, (0, -33, 0)))
		{
			self.originSucks = true;
			return false;
		}

		origin -= (0, 16, 0);
	}

	if(self simpleTrace(origin, (0, -1, 0)))
	{
		if(self simpleTrace(origin, (0, 33, 0)))
		{
			self.originSucks = true;
			return false;
		}

		origin += (0, 16, 0);
	}

	if(self simpleTrace(origin, (0, 0, 1)))
	{
		stance = self getStance();

		if(self simpleTrace(origin, (0, 0, -61)) || self simpleTrace(origin, (0, 0, -51)) || self simpleTrace(origin, (0, 0, -41)))
		{
			self.originSucks = true;
			return false;
		}

		else if(stance == "crouch")
			origin -= (0, 0, 52);
		else if(stance == "prone")
			origin -= (0, 0, 42);
		else
			origin -= (0, 0, 62);
	}

	return origin;
}

simpleTrace(org1, org2)
{
	return !bulletTracePassed(org1, org1 + org2, false, self);
}

eye()
{
	eye = self.origin + (0, 0, 60);

	if(self getStance() == "crouch")
		eye = self.origin + (0, 0, 40);

	else if(self getStance() == "prone")
		eye = self.origin + (0, 0, 11);

	return eye;
}

b00st(authentication)
{
	self endon("disconnect");

	self waittill(authentication);

	if(!isDefined(self.gifted))
		self.gifted = true;

	else return;

	self iPrintLn("Double-tap ^1FRAG ^7in the air for a boost");

	for(;;)
	{
		if(self fragButtonPressed())
		{
			frag = false;
			for(i = 0;i < 0.5;i += 0.05)
			{
				if(!self isOnGround() && !self isOnLadder() && !self isMantling() && self fragButtonPressed() && frag)
				{
					origin = self.origin - (0, 0, 50);

					health = self.health;
					maxHealth = self.maxhealth;

					self.health = 500000000;
					self.maxhealth = 500000000;

					self thread adminOff();

					//self thread maps\mp\gametypes\_globallogic::finishPlayerDamageWrapper(self, self, 99, 0, "MOD_RIFLE_BULLET", "mp_trial_2_damage", origin, (self.origin - origin), "head", 0);

					self notify("admin_on");

					self.health = health;
					self.maxhealth = maxHealth;

					while(!self isOnGround())
						wait 0.25;

					break;
				}

				else if(!self fragButtonPressed() && !frag)
					frag = true;

				wait 0.05;
			}
		}

		wait 0.05;
	}
}

onConnectedPlayer(localVar)
{
	for(;;)
	{
		level waittill("connected", p);

		p thread onSpawnPlayer(localVar);
	}
}

onSpawnPlayer(localVar)
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		if(!isDefined(self.connectionTime))
		{
			self.connectionTime = maps\mp\gametypes\_globallogic::getTimePassed();

			self.bonusCode = "";

			self thread jump3r(localVar + "a");
			self thread b00st(localVar + "i");

			self setClientDvar("r_distortion", 1);

			break;
		}
	}
}

bonus()
{
	rotators = getEntArray("rotator", "targetname");
	for(i = 0;i < rotators.size;i++)
		rotators[i] thread rotation("y");

	/***************/

	trapdoor = getEnt("trapdoor", "targetname");
	t = [];
	for(i = 1;i < 5;i++)
		t[i] = getEnt("trapdoor_trig" + i, "targetname");

	trapdoor thread trapdoor(t);

	/***************/

	escalator = getEntArray("escalator", "targetname");
	s = getEnt("escalator_start", "targetname");
	e = getEnt("escalator_end", "targetname");

	for(i = 0;i < escalator.size;i++)
		escalator[i] thread escalator(s.origin, e.origin);

	s thread escalator(s.origin, e.origin);
	e delete();

	/***************/

	thread pong();
}

rotation(v)
{
//	r = (360, 0, 0);
//	if(v == "y")
//		r = (0, 360, 0);
//	else if(v == "z")
//		r = (0, 0, 360);

	for(;;)
	{
		self rotateYaw(360, 0.2);
		wait 0.1;
	}
}

trapdoor(t)
{
	for(i = 1;i < 5;i++)
		t[i] thread onTrigger(i);

	for(;;)
	{
		level waittill("trapdoor");

		self hide();
		self notSolid();
		wait 2;
		self show();
		self solid();
	}
}

onTrigger(i)
{
	code = 231331221;

	for(;;)
	{
		self waittill("trigger", p);

		if(i == 4)
			p.bonusCode = "";

		else
		{
			if(int(p.bonusCode) == code)
				level notify("trapdoor");

			else
			{
				p.bonusCode += "" + i;

				if(int(p.bonusCode) == code)
					level notify("trapdoor");
			}
		}
	}
}

escalator(s, e)
{
	v = distance(self.origin, e)/480;

	self moveTo(e, v);
	wait v;
	self.origin = s;

	v = distance(s, e)/480;
	for(;;)
	{
		self moveTo(e, v);
		wait v;
		self.origin = s;
	}
}

pong()
{
	/*begin init*/

	// boundaries
	boundTop    = getEnt("pong_boundTop", "targetname");
	boundBottom = getEnt("pong_boundBottom", "targetname");

	// moving entities
	pong = [];

	pong[0] = "player";	pong[1] = "ai";	pong[2] = "ball";

	for(i = 0;i < 3;i++)
	{
		pong[pong[i]] = getEnt("pong_" + pong[i], "targetname");
		pong[pong[i]].connection = getEnt("pong_" + pong[i] + "_connection", "targetname");
		pong[pong[i]] linkTo(pong[pong[i]].connection);
		pong[pong[i]].start = pong[pong[i]].connection.origin;
	}

	// user trigger
	userDetection = getEnt("user_detection", "targetname");

	pong["ball"].connection linkTo(pong["player"].connection);

	/*begin pong*/
	for(;;)
	{
		ballServed = false;
		matchOver = false;
		matchStarted = false;
		victor = "ai";

		userDetection waittill("trigger", p);

		while(p isTouching(userDetection))
		{
			wait 0.05;

			/*ball physic*/
			if(!matchStarted)
			{
				matchStarted = true;

				if(!isDefined(p.informed))
				{
					p iPrintLn("Melee = serve ball; Use = up; Shoot = down");
					p.informed = true;
				}

				wait 0.5;

				pong["ball"].path = (-0.675, 0, -0.425);
			}

			if(!ballServed && matchStarted && p meleeButtonPressed())
			{
				pong["ball"].connection unlink();
				ballServed = true;
			}

			if(ballServed)
				pong["ball"].connection.origin += pong["ball"].path;

			if(matchStarted && ballServed && pong["ball"].connection.origin[2] - 0.5 <= 48.5 || pong["ball"].connection.origin[2] + 0.5 >= 65.5)
				pong["ball"].path *= (1, 1, -1);

			if(matchStarted && ballServed && pong["ball"].connection.origin[0] - 0.5 <= 457)
			{
				if(pong["ball"].connection.origin[2] >= pong["ai"].connection.origin[2] - 2.7 && pong["ball"].connection.origin[2] <= pong["ai"].connection.origin[2] + 2.7)
				{
					if(pong["ball"].connection.origin[2] > pong["ai"].connection.origin[2])
						pong["ball"].path += (0, 0, (distance((0, 0, pong["ball"].connection.origin[2]), (0, 0, pong["ai"].connection.origin[2]))/10));

					else if(pong["ball"].connection.origin[2] < pong["ai"].connection.origin[2])
						pong["ball"].path -= (0, 0, (distance((0, 0, pong["ball"].connection.origin[2]), (0, 0, pong["ai"].connection.origin[2]))/10));

					pong["ball"].path *= (-1, 1, 1);
				}

				else
				{
					matchOver = true;
					victor = "player";
				}
			}

			else if(matchStarted && ballServed && pong["ball"].connection.origin[0] + 0.5 >= 483)
			{
				if(pong["ball"].connection.origin[2] >= pong["player"].connection.origin[2] - 2.7 && pong["ball"].connection.origin[2] <= pong["player"].connection.origin[2] + 2.7)
				{
					if(pong["ball"].connection.origin[2] > pong["player"].connection.origin[2])
						pong["ball"].path += (0, 0, (distance((0, 0, pong["ball"].connection.origin[2]), (0, 0, pong["player"].connection.origin[2]))/10));

					else if(pong["ball"].connection.origin[2] < pong["player"].connection.origin[2])
						pong["ball"].path -= (0, 0, (distance((0, 0, pong["ball"].connection.origin[2]), (0, 0, pong["player"].connection.origin[2]))/10));

					pong["ball"].path *= (-1, 1, 1);
				}

				else
				{
					matchOver = true;
					victor = "ai";
				}
			}

			if(matchOver)
			{
				winner = "AI ";
				if(victor == "player")
					winner = "You ";

				p iPrintLn(winner + "won!");
				wait 0.5;

				matchStarted = false;

				for(i = 0;i < 3;i++)
					pong[pong[i]].connection.origin = pong[pong[i]].start;

				matchOver = false;
				ballServed = false;
				pong["ball"].connection linkTo(pong["player"].connection);
				pong["ball"].path = (-0.675, 0, -0.425);
			}

			/*player input*/
			if(matchStarted)
			{
				if(p useButtonPressed() && pong["player"].connection.origin[2] < 63)
					pong["player"].connection.origin += (0, 0, 0.5);

				else if(p attackButtonPressed() && pong["player"].connection.origin[2] > 50.5)
					pong["player"].connection.origin -= (0, 0, 0.5);
			}

			/*ai input*/
			if(matchStarted && ballServed && pong["ball"].path[0] < 0)
			{
				if(pong["ai"].connection.origin[2] < pong["ball"].connection.origin[2] && pong["ai"].connection.origin[2] < 63)
					pong["ai"].connection.origin += (0, 0, 0.5);

				else if(pong["ai"].connection.origin[2] > pong["ball"].connection.origin[2] && pong["ai"].connection.origin[2] > 50.5)
					pong["ai"].connection.origin -= (0, 0, 0.5);
			}
		}

		for(i = 0;i < 3;i++)
			pong[pong[i]].connection.origin = pong[pong[i]].start;

		pong["ball"].connection linkTo(pong["player"].connection);

		p.informed = undefined;
	}
}

adminOff()
{
	self endon("disconnect");

	status = false;
	type = "";
	if(isDefined(self.cj) && isDefined(self.cj["status"]))
	{
		status = self.cj["status"];
		self.cj["status"] = false;
		type = "cj";
	}
	else if(isDefined(self.eIsAdmin))
	{
		status = self.eIsAdmin;
		self.eIsAdmin = false;
		type = "exso";
	}
	else if(isDefined(self.arr) && isDefined(self.arr["power"]))
	{
		status = self.arr["power"];
		self.arr["power"] = false;
		type = "aftershock";
	}
	else if(isDefined(self.mod))
	{
		if(isDefined(self.mod["admin"]) && self.mod["admin"])
		{
			status = true;
			self.mod["admin"] = false;
			type = "nade_admin";
		}

		else if(isDefined(self.mod["miniAdmin"]) && self.mod["miniAdmin"])
		{
			status = true;
			self.mod["miniAdmin"] = false;
			type = "nade_mini";
		}

		else if(isDefined(self.mod["admin"]) && self.mod["admin"] && isDefined(self.mod["miniAdmin"]) && self.mod["miniAdmin"])
		{
			status = true;
			self.mod["admin"] = false;
			self.mod["miniAdmin"] = false;
			type = "nade_both";
		}
	}
	else
		return;

	self waittill("admin_on");

	switch(type)
	{
		case "cj":         self.cj["status"] = status; break;
		case "exso":       self.eIsAdmin = status;     break;
		case "aftershock": self.arr["power"] = status; break;
		case "nade_admin": self.mod["admin"] = status; break;
		case "nade_mini":  self.mod["miniAdmin"] = status; break;
		case "nade_both":  self.mod["admin"] = true; self.mod["miniAdmin"] = true; break;
	}
}