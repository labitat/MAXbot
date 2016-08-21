// author: clayb.rpi@gmail.com
// date: 2012-04-29
// units: mm
// description: printrbot Y axis bar end with end-stop trigger
// NOTE: This is an unofficial piece

$fn=24;

module tear(r, h) {
    union() {
        cylinder(r=r, h=h);
        rotate([0, 0, 135]) cube([r, r, h]);
    }
}

difference() {
    union() {
		cube([22.7, 9.8, 8]);
		cube([16.8, 11.2, 8]);

		translate([8.4, 11.2, 0]) cylinder(r=16.8/2, h=8);

		// end stop trigger

		translate([9.5, -10, 0]) cube([7.8, 11.2, 4]);
    }

	translate([-0.1, 4.9, 4.1]) rotate([0, 90, 0]) tear(r=3.8/2, h=23);
	translate([8.4, 11.2, -1]) cylinder(r=4.2, h=10);
	translate([7.8, -1, -1]) cube([1.7, 11.2, 10]);
}
