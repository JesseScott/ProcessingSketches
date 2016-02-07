
class VehicleController {

    FloatVehicle[] vehicle;

    VehicleController(int NumberOfVehicles) {
      vehicle = new FloatVehicle[NumberOfVehicles];
      for (int i = 0; i < vehicle.length; i++) {
        vehicle[i] = new FloatVehicle(i);
        vehicle[i].position.set(random(width), 5.0f, random(height));
      }
    }

    // cycle+draw objects
    void cycle() {
      for (int i = 0; i < vehicle.length; i++) {
        vehicle[i].cycle();
        this.draw(vehicle[i]);
      }
    }

    // draw object
    void draw(FloatVehicle me) {
      // get object properties
      Vector3f position = me.position;
      Vector3f velocity = me.velocity;
      float rotation = me.rotation;
      float myAlpha = me.myAlpha;

      boolean simple = false;
      noFill();
      if (simple) {
        stroke(color(25, 90, 90, myAlpha));
        point(position.x, position.z);
      } 
      else {
        pushMatrix();
          translate(position.x, position.z);//, position.y);
          scale(1.0f);        
          stroke(color(190,0,190,0));
          rect(0, 0, velocity.x * 10, velocity.z * 10);
          stroke(color(190, 10, 0, myAlpha));
          line( 25,5,5,10);
          stroke(color(10,10,66,25));
          line(5,1,5,1);
        popMatrix();
      }

    }

  }

