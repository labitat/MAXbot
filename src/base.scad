// Based on the ws-base from Wersybot (http://www.thingiverse.com/thing:37009)

include <../config.scad>;

module base_platform(size=[0,0,0])
{
    x_size = size[0];
    y_size = size[1];
    z_size = size[2];

    inner_square_x = 15.5;

    hull() {
        cube([x_size,10,z_size], center=true);
        for(i=[-1,1]) translate([i*(x_size-10)/2,y_size,0]) cylinder(d=10, h=z_size, center=true);
    }
    translate([0,9.9,0]) {
        difference() {
            union() {
                hull() for(i=[-1,1]) for(j=[-1,1]) translate([i*inner_square_x,j*(y_size+3.3),0]) cylinder(d=12, h=z_size, center=true, $fn=30);
                for(i=[-1,1]) for(j=[-1,1]) translate([i*(inner_square_x+11.9-(11.8/2)), j*((y_size+3.3)-2.35-(11.8/2)),0]) cube([11.8,11.8,z_size], center=true);
            }
            for(i=[-1,1]) translate([0,i*39,0]) cylinder(d=32.5, h=z_size+2, center=true, $fn=60);
            for(i=[-1,1]) for(j=[-1,1]) {
                translate([i*(inner_square_x),j*((y_size+3.3)),0]) cylinder(d=3.4, h=z_size+2, center=true, $fn=16);
                translate([i*(inner_square_x+11.9), j*((y_size+3.3)-2.35),0]) cylinder(d=11.8, h=z_size+2, center=true, $fn=30);
            }
        }
    }
}

module base_vertical_part(size=[0,0,0])
{
    x_size = size[0];
    y_size = size[1];
    z_size = size[2];

    difference() {
        union() {
            cube([x_size,y_size,z_size], center=true);
            for(i=[-1,1]) for(j=[-1,0,1]) translate([j*15,(i*1.6),0]) cylinder(d=12, h=z_size, center=true, $fn=10);
        }

        // Bottom wood mount holes
        for(i=[-1,1]) translate([i*((x_size/2)-16),0,((z_size-25)/2)+2]) cylinder(d=2, h=25, center=true, $fn=24);

        // Bottom trapez cutout
        translate([0,0,(z_size-6+1)/2]) difference() {
            cube([x_size-40,10+8,6+1], center=true);
            for(i=[-1,1]) translate([i*-(((x_size-40)/2)+2.6),0,0]) rotate([0,i*60,0]) cube([20,10+8+1,6+1], center=true);
        }

        // Holes for wires and threaded rods
        for(i=[-1,1]) {
            translate([i*((x_size/2)-9), 0, (z_size/2)-9.5]) rotate([90,0,0]) cylinder(d=8.1, h=10+2, center=true, $fn=16);
            translate([i*((x_size/2)-9), 0, (-z_size/2)+15.5]) rotate([90,0,0]) cylinder(d=8.1, h=10+2, center=true, $fn=16);
            hull() for(j=[-1,1]) translate([(i*34)+(j*5),0,-(z_size/2)+7+24.5]) rotate([90,0,0]) cylinder(d=12, h=10+2, center=true, $fn=16);
        }
    }
}

module base_bearing_cutout(height, width)
{
    // Bearing cutout
    translate([0,19.8-6.3,-height/2]) rotate([0,90,0]) {

        translate([4,0,0]) cylinder(h=xLmLength, d=xLmDiameter, center=true, $fn=36);

        for(i=[-1,1]) translate([0,0,i*7.5]) difference() {
            cylinder(d=19, h=4, center=true, $fn=50);
            cylinder(d=15.1, h=4+1, center=true, $fn=50);
        }
    }
}

module base()
{
    height=63;
    width=100;

    difference() {
        union() {
            base_vertical_part([width,10,height]);
            hull() {
                translate([0,16.5,-((height-5)/2)+7]) cube([5,20,5], center=true);
                translate([0,6,(height/2)-6.5]) cube([5,1,1], center=true);
            }
            translate([0,0,-(height-7)/2]) base_platform(size=[width,19.8,7]);
        }
        translate([0,0,-13.5]) cylinder(d=8.1, h=height, center=true, $fn=24);
        for(i=[-1,1]) translate([i*((width/2)-19.3),0]) base_bearing_cutout(height, width);
    }
}

base();
