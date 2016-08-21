// Thanks and credits to Peter Bøgely (reprap.me) for
// inventing and selling me his KISS Extruder in the first place.
// Dual-version: idea, redesign and OpenSCAD programming by Martin Axelsen
// I didnt have Peter's original source file, so I rewrote the whole thing from scratch.



//functions (works as global constant for parent script)
function kissX()				= xMotorWidth;
function kissY()				= xMotorHeight+kissHeight;
function kissY2()				= kissHeight;
function kissZ()				= xMotorWidth;
function kissRodLength()		= motorRodLength-kissHeight;
function kissRodDiameter()		= xMotorRod;
function kissHotendX()			= kissOffset();
function kissHotendY()			= 0;
function kissHotendClear()		= 10;
function kissHotendDepth()		= 0;
function kissMountX()			= 9.5;
function kissMountY()			= 14.5;
function kissMountClear()		= mountHoleDiameter;
function kissFilament()			= filamentDiameter+filamentDeformation;
function kissMountScrDist()		= mountDistance;
function kissMountScrLen()		= 20;
function kissMountScrClear()	= mountHoleDiameter;



/*** CONSTANTS SETUP ***/
mountDistance			= 48;		//
mountHoleDiameter		= 3.2;		//
mountBracketHeight		= 6;		//
mounthexHoleDiameter	= 6.7;

rotatingClearance		= 1;		// rotating parts perimeter clearance
lockFit					= 0.75;		// plastic diameter reduction for bearing screw (snap-fit without a bolt)
filamentDeformation		= 0.4;		// filament pressure diameter reduction					*** INCORPORATE ***
filamentDiameter		= 1.75 - filamentDeformation;	// filament diameter
filamentClearance		= 0.75 + filamentDeformation;	// extra diameter
kissHeight				= 16;		// KISS box height, also determines length of bearing & motor screws

cylinderSmallDetails	= 30;	
cylinderLargeDetails	= 60;	

// 624ZZ Bearing			Overview at http://www.thebigbearingstore.com/servlet/Page?template=600%20radial%20ball%20bearings
bearingInnerDia			= 4;		// bearing support diameter
bearingDiameter			= 13;		// bearing diameter
bearingHeight			= 5;		// bearing height
bearingClearance		= 1;		// bearing outer radius clearance and extra height

// NEMA 17 Stepper Motor
xMotorMount				= 3.2;		// motor mount hole diameter
xMotorHoleDist			= 31;		// motor mount hole distance
xMotorRod				= 5;		// motor rod diameter
xMotorWidth				= 42;		// size of motor on x and y-axis
xMotorHeight			= 39;		// size of motor on z-axis
xMotorCutoutD			= 22;		// motor center ring diameter
xMotorCutoutH			= 2;		// motor center ring height
zMount					= 20;		// length of motor mounting screws
motorRodLength			= 24;		// length of motor rod

// Drive Gear Pulley
hobbedOffset			= 0;		// pulley hobbed groove, filament, bearings and mounting axis offset
hobbedLength			= 14;		// pulley axis length (MK7=14 | MK8=11)
hobbedDiameterOut		= 12.5;		// pulley outer diameter (MK7=12.5 | MK8=11)
hobbedDiameterIn		= 10.56;	// pulley hobbed groove valley diameter (MK7=10.56 | MK8=6.7)



hobbedRadiusIn			= hobbedDiameterIn/2;
bearingRadius			= bearingDiameter/2;




function kissOffset() = (filamentDiameter+hobbedDiameterIn)/2;
function kissDepth() = kissHeight;
function kissHeight() = xMotorWidth;
function kissMountHoleDiameter() = mountHoleDiameter;
function kissMountHoleDistance() = mountDistance;

echo();
echo("Use screws and bolts:");
echo("Motor screws: 4 pcs. of metric diameter M[mm], thread length [mm]", xMotorMount, kissHeight+xMotorMount);
echo("Bearing screws: 2 pcs. of metric diameter M[mm], thread length [mm]", bearingInnerDia, kissHeight);
echo();

/*** MODULES ***/

//KISS extruder box
module kiss(filamentDiameter, filamentOffset, bearingOffset)
{
	translate(v=[0, 0, kissHeight/2])
	{
		
		
		//bearing axis 1
		difference()
		{
			translate(v=[0, bearingOffset, -kissHeight/2-1])
			hull()
			{
				rotate([-5, 0, 0])
				cylinder(h = kissHeight+2, r1 = (bearingInnerDia-lockFit)/2, r2 = (bearingInnerDia-lockFit)/2+0.5, center = false, $fn=cylinderSmallDetails);
				
				rotate([5, 0, 0])
				cylinder(h = kissHeight+2, r1 = (bearingInnerDia-lockFit)/2, r2 = (bearingInnerDia-lockFit)/2+0.5, center = false, $fn=cylinderSmallDetails);
			}
			
			//artificial overhang
			translate(v=[0, bearingOffset, hobbedOffset-(bearingHeight+bearingClearance)/2])
			rotate([180, 0, 0])
			cylinder(h = .25, r = 3, center = false);
		}
		
		//bearing axis 2
		difference()
		{
			translate(v=[0, -bearingOffset, -kissHeight/2-1])
			hull()
			{
				rotate([-5, 0, 0])
				cylinder(h = kissHeight+2, r1 = (bearingInnerDia-lockFit)/2, r2 = (bearingInnerDia-lockFit)/2+0.5, center = false, $fn=cylinderSmallDetails);
				
				rotate([5, 0, 0])
				cylinder(h = kissHeight+2, r1 = (bearingInnerDia-lockFit)/2, r2 = (bearingInnerDia-lockFit)/2+0.5, center = false, $fn=cylinderSmallDetails);
			}
			
			//artificial overhang
			translate(v=[0, -bearingOffset, hobbedOffset-(bearingHeight+bearingClearance)/2])
			rotate([180, 0, 0])
			cylinder(h = .25, r = 3, center = false);
		}

		
		translate([0, 0, hobbedOffset])
		union()
		{

			//filament hole 1
			translate(v=[0, filamentOffset, 0])
			rotate([0, 90, 0])
			%cylinder(h = xMotorWidth*2, r=filamentDiameter/2, center = true, $fn=cylinderSmallDetails);

			translate(v=[0, filamentOffset, 0])
			rotate([0, 90, 0])
			cylinder(h = xMotorWidth*2, r=filamentDiameter/2+filamentClearance/2, center = true, $fn=cylinderSmallDetails);
			
/*			//filament hole 2
			translate(v=[0, -filamentOffset, 0])
			rotate([0, 90, 0])
			%cylinder(h = xMotorWidth*2, r=filamentDiameter/2, center = true, $fn=cylinderSmallDetails);
*/
			translate(v=[0, -filamentOffset, 0])
			rotate([0, 90, 0])
			cylinder(h = xMotorWidth*2, r=filamentDiameter/2+filamentClearance/2, center = true, $fn=cylinderSmallDetails);
			
			//bearing hole 1
			translate(v=[0, bearingOffset, 0])
			%cylinder(h = bearingHeight, r = bearingDiameter/2, center = true, $fn = cylinderLargeDetails);

			translate(v=[0, bearingOffset, 0])
			cylinder(h = bearingHeight+bearingClearance, r = bearingDiameter/2+bearingClearance, center = true, $fn = cylinderLargeDetails);

			translate(v=[-bearingDiameter/2-bearingClearance, xMotorWidth/2-(xMotorWidth/2-bearingOffset), -bearingHeight/2-bearingClearance/2])
			cube([(bearingDiameter+bearingClearance*2), xMotorWidth/2-bearingOffset+1, bearingHeight+bearingClearance], center = false);
			
			//bearing hole 2
			translate(v=[0, -bearingOffset, 0])
			%cylinder(h = bearingHeight, r = bearingDiameter/2, center = true, $fn = cylinderLargeDetails);

			translate(v=[0, -bearingOffset, 0])
			cylinder(h = bearingHeight+bearingClearance, r = bearingDiameter/2+bearingClearance, center = true, $fn = cylinderLargeDetails);

			translate(v=[-bearingDiameter/2-bearingClearance, -1-xMotorWidth/2, -bearingHeight/2-bearingClearance/2])
			cube([bearingDiameter+bearingClearance*2, xMotorWidth/2-bearingOffset+1, bearingHeight+bearingClearance], center = false);
		}
	}
}


module nema()
{
	//hobbed pulley outer diameter:
	translate(v = [0, 0, xMotorCutoutH-1])
	cylinder(h = hobbedLength+20, r = hobbedDiameterOut/2+rotatingClearance, center = false, $fn=cylinderLargeDetails);

	//hobbed pulley effective diameter:
	translate(v = [0, 0, xMotorCutoutH-1])
	%cylinder(h = hobbedLength+1, r = hobbedDiameterIn/2, center = false, $fn=cylinderLargeDetails);
	
	//motor ring:
	translate(v = [0, 0, xMotorCutoutH])
	rotate([180,0,0])
	cylinder(h = xMotorCutoutH+1, r = xMotorCutoutD/2+0.5, center = false, $fn = cylinderLargeDetails);
	
	//motor mount 1:
	translate(v = [-xMotorHoleDist/2, xMotorHoleDist/2, -1])
	cylinder(h = zMount, r = xMotorMount/2, center = false, $fn = cylinderSmallDetails);
	
	//motor mount 2:
	translate(v = [xMotorHoleDist/2, xMotorHoleDist/2, -1])
	cylinder(h = zMount, r = xMotorMount/2, center = false, $fn = cylinderSmallDetails);
	
	//motor mount 3:
	translate(v = [-xMotorHoleDist/2, -xMotorHoleDist/2, -1])
	cylinder(h = zMount, r = xMotorMount/2, center = false, $fn = cylinderSmallDetails);
	
	//motor mount 4:
	translate(v = [xMotorHoleDist/2, -xMotorHoleDist/2, -1])
	cylinder(h = zMount, r = xMotorMount/2, center = false, $fn = cylinderSmallDetails);
}


/*** MAIN ***/
module goKiss()
{
	translate([0, 0, kissHeight])
	rotate([180,0,0])
	difference()
	{
		union()
		{
			// main body
			translate(v=[0, 0, kissHeight/2])
			cube(size = [xMotorWidth, xMotorWidth, kissHeight], center = true);
			
			// bracket
			translate([xMotorWidth/2-mountBracketHeight/2, 0, kissHeight/2])
			cube([mountBracketHeight, mountDistance+mountHoleDiameter*2-1, kissHeight], center=true);
		}
		
		translate([xMotorWidth/2-mountBracketHeight, 0, kissHeight/2+hobbedOffset])
		union()
		{
			// bracket hole 1
			translate(v=[mountBracketHeight/2, -mountDistance/2, 0])
			rotate([0, 90, 0])
			cylinder(h = mountBracketHeight+1, r = mountHoleDiameter/2, center = true, $fn=cylinderSmallDetails);

			// bracket hole 2
			translate(v=[mountBracketHeight/2, mountDistance/2, 0])
			rotate([0, 90, 0])
			cylinder(h = mountBracketHeight+1, r = mountHoleDiameter/2, center = true, $fn=cylinderSmallDetails);

			// bracket screw carving 1
			translate(v=[1, -mountDistance/2, 0])
			rotate([0, 90, 180])
			cylinder(h = xMotorWidth/2, r = mounthexHoleDiameter/2, center = false, $fn=6);

			// bracket screw carving 2
			translate(v=[1, mountDistance/2, 0])
			rotate([0, 90, 180])
			cylinder(h = xMotorWidth/2, r = mounthexHoleDiameter/2, center = false, $fn=6);
		}
		
/*		translate([0, 0, kissHeight])
		rotate([180, 0, 0])
		nema();
*/		
		nema();
		for (i = [filamentDiameter, filamentDiameter]) {					//or use: 	for (i = filamentDiameter) or [1.75, 3.00])
			diameter = i;
			radius = i/2;
			fOffset = hobbedRadiusIn+radius;
			bOffset = hobbedRadiusIn+diameter+bearingRadius;

			kiss(diameter, fOffset, bOffset);
			//echo("Filament diameter [mm], offset [mm]", diameter + filamentDeformation, kissOffset());
		}
	}
	echo();
}

goKiss();

