part = "20x Extrusion"; //[20x Extrusion, Wheel, OpenRail, 20mm Gantry Plate, Universal Gantry Plate, OpenRail Gantry Plate, 20x End Cap, T-Nut] 

//type = "20mm"; //[20mm, 40mm, 60mm, 80mm]

//scale_factor = 1; //[1:Full, 0.5:Half, 0.25:Quarter]

//length = 20;

/*[Hidden]*/
$fn=100;
delta=0.01;
tolerance = 0.2;



module oval_hole(length = 20){
    translate([-length/2,-diameter/2,0])
    cube([length,diameter,height]);
    
    translate([length/2,0,0])
    cylinder(h=height, d=diameter);
    
    translate([-length/2,0,0])
    cylinder(h=height, d=diameter);    
}

//Basic outline of one quarter of extrusion
module vslot_unit(){
    difference(){
        union(){
            polygon(points=[[0,0],[0,3.7],[0.2*sqrt(2),3.9],[3.9-1.5*sqrt(0.5),3.9],[5.5,5.5+1.5*sqrt(0.5)],[5.5,8.2],[2.88,8.2],[2.88,8.3],[4.58,10],[8.5,10],[8.5,8.5],[10,8.5],[10,4.85],[8.3,2.88],[8.2,2.88],[8.2,5.5],[5.5+1.5*sqrt(0.5),5.5],[3.9,3.9-1.5*sqrt(0.5)],[3.9,0.2*sqrt(2)],[3.7,0]]);
            
            translate([8.5,8.5,0])
            circle(d=3);
        }
        
        union(){
            circle(d=5);
            
            polygon(points=[[6.57,8.2],[8.2,8.2],[8.2,6.57],[7.66,6.57],[6.57,7.66]]);
        }
    }
}

//Basic outline used in the middle of anything larger than 20x20
module vslot_extension_unit(){
    difference(){
        union(){
            polygon(points=[[0,0],[0,3.7],[0.2*sqrt(2),3.9],[3.9-1.5*sqrt(0.5),3.9],[5.5,5.5+1.5*sqrt(0.5)],[5.5,8.2],[2.78,8.2],[4.58,10],[10,10],[10,8.2],[7.3,8.2],[7.3,7.3-1.5*sqrt(0.5)],[3.9,3.9-1.5*sqrt(0.5)],[3.9,0.2*sqrt(2)],[3.7,0]]);
        }
        
        union(){
            circle(d=5);
        }
    }
}

//Pieces together the extention units
module vslot_extension_part(){
    translate([-20,0,0])
    vslot_extension_unit();
    
    translate([-20,0,0])
    mirror([0,1,0])
    vslot_extension_unit();
    
    rotate([0,0,180])
    vslot_extension_unit();
    
    mirror([0,1,0])
    rotate([0,0,180])
    vslot_extension_unit();
}

//Pieces together the extrusion
module 2020_extrusion(sections, offset_r, length = 20, type="20mm"){
    linear_extrude(height=length)
    offset(r=offset_r)
    union(){
        for(i=[0:1])
            rotate([0,0,-i*90])
            vslot_unit();
        
        translate([-20*(sections),0,0])
        for(i=[2:3])
            rotate([0,0,-i*90])
            vslot_unit();
        
        if(type != "20mm")
            for(i=[0:sections-1])
                translate([-20*i,0,0])
                vslot_extension_part();
    }
}

module vSlotWheel(){
    rotate_extrude()
    //Wheel cross section
    polygon(points=[[6.94717,-0.5],[7.98715,-0.5],[7.98715,-4.816523],[8.28715,-5.116523],[9.774828,-5.116523],[11.945,-2.946351],[11.945,-2.44542],[10.049828,-0.275],[9.374828,-0.275],[9.374828,0.275],[10.049828,0.275],[11.945,2.44542],[11.945,2.946351],[9.774828,5.116523],[8.28715,5.116523],[7.98715,4.816523],[7.98715,0.5],[6.94717,0.5]]);
}

module openrail(length = 20){
    difference(){
        linear_extrude(height=length)
        union(){
            //OpenRail cross section
            polygon(points=[[0,0.3],[0.3,0.3],[0.3,0],[2.075,0],[2.075,0.3],[2.375,0.3],[2.375,19.529],[4.75,19.529],[4.75,20.329],[2.375+0.5*sqrt(0.5),22.704-0.5*sqrt(0.5)],[2.375,22.704-0.5*sqrt(2)],[2.375-0.5*sqrt(0.5),22.704-0.5*sqrt(0.5)],[0,20.329]]);
            
            translate([0.3,0.3,0])
            circle(d=0.6);
            
            translate([2.075,0.3,0])
            circle(d=0.6);
            
            translate([2.375,22.704-0.5*sqrt(2),0])
            circle(d=1);
        }
        
        for(i=[0:floor(length/50)])
            translate([-delta,9.7543,50*(i+0.5)])
            rotate([0,90,0])
            rotate([0,0,-90])
            oval_hole(length=6.7, diameter=5.3, height=2.375+2*delta);
    }
}

plate_spec = [
["width","Depth","Thickness","Corner Radius",
    ["Hole Diameter","Hole Length (0 for circle)","X translation","Y translation"]
],

//20mm Gantry Plate
[65.5,65.5,3,3.36,
    [3,6.5,-20.146,27.7],[3,6.5,0,27.7],[3,6.5,20.146,27.7],
    [5,0,-19.85,20],[5,20.64,0,20],[7.2,0,19.85,20],
    [5,0,-19.85,10],[5,0,0,10],[5,0,19.85,10],
    [5,0,-19.85,0],[5,0,-10,0],[5,0,0,0],[5,0,10,0],[7.2,0,19.85,0],
    [5,0,-19.85,-10],[5,0,0,-10],[5,0,19.85,-10],
    [5,0,-19.85,-20],[5,20.64,0,-20],[7.2,0,19.85,-20],
    [3,6.5,-20.146,-27.7],[3,6.5,0,-27.7],[3,6.5,20.146,-27.7]
],

//Universal Gantry Plate
[127,88,3,3.36,
    [3,6.5,-20,38.02],[3,6.5,0,38.02],[3,6.5,20,38.02],
    [5,0,-49.85,30.32],[5,0,-39.85,30.32],[5,0,-29.85,30.32],[5,0,-19.85,30.32],[5,20,0,30.32],[7.2,0,19.85,30.32],[7.2,0,29.85,30.32],[7.2,0,39.85,30.32],[7.2,0,49.85,30.32],
    [5,0,-49.85,20.325],[5,0,-39.85,20.325],[5,0,-29.85,20.325],[5,0,-19.85,20.325],[5,0,-10,20.325],[5,0,0,20.325],[5,0,10,20.325],[5,0,19.85,20.325],[5,0,29.85,20.325],[5,0,39.85,20.325],[5,0,49.85,20.325],
    [5,0,-14.825,14.82],[5,0,14.825,14.82],
    [5,0,-29.85,10],[5,0,-19.85,10],[5,0,0,10],[5,0,19.85,10],[5,0,29.85,10],
    [5,0,-49.85,0],[5,0,-39.85,0],[5,0,-29.85,0],[5,0,-19.85,0],[5,0,-10,0],[5,0,0,0],[5,0,10,0],[7.2,0,19.85,0],[7.2,0,29.85,0],[7.2,0,39.85,0],[7.2,0,49.85,0],
    [5,0,-29.85,-10],[5,0,-19.85,-10],[5,0,0,-10],[5,0,19.85,-10],[5,0,29.85,-10],
    [5,0,-14.825,-14.82],[5,0,14.825,-14.82],
    [5,0,-49.85,-20.325],[5,0,-39.85,-20.325],[5,0,-29.85,-20.325],[5,0,-19.85,-20.325],[5,0,-10,-20.325],[5,0,0,-20.325],[5,0,10,-20.325],[5,0,19.85,-20.325],[5,0,29.85,-20.325],[5,0,39.85,-20.325],[5,0,49.85,-20.325],
    [5,0,-49.85,-30.32],[5,0,-39.85,-30.32],[5,0,-29.85,-30.32],[5,0,-19.85,-30.32],[5,20,0,-30.32],[7.2,0,19.85,-30.32],[7.2,0,29.85,-30.32],[7.2,0,39.85,-30.32],[7.2,0,49.85,-30.32],
    [3,6.5,-20,-38.02],[3,6.5,0,-38.02],[3,6.5,20,-38.02]
],

//OpenRail 20mm Gantry Plate
[80,80,3.175,10,
    [5,0,-22.3,22.3],[5,0,0,22.3],[7.137,0,22.3,22.3],
    [5,0,0,22.30],
    [5,0,0,10],
    [5,0,-22.3,0],[5,0,-10,0],[5,0,0,0],[5,0,10,0],[7.137,0,22.3,0],
    [5,0,0,-10],
    [5,0,-22.3,-22.3],[5,0,0,-22.3],[7.137,0,22.3,-22.3]
],

//OpenRail 40mm Gantry Plate
[100,120,3.175,10,
    [5,0,-32.3,42.3],[5,0,-22.3,42.3],[5,0,-10,42.3],[5,0,0,42.3],[5,0,10,42.3],[7.137,0,22.3,42.3],[7.137,0,32.3,42.3],
    [5,0,-10,30],[5,0,10,30],
    [5,0,-10,20],[5,0,10,20],
    [5,0,-40,10],[5,0,-20,10],[5,0,0,10],[5,0,20,10],[5,0,40,10],
    [5,0,-32.3,0],[5,0,-10,0],[5,0,0,0],[5,0,10,0],[7.137,0,32.3,0],
    [5,0,-40,-10],[5,0,-20,-10],[5,0,0,-10],[5,0,20,-10],[5,0,40,-10],
    [5,0,-10,-20],[5,0,10,-20],
    [5,0,-10,-30],[5,0,10,-30],
    [5,0,-32.3,-42.3],[5,0,-22.3,-42.3],[5,0,-10,-42.3],[5,0,0,-42.3],[5,0,10,-42.3],[7.137,0,22.3,-42.3],[7.137,0,32.3,-42.3]
],

//OpenRail 60mm Gantry Plate
[120,140,3.175,10,
    [5,0,-42.3,52.3],[5,0,-32.3,52.3],[5,0,-22.3,52.3],[5,0,-10,52.3],[5,0,0,52.3],[5,0,10,52.3],[7.137,0,22.3,52.3],[7.137,0,32.3,52.3],[7.137,0,42.3,52.3],
    [5,0,-20,30],[5,0,0,30],[5,0,20,30],
    [5,0,-42.3,26.3],[7.137,0,42.3,26.3],
    [5,0,-30,20],[5,0,0,20],[5,0,30,20],
    [5,0,-45,10],[5,0,0,10],[5,0,45,10],
    [5,0,-42.30,0],[5,0,-30,0],[5,0,-20,0],[5,0,-10,0],[5,0,0,0],[5,0,10,0],[5,0,20,0],[5,0,30,0],[7.137,0,42.30,0],
    [5,0,-45,-10],[5,0,0,-10],[5,0,45,-10],
    [5,0,-30,-20],[5,0,0,-20],[5,0,30,-20],
    [5,0,-42.3,-26.3],[7.137,0,42.3,-26.3],
    [5,0,-20,-30],[5,0,0,-30],[5,0,20,-30],
    [5,0,-42.3,-52.3],[5,0,-32.3,-52.3],[5,0,-22.3,-52.3],[5,0,-10,-52.3],[5,0,0,-52.3],[5,0,10,-52.3],[7.137,0,22.3,-52.3],[7.137,0,32.3,-52.3],[7.137,0,42.3,-52.3]
],

//OpenRail 80mm Gantry Plate
[140,160,3.175,10,
    [5,0,-52.3,62.3],[5,0,-42.3,62.3],[5,0,-32.3,62.3],[5,0,-22.3,62.3],[5,0,-10,62.3],[5,0,0,62.3],[5,0,10,62.3],[7.137,0,22.3,62.3],[7.137,0,32.3,62.3],[7.137,0,42.3,62.3],[7.137,0,52.3,62.3],
    [5,0,-30,40],[5,0,-20,40],[5,0,20,40],[5,0,30,40],
    [5,0,-52.3,35],[7.137,0,52.3,35],
    [5,0,-40,30],[5,0,0,30],[5,0,40,30],
    [5,0,-55,10],[5,0,-40,10],[5,0,0,10],[5,0,40,10],[5,0,55,10],
    [5,0,-52.3,0],[5,0,-30,0],[5,0,-10,0],[5,0,0,0],[5,0,10,0],[5,0,30,0],[5,0,52.3,0],
    [5,0,-55,-10],[5,0,-40,-10],[5,0,0,-10],[5,0,40,-10],[5,0,55,-10],
    [5,0,-40,-30],[5,0,0,-30],[5,0,40,-30],
    [5,0,-52.3,-35],[7.137,0,52.3,-35],
    [5,0,-30,-40],[5,0,-20,-40],[5,0,20,-40],[5,0,30,-40],
    [5,0,-52.3,-62.3],[5,0,-42.3,-62.3],[5,0,-32.3,-62.3],[5,0,-22.3,-62.3],[5,0,-10,-62.3],[5,0,0,-62.3],[5,0,10,-62.3],[7.137,0,22.3,-62.3],[7.137,0,32.3,-62.3],[7.137,0,42.3,-62.3],[7.137,0,52.3,-62.3]
]
];

module vSlotPlate (plate_type){
    difference(){
        //The plate
        translate([-(plate_spec[plate_type][0]-plate_spec[plate_type][3])/2,-(plate_spec[plate_type][1]-plate_spec[plate_type][3])/2,0])
        minkowski(){
            cube([plate_spec[plate_type][0]-plate_spec[plate_type][3],plate_spec[plate_type][1]-plate_spec[plate_type][3],plate_spec[plate_type][2]/2]);
            cylinder(h=plate_spec[plate_type][2]/2, d=plate_spec[plate_type][3]);
        }
        
        //The holes
        for (i=[4:len(plate_spec[plate_type])-1]){
            translate([plate_spec[plate_type][i][2],plate_spec[plate_type][i][3],-delta])
            oval_hole(height=plate_spec[plate_type][2]+2*delta,diameter=plate_spec[plate_type][i][0],length=plate_spec[plate_type][i][1]);
        }
    }
}

module end_cap(sections, offset_r){
    difference(){
        translate([-8.5-20*sections,-8.5,-2])
        minkowski(){
            cube([17+20*sections,17,6]);
            cylinder(h=6, d=3);
        }
        
        2020_extrusion(sections, offset_r);
    }
}

module t_nut(length = 20){
    difference(){
        linear_extrude(height=length)
        //2.5*tolerance allows T-Nut to move freely, reduce ratio for tighter fit
        offset(r=-2.5*tolerance)
        polygon(points=[[3.9-1.5*sqrt(0.5),3.9],[5.5,5.5+1.5*sqrt(0.5)],[5.5,8.2],[-5.5,8.2],[-5.5,5.5+1.5*sqrt(0.5)],[-3.9+1.5*sqrt(0.5),3.9]]);
        
        translate([0,3.9+tolerance-delta,length/2])
        rotate([0,30,0])
        rotate([-90,0,0])
        union(){
            // h = depth of nut hole
            // d/sqrt(3) = nut size, flat-flat
            cylinder(h=3, d=5.5*sqrt(3), $fn=6);
            
            // d = diameter of hole for bolt thread
            cylinder(h=4.3-2*tolerance+2*delta, d=3.1);
        }
    }
}

module show_what(type="20mm"){
    if(part == "20x Extrusion"){
        if(type == "20mm")
            2020_extrusion(sections=0, offset_r=0);
        if(type == "40mm")
            2020_extrusion(sections=1, offset_r=0);
        if(type == "60mm")
            2020_extrusion(sections=2, offset_r=0);
        if(type == "80mm")
            2020_extrusion(sections=3, offset_r=0);
    }
    if(part == "Wheel")
        vSlotWheel();
    if(part == "OpenRail")
        openrail();
    if(part == "20mm Gantry Plate")
        vSlotPlate(plate_type=1);
    if(part == "Universal Gantry Plate")
        vSlotPlate(plate_type=2);
    if(part == "OpenRail Gantry Plate"){
        if(type == "20mm")
            vSlotPlate(plate_type=3);
        if(type == "40mm")
            vSlotPlate(plate_type=4);
        if(type == "60mm")
            vSlotPlate(plate_type=5);
        if(type == "80mm")
            vSlotPlate(plate_type=6);
    }
    if(part == "20x End Cap"){
        if(type == "20mm")
            end_cap(sections=0, offset_r=tolerance);
        if(type == "40mm")
            end_cap(sections=1, offset_r=tolerance);
        if(type == "60mm")
            end_cap(sections=2, offset_r=tolerance);
        if(type == "80mm")
            end_cap(sections=3, offset_r=tolerance);
    }
    if(part == "T-Nut")
        t_nut();
}

//2020_extrusion(sections=0, offset_r=0, length=590);

//color("silver")
//scale(scale_factor)
//show_what();