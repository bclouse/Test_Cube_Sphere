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
