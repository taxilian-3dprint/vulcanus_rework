// Eccentric Spacer - Makerslice compatible
// as per http://www.buildlog.net/sm_laser/drawings/b18001_rev_3.pdf
//
// CC-BY-SA Licenced under Creative Commons-Share Alike 3.0 Licence
//
//
// modified by @makevoid for more generic m5 spacer - metric 
// modified by Richard Bateman to make module parameterized
//
// http://openbuildspartstore.com/eccentric-spacers/
//
// http://cdn1.bigcommerce.com/server2300/itwgldve/products/97/images/1038/Eccentric_Spacer_Version_3__55794.1392409357.1280.1280.jpg?c=1

tol = 0.3; // tolerance, you know, plastic expands

i = 25.4;						// inch
fn=100;						// used for $fs

//mEsRoundD = 9;			// Round Diameter // maxed
//mEsHexD  =  12.85-tol;		// Hole Hex Diameter M8 wrench


module eccentric_spacer(hex_height = 6.35, round_height = 2.50,
    hex_diameter = 9.87, round_diameter = 7.64, hole_diameter = 5, hole_offset=0.79, tolerance=0.3) {

  total_height =   hex_height + round_height;
  difference() {
	 union() {
		cylinder(r=(hex_diameter-tolerance)/2,h=hex_height,$fn=6);
	 	cylinder(r=round_diameter/2,h=total_height,$fn=fn);
	 } // u
		translate([0,hole_offset,-0.1]) 
         cylinder(r=(hole_diameter+tolerance)/2,h=total_height+0.2,$fn=fn);
  } // d
			
}

eccentric_spacer();
translate([ 0, 16]) spacer();
translate([16,  0]) spacer();
translate([16, 16]) spacer();