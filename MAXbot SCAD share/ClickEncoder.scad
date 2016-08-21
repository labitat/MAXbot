
encoderHull();

$fn = 50;

encX	= 12.7	+0.5;
encY	= 15	+0.5;
encZ	= 6.6;
tipDia	= 6;
tipCut	= 4.5;
tipLen	= 7;
rodDia	= 7		+0.5;
rodLen	= 6		-1;
pinH	= 7.2	+1;
pinD	= 2		+2;
pinOff	= 4;
pinZ	= rodLen+encZ-pinOff;

function encoderX() = encX;
function encoderY() = encY;
function encoderZ() = encZ+rodLen+pinH-pinOff;


module encoderHull()
{
	cylinder(r=rodDia/2, h=rodLen+1, center=false);
	
	translate([0, 0, -tipLen])
	difference()
	{
		cylinder(r=tipDia/2, h=tipLen+1, center=false);
		
		rotate([0, 0, -70])
		translate([tipDia/2-tipCut, tipDia, -1])
		rotate([0, 0, 180])
		cube([2*tipDia, 2*tipDia, tipLen+1]);
	}

	translate([0, 0, rodLen+encZ/2-0.01])
	cube([encX, encY, encZ+0.1], center = true);
	
	for (iy=[-1, 1])
	{
		for (ix=[-1, 0, 1])
		{
			translate([ix*2.54, iy*encY/2, pinZ])
			cylinder(r=pinD/2, h=pinH, center=false);
		}
	}
	
	for (ix=[-1, 1])
	{
		translate([ix*encX/2, 0, pinZ])
		cylinder(r=pinD/2, h=pinH, center=false);
	}
}

