use <KISS dualstruder.scad>;
// use <nozzle_cooler.scad>;

jBodyLength				= 40;
jBodyDiameter			= 16;
jBodyCutZOffset			= 5;
jBodyCutZ				= 4.5;
jBodyCutDiameter		= 12;
jMountScrewDiameter		= 3;
jHeaterX				= 16;		//new=16
jHeaterY				= 18;		//new=18
jHeaterYOffset			= 3;		//new=3
jHeaterZ				= 9.4;		//new=9.4
jConeExtension			= 2.2;
jConeZ					= 2;
jConeDiameter			= 8;
jTipDiameter			= 2;
jTipZ					= 0.5;
jFilamentHoleDiameter	= 2;
jNozzleDiameter			= 0.4;
jRenderDetails			= 100;

$fn		= jRenderDetails;

// vars from KISS dualstruder.scad
kissX					= kissX();
kissY					= kissY();
kissZ					= kissZ();
kissRodLength			= kissRodLength();
kissRodDiameter			= kissRodDiameter();
kissHotendX				= kissHotendX();
kissHotendY				= kissHotendY();
kissHotendClear			= kissHotendClear();
kissHotendDepth			= kissHotendDepth();
kissMountX				= kissMountX();
kissMountY				= kissMountY();
kissMountClear			= kissMountClear();
kissFilament			= kissFilament();
kissMountScrDist		= kissMountScrDist();
kissMountScrLen			= kissMountScrLen();
kissMountScrClear		= kissMountScrClear();

//functions for module interoperability:
function kissSizeY()	= kissY2();
function kissSizeZ()	= kissZ;
function J_X()			= kissHotendX();
function J_Y()			= kissHotendY();
function cooler_off()	= bracket_off();
function cooler_dist()	= bracket_distance();
function jHead_d()		= jBodyDiameter;
function jHead_z()		= jBodyCutZ+jBodyCutZOffset;
function jHeadOffset()	= kissOffset();
function jBodyCut2TipZ()	= jBodyLength+jHeaterZ+jConeExtension+jConeZ+jTipZ-jBodyCutZOffset-jBodyCutZ;


module extruder_cooler()
{
	cooler();
}


module goKissD()
{
	goKiss();
}


module jHeadDummy(clearance=0)
{
	rotate([0, 180, 0])
	color("DimGray")
	{
		//body rim
		cylinder(h=jBodyCutZOffset+clearance, r=jBodyDiameter/2+clearance, center= false, $fn=jRenderDetails);

		//body neck
		translate([0, 0, jBodyCutZOffset-1])
		cylinder(h=jBodyCutZ+2, r=jBodyCutDiameter/2+clearance, center= false, $fn=jRenderDetails);

		//no-go
		translate([0, 0, jBodyCutZOffset+jBodyCutZ])
		cylinder(h=10, r=50, center= false);
	}
}


module jHead(n, o, p)
	// when (n == false) => render part without bore (when used for subtraction)
	// when (o == 1) => translate to kissX output location | when (o == 0) => do not translate
	// when (p == 0) => normal | else p=extra value added to jBodyDiameter (for thru holes etc.)
{
	translate([o*kissHotendX, 0, 0.01])
	rotate([0, 180, 0])
	{
		difference()
		{
			union()
			{
				color("DimGray")
				{
					//body rim
					cylinder(h=jBodyCutZOffset, r=jBodyDiameter/2, center= false, $fn=jRenderDetails);

					//body neck
					translate([0, 0, jBodyCutZOffset-1])
					cylinder(h=jBodyCutZ+2, r=jBodyCutDiameter/2, center= false, $fn=jRenderDetails);

					//body main part
					translate([0, 0, jBodyCutZ+jBodyCutZOffset])
					cylinder(h=jBodyLength-jBodyCutZ-jBodyCutZOffset, r=jBodyDiameter/2+p, center= false, $fn=jRenderDetails);
				}

				//heater:
				color("Silver")
				translate([-jHeaterX/2, -jHeaterY/2+jHeaterYOffset, jBodyLength])
				cube([jHeaterX, jHeaterY, jHeaterZ]);
			}

			//filament path
			if (n == true)
				translate([0, 0, -1])
				cylinder(h=jBodyLength+jHeaterZ+jConeExtension+2, r=jFilamentHoleDiameter/2, center=false, $fn=jRenderDetails);
		}

		difference()
		{
			union()
			{
				//cone:
				//ConeExtension
				translate([0, 0, jBodyLength+jHeaterZ])
				cylinder(h=jConeExtension, r=jConeDiameter/2, center= false, $fn=jRenderDetails);

				translate([0, 0, jBodyLength+jHeaterZ+jConeExtension])
				cylinder(h=jConeZ, r1=jConeDiameter/2, r2=jTipDiameter/2, center= false, $fn=jRenderDetails);

				//tip:
				translate([0, 0, jBodyLength+jHeaterZ+jConeExtension+jConeZ])
				cylinder(h=jTipZ, r=jTipDiameter/2, center= false, $fn=jRenderDetails);
			}

			//nozzle
			translate([0, 0, jBodyLength+jConeExtension+jHeaterZ-1])
			cylinder(h=jConeZ+jTipZ+2, r=jNozzleDiameter/2, center= false, $fn=jRenderDetails);
		}
	}
}


bowdenRenderDetails			= 25;
bowdenBaseMountDistance		= 25;
bowdenBaseMountHoleDiameter	= 3+.2;
bowdenBaseHeight			= 3;
bowdenBaseMountHoleLength	= 1+bowdenBaseHeight;
bowdenTubeOuterDiameter		= 4+.5;
bowdenTubeSupportLength		= 2*bowdenBaseMountHoleDiameter;
bowdenNutEdgeDiameter		= 8;
bowdenNutHeight				= 3.1;

bowdenMainBodyDiameter		= jBodyCutDiameter+jMountScrewDiameter*3;
bowdenOffset				= jBodyCutZOffset+bowdenBaseMountHoleDiameter*1.5+bowdenBaseHeight;

module bowdenJAdapter(n, j)
//if (n == true) => render part for printing | if (n == false) => render part without bore (mockup mode for subtraction etc)
{
	translate([0, 0, bowdenOffset])
	difference()
	{
		union()
		{
			//main body cylinder:
			translate([0, 0, bowdenNutHeight])
			rotate([180,0 ,0])
			cylinder(h=bowdenNutHeight+bowdenOffset, r=bowdenMainBodyDiameter/2, center=false, $fn=bowdenRenderDetails*2);

			//bowden tube support:
			translate([0, 0, bowdenNutHeight])
			cylinder(h=bowdenTubeSupportLength+1, r1=bowdenMainBodyDiameter/2, r2=bowdenTubeOuterDiameter/2, center=false, $fn=bowdenRenderDetails);

			//J-head mounting screw bases:
			for (z = [-1,1])
				translate([z*(jBodyCutDiameter/2+jMountScrewDiameter/2), 0, -jBodyCutZOffset-jMountScrewDiameter/2])
				{
					rotate([90, 0, 0])
					cylinder(h=bowdenMainBodyDiameter, r=jMountScrewDiameter, center=true, $fn=bowdenRenderDetails);
					translate([-jMountScrewDiameter, -bowdenMainBodyDiameter/2, -jMountScrewDiameter-1])
					cube([jMountScrewDiameter*2, bowdenMainBodyDiameter, jMountScrewDiameter+1], center=false);
				}

			//base plate
			translate([0, 0, bowdenBaseHeight/2-bowdenOffset])
			cube([bowdenMainBodyDiameter, bowdenBaseMountDistance+bowdenBaseMountHoleDiameter*2, bowdenBaseHeight], center = true);

			//additional support for mounting screws:
			for (z = [-1,1])
				translate([0, z*bowdenBaseMountDistance/2, -bowdenOffset])
				cylinder(h=bowdenBaseMountHoleLength, r=bowdenBaseMountHoleDiameter, center=false, $fn=bowdenRenderDetails);

			//bowden mount screws:
			if (n == false)
				for (z = [-1,1])
					translate([0, z*bowdenBaseMountDistance/2, 1+bowdenBaseMountHoleLength-bowdenOffset])
					rotate([180, 0, 0])
					cylinder(h=bowdenBaseMountHoleLength*4, r=bowdenBaseMountHoleDiameter/2, center=false, $fn=bowdenRenderDetails);

			if (n == false)
			{
				//J-Head:
				jHead(false, 0, j);

			}
		}

		if (n)
		{
			union()
			{
				//bowden tube hole:
				translate([0, 0, bowdenNutHeight-1])
				cylinder(h=40+1, r=bowdenTubeOuterDiameter/2, center=false, $fn=bowdenRenderDetails);

				//nut trap;
				translate([0, 0, bowdenNutHeight])
				rotate([180, 0, 90])
				cylinder(h=bowdenNutHeight+1, r=bowdenNutEdgeDiameter/2, center=false, $fn=6);

				//J-Head:
				jHead(false, 0, 0);

				//J-head mounting screws:
				for (z = [-1,1])
					translate([z*(jBodyCutDiameter/2+jMountScrewDiameter/2), 0, -jBodyCutZOffset-jMountScrewDiameter/2])
					rotate([90, 0, 0])
					cylinder(h=bowdenMainBodyDiameter+2, r=jMountScrewDiameter/2, center=true, $fn=bowdenRenderDetails);

				//bowden mount holes:
				for (z = [-1,1])
					translate([0, z*bowdenBaseMountDistance/2, -1-bowdenOffset])
					cylinder(h=bowdenBaseMountHoleLength+2, r=bowdenBaseMountHoleDiameter/2, center=false, $fn=bowdenRenderDetails);

				//bowden mount body cutout (for small instances of bowdenBaseMountDistance below about 27):
				for (z = [-1,1])
					translate([0, z*bowdenBaseMountDistance/2, -bowdenOffset+bowdenBaseMountHoleLength])
					rotate([0, 0, 0])
					cylinder(h=bowdenOffset+bowdenBaseMountHoleLength, r=bowdenBaseMountHoleDiameter, center=false, $fn=bowdenRenderDetails);

				translate([-25, 0, -1-bowdenOffset])
				cube([50, 50, 100], center=false);
			}
		}
	}
}


module bowdenKAdapter()
{
	difference()
	{
		//bowden base:
		cylinder(h=kissHotendDepth, r=(kissHotendClear+1)/2, center=false, $fn=bowdenRenderDetails);

		union()
		{
			//bowden tube hole:
			translate([0, 0, kissHotendDepth/2])
			cylinder(h=kissHotendDepth+1, r=(bowdenTubeOuterDiameter+1)/2, center=true, $fn=bowdenRenderDetails);			//nut trap;

			translate([0, 0, kissHotendDepth-bowdenNutHeight])
			#cylinder(h=bowdenNutHeight+1, r=(bowdenNutEdgeDiameter+1)/2, center=false, $fn=6);
		}
	}
}

module jHeadShow(){
	translate([0 ,-kissOffset(), kJHeight])
	rotate([0, 0, 90])
	jHead(true, 0, 0);

}


/* vars from kiss dualstruder:
kissOffset()
kissDepth()
kissHeight()
kissMountHoleDiameter()
kissMountHoleDistance()
*/
kissMountHoleRadius	= kissMountHoleDiameter()/2;
kJLength			= 27;
kJHeight			= jBodyCutZ+jBodyCutZOffset;
kJMotorSupportWidth	= 0.75*kissHeight();

function kJSizeZ()	= kJHeight; //(for module compatibility :)

module kJ(n)
//if (n == true) => render part for printing | if (n == false) => render part without bore (mockup mode for subtraction etc)
{
	difference()
	{
		union()
		{
			translate([-kissDepth()/1.5, -(kissMountHoleDistance()/2+kissMountHoleDiameter()), 0])
			cube([kissDepth()*1.5, kissMountHoleDistance()+kissMountHoleDiameter()*2, kJHeight], center=false);

			translate([kissDepth()/2, -kJMotorSupportWidth/2, 0])
			cube([kJLength, kJMotorSupportWidth, kJHeight], center=false);
		}

		union()
		{
		//%	translate([-kissDepth()/2, 0, kissHeight()/2+kJHeight])
		//	rotate([0,90,0])
		//	goKiss();

			translate([0 ,-kissOffset(), kJHeight])
			rotate([0, 0, 180])
			jHead(false, 0, 0);

			//mounting plate holes
			translate([0, kissMountHoleDistance()/2, 0])
			cylinder(h=kJHeight*3, r=kissMountHoleRadius, center=true, $fn=jRenderDetails);

			translate([0, -kissMountHoleDistance()/2, 0])
			cylinder(h=kJHeight*3, r=kissMountHoleRadius, center=true, $fn=jRenderDetails);

			//body rim
			translate([-kissDepth(), -kissOffset()-jBodyDiameter/2,  jBodyCutZOffset-0.5])
			cube([kissDepth(), jBodyDiameter, jBodyCutZOffset+1], center= false);

			//body neck opening
			translate([-kissDepth(), -kissOffset()-jBodyCutDiameter/2, -1])
			cube([kissDepth(), jBodyCutDiameter, jBodyCutZ+2], center= false);

			//locking bar
			translate([-jBodyCutDiameter/2-kissMountHoleRadius, 0, kJHeight-jBodyCutZOffset-kissMountHoleRadius])
			rotate([90, 0, 0])
			cylinder(h=kissMountHoleDistance()*2, r=kissMountHoleRadius ,center=true, $fn=jRenderDetails);

			translate([jBodyCutDiameter/2+kissMountHoleRadius, 0, kJHeight-jBodyCutZOffset-kissMountHoleRadius])
			rotate([90, 0, 0])
			cylinder(h=kissMountHoleDistance()*2, r=kissMountHoleRadius ,center=true, $fn=jRenderDetails);
		}
	}
	if (n == false)
	{
//		translate([-kissDepth()/2, 0, kissHeight()/2+kJHeight])
//		rotate([0,90,0])
//		goKiss();

		translate([0 ,-kissOffset(), kJHeight])
		rotate([0, 0, 270])
		jHead(false, 0, 1);

		translate([0, kissMountHoleDistance()/2, 0])
		cylinder(h=kJHeight*3, r=kissMountHoleRadius, center=true, $fn=jRenderDetails);

		translate([0, -kissMountHoleDistance()/2, 0])
		cylinder(h=kJHeight*3, r=kissMountHoleRadius, center=true, $fn=jRenderDetails);
	}
}



//

function kJoffset() = kissOffset();

function bowdenWidth() = bowdenMainBodyDiameter;


//kiss(false);

jHead(false, 0, 0);
//bowdenJAdapter(true, 0);
//bowdenKAdapter();

//kJ(true);

cube([0, 0, 0]);