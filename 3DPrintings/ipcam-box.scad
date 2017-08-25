resolution_factor = 1.00;

module prism(l, w, h)
{
    polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );    
}

module camera_cutout()
{
    width = 39.5;
    height = 39.5;
    length = 68;
    cable_well_depth = 4.0;
    cable_well_width= 20.0;
    
    //How much do we pull back 
    translate([0, 3, 0])
    
    union()
    {
        //Basic block of electronics
        translate([0, length/2, 0])
        cube([width, length, height], center = true);
        
        //Channel for cables between electronics
        translate([0, length/2.0, 0])
        cube([width+cable_well_depth, length, cable_well_width], center = true);
        translate([0, length/2.0, 0])
        cube([cable_well_width, length, height+cable_well_depth], center = true);
        
        //Lens hole
        translate([0, 0.01, 0])
        rotate(90, [1, 0, 0])
        cylinder(r = 13, h = 20, $fn = 50);
        
        //Screwholes
        zz = 33.5/2;
//        translate([zz, 0.01, zz])
//        rotate(90, [1, 0, 0])
//        cylinder(r = 3.5/2, h = 4, $fn = 50);
        translate([-zz, 0, zz])
        rotate(90, [1, 0.01, 0])
        cylinder(r = 3.5/2, h = 4, $fn = 50);
        translate([zz, 0.01, -zz])
        rotate(90, [1, 0, 0])
        cylinder(r = 3.5/2, h = 4, $fn = 50);
//       translate([-zz, 0.01, -zz])
//       rotate(90, [1, 0, 0])
//       cylinder(r = 3.5/2, h = 4, $fn = 50);
        
    }
}

module camera()
{
    width = 46;
    depth = 35.0;
    difference()
    {
        union()
        {
            translate([0, depth/2, 0])
            cube([width, depth, width], center = true);
        }
        camera_cutout();
    }
}


/*

color( "LightCoral", 1.0 ) {
    translate([-distV,0,0])
    rotate([dispV,0,-dispH])
    camera();
}
*/

//SUPPORT PRISMS


//DRAWING THE CAMERA BOXES
dispH = 35;
dispV = 30;
distV = 44;

$fn=100;


module sup(){

    difference(){
        difference(){
            color( "PaleGreen", 1.0 ) {
                translate([15, -20, -27])
                rotate([0,0,dispH])
                    prism(60, 50, 30);
            }   
            translate([-35, 2, -40])
            cube(size = [35, 30, 55], center = false);
        }

        translate([25, -40, -30])
        rotate([0,0,dispH])
        cube(size = [80, 30, 15], center = false);
        }


     color( "MediumPurple", 1.0 ) {
         translate([distV,0,0])
         rotate([dispV,0,dispH])
         camera();
     }
}

sup();

mirror([1,0,0]) sup();


/*
color( "White", 1.0 ) {
    translate([-35, 2, -40])
    cube(size = [35, 30, 55], center = false);
}

difference(){
    color( "LightBlue", 1.0 ) {
        translate([-65, 15, -27])
        rotate([0,0,-dispH])
            prism(60,50,30);
    }   
    translate([0.5, 2, -40])
    cube(size = [35, 30, 55], center = false);

}

*/



























