extruded_2020_width=20;

include <vulcanus_params.scad>
use <Thread_Library.scad>
//include <smallbridges/scad/vslot.scad>
use <V-Slot.scad>
use <extrusion.scad>
make_screws = 0;

gray = [0.8, 0.8, 0.8];
yellow = [0.9,0.9,0];
magenta = [0.9,0,0.9];

$fn = 20;
//$fa = 1;

printOnly="corexy";

vulcanus_frame();
vulcanus_corexy_level(frame_cross_length, corexy_stage_level);
//vulcanus_corexy_yrods(frame_cross_length, corexy_stage_level);
vulcanus_corexy_slide(frame_cross_length, top_stage_level);

if (printOnly == "none" || printOnly == "base") {
    vulcanus_bed_level(frame_cross_length, bed_stage_level);
}

if (printOnly == "none" || printOnly == "bed") {
    color(rod_color) vulcanus_z_rods(frame_cross_length, top_level=corexy_stage_level);
    color(lead_screw_color) vulcanus_z_lead_screws(frame_cross_length, bed_stage_level);

    vulcanus_z_steppers(frame_cross_length, bed_stage_level);
}

// This module builds the primary frame -- basically it puts all the extruded aluminum
// in place except for the build plate(s)
module vulcanus_frame(tall_piece = frame_height, cross_piece = frame_cross_length) {
    side_length = cross_piece + extruded_2020_width;
    
    module vertical_support() { vslot20x20(tall_piece); }
    
    color(frame_color) {
        translate([-side_length/2, -side_length/2, 0]) vertical_support();
        translate([side_length/2, -side_length/2, 0]) vertical_support();
        translate([-side_length/2, side_length/2, 0]) vertical_support();
        translate([side_length/2, side_length/2, 0]) vertical_support();
    }
    
    if (printOnly == "none" || printOnly == "frame") {
        // Bottom stage (the base)
        vulcanus_x_piece(bottom_stage_level, cross_piece);
    }
    
    if (printOnly == "none" || printOnly == "frame") {
        // Bed stage (the stage that the bed and bed-level thingies go
        vulcanus_x_piece(bed_stage_level, cross_piece, rotate=1);
    }
    
    if (printOnly == "none" || printOnly == "frame" || printOnly == "corexy") {
        // CoreXY stage (the stage where the corexy movement goes)
        vulcanus_x_piece(corexy_stage_level, cross_piece, tricorner=0, rotate=1);
    }
    
    if (printOnly == "none" || printOnly == "frame" || printOnly == "corexy") {
        // Top stage (the roof)
        vulcanus_x_piece(top_stage_level, cross_piece, rotate=1, corners=false);
    }
}

module vslot20x20(length) {
    2020_extrusion(length=length);
}

module vulcanus_x_piece(height = 0, cross_piece = frame_cross_length, corner = 1, tricorner = 1, rotate=0, corners=true) {
    module draw_cross_piece() { vslot20x20(cross_piece); }

    translate([0, 0, height]) {
        piece_width = cross_piece;
        color(frame_color) {
            // Place the cross-pieces
            translate([-piece_width/2, -piece_width/2 - extruded_2020_width/2, extruded_2020_width/2])
                rotate([0, 90, 0]) vslot20x20(cross_piece);
            translate([-piece_width/2, piece_width/2 + extruded_2020_width/2, extruded_2020_width/2])
                rotate([0, 90, 0]) vslot20x20(cross_piece);
            translate([-piece_width/2 - extruded_2020_width / 2, piece_width/2, extruded_2020_width/2])
                rotate([90, 0, 0]) vslot20x20(cross_piece);
            translate([piece_width/2 + extruded_2020_width / 2, piece_width/2, extruded_2020_width/2])
                rotate([90, 0, 0]) vslot20x20(cross_piece);
        }
        
        // Draw the corners and rotate (upside down) if needed
        rotateDeg = 180 * rotate;
        zAdjust = extruded_2020_width + (-extruded_2020_width * rotate);
        if (corners) {
            color("aqua") rotate([rotateDeg,0,0]) {
                translate([piece_width/2, piece_width/2, zAdjust]) rotate([0,0,90])   if (tricorner) { tricorner(); } else { bicorner(); }
                translate([-piece_width/2, piece_width/2, zAdjust]) rotate([0,0,180]) if (tricorner) { tricorner(); } else { bicorner(); }
                translate([piece_width/2, -piece_width/2, zAdjust]) rotate([0,0,0])   if (tricorner) { tricorner(); } else { bicorner(); }
                translate([-piece_width/2, -piece_width/2, zAdjust]) rotate([0,0,-90])if (tricorner) { tricorner(); } else { bicorner(); }
            }
        }
    }
}

module vulcanus_corexy_level(cross_piece=frame_cross_length, base_level = 0) {
    module draw_side() {
        color(lead_screw_bracket_color) z_bearing_holder();
        color(rodbracket_color) {
            translate([cross_piece/4, 0, 0]) zaxis_mount();
            translate([-cross_piece/4, 0, 0]) zaxis_mount();
        }
    }
    
    translate([0,0,base_level]) {
        translate([-cross_piece/2,cross_piece/2,0]) {
            // Motor mount left and stepper
            //color(motormount_color) motor_left();
            //translate([extruded_2020_width + 1, -extruded_2020_width - 1, 50]) color(stepper_color) NEMA17_full();
        }
        translate([cross_piece/2,cross_piece/2,0]) {
            // Motor mount right and stepper
            //color(motormount_color) motor_right();
            //translate([-extruded_2020_width - 1, -extruded_2020_width - 1, 50]) color(stepper_color) NEMA17_full();
        }
    
        translate([-cross_piece/2,-cross_piece/2,0]) {
            // Idler left
            //color(motormount_color) idler_left();
        }
        translate([cross_piece/2,-cross_piece/2,0]) {
            // Idler right
            //color(motormount_color) idler_right();
        }
        // Draw the z smooth rod holders and the lead screw top guide
        translate([0,-cross_piece/2,0]) draw_side();
        mirror([0,1,0]) translate([0,-cross_piece/2,0]) draw_side();
    }
}

module vulcanus_corexy_yrods(cross_piece=frame_cross_length, base_level = 0) {
    module y_rod() {
        translate([cross_piece/2 - 19.4, cross_piece/2 - 42.25, 38]) rotate([90,0,0])
            color(rod_color) render() cylinder(d=xy_rod_diameter, h=y_rod_length);
    }
    translate([0,0,base_level]) {
        y_rod();
        mirror([1,0,0]) y_rod();
    }
}

module vulcanus_corexy_slide(cross_piece=frame_cross_length, base_level = 0) {
    module draw_xslide() {
        translate([0, frame_cross_length/2+10,10]) rotate([0,0,180]) linear_xaxis();
    }
    module draw_gantry() {
        translate([0, frame_cross_length/2+10,10]) rotate([0,0,180]) linear_gantry();
    }
    
    translate([0,0,base_level - 40]) {
        mirror([0,0,0]) draw_xslide();
        mirror([0,1,0]) draw_xslide();
    
        translate([0,x_rail_length/2,10]) rotate([90,0,0]) color(frame_color) vslot20x20(x_rail_length);
        translate([0,0,10]) rotate([0,0,-90]) linear_gantry();
    }
}

module vulcanus_bed_level(cross_piece=frame_cross_length, base_level = 0) {
    module draw_side() {
        color(lead_screw_bracket_color) zmotor_mount();
        color(rodbracket_color) {
            translate([cross_piece/4, 0, 0]) zaxis_mount();
            translate([-cross_piece/4, 0, 0]) zaxis_mount();
        }
    }
    
    translate([0,0,base_level]) {
        translate([0,-cross_piece/2,0]) draw_side();
        mirror([0,1,0]) translate([0,-cross_piece/2,0]) draw_side();
    }
}

module vulcanus_z_rods(cross_piece=frame_cross_length, top_level = 0) {
    zrod_base = top_level + extruded_2020_width - z_rod_length;
    
    
    translate([0, 0, zrod_base]) {
        translate([0,-cross_piece/2 + z_rod_inset,0]) {
            translate([cross_piece/4, 0, 0]) render() cylinder(d=z_rod_diameter, h=z_rod_length);
            translate([-cross_piece/4, 0, 0]) render() cylinder(d=z_rod_diameter, h=z_rod_length);
        }
        mirror([0,1,0]) translate([0,-cross_piece/2 + z_rod_inset,0]) {
            translate([cross_piece/4, 0, 0]) render() cylinder(d=z_rod_diameter, h=z_rod_length);
            translate([-cross_piece/4, 0, 0]) render() cylinder(d=z_rod_diameter, h=z_rod_length);
        }
    }
}

module vulcanus_z_steppers(cross_piece=frame_cross_length, base_level = 0) {
     color(stepper_color) translate([0,0,base_level + extruded_2020_width]) {
        translate([0,-cross_piece/2 + extruded_2020_width + 1,0]) NEMA17_full();
        mirror([0,1,0]) translate([0,-cross_piece/2 + extruded_2020_width + 1,0]) NEMA17_full();
    }
}
module vulcanus_z_lead_screws(cross_piece=frame_cross_length, base_level = 0) {
    
    module trapThreadRod() {
        if (make_screws) {
            render() trapezoidThread(length=lead_screw_length, pitch=lead_screw_pitch, threadAngle=30, pitchRadius=lead_screw_diameter/2);
        } else {
            cylinder(d=lead_screw_diameter, h=lead_screw_length);
        }
    }
    
    translate([0,0,base_level + extruded_2020_width + lead_screw_coupler_height]) {
        translate([0,-cross_piece/2 + z_rod_inset,0]) trapThreadRod();
        mirror([0,1,0]) translate([0,-cross_piece/2 + z_rod_inset,0]) trapThreadRod();
    }
}

module tricorner() {
    render() import("./tricorner_notrotated.stl", convexity=10);
}

module bicorner() {
    render() import("./2corner.stl", convexity=10);
}

module motor_left() {
    rotate([180, 0, -90]) translate([71.25 - extruded_2020_width, -48.25 + extruded_2020_width, -53])
    import("./motor_left.stl", convexity=10);
}
module motor_right() {
    rotate([0,0,180]) mirror([0,1,0]) motor_left();
}
module idler_left() {
    rotate([0, 0, -90]) translate([-5, 13.5, extruded_2020_width])
    import("./idler_left.stl", convexity=10);
}
module idler_right() {
    rotate([0,0,180]) mirror([0,1,0]) idler_left();
}

module zmotor_mount() {
    rotate([180,0,0]) translate([0,-11, -extruded_2020_width]) import("./Z-Motor.stl", convexity=10);
}
module zaxis_mount() {
    translate([0,15.5,0]) render() import("./Z-Axis_Holder.stl", convexity=10);
    translate([0,26.25,0]) mirror([0,1,0]) render() import("./Z-Axis_Clamp.stl", convexity=10);
}
module z_bearing_holder() {
    render() {
        rotate([0,0,90]) translate([extruded_2020_width-1.5,0,0]) import("./Z_Axis_bearing_holder.stl");
    }
}

module NEMA17_full() {
    render() {
        translate([0,0,-16.725]) import("./nema17/Motor_NEMA17.stl");
    }
}