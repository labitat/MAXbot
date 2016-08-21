/*
The MAXbot
Parametric Wallace/printrBot derivate/upgrade
Written for OpenSCAD by Martin Axelsen 2012-2013
kharar@gmail.com | http://kortlink.dk/c9d9
*/

use<extruders.scad>;

//SELECT RENDER PART:
//0=Show all parts assembled
//1=X motor mount
//2=X carriage
//3=X belt end
//4=Belt clamp (and future fan holder)
//5=J-head adaptor
//6=Extruder
//7=X carriage fan mount (under construction)

renderPart			= 6;			// part selector



// CONSTANTS
$fn=40;
pi					= 3.14159265;	// PI
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
uSwitchHoleDia		= 2.25;			// microswitch mounting hole snapfit/selfcarving diameter (M2 -> 1.5)
uSwitchPlateOffset	= 2;			// microswitch touching plate offset (X-carriage homing position)

xPulleyTooth		= 16;			// pulley tooth count (to calculate pulley diameter)
xPulleyToothHeight	= 7;			// pulley tooth area length (actual span than belt can reside on)
xPulleyCutout		= 10;			// pulley clearance radius
xPulleyBaseHeight	= 8 +1;			// pulley base height (the part where the set screw is) (+1 for clearance)

xMotorDisplaceY		= 1.275;		//*motorrod clearance (must be kept high enough to avoid motor mount screws, and low enough to avoid motor-rod to intersecting X-rod 2) (1.275@8mmxrod | -1@10mmxrod)
xMotorDisplaceZ		= 0;			// motor base vs X-rod 2 clearance
xMotorMountWall		= 4;			// motor mount screw wall thickness
xMotorMount			= 3+0.1;		// motor mount screw hole diameter (NEMA17=3)
xMotorHoleDist		= 31;			// motor mount screw hole distance (NEMA17=31)
xMotorRod			= 5 +1;			// motor axis diameter (NEMA17=5) (+1 for clearance)
xMotorRodLength		= 22.5;			// motor axis length (NEMA17=22.5)
xMotorWidth			= 42.3;			// size of motor measured on x and y-axis (NEMA17=42.3)
xMotorHeight		= 47;			// size of motor measured on z-axis (NEMA17=47)
xMotorCutoutD		= 22 +1;		// motor center ring diameter (NEMA17=22) (+1 for clearance)
xMotorCutoutH		= 2;			// motor center ring height (NEMA17=2)

xBeltWall			= 4;			// thickness of clamp/belt mounts
xCarriageBeltMount	= 3+0.2;		// clamp screw hole diameter
xCarriageLift		= 1;			// x-carriage base plate height (must be>0 to avoid collision with Z-rod walls in either end)
xCarriageZ			= 4;			// x-carriage base thickness
xCarriageUseLength	= (48+2*3);	// minimum distance between Z-rod carvings (48=mounting screw interval distance, 2=screw count, 3=screw diameter)
xCarExtGroove		= 0;			// extruder cut-out depth from x-carriage base thickness (xCarriageZ)
xCenterHole			= 22;			// x-carriage base plate hot-end hole diameter
xLmWall				= 4;			// x-carriage linear bearing support wall thickness (determines flexibility of snap-fit/quick-release)
xLmSnap				= 15;			// x-carriage linear bearing support bottom cut-off amount (for easy snap-fit/quick-release functionality) (works with 15)

xRodDist			= 65;			// distance between center of smooth X-rods (40mm fan compatible>=65)(Prusa semi-compatible=50)
xRodHole			= 8;			//*rod diameter (8 or 10)
xRodDepth			= 26;			// X-rod hole depth into X-ends (for direct printrBot compatibility set around 26)
xRodLength			= 330;			// length of X-rods (minimum 118 approx)
xRodEnds			= true;			// [boolean]
xRodFixation		= true;			// [boolean]
xRodFixScrew		= 3;			// hole diameter for X-rod fixation
xRodFixLength		= 2;			// hole extension for X-rod fixation
xRodFixDist			= 6;			// hole distance from either end of x-rod hole

xLmLength			= 24;			//*linear bearing length (LM8UU=24 | LM10UU=29)
xLmDiameter			= 15+0.1;		//*linear bearing diameter (LM8UU=15 | LM10UU=19) (+0.1 for printer calibration)

zRodThreaded		= 8;			// threaded Z-(outer)rod diameter (M8=8)
zRodSmooth			= 8;			// smooth Z-(inner)rod diameter (usually same size as zRodThreaded)
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



// VARIABLES
xPulleyRadius		= (xPulleyTooth*xBeltToothSize/pi)/2;					// x-belt pulley radius

xCarriagePlatform	= xLmDiameter/2+xLmWall+xCarriageLift+xCarriageZ;		// x-carriage plateau Z-distance from origin

xBeltHeight			= xLmDiameter/2+xLmWall+xBeltSide/2+1+1;				//*x-belt Z-distance from origin
xPulleyBeltHeight	= xBeltHeight-xPulleyBaseHeight;						// x-belt to base of pulley distance

xBeltMountZdisplace	= xBeltSide+xCarriageBeltMount;							// clamp screw holes Z-distance from belt height on x-carriage
xBeltMountXDist		= 10;													// clamp screw holes X-distance from belt height on x-carriage

xBeltIdlerDiameter	= bearingDiameter;  									//xBeltToothCount*xBeltToothSize/pi;		// belt idler diameter

xBody				= xRodDepth; 											// x-size of x-ends
yBody				= xRodDist+2*xRodHole;									// y-size of x-ends
zBody				= 2*xRodHole;											// z-size of x-ends

zRodHole			= zRodThreaded + 3;										// holes size for the threaded Z-rods
xMotorDisplaceX		= xMotorWidth/2-xBody/2;								// motor position (clearance for X-carriage)
renderPartDistance	= xRodLength/2-xRodDepth+xBody/2;						// distance between origins (for renderPart=0 only)
zLmOffset			= -(zLmLength*2-zBody)/2;								// smooth z-rod LM bearing support tube displacement
zLmSupportX			= zLmDiameter/2+zLmWall;								// support for the Z-LM tube

xCarriageMountY		= yBody/2+xMotorDisplaceY-xPulleyRadius-xBeltDepth;	// x-carriage belt mount y-distance from origin
xCarriageLmSpace	= 2;													// x-carriage LM center spacer
xCarriageLmEnd		= 2;													// x-carriage LM end limiter
xCarriageLength		= max(zLmLength*2+xCarriageLmSpace*2+xCarriageLmEnd, xCarriageUseLength+zRodSmooth+2);		// x-carriage length on x-axis

xPulleyDisplaceZ	= xBeltHeight-xPulleyBaseHeight-xPulleyToothHeight/2-xRodHole/2;	//2.5;			// pulley vs X-rod 2 clearance (pulley cut-out plateau)


uSwitchOffsetY		= zLmDiameter/2;										// x-microswitch Y-distance from origin



// TEXT OUTPUT

	echo();
	if (xRodLength <= zLmLength*2+xRodDepth*2)	echo("ATTENTION: xRodLength too small or xRodDepth too large");
	echo("Mechanical summary:");
	echo();
	echo("Belt outside around pulley diameter:                               ", round((xPulleyRadius*2+xBeltDepth*2)*100)/100);
	echo("Caliper measurement belt around idler:                           ", round((xBeltIdlerDiameter+xBeltDepth*2)*100)/100);
	echo("Length of X-carriage on X-rods:                                      ", xCarriageLength);
	echo("Distance between X-ends (space between axis ends):   ", xRodLength-xRodDepth*2);
	echo("Max theoretical build volume X (free space on axis):      ", xRodLength-xRodDepth*2-xCarriageLength);
	echo("Amount of X-rod reserved by X-ends and X-carriage:    ", xRodDepth*2+xCarriageLength);
	echo("Inner distance between smooth Z-rods:                         ", (renderPartDistance-(xBody/2+zRodOffset))*2-zRodSmooth);
	echo("Approximate length of X-axis timing belt (no margin):    ",  round(2*(xRodLength-xRodDepth*2+xBody+xMotorDisplaceX)+(xPulleyRadius+bearingDiameter/2)*pi));
	echo("X-idler bearing distance from mounting hole surface:     ", round((xBeltHeight-zBody/2-bearingHeight/2)*100)/100);
	echo("X-belt height from base pulley cut-out                            ", round(xPulleyBeltHeight*100)/100);
	echo("Distance between carriage and LM undersides:              ", (xCarriagePlatform-xCarriageZ)+zLmDiameter/2);
	echo();


/**************** MODULES **************************/
module test()
{
//cube([10,10,10], center=true);
//empty on purpose
uSwitch();
}

module beltMountHoles(n)
{
	//Belt mount hole 1:
	translate(v = [-xBeltMountXDist/2, 1, xBeltHeight+xBeltMountZdisplace/2])
	rotate ([90,0,0])
	cylinder(h = xBeltWall*(n+1)+2, r=xCarriageBeltMount/2, center = false);

	//Belt mount hole 2:
	translate(v = [xBeltMountXDist/2, 1, xBeltHeight+xBeltMountZdisplace/2])
	rotate ([90,0,0])
	cylinder (h = xBeltWall*(n+1)+2, r=xCarriageBeltMount/2, center = false);
}


module beltMount(n)		// n=0: xCarriage		n=1: Clamp
{
	difference()
	{
		rotate([90, 0, 0])
		linear_extrude(height = xBeltWall, center = false)
		polygon(	
			points=	[	[(1-n)*(-xCarriageLength/2)+n*-xCarriageBeltMount*3, xCarriagePlatform-(n)*(xCarriageZ+xCarriageLift)],
						[(1-n)*-xCarriageBeltMount*3+n*-xCarriageBeltMount*3, xBeltHeight+xBeltMountZdisplace/2+xCarriageBeltMount*1.5],
						[(1-n)*xCarriageBeltMount*3+n*xCarriageBeltMount*3, xBeltHeight+xBeltMountZdisplace/2+xCarriageBeltMount*1.5],
						[ (1-n)*(xCarriageLength/2)+n*xCarriageBeltMount*3, xCarriagePlatform-(n)*(xCarriageZ+xCarriageLift)]	
					],
			paths=	[	[0,1,2,3]
					]
		);
		
		beltMountHoles(n);

		//Clamp timing belt teeth
		if (n == 1)
		{
			rotate([90, 0, 0])
			for (i = [-ceil(7*xCarriageBeltMount/xBeltToothSize)*xBeltToothSize-xBeltToothSize : xBeltToothSize : 10*xBeltToothSize])
				translate([i, xBeltHeight, xBeltWall-xBeltToothDepth])
				cube([xBeltToothSize/2+0.2, xBeltSide+1, xBeltToothDepth*1.5], center=true);

			translate([0, -xBeltWall-xBeltToothDepth/2, xBeltHeight])
			cube([50*xCarriageBeltMount, xBeltToothDepth*2, xBeltSide+1], center=true);
		}
	}
	//cube([]);
}


module uSwitch()
{
	cube([uSwitchDepth, uSwitchLength,uSwitchThickness], center = false);

	translate([uSwitchHoleAX, uSwitchHoleAY, uSwitchThickness+2])
	rotate([0, 180, 0])
	cylinder(h=uSwitchThickness+uSwitchMountHole+53, r=uSwitchHoleDia/2, center=false);

	translate([uSwitchHoleBX, uSwitchHoleBY, uSwitchThickness+2])
	rotate([0, 180, 0])
	cylinder(h=uSwitchThickness+uSwitchMountHole+53, r=uSwitchHoleDia/2, center=false);
/*	
	translate([uSwitchHoleBX, uSwitchHoleBY, -zBody])
	rotate([180-45, 0, 0])
	cylinder(h=5, r=uSwitchHoleDia/2, center=false);
	
	translate([uSwitchHoleAX, uSwitchHoleAY, 0])
	sphere(r=1);
*/
	translate([uSwitchHoleBX, uSwitchHoleBY, -zBody])
	rotate([90, 0, 0])
	{
//		cylinder(h=uSwitchHoleBY-uSwitchHoleAY, r=uSwitchHoleDia/2, center=false);

		translate([-uSwitchHoleDia/2, -50, 0])
		cube([uSwitchHoleDia, 50, uSwitchHoleBY-uSwitchHoleAY]);
	}
}


module showRods()		// x/y/z-rods and belt
{
	// front smooth X-rod
	rotate ([0,90,0])
	translate(v = [0, -xRodDist/2, 0])
	#cylinder(h = xRodLength, r=xRodHole/2, center = true);

	// rear smooth X-rod
	rotate ([0,90,0])
	translate(v = [0, xRodDist/2, 0])
	#cylinder(h = xRodLength, r=xRodHole/2, center = true);

	// outer threaded Z-rod 1
	rotate ([0,0,90])
	translate(v = [0, -(xBody/2+zRodOffset)+zRodDist+renderPartDistance, 0])
	#cylinder(h = xRodLength, r=zRodThreaded/2, center = true);

	// inner smooth Z-rod 1
	rotate ([0,0,90])
	translate(v = [0, -(xBody/2+zRodOffset)+renderPartDistance, 0])
	#cylinder(h = xRodLength, r=zRodSmooth/2, center = true);

	// inner smooth Z-rod 2
	rotate ([0,0,90])
	translate(v = [0, (xBody/2+zRodOffset)-renderPartDistance, 0])

	#cylinder(h = xRodLength, r=zRodSmooth/2, center = true);
	// outer threaded Z-rod 2
	rotate ([0,0,90])
	translate(v = [0, (xBody/2+zRodOffset)-zRodDist-renderPartDistance, 0])
	#cylinder(h = xRodLength, r=zRodThreaded/2, center = true);

	//x-belt
	translate([-xRodLength/2+xRodDepth-xBody/2-xMotorDisplaceX, yBody/2+xMotorDisplaceY-xPulleyRadius-xBeltDepth, xBeltHeight-xBeltSide/2])
	%cube([xRodLength-xRodDepth*2+xBody+xMotorDisplaceX, xBeltToothSize/2+xBeltDepth, xBeltSide], center = false);
}


module zTopSupport()
{
/*	difference()
	{
		union()
		{
			cube([zRodDist, (zRodSmooth/2+zTopSupportWall)*2, bearingHeight+zTopSupportWall], center = true);

			translate([-zRodDist/2, 0, 0])
			cylinder(h = bearingHeight+zTopSupportWall, r=zRodSmooth/2+zTopSupportWall, center = true, $fn=60);

			translate([zRodDist/2, 0, 0])
			cylinder(h = bearingHeight+zTopSupportWall, r=bearingDiameter/2+zTopSupportWall, center = true, $fn=60);
		}
		union()
		{
			translate([-zRodDist/2, 0, 0])
			cylinder(h = bearingHeight+zTopSupportWall+1, r=zRodSmooth/2, center = true, $fn=60);

			translate([zRodDist/2, 0, -zTopSupportWall/2-1])
			cylinder(h = bearingHeight+2, r=bearingDiameter/2, center=true, $fn=60);

			translate([zRodDist/2, 0, zTopSupportWall])
			cylinder(h = bearingHeight, r=bearingDiameter/2-zTopSupportWall, center=true, $fn=60);

			// Show bearing:
			translate([zRodDist/2, 0, -zTopSupportWall/2])
			#cylinder(h = bearingHeight, r=bearingDiameter/2, center=true, $fn=60);
		}
	}
*/
}


module xMotor()
{
	//X-motor rod:
	translate(v = [0, 0, -xRodHole/2])
	cylinder(h = xMotorRodLength+4, r = xMotorRod/2+0.5, center = false);
	
	//X-motor ring cutout:
	rotate([180,0,0])
	cylinder(h = xMotorCutoutH+1, r = xMotorCutoutD/2, center = false);
	
	//X-motor base cutout:
	translate(v = [-xMotorWidth/2-0.5, xMotorWidth/2+0.5, -xMotorCutoutH])
	rotate([180,0,0])
	cube(size = [xMotorWidth+1, xMotorWidth+1, xMotorHeight], center = false);
	
	//X-motor mounting hole 1:
	translate(v = [-xMotorHoleDist/2, xMotorHoleDist/2, -xMotorCutoutH-1])
	cylinder(h = zBody+1, r = xMotorMount/2, center = false);
	
	//X-motor mounting hole 2:
	translate(v = [xMotorHoleDist/2, xMotorHoleDist/2, -xMotorCutoutH-1])
	cylinder(h = zBody+1, r = xMotorMount/2, center = false);
	
	//X-motor mounting hole 3:
	translate(v = [-xMotorHoleDist/2, -xMotorHoleDist/2, -xMotorCutoutH-1])
	cylinder(h = zBody+1, r = xMotorMount/2, center = false);
	
	//X-motor mounting hole 4:
	translate(v = [xMotorHoleDist/2, -xMotorHoleDist/2, -xMotorCutoutH-1])
	cylinder(h = zBody+1, r = xMotorMount/2, center = false);
}


module pulley()
{
	//X-motor pulley clearance cutout:
	cylinder(h = 9, r = xPulleyCutout, center = false);

	//X-motor pulley:
	if (renderPart == 0)
	{
		// toothed part
		translate([0,0,xPulleyBaseHeight+xPulleyToothHeight/2])
		#cylinder(h = xPulleyToothHeight, r = xPulleyRadius, center = true, $fn=xPulleyTooth);
		// base part
		translate([0,0,xPulleyBaseHeight/2])
		#cylinder(h = xPulleyBaseHeight, r = xPulleyRadius+2, center = true);
	}
}


module xBearingIdler()
{
	translate(v = [0, yBody/2+xMotorDisplaceY+(xBeltIdlerDiameter/2-xPulleyRadius)+xBeltToothDepth, 0])
	cylinder(h = 2*zBody+2, r = xBeltIdlerRodHole/2, center = true);

	if (renderPart == 0 || renderPart == 3) //or
	{
		translate(v = [0, yBody/2+xMotorDisplaceY+(xBeltIdlerDiameter/2-xPulleyRadius)+xBeltToothDepth, xBeltHeight])
		#cylinder(h = bearingHeight, r = xBeltIdlerDiameter/2, center = true);
	}
}

module endstopPusher(length)
{
	espThickness=1;
	angle=50;
	width=uSwitchThickness+1;
	height=width*tan(angle);
	

	difference()
	{
		translate(-[1, length/2, height+espThickness])
		cube([width, length, height+espThickness], center=false);

%		translate([width-1, -length/2-1, -espThickness])
		rotate([0, 180-angle, 0])
		cube([height*1.42, length+2, width], center=false);
	}
}


/************** MAIN MODULES **************************************************/


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
				translate([xMotorDisplaceX+xMotorHoleDist/2, -yBody/2-xMotorDisplaceY+xMotorHoleDist/2, 0])
				cylinder(h=zBody, r=xMotorMount/2+xMotorMountWall, center=true);

				translate([xBody/2+((xMotorDisplaceX+xMotorHoleDist/2)-xBody/2)/2, -yBody/2-xMotorDisplaceY+xMotorHoleDist/2, 0])
				cube([(xMotorDisplaceX+xMotorHoleDist/2)-xBody/2, xMotorMount+xMotorMountWall*2, zBody], center=true);

				translate([xBody/2+(zRodDist-(xBody/2+zRodOffset)-xBody/2)/2, ((-yBody/2-xMotorDisplaceY+xMotorHoleDist/2-xMotorMount/2+xMotorMountWall/2)-(zNutHole/2))/2, 0]) //skal rettes!
				cube([zRodDist-(xBody/2+zRodOffset)-xBody/2, (-zNutHole/2-zNutWall)-(-yBody/2-xMotorDisplaceY+xMotorHoleDist/2+xMotorMount/2+xMotorMountWall)+1, zBody], center=true);

			}
			
			if (part == 3)
			{
				//X-belt mount:
				translate(v = [0, yBody/2+xMotorDisplaceY+(xBeltIdlerDiameter/2-xPulleyRadius)+xBeltToothDepth, 0])
				cylinder(h = zBody, r = xBeltIdlerRodHole/2+xBeltIdlerRodWall, center = true);

				//X-belt mount support:
				translate(v = [-xBeltIdlerRodHole/2-xBeltIdlerRodWall, yBody/2, -zBody/2])
				cube(size = [xBeltIdlerRodHole+xBeltIdlerRodWall*2, xMotorDisplaceY+(xBeltIdlerDiameter/2-xPulleyRadius)+xBeltToothDepth, zBody], center = false);
			}

			//LM z-rod mount tube:
			translate(v = [-(xBody/2+zRodOffset), 0, zLmOffset])
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

		/*	//endstop push:
			translate([zLmSupportX-xBody/2, 0, -zBody-zLmLength])
			rotate([0, 180, 180])
			endstopPusher(zLmSupportX*2);
		*/

			//Threaded z-rod mount:
			translate(v = [zRodDist-(xBody/2+zRodOffset), 0, 0])
			cylinder(h = zBody, r=zNutHole/2+zNutWall, center = true);

			translate([xBody/2+(zRodDist-(xBody/2+zRodOffset)-xBody/2)/2, 0, 0])
			cube([zRodDist-(xBody/2+zRodOffset)-xBody/2, zNutHole+zNutWall*2,zBody], center=true);

			//X-rod ends:
			if ((!xRodEnds) && (part==3)) {} else
			{
				//X-rod end 1:
				translate(v = [xBody/2, -xRodDist/2, 0])
				cylinder(h=zBody, r=xRodHole, center=true);
				
				//X-rod end 2:
				translate(v = [xBody/2, +xRodDist/2, 0])
				cylinder(h=zBody, r=xRodHole, center=true);
			}

			//X-rod mount 1:
			translate(v = [0, -xRodDist/2, 0])
			cube([xBody, xRodHole*2, zBody], center = true);


			//X-rod mount 2:
			translate(v = [0, xRodDist/2, 0])
			cube([xBody, xRodHole*2, zBody], center = true);
		}
		
		union()
		{
			if (part == 1)
			{
				translate(v = [xMotorDisplaceX, -yBody/2-xMotorDisplaceY, -xRodHole/2-xMotorDisplaceZ])
				#xMotor();

				translate(v = [xMotorDisplaceX, -yBody/2-xMotorDisplaceY, xRodHole/2+xPulleyDisplaceZ])
				pulley();

				// uSwitch mounting holes:
				translate(v = [-xBody/2+uSwitchPlateOffset, uSwitchOffsetY, zBody/2])
				#uSwitch();
			}

			if (part == 3)
			{
				// X-bearing hole:
			#	xBearingIdler();
			}

			//LM z-rod hole:
			rotate ([0,0,90])
			translate(v = [0, (xBody/2+zRodOffset), zLmOffset])
			#cylinder(h = zLmLength*2+1, r=zLmDiameter/2, center = true);
			
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
			
			translate([-xBody/2-zRodOffset-(zLmDiameter/2.5), 0, zBody/2-2*zLmLength-.5])
			cylinder(h=5, r1=0.25+zLmSfccDepth-zLmSnap/2, r2=zLmSfccDepth-zLmSnap/2-0.25);

			
			//Threaded z-rod hole:
			rotate ([0,0,90])
			translate(v = [0, (xBody/2+zRodOffset)-zRodDist, 0])
			cylinder(h = zBody+1, r=zRodHole/2, center = true);
			
			//Threaded z-rod hex nut mount hole:
			translate(v = [zRodDist-(xBody/2+zRodOffset), 0, -zBody/2+zNutHeight/2])
			rotate ([0, 0, 90]*0)
			#cylinder(h = zNutHeight+1, r=zNutHole/2, center = true, $fn=6);
			
			//X-rod hole 1 + finish:
			rotate ([0,90,0])
			translate(v = [0, -xRodDist/2, -xBody/2+xRodDepth/2-1])
			cylinder(h = xRodDepth+2, r=xRodHole/2, center = true);

			rotate ([0,90,0])
			translate(v = [0, -xRodDist/2, -xBody/2+xRodDepth-0.001])
			cylinder(h = xRodHole/4, r1=xRodHole/2, r2=0, center = false);
			
			//X-rod hole 2 + finish:
			rotate ([0,90,0])
			translate(v = [0, xRodDist/2, -xBody/2+xRodDepth/2-1])
			cylinder(h = xRodDepth+2, r=xRodHole/2, center = true);

			rotate ([0,90,0])
			translate(v = [0, xRodDist/2, -xBody/2+xRodDepth-0.001])
			cylinder(h = xRodHole/4, r1=xRodHole/2, r2=0, center = false);
			
			// X-rod fixation holes
			
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


module xCarriage()
{
	difference()
	{
		union()
		{
			//Base:
			translate([0, 0, xCarriageLift+xLmWall+xLmDiameter/2+xCarriageZ/2])
			cube(size = [xCarriageLength, xRodDist+xCarriageZ ,xCarriageZ], center = true);

			//Base support 1:
			translate([0, -xRodDist/2, xCarriageLift/2+xLmWall+xLmDiameter/2])
			cube(size = [xCarriageLength, xCarriageZ ,xCarriageLift+1], center = true);

			//Base support 2:
			translate([0, xRodDist/2, xCarriageLift/2+xLmWall+xLmDiameter/2])
			cube(size = [xCarriageLength, xCarriageZ ,xCarriageLift+1], center = true);

			//X-rod mount 1:
			rotate ([0,90,0])
			translate(v = [0, -xRodDist/2, 0])
			cylinder(h = xCarriageLength, r=xLmDiameter/2+xLmWall, center = true);

			//X-rod mount 2:
			rotate ([0,90,0])
			translate(v = [0, +xRodDist/2, 0])
			cylinder(h = xCarriageLength, r=xLmDiameter/2+xLmWall, center = true);

			//X-belt mounting plate
			translate([0, xCarriageMountY, -0.01])
			beltMount(0);

			//uSwitch touch plate:
			difference()
			{
				translate([-xCarriageLength/2-uSwitchPlateOffset, -uSwitchOffsetY-(uSwitchLength-5), zBody/2+1])
				cube([xCarriageZ, uSwitchLength-10, uSwitchThickness], center=false);

				translate([-xCarriageLength/2-uSwitchPlateOffset, -uSwitchOffsetY-uSwitchLength-1, zBody/2])
				rotate([0, 40, 0])
				cube([xCarriageZ, uSwitchLength+2, uSwitchThickness], center=false);
			}
			//endstopPusher(uSwitchLength);
		}
		
		//Belt mount
		union()
		{
			//Plate holes
			translate([0, xCarriageMountY, 0])
			#beltMountHoles(1);
			
			//hexnut cut-out:
			for (i=[-1,1])
			{
				translate(v = [i*xBeltMountXDist/2, xCarriageMountY-xBeltWall*2/3-xCarriageBeltMount/2, xBeltHeight+xBeltMountZdisplace/2])
				rotate ([90,0,0])
				cylinder (h =xCarriageBeltMount , r=xCarriageBeltMount, center = true, $fn=6);
			}

			
			/*union()
			{
				//Hole 1 hexnut cut-out:
				translate(v = [0, xCarriageMountY-xBeltWall*2/3-xCarriageBeltMount/2, xBeltHeight+xBeltMountZdisplace/2])
				rotate ([90,0,0])
				cylinder (h =xCarriageBeltMount , r=xCarriageBeltMount, center = true, $fn=6);
				
				//Hole 2 hexnut cut-out:
				translate(v = [0, xCarriageMountY-xBeltWall*2/3-xCarriageBeltMount/2, xBeltHeight-xBeltMountZdisplace/2])
				rotate ([90,0,0])
				cylinder (h =xCarriageBeltMount , r=xCarriageBeltMount, center = true, $fn=6);
				
				//Hole 2 hexnut cut-out access space:
				translate(v = [0, xCarriageMountY-xBeltWall*2/3-xCarriageBeltMount/2, xBeltHeight])
				#cube([xCarriageBeltMount*2,xCarriageBeltMount,xBeltMountZdisplace], center = true);
			}
			*/
		}

		//Hotend cut-out:
		translate([0, 0, xCarriagePlatform-xCarExtGroove])
		rotate([0, 0, 270])
		#kJ(false);

		//X-rod 1:
		rotate ([0,90,0])
		translate(v = [0, -xRodDist/2, 0])
		cylinder(h = xCarriageLength+1, r=xLmDiameter/2-.5, center = true);

		//X-rod 2:
		rotate ([0,90,0])
		translate(v = [0, xRodDist/2, 0])
		cylinder(h = xCarriageLength+1, r=xLmDiameter/2-.5, center = true);

		//X-rod 1 LM-1:
		rotate ([0,90,0])
		translate(v = [0, -xRodDist/2, xCarriageLength/2-xLmLength/2-xCarriageLmEnd])
		#cylinder(h = xLmLength, r=xLmDiameter/2, center = true);

		//X-rod 1 LM-2:
		rotate ([0,90,0])
		translate(v = [0, -xRodDist/2, -xCarriageLength/2+xLmLength/2+xCarriageLmEnd])
		#cylinder(h = xLmLength, r=xLmDiameter/2, center = true);

		//X-rod 2 LM-3:
		rotate ([0,90,0])
		translate(v = [0, xRodDist/2, xCarriageLength/2-xLmLength/2-xCarriageLmEnd])
		#cylinder(h = xLmLength, r=xLmDiameter/2, center = true);

		//X-rod 2 LM-4:
		rotate ([0,90,0])
		translate(v = [0, xRodDist/2, -xCarriageLength/2+xLmLength/2+xCarriageLmEnd])
		#cylinder(h = xLmLength, r=xLmDiameter/2, center = true);

		//Z-rod Base cut-out 1:
		translate([-xCarriageLength/2, 0, xCarriageLift+xLmWall+xLmDiameter/2+xCarriageZ/2])
		cylinder(h = xCarriageZ+1, r=zRodSmooth/2+1, center = true);

		//Z-rod Base cut-out 2:
		translate([xCarriageLength/2, 0, xCarriageLift+xLmWall+xLmDiameter/2+xCarriageZ/2])
		cylinder(h = xCarriageZ+1, r=zRodSmooth/2+1, center = true);

		//Wires and cable tie cut-out:
		translate([-xCarriageLength/2, yBody/4, xCarriageLift+xLmWall+xLmDiameter/2+xCarriageZ/2])
		{
			translate([1, 0, 0])
			cylinder(h = xCarriageZ+1, r=3, center = true);
			
			for (i=[-1,1])
				translate([3, i*6, 0])
				cylinder(h = xCarriageZ+1, r=1.5, center = true, $fn=10);
			
		}
		
		//X-rod 1 round snap-fit:
		translate(v = [0, -xRodDist/2, -xLmSnap])
		rotate([0, 90, 0])
		cylinder(h = xCarriageLength+1, r=xLmSnap, center = true);
		
		//X-rod 2 round snap-fit:
		translate(v = [0, xRodDist/2, -xLmSnap])
		rotate([0, 90, 0])
		cylinder(h = xCarriageLength+1, r=xLmSnap, center = true);
		
/*		//fan mount
		translate([8, 0, xCarriagePlatform-xCarriageZ-0.1])
		rotate([180, 90, 0])
		fanMountFan();
*/
	}

	//experimental hotend fan duct
/*	translate([kJoffset()+2, 0, xCarriagePlatform-xCarriageZ-20])
	rotate([180, 90, 0])
	{
		fanMountPrimary();
		fanMountSecondary();
	}
*/
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
			translate(v = -[renderPartDistance, 0, 0])
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
			translate(v = [renderPartDistance, 0, 0])
			xBarEnds(n);
		}
	}
	if (n == 4)
	{
		if (renderPart == 4)
		{
			rotate([90, 180, 0])
			beltMount(1);		
		} else {
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
			translate([0, kissSizeY()/2, kissSizeZ()/2+kJSizeZ()+xCarriagePlatform])
			rotate([90, 90, 0])
			goKissD(); //MAXtruder();
		}
	}
	if (n == 7)
	{
		if (renderPart == 7)
		{
			rotate([180, 0, 0])
			fanMountSecondary();		
		} else {
			translate([8, 0, xCarriagePlatform-xCarriageZ])
			rotate([180, 90, 0])
			{
				//fanMountPrimary();
				fanMountSecondary();
				%fanMountFan();
			}
		}
	}
	if (n == 8)
	{
		if (renderPart == 8)
		{
			test();		
		} else {
			test();
		}
	}
}





// MAIN
if (renderPart == 0)
{
	showRods();
	for (pn = [1 : 6])
		render(pn);
} else {
	render(renderPart);
}
