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
  heightMap = loadImage("BW Projected Alisesh Map_5.png");

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

void renderFaces() {
  faces = new PImage[6];
  //PImage [] test = new PImage[4];
  int index;
  float value = 0;
  float max = 0;

  for (int s = 0; s < 6; s++) {
    faces[s] = createImage(resolution+1, resolution+1, RGB);
    faces[s].loadPixels();
    //if (s < 4) {
    //  test[s] = createImage(resolution+1, resolution+1, RGB);
    //  test[s].loadPixels();
    //}

    index = 0;
    for (int y = 0; y < resolution+1; y++) {
      for (int x = 0; x < resolution+1; x++) {
        switch(s) {
        case 0:
          value = (cube[s][x][resolution-y].mag()-size)/heightMultiplier;
          //if (value > 1) {
          //  value += waterHeight;
          //}
          faces[s].pixels[index] = color(value);
          //if(x%100 == 0) {
          //  print(red(faces[s].pixels[index])+" ");
          //}
          //test[s].pixels[index] = color((cube[0][rotGridX(x, y, resolution, s)][rotGridY(x, resolution-y, resolution, s)].mag()-size)/heightMultiplier);
          break;    //pole
        case 1:
          value = (cube[s][resolution-x][y].mag()-size)/heightMultiplier;
          faces[s].pixels[index] = color(value);
          //test[s].pixels[index] = color((cube[0][rotGridX(x, y, resolution, s)][rotGridY(x, resolution-y, resolution, s)].mag()-size)/heightMultiplier);
          break;
        case 2:
          value = (cube[s][x][y].mag()-size)/heightMultiplier;
          faces[s].pixels[index] = color(value);
          //test[s].pixels[index] = color((cube[0][rotGridX(x, y, resolution, s)][rotGridY(x, resolution-y, resolution, s)].mag()-size)/heightMultiplier);
          break;
        case 3:
          value = (cube[s][rotGridX(x, y, resolution, 1)][rotGridY(x, y, resolution, 1)].mag()-size)/heightMultiplier;
          faces[s].pixels[index] = color(value);
          //test[s].pixels[index] = color((cube[0][rotGridX(x, y, resolution, s)][rotGridY(x, resolution-y, resolution, s)].mag()-size)/heightMultiplier);
          break;    //pole
        case 4:
          value = (cube[s][x][y].mag()-size)/heightMultiplier;
          faces[s].pixels[index] = color(value);
          break;
        case 5:
          value = (cube[s][resolution-x][y].mag()-size)/heightMultiplier;
          faces[s].pixels[index] = color(value);
          break;
        }
        faces[s].pixels[index] = color(value*255/157.6);
        if (value > max) {
          max = value;
        }

        index++;
      }
      //if (y%100 == 0 && s == 0) {
      //  print("\n");
      //}
    }
    faces[s].updatePixels();
    faces[s].save("Faces\\face_"+s+".png");
    //if (s <4) {
    //  test[s].save("Test_Faces\\rot_"+s+".png");
    //}
  }
  saveCombinedFaces();
  println(max);
}

void saveCombinedFaces() {
  int r = (resolution+1)/2;
  PGraphics finalImg = createGraphics(r*8, r*6);
  //for (int i = 0; i < 4; i++) {
  finalImg.beginDraw();
  finalImg.background(25, 25, 0);
  finalImg.imageMode(CENTER);
  finalImg.image(faces[1], r*1, r*3);
  finalImg.image(faces[2], r*3, r*3);
  finalImg.image(faces[4], r*5, r*3);
  finalImg.image(faces[5], r*7, r*3);
  finalImg.image(faces[0], r*3, r*1);
  finalImg.image(faces[3], r*5, r*5);

  finalImg.save("Faces\\face_combined_square.png");


  finalImg.image(rotateImage(faces[0], 3), r*1, r*1);
  finalImg.image(rotateImage(faces[0], 1), r*5, r*1);
  finalImg.image(rotateImage(faces[0], 2), r*7, r*1);

  finalImg.image(rotateImage(faces[3], 2), r*1, r*5);
  finalImg.image(rotateImage(faces[3], 1), r*3, r*5);
  finalImg.image(rotateImage(faces[3], 3), r*7, r*5);
  
  finalImg.save("Faces\\face_combined.png");

  triangles(finalImg);

  finalImg.save("Faces\\face_combined_triangles.png");
  finalImg.endDraw();
  //}
}

void triangles(PGraphics pg) {
  pg.noStroke();
  pg.fill(25, 25, 0);
  int r = resolution+1;

  for (int i = 0; i < 5; i++) {
    pg.triangle(i*r, r-1, (i+1)*r, 0-1, (i-1)*r, 0-1);
    pg.triangle(i*r, r*2+1, (i+1)*r, 3*r+1, (i-1)*r, 3*r+1);
  }
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

//float dualInterpolate(float x1, float x2, float y1, float y2, float posX, float posY, float v1, float v2, float v3, float v4) {
//  float top, bottom;

//  top = map(posX, x1, x2, v1, v2);
//  bottom = map(posX, x1, x2, v3, v4);

//  return map(posY, y1, y2, top, bottom);
//}
