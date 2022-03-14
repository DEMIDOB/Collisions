import java.util.ArrayList;
import java.util.HashSet;

class World {
  public float G;
  public PVector g;
  
  private ArrayList<Body> bodies;
  
  public World(float G, PVector g) {
    this.G = G;
    this.g = g;
    
    bodies = new ArrayList<Body>();
  }
  
  public void tick() {
    for (int i = 0; i < bodies.size() - 1; ++i) {
      for (int j = i + 1; j < bodies.size(); ++j) {
        Body b_i = bodies.get(i);
        Body b_j = bodies.get(j);
        
        PVector i_to_j = b_j.position.copy().sub(b_i.position);
        float dist_sq = i_to_j.magSq();
        float allowedDist = b_i.radius + b_j.radius;
        
        if (dist_sq <= allowedDist * allowedDist + b_i.velocityMagSq() + b_j.velocityMagSq()) {
          if (b_i.mass < 0 && b_j.mass > 0 || b_j.mass < 0 && b_i.mass > 0) {
            bodies.remove(max(i, j));
            bodies.remove(min(i, j));
            
            // kinda flash (just visual):
            //fill(255);
            //circle((b_i.position.x + b_j.position.x) / 2, (b_i.position.y + b_j.position.y) / 2, 200);
          }
          b_i.collide(b_j);
          //frameRate(1);
          continue;
        }
        
        //frameRate(60);
        
        float gravitationalForceMag = G * b_i.mass * b_j.mass / dist_sq;
        
        i_to_j.mult(gravitationalForceMag);
        
        b_i.applyForce(i_to_j);
        b_j.applyForce(i_to_j.mult(-1));
      }
    }
    
    for (Body body : bodies) {
      body.accelerate(g);
      body.tick();
    }
  }
  
  public void update() {
    for (Body body : bodies) {
      body.update();
    }
  }
  
  public void display() {
    for (Body body : bodies) {
      body.display();
    }
  }
  
  public void addBody(Body b) {
    b.id = this.bodies.size();
    this.bodies.add(b);
  }
}
