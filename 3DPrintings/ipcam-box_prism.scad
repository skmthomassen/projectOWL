resolution_factor = 1.00;

aby = 5;
abx = 5;
aty = 5;
atx = 2;

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

poly_square(aby, abx, aty, atx);

/*
    polyhedron(
        points=[
            [10, 0, 0],  //0
            [0, 10, 0],  //1
            [-10, 0, 0],  //2
            [0, -10, 0],  //3
            [0, 0, 10]],  //4
        faces=[
            [0, 1, 2, 3],
            [4, 1, 0],
            [4, 2, 1],
            [4, 3, 2],
            [4, 0, 3]]    
    );    
*/











