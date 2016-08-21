use <KISS dualstruder.scad>;

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

function kissSizeY()	= kissY2(); //(for module compatibility :)
function kissSizeZ()	= kissZ; //(for module compatibility :)


jBodyLength				= 46;
jBodyDiameter			= 16;
jBodyCutZOffset			= 5;
jBodyCutZ				= 4.5;
jBodyCutDiameter		= 12;
jMountScrewDiameter		= 3;
jHeaterX				= 16;		// old=		new=16
jHeaterY				= 18;		// old=		new=18
jHeaterYOffset			= 3;		// old=		new=3
jHeaterZ				= 9.5;		// old=		new=9.5
jConeZ					= 2;
jConeDiameter			= 8;
jTipDiameter			= 2;
jTipZ					= 0.5;
jFilamentHoleDiameter	= 2;
jNozzleDiameter			= 0.4;
jRenderDetails			= 100;

$fn		= jRenderDetails;

module goKissD()
{
	goKiss();
}

module jHead(n, o, p)
				//when (n == false) => render part without bore (when used for subtraction)
				//when (o == 1) => translate to kissX output location | when (o == 0) => do not translate
				//when (p == 0) => normal | else p=extra value added to jBodyDiameter (for thru holes etc.)
{
	translate([o*kissHotendX, 0, 0.01])
	rotate([0, 180, 0.01])
	{
		difference()
		{
			union()
			{
				//body rim
				cylinder(h=jBodyCutZOffset, r=jBodyDiameter/2, center= false, $fn=jRenderDetails);

				//body neck
				translate([0, 0, jBodyCutZOffset-1])
				cylinder(h=jBodyCutZ+2, r=jBodyCutDiameter/2, center= false, $fn=jRenderDetails);

				//body main part
				translate([0, 0, jBodyCutZ+jBodyCutZOffset])
				cylinder(h=jBodyLength-jBodyCutZ-jBodyCutZOffset, r=jBodyDiameter/2+p, center= false, $fn=jRenderDetails);

				//heater:
				translate([-jHeaterX/2, -jHeaterY/2+jHeaterYOffset, jBodyLength])
				cube([jHeaterX, jHeaterY, jHeaterZ]);
			}

			//filament path
			if (n == true)
				translate([0, 0, -1])
				cylinder(h=jBodyLength+jHeaterZ+2, r=jFilamentHoleDiameter/2, center=false, $fn=jRenderDetails);
		}
		
		difference()
		{
			union()
			{
				//cone:
				translate([0, 0, jBodyLength+jHeaterZ])
				cylinder(h=jConeZ, r1=jConeDiameter/2, r2=jTipDiameter/2, center= false, $fn=jRenderDetails);

				//tip:
				translate([0, 0, jBodyLength+jHeaterZ+jConeZ])
				cylinder(h=jTipZ, r=jTipDiameter/2, center= false, $fn=jRenderDetails);
			}
			
			//nozzle
			translate([0, 0, jBodyLength+jHeaterZ-1])
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
		rotate([0, 0, 180])
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
//jHead(false, 0, 0);
//bowdenJAdapter(true, 0);
//bowdenKAdapter();

kJ(true);

//
