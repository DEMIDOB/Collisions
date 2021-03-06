World world;

float bordersMomentumConsumption = -0.0f;
boolean running = false;

int initialBodiesAmount = 5000;
int speed = int(pow(2, 1));
int massRange = 10;

HashSet<Character> numsSet;

void setup() {
  size(1280, 720);
  // fullScreen();
  frameRate(60);

  // Generate seed:
  int seed = 746396608;
  seed = int(random(1000000000));
  println("Seed:", seed);
  println();
  randomSeed(seed);
  print(seed);
  
  numsSet = new HashSet<Character>();
  numsSet.add('0');
  numsSet.add('1');
  numsSet.add('2');
  numsSet.add('3');
  numsSet.add('4');
  numsSet.add('5');
  numsSet.add('6');
  numsSet.add('7');
  numsSet.add('8');
  numsSet.add('9');
  
  println(solveQuadratic(1, 0, 28));
  world = new World(0.001, new PVector(0, -0.0f));
  
  for (int i = 0; i < initialBodiesAmount; ++i) {
    world.addBody(new Body(random(-massRange, massRange), new PVector(random(width), random(height))));
  }
  
  noStroke();
  running = initialBodiesAmount > 0;
}

void draw() {
  if (!running) {
    fill(255);
    rect(25, 25, 15, 50);
    rect(55, 25, 15, 50);
    return;
  }
  
  //background(255, 2);
  fill(0, 235);
  rect(0, 0, width, height);
  
  for (int i = 0; i < speed; ++i) {
    world.tick();
    world.update();
  }
  world.display();
}

void mousePressed() {
  if (mouseButton == LEFT)
    world.addBody(new Body(random(0, massRange), new PVector(mouseX, height - mouseY)));
  else if (mouseButton == RIGHT)
    world.addBody(new Body(-random(0, massRange), new PVector(mouseX, height - mouseY)));
  else
    running = !running;
}

void keyPressed() {
  if (keyCode == SHIFT)
    running = !running;
    
  if (key == '=')
    ++speed;
  else if (key == '-')
    --speed;
  
  if (numsSet.contains(key))
    speed = int(pow(2, Integer.parseInt("" + key) - 1));
}
