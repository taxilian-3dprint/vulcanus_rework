
length=30;
height=30;
width=20;

radius = 2.5;

cubelen = length - radius;

offset = 8.66;

intersection() {

    /*translate([0,0,17]) rotate([43.275, 215, 0])*/ union() {

        bracket();
        translate([0, -width, 0]) rotate([0,0,90]) bracket();
        rotate([0, 90, 90]) bracket();

        difference() {
            intersection() {
                sphere(r=length - radius);
                translate([offset, -offset, 0]) rotate([35.266, 0, 45]) centered_cube([cubelen*2, cubelen*2, height*2]);
                translate([-length+radius, -radius+.75, 0]) cube([length-1.5, length, height]);
            }
            translate([0, -length, 0]) cube([length, length, height]);
        }

    }

}
module bracket() {
    translate([-90, -85, 0]) import("./Vulcanus_V2_Corner_Bracket.stl", convexity=10);
}

module centered_cube(size) {
    translate([-size[0]/2, -size[1]/2, -size[2]/2]) cube(size);
}