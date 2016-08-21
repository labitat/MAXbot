
//lcdPanel();

lcdHull();


lcdPcbX			= 98.3	+1;
lcdPcbY			= 60.0	+1;
lcdPcbZ			=  1.6	+0.5;

lcdFrameX		= 97.2	+0.5;
lcdFrameY		= 39.6	+0.5;
lcdFrameZ		=  9.5;

lcdHoleX		= 93.0;
lcdHoleY		= 55.0;
lcdHoleDia		=  3.4;

lcdWindowX		= 76.0;
lcdWindowY		= 26.0;

lcdRearY		= 45.0;
lcdRearZ		=  2.5;

lcdPinOffset	=  5;
lcdPinDia		=  1;
lcdPins			= 16;

lcdNutDia		= 6.4;//	+0.5;
lcdNutH			= 2.3;//	+0.5;

holesupport	= 0.2;


function lcdX() = lcdPcbX;
function lcdY() = lcdPcbY;
function lcdZ() = lcdFrameZ+lcdPcbZ+lcdRearZ;
function lcdRearZ() = lcdRearZ;
function lcdFramePcb() = lcdFrameZ+lcdPcbZ;
function lcdFrame() = lcdFrameZ;
function lcdPcb() = lcdPcbZ;

module lcdReserved()
{
	translate([0, 0, lcdFrameZ+lcdPcbZ+lcdRearZ/2])
	cube([lcdFrameX, lcdRearY, lcdRearZ+0.01], center=true);

	for (i=[0, 1])
	{
		rotate([0, 0, 180]*i)
		translate([lcdHoleX/2-lcdPinOffset-1.27, lcdHoleY/2+1.27, lcdFrameZ/4])
		rotate([0, 0, 180])
		cube([2*lcdPins*2.54, 15, lcdFrameZ/1.5+lcdPcbZ+lcdRearZ]);
	}
}


module lcdPcb()
{
	translate([0, 0, lcdFrameZ+lcdPcbZ/2])
	cube([lcdPcbX, lcdPcbY, lcdPcbZ+0.01], center=true);
}


module lcdFrame()
{
	translate([0, 0, lcdFrameZ/2])
	cube([lcdFrameX, lcdFrameY, lcdFrameZ+0.01], center=true);
}


module lcdHoles()
{
	for (iy=[-1, 1])
	{
		for (ix=[-1, 1])
		{
			translate([ix*lcdHoleX/2, iy*lcdHoleY/2, 2])
			{
				difference()
				{
					cylinder(r=lcdHoleDia/2, h=(lcdRearZ+lcdPcbZ+lcdFrameZ)*2, $fn=20);
					translate([0, 0, 3+lcdNutH])
					cylinder(r=lcdHoleDia , h=holesupport, center=false);
				}

				translate([0, 0, 3])
				{
					cylinder(r=lcdNutDia/2, h=lcdNutH, $fn=6);

					rotate([0, 0, 90])
					rotate([0, 0, 90]*iy)
					translate([-lcdNutDia/2, 0, 0])
					cube([lcdNutDia/2*2, 15, lcdNutH]);
				}
			}
		}
	}
}


module lcdWindow()
{
	translate([-lcdWindowX/2, -lcdWindowY/2, 1-100])
	cube([lcdWindowX, lcdWindowY, 100]);
}


module lcdPins()
{
	for (i=[1: 1: lcdPins])
	{
		translate([lcdHoleX/2-lcdPinOffset-i*2.54, lcdHoleY/2, lcdFrameZ+lcdPcbZ/2])
		cylinder(r=lcdPinDia/2, h=lcdPcbZ*3, center=true, $fn=10);
	}
}


module lcdLowerNuts(offZ)
{
	for (iy=[-1, 1])
	{
		for (ix=[-1, 1])
		{
			translate([ix*lcdHoleX/2, iy*lcdHoleY/2, offZ-lcdNutH])
			cylinder(r=lcdNutDia/2, h=lcdNutH, $fn=20);
		}
	}
}

module lcdPanel()
{
	difference()
	{
		union()
		{
			lcdPcb();

			lcdFrame();
		}

		lcdHoles();

		lcdPins();
	}
}


module lcdHull()
{
	lcdPcb();

	lcdFrame();

	lcdHoles();

	lcdReserved();

	lcdWindow();
}
