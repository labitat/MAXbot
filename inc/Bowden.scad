include <MCAD/nuts_and_bolts.scad>
include <MCAD/bearing.scad>
use <extruders.scad>

//bowden_feeder(single=false);
//bowden_hotend_parts();
bowden_hotend_main(mockup_clr=0);			// omit mockup_clr for normal printing mode
//bowden_hotend_dual(mockup_clr=0.2);		// set mockup_clr>0 for mockup mode eg. (mockup_clr=0.2)
//bowden_hotend_triple(mockup_clr=0.2);

//consts:
$fn					= 50;
filament_d			= 1.75;
filament_hole_d		= 2;
tube_d				= 5;
nut_size			= 5;			// metric size (5 goes for M5, that will fit on a 5mm OD tube with a little will and an exacto knife)
render_length		= 50;
overhang_h			= 0.2;			// partial overhang eliminator (set at desired printing layer height)

nutntube_offset		= 2;

hotend_mount_dist	= 17;

MK_eff_d			= 10.56;		// Drive gear effective diameter (MK7=10.56 or MK8=7)
MK_ext_d			= 13;			// Drive gear external diameter
MK_hgt				= 10;

bearing_model		= 624;

motorMountDia		= 3+0.2;		// motor mount screw hole diameter (NEMA17=3)
motorMountDist		= 31;			// motor mount screw hole distance (NEMA17=31)
motorWidth			= 42.3;			// size of motor measured on x and y-axis (NEMA17=42.3)
motorHeight			= 47;			// size of motor measured on z-axis (NEMA17=47)
motorCutoutD		= 22 +1;		// motor center ring diameter (NEMA17=22) (+1 for clearance)
motorCutoutH		= 2;			// motor center ring height (NEMA17=2)
motorRod			= 5 +1;			// motor axis diameter (NEMA17=5) (+1 for clearance)
motorRodLength		= 22.5;			// motor axis length (NEMA17=22.5)

//calculations:
motor_sides			= motorWidth;
motor_bolt_dist		= motorMountDist;
motor_bolt_d		= motorMountDia;

nut_thickness		= METRIC_NUT_THICKNESS[nut_size];
tube_r				= tube_d/2;
filament_r			= filament_d/2;
filament_y_offset	= nut_thickness;
filament_offset		= MK_eff_d/2+filament_r;
bearing_ir			= bearingDimensions(bearing_model)*[1, 0, 0]/2;
bearing_or			= bearingDimensions(bearing_model)*[0, 1, 0]/2;
bearing_h			= bearingDimensions(bearing_model)*[0, 0, 1];
bearing_offset		= filament_r+filament_offset+bearing_or;

box_round			= (motor_sides-motor_bolt_dist)/2-0.85;
box_hgt				= max(METRIC_NUT_AC_WIDTHS[nut_size], bearing_h)*2;
motor_bolt_length	= 20;

z_offset			= 2;



//modules


module bowden_hotend_parts()
{
	difference()
	{
		bowden_hotend_main();

		parter();
	}


	translate([2, 0, 0])
	intersection()
	{
		bowden_hotend_main();

		parter();
	}
}


module parter()
{
	rotate([0, 0, 180])
	translate([-25, 0, 0])
	cube([50, 50, 500], center=true);
}


module bowden_hotend_main(mockup_clr=0, clr_int=0.2)	// external & internal clearance setting
{
	mountD		= 3;										// mounting and assembly screws diameter
	wallWidth	= 2;										// partly wall around springs
	springR		= METRIC_NUT_AC_WIDTHS[mountD]/2+clr_int;	// radius of chosen spring must be less than this
	springH		= 4;										// spring hole length
	conWasherR	= 3.5;										// conical washer radius
	radius1		= 13;										// main hole radius
	radius2 	= 5;										// top radius
	radius3 	= conWasherR+wallWidth;						// triangle round corners (washer radius)
	plateH		= 8;										// triangle height
	asmOffZ		= METRIC_NUT_AC_WIDTHS[mountD]/2+overhang_h;	// assemply screws Z offset
	asmOffY		= METRIC_NUT_AC_WIDTHS[nut_size]/2+COURSE_METRIC_BOLT_MAJOR_THREAD_DIAMETERS[mountD]/2+0.6;		// assemply screws Y offset
	asmOffX		= 5;										// assemply screws X offset
	mainRimOffZ	= 5;										// tower roof offset
	mainHeight	= nutntube_offset+METRIC_NUT_THICKNESS[nut_size]+(9-mainRimOffZ);
	cableWidth	= 11;										// cable harness width

	if (mockup_clr == 0)
	translate([0, 0, jHead_z()])
	difference()
	{
		union()
		{
			hull()
			{
				translate([0, 0, -jHead_z()])
				cylinder(h=jHead_z()+mainRimOffZ, r=radius1);

				translate([0, 0, mainRimOffZ])
				cylinder(h=mainHeight, r1=radius1, r2=radius2);
			}

			translate([0, 0, mainRimOffZ])
			cylinder(h=mainHeight, r=radius2+4);

			//carriage mount&leveling plate
			if (mockup_clr == 0)
			hull()
			{
				for (i = [0, 120, 240])
				rotate([0, 0, i])
				translate([hotend_mount_dist, 0, -jHead_z()])
				cylinder(h=plateH+0.1, r=radius3);
			}

			/*
			//assembly screw reinforcement
			for (i = [0, 1])
			mirror([0, i, 0])
			translate([0, asmOffY, asmOffZ])
			rotate([0, 90, 0])
			cylinder(h=(asmOffX+METRIC_NUT_THICKNESS[mountD])*2, r=4.5, center=true);
			*/
		}

		translate([0, 0, nutntube_offset-clr_int])
		nutntube(clearance=clr_int);

		jHeadDummy(clearance=clr_int);

		//cut1 for wires
		translate([-radius1, 0, -jHead_z()])
		rotate([0, -35, 0])
		cube([9, cableWidth, 50], center=true);

		//cut2 for wires
		translate([-radius1, 0, 0])
		cube([5, cableWidth, 50], center=true);

		//cut3 for wires
		translate([-nut_size, -cableWidth/2, mainRimOffZ+0.5*mainHeight])
		rotate([0, 220, 0])
		cube([5, cableWidth, 50], center=false);

		//cut4 for wires
		translate([-nut_size, cableWidth/2, mainRimOffZ+0.5*mainHeight])
		rotate([0, 0, 180])
		cube([5, cableWidth, 50], center=false);

		//assembly screw holes
		for (i = [0, 1])
		mirror([0, i, 0])
		translate([0, asmOffY, asmOffZ])
		rotate([0, 90, 0])
		{
			//screw thread holes
			cylinder(h=50, r=(mountD+0.5)/2, center=true);

			union()
			{
				//screw head recession
				translate([0, 0, asmOffX])
				cylinder(h=20, r=METRIC_NUT_AC_WIDTHS[mountD]/2);

				//conical recessed nuts
				rotate([180, 0, 0])
				translate([0, 0, asmOffX])
				rotate([0, 0, 90])
				union()
				{
					scale([0.99, 0.99, 10])
					nutHole(mountD);

					//removal of resulting unwanted overhang
					translate([METRIC_NUT_AC_WIDTHS[mountD]/2, 0, METRIC_NUT_THICKNESS[mountD]])
					rotate([0, 0, 90])
					cube([1, 1, 1]*METRIC_NUT_AC_WIDTHS[mountD]);
				}
			}
		}


		//carriage mount+leveling plate holes
		for (i = [0, 120, 240])
		rotate([0, 0, i])
		translate([hotend_mount_dist, 0, -jHead_z()])
		{
			translate([0, 0, -1])
			cylinder(h=plateH+2, r=(mountD+0.5)/2+clr_int);

			if (mockup_clr == 0)
			{
				//spring clearance
				translate([0, 0, plateH-springH])
				cylinder(h=springH+0.1, r1=springR+clr_int, r2=conWasherR+clr_int);

				translate([0, 0, plateH+0*radius3+springR+clr_int-springH])
				rotate([0, 45, 0])
				difference()
				{
					cylinder(h=2*springH, r=2*springH);

					rotate([0, -90, 0])
					translate([0, 0, 2*(2*clr_int+conWasherR-springR)])
					cylinder(h=2*springH, r=3*springH);
				}
			}
		}

		//perimeter cleanup
		translate([0, 0, plateH-jHead_z()])
		{
			difference()
			{
				cylinder(h=20, r=2*radius1);

				translate([0, 0, -1])
				cylinder(h=22, r=radius1);
			}
		}
	}

	//added details
	if (mockup_clr == 0)
	translate([0, 0, jHead_z()])
	{
		//overhang support
		cylinder(h=overhang_h, r=jHead_d()/2);

		//overhang support
		translate([0, 0, nutntube_offset+METRIC_NUT_THICKNESS[nut_size]])
		cylinder(h=overhang_h, r=nut_size);
	}

	//extras (mockup mode only)
	if (mockup_clr != 0)
	{
		//main hole
		hull()
		{
			hull()
			{
				cylinder(h=50, r=radius1+mockup_clr, center=true);

				//safe overhang
				cube([10, 2*(radius1+mockup_clr), 50], center=true);
			}

			//wire cutout
			translate([-radius1, 0, 0])
			cylinder(h=50, r=cableWidth/2+mockup_clr, center=true);
		}

		//mounting screw holes
		for (i = [0, 120, 240])
		rotate([0, 0, i])
		translate([hotend_mount_dist, 0, 0])
		cylinder(h=50, r=(mountD+mockup_clr)/2, center=true);
	}
}


module bowden_hotend_dual(mockup_clr, clr_int, nutOffset)
{
	translate([-8, -13, 0])
	bowden_hotend_main(mockup_clr, clr_int, nutOffset);

	translate([8, 13, 0])
	rotate([0, 0, 180])
	bowden_hotend_main(mockup_clr, clr_int, nutOffset);
}


module bowden_hotend_triple(mockup_clr, clr_int, nutOffset)
{
	translate([-11, 21, 0])
	bowden_hotend_main(mockup_clr, clr_int, nutOffset);

	translate([11, 0, 0])
	rotate([0, 0, 180])
	bowden_hotend_main(mockup_clr, clr_int, nutOffset);

	translate([-11, -21, 0])
	bowden_hotend_main(mockup_clr, clr_int, nutOffset);
}


module motor()
{
	tol = 0; //tolerance

	{
		//motor rod:
		translate([0, 0, -1])
		cylinder(h = motorRodLength+motorCutoutH+1, r = motorRod/2);

		//motor ring:
		translate([0, 0, -1])
		cylinder(h = motorCutoutH+1, r = motorCutoutD/2);

		//motor base:
		translate([-motorWidth/2-tol/2, motorWidth/2+tol/2, 0])
		rotate([180,0,0])
		cube(size = [motorWidth+tol, motorWidth+tol, motorHeight]);

		//motor mountings
		for (ix = [-1, 1])
		for (iy = [-1, 1])
		translate([ix*motorMountDist/2, iy*motorMountDist/2, -3])
		{
			cylinder(h = motor_bolt_length+1, r = motorMountDia/2);

			translate([0, 0, motor_bolt_length])
			cylinder(h=METRIC_NUT_THICKNESS[3], r=METRIC_NUT_AC_WIDTHS[3]/2);
		}
	}
}


module nutntube(clearance=0)
{
	//filament
	color("Blue")
	cylinder(h=2*render_length, r=filament_r, center=true);

	//bowden tube extension
	color("white")
	translate([0, 0, -5])
	cylinder(h=6, r=tube_r+clearance);

	//recess nut
	color("Silver")
	nutHole(nut_size, tolerance=clearance);

	//bowden tube
	translate([0, 0, nut_thickness/2])
	color("Black")
	cylinder(h=render_length, r=tube_r+clearance);
}


module bowden_feeder(single=false)
{
	translate([0, 0, motor_sides/2])
	rotate([0, 90, 0])
	{
		difference()
		{
			union()
			{
				//tube side
				translate([filament_offset, -motor_sides/2+3*filament_y_offset/2, 0])
				cylinder(h=box_hgt, r=3*filament_y_offset/2);

				translate([filament_offset, -motor_sides/2, 0])
				cube([motor_sides/2-filament_offset, motor_sides/2, box_hgt]);

				if (single == true)
				{
					//open side
					translate([motor_sides/2-box_round, 0, 0])
					cube([box_round, motor_sides/2, box_hgt]);

					translate([motor_sides/2-2*box_round, 0, 0])
					cube([2*box_round, motor_sides/2-box_round, box_hgt]);

					translate([motor_sides/2-box_round, motor_sides/2-box_round, 0])
					cylinder(h=box_hgt, r=box_round);
				} else
				{
					//tube side 2
					translate([filament_offset, -(-motor_sides/2+3*filament_y_offset/2), 0])
					cylinder(h=box_hgt, r=3*filament_y_offset/2);

					translate([filament_offset, 0, 0])
					cube([motor_sides/2-filament_offset, motor_sides/2, box_hgt]);
				}
			}

			//corner cut
			for (i = [-1, 1])
			translate([motor_sides/2, i*motor_sides/2, box_hgt/2])
			rotate([0, 0, 45])
			cube([6, 6, box_hgt+2], center=true);

			//top cut
			translate([0, 0, 25+motor_bolt_length-3])
			cube([2*motor_sides, 2*motor_sides, 50], center=true);

			//bearing slot
			translate([-motor_sides, -bearing_or-1, box_hgt/2+z_offset-bearing_h/2-0.5])
			cube([2*motor_sides, 2*bearing_or+2, bearing_h+1]);

			//bowden slot
			translate([filament_offset, filament_y_offset+nut_thickness-motor_sides/2, box_hgt/2+z_offset])
			rotate([90, 0, 0])
			minkowski(convexity=5)
			{
				nutntube();

				rotate([0, 0, 180])
				cube([10, 0.1, 0.1]);
			}

			if (single == false)
			mirror([0, 1, 0])
			translate([filament_offset, filament_y_offset+nut_thickness-motor_sides/2, box_hgt/2+z_offset])
			rotate([90, 0, 0])
			minkowski(convexity=5)
			{
				nutntube();

				rotate([0, 0, 180])
				cube([10, 0.1, 0.1]);
			}

			//bearing axis and nut
			minkowski(convexity=5)
			{
				union()
				{
					//bearing screw
					translate([bearing_offset, 0, motorCutoutH])
					rotate([0, 5, 0])
					cylinder(h=box_hgt+1, r1=bearing_ir*0.9, r2=bearing_ir);

					//bearing screw nut
					translate([bearing_offset, 0, motorCutoutH])
					nutHole(4);
				}

				rotate([0, 0, 180])
				cube([10, 0.1, 0.1]);
			}

			//stepper motor (NEMA 17)
			motor();

			//MK crearance
			translate([0, 0, -1])
			cylinder(h = motorCutoutH+1+30, r = motorCutoutD/2);
		}

		//Visualized all-parts:
/*
		//Motor
		color("DarkGrey")
		motor();

		//bowden slot
		translate([filament_offset, filament_y_offset+nut_thickness-motor_sides/2, box_hgt/2+z_offset])
		rotate([90, 0, 0])
		nutntube();

		if (single == false)
		mirror([0, 1, 0])
		translate([filament_offset, filament_y_offset+nut_thickness-motor_sides/2, box_hgt/2+z_offset])
		rotate([90, 0, 0])
		nutntube();

		//MK drive gear
		color("Silver")
		translate([0, 0, box_hgt/2+z_offset])
		{
			translate([0, 0, -MK_hgt/2])
			cylinder(h=MK_hgt/2, r1=MK_ext_d/2, r2=MK_eff_d/2);
			cylinder(h=MK_hgt/2, r1=MK_eff_d/2, r2=MK_ext_d/2);
		}

		//bearing
		translate([bearing_offset, 0, box_hgt/2+z_offset-bearing_h/2])
		bearing(model=bearing_model, outline=false);
*/
	}
}
