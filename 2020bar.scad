/* Global */

//Extrusion height
//extruded_2020(100);

corner_bar_offset = 7.5;
corner_bar_width = 4.5;

outer_notch_offset = 10;
outer_notch_width = 7.2;
outer_notch_depth = 1;

extruded_2020_width = 20;

module extruded_2020(bar_height = 10){
    render() {
        translate([0,0,bar_height/2])
        intersection(){
            cylinder(d=26.87,h=bar_height,center=true, $fn=200);
            difference(){
                union(){
                    difference(){
                    cube([20,20,bar_height],center=true);
                        translate([0,0,-0.5]) union()    
                        {
                            cube([16.4,16.4,bar_height+2],center=true);
                            cube([6.2,20,bar_height+2],center=true);
                            cube([20,6.2,bar_height+2],center=true);
                            
                            translate([0,outer_notch_offset,0])
                            cube([outer_notch_width,outer_notch_depth,bar_height+2],center=true);
                            translate([outer_notch_offset,0,0])
                            cube([outer_notch_depth,outer_notch_width,bar_height+2],center=true);
                            translate([0,-outer_notch_offset,0])
                            cube([outer_notch_width,outer_notch_depth,bar_height+2],center=true);
                            translate([-outer_notch_offset,0,0])
                            cube([outer_notch_depth,outer_notch_width,bar_height+2],center=true);
                        }
                            
                    }
                    rotate([0,0,45]){
                        cube([1.5,26,bar_height],center=true);
                        cube([26,1.5,bar_height],center=true);
                    }
                    translate([corner_bar_offset,corner_bar_offset,0])   cube([corner_bar_width,corner_bar_width,bar_height],center=true);
                    translate([-corner_bar_offset,-corner_bar_offset,0]) cube([corner_bar_width,corner_bar_width,bar_height],center=true);
                    translate([-corner_bar_offset,corner_bar_offset,0])  cube([corner_bar_width,corner_bar_width,bar_height],center=true);
                    translate([corner_bar_offset,-corner_bar_offset,0])  cube([corner_bar_width,corner_bar_width,bar_height],center=true);
                    cube([8,8,bar_height],center=true);
                }
                translate([0,0,-0.5]) cylinder(r=2.5,h=bar_height+2,center=true, $fn=200);
            }
        }
    }
}