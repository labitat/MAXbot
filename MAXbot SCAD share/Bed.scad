//Vars
$fn=50;
bedX		= 240;	//std:240	//mini:156
bedY		= 320;  //std:320	//mini:240
bedZ		= 5;
holesRad	= 3		*0.5;
turnRad		= 15;	//20
hexnutHgt	= 3;
mkSide		= 214;	//214
mkMount		= 209;	//209
hwRad		= 4;
mkHgt		= 10;
beltMount	= 19;
beltOffset	= 46;
slotLength	= 4;

hwOffset	= hwRad*4;

wlRad		= 8;
wlInside	= 1.5*wlRad;
wlInsideOff	= wlInside+1.42*wlRad*2;
wlSide		= mkSide/2-wlRad;
wlCenter	= 0;

module wl() //weightloss
{
	hull()
	{
		translate([wlInsideOff, wlInside+wlRad/2, 0])
		cylinder(h=bedZ+1, r=wlRad ,center=true);

		translate([wlSide, wlSide-(wlInsideOff-wlInside), 0])
		cylinder(h=bedZ+1, r=wlRad ,center=true);

		translate([wlSide, wlInside+wlRad/2, 0])
		cylinder(h=bedZ+1, r=wlRad ,center=true);
	}
}

module wl2() //weightloss
{
	scale([0.9, 1, 1])
	wl();

	scale([1, 1, 1])
	mirror([-1, 1, 0])
	translate([0, 0, 0])
	wl();
}


module mkMountHole()
{
	cylinder(r=holesRad, h=bedZ+1, center=true);

	//hexnut
	translate([0, 0, (-bedZ-hexnutHgt)])
	#cylinder(r=3.2 ,h=hexnutHgt, center=true, $fn=6);

	//legs
	#cylinder(r=holesRad, h=bedZ+mkHgt*2, center=true);
}


module mk()
{
	for (ra=[0, 180])
	rotate([0, 0, ra])
	{
		translate([-mkMount/2, mkMount/2, 0])
		mkMountHole();

		translate([0, mkMount/2, 0])
		mkMountHole();

		translate([mkMount/2, mkMount/2, 0])
		mkMountHole();

		//heater wire hole
		translate([0, mkSide/2+hwOffset, 0])
		cylinder(h=bedZ+1, r=hwRad, center=true);
	}

	//thermistor wire hole
	//translate([mkSide/2+hwOffset, 0, 0])
	cylinder(h=bedZ+1, r=wlRad*2, center=true);

	//plate
	#translate([0, 0, bedZ/2+mkHgt])
	cube([mkSide, mkSide, 1], center=true);
}


module main()
{
	difference()
	{
		//ADD:
		union()
		{
			//main body
			cube([bedX+turnRad, bedY, bedZ], center=true);

			//corner shapes
			for (iy=[-bedY/2, bedY/2])
			{
				hull()
				{
					for (ix=[-bedX/2, bedX/2])
					{
						translate([ix,iy,0])
						{
							cylinder(r=turnRad, h=bedZ, center=true);
						}
					}
				}
			}
		}

		//REMOVE:
		union()
		{

			//Timeglass shape
			for (ix=[-1, 1])
			{
				translate([ix*(bedX/2+turnRad), 0, 0])
				hull()
				{
					for (iy=[-1, 1])
					{
						translate([0, iy*(bedY/2-turnRad*1.73), 0])
						cylinder(r=turnRad, h=bedZ+1, center=true);
					}
				}
			}

			//weightloss-cutouts
			wl2();
			mirror([1, 0, 0]) wl2();
			rotate([0, 0, 180])
			{
				wl2();
				mirror([1, 0, 0]) wl2();
			}

			//Corner holes + belt clips
			for (iy=[-1, 1])
			{
				for (ix=[-1, 1])
				{
					translate([ix*bedX/2, iy*bedY/2, 0])
					{
						slot();
						//cylinder(r=holesRad, h=bedZ+1, center=true);

						translate([-ix*beltOffset, 0, 0])
						{
							slot();
							//cylinder(r=holesRad, h=bedZ+1, center=true);

							translate([-ix*beltMount, 0, 0])
							slot();
							//cylinder(r=holesRad, h=bedZ+1, center=true);
						}
					}
				}
			}

			//MK2 heatbed
			mk();
		}
	}
}

module slot()
{
	hull()
	{
		translate([-slotLength, 0, 0])
		cylinder(r=holesRad, h=bedZ+1, center=true);

		translate([slotLength, 0, 0])
		cylinder(r=holesRad, h=bedZ+1, center=true);

	}
}


projection(cut = true)
main();