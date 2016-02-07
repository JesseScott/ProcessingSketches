

// Imports
import android.content.Context;
import android.app.Notification;
import android.app.NotificationManager;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorManager;
import android.hardware.SensorEventListener;
// Vibration Globals:
NotificationManager gNotificationManager; // Android Class to tell User that an event has occurred
Notification gNotification; // Android Class that determines how Notifications are presented
// Accelerator Globals
SensorManager mSensorManager; // Allows use of Android's Sensors
MySensorEventListener accSensorEventListener; // Event Listener
Sensor acc_sensor; // Accelerometer Sensor Class
float[] acc_values; // Array to hold our Accelerometer Sensors
long[] gVibrate = {0,250,50,125,50,62}; // Vibration Pattern 

String[] fontList; // To get access to the System Fonts
PFont androidFont; 

float posX, posY;	       	// Position unserer Kugel
float windX, windY;		   	// Windrichtung
float windSpeed = 25;	   	// Windstärke
float windChange = 0.005; 	// Geschwindigkeit der Windrichtungsänderung
float accX, accY;			// X & Y Werte des Accelerometers 

float offX = 0.0;			// Variablen für perlin noise Wind
float offY = 10.0; 			 

float ballSize = 40;

int hitCount = 0;			// Anzahl der Versuche
int highscore = 0;			// Highscore 
int sec;					// Sekundenzähler
int lastMillis = 0;			// Millisekunden seit dem letzten reset

PImage bg, ball, shadow;

void setup(){
size(screenWidth, screenHeight, A2D);
orientation(LANDSCAPE);  
smooth();

// Images
bg = loadImage("background.png");
ball = loadImage("ball.png");
shadow = loadImage("shadow.png");

posX = screenWidth/2; 
posY = screenHeight/2; 

fontList = PFont.list(); // Required to access different system fonts besides the default
androidFont= createFont(fontList[4], 24, true); // #4 is Sans-Serif Bold, 24 pixels, Anti-aliased
textFont(androidFont);
}



void draw(){
// Background Image  
image(bg, 0, 0);
println(frameRate);
// Windrichtung wird für X&Y auf einen Wert zwischen -12,5 und 12,5 gesetzt.
windX = noise(offX)*windSpeed-windSpeed/2;  
windY = noise(offY)*windSpeed-windSpeed/2; 

accX = acc_values[1] * 5;
accY = acc_values[0] * 5; 

// Our fake wind
posX += windX + accX;
posY += windY + accY;
offX += windChange;
offY += windChange;

image(shadow, posX-accX, posY+accY);
image(ball, posX, posY);

// Flagpole
strokeWeight(4);
stroke(225,0,0);
line(770,450,770+windX*2+2,450+windY*2+2); 
noStroke();
fill(225);
ellipse(770,450,4,4); 

if( posX  < 2 || 
    posX  + 75 > screenWidth - 2 ||
    posY  < 2 ||
    posY + 150 > screenHeight - 2 ) {

gNotificationManager.notify(1, gNotification); // Vibration    

posX = screenWidth/2;
posY = screenHeight/2;

hitCount += 1;

lastMillis = millis();	//reset des Counters

//Highscore +1 falls höher als alter Highscore
if( sec > highscore) {
       highscore = sec; 
     }
 }

sec = (millis() - lastMillis) / 1000; //aktuell gespielte Sekunden

// unsere Anzeigen
fill(55); // drop shadow
text("WindX: "+nfs(windX,0,1), 419, 441);
text("WindY: "+nfs(windY,0,1), 419, 471);
text("Hit Count " +hitCount, 19, 441);
text("Score " +sec, 219, 441);
text("Hi Score " +highscore, 219, 471);

fill(255); // top layer
text("WindX: "+nfs(windX,0,1), 420, 440);
text("WindY: "+nfs(windY,0,1), 420, 470);
text("Hit Count " +hitCount, 20, 440);
text("Score " +sec, 220, 440);
text("Hi Score " +highscore, 220, 470);

} // schließt den draw loop

void onResume() {
super.onResume();
gNotificationManager = (NotificationManager)
getSystemService(Context.NOTIFICATION_SERVICE);
gNotification = new Notification();
gNotification.vibrate = gVibrate;

// Build our SensorManager
mSensorManager = (SensorManager)getSystemService(Context.SENSOR_SERVICE);

// Build a SensorEventListener
accSensorEventListener = new MySensorEventListener();

// Get our Sensors
acc_sensor =  mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);

// Register the SensorEventListeners/SensorManager
mSensorManager.registerListener(accSensorEventListener, acc_sensor,
SensorManager.SENSOR_DELAY_GAME);
}

void onPause() {
 mSensorManager.unregisterListener(accSensorEventListener);
 super.onPause();
} 


class MySensorEventListener implements SensorEventListener {
 void onSensorChanged(SensorEvent event) {
   int eventType = event.sensor.getType();
   if(eventType == Sensor.TYPE_ACCELEROMETER) {
     acc_values = event.values;
   }
 }
 void onAccuracyChanged(Sensor sensor, int accuracy) {
 }
}

