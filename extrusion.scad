use <V-Slot.scad>
use <wheel.scad>
use <ISOThreadUM2.scad>
use <eccentric_spacer.scad>
use <xyblock.scad>

wheel_v_offset = 20;
plate_offset = 8;
spacer_length = 6;

module wheelHexBolt(l=45) {
    render() hex_bolt(5,l);
}
module wheelHexNut() {
    render() hex_nut(5);
}

module movementWheel(eccentric=false, l=20, plate_height = 3) {
    translate([0,-0.25,0]) rotate([90,0,0]) 625_bearing();
    translate([0, 0.25,0]) rotate([-90,0,0]) 625_bearing();
    color([0.8,0.8,0.8]) rotate([90,0,0]) vSlotWheel();
    color("blue") translate([0,9+plate_offset+plate_height,0]) rotate([90,0,0]) wheelHexBolt(l);
    color("green") translate([0,-5,0]) rotate([90,0,0]) wheelHexNut();
    
    if (!eccentric) {
        color("red") translate([0,plate_offset+3.25,0]) rotate([90,0,0]) tube(spacer_length, 5, 10);
    } else {
        color("red") translate([0, plate_offset-1.5, 0]) rotate([-90,0,0]) eccentric_spacer(spacer_length);
    }
}

module linear_xaxis(fn=40) {
    $fn = fn;
    wheel_h_offset = 16;
    plate_height = 22.5;

    translate([-wheel_h_offset, 0, wheel_v_offset]) movementWheel(true, l=45, plate_height=plate_height);
    translate([-wheel_h_offset, 0, -wheel_v_offset]) movementWheel(l=45, plate_height=plate_height);
    translate([wheel_h_offset, 0, wheel_v_offset]) movementWheel(true, l=45, plate_height=plate_height);
    translate([wheel_h_offset, 0, -wheel_v_offset]) movementWheel(l=45, plate_height=plate_height);

    translate([0,plate_height + 5+plate_offset, 0]) rotate([90,180,0]) xy_block_vslot();
//    translate([0,10+plate_offset,0]) rotate([90,90,0]) vSlotPlate(plate_type=1);
}

module linear_gantry(fn=40) {
    $fn = fn;

    wheel_h_offset = 20;
    plate_height = 5;

    translate([-wheel_h_offset, 0, wheel_v_offset]) movementWheel(true, l=28, plate_height=plate_height);
    translate([-wheel_h_offset, 0, -wheel_v_offset]) movementWheel(l=28, plate_height=plate_height);
    translate([wheel_h_offset, 0, wheel_v_offset]) movementWheel(true, l=28, plate_height=plate_height);
    translate([wheel_h_offset, 0, -wheel_v_offset]) movementWheel(l=28, plate_height=plate_height);

    translate([0,10+plate_offset,0]) rotate([90,90,0]) vSlotPlate(plate_type=1);
}


color([0.45,0.45,0.45]) translate([-150, 0, 0]) rotate([0, 90, 0]) 2020_extrusion(length=300);

echo ("You should include extrusion.scad with use, not include!");


linear_gantry();

translate([100,0,0]) linear_xaxis();