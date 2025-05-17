main()
{
	maps\mp\_load::main();
	maps\mp\mp_duchsnoep\comblock::main();
	maps\mp\mp_duchsnoep\speed::main();
	maps\mp\mp_duchsnoep\bounce::main();
	thread teleport();
	thread limitfps();
	thread killtrigs();
	//thread notifytrigs();
	thread platforms();
	precachemenu("check_com_maxfps");
}

platforms()
{
	one = getent("mozog_plat", "targetname");
	two = getentarray("mozog_bou", "targetname");
	one thread domove(-800);
	for(i = 0; i < two.size; i++)
		two[i] thread domove(800);
}

domove(dist)
{
	while(true)
	{
		self movex(dist, 5, 2, 2);
		self waittill("movedone");
		wait 1;
		dist *=-1;
	}
}

limitfps()
{
	while(true)
	{
		level waittill("connecting", player);
		player thread waitforspawn();
		player thread onmenu();
	}
}

waitforspawn()
{
	self.checked_fps = undefined;;
	self endon("disconnect");
	while(true)
	{
		while(!isalive(self))
			wait 0.5;
		//self setclientcvar("com_maxfps", 125);
		self setclientdvar("com_maxfps", "125");
		wait 0.05;
	}
}

onmenu()
{
	self endon("disconnect");
	while(true)
	{
		self waittill("menuresponse", menu, response);
		if(menu == "check_com_maxfps")
		{
			if(response == "imabigfatcheater" || !isdefined(self.checked_fps) || self.checked_fps)
			{
				iprintlnbold(self.name + " is using con_maxfps. ^1CHEATER");
				self.checked_fps = true;
			}
			else if(response == "imclean")
			{
				iprintln(self.name + " is using com_maxfps. good.");
				self.checked_fps = true;
			}
		}
	}
}

teleportcheck()
{
	trig = getent("entercheck");
	while(true)
	{
		trig waittill("trigger", player);
		target = getent(self.target, "targetname");
		if(!isdefined(player.checked_fps) || !player.checked_fps)
		{
			if(!isdefined(player.checked_fps))
			{
				if(!isdefined(player.checked_fps))
				{
					player closemenu();
					player closeingamemenu();
					player openmenu("check_com_maxfps");
				}
				player.checked_fps = false;
			}
		}
		else
		{
			wait 0.1;
			player setorigin(target.origin);
			player setplayerangles(target.angles);
			wait 0.1;
		}
	}
}

teleport()
{
	entTransporter = getentarray( "enter", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter();
}
 
transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		wait 0.1;
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.1;
	}
}

killtrigs()
{
	trigs = getentarray("kill_player", "targetname");
	for(i = 0; i < trigs.size; i++)
	{
		trigs[i] thread waitforplayerkill();
	}
}

waitforplayerkill()
{
	while(true)
	{
		self waittill("trigger", player);
		player suicide();
	}
}

notifytrigs()
{
	ents = getentarray();
	for(i = 0; i < ents.size; i++)
	{
		if(isdefined(ents[i].classname) && ents[i].classname == "trigger_multiple")
		{
			ents[i] thread waitforp();
		}
	}
}

waitforp()
{
	while(true)
	{
		self waittill("trigger", player);
		if(isdefined(self.targetname))
			player iprintln("Activated " + self.targetname);
		else
			player iprintln("Activated something without targetname");
	}
}