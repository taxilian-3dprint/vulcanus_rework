include <V-Slot.scad>
include <wheel.scad>
include <ISOThreadUM2.scad>
use <eccentric_spacer.scad>

$fa=0.5;
$fn=100;

module linear_gantry() {

    module movementWheel(eccentric=false) {
        translate([0,-0.25,0]) rotate([90,0,0]) 625_bearing();
        translate([0, 0.25,0]) rotate([-90,0,0]) 625_bearing();
        color([0.8,0.8,0.8]) render() rotate([90,0,0]) vSlotWheel();
        color("blue") translate([0,13.5+plate_offset,0]) rotate([90,0,0]) render() hex_bolt(5,30);
        color("green") translate([0,-5,0]) rotate([90,0,0]) render() hex_nut(5);
        
        if (eccentric) {
            color("red") translate([0,plate_offset+3.25,0]) rotate([90,0,0]) render() tube(spacer_length, 5, 10);
        } else {
            color("red") translate([0, plate_offset, 0]) rotate([90,0,0]) eccentric_spacer(spacer_length);
        }
    }

    wheel_v_offset = 20;
    wheel_h_offset = 20;
    plate_offset = 8;
    spacer_length = 6;

    translate([-wheel_h_offset, 0, wheel_v_offset]) movementWheel();
    translate([-wheel_h_offset, 0, -wheel_v_offset]) movementWheel(true);
    translate([wheel_h_offset, 0, wheel_v_offset]) movementWheel();
    translate([wheel_h_offset, 0, -wheel_v_offset]) movementWheel(true);

    translate([0,10+plate_offset,0]) rotate([90,90,0]) vSlotPlate(plate_type=1);
}

color([0.45,0.45,0.45]) translate([-150, 0, 0]) rotate([0, 90, 0]) 2020_extrusion(length=300);

echo ("You should include extrusion.scad with use, not include!");


linear_gantry();