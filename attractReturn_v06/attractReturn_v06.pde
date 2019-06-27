// M_4_2_01.pde
// Attractor.pde
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * a simple attractor
 *
 * MOUSE
 * left click, drag  : attract nodes
 * right click drag  : inverse attract nodes
 
 ARROW UP/DOWN       :  adjust nodeSize
 
 * KEYS
 * d/f               : toggles swirl on and off 
 * q/w               : toggles return nodes on and off
 * r                 : reset nodes
 * s                 : save png
 */

import generativedesign.*;
import java.util.Calendar;
PImage img;
import processing.video.*;

Capture video;

boolean returnBool;
boolean swirlBool;
int nodeSize;
int ex,why;
int xCount = 400;
int yCount = 400;
int gridSize = 400;
float initialPosesX[] = new float[xCount*yCount]; 
float initialPosesY[] = new float[xCount*yCount]; 
int edgeX;
int edgeY;

color pixelColor[]=new color[xCount*yCount];

// nodes array 
Node[] myNodes = new Node[xCount*yCount];

// attractor
Attractor myAttractor;


// image output
boolean saveOneFrame = false;



void setup() {  
  size(500, 500); 
video = new Capture(this, 640, 480);
video.start();  
 int count = video.width * video.height;
  edgeX=(video.width-xCount)/2;
  edgeY=(video.height-yCount)/2;
  // setup drawing parameters
  colorMode(RGB, 255, 255, 255, 100);
  smooth();
  noStroke();
loadPixels();
  background(255); 
returnBool=true;
  cursor(CROSS);
 //img = loadImage("me.jpg");
  // setup node grid
  initGrid();

  // setup attractor
  myAttractor = new Attractor(0, 0);
}

void draw() {
  if (video.available()){
  fill(0, 10);
  rect(0, 0, width, height);
  video.read();
  video.loadPixels();
  myAttractor.x = mouseX;
  myAttractor.y = mouseY;

  for (int i = 0; i < myNodes.length; i++) {
    if (mousePressed && (mouseButton == RIGHT)) {
     // returnBool=false;
     if (swirlBool==true){
      myAttractor.attractRight(myNodes[i]);
     }
     else if (swirlBool==false){
     myAttractor.attractIn(myNodes[i]);
     }
    }
    else if (mousePressed && (mouseButton == LEFT)) {
     // returnBool=false;
     if(swirlBool==true){
      myAttractor.attractLeft(myNodes[i]);
     }
     else if (swirlBool==false){
     myAttractor.attractOut(myNodes[i]);
     }
    }
//if (returnBool==true){
  else{
  myAttractor.x = initialPosesX[i];
  myAttractor.y = initialPosesY[i];
  if (returnBool==true){
   myAttractor.returning(myNodes[i]);
  }
}

    myNodes[i].update();
    why= (i/yCount);
    ex= (i%xCount);
pixelColor[i] = video.pixels[(why+edgeY)*video.width+(edgeX+ex)];
                  
    // draw nodes
    fill(pixelColor[i]);
    //fill(44);
    rect(myNodes[i].x, myNodes[i].y, random(0,nodeSize), random(0,nodeSize));
  }

  // image output
  if (saveOneFrame == true) {
    saveFrame("_M_4_1_02_"+timestamp()+".png");
    saveOneFrame = false;
  }
}
  }


void initGrid() {
  nodeSize=1;
  returnBool=true;
  video.read();
  video.loadPixels();
  int i = 0; 
  for (int y = 0; y < yCount; y++) {
    for (int x = 0; x < xCount; x++) {
      float xPos = x*(gridSize/(xCount))+(width-gridSize)/2;
      float yPos = y*(gridSize/(yCount+0))+(height-gridSize)/2;
      myNodes[i] = new Node(xPos, yPos);
      myNodes[i].setBoundary(0, 0, width, height);
      myNodes[i].setDamping(0.02);  //// 0.0 - 1.0
      initialPosesX[i]=xPos;
      initialPosesY[i]=yPos;
      
      //float tileWidth = width / (float)img.width;
      //float tileHeight = height / (float)img.height;
      //float posX = tileWidth*xPos;
      //float posY = tileHeight*yPos; 
      pixelColor[i] = video.pixels[(y+edgeY)*video.width+(edgeX+x)];
      
      
      i++;
    }
  }
}


void keyPressed() {
  if (key=='r' || key=='R') {
    initGrid();
  }
  if(key=='q'){
  returnBool=true;
  println("returnNodes On");
  }
  
    if(key=='w'){
  returnBool=false;
  println("returnNodes Off");
  }

    if(key=='f'){
  swirlBool=false;
  println("swirl Off");
  }
  
    if(key=='d'){
  swirlBool=true;
  println("swirl On");
  }

  if (key=='s' || key=='S') {
    saveOneFrame = true;
  }
  
  if (key == CODED) {
    if (keyCode == UP) {
      if(nodeSize<width){
    nodeSize+=1;  
      }
      println("nodeSize:  "+nodeSize);
    }
     else if (keyCode == DOWN) {
       if(nodeSize>0){
    nodeSize-=1;
       }
       println("nodeSize:  "+nodeSize);
    }
    
  }
}


String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}
