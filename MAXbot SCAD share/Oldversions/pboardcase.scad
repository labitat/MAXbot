//SELECT RENDER MODE:
// 3 = assembled case
// 2 = lid
// 1 = base
// 0 = PCB hull
rendertype		=1;

//PCB in preview: (0 = disable  |  1 = enable)
showpcb		= false;

//Set this slightly above intended layer thickness. It will render a single layer of horizontal plane to support mid-air mounting hole boundaries:
overhanghold	= 0.25;		

//Wall thickness: (base, lid & all four sides)
casewall		= 3;

//Additional space around PCB (because no PCB is cut excactly to measure)
boardxyadd		= 1;

//Additional space around plugs (according to your printer)
plugsxyadd		= 1;



//
//Be carefull when changing the following parameters:
//
boardx		= 100.08;	//PCB x
boardy		= 60.96;	//PCB Y
boardz		= 1.5;		//PCB Z
boardh		= 15;		//PCB height incl. components (case internal height)
boardlift	= 3;		//PCB mount heigth (to make space for rear side solderings)
boardliftd	= 8;		//PCB mount width
mountholesx	= 92.46;	//PCB mounting holes X-distance
mountholesy	= 53.34;	//PCB mounting holes Y-distance
mountholesd	= 3.6;		//PCB mounting holes diameter
screwrecess	= 4.15;		//Depth of hole for screw head
hexrecess	= 3.85;		//Depth of hole for hex nuts
grid		= 0.254;	//how many millimeters goes to ten mils (10 mil = 0.01 inch)
$fn			= 50;		//Circular level of details



casex = boardx+2*(casewall+boardxyadd);
casey = boardy+2*(casewall+boardxyadd);
casez = boardh+2*casewall;
plugsz = boardh+casewall*2;
splitz = casewall+boardlift+boardz-0.01;
screwlead = casez-screwrecess-hexrecess;


echo("M3 Mounting screws lead length:", screwlead+7);

//Pin
module pin(pinwidth, pinlength)
{
	translate([-pinwidth/2, -pinwidth/2, 0])
	cube([pinwidth, pinwidth, pinlength]);
}

//Molek KK type header
module molex(pins)
{
	//outline
	translate([-6*grid-plugsxyadd, -10*grid-plugsxyadd, 0])
	cube([12*grid*pins + 2*plugsxyadd, 26*grid + 2*plugsxyadd, plugsz], center=false);
	
	if (showpcb)
	{
		//pins
		for(i=[0:1:pins-1])
			translate([10*grid*i, 0, -3])
			%pin(0.6, 13);
		
		//horizontal plate
		color([1, 1, 1])
		translate([-5*grid, -10*grid, 0])
		%cube([10*grid*pins, 22*grid, 2.5], center=false);

		//vertical plate
		color([1, 1, 1])
		translate([0, -10*grid, 0])
		%cube([10*grid*(pins-1), 1.5, 8]);
	}
}

//IDC pin header
module IDC(xpins, ypins)
{
	//outline
	translate([-5*grid-9.1*grid-plugsxyadd, -5*grid-plugsxyadd, 0])
	cube([10*grid*xpins+18.2*grid+2*plugsxyadd, 10*grid*ypins+2*plugsxyadd, plugsz]);
	
	translate([(xpins-1)*5*grid, -5*grid, plugsz/2])
	cube([4+2*plugsxyadd, 2+2*plugsxyadd, plugsz], center=true);

	translate([(xpins-1)*5*grid, -5*grid, plugsz/2+7])
	cube([10*grid*xpins+2*plugsxyadd, 2+2*plugsxyadd, plugsz-7], center=true);
}

//Berg/Dupont pin header
module dupont(xpins, ypins)
{
	//outline
	translate([-5*grid-plugsxyadd, -5*grid-plugsxyadd, 0])
	cube([10*grid*xpins+2*plugsxyadd, 10*grid*ypins+2*plugsxyadd, plugsz]);
	
	if (showpcb)
	{
		//pins
		for(ix=[0:1:xpins-1])
			for(iy=[0:1:ypins-1])
				translate([10*grid*ix, 10*grid*iy, -3])
				%pin(0.6, 11);

		//horizontal plate
		color([0, 0, 0])
		translate([-5*grid, -5*grid, 0])
		%cube([10*grid*xpins, 10*grid*ypins, 2.5]);
	}
}

//P4 ATX 12 volt header
module atxpower()
{
	//main box
	translate([-plugsxyadd, -plugsxyadd, 0])
	cube([44*grid+2*plugsxyadd, 44*grid+2*plugsxyadd, plugsz]);
	
	//lock
	translate([12*grid-plugsxyadd, 0, 0])
	cube([20*grid+2*plugsxyadd, 60*grid+plugsxyadd, plugsz]);
	
	if (showpcb)
	{
		//pins
		translate([((44-17)/2)*grid, ((44-22)/2)*grid])
		for(ix=[0,1])
			for(iy=[0,1])
				translate([17*grid*ix, 22*grid*iy, -3])
				%pin(1, 13);
		
	}
}

//Micro USB female slot
module microusb()
{
	plugx	= 32*grid;	
	plugy	= 12*grid;
	handlex	= 40*grid;
	handley	= 30*grid;
	xyadd	= 1*grid; 	//alternative plugsxyadd;
	
	//plug
	translate([-plugx/2-xyadd, -6, -xyadd])
	cube([plugx+2*xyadd, 20, plugy+2*xyadd]);
	
	//handle
	translate([-handlex/2-xyadd, 2, plugy/2-handley/2-xyadd])
	cube([handlex+2*xyadd, 20, handley+2*xyadd]);
	
	if (showpcb)
	{
		translate([-plugx/2, -6, 0])
		%cube([plugx, 5.5, plugy]);
	}
}

//MicroSD slot
module microsd()
{
	cardz	= 1;
	xyadd	= 1*grid;	//add to hole dimensions
	sdround	= 10;		//radius of horizontal slit
	finger	= 10;		//radius of vertical slit
	
	//card outline
	translate([-48/2*grid-xyadd, -13, -xyadd])
	cube([48*grid+2*xyadd, plugsz, cardz+2*xyadd]);

	//card entrance
//	translate([48/2*grid+xyadd, sdround, cardz/2])
//	rotate([0, 90, 180])
//	cylinder(r=sdround, h=48*grid+2*xyadd);

	translate([48/2*grid+xyadd, 0*sdround, cardz/2])
	rotate([0, 90, 180])
	rotate([0, 0, 205])
	cube([sdround, sdround, 48*grid+2*xyadd]);
	
	//finger access
	translate([0, finger, cardz/2-casez])
	cylinder(r=finger, h=2*casez);
	
	if (showpcb)
	{
		//card slot
		translate([-48/2*grid, -13, 0])
		%cube([48*grid, 16, cardz]);
	}
}

//Sketch for round ventilation hole with bars
module grill(gr, gh, bw, bs) //(holeradius, holeheight, barwidth, barspacing)
{
	difference()
	{
		cylinder(r=gr, h=gh);
		
		translate([0, -gr, 0])
		for(i=[-gr-bw:bw+bs:gr])
			translate([i, 0, 0])
			cube([bw, 2*gr, gh]);
	}

}

//PCB hull (inverted outline and mountings)
module pboard()
{
	difference()
	{
		cube([boardx, boardy, boardh]);

		//mounting
		translate([(boardx-mountholesx)/2, (boardy-mountholesy)/2, 0])
		for(ix=[0,1])
		{
			for(iy=[0,1])
			{
				translate([mountholesx*ix, mountholesy*iy, 0])
				{
					//Screw lid support
					
					//PCB lid support
					translate([0, 0, boardlift+boardz+plugsz/2])
					cube([boardliftd, boardliftd, plugsz], center=true);

					//PCB bottom support
					translate([0, 0, boardlift/2])
					cube([boardliftd, boardliftd, boardlift], center=true);
				}
			}
		}
		

		//Air duct walls (and additional lid support)
		translate([55.5, 34.5, boardlift+boardz])
		cube([38.5, 2, plugsz]);
		
		translate([57.5, 36.5, boardlift+boardz])
		rotate([0, 0, 180])
		cube([2, 28.5, plugsz]);
		
		translate([8, 8, boardlift+boardz])
		cube([49.5, 2, plugsz]);
		
		translate([8, 10, boardlift+boardz])
		rotate([0, 0, 235])
		cube([4, 2, plugsz]);
		
		
		//PCB rear side support
		translate([boardx/2, boardy/2, 0])
		for(ix=[-1,1])
		{
			for(iy=[-1,1])
			{
				translate([16*ix, 16*iy, 0])
				{
					translate([0, 0, boardlift/2])
					cylinder(r=boardliftd/2, h=boardlift, center=true);
				}
			}
		}
	}
}


// RENDER
module case()
{
	//uncomment to insert and view split-plane:
	//%translate([casex/2, casey/2, splitz]) cube([casex+1, casey+1, 0.01], center=true);
		
	difference()
	{
		//case body
		if (rendertype != 0)
		{
			cube([casex, casey, casez]);
		} else
		{
			cube([0.1, 0.1, 0.1]);
		}

		translate([casewall+boardxyadd, casewall+boardxyadd, casewall])
		union()
		{
			//total outline
			pboard();

			translate([0, 0, boardlift])
			{
				//PCB
				translate([-boardxyadd, -boardxyadd, 0])
				cube([boardx+2*boardxyadd, boardy+2*boardxyadd, boardz]);
				
				if (showpcb) 
				%cube([boardx, boardy, boardz]);

				//components
				translate([0, 0, boardz])
				{
					union()
					{
						//Micro-USB
						translate([49*grid, -5*grid, 0])
						rotate([0, 0, 180])
						microusb();

						//X-stop
						translate([95*grid, 13*grid, 0])
						rotate([0, 0, 180])
						molex(3);

						//Y-stop
						translate([127*grid, 13*grid, 0])
						rotate([0, 0, 180])
						molex(3);

						//Z-stop
						translate([159*grid, 13*grid, 0])
						rotate([0, 0, 180])
						molex(3);

						//E-stop
						translate([191*grid, 13*grid, 0])
						rotate([0, 0, 180])
						molex(3);

						//EXP1
						translate([264*grid, 19*grid, 0])
						rotate([0, 0, 180])
						dupont(7,2);

						//EXP2
						translate([302*grid, 129*grid, 0])
						rotate([0, 0, 180])
						IDC(7,2);
						
						//HWB jumper
						translate([212.4*grid, 123.2*grid, 0])
						rotate([0, 0, 135])
						dupont(2,1);
						
						//cutout for X1 (next to CPU)
						translate([215*grid, 50*grid, 0])
						//rotate([0, 0, 135])
						cube([4, 4, 2]);
						
						//cutout for R13 (next to HWB jumper)
						translate([215*grid, 120*grid, 0])
						cube([3, 4, 1]);
						
						//ICSP
						translate([281*grid, 9*grid, 0])
						dupont(3,2);
						
						//MicroSD slot hole
						translate([340*grid, -1, 0])
						rotate([0, 0, 180])
						microsd();
						
						//Reset pinhole
						translate([380*grid, 48*grid, 0])
						cylinder(r=2, h=plugsz);
						
						//cutout for reset switch solder pads
						translate([363*grid, 24*grid, 0])
						cube([7.85, 2, 1]);
						
						//Bed sensor Molex KK type
						translate([384*grid, 88*grid, 0])
						rotate([0, 0, 270])
						molex(2);						//dupont()2,1);
						
						//Tip sensor Molex KK type
						translate([384*grid, 108*grid, 0])
						rotate([0, 0, 270])
						molex(2);						//dupont()2,1);
				
						//Fan power berg type
						translate([384*grid, 156*grid, 0])
						rotate([0, 0, 270])
						molex(2);						//dupont()2,1);

						//E, Z, Y & X-motor
						translate([70*grid, 227*grid, 0])
						for(i=[0:1:3])
						{
							translate([i*80*grid, 0, 0])
							{
								molex(4);

								//current-adjust hole
							//	translate([51*grid, -38*grid, 0])
							//	cylinder(r=2, h=plugsz);
							}
						}
						
						//X-motor capacitor
						translate([40*grid, 225*grid, 0])
						cylinder(r=3.5, h=8, center=false);
						
						//P4 ATX power
						translate([0, 197*grid, 0])
						rotate([0, 0, -90])
						atxpower();

						//Tip power
						translate([12*grid, 82*grid, 0])
						rotate([0, 0, 90])
						molex(4);

						//Bed power
						translate([12*grid, 39.5*grid, 0])
						rotate([0, 0, 90])
						molex(4);

						//Fan
						translate([36.5, 32, 0])
						{
							cylinder(r=37/2, h=plugsz);
							//grill(37/2, plugsz, 2, 7.75);
							
							//Fan mount
							for(ix=[-1,1])
							{
								for(iy=[-1,1])
								{
									translate([16*ix, 16*iy, 0])
									cylinder(r=3/2, h=plugsz);
								}
							}
						}

						//ventilation duct exhaust
						translate([boardx-1, boardy-18, -0.1])
						rotate([90, 0, 120])
						cube([10, 10, casewall*5]);
						translate([boardx-1, boardy-18, -0.1])
						rotate([90, 0, 90])
						cube([10, 10, casewall*5]);
						//grill(5, casewall+2, 1.2, 2.5);
						
						//case+PCB screws
						translate([(boardx-mountholesx)/2, (boardy-mountholesy)/2, -casewall-boardlift-boardz])
						for(ix=[0,1])
						{
							for(iy=[0,1])
							{
								translate([mountholesx*ix, mountholesy*iy, 0])
								{
									//hexnut
									translate([0, 0, -1])
									cylinder(r=6.6/2, h=hexrecess+1, $fn=6);
									
									//screw axis
									translate([0, 0, hexrecess+screwlead/2])
									cylinder(r=mountholesd/2, h=screwlead-2*overhanghold, center=true);
									
									//screw head
									translate([0, 0, casez-screwrecess])
									cylinder(r=6.7/2, h=screwrecess+1);
								}
							}
						}
					}
				}
			}
		}
		
		//strips mount holes
		translate([casex/2, casey/2, 0])
		for(ix=[-1, 1])
		{
			for(iy=[-1, 1])
			{
				translate([ix*(casex/2-30), iy*(casey/2)-iy*5-0.5, -1])
				rotate([-iy*40, 0, 0])
				cube([4, 1.5, 10]);
			}
		}
	}
}

module casetop()
{
	rotate([0, 180, 180])
	translate([0, -casey, -casez])
	difference()
	{
		case();
		
		translate([-1, -1, -1])
		cube([casex+2, casey+2, splitz+1]);
	}
}

module casebottom()
{
	difference()
	{
		case();
		
		translate([-1, -1, splitz])
		cube([casex+2, casey+2, casez-splitz+1]);
	}
}

if (rendertype == 0) assign(showpcb=true) case();
if (rendertype == 1) casebottom();
if (rendertype == 2) casetop();
if (rendertype == 3) assign(showpcb=true) case();
