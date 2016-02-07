
 public class FloatVehicle {

    int ID;
    float xTextPosition;
    float yTextPosition;
    int counter;
    Vector3f finalTextPosition = new Vector3f();
    float myAlpha;

    // states
    static final int IDLE = 0;
    static final int FINDING = 1;
    static final int REMAINING = 2;
    static final int LEAVING = 3;
    static final int EXPLODING = 4;
    int state = IDLE;

    // behavior
    float rotation;
    Behavior behavior = new Behavior();
    Vector3f velocity = behavior.velocity;
    Vector3f position = behavior.position;
    Vector3f direction_wandering = new Vector3f();
    Vector3f direction_goto = new Vector3f();

    // behavior relevance
    float wanderingRelevance;
    float goToRelevance;

    // physic
    Vector3f steering_direction = new Vector3f();
    Vector3f steering_force = new Vector3f();
    Vector3f acceleration = new Vector3f();
    float max_force;
    float max_speed;
    float mass;
    FloatVehicle(int ID) {
      this.ID = ID;
      int numberOfCharactersPerLine =82;
      yTextPosition = (float) Math.floor(ID / (float) numberOfCharactersPerLine);
      xTextPosition = ID - yTextPosition * numberOfCharactersPerLine;
      // setup vehicle
      reset();
    }

    void reset() {
      setState(IDLE);
    }

    void setState(int newState) {
      switch (newState) {
      case EXPLODING:
      println("EXPLODING");
        // set initial position of explode
        float startX = objx + random(-100, 100);
        float startY = objy;//+ random(-100, 100);
        position.set(startX, -52.0f, startY);
        // set point to go to
        float randomValue = (float) Math.random() * 360;
        float radius = 100.0f + (float) Math.random() * 100.0f;
        float aimX = sin(randomValue) * radius + startX;
        float aimY = cos(randomValue) * radius + startY;
        behavior.goToPoint.pointPosition = new Vector3f(aimX, 0.0f, aimY);
        // exploding state
        velocity.set(0.0f, 2.0f, 0.1f);
        wanderingRelevance = 0.0f;
        goToRelevance = 1.0f;
        max_force = 0.6f + (float) Math.random() * 0.3f;
        max_speed = 3.0f + (float) Math.random() * 2.0f;
        mass = 0.1f + (float) Math.random() * 0.1f;
        myAlpha = 100;
        counter = 2;
      break;
      // normal state
      case IDLE:
      println("IDLE");
        wanderingRelevance = 0.8f;
        goToRelevance = 0.2f;
        max_force = 0.3f;
        max_speed = 1.0f;
        mass = 1.0f;
        myAlpha = 20;
        counter = 0;
      break;
      //
      case FINDING:
      println("FINDING");
        float textStartX = 150.0f;
        float textStartY = 300.0f;
        float spacerX = 5;
        float spacerY = 8;
        finalTextPosition = new Vector3f(textStartX + xTextPosition * spacerX, 0.0f,
        textStartY + yTextPosition * spacerY);
        behavior.goToPoint.pointPosition = finalTextPosition;
        //
        wanderingRelevance = 0.2f;
        goToRelevance = 0.8f;
        max_force = 0.1f;
        max_speed = 4.0f;
        mass = 4.0f;
        counter = 0;
      break;
      //
      case REMAINING:
      println("REMAINING");
        wanderingRelevance = 0.0f;
        goToRelevance = 0.0f;
        max_force = 0.1f;
        max_speed = 1.0f;
        mass = 1.0f;
        counter = 0;
      break;
      //
      case LEAVING:
      println("LEAVING");
        // set point to go to
        randomValue = (float) Math.random() * 360;
        radius = 10.0f + (float) Math.random() * 150.0f;
        aimX = sin(randomValue) * radius + position.x;
        aimY = cos(randomValue) * radius + position.z;
        behavior.goToPoint.pointPosition = new Vector3f(aimX, 0.0f, aimY);
        velocity.set(1.0f, 0.0f, 0.0f);
        wanderingRelevance = 0.6f;
        goToRelevance = 0.4f;
        max_force = 0.4f;
        max_speed = 2.0f;
        mass = 2.0f;
        counter = 0;
        myAlpha = 255;
      break;
      }

      state = newState;
    }

    void cycle() {
      counter++;
      // select state
      switch (state) {
      case EXPLODING:
      //println("CYCLE : EXPLODING");
        if (counter > 10 && max_force > 0.2f) {
          max_force -= 0.1f;
        }
        if (counter > 5 && max_speed > 0.2f) {
          max_speed -= 0.18f;
        }
        if (counter == 25) {
          setState(FINDING);
        }
        break;
      case FINDING:
      //println("CYCLE : FINDING");
        if (counter > 10) {
          max_force = 0.5f;
        }
        if (mass > 0.2f) {
          mass -= 0.07;
        }
        // check distance to arrival position
        Vector3f distanceVector = new Vector3f();
        distanceVector.sub(finalTextPosition, position);
        float distance = distanceVector.length();
        if (distance < 10) {
          max_speed = distance / 2.5f;
          max_force = distance / 14.0f;
        }
        if (distance < 1) {
          setState(REMAINING);
        }
      break;
      //
      case REMAINING:
      //println("CYCLE : REMAINING");
        if (rotation > 0.01f || rotation < -0.01f) {
          rotation *= 0.8f;
        } 
        else {
          position.set(finalTextPosition);
          rotation = 0.0f;
        }
        if (counter == 100) {
          setState(LEAVING);
        }
      break;
      //
      case LEAVING:
      //println("CYCLE : LEAVING");
        if (myAlpha > 5.0f) {
          myAlpha -= 5.0f;
        }
        if (counter == 150) {
          setState(IDLE);
        }
      break;
      //
      case IDLE:
      //println("CYCLE : IDLE");
        ////////////////////////CLUSTER SIZE
        behavior.goToPoint.pointPosition = new Vector3f(objx + random(0, 100), 0.0f, objy+ random(0, 100));
        break;
      }

      if (state != REMAINING) {
        // wandering
        direction_wandering.set(behavior.wander.get());
        // stayHome
        direction_goto.set(behavior.goToPoint.get());
        // add vectors with relevance
        direction_wandering.scale(wanderingRelevance);
        direction_goto.scale(goToRelevance);
        steering_direction.set(0.0f, 0.0f, 0.0f);
        steering_direction.add(direction_goto);
        steering_direction.add(direction_wandering);
        // physic
        steering_force.set(steering_direction);
        if (steering_force.length() > max_force) {
          steering_force.normalize();
          steering_force.scale(max_force);
        }
        acceleration.scale(1.0f / mass, steering_force);
        velocity.add(acceleration);
        if (velocity.length() > max_speed) {
          velocity.normalize();
          velocity.scale(max_speed);
        }
        position.add(velocity);
        rotation = atan2(velocity.z, velocity.x);
      }
      
    }
  }

