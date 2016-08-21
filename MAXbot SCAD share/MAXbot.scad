/*
The MAXbot
Parametric Wallace/printrBot derivate/upgrade
Written with OpenSCAD by Martin Axelsen 2012-2013
kharar@gmail.com  |  tinyurl.com/maxbot
*/

use<extruders.scad>;
// use<bowden.scad>

/***********************************************************\
RENDERPART selector:                                        *
0	= Show all parts assembled                              *
1	= X motor mount                                         *
2	= X carriage                                            *
3	= X belt end                                            *
4	= X carriage Belt clamp (with optional cooler mount)    *
5	= J-head adapter                                        *
6	= Extruder                                              *
7	= Nozzle cooler (under construction)                    *
8	= X cable guide                                         *
9	= Z endstop holder                                      *
-1	= Show vitamins only                                    *
\***********************************************************/
renderPart			= 0;			// part selection


/***********************************************************\
EXTRUDERSELECT selector:                                    *
0	= Direct extruder                                       *
1	= Single Bowden                                         *
2	= Double Bowden                                         *
3	= Triple Bowden                                         *
\***********************************************************/
extruderSelect		= 0;			// extruder selection


// CONSTANTS
$fn=50;
pi					= 3.14159265;	// PI

coolerAddon			= true; 		// specifies if part 4 includes the cooler mounting (experimental)

bearingHeight		= 8;			// belt bearing height (608ZZ=8)
bearingDiameter		= 22;			// belt bearing diameter (608ZZ=22)

xBeltToothSize		= 2.5;			// belt tooth interval (T2.5=2.5 | T5=5)
xBeltToothDepth		= 0.7;			// belt tooth thickness (T2.5=0.7 | T5=1)
xBeltDepth			= 0.9;			// belt additional thickness on smooth side of reinforcement (T2.5=0.9 | T5=0.5)
xBeltSide			= 6;			// belt width (T2.5=6 | T5=5)
xBeltIdlerRodHole	= 8;			// belt bearing rod hole diameter (608ZZ -> M8=8)
xBeltIdlerRodWall	= 7;			// belt bearing rod hole wall thickness

uSwitchLength		= 20;			// microswitch length (along longest side)
uSwitchThickness	= 6.5;			// microswitch thickness (along smallest side and mounting holes)
uSwitchDepth		= 12;			// microswitch depth (measured from rear to front with contact fully pressed)
uSwitchHoleAX		= 9;			// microswitch mounting hole A X-coordinate
uSwitchHoleAY		= 5.5;			// microswitch mounting hole A Y-coordinate
uSwitchHoleBX		= 9;			// microswitch mounting hole B X-coordinate
uSwitchHoleBY		= 15;			// microswitch mounting hole B Y-coordinate
uSwitchMountHole	= 20;			// X-end microswitch mounting hole depth
uSwitchMountHoleDia	= 3.2;			// microswitch mounting holes to parts
uSwitchHoleDia		= 2.25;			// microswitch holes to render
uSwitchPlateOffset	= 2;			// microswitch touching plate offset (X-carriage homing position)

xPulleyTooth		= 16;			// pulley tooth count (to calculate pulley diameter)
xPulleyToothHeight	= 7;			// pulley tooth area length (actual span than belt can reside on)
xPulleyCutout		= 10;			// pulley clearance radius
xPulleyBaseHeight	= 8 +1;			// pulley base height (the part where the set screw is) (+1 for clearance)

xMotorDisplaceY		= 1.275;		//*motorrod clearance (must be kept high enough to avoid motor mount screws, and low enough to avoid motor-rod to intersecting X-rod 2) (1.275@8mmxrod | -1@10mmxrod)
xMotorDisplaceZ		= 0;			// motor base vs X-rod 2 clearance

motorMountWall		= 4;			// motor mount screw wall thickness (valid for part 1)
motorMount			= 3+0.2;		// motor mount screw hole diameter (NEMA17=3)
motorMountDist		= 31;			// motor mount screw hole distance (NEMA17=31)
motorWidth			= 42.3;			// size of motor measured on x and y-axis (NEMA17=42.3)
motorHeight			= 47;			// size of motor measured on z-axis (NEMA17=47)
motorCutoutD		= 22 +1;		// motor center ring diameter (NEMA17=22) (+1 for clearance)
motorCutoutH		= 2;			// motor center ring height (NEMA17=2)
motorRod			= 5 +1;			// motor axis diameter (NEMA17=5) (+1 for clearance)
motorRodLength		= 22.5;			// motor axis length (NEMA17=22.5)

xBeltWall			= 4;			// thickness of clamp/belt mounts
xCarriageBeltMount	= 3+0.2;		// clamp screw hole diameter
xCarriageLift		= 1;			// x-carriage base plate height (must be>0 to avoid collision with Z-rod walls on either side)
xCarriageDefaultZ	= 4;			// x-carriage base thickness
directExtruderWidth	= (48+2*3);	// minimum distance between Z-rod carvings (48=mounting screw interval distance, 2=screw count, 3=screw diameter)
xCarExtGroove		= 0;			// extruder cut-out depth from x-carriage base thickness (xCarriageZ)
xCenterHole			= 22;			// x-carriage base plate hot-end hole diameter
xLmWall				= 4;			// x-carriage linear bearing support wall thickness (determines flexibility of snap-fit/quick-release)
xLmSnap				= 13;			// x-carriage linear bearing support bottom cut-off amount (for easy snap-fit/quick-release functionality) (works with 15)

xRodDist			= 65;			// distance between center of smooth X-rods (40mm fan compatible>=65)(Prusa semi-compatible=50)
xRodHole			= 8;			//*rod diameter (8 or 10)
xRodDepth			= 26;			// X-rod hole depth into X-ends (for direct printrBot compatibility set around 26)
xRodLength			= 320;			// length of X-rods (minimum 116 approx)
xRodEnds			= true;			// [boolean]
xRodFixation		= true;			// [boolean]
xRodFixScrew		= 3;			// hole diameter for X-rod fixation
xRodFixLength		= 2;			// hole expansion for X-rod fixation
xRodFixDist			= 6;			// hole distance from either end of x-rod hole

xLmLength			= 24;			//*linear bearing length (LM8UU=24 | LM10UU=29)
xLmDiameter			= 15+0.1;		//*linear bearing diameter (LM8UU=15 | LM10UU=19) (+0.1 for printer calibration)

zRodThreadedDia		= 8;			// threaded Z-(outer)rod diameter (M8=8)
zRodThreadedLen		= 250;			// threaded Z-(outer)rod length (250) use HiQ stainless or better
zRodSmoothLen		= 380;
zRodSmooth			= 10;			// smooth Z-(inner)rod diameter (usually same size as zRodThreadedDia)
zRodDist			= 29;			// distance between the center of threaded and smooth Z-rods (PrintrBot/Wallace=28)
zRodOffset			= 0;			// Z-rods position relative to x-ends body (normally leave at 0)
zNutHole			= 14.5+0.65;	// Z axis hex-nut outer diagonal
zNutHeight			= 6.2;			// Z axis hex-nut height
zNutWall			= 5;			// support thickness around nut
zLmLength			= 24;			// linear bearing length (LM8UU=24)
zLmDiameter			= 15.1;			// linear bearing diameter (LM8UU=15)

zLmWall				= 4;			// Z-axis linear bearing support wall thickness
zLmSnap				= 6;			// x-carriage linear bearing support bottom cut-off amount (for easy snap-fit/quick-release functionality use any number from 6 and up)
zLmSupportY			= 9;			// support width for the Z-LM tube
zLmSfccAngle		= 20;			// snap-fit corner-cut angle
zLmSfccDepth		= 7;			// snap-fit corner-cut depth

guideWidth			= 16;			// X cable guide hole width
guideHeight			= 16;			// X cable guide height
guideBracketH		= 3;			// X cable guide screw plate height
guideBridgeOffset	= 10;			// X cable guide bridge position offset

zEndstopPosX		= 4;			// Z endstop length placement
zEndstopPosZ		= 40;			// Z endstop height placement
zEndstopWall		= 3;			// Z endstop wall thicknesses

zBedOffset			= 120;			// Lowest position of X bridge on Z axis, only used for displaying
zPosDisp			= 0;			// Z height of X-bridge, only used for displaying


// VARIABLES
coolerMountOffset	= 44; //cooler_off();
coolerMountDist		= 13; //cooler_dist();
xCarriageUseLength	= (extruderSelect == 0) ? directExtruderWidth : 30*extruderSelect;		// minimum distance between Z-rod carvings
xCarriageZ			= (extruderSelect == 0) ? xCarriageDefaultZ : 2*xCarriageDefaultZ;
guideThickness		= motorMount;											// X cable guide element thickness
xPulleyRadius		= (xPulleyTooth*xBeltToothSize/pi)/2;					// x-belt pulley radius
xCarriagePlatform	= xLmDiameter/2+xLmWall+xCarriageLift+xCarriageZ;		// x-carriage plateau Z-distance from origin
xBeltHeight			= xRodHole/2+xPulleyBaseHeight+xBeltSide/2+1;//xLmDiameter/2+xLmWall+xBeltSide/2+1+10;				//*x-belt Z-distance from origin
xPulleyBeltHeight	= xBeltHeight-xPulleyBaseHeight;						// x-belt to base of pulley distance
xBeltMountZdisplace	= xBeltSide+xCarriageBeltMount;							// clamp screw holes Z-distance from belt height on x-carriage
xBeltMountXDist		= 10;													// clamp screw holes X-distance
xBeltIdlerDiameter	= bearingDiameter;  									//xBeltToothCount*xBeltToothSize/pi;		// belt idler diameter
xBody				= xRodDepth; 											// x-size of x-ends
yBody				= xRodDist+2*xRodHole;									// y-size of x-ends
zBody				= 2*xRodHole;											// z-size of x-ends
zRodHole			= zRodThreadedDia + 3;									// holes size for the threaded Z-rods
xMotorDisplaceX		= motorWidth/2-xBody/2;									// motor position (clearance for X-carriage)
renderPartDistance	= xRodLength/2-xRodDepth+xBody/2;						// distance between origins (for renderPart=0 only)
zLmOffset			= -(zLmLength*2-zBody)/2;								// smooth z-rod LM bearing support tube displacement
zLmSupportX			= zLmDiameter/2+zLmWall;								// support for the Z-LM tube
xCarriageMountY		= yBody/2+xMotorDisplaceY-xPulleyRadius-xBeltDepth;	// x-carriage belt mount y-distance from origin
xCarriageLmSpace	= 2;													// x-carriage LM center spacer
xCarriageLmEnd		= 2;													// x-carriage LM end limiter
xCarriageLength		= max(zLmLength*2+xCarriageLmSpace*2+xCarriageLmEnd, xCarriageUseLength+zRodSmooth+2);		// x-carriage length on x-axis
xPulleyDisplaceZ	= xBeltHeight-xPulleyBaseHeight-xPulleyToothHeight/2-xRodHole/2;	//2.5;			// pulley vs X-rod 2 clearance (pulley cut-out plateau)
zPos				= zPosDisp+zBedOffset;			// Z height of X-bridge, only used for displaying
uSwitchOffsetY		= zLmDiameter/2;										// x-microswitch Y-distance from origin



// TEXT OUTPUT
echo();
if (xRodLength <= zLmLength*2+xRodDepth*2)	echo("ATTENTION: xRodLength too small or xRodDepth too large");
echo("Mechanical summary:");
echo();
//echo("Belt outside around pulley diameter:                               ", round((xPulleyRadius*2+xBeltDepth*2)*100)/100);
//echo("Caliper measurement belt around idler:                           ", round((xBeltIdlerDiameter+xBeltDepth*2)*100)/100);
//echo("Length of X-carriage on X-rods:                                      ", xCarriageLength);
//echo("Distance between X-ends (space between axis ends):   ", xRodLength-xRodDepth*2);
echo("Maximum movement on X axis (free space on rods):       ", xRodLength-xRodDepth*2-xCarriageLength);
echo("Amount of X-rod reserved to X-ends and X-carriage:     ", xRodDepth*2+xCarriageLength);
echo("Space between smooth Z-rods:                                       ", (renderPartDistance-(xBody/2+zRodOffset))*2-zRodSmooth);
echo("Approx. length of X-axis timing belt (without margin):    ", round(2*(xRodLength-xRodDepth*2+xBody+xMotorDisplaceX)+(xPulleyRadius+bearingDiameter/2)*pi));
//echo("X-idler bearing distance from mounting hole surface:     ", round((xBeltHeight-zBody/2-bearingHeight/2)*100)/100);
//echo("X-belt height from base pulley cut-out                            ", round(xPulleyBeltHeight*100)/100);
echo("Distance between carriage and LM undersides:              ", (xCarriagePlatform-xCarriageZ)+zLmDiameter/2);
echo();



/**************** MODULES **************************/



module beltMountHoles(n)
{
	//Belt mount hole 1:
	translate([-xBeltMountXDist/2, 1, xBeltHeight+xBeltMountZdisplace/2])
	rotate ([90,0,0])
	cylinder(h = xBeltWall*(n+1)+2, r=xCarriageBeltMount/2, center = false);

	//Belt mount hole 2:
	translate([xBeltMountXDist/2, 1, xBeltHeight+xBeltMountZdisplace/2])
	rotate ([90,0,0])
	cylinder (h = xBeltWall*(n+1)+2, r=xCarriageBeltMount/2, center = false);
}


module uSwitch(part)
{
	if (part == 0)
	{
		difference()
		{
			cube([uSwitchDepth, uSwitchLength,uSwitchThickness], center = false);

			translate([uSwitchHoleAX, uSwitchHoleAY, uSwitchThickness+1])
			rotate([0, 180, 0])
			cylinder(h=uSwitchThickness+2, r=uSwitchHoleDia/2, center=false);

			translate([uSwitchHoleBX, uSwitchHoleBY, uSwitchThickness+1])
			rotate([0, 180, 0])
			cylinder(h=uSwitchThickness+2, r=uSwitchHoleDia/2, center=false);
		}
	}

	if (part != 0)
	{
		translate([uSwitchHoleAX, uSwitchHoleAY, uSwitchThickness/2])
		rotate([0, 180, 0])
		cylinder(h=uSwitchThickness+uSwitchMountHole+100, r=uSwitchMountHoleDia/2, center=true);

		translate([uSwitchHoleBX, uSwitchHoleBY, uSwitchThickness/2])
		rotate([0, 180, 0])
		cylinder(h=uSwitchThickness+uSwitchMountHole+100, r=uSwitchMountHoleDia/2, center=true);

		translate([uSwitchHoleBX, uSwitchHoleBY, -zBody])
		rotate([90, 0, 0])
		{
			translate([-uSwitchHoleDia/2, -40, 0])
			cube([uSwitchHoleDia, 40, uSwitchHoleBY-uSwitchHoleAY]);
		}
	}
}


module motor(part)
{
	tol = sign(part);

	//X-motor rod:
	translate([0, 0, -xRodHole/2])
	if (part == 0){
		cylinder(h = motorRodLength+4, r = motorRod/2, center = false);
	}else{
		cylinder(h = motorRodLength+4, r = motorRod/2+0.5, center = false);
	}

	//X-motor ring:
	rotate([180,0,0])
	cylinder(h = motorCutoutH+1, r = motorCutoutD/2, center = false);

	//X-motor base:
	translate([-motorWidth/2-tol/2, motorWidth/2+tol/2, -motorCutoutH])
	rotate([180,0,0])
	cube(size = [motorWidth+tol, motorWidth+tol, motorHeight], center = false);

	//X-motor mountings
	for (ix = [-1, 1])
	for (iy = [-1, 1])
	translate([ix*motorMountDist/2, iy*motorMountDist/2, -motorCutoutH-1])
	cylinder(h = 2*zBody+1, r = motorMount/2, center = false);
}


module pulley(part)
{
	difference()
	{
		union()
		{
			//X-motor pulley clearance cutout:
			if (part == 1)
			cylinder(h = 9, r = xPulleyCutout, center = false);

			//X-motor pulley:
			if (part == 0)
			{
				// top shim
				translate([0,0,xPulleyBaseHeight+xPulleyToothHeight])
				cylinder(h = 1, r = xPulleyRadius+2, center = true);
				// toothed part
				translate([0,0,xPulleyBaseHeight+xPulleyToothHeight/2])
				cylinder(h = xPulleyToothHeight, r = xPulleyRadius, center = true, $fn=xPulleyTooth);
				// base part
				translate([0,0,xPulleyBaseHeight/2])
				cylinder(h = xPulleyBaseHeight, r = xPulleyRadius+2, center = true);
			}
		}

		cylinder(h=20, r=motorRod/2);
	}
}


module xBearingIdler(part)
{
	translate([0, yBody/2+xMotorDisplaceY+(xBeltIdlerDiameter/2-xPulleyRadius)+xBeltToothDepth, zBody/3])
	cylinder(h = 3*zBody+2, r = xBeltIdlerRodHole/2, center = true);

	if (part == 0 || part == 3) //or
	{
		translate([0, yBody/2+xMotorDisplaceY+(xBeltIdlerDiameter/2-xPulleyRadius)+xBeltToothDepth, xBeltHeight])
		cylinder(h = bearingHeight, r = xBeltIdlerDiameter/2, center = true);
	}
}


module xLM()
{
	for (ix = [-1, 1])
	for (iy = [-1, 1])
	translate([ix*xCarriageLength/2-ix*xLmLength/2-ix*xCarriageLmEnd, iy*xRodDist/2, 0])
	rotate([0, 90, 0])

	difference(){
		cylinder(h=xLmLength, r=xLmDiameter/2, center=true);

		cylinder(h=xLmLength+1, r=xRodHole/2, center=true);
	}
}


module zLM(part)
{
	if (part == 0)
	for (i = [-1, 1])
	translate([0, 0, i*zLmLength/2])
	difference(){
		cylinder(h=zLmLength, r=zLmDiameter/2, center=true);

		cylinder(h=zLmLength+1, r=zRodSmooth/2, center=true);
	}
	else
	{
		cylinder(h=2*zLmLength+1, r=zLmDiameter/2, center=true);
	}
}

module airDeflector()
{
	translate([-coolerWidth, xRodDist/2, -(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ])
	rotate([0, 0, 270])
	{
		//wall
		difference()
		{
			cube([coolerLength, coolerWall, coolerHeight]);

			translate([coolerLength, -1, 0])
			rotate([0, -coolerAngle, 0])
			cube([coolerHeight, coolerWall+2, coolerHeight*(1+tan(coolerAngle))]);
		}

		//rounded edge
		translate([coolerLength, coolerRadius+coolerWall, 0])
		difference()
		{
			rotate([0, -coolerAngle, 0])
			intersection()
			{
				difference()
				{
					cylinder(r=coolerRadius+coolerWall, h=2*coolerTan, center=true);

					cylinder(r=coolerRadius, h=2*coolerTan+1, center=true);
				}

				translate([0, -coolerRadius*2, -coolerTan/2-1])
				cube([coolerRadius*2, coolerRadius*2, coolerTan]);
			}

			translate([-coolerLength-coolerTan, -(coolerRadius+coolerWall+1), coolerHeight])
			cube([coolerLength*2+coolerTan*2, 2*(coolerRadius+coolerWall+1), 2*coolerHeight]);

			translate([coolerTan, -(coolerRadius+coolerWall+1), 0])
			rotate([0, 180, 0])
			cube([coolerTan, 2*(coolerRadius+coolerWall), coolerHeight*2]);

		}
	}
}



/******************************************************************************/
/************** MAIN MODULES **************************************************/
/******************************************************************************/

//-1
module vitamins()		// x/y/z-rods, belt, Z-motors etc.
{
	color("Silver"){
		for (i = [-1, 1])
		{
			// front smooth X-rod
			translate([0, i*xRodDist/2, 0])
			rotate ([0,90,0])
			cylinder(h = xRodLength, r=xRodHole/2, center = true);

			// outer threaded Z-rods
			translate([-i*(xBody/2+zRodOffset)+i*zRodDist+i*renderPartDistance, 0, motorHeight+motorRodLength+zRodThreadedLen/2-zPos])
			cylinder(h = zRodThreadedLen, r=zRodThreadedDia/2, center = true);

			// inner smooth Z-rods
			translate([-i*(xBody/2+zRodOffset)+i*renderPartDistance, 0, zRodSmoothLen/2-zPos])
			cylinder(h = zRodSmoothLen, r=zRodSmooth/2, center = true);

			//Z-Couplers
			translate([-i*(zRodDist+renderPartDistance-(xBody/2+zRodOffset)), 0, motorHeight+motorRodLength-zPos])
			cylinder(h=25, r=20/2, center=true);

			//Z-motors
			translate([-i*(zRodDist+renderPartDistance-(xBody/2+zRodOffset)), 0, motorHeight-zPos])
			motor(0);

			// Z-rod LM's
			translate([i*(renderPartDistance-(xBody/2+zRodOffset)), 0, zLmOffset])
			zLM(0);
		}

		// X-endstop microswitch
		translate([-renderPartDistance+xBody/2-uSwitchPlateOffset, -uSwitchOffsetY, zBody/2])
		rotate([0, 0, 180])
		uSwitch(0);

		// Z-endstop microswitch
		translate([-(zRodDist+renderPartDistance-(xBody/2+zRodOffset))+uSwitchLength/2+zEndstopPosX, -uSwitchThickness-motorWidth/2, uSwitchDepth+zEndstopPosZ+motorHeight-motorCutoutH-zPos])
		rotate([270, 90, 0])
		uSwitch(0);

		//X-motor
		translate([-renderPartDistance-xMotorDisplaceX, -(-yBody/2-xMotorDisplaceY), -xRodHole/2-xMotorDisplaceZ])
		motor(0);

		//X-Pulley
		translate([-renderPartDistance-xMotorDisplaceX, -(-yBody/2-xMotorDisplaceY), xRodHole/2+xPulleyDisplaceZ])
		pulley(0);

		//Belt idler bearing and rod
		translate([renderPartDistance, 0, 0])
		xBearingIdler(0);

		//X-rod LM's
		xLM();

		//Hotend:
		translate([0, 0, xCarriagePlatform-xCarExtGroove])
		rotate([0, 0, 270])
		jHeadShow(false, 0, 0);
	}

	//Threaded z-rod brass hex nut:
	color("DarkOrange")
	for (i = [-1, 1])
	translate([i*(renderPartDistance+zRodDist-(xBody/2+zRodOffset)), 0, -zBody/2+zNutHeight/2])
	cylinder(h = zNutHeight, r=zNutHole/2, center = true, $fn=6);

	//x-belt
	color("GhostWhite")
	translate([-xRodLength/2+xRodDepth-xBody/2-xMotorDisplaceX, yBody/2+xMotorDisplaceY-xPulleyRadius-xBeltDepth, xBeltHeight-xBeltSide/2])
	cube([xRodLength-xRodDepth*2+xBody+xMotorDisplaceX, xBeltToothSize/2+xBeltDepth, xBeltSide], center = false);

	//Braided sleeve
	color("DimGray")
	translate([-xCarriageLength/2+3+1, yBody/2+xMotorDisplaceY-motorMountDist/2-guideWidth/2, xCarriageLift+xLmWall+xLmDiameter/2+xCarriageZ/2])
	{
		rotate([0, 0, 180])
		//	cylinder(h=xRodLength/2, r=4);
		translate([0, -4, -4])
		cube([xRodLength/2, 8, 8]);

		translate([-xRodLength/2, 0, -zPos/2])
		rotate([90, 0, 0])
		difference()
		{
			cylinder(h=2*4, r=zPos/2+4, center=true);

			cylinder(h=2*4+1, r=zPos/2-4, center=true);
			translate([zPos/2, 0, 0])
			cube([zPos, 2*zPos, 10], center=true);
		}
	}
}


//1 & 3
module xBarEnds(part)
{
	difference()
	{
		union()
		{
			//Body:
			cube(size = [xBody, yBody-xRodHole*2, zBody], center = true);

			if (part == 1)
			{
				// motor support
				translate([xMotorDisplaceX+motorMountDist/2, -yBody/2-xMotorDisplaceY+motorMountDist/2, 0])
				cylinder(h=zBody, r=motorMount/2+motorMountWall, center=true);

				translate([xBody/2+((xMotorDisplaceX+motorMountDist/2)-xBody/2)/2, -yBody/2-xMotorDisplaceY+motorMountDist/2, 0])
				cube([(xMotorDisplaceX+motorMountDist/2)-xBody/2, motorMount+motorMountWall*2, zBody], center=true);

				translate([xBody/2+(zRodDist-(xBody/2+zRodOffset)-xBody/2)/2, ((-yBody/2-xMotorDisplaceY+motorMountDist/2-motorMount/2+motorMountWall/2)-(zNutHole/2))/2, 0]) //skal rettes!
				cube([zRodDist-(xBody/2+zRodOffset)-xBody/2, (-zNutHole/2-zNutWall)-(-yBody/2-xMotorDisplaceY+motorMountDist/2+motorMount/2+motorMountWall)+1, zBody], center=true);

			}

			if (part == 3)
			{
				//X-belt mount:
				translate([0, yBody/2+xMotorDisplaceY+(xBeltIdlerDiameter/2-xPulleyRadius)+xBeltToothDepth, 0])
				cylinder(h = zBody, r = xBeltIdlerRodHole/2+xBeltIdlerRodWall, center = true);

				//X-belt mount support:
				translate([-xBeltIdlerRodHole/2-xBeltIdlerRodWall, yBody/2, -zBody/2])
				cube(size = [xBeltIdlerRodHole+xBeltIdlerRodWall*2, xMotorDisplaceY+(xBeltIdlerDiameter/2-xPulleyRadius)+xBeltToothDepth, zBody], center = false);
			}

			//LM z-rod mount tube:
			translate([-(xBody/2+zRodOffset), 0, zLmOffset])
			cylinder(h = zLmLength*2, r=zLmDiameter/2+zLmWall, center = true);

			//LM z-rod mount tube support:
			translate([-xBody/2, 0, 1-zBody/2])
			rotate([270, 0, 270])
			linear_extrude(height = zLmSupportX, center = false)
			polygon(
				points=	[	[-zLmDiameter/2-zLmWall-zLmSupportY, 0],
							[-zLmDiameter/2-zLmWall, zLmLength+zBody/2+1],
							[zLmDiameter/2+zLmWall, zLmLength+zBody/2+1],
							[zLmDiameter/2+zLmWall+zLmSupportY, 0]
						],
				paths=	[	[0,1,2,3]
						]
			);

			//Threaded z-rod mount:
			translate([zRodDist-(xBody/2+zRodOffset), 0, 0])
			cylinder(h = zBody, r=zNutHole/2+zNutWall, center = true);

			translate([xBody/2+(zRodDist-(xBody/2+zRodOffset)-xBody/2)/2, 0, 0])
			cube([zRodDist-(xBody/2+zRodOffset)-xBody/2, zNutHole+zNutWall*2,zBody], center=true);

			//X-rod ends:
			if ((!xRodEnds) && (part==3)) {} else
			{
				//X-rod end 1:
				translate([xBody/2, -xRodDist/2, 0])
				cylinder(h=zBody, r=xRodHole, center=true);

				//X-rod end 2:
				translate([xBody/2, +xRodDist/2, 0])
				cylinder(h=zBody, r=xRodHole, center=true);
			}

			//X-rod mount 1:
			translate([0, -xRodDist/2, 0])
			cube([xBody, xRodHole*2, zBody], center = true);

			//X-rod mount 2:
			translate([0, xRodDist/2, 0])
			cube([xBody, xRodHole*2, zBody], center = true);
		}

		union()
		{
			if (part == 1)
			{
				translate([xMotorDisplaceX, -yBody/2-xMotorDisplaceY, -xRodHole/2-xMotorDisplaceZ])
				motor(part);

				translate([xMotorDisplaceX, -yBody/2-xMotorDisplaceY, xRodHole/2+xPulleyDisplaceZ])
				pulley(part);

				// X-endstop uSwitch mounting holes:
				translate([-xBody/2+uSwitchPlateOffset, uSwitchOffsetY, zBody/2])
				uSwitch(part);

				// Z-endstop rod hole:
				translate([zRodDist-xBody/2-zRodOffset-uSwitchLength/6-zEndstopPosX, uSwitchThickness/2+motorWidth/2, 0])
				union(){
					//hole for M3 screw with retention spring
					cylinder(h=40, r=1.6, center=true);

					//hex nut
					translate([0, 0, -zBody/2-1])
					cylinder(h=4, r=3.1, $fn=6);
				}
			}

			if (part == 3)
			{
				// X-bearing hole:
				xBearingIdler(part);
			}

			//LM z-rod hole:
			translate([-(xBody/2+zRodOffset), 0, zLmOffset])
			zLM(part);

			//z-rod round snap-fit:
			translate([-xBody/2-zRodOffset-zLmSnap-(2*zLmDiameter)/zLmSnap, 0, zLmOffset])
			cylinder(h = zLmLength*2+1, r=zLmSnap, center = true);

			//snap-fit corner-cut top
			translate([-xBody/2-zRodOffset-zLmSnap-(2*zLmDiameter)/zLmSnap, 0, zBody/2])
			rotate ([0, zLmSfccAngle, 0])
			cube([zLmSfccDepth, 2*zLmSupportX, 2*zLmLength], center=true);

			//snap-fit corner-cut bottom
			translate([-xBody/2-zRodOffset-zLmSnap-(2*zLmDiameter)/zLmSnap, 0, zBody/2-2*zLmLength])
			rotate ([0, 180-zLmSfccAngle, 0])
			cube([zLmSfccDepth, 2*zLmSupportX, 2*zLmLength], center=true);

			//Threaded z-rod hole:
			rotate ([0,0,90])
			translate([0, (xBody/2+zRodOffset)-zRodDist, 0])
			cylinder(h = zBody+1, r=zRodHole/2, center = true);

			//Threaded z-rod brass hex nut hole:
			translate([zRodDist-(xBody/2+zRodOffset), 0, -zBody/2+zNutHeight/2])
			cylinder(h = zNutHeight+1, r=zNutHole/2, center = true, $fn=6);

			//X-rod hole 1 + finish:
			rotate ([0,90,0])
			translate([0, -xRodDist/2, -xBody/2+xRodDepth/2-1])
			cylinder(h = xRodDepth+2, r=xRodHole/2, center = true);

			rotate ([0,90,0])
			translate([0, -xRodDist/2, -xBody/2+xRodDepth-0.001])
			cylinder(h = xRodHole/4, r1=xRodHole/2, r2=0, center = false);

			//X-rod hole 2 + finish:
			rotate ([0,90,0])
			translate([0, xRodDist/2, -xBody/2+xRodDepth/2-1])
			cylinder(h = xRodDepth+2, r=xRodHole/2, center = true);

			rotate ([0,90,0])
			translate([0, xRodDist/2, -xBody/2+xRodDepth-0.001])
			cylinder(h = xRodHole/4, r1=xRodHole/2, r2=0, center = false);

			// X-rod fixation slots
			if (xRodFixation)
			{
				for (iy=[1, -1])
				{
					for (ix=[1, -1])
					{
						if ((part == 1) && (iy==-1)) {} else
						translate([ix*(xRodDepth/2-xRodFixDist), iy*xRodDist/2, 0])
						hull()
						{
							translate([xRodFixLength/2, 0, 0])
							cylinder(r=xRodFixScrew/2, h=zBody+1, center=true);
							translate([-xRodFixLength/2, 0, 0])
							cylinder(r=xRodFixScrew/2, h=zBody+1, center=true);
						}
					}
				}
			}
		}
	}
}


//2
module xCarriage()
{
	difference()
	{
		union()
		{
			difference()
			{
				//Base:
				translate([0, 0, xCarriageLift+xLmWall+xLmDiameter/2+xCarriageZ/2])
				cube(size = [xCarriageLength, xRodDist+xCarriageDefaultZ ,xCarriageZ], center = true);

				//Hotend cut-out:
				if (extruderSelect == 0)
				{
					translate([0, 0, xCarriagePlatform-xCarExtGroove])
					rotate([0, 0, 270])
					kJ(false);
				}

				if (extruderSelect == 1)
				{
					translate([0, 0, xCarriagePlatform+5])
					rotate([0, 0, -90])
					bowden_hotend_main(mockup_clr=0.5);

/*				%	translate([0, 0, xCarriagePlatform+5])
					rotate([0, 0, -90])
					bowden_hotend_main();
*/				}

				if (extruderSelect == 2)
				{
					translate([0, 0, xCarriagePlatform])
					rotate([0, 0, -90])
					bowden_hotend_dual(mockup_clr=0.5, nutOffset=-xCarriageZ);
				}

/*				if (extruderSelect == 3)
				{
					translate([0, 0, xCarriagePlatform])
					rotate([0, 0, -90])
					bowden_hotend_triple(mockup_clr=0.5, nutOffset=-xCarriageZ);
				} */
			}

			//Base support 1:
			translate([0, -xRodDist/2, xCarriageLift/2+xLmWall+xLmDiameter/2])
			cube(size = [xCarriageLength, xCarriageDefaultZ ,xCarriageLift+1], center = true);

			//Base support 2:
			translate([0, xRodDist/2, xCarriageLift/2+xLmWall+xLmDiameter/2])
			cube(size = [xCarriageLength, xCarriageDefaultZ ,xCarriageLift+1], center = true);

			//X-rod mount 1:
			rotate ([0,90,0])
			translate([0, -xRodDist/2, 0])
			cylinder(h = xCarriageLength, r=xLmDiameter/2+xLmWall, center = true);

			//X-rod mount 2:
			rotate ([0,90,0])
			translate([0, +xRodDist/2, 0])
			cylinder(h = xCarriageLength, r=xLmDiameter/2+xLmWall, center = true);

			//X-belt mounting plate
			translate([0, xCarriageMountY, -0.01])
			beltMount(0);

			//uSwitch touch plate:
			hull()
			{
				translate([-xCarriageLength/2-uSwitchPlateOffset, -uSwitchOffsetY-(uSwitchLength-5), zBody/2+1])
				cube([1, uSwitchLength-10, uSwitchThickness], center=false);

				translate([-xCarriageLength/2, -uSwitchOffsetY-(uSwitchLength-5), xCarriageLift+xLmWall+xLmDiameter/2])
				cube([xCarriageLength/2-xCarriageUseLength/2, uSwitchLength-10, xCarriageZ], center=false);
			}
		}

		//Belt mount
		union()
		{
			//Plate holes
			translate([0, xCarriageMountY, 0])
			beltMountHoles(1);

			//hexnut cut-out:
			for (i=[-1,1])
			{
				translate([i*xBeltMountXDist/2, xCarriageMountY-xBeltWall*2/3-xCarriageBeltMount/2, xBeltHeight+xBeltMountZdisplace/2])
				rotate ([90,0,0])
				cylinder (h =xCarriageBeltMount , r=xCarriageBeltMount, center = true, $fn=6);
			}


			/*union()
			{
				//Hole 1 hexnut cut-out:
				translate([0, xCarriageMountY-xBeltWall*2/3-xCarriageBeltMount/2, xBeltHeight+xBeltMountZdisplace/2])
				rotate ([90,0,0])
				cylinder (h =xCarriageBeltMount , r=xCarriageBeltMount, center = true, $fn=6);

				//Hole 2 hexnut cut-out:
				translate([0, xCarriageMountY-xBeltWall*2/3-xCarriageBeltMount/2, xBeltHeight-xBeltMountZdisplace/2])
				rotate ([90,0,0])
				cylinder (h =xCarriageBeltMount , r=xCarriageBeltMount, center = true, $fn=6);

				//Hole 2 hexnut cut-out access space:
				translate([0, xCarriageMountY-xBeltWall*2/3-xCarriageBeltMount/2, xBeltHeight])
				#cube([xCarriageBeltMount*2,xCarriageBeltMount,xBeltMountZdisplace], center = true);
			}
			*/
		}

		//X-rod 1:
		rotate ([0,90,0])
		translate([0, -xRodDist/2, 0])
		cylinder(h = xCarriageLength+1, r=xLmDiameter/2-.5, center = true);

		//X-rod 2:
		rotate ([0,90,0])
		translate([0, xRodDist/2, 0])
		cylinder(h = xCarriageLength+1, r=xLmDiameter/2-.5, center = true);

		//X-rod LM's
		xLM();

		//Z-rod Base cut-out 1:
		translate([-xCarriageLength/2, 0, xCarriageLift+xLmWall+xLmDiameter/2+xCarriageZ/2])
		cylinder(h = xCarriageZ+1, r=zRodSmooth/2+1, center = true);

		//Z-rod Base cut-out 2:
		translate([xCarriageLength/2, 0, xCarriageLift+xLmWall+xLmDiameter/2+xCarriageZ/2])
		cylinder(h = xCarriageZ+1, r=zRodSmooth/2+1, center = true);

		//Cut-out for Wires and cable tie holes
		if (extruderSelect == 0)
		translate([-xCarriageLength/2, yBody/2+xMotorDisplaceY-motorMountDist/2-guideWidth/2, xCarriageLift+xLmWall+xLmDiameter/2+xCarriageZ/2])
		{
			translate([1, 0, 0])
			cylinder(h = xCarriageZ+1, r=3, center = true);

			for (i=[-1,1])
				translate([3, i*6, 0])
				cylinder(h = xCarriageZ+1, r=1.5, center = true, $fn=10);

		}

		//X-rod 1 round snap-fit:
		translate([0, -xRodDist/2, -xLmSnap])
		rotate([0, 90, 0])
		cylinder(h = xCarriageLength+1, r=xLmSnap, center = true);

		//X-rod 2 round snap-fit:
		translate([0, xRodDist/2, -xLmSnap])
		rotate([0, 90, 0])
		cylinder(h = xCarriageLength+1, r=xLmSnap, center = true);

/*		//fan mount
		translate([8, 0, xCarriagePlatform-xCarriageZ-0.1])
		rotate([180, 90, 0])
		fanMountDistFan();
*/
	}

	//experimental hotend fan duct
/*	translate([kJoffset()+2, 0, xCarriagePlatform-xCarriageZ-20])
	rotate([180, 90, 0])
	{
		fanMountDistPrimary();
		fanMountDistSecondary();
	}
*/
}


//4
module beltMount(n)		//use:	 n=0 for xCarriage		n=1 for Clamp
{
	rotate([((n == 0) || (n == 1) && coolerAddon) ? 0 : -90, 0, 0])
	difference()
	{
		union()
		{
			rotate([90, 0, 0])
			linear_extrude(height = xBeltWall, center = false)
			polygon(
				points=	[	[(1-n)*(-xCarriageLength/2)+n*-xCarriageBeltMount*3, xCarriagePlatform-(n)*(xCarriageZ+xCarriageLift)],
							[(1-n)*-xCarriageBeltMount*3+n*-xCarriageBeltMount*3, xBeltHeight+xBeltMountZdisplace/2+xCarriageBeltMount*1.5],
							[(1-n)*xCarriageBeltMount*3+n*xCarriageBeltMount*3, xBeltHeight+xBeltMountZdisplace/2+xCarriageBeltMount*1.5],
							[(1-n)*(xCarriageLength/2)+n*xCarriageBeltMount*3, xCarriagePlatform-(n)*(xCarriageZ+xCarriageLift)]
						],
				paths=	[	[0,1,2,3]
						]
			);

			if ((n == 1) && coolerAddon)
			{
				//cooler mounting
				difference()
				{
					union()
					{
						//translate([-3*xCarriageBeltMount, -1.5, xCarriagePlatform-(xCarriageZ+xCarriageLift)])
						//cube([6*xCarriageBeltMount, 9, 5]);

						//Primary triangular support
						translate([-1, -1.5, xCarriagePlatform-(xCarriageZ+xCarriageLift)])
						difference()
						{
							cube([2, 10, 14]);

							translate([-10, 0, 14])
							rotate([-45, 0, 0])
							cube([20, 20, 20]);
						}

						//Secondary triangular support
						translate([-9, -2, xCarriagePlatform-(xCarriageZ+xCarriageLift)])
						rotate([0, 0, 56])
						difference()
						{
							cube([2, 10, 14]);

							translate([-10, 0, 14])
							rotate([-45, 0, 0])
							cube([20, 20, 20]);
						}

						//cooler mount base plate
						translate([-J_X()-coolerMountDist, coolerMountOffset-(xCarriageMountY+xBeltWall)-10, xCarriagePlatform-(xCarriageZ+xCarriageLift)])
						hull()
						{
							translate([-3, 46-coolerMountOffset, 0])
							cube([coolerMountDist*2+6, coolerMountOffset-36, 5]);

							translate([0, 10, 0])
							cylinder(h=5, r=3);

							translate([coolerMountDist*2, 10, 0])
							cylinder(h=5, r=3);
						}
					}

					//cooler mounting holes
					translate([-J_X(), coolerMountOffset-(xCarriageMountY+xBeltWall)-4.5, xCarriagePlatform-(xCarriageZ+xCarriageLift)])
					{
						translate([-coolerMountDist, 4.5, -1])
						cylinder(h=5+2, r=1.5);

						translate([coolerMountDist, 4.5, -1])
						cylinder(h=5+2, r=1.5);
					}
				}
			}
		}

		beltMountHoles(n);

		//Clamp timing belt teeth
		if (n == 1)
		{
			rotate([90, 0, 0])
			for (i = [-ceil(7*xCarriageBeltMount/xBeltToothSize)*xBeltToothSize-xBeltToothSize : xBeltToothSize : 10*xBeltToothSize])
				translate([i, xBeltHeight, xBeltWall-xBeltToothDepth])
				cube([xBeltToothSize/2+0.2, xBeltSide+1, xBeltToothDepth*2], center=true);

			translate([0, -xBeltWall, xBeltHeight])
			cube([50*xCarriageBeltMount, xBeltToothDepth*2, xBeltSide+1], center=true);
		}
	}
}


//5
// using extruders.scad

//6
// using extruders.scad

//7
//************************************* UNDER CONSTRUCTION ********************************************
fanPosY				= 50;
fanPosZ				= 4;
fanWidth			= 40;
fanMountDist		= 32;
fanDiagonal			= 1.41*fanWidth/2;
//channelDiagonal		= sqrt(2*(-(-(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ+coolerWall)-(xLmDiameter/2+xLmWall)-coolerWall)*(-(-(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ+coolerWall)-(xLmDiameter/2+xLmWall)-coolerWall));
tipClearance		= 10;
coolerWall			= 1;
coolerWidth			= 34/2;
coolerHeight		= -(-(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ)-(xLmDiameter/2+xLmWall);
coolerRadius		= 5;
coolerLength		= xRodDist/2-coolerRadius;
coolerAngle			= 50;
coolerTan			= 2*coolerHeight*(1+tan(coolerAngle));

module fanMount()
{
	//%xCarriage();
	//%translate([0, 0, xCarriagePlatform]) rotate([0, 0, 270]) kJ(false);
	//%translate([0, xCarriageMountY+xBeltWall, 0]) beltMount(1);

	//rotate([0, 0, 180])
	difference()
	{
		union()
		{
			difference()
			{
				union()
				{
					//main block
					translate([-coolerWidth-jHeadOffset(), xRodDist/2, -(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ])
					cube([2*coolerWidth, fanPosY-xRodDist/2, (jBodyCut2TipZ()-xCarriagePlatform)-fanPosZ+xCarriagePlatform-(xCarriageZ+xCarriageLift)]);
				}

				//X-rod cutout
				translate([coolerWidth-jHeadOffset()+1, xRodDist/2, 0])
				rotate([0, -90, 0])
				cylinder(r=(xLmDiameter/2+xLmWall), h=2*coolerWidth+2);

				//overhang limiter
				translate([coolerWidth-jHeadOffset()+1, xRodDist/2, 0])
				rotate([60, 0, 180])
				cube([2*coolerWidth+2, (xLmDiameter/2+xLmWall), (xLmDiameter/2+xLmWall)]);

				//upper cut around hotend
				translate([-coolerWidth-jHeadOffset()-1, -tipClearance-1, -(xLmDiameter/2+xLmWall)])
				cube([2*coolerWidth+2, xRodDist/2+tipClearance+1, 2*(xLmDiameter/2+xLmWall)+1]);

				//channel hollow-out
				translate([coolerWall-coolerWidth-jHeadOffset(), coolerWall, -(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ+coolerWall])
				cube([2*coolerWidth-2*coolerWall, fanPosY-12.9, -(-(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ+coolerWall)-(xLmDiameter/2+xLmWall)-coolerWall]);

				/*
				//hotend cutout
				translate([-jHeadOffset(), tipClearance/2, -(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ-1])
				rotate([0, 0, 90])
				cylinder(r=tipClearance*1.2, h=coolerHeight+2, center=false,$fn=6);
				*/

				/*
				//lower edge output cut
				intersection()
				{
					//hotend cutout (adjusted)
					translate([-jHeadOffset(), tipClearance/2, -(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ-0.5])
					rotate([0, 0, 90])
					cylinder(r1=tipClearance*1.2, r2=tipClearance*1.2+1.5*coolerWall, h=coolerWall+1, center=false, $fn=6);

					//channel hollow-out (adjusted)
					translate([-coolerWidth-jHeadOffset()+coolerWall, coolerWall, -(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ])
					cube([2*coolerWidth-2*coolerWall, 2*tipClearance, -(-(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ+coolerWall)-(xLmDiameter/2+xLmWall)-coolerWall]);
				}
				*/
			}

			/*
			difference()
			{
				translate([0, 0, -(-(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ+coolerWall)-(xLmDiameter/2+xLmWall)-coolerWall])
				intersection()
				{
					//hotend cutout (adjusted)
					translate([-jHeadOffset(), tipClearance/2, -(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ])
					rotate([0, 0, 90])
					cylinder(r1=tipClearance*1.2, r2=tipClearance*1.2+1.5*coolerWall, h=coolerWall, center=false,$fn=6);

					//channel hollow-out (adjusted)
					translate([-coolerWidth-jHeadOffset()+coolerWall, coolerWall, -(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ-1])
					cube([2*coolerWidth-2*coolerWall, 2*tipClearance, -(-(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ+coolerWall)-(xLmDiameter/2+xLmWall)-coolerWall]);
				}

				//hotend cutout
				translate([-jHeadOffset(), tipClearance/2, -(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ-1])
				rotate([0, 0, 90])
				cylinder(r=tipClearance*1.2, h=coolerHeight+2, center=false,$fn=6);
			}
			*/

			/*
			//nozzle supports
			translate([-jHeadOffset(), tipClearance/2, -(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ])
			for (i = [-30, -90, -150])
			rotate([0, 0, -i])
			translate([tipClearance+coolerWall, -coolerWall, 0])
			cube([coolerWall*2, coolerWall*2, -(-(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ)-(xLmDiameter/2+xLmWall)]);


			//nozzle wall
			translate([-jHeadOffset(), tipClearance/2, -(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ])
			for (i = [-60, -120])
			rotate([0, 0, -i])
			translate([tipClearance, 0, coolerHeight/2])
			cube([coolerWall, tipClearance+coolerWall, coolerHeight], center=true);
			*/

			//fanFunnel();

			hull()
			{
				//fan mounting plate
				translate([-jHeadOffset(), fanPosY+fanDiagonal/2, fanDiagonal/2-(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ])
				rotate([-45, 0, 0])
				translate([-20, -20, 0])
				cube([40, 40, 2]);

				//cooler block plate
				translate([-coolerWidth-jHeadOffset(), fanPosY-5, -(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ])
				cube([2*coolerWidth, 1, fanDiagonal-5]);
			}
		}

		hull()
		{
			//fan center hole
			translate([-jHeadOffset(), fanPosY+fanDiagonal/2, fanDiagonal/2-(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ])
			rotate([-45, 0, 0])
			translate([0, 0, -.5])
			cylinder(r=18, h=5);

			//cooler block opening
			translate([coolerWall-coolerWidth-jHeadOffset(), fanPosY-12, -(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ+coolerWall])
			cube([2*coolerWidth-2*coolerWall, 1, coolerHeight-2*coolerWall]);
		}

		//fan mounting holes
		translate([-jHeadOffset(), fanPosY+fanDiagonal/2, fanDiagonal/2-(jBodyCut2TipZ()-xCarriagePlatform)+fanPosZ])
		rotate([-45, 0, 0])
		for (x =[-1, 1])
		for (y =[-1, 1])
		translate([x*fanMountDist/2, y*fanMountDist/2, -.5])
		{
			cylinder(r=1.6, h=5);

			translate([x*3.5, 0, 0])
			cube([10, 3, 2], center=true);
		}

		//coolerMountBracket
		translate([-J_X(), coolerMountOffset, xCarriagePlatform-(xCarriageZ+xCarriageLift)])
		{
			translate([-coolerMountDist, 0, -5])
			{
				cylinder(r=1.6, h=6);

				translate([-5, 0, 1.6])
				cube([10, 3.2, 3.2], center=true);

			}

			translate([coolerMountDist, 0, -5])
			{
				cylinder(r=1.6, h=6);

				translate([5, 0, 1.6])
				cube([10, 3.2, 3.2], center=true);

			}
		}
	}

	translate([-J_X(), 0, 0])
	{
		airDeflector();

		mirror([1, 0, 0])
		airDeflector();
	}
}


//8
module cableGuide()
{
	difference(){
		union(){
			//mounting bracket
			translate([0, -guideThickness, 0])
			cube([motorMountDist, 2*guideThickness, guideBracketH]);
			cylinder(h=guideBracketH, r=guideThickness);
			translate([motorMountDist, 0, 0])
			cylinder(h=guideBracketH, r=guideThickness);

			difference(){
				union(){
					//cable guide towers
					for (i=[0, 1])
					translate([guideBridgeOffset, i*guideWidth, 0]){
						cylinder(h=guideHeight, r=guideThickness);
						translate([0, 0, guideHeight])
						sphere(r=guideThickness);
					}

					//cable guide bridge
					translate([guideBridgeOffset, guideWidth, guideHeight])
					difference(){
						rotate([90, 0, 0])
						cylinder(h=guideWidth, r=guideThickness);

						translate([-guideThickness, -guideWidth-1, -guideThickness-1])
						cube([2*guideThickness, guideWidth+2, guideThickness+1]);
					}
				}
			}
		}

		//motor mount holes
		translate([0, 0, -1]){
			cylinder(h=guideBracketH+2, r=motorMount/2);
			translate([motorMountDist, 0, 0])
			cylinder(h=guideBracketH+2, r=motorMount/2);
		}
	}

}


//9
module zEndstopMount()
{
	difference()
	{
		union()
		{
			//motor corner bracket
			translate([-zEndstopWall, -zEndstopWall, -uSwitchThickness])
			cube([motorWidth/2+zEndstopWall, motorWidth/2+zEndstopWall, uSwitchThickness+zEndstopWall]);

			// angled surfaces
			hull()
			{
				translate([-zEndstopWall, -zEndstopWall, -uSwitchThickness])
				cube([motorWidth/2+zEndstopWall, (motorWidth/2-motorCutoutD/2-0.5)+zEndstopWall, uSwitchThickness+zEndstopWall]);

				translate([-zEndstopWall, -zEndstopWall, -uSwitchThickness])
				cube([motorWidth/2+zEndstopWall+zEndstopPosX, zEndstopWall, uSwitchThickness+zEndstopWall]);

				translate([-zEndstopWall, -zEndstopWall-uSwitchThickness, 0])
				cube([zEndstopWall+motorWidth/2-uSwitchLength/2+zEndstopPosX+uSwitchLength, zEndstopWall, zEndstopWall]);
			}

			//stiffener
			translate([motorWidth/2-zEndstopWall/2, -zEndstopWall-uSwitchThickness, 0])
			hull()
			{
				cube([zEndstopWall, zEndstopWall+uSwitchThickness+(motorWidth/2-motorCutoutD/2)/2, zEndstopWall]);
				cube([zEndstopWall, zEndstopWall, zEndstopWall+uSwitchThickness+(motorWidth/2-motorCutoutD/2)/2]);
			}

			//endstop plate
			translate([motorWidth/2-uSwitchLength/2+zEndstopPosX, -zEndstopWall-uSwitchThickness, 0])
			cube([uSwitchLength, zEndstopWall, uSwitchDepth/2+zEndstopPosZ-zEndstopWall]);

			translate([motorWidth/2-uSwitchLength/2+zEndstopPosX, -zEndstopWall-uSwitchThickness, 0])
			translate([0, zEndstopWall, uSwitchDepth/2+zEndstopPosZ-zEndstopWall])
			hull()
			{
				translate([uSwitchDepth/2, 0, 0])
				rotate([90, 0, 0])
				cylinder(r=uSwitchDepth/2, h=zEndstopWall);

				translate([uSwitchLength-uSwitchDepth/2, 0, 0])
				rotate([90, 0, 0])
				cylinder(r=uSwitchDepth/2, h=zEndstopWall);
			}
		}

		//corner cut-away
		translate([-zEndstopWall, -zEndstopWall, 0])
		rotate([0, 0, 45])
		translate([-motorWidth, -motorWidth/2, -motorWidth/2])
		cube([motorWidth, motorWidth, motorWidth]);

		//microswitch mounting holes:
		translate([motorWidth/2+uSwitchLength/2+zEndstopPosX, -uSwitchThickness, uSwitchDepth+zEndstopPosZ])
		rotate([270, 90, 0])
		uSwitch(1);

		//stepper motor cut:
		translate([motorWidth/2, motorWidth/2, motorCutoutH])
		motor(0);

		//stepper motor cut:
		translate([motorWidth/2, motorWidth/2, motorCutoutH])
		cylinder(h=2*zEndstopWall, r=motorCutoutD/2+.5, center=true);
	}
}


/**************** CONTROL **************************/

module render(n)
{
	if (n == 1)
	{
		if (renderPart == 1)							// solo mode
		{
			rotate([180,0,0])
			xBarEnds(n);
		} else {									// combined mode
			color("Green")
			translate([-renderPartDistance, 0, 0])
			rotate ([0,0,180])
			xBarEnds(n);
		}
	}
	if (n == 2)
	{
		if (renderPart == 2)
		{
			rotate ([0,90,0])
			xCarriage();
		} else {
			color("Yellow")
			xCarriage();
		}
	}
	if (n == 3)
	{
		if (renderPart == 3)
		{
			rotate([180,0,0])
			xBarEnds(n);
		} else {
			color("Red")
			translate([renderPartDistance, 0, 0])
			xBarEnds(n);
		}
	}
	if (n == 4)
	{
		if (renderPart == 4)
		{
			rotate([0, 0, 0])
			beltMount(1);
		} else {
			color("Orange")
			translate([0, xCarriageMountY+xBeltWall, 0])
			beltMount(1);
		}
	}
	if (n == 5)
	{
		if (renderPart == 5)
		{
			kJ();
		} else {
			color("Blue")
			translate([0, 0, xCarriagePlatform])
			rotate([0, 0, 270])
			kJ();
		}
	}
	if (n == 6)
	{
		if (renderPart == 6)
		{
			goKissD(); //MAXtruder();
		} else {
			color("Magenta")
			translate([0, kissSizeY()/2, kissSizeZ()/2+kJSizeZ()+xCarriagePlatform])
			rotate([90, 90, 0])
			goKissD(); //MAXtruder();
		}
	}
	if (n == 7)
	{
		if (renderPart == 7)
		{
			//rotate([0, 0, 0])
			fanMount();
		} else {
			color("Cyan")
			//translate([-J_X(), 0, xCarriagePlatform-xCarriageZ-28])
			//rotate([45, 0, 0])
			{
				fanMount();
			}
		}
	}
	if (n == 8)
	{
		if (renderPart == 8)
		{
			cableGuide();
		} else {
			color("GreenYellow")
			translate([-renderPartDistance-xMotorDisplaceX+motorMountDist/2, yBody/2+xMotorDisplaceY-motorMountDist/2, zBody/2])
			rotate([0, 0, 180])
			cableGuide();
		}
	}
	if (n == 9)
	{
		if (renderPart == 9)
		{
			rotate([90, 0, 0])
			zEndstopMount();
		} else {
			color("SeaGreen")
			translate([-(zRodDist+renderPartDistance-(xBody/2+zRodOffset))-motorWidth/2, -motorWidth/2, motorHeight-motorCutoutH-zPos])
			zEndstopMount();
		}
	}
}

module maxbot()
{
	// MAIN
	translate([jHeadOffset(), 0, 44.6-xCarriagePlatform])
	if (renderPart == 0)
	{

		for (pn = [1 : 9])
		render(pn);

		vitamins();

	} else {
		if (renderPart == -1) vitamins();

		render(renderPart);
	}
}

maxbot();
