
//$fa = 0.5;
//$fn = 200;

//624_bearing(cutout=false);

//tslot_wheel();

tslot_trackWidth = 6;
wheel_diameter = tslot_trackWidth * 2.25;
wheel_radius = wheel_diameter / 2;
wheel_height = 10; 
wheel_outer = 15.23;


module tube(h, id, od) {
    difference() {
        cylinder(h, od/2, od/2);
        translate([0,0,-0.5]) cylinder(h+1, id/2, id/2);
    }
}

module 624_bearing(cutout = false) {
    generic_bearing(cutout=cutout,
        bearing_outer_d = 13,
        bearing_inner_d = 4,
        bearing_thickness = 5);
}

module 625_bearing(cutout=false) {
    generic_bearing(cutout=cutout,
        bearing_outer_d = 16,
        bearing_inner_d = 5,
        bearing_thickness = 5);
}

module generic_bearing(cutout=false,
        bearing_outer_d = 13,
        bearing_outer_d = 13,
        bearing_inner_d = 4,
        bearing_thickness = 5,
        bearing_wall_d = 1,
        bearing_inset = 0.15,
    ) {

    edgeColors = [0.4, 0.4, 0.4];
    middleColors = [0.6, 0.6, 0.6];

    if (!cutout) {
        union() {
            color(edgeColors) translate([0,0,bearing_inset]) render() tube(bearing_thickness - bearing_inset*2, bearing_inner_d + bearing_wall_d, bearing_outer_d - bearing_wall_d);
            color(middleColors) render() tube(bearing_thickness, bearing_inner_d, bearing_inner_d + bearing_wall_d);
            color(middleColors) render() tube(bearing_thickness, bearing_outer_d - bearing_wall_d, bearing_outer_d);
        }
    } else {
        render() tube(bearing_thickness, bearing_inner_d, bearing_outer_d);
    }
}

module tslot_wheel() {
    wheelCenter = wheel_outer - wheel_radius;
    difference() {
        intersection() {
            union() {
                translate([0, 0, (wheel_radius - (wheel_radius - wheel_height / 2))]) rotate_extrude() translate([wheelCenter, 0, 0]) circle(r=wheel_radius);
                cylinder(wheel_height, wheelCenter, wheelCenter);
            }
            translate([-30, -30, 0]) cube([60,60,wheel_height]);
            
        }
        translate([0,0,-5]) cylinder(50, 13/2, 13/2);
    }
}