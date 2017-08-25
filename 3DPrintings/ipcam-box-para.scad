resolution_factor = 1.00;

module quarter_inch_nut_cutout()
{
    union()
    {
        translate([0, 0, -20])
            cylinder(r = 6.5/2, h = 21, $fn = 50*resolution_factor);
        
        for (i = [-60,0,60])
        {
            translate([0, 0, 5.65/2])
            rotate(i, [0, 0, 1])
                cube([11, tan(30)*11, 5.65], center = true);
        }
    }
}

module mountHold(l, w, h)
{
    cube([l, w, h]);        
}    


module camera_cutout()
{
    width = 39.5;
    height = 39.5;
    length = 68;
    cable_well_depth = 4.0;
    cable_well_width= 30.0;
    
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
        //r=15.5 for big || r=12.5 for small
        cylinder(r = 15.5, h = 20, $fn = 50);
        
        //Screwholes
        zz = 33.5/2;
        translate([-zz, 0, zz])
        rotate(90, [1, 0.01, 0])
        cylinder(r = 3.5/2, h = 4, $fn = 50);
        translate([zz, 0.01, -zz])
        rotate(90, [1, 0, 0])
        cylinder(r = 3.5/2, h = 4, $fn = 50);
        
    }
}

module camera()
{
    width = 46;
    //long=70 | short=35
    depth = 70.0;
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

/*CAMERA BOXES DIMENSIONS*/
dispH = 35;
dispV = 30;
distV = 44;

module rotated_camera(){
    translate([23, 0, 0])
    rotate(90, [1, 0, 0])
    camera();
}

module platform(){
     //SCREWBOLD CUTOUT
     difference(){
        rotate(90, [0, 0, 1])
        translate([-15, -12.5, 0])
        mountHold(25, 25, 9);
        translate([0, 0, 4])
        quarter_inch_nut_cutout(); 
         }
     }
//quarter_inch_nut_cutout(); 


union(){
    rotated_camera();
    mirror([10, , 0]) rotated_camera();
    translate([0, 37, 0])
    platform();
}











