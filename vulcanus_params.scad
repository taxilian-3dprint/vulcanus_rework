
//$fa=4;
//$fs=0.2;

extruded_2020_width = 20;

frame_height = 700;
frame_cross_length = 590;

bed_frame_long = 505;
bed_frame_short = 460;

bottom_stage_level = 0;
bed_stage_level = 85;

z_rod_diameter = 12;
z_rod_length = 600;
z_rod_inset = 21.25;

x_rail_length = frame_cross_length - 50;

lead_screw_pitch = 4;
lead_screw_length = 500;
lead_screw_diameter = 8;
lead_screw_coupler_height = 15;

xy_rod_diameter = 10;
x_rod_length = 511;
y_rod_length = 537;

corexy_stage_level = frame_height - extruded_2020_width - 80;
top_stage_level = frame_height - extruded_2020_width;


frame_color = [0.45, 0.45, 0.45];
frame_connector_color = "aqua";
rod_color = [0.8, 0.8, 0.8];
lead_screw_color = rod_color;
lead_screw_bracket_color = "orange";

stepper_color = [0.95, 0.95, 0.95];

motormount_color = "yellow";
rodbracket_color = "green";

// V-Slot config stuff


vslot_wheel = [23.89,10.23];	//23.89 & 10.23
vslot_wheel_hole = 5+0.5;
vslot_wheel_eccentric = 7.2+0.5; //hole for eccentric spacer
vslot_wheel_spacer_length = 6.35;

y_bearing_block_height = 6+15/2;

// Belts:
GT2_belt_width = 6;
GT2_belt_pitch = 2;
GT2_belt_thickness = 1.38;
GT2_belt_tooth_height = 0.75;  
GT2_belt_tooth_ratio = 0.5;

end_belt_bearing_distance = 25;// distance between 2 bearings on y-ends
belt_clearance = 9.5; //space for belts
x_belt_clearance = 5; //spacing between x-axis vslot and belt
belt_bearing = [4, 13, 10]; // 2 624 bearings together, good size for GT2

//from metric (prusa i3)
m4_diameter = 4.6;
m4_nut_diameter = 7.6;
m4_nut_diameter_horizontal = 8.15;

m3_diameter = 3.6;
m3_nut_diameter = 5.3;
m3_nut_diameter_horizontal = 6.8;
m3_washer_diameter = 6.9;
//end i3 variables

m5_diameter = 5.5;

M4 = m4_diameter;
M3 = m3_diameter;
M5 = m5_diameter;
m4_washer_thickness = 0.8; //flat and penny washers
m4_washer_diameter = 9.6;
