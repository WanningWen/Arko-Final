Player p;
Platform lv1p1, lv1p2, lv1p3, lv1p4, lv1p5, lv1p6, lv1p7;
Spike lv1d1, lv1d2;
Platform[] platforms;
Spike[] spikes;
ArrayList<Coin> coins;
boolean gameRunning;
boolean immortal;

int deathTimer    = 0;       // counts frames since death began
int deathDuration = 60;      // e.g. 60 frames ≈ 1 second at 60 FPS
boolean isDead    = false;

// new portal stuff
Portal   exitPortal;
boolean levelPassed = false;
boolean coinsCollected = false;

void setup() {
  size(800, 500);

  // — Platforms —
  lv1p1 = new Platform("Test22",  40,  height/2+150, 538, 85);
  lv1p2 = new Platform("Test22", 700,  height/2+100, 538, 85);
  lv1p3 = new Platform("Test22",1238,  height/2+15,  538, 85);
  lv1p4 = new Platform("Test22",1776,  height/2+80,  538, 85);
  lv1p5 = new Platform("Test22",2400,  height/2-50,  269, 50);
  lv1p6 = new Platform("Test22",2700,  height/2-120, 1076,85);
  lv1p7 = new Platform("Test22", 800,  height/2-110, 538, 85);
  platforms = new Platform[]{lv1p1,lv1p2,lv1p3,lv1p4,lv1p5,lv1p6,lv1p7};
  
  

  // — Spikes —
  lv1d1 = new Spike("Spikes", 250,  height/2+150-21, 65,21);
  lv1d2 = new Spike("Spikes", 800,  height/2+100-21, 65,21);
  spikes = new Spike[]{lv1d1, lv1d2};
  
  // — coins —
  coins = new ArrayList<Coin>();
  int coinsPerPlat = 2;
  int coinSize     = 32;
  
  // Find the rightmost platform edge in world coords
  float mapEndX = 0;
  for (Platform plt : platforms) {
    mapEndX = max(mapEndX, plt.x + plt.xsize);
    for (int i = 0; i < coinsPerPlat; i++) {
      float cx = plt.x + (plt.xsize/(coinsPerPlat+1))*(i+1) - coinSize/2;
      float cy = plt.y - coinSize - 5;
      coins.add(new Coin("coin", cx, cy, coinSize, coinSize));
    }
  }
  
  // — Player —
  p = new Player(width/2-10, height/2-10, 0, 0, platforms, spikes);
  gameRunning = true;

  // — Portal —
  // 2) Choose an offset beyond that edge
  float portalX = mapEndX;     // 100px past the last platform
  float portalY = height/2 - 200;    // adjust vertically as desired
  println("Spawning portal at (" + portalX + "," + portalY + ")");
  // 3) Create and activate the portal
  exitPortal = new Portal(portalX, portalY, 48, 64);
  exitPortal.active = false;
}

void draw() {
  if (immortal) {
    isDead = false;
  }
  if (isDead) {
    // — DEATH BLINK & MESSAGE —
    background(255);
    for (Platform plt : platforms) plt.draw();
    for (Spike sp : spikes)    sp.draw();

    fill(255, 0, 0);
    textSize(64);
    text("You Died!", width/2-110, 100);

    if ((deathTimer / 10) % 2 == 0) {
      p.draw();
    }
    deathTimer++;
    if (deathTimer >= deathDuration) {
      resetLevel();
    }
  }
  else if (levelPassed) {
    // — PASS SCREEN —
    background(0, 150, 200);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(48);
    text("YOU PASSED!", width/2, height/2);
  }
  else {
    // — NORMAL GAMEPLAY —
    background(255);

    // 1) Player
    p.draw();
    p.tick();

    // 2) Fall‐off‐screen death
    if (p.getY() > height) {
      isDead = true;
      deathTimer = 0;
    }

    // 3) Platforms
    for (Platform plt : platforms) {
      plt.scrollX = p.getScrollX();
      plt.scrollY = p.getScrollY();
      plt.tick(p.hasMovedX, p.hasMovedY);
    }

    // 4) Spikes & death
    for (Spike sp : spikes) {
      sp.scrollX = p.getScrollX();
      sp.scrollY = p.getScrollY();
      sp.tick(p.hasMovedX, p.hasMovedY);
    }
    if (!isDead && p.touchingSpikes()) {
      isDead = true;
      deathTimer = 0;
    }

    // 5) Portal
    boolean allCollected = true;
    for (Coin c : coins) {
      if (!c.collected) {
        allCollected = false;
        break;
      }
    }
    exitPortal.active = allCollected;
    
    // 5b) Draw & tick portal
    exitPortal.scrollX = p.getScrollX();
    exitPortal.scrollY = p.getScrollY();
    exitPortal.tick(p.hasMovedX, p.hasMovedY);
    if (!levelPassed && exitPortal.reached(p)) {
      levelPassed = true;
    }
    
    // 6) Coins
    int collectedCount = 0;
    for (Coin c : coins) {
      c.scrollX = p.getScrollX();
      c.scrollY = p.getScrollY();
      c.tick(p.hasMovedX, p.hasMovedY, p);
      if (c.collected) collectedCount++;
    }
    // draw coin counter in the corner
    fill(0);                   // black text
    textSize(20);              // adjust legibility
    textAlign(LEFT, TOP);
    text("Coins: " + collectedCount + " / " + coins.size(), 10, 10);

    // 6) Reset camera scroll
    p.scrollX = 0;
    p.scrollY = 0;
  }
}

void resetLevel() {
  // reset player
  p.center();
  p.sy = 0;
  p.doubleJump = false;
  p.jumpCounter = 0;

  // reset platforms & spikes
  for (Platform plt : platforms) {
    plt.center();
    plt.devReset = false;
  }
  for (Spike sp : spikes) {
    sp.center();
    sp.devReset = false;
  }
  // reset coins not collected
  for (Coin c : coins) {
    if (!c.collected) {
      c.center();
    }
  }
  
  // — RESET THE PORTAL TOO! —
  exitPortal.center();
  exitPortal.devReset = false;

  // clear death & pass flags
  isDead = false;
  deathTimer = 0;
  levelPassed = false;
}

// Movement testing
void keyPressed() {
  if (key==' ') {
    p.center();
    for (Platform plt : platforms) plt.devReset = true;
    for (Spike sp : spikes)    sp.devReset = true;
  }
  if (keyCode==RIGHT) p.keys[0]=true;
  if (keyCode==LEFT)  p.keys[1]=true;
  if (keyCode==UP)    p.keys[2]=true;
  if (key=='i') {
    immortal = true;
  }
}
void keyReleased() {
  if (key==' ') {
    for (Platform plt : platforms) plt.devReset = false;
    for (Spike sp : spikes)    sp.devReset = false;
  }
  if (keyCode==RIGHT) p.keys[0]=false;
  if (keyCode==LEFT)  p.keys[1]=false;
  if (keyCode==UP)    p.keys[2]=false;
}
