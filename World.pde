import java.util.ArrayList;
import java.util.HashSet;

public static class World {
  // ========= static relationships: =========
  
  public static float k_OVER_G = 100;
  public static float unitChargeMass = 0.000001;
  public static final float unitCharge = 0.01;
  public static final float unitChargeSq = unitCharge * unitCharge;
  public static boolean CONSIDER_COLLISIONS_ABSTRACTION = false;
  
  // =========================================
  
  private float G, k;
  public PVector g;
  
  private ArrayList<Body> bodies;
  
  public World(float G, PVector g) {
    this.G = G;
    this.k = G * k_OVER_G;
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
          
          if (CONSIDER_COLLISIONS_ABSTRACTION) {
            b_i.collide(b_j);
            continue;
          }
        }
        
        // ==== GRAVITATIONAL FORCE ====
        float gravitationalForceMag = G * b_i.mass * b_j.mass / dist_sq;
        
        PVector gravitationalForce_j_to_i = i_to_j.copy().mult(gravitationalForceMag);
        
        b_i.applyForce(gravitationalForce_j_to_i);
        b_j.applyForce(gravitationalForce_j_to_i.mult(-1));
        
        
        // ==== COULOMB FORCE ====
        PVector coulombForce_i_to_j = i_to_j.copy().mult(k * b_i.charge * b_j.charge * unitChargeSq / dist_sq);
        PVector coulombForce_j_to_i = coulombForce_i_to_j.copy().mult(-1); 
        
        b_j.applyForce(coulombForce_i_to_j);
        b_i.applyForce(coulombForce_j_to_i);
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
