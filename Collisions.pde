World world;

float bordersMomentumConsumption = -0.5f;

void setup() {
  size(1280, 720);
  frameRate(60);
  
  println(solveQuadratic(1, 0, 28));
  
  Body b1 = new Body(500, new PVector(width, height / 2));
  //b1.applyForce(new PVector(-100, 1500));
  
  world = new World(0.01, new PVector(0, -0.0f));
  //world.addBody(b1);
  //world.addBody(new Body(500, new PVector(0, height / 2)));
  //world.addBody(new Body(500, new PVector(width / 2, height / 2)));
  
  for (int i = 0; i < 5; ++i) {
    world.addBody(new Body(random(10, 500), new PVector(random(width), random(height))));
  }
}

void draw() {
  background(0);
  
  world.tick();
  world.update();
  world.display();
}
