// Name: Bed cutout
// Originally created by Martin Axelsen <kharar@gmail.com> refactored by Simon Paarlberg <simon@paarlberg.dk>
// https://labitat.dk/wiki/MAXbot and https://github.com/labitat/maxbot
// Camera: 0,0,0,0,0,0,1090

$fn=50;
bedX        = 240;  //std:240   //mini:156
bedY        = 320;  //std:320   //mini:240
holesRad    = 3*0.5;
turnRad     = 15;   //20
mkSide      = 214;  //214
mkMount     = 209;  //209
hwRad       = 4;
beltMount   = 19;
beltOffset  = 46;
slotLength  = 4;

hwOffset    = hwRad*4;

wlRad       = 8;
wlInside    = 1.5*wlRad;
wlInsideOff = wlInside+1.42*wlRad*2;
wlSide      = mkSide/2-wlRad;

module bed_weightloss_cutout()
{
    hull() {
        translate([wlInsideOff, wlInside+wlRad/2]) circle(r=wlRad, center=true);
        translate([wlSide, wlSide-(wlInsideOff-wlInside)]) circle(r=wlRad, center=true);
        translate([wlSide, wlInside+wlRad/2]) circle(r=wlRad, center=true);
    }
}

module bed_mk2_heatbed()
{
    for (ra=[0, 180]) rotate([0, 0, ra]) {
        translate([-mkMount/2, mkMount/2]) circle(r=holesRad, center=true);
        translate([0, mkMount/2]) circle(r=holesRad, center=true);
        translate([mkMount/2, mkMount/2]) circle(r=holesRad, center=true);

        //heater wire hole
        translate([0, mkSide/2+hwOffset]) circle(r=hwRad, center=true);
    }

    //thermistor wire hole
    circle(r=wlRad*2, center=true);
}

module bed_slot()
{
    hull() {
        translate([-slotLength, 0]) circle(r=holesRad, center=true);
        translate([slotLength, 0]) circle(r=holesRad, center=true);
    }
}

module bed()
{
    difference() {
        union() {
            //main body
            square([bedX+turnRad, bedY], center=true);

            //corner shapes
            for (iy=[-bedY/2, bedY/2]) {
                hull() {
                    for (ix=[-bedX/2, bedX/2]) {
                        translate([ix, iy]) circle(r=turnRad, center=true);
                    }
                }
            }
        }

        //Timeglass shape
        for (ix=[-1, 1]) {
            translate([ix*(bedX/2+turnRad), 0]) hull() {
                for (iy=[-1, 1]) {
                    translate([0, iy*(bedY/2-turnRad*1.73)]) circle(r=turnRad, center=true);
                }
            }
        }

        //weightloss cutouts
        for(ix=[0,1]) mirror([ix,0]) for(iy=[0,1]) mirror([0,iy]) {
            scale([0.9, 1]) bed_weightloss_cutout();
            scale([1, 1]) mirror([-1, 1, 0]) bed_weightloss_cutout();
        }

        //Corner holes + belt clips
        for (iy=[-1, 1]) for (ix=[-1, 1]) {
            translate([ix*bedX/2, iy*bedY/2]) {
                bed_slot();
                translate([-ix*beltOffset, 0]) {
                    bed_slot();
                    translate([-ix*beltMount, 0]) bed_slot();
                }
            }
        }

        //MK2 heatbed
        bed_mk2_heatbed();
    }
}

bed();
