main()
{
	maps\mp\_load::main();	
	maps\mp\_teleport::main();
	maps\mp\_teleport2::main();
	maps\mp\_teleport3::main();
	maps\mp\_teleport4::main();
	maps\mp\_teleport5::main();
	maps\mp\_teleport6::main();
	maps\mp\_teleport7::main();


	thread endofmap1();
	thread endofmap2();
	thread endofmap3();
	thread endofmap4();
	thread fixedTP();

}

endofmap1()
{
trigger = getent("hard","targetname");

	while (1)
	{
		trigger waittill ("trigger", user );
		if ( isPlayer( user ) && isAlive( user ) && isdefined( user.done ) )
					{
					wait 0.5;
					}
		else
			{
user iprintlnbold ("^7Congratulations, " + user.name + ", you have completed ^1Hard ^7way^1!");
user iprintlnbold ("Easy way created by ^1RuleZzzz");	
user iprintlnbold ("Map created by ^1werax");	
			user.done = true;
			}
	}
}

endofmap2()
{
trigger = getent("inter+","targetname");

	while (1)
	{
		trigger waittill ("trigger", user );
		if ( isPlayer( user ) && isAlive( user ) && isdefined( user.done ) )
					{
					wait 0.5;
					}
		else
			{
user iprintlnbold ("^7Congratulations, " + user.name + ", you have completed ^1Inter+ ^7way^1!");
user iprintlnbold ("Easy way created by ^1RuleZzzz");	
user iprintlnbold ("Map created by ^1werax");		
			user.done = true;
			}
	}
}

endofmap3()
{
trigger = getent("inter","targetname");

	while (1)
	{
		trigger waittill ("trigger", user );
		if ( isPlayer( user ) && isAlive( user ) && isdefined( user.done ) )
					{
					wait 0.5;
					}
		else
			{
user iprintlnbold ("^7Congratulations, " + user.name + ", you have completed ^1Inter ^7way^1!");
user iprintlnbold ("Easy way created by ^1RuleZzzz");	
user iprintlnbold ("Map created by ^1werax");			
			user.done = true;
			}
	}
}

endofmap4()
{
trigger = getent("easy","targetname");

	while (1)
	{
		trigger waittill ("trigger", user );
		if ( isPlayer( user ) && isAlive( user ) && isdefined( user.done ) )
					{
					wait 0.5;
					}
		else
			{
user iprintlnbold ("^7Congratulations, " + user.name + ", you have completed ^1easy ^7way^1!");
user iprintlnbold ("Easy way created by ^1RuleZzzz");	
user iprintlnbold ("Map created by ^1werax");			
			user.done = true;
			}
	}
}

fixedTP() {
    from_x = 4149;
    from_y = -6037;
    from_z = -207;
    
    to_x = 1425;
    to_y = -6760;
    to_z = -730;
    trig_size = 100;
    trig_height = 74;
    fixed_tp = Spawn("trigger_radius", (from_x, from_y, from_z), 0, trig_size, trig_height);
    while (1) {
        fixed_tp waittill("trigger", player);
        if (player IsOnGround())
            player SetOrigin( (to_x, to_y, to_z) );
        wait 0.5;
    }
}



	
