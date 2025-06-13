Player p;
Platform lv1p1;
Platform lv1p2;
Platform lv1p3;
Platform lv1p4;
Platform lv1p5;
Platform lv1p6;
Platform lv1p7;
//Platform lv1p8;
Spike lv1d1;
Spike lv1d2;
Platform[] platforms;
Spike[] spikes;
boolean gameRunning;
int deathTimer = 0;       // counts frames since death began
int deathDuration = 60;   // e.g. 60 frames ≈ 1 second at 60 FPS
boolean isDead = false;

// new stuff
Coin[]   coins;
Portal   exitPortal;
boolean levelPassed = false;


void setup() {
  //
  size(800, 500); // 800 is the length (horizontal), 500 is the height (vertical)
  // more testing
  lv1p1 = new Platform("Test22", 40, height/2+150, 538, 85); // original dimensions 269*85
  lv1p2 = new Platform("Test22", 700, height/2+100, 538, 85); // original dimensions 269*85
  lv1p3 = new Platform("Test22", 1238, height/2+15, 538, 85); // original dimensions 269*85
  lv1p4 = new Platform("Test22", 1776, height/2+80, 538, 85); // original dimensions 269*85
  lv1p5 = new Platform("Test22", 2400, height/2-50, 269, 50); // original dimensions 269*85
  lv1p6 = new Platform("Test22", 2700, height/2-120, 1076, 85); // original dimensions 269*85
  lv1p7 = new Platform("Test22", 800, height/2-110, 538, 85); // original dimensions 269*85
  lv1d1 = new Spike("Spikes", 250, height/2+150-21, 65, 21); // original dimensions 65*21
  //lv1p8 = new Platform("Floating Island", 1500, height/2-160, 117, 48); // original dimensions 117*48
  lv1d2 = new Spike("Spikes", 900, height/2+100-21, 65, 21);
  
  // x = 40, y = 400
  // IMPORTANT: INITIALIZE PLATFORMS BEFORE PLAYER!
  platforms = new Platform[] {lv1p1, lv1p2, lv1p3, lv1p4, lv1p5, lv1p6, lv1p7};
  spikes = new Spike[] {lv1d1, lv1d2};
  p = new Player(width/2-10, height/2-10, 0, 0, platforms, spikes);
  
  // x = 390, y = 240
  gameRunning = true;
}



void draw() {
  // testing
  if (isDead) {
    // death animation: blink player on/off every 10 frames
    background(255);
    // draw static world
    for (Platform plt : platforms) plt.draw();
    for (Spike sp : spikes)   sp.draw();

    // blink: show player only on even 10-frame intervals
    if ( (deathTimer / 10) % 2 == 0 ) {
      p.draw();
    }

    // advance timer
    deathTimer++;

    // when done, reset everything:
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
  
    // 2) Death by falling
    if (p.getY() > height) {
      isDead     = true;
      deathTimer = 0;
    }
  
    // 3) Platforms
    for (Platform plt : platforms) {
      plt.scrollX = p.getScrollX();
      plt.scrollY = p.getScrollY();
      plt.tick(p.hasMovedX, p.hasMovedY);
    }
  
    // 4) Spikes and spike‐death
    for (Spike sp : spikes) {
      sp.scrollX = p.getScrollX();
      sp.scrollY = p.getScrollY();
      sp.tick(p.hasMovedX, p.hasMovedY);
    }
    if (!isDead && p.touchingSpikes()) {
      isDead     = true;
      deathTimer = 0;
    }
  
    // 7) Reset scroll for next frame
    p.scrollX = 0;
    p.scrollY = 0;
  }
}

void resetLevel() {
  // put player back and clear its state
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

  // clear death flag & timer
  isDead     = false;
  deathTimer = 0;
}


// TESTING MOVEMENT

void keyPressed() {
  //
  if (key == ' ') {
    p.center();
    for (int i = 0; i < platforms.length; i++) {
      // reset platforms
      platforms[i].devReset = true;
    }
    for (int j = 0; j < spikes.length; j++) {
      // reset spikes
      spikes[j].devReset = true;
    }
  }
  // below is in order to handle multiple keypresses at once:
  if (keyCode == RIGHT) {
    p.keys[0] = true;
  }
  if (keyCode == LEFT) {
    p.keys[1] = true;
  }
  if (keyCode == UP) {
    p.keys[2] = true;
  }
}

// releasing keys:

void keyReleased() {
  //
  if (key == ' ') {
    for (int i = 0; i < platforms.length; i++) {
      // stop resetting platforms
      platforms[i].devReset = false;
    }
    for (int j = 0; j < spikes.length; j++) {
      // stop resetting spikes
      spikes[j].devReset = false;
    }
  }
  if (keyCode == RIGHT) {
    p.keys[0] = false;
  }
  if (keyCode == LEFT) {
    p.keys[1] = false;
  }
  if (keyCode == UP) {
    p.keys[2] = false;
  }
}
