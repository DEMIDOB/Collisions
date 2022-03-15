import java.util.ArrayList;

class Body {
  public int id = 0;
  
  public float mass;
  public PVector position;
  public float radius;
  
  
  private PVector velocity, acceleration;
  private PVector netForce;
  
  private HashSet<Integer> collisionsSet;
  
  public Body(float mass) {
    this.mass = mass;
    this.position = new PVector();
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.netForce = new PVector();
    
    this.radius = log(mass) / log(2);
    
    this.collisionsSet = new HashSet<Integer>();
  }
  
  public Body(float mass, PVector position) {
    this.mass = mass;
    this.position = position;
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.netForce = new PVector();
    
    this.radius = log(abs(mass)) / log(1.3);
    
    this.collisionsSet = new HashSet<Integer>();
  }
  
  public void applyForce(PVector force) {
    netForce.add(force);
  }
  
  public void accelerate(PVector a) {
    this.acceleration.add(a);
  }
  
  public void tick() {
    accelerate(netForce.div(mass));
    velocity.add(acceleration);
    
    netForce.x = 0;
    netForce.y = 0;
    // netForce.z = 0;
    
    acceleration.x = 0;
    acceleration.y = 0;
    // acceleration.z = 0;
    
    collisionsSet.clear();
  }
  
  public void update() {
    position.add(velocity);
    
    if (bordersMomentumConsumption != 0) {    
      if (position.x >= width - radius) {
        position.x = width - radius;
        velocity.x *= bordersMomentumConsumption;
      } else if (position.x <= radius) {
        position.x = radius;
        velocity.x *= bordersMomentumConsumption;
      }
      
      if (position.y >= height - radius) {
        position.y = height - radius;
        velocity.y *= bordersMomentumConsumption;
      } else if (position.y <= radius) {
        position.y = radius;
        velocity.y *= bordersMomentumConsumption;
      }
    } else {
      if (position.x > width + radius) {
        position.x = -radius;
      } else if (position.x < -radius) {
        position.x = width + radius;
      }
      
      if (position.y > height + radius) {
        position.y = -radius;
      } else if (position.y < -radius) {
        position.y = height + radius;
      }
    }
  }
  
  public void display() {
    if (mass > 0)
      fill(map(mass, 0, massRange, 50, 150), 0, 0);
    else
      fill(0, 0, map(-mass, 0, massRange, 50, 150));
    
    //fill(255);
    circle(position.x, height - position.y, radius * 2);
    
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(20);
    //text("" + id, position.x, height - position.y);
  }
  
  public float velocityMagSq() {
    return velocity.magSq();
  }
  
  public PVector momentum() {
    return this.velocity.copy().mult(this.mass);
  }
  
  public PVector kineticEnergy() {
    PVector out = this.momentum();
    
    out.x *= this.velocity.x;
    out.y *= this.velocity.y;
    
    return out;
  }
  
  public void collide(Body b) {
    netForce.x = 0;
    netForce.y = 0;
    // netForce.z = 0;
    
    acceleration.x = 0;
    acceleration.y = 0;
    // acceleration.z = 0;
    
    if (collisionsSet.contains(b.id) || b.collisionsSet.contains(this.id)) 
      return;
      
    collisionsSet.add(b.id);
      
    float m1 = this.mass;
    float m2 = b.mass;
    
    PVector p1 = this.momentum().mult(0.5);
    PVector p2 = b.momentum().mult(0.5);
    
    PVector e1 = this.kineticEnergy().mult(0.5);
    PVector e2 = b.kineticEnergy().mult(0.5);
    
    PVector conservedMomentum = p1.copy().add(p2).div(2);
    PVector conservedEnergy = e1.copy().add(e2);
      
    // X quadratic equation:
    float a = m1 + m1/m2;
    
    float[] solutionsX1 = solveQuadratic(a, -2 * conservedMomentum.x * m1 / m2, conservedMomentum.x * conservedMomentum.x / m2 - conservedEnergy.x);
    float[] solutionsX2 = {1, (conservedMomentum.x - m1*solutionsX1[1]) / m2,(conservedMomentum.x - m1*solutionsX1[2]) / m2};
    
    //println();
    //println(id + " with " + b.id);
    //println(solutionsX1[1] + " " + solutionsX1[2]);
    //println(solutionsX2[1] + " " + solutionsX2[2]);
    
    float v1x = solutionsX1[1], v2x = solutionsX2[1];
    
    if (this.velocity.x < 0) {
      v1x = solutionsX1[2];
      v2x = solutionsX2[2];
    }
    
    this.velocity.x = v1x;
    b.velocity.x = v2x;
    
    // Y quadratic equation:
    
    float[] solutionsY1 = solveQuadratic(a, -2 * conservedMomentum.y * m1 / m2, conservedMomentum.y * conservedMomentum.y / m2 - conservedEnergy.y);
    float[] solutionsY2 = {1, (conservedMomentum.y - m1*solutionsY1[1]) / m2,(conservedMomentum.y - m1*solutionsY1[2]) / m2};
    
    //println();
    //println(id + " with " + b.id);
    //println(solutionsX1[1] + " " + solutionsX1[2]);
    //println(solutionsX2[1] + " " + solutionsX2[2]);
    
    float v1y = solutionsY1[1], v2y = solutionsY2[1];
    
    if (this.velocity.y < 0) {
      v1y = solutionsY1[2];
      v2y = solutionsY2[2];
    }
    
    this.velocity.y = v1y;
    b.velocity.y = v2y;
    
    b.collide(this);
  }
}
