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


module poly_square(by, bx, ty, tx)
{
    polyhedron(
       points=[
                //Buttom Points
              [ 0, 0, 0 ],  //0
              [ 0, by, 0 ],  //1
              [ bx, by, 0 ],  //2
              [ bx, 0, 0 ],  //3
                //Top Points1
              [ 0, 0, ty ],  //4
              [ 0, by, ty ],  //5
              [ bx, by, tx ],  //6
              [ bx, 0, tx ]], //7
        faces=[
              [0,1,2,3],  // bottom
              [7,6,5,4],  // top
              [4,5,1,0],  // x0
              [5,6,2,1],  // parax
              [6,7,3,2],  // paray
              [7,4,0,3]] // y0
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
        cylinder(r = 12.5, h = 20, $fn = 50);
        
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

/*POLYHEDRA BOX DIMENSIONS*/
aby = 50;
abx = 40;
aty = 27;
atx = 5;

/*CAMERA BOXES DIMENSIONS*/
dispH = 35;
dispV = 30;
distV = 44;

module boxANDpoly(){

    union(){
        color( "PaleGreen", 1.0 ) {
            translate([-30, 0, 0])
            poly_square(aby, abx, aty, atx);
                    }   
        color( "MediumPurple", 1.0 ) {
            translate([15, 25, 27])
            rotate([30, 0, 90])
            camera();
        }
     }
}

module unit(){
    difference(){    
        translate([0, 14, 0])
        rotate([0, 0, 35])
        boxANDpoly();
        translate([-50, -70, -10])
        cube([70, 70, 70]);
    }
}


//unit();
//mirror([0, 1, 0]) unit();

     //SCREWBOLD CUTOUT
module holder(){
     difference(){
        translate([-15, -20, 0])
        mountHold(25, 40, 7);
        translate([0, 0, 4])
        quarter_inch_nut_cutout(); 
         }
}

holder();














