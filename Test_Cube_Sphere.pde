import nervoussystem.obj.*;

PVector[][][] cube;
PVector[][][] mapLocations;
float [][][] mapHeights;
float[] placement;
int size = 200;
PVector angle;
int axis = 0;
int resolution = 499;
PImage heightMap;
float heightMultiplier = 0.08;
boolean saveOBJ = true;
float waterHeight = 110;
boolean render = false;
PImage[] faces;
PImage[][] poleFaces;

void setup() {
  size(1000, 1000, P3D);
  angle = new PVector();
  heightMap = loadImage("BW Projected Alisesh Map_4.png");

  getShapeCoords();
}

void draw() {
  background(0);
  noStroke();
  //stroke(0);
  fill(150);

  if (render) {
    if (!saveOBJ) {
      translate(width/2, height/2);

      rotateX(angle.x);
      rotateY(angle.y);
      rotateZ(angle.z);
      switch (axis) {
      case 0:
        angle.x += 0.01;
        break;
      case 1:
        angle.y += 0.01;
        break;
      case 2:
        angle.z += 0.01;
        break;
      }
    } else {
      beginRecord("nervoussystem.obj.OBJExport", "test.obj");
      println("Begin Record ...");
    }


    for (int s = 0; s < 6; s++) {
      for (int x = 0; x < resolution; x++) {
        beginShape(TRIANGLE_STRIP);
        for (int y = 0; y < resolution+1; y ++) {
          //switch (s) {
          //case 0:
          //  fill(255, 0, 0);
          //  break;
          //case 1:
          //  fill(0, 255, 0);
          //  break;
          //case 2:
          //  fill(0, 0, 255);
          //  break;
          //case 3:
          //  fill(70, 0, 0);
          //  break;
          //case 4:
          //  fill(0, 70, 0);
          //  break;
          //case 5:
          //  fill(0, 0, 70);
          //  break;
          //}
          //println(x+"\t"+y);
          vertex(cube[s][x][y].x, cube[s][x][y].y, cube[s][x][y].z);
          vertex(cube[s][x+1][y].x, cube[s][x+1][y].y, cube[s][x+1][y].z);
        }
        endShape();
      }
    }
    if (saveOBJ) {
      endRecord();
      saveOBJ = false;
      println("End Record");
    }
  } else {
    renderFaces();
    exit();
  }
  //noLoop();
}

//void renderFaces() {
//  faces = new PImage[4];
//  poleFaces = new PImage[2][4];
//  int index;

//  for (int s = 0; s < 4; s++) {
//    poleFaces[0][s] = createImage(resolution+1, resolution+1, RGB);
//    poleFaces[1][s] = createImage(resolution+1, resolution+1, RGB);
//    faces[s] = createImage(resolution+1, resolution+1, RGB);
//    poleFaces[0][s].loadPixels();
//    poleFaces[0][s].loadPixels();
//    faces[s].loadPixels();

//    index = 0;
//    for (int y = 0; y < resolution+1; y++) {
//      for (int x = 0; x < resolution+1; x++) {
//        if(index == 100500) {
//          println(x+", "+y+", "+resolution);
//          println(rotGridX(x,y,resolution,1));
//          println(rotGridX(x,y,resolution,1));
//        }
//        switch(s) {
//          //case 0: faces[s].pixels[index] = color((cube[s][x][resolution-y].mag()-size)/heightMultiplier); break;    //pole
//          //case 3: faces[s].pixels[index] = color((cube[s][resolution-y][x].mag()-size)/heightMultiplier); break;    //pole
//        case 0:
//          faces[s].pixels[index] = color((cube[1][resolution-x][y].mag()-size)/heightMultiplier);
//          poleFaces[0][s].pixels[index] = color((cube[0][rotGridX(x,resolution-y,resolution,3)][rotGridX(x,resolution-y,resolution,3)].mag()-size)/heightMultiplier);
//          poleFaces[1][s].pixels[index] = color((cube[3][rotGridX(x,y,resolution,1)][rotGridX(x,y,resolution,1)].mag()-size)/heightMultiplier);
//          break;
//        case 1:
//          faces[s].pixels[index] = color((cube[2][x][y].mag()-size)/heightMultiplier);
//          poleFaces[0][s].pixels[index] = color((cube[0][rotGridX(x,resolution-y,resolution,0)][rotGridX(x,resolution-y,resolution,0)].mag()-size)/heightMultiplier);
//          poleFaces[1][s].pixels[index] = color((cube[3][rotGridX(x,y,resolution,0)][rotGridX(x,y,resolution,0)].mag()-size)/heightMultiplier);
//          break;
//        case 2:
//          faces[s].pixels[index] = color((cube[4][x][y].mag()-size)/heightMultiplier);
//          poleFaces[0][s].pixels[index] = color((cube[0][rotGridX(x,resolution-y,resolution,1)][rotGridX(x,resolution-y,resolution,1)].mag()-size)/heightMultiplier);
//          poleFaces[1][s].pixels[index] = color((cube[3][rotGridX(x,y,resolution,3)][rotGridX(x,y,resolution,3)].mag()-size)/heightMultiplier);
//          break;
//        case 3:
//          faces[s].pixels[index] = color((cube[5][resolution-x][y].mag()-size)/heightMultiplier);
//          poleFaces[0][s].pixels[index] = color((cube[0][rotGridX(x,resolution-y,resolution,2)][rotGridX(x,resolution-y,resolution,2)].mag()-size)/heightMultiplier);
//          poleFaces[1][s].pixels[index] = color((cube[3][rotGridX(x,y,resolution,2)][rotGridX(x,y,resolution,2)].mag()-size)/heightMultiplier);
//          break;
//        }

//        index++;
//      }
//    }
//    faces[s].updatePixels();
//    faces[s].save("Test_Faces\\face_"+s+".jpeg");
//  }
//  poleFaces[0][1].save("Test_Faces\\pole_0.jpeg");
//  poleFaces[1][1].save("Test_Faces\\pole_1.jpeg");
//  saveCombinedFaces();
//}

void renderFaces() {
  faces = new PImage[6];
  PImage [] test = new PImage[4];
  int index;

  for (int s = 0; s < 6; s++) {
    faces[s] = createImage(resolution+1, resolution+1, RGB);
    faces[s].loadPixels();
    if (s < 4) {
      test[s] = createImage(resolution+1, resolution+1, RGB);
      test[s].loadPixels();
    }

    index = 0;
    for (int y = 0; y < resolution+1; y++) {
      for (int x = 0; x < resolution+1; x++) {
        switch(s) {
        case 0:
          faces[s].pixels[index] = color((cube[s][x][resolution-y].mag()-size)/heightMultiplier);
          test[s].pixels[index] = color((cube[0][rotGridX(x, y, resolution, s)][rotGridY(x, resolution-y, resolution, s)].mag()-size)/heightMultiplier);
          break;    //pole
        case 1:
          faces[s].pixels[index] = color((cube[s][resolution-x][y].mag()-size)/heightMultiplier);
          test[s].pixels[index] = color((cube[0][rotGridX(x, y, resolution, s)][rotGridY(x, resolution-y, resolution, s)].mag()-size)/heightMultiplier);
          break;
        case 2:
          faces[s].pixels[index] = color((cube[s][x][y].mag()-size)/heightMultiplier);
          test[s].pixels[index] = color((cube[0][rotGridX(x, y, resolution, s)][rotGridY(x, resolution-y, resolution, s)].mag()-size)/heightMultiplier);
          break;
        case 3:
          //faces[s].pixels[index] = color((cube[s][resolution-y][x].mag()-size)/heightMultiplier);
          faces[s].pixels[index] = color((cube[s][rotGridX(x, y, resolution, 1)][rotGridY(x, y, resolution, 1)].mag()-size)/heightMultiplier);
          test[s].pixels[index] = color((cube[0][rotGridX(x, y, resolution, s)][rotGridY(x, resolution-y, resolution, s)].mag()-size)/heightMultiplier);
          break;    //pole
        case 4:
          faces[s].pixels[index] = color((cube[s][x][y].mag()-size)/heightMultiplier);
          break;
        case 5:
          faces[s].pixels[index] = color((cube[s][resolution-x][y].mag()-size)/heightMultiplier);
          break;
        }

        index++;
      }
    }
    faces[s].updatePixels();
    faces[s].save("Faces\\face_"+s+".jpeg");
    if (s <4) {
      test[s].save("Test_Faces\\rot_"+s+".jpeg");
    }
  }
  saveCombinedFaces();
}

void saveCombinedFaces() {
  int r = (resolution+1)/2;
  PGraphics finalImg = createGraphics(r*8, r*6);
  //for (int i = 0; i < 4; i++) {
  finalImg.beginDraw();
  finalImg.background(25);
  finalImg.imageMode(CENTER);
  finalImg.image(faces[0], r*3, r*1);
  finalImg.image(faces[3], r*5, r*5);
  finalImg.image(faces[1], r*1, r*3);
  finalImg.image(faces[2], r*3, r*3);
  finalImg.image(faces[4], r*5, r*3);
  finalImg.image(faces[5], r*7, r*3);

  finalImg.endDraw();
  finalImg.save("Faces\\face_combined.jpeg");
  //}
}

//void saveCombinedFaces() {
//  int r = (resolution+1)/2;
//  PGraphics finalImg = createGraphics(r*8, r*6);
//  //for (int i = 0; i < 4; i++) {
//  int i = 0;
//  finalImg.beginDraw();
//  finalImg.background(25);
//  finalImg.imageMode(CENTER);
//  finalImg.image(poleFaces[0][i], r*(2*i+1), r*1);
//  finalImg.image(poleFaces[1][i], r*(2*i+1), r*5);
//  finalImg.image(faces[0], r*1, r*3);
//  finalImg.image(faces[1], r*3, r*3);
//  finalImg.image(faces[2], r*5, r*3);
//  finalImg.image(faces[3], r*7, r*3);
//  finalImg.endDraw();
//  finalImg.save("Test_Faces\\face_combined_"+i+".jpeg");
//  //}
//}

PImage rotateImage(PImage img, int rotationID) {
  color[][] dummy;
  PImage out;
  int index = 0;
  img.loadPixels();

  if (rotationID == 1 || rotationID == 3) {
    dummy = new color[img.height][img.width];
    out = createImage(img.height, img.width, RGB);
  } else if (rotationID == 2) {
    dummy = new color[img.width][img.height];
    out = createImage(img.width, img.height, RGB);
  } else {
    if (rotationID != 0) {
      println("ERROR with 'rotateImage'. The rotationID ("+rotationID+") is invalid");
    }
    return img;
  }

  for (int r = 0; r < img.height; r++) {
    for (int c = 0; c < img.width; c++) {
      switch(rotationID) {
      case 1:
        dummy[img.height-r-1][c] = img.pixels[index];
        break;
      case 2:
        dummy[img.width-c-1][img.height-r-1] = img.pixels[index];
        break;
      case 3:
        dummy[r][img.width-c-1] = img.pixels[index];
        break;
      }
      index++;
    }
  }
  img.updatePixels();
  
  out.loadPixels();
  index = 0;
  for (int r = 0; r < out.height; r++) {
    for (int c = 0; c < out.width; c++) {
      out.pixels[index] = dummy[c][r];
      index++;
    }
  }
  out.updatePixels();

  return out;
}

int rotGridX(int x, int y, int gridSize, int rot) {    //rot is the rotation amount (0 is normal, 1 is 90 deg cw, 2 is 180 deg, and 3 is 90 deg ccw
  int out = 0;

  switch (rot) {
  case 0:
    out = x;
    break;
  case 1:
    out = gridSize - y;
    break;
  case 2:
    out = gridSize - x;
    break;
  case 3:
    out = y;
    break;
  default:
    println("Error in 'rotGridX' for variable rot. It is '"+rot+"'");
  }

  return out;
}

int rotGridY(int x, int y, int gridSize, int rot) {    //rot is the rotation amount (0 is normal, 1 is 90 deg cw, 2 is 180 deg, and 3 is 90 deg ccw
  int out = 0;

  switch (rot) {
  case 0:
    out = y;
    break;
  case 1:
    out = x;
    break;
  case 2:
    out = gridSize - y;
    break;
  case 3:
    out = gridSize - x;
    break;
  default:
    println("Error in 'rotGridY' for variable rot. It is '"+rot+"'");
  }

  return out;
}

void getShapeCoords() {
  cube = new PVector[6][resolution+1][resolution+1];
  mapLocations = new PVector[6][resolution+1][resolution+1];
  mapHeights = new float[6][resolution+1][resolution+1];
  placement = new float[resolution+1];
  float[] values = new float[4];
  int angleOffset = (int)heightMap.width/8;
  int angle = 0;

  for (int i = 0; i < resolution+1; i++) {
    placement[i] = tan(PI/4 - PI*i/(2*resolution))*size;
  }
  heightMap.loadPixels();
  for (int x = 0; x < resolution+1; x++) {
    for (int y = 0; y < resolution+1; y ++) {
      //Create a cube based on the special "placement" array which spreads out the points
      cube[0][x][y] = new PVector(placement[x], placement[y], size);
      cube[1][x][y] = new PVector(size, placement[x], placement[y]);
      cube[2][x][y] = new PVector(placement[x], size, placement[y]);
      cube[3][x][y] = new PVector(placement[x], placement[y], -size);
      cube[4][x][y] = new PVector(-size, placement[x], placement[y]);
      cube[5][x][y] = new PVector(placement[x], -size, placement[y]);

      //sets each vector to the radius of a sphere, thus "shrink-wrapping" it to a sphere
      cube[0][x][y].setMag(size);
      cube[1][x][y].setMag(size);
      cube[2][x][y].setMag(size);
      cube[3][x][y].setMag(size);
      cube[4][x][y].setMag(size);
      cube[5][x][y].setMag(size);

      for (int s = 0; s < 6; s++) {
        mapLocations[s][x][y] = convert2Map(cube[s][x][y].x, cube[s][x][y].y, cube[s][x][y].z, size);
        angle = angleOffset+(int)mapLocations[s][x][y].x;
        if (angle >= heightMap.width-1) angle -= heightMap.width;

        //Get height Values from

        //if (s == 3 && x == 248 && y == 251) {
        //  //if (s >= 3) {
        //  println("[ "+s+", "+x+", "+y+" ]\t");
        //  println("cube:        \t\t"+cube[s][x][y].x+"\t"+cube[s][x][y].y);
        //  println("mapLocations:\t\t"+mapLocations[s][x][y].x+"\t"+mapLocations[s][x][y].y);
        //  println(angleOffset+"\t\t"+angle+"\t\t"+heightMap.width);
        //}


        //values[0] = red( heightMap.pixels[ (int) mapLocations[s][x][y].y*heightMap.width + (int)mapLocations[s][x][y].x]);                       //Upper left    [0, 0]
        //values[1] = red( heightMap.pixels[ (int) mapLocations[s][x][y].y*heightMap.width + (int)mapLocations[s][x][y].x + 1]);                   //Upper right   [1, 0]
        values[0] = red( heightMap.pixels[ (int) mapLocations[s][x][y].y*heightMap.width + angle]);                       //Upper left    [0, 0]
        values[1] = red( heightMap.pixels[ (int) mapLocations[s][x][y].y*heightMap.width + angle+1]);                   //Upper right   [1, 0]

        if ((int)mapLocations[s][x][y].y+1 >= heightMap.height) {
          values[2] = values[0];
          values[3] = values[1];
        } else {
          //values[2] = red( heightMap.pixels[ ((int) mapLocations[s][x][y].y+1)*heightMap.width + (int)mapLocations[s][x][y].x]);     //Bottom left   [0, 1]
          //values[3] = red( heightMap.pixels[ ((int) mapLocations[s][x][y].y+1)*heightMap.width + (int)mapLocations[s][x][y].x+ 1]); //Bottom right  [1, 1]
          values[2] = red( heightMap.pixels[ ((int) mapLocations[s][x][y].y+1)*heightMap.width + angle]);     //Bottom left   [0, 1]
          values[3] = red( heightMap.pixels[ ((int) mapLocations[s][x][y].y+1)*heightMap.width + angle + 1]); //Bottom right  [1, 1]
        }
        mapHeights[s][x][y] = dualInterpolate(getVectors(mapLocations[s][x][y]), values[0], values[1], values[2], values[3])-waterHeight;

        if (mapHeights[s][x][y] >= 0) {
          //println(mapHeights[s][x][y]);
          cube[s][x][y].setMag(size + heightMultiplier*mapHeights[s][x][y] + 1);
          //cube[s][x][y].setMag(size + 5);
        }
      }
    }
  }
}

void keyReleased() {
  if (keyCode == UP) {
    resolution += 2;
    getShapeCoords();
  } else if (keyCode == DOWN) {
    resolution += 2;
    getShapeCoords();
  }
}

void mouseReleased() {
  switch (axis) {
  case 0:
  case 1:
    axis++;
    break;
  case 2:
    axis = 0;
    break;
  }
}

float true_asin(float v, float x, float y) {
  float out = asin(v);

  if (x < 0) out = PI-out;
  else if (y < 0) out += TWO_PI;

  return out;
}

PVector convert2Map(float x_, float y_, float z_, float R) {
  float phi, theta;

  phi = acos(z_/R);
  theta = true_asin(y_/(R*sin(phi)), x_, y_);
  //theta =+ PI/4;
  //if (theta > 2*PI) {
  //  theta -= 2*PI;
  //}

  return new PVector(900*theta/PI, 900*phi/PI);
}

PVector[] getVectors(PVector pos) {  //gets the array of PVectors needed for the "dualInterpolate" function
  int a = (int) pos.x;                      //gets the x location in the upper left of the map coordinate
  int b = (int) pos.y;                      //gets the y location in the upper left of the map coordinate
  PVector[] out = new PVector[3];

  out[0] = new PVector(a, b);               //Upper left corner of the square that contains [x,y]
  out[1] = new PVector(a+1, b+1);           //Bottom right corner of the square that contains [x,y]
  out[2] = new PVector(pos.x, pos.y);       //Position [x,y]

  return out;
}

float dualInterpolate(PVector[] positions, float v1, float v2, float v3, float v4) {  //positions: [0] low, [1] high, [2] pos
  float top, bottom;

  if (v1 == v2) {
    top = v1;
  } else {
    top = map(positions[2].x, positions[0].x, positions[1].x, v1, v2);
  }

  if (v3 == v4) {
    bottom = v3;
  } else {
    bottom = map(positions[2].x, positions[0].x, positions[1].x, v3, v4);
  }

  if (top == bottom) {
    return top;
  }
  return map(positions[2].y, positions[0].y, positions[1].y, top, bottom);
}

//float dualInterpolate(float x1, float x2, float y1, float y2, float posX, float posY, float v1, float v2, float v3, float v4) {
//  float top, bottom;

//  top = map(posX, x1, x2, v1, v2);
//  bottom = map(posX, x1, x2, v3, v4);

//  return map(posY, y1, y2, top, bottom);
//}
