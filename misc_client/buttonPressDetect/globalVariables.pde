
// IMPORTS
// -------------------------------- //

import processing.net.*;
import SimpleOpenNI.*;
import blobDetection.*;
import java.awt.*;
import java.io.File;
import java.io.IOException;

// DECLARATIONS
// -------------------------------- //

Client client;
SimpleOpenNI context;
CircleButton[] circle;
BlobDetection bd;

// VARIABLES
// -------------------------------- //

// State
String truthTest = "true";
boolean runCalibration = false;
boolean debugToConsole = false;
boolean displayImages = false;
boolean appReady = false;
boolean inTri = false;

// Calibration
int calibState = 0;

// XML Variables 
XMLElement xml;      // The XML document
int numButtons;      // # of buttons to arrange acround the circle
int sizeButton;      // size of each button
int trigTime;        // time required to activate trigger
String ipAddress;    // IP Address to connect to
int port;            // PORT to connect to
int delayTime;       // Delay Between Index and Play Messages
int tableHeight;     // The Depth Offset Of The Table 
int zOffset;         // The Z Offset Of The Kinect
String calibrate;    // Whether to Recalibrate or go to Detection mode
String display;      // Whether to display blobs / Kinect image
String debug;         // Whether to debug info to console
float blobMin;       // The minimum size of a blob to pass forward
float blobMax;       // The maximum size of a blob to pass forward
float blobThresh;    // The threshold of the blob detection routine

// Crop Position Variables
String cropPos[];
int cropL, cropR, cropT, cropB; // The Crops of Where to Detect Kinect Data
String pathName = "";
String cropFile = "cropPositions.txt";
boolean cropCalib = false;

// Poly
String polyPos[];
String polyCrop = "polyPositions.txt";
PVector[] poly;
float pv0, pv1, pv2, pv3, pv4, pv5, pv6, pv7;
boolean inPoly = false;
PVector projection = new PVector();

// Circle 
int circX[], circY[];
String circPos[];
int circleCount = 0;
boolean circleCalib = false;
String circFile = "circlePositions.txt";

color currentColor = color(125);
color baseColor = color(125);
color buttonColor = color(203);
color highlight = color(255,0,0);

// XY Coordinates
float handX, handY;
float oldBlobX, oldBlobY;
boolean zone = false;

// Kinect Space
float zoom = 1.0;
float rotX = radians(180);
float rotY = radians(0);

// Timer
int newTimer = 0;
int globalTimer = 0;
int delayMessage = 5000;
boolean checkTimer = false;
boolean stillOver = false;

// Network Messages
String message;
boolean msgReady = true;

// Blob Detection
float blobX, blobY;
color blobNo = color(0); 
color blobYes = color(0, 255, 0); 



