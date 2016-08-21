use <Lcd4x20.scad>
use <ClickEncoder.scad>



front();

//rear();

//explodedView();

//panelHull();



buttonDist	= 20;
buttonDia	= 15;
wall		= 2;
boxZ		= wall+max(lcdZ(),encoderZ()-wall+1);
cutOffset	= 1;
boxCutZ		= lcdFramePcb()-cutOffset;
wireTray	= 3;
wireWidth	= 14	*1.27;
wireHeight	= 1;

//Pin
module pin(pinwidth, pinlength)
{
	translate([-pinwidth/2, -pinwidth/2, 0])
	cube([pinwidth, pinwidth, pinlength]);
}


//IDC pin header
module IDC(xpins, ypins)
{
plugsxyadd	= 0.5;
grid		= 0.254;	//how many millimeters goes to ten mils (10 mil = 0.01 inch)
plugsz		= 20;

	//outline
	translate([-5*grid-9.1*grid-plugsxyadd, -5*grid-plugsxyadd, 0])
	cube([10*grid*xpins+18.2*grid+2*plugsxyadd, 10*grid*ypins+2*plugsxyadd, plugsz]);
	
	translate([(xpins-1)*5*grid, -5*grid, plugsz/2])
	cube([4+2*plugsxyadd, 2+2*plugsxyadd, plugsz], center=true);

	translate([(xpins-1)*5*grid, -5*grid, plugsz/2+7])
	cube([10*grid*xpins+2*plugsxyadd, 2+2*plugsxyadd, plugsz-14], center=true);
	
	//pins
	for(ix=[0:1:xpins-1])
	for(iy=[0:1:ypins-1])
	translate([10*grid*ix, 10*grid*iy, -3])
	pin(0.6, 11);

}


module panelHull()
{
	difference()
	{
		hull()
		{
			translate([0, 0, boxZ/2])
			cube([lcdX()+2*wall, lcdY()+2*wall, boxZ], center=true);
			
			translate([lcdX()/2+buttonDist, 0, boxZ/2])
			cylinder(r=buttonDia, h=boxZ, center=true);
		}
		
		translate([0, 0, -0.01])
		union()
		{
			lcdHull();
			
			//encoder and wire trays
			translate([lcdX()/2+buttonDist, 0, 0])
			{
				encoderHull();
				for (iy=[-1, 0, 1])
				{
					//encoder wire trays
					translate([(encoderX()-(buttonDist+10))/2, iy*(encoderY()-wireTray)/2, boxCutZ+lcdRearZ()/2+cutOffset/2])
					cube([buttonDist+10, wireTray, lcdRearZ()+cutOffset], center=true);
				}
			}
			
			//old ext. wire hole
//			translate([-lcdX()/2-wall-1, -wireWidth/2, lcdZ()-wireHeight])
//			cube([10+wall, wireWidth, wireHeight]);
			
			//IDC pin header
			translate([10, -lcdY()/2+7, 4])
			rotate([90, 0, 0])
			IDC(7, 2);
			
			//wire duct
			translate([39, -lcdY()/2+6, 4])
			cube([15, 5, 10]);
			translate([52, -lcdY()/2+6, 4])
			cube([5, 35, 10]);
		}
		
		lcdLowerNuts(boxZ+0.01);
	}
}

module front()
{
	difference()
	{
		panelHull();
		
		//cut away the rear
		translate([0, 0, boxZ/2+boxCutZ])
		cube([200, 200, boxZ], center=true);
	}
}

module rear()
{
	translate([0, 0, boxZ])
	rotate([0, 180, 0])
	difference()
	{
		panelHull();
		
		//cut away the front
		translate([0, 0, boxCutZ-boxZ/2])
		cube([200, 200, boxZ], center=true);
	}
}

module explodedView()
{
	rear();
	
%	translate([0, 0, 30])
	rotate([180, 0, 0])
	lcdPanel();

%	translate([-(lcdX()/2+buttonDist), 0, 30])
	rotate([180, 0, 0])
	encoderHull();

	translate([0, 0, 50])
	rotate([0, 180, 0])
	front();
}