// xy block  
// Original Author: sdavi
// "borrowed" from: https://github.com/sdavi/VSlot-CoreXY
// Creative Commons Attribution-ShareAlike 4.0 International License

//BoM (for both sides)

//4x eccentric spacers (6.35mm / 1/4")
//8x solid wheel kit (or seperate with 6.35mm / 1/4" spacer)
//8x M5x45mm screw

//2x 8mm Smooth Rod for X-Axis
//4x M4 ??mm bolt + nut
//8x F624ZZ 
//8x M4 washer

include <vulcanus_params.scad>
use <cube_library.scad>

x_bearing = [8, 15, 24];//rod diameter,outter diameter, length

xy_block_vslot();

long_bearing_screw = false; //use long screw (60mm for bearings) 

min_beltbearing_height = max(((belt_bearing[2]+m4_washer_thickness*2) * 2), y_bearing_block_height);

v_slot = 20; //20x20

echo("Min Height:", min_beltbearing_height);

h_wheel_spacing = 32;
v_wheel_spacing = 39.7; // spacing used on openbuilds plates. One hole is 5mm and the other hole is 7.2 for the eccentric spacer.

//wheel_hole = M5;
//wheel_hole_eccentric = 7.2+0.5;
wheel_edge_inset = 4.5+vslot_wheel_hole/2;

x_rod_distance = 40;

xy_block_width = h_wheel_spacing+10+ wheel_edge_inset*2;
xy_block_length = x_rod_distance+x_bearing[0]+8;//55;
xy_block_height = 4;

belt_area_clearance = belt_clearance+belt_bearing[1];// room for belt and bearings
belt_area_clearance_width = belt_bearing[1]*2+GT2_belt_thickness+4;

echo("bc Width:",belt_area_clearance_width);

total_height=belt_area_clearance;
echo("TotalHeight: ", total_height);


belt_bearing_x_pos = [xy_block_width/2-10-x_belt_clearance-GT2_belt_thickness -belt_bearing[1]/2,
 					     xy_block_width/2+10+x_belt_clearance+GT2_belt_thickness + belt_bearing[1]/2];
belt_bearing_z_pos = belt_bearing[1]/2;


//[x,y,size]
wheel_holes = [[xy_block_width/2-h_wheel_spacing/2, xy_block_length/2-v_wheel_spacing/2, vslot_wheel_hole],
				  [xy_block_width/2+h_wheel_spacing/2, xy_block_length/2-v_wheel_spacing/2,vslot_wheel_hole],
				  [xy_block_width/2-h_wheel_spacing/2, xy_block_length/2+v_wheel_spacing/2,vslot_wheel_eccentric], //eccentric
				  [xy_block_width/2+h_wheel_spacing/2, xy_block_length/2+v_wheel_spacing/2,vslot_wheel_eccentric]//eccentric
				];


module xy_block_vslot(){
	
	translate([-xy_block_width/2, -xy_block_length/2, 0]) difference(){
		union(){
			cube_fillet([xy_block_width, xy_block_length, total_height], vertical=[2,2,2,2]);
		}

		//holes for wheels
		for(p=wheel_holes){
			translate([p[0], p[1], -0.1])
				cylinder(d=p[2], h=total_height+0.2, $fn=30);
		}


		//cutout for belt
		translate([-0.1, xy_block_length/2-min_beltbearing_height/2, total_height-5-GT2_belt_thickness-5])
			cube([xy_block_length+0.2, min_beltbearing_height, belt_area_clearance+0.1]);


		//cutout for belts and bearings going along xaxis
		translate([-0.1, xy_block_length/2-min_beltbearing_height/2, -0.1]){
			cube([(xy_block_width-20)/2+0.1, min_beltbearing_height, total_height+0.1]);			
			translate([0.1+xy_block_width-(xy_block_width-20)/2,0,0])cube([(xy_block_width-20)/2+0.1, min_beltbearing_height, total_height+0.1]);			

		}

		//holes to attach x-vslot
		//uses corner square or triangle
		translate([xy_block_width/2, 0, -0.1]){
			translate([0,xy_block_length/2-20/2-20/2,0]) cylinder(d=M5, h=total_height+0.2, $fn=30);
			translate([0,xy_block_length/2+20/2+20/2,0]) cylinder(d=M5, h=total_height+0.2, $fn=30);

		}
	


		/*translate([xy_block_width/2-belt_area_clearance_width/2, xy_block_length/2-min_beltbearing_height/2, -0.1])
			cube([belt_area_clearance_width, min_beltbearing_height, total_height+0.1]);*/
	
		
		//cut m4 screw hole to mount belt bearings
		for(x=belt_bearing_x_pos){
			
			translate([x, -0.1, belt_bearing_z_pos]){
				#rotate([-90,0,0]) cylinder(d=M4, h=xy_block_length+0.2);

				if(long_bearing_screw == true){
					//cut hole for head/nut
					rotate([-90,0,0])cylinder(d=9, h=4, $fn=60);//3.4 min height for head
					translate([0, xy_block_length+0.1-4, 0])
						rotate([-90,0,0])cylinder(d=m4_nut_diameter_horizontal, h=4+0.1, $fn=6);//3.4 min height for head
				}

			}
		}



	}


}

