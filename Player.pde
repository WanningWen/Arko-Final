class Player extends Thing {
  // do stuff
  private float x;
  private float y;
  private float sx;
  private float sy;
  private PImage p;
  private Joystick j;
  private int inAir;
  private Platform[] platforms;
  private Spike[] spikes;
  // just in case
  private float currentX, currentY;
  // just in case ig?
  private String exit;
  private int state;
  private boolean stateNull;
  private int distance;
  private float angle;
  private float scrollX;
  private float scrollY;
  private boolean keyPress;
  private int jumpCounter;
  // for handling multiple keypresses at the same time:
  public boolean[] keys; // THIS IS PUBLIC
  private boolean doubleJump;
  public boolean hasMovedX;
  public boolean hasMovedY;
  public boolean borderRight;
  public boolean borderLeft;
  private boolean hitTop;
  public boolean dead;
  //
  private boolean hidden;
  
  
  //coin
  public int collected = 0;
  
  public Player(float xpos, float ypos, float scrollX, float scrollY, Platform[] platformList, Spike[] spikeList) {
    //
    super(20, 20, xpos, ypos, 7, (float) 0);
    this.x = xpos;
    this.y = ypos;
    this.currentX = xpos;
    this.currentY = ypos;
    this.sx = 7.0; // random init value
    this.sy = 0;
    this.inAir = 0;
    // test:
    this.exit = super.exit;
    // test again:
    this.state = 0;
    this.stateNull = true;
    // test yet again:
    this.distance = 0;
    //
    this.angle = 0.0;
    this.hidden = false;
    this.keyPress = false;
    this.jumpCounter = 0;
    this.keys = new boolean[3]; // right, left, up keys, respectively
    for (int i = 0; i < this.keys.length; i++) {
      this.keys[i] = false;
    }
    this.doubleJump = false;
    this.scrollX = scrollX;
    this.scrollY = scrollY;
    this.hasMovedX = false;
    this.hasMovedY = false;
    this.borderLeft = false;
    this.borderRight = false;
    this.hitTop = false;
    this.dead = false;
    this.platforms = platformList; // this will be a list of all the platform objects in the level, so we can go through this list whenever checking if player is touching platforms
    this.spikes = spikeList;
    //
    PImage img;
    img = loadImage("player.png");
    // 40x40, we want to resize to 20x20
    img.resize(20, 20);
    this.p = img;
    image(p, xpos, ypos);
    j = new Joystick();
  }
  public void draw() {
    //
    image(this.p, this.x, this.y);
    j.tick(); // not sure if this should go in the if statement
  }
  // get methods
  public float getX() {
    return this.x;
  }
  public float getY() {
    return this.y;
  }
  public float getScrollX() {
    return this.scrollX;
  }
  public float getScrollY() {
    return this.scrollY;
  }
  public void right() {
    //
    for (int i = 0; i < this.platforms.length; i++) {
      if (super.borderingRight(this.platforms[i], this.x, this.y, this.platforms[i].x, this.platforms[i].y)) {
        return;
      }
    }
    for (int i = 0; i < this.sx*10; i++) {
      this.x += 0.1;
      this.currentX += 0.1;
      this.scrollX += 0.1;
    }
  }
  public void left() {
    //
    for (int i = 0; i < this.platforms.length; i++) {
      if (super.borderingLeft(this.platforms[i], this.x, this.y, this.platforms[i].getX(), this.platforms[i].getY())) {
        return;
      }
    }
    for (int i = 0; i < this.sx; i++) {
      //
      this.x -= 1;
      this.currentX -= 1;
      this.scrollX -= 1;
    }
  }
  public void center() {
    // dev function
    this.x = width/2-10;
    this.y = height/2-10;
    this.currentX = this.x;
    this.currentY = this.y;
    this.sx = 5; // init value
    this.sy = 0;
    this.inAir = 0;
    this.jumpCounter = 0;
    this.doubleJump = false;
    this.scrollX = 0;
    this.scrollY = 0;
    this.dead = false;
  }
  public boolean touchingPlatforms() {
    //
    for (int i = 0; i < this.platforms.length; i++) {
      if (super.touching2(this.platforms[i], this.x, this.y, this.platforms[i].getX(), this.platforms[i].getY())) {
        return true;
      }
    }
    return false; // there we go1
  }
  public boolean borderingPlatforms() {
    //
    for (int i = 0; i < this.platforms.length; i++) {
      if (super.bordering(this.platforms[i], (int) this.x, (int) this.y, (int) this.platforms[i].getX(), (int) this.platforms[i].getY())) {
        return true;
      }
    }
    return false; // there we go1
  }
  public boolean touchingSpikes() {
    for (int i = 0; i < spikes.length; i++) {
      // ← use spikes[i].x and spikes[i].y instead of getX()/getY()
      if (super.touching2(
            spikes[i],
            this.x, this.y,
            spikes[i].x, spikes[i].y
          )) {
        println("Spike hit at player("+ x +","+ y +") vs spike("+ spikes[i].x +","+ spikes[i].y +")");
        return true;
      }
    }
    return false;
  }

  // position function:
  public void position() {
    // there is a big difference between saying "this.x -= this.scrollX" and having a new variable equal this value because the first one actually changes the value of this.x, which we don't want to do.
    this.currentX = this.x - this.scrollX;
    this.currentY = this.y - this.scrollY;
  }
  public void tick() {
    // tick function!
    this.dead = false;
    this.x = this.currentX;
    this.y = this.currentY;
    this.hasMovedX = false;
    this.hasMovedY = false;
    // CHECK FOR DEATH
    if (this.touchingSpikes()) {
      //println("touching spikes");
      this.dead = true;
      //this.die();
      return; // END FUNCTION
    }
    //
    if (this.touchingPlatforms()) {
      //
      this.doubleJump = false;
    }
    if (jumpCounter > 0) {
      //
      this.y -= 2*jumpCounter;
      this.jumpCounter -= 1;
      this.hasMovedY = true;
      for (int l = 0; l < this.platforms.length; l++) {
        if (super.borderingTop(this.platforms[l], this.x, this.y, this.platforms[l].getX(), this.platforms[l].getY())) {
          this.hitTop = true;
          this.jumpCounter = 0;
        }
      }
    } else {
      for (float i = 0; i < sy; i+= 0.3) {
        if (!this.touchingPlatforms()) {
          this.y += 0.3; // processing is wacky
        } else {
          this.hitTop = false;
          this.sy = 0;
        }
    }
    }
    this.sy += 0.3;
    // NEW KEYPRESS CODE:
    if (this.keys[0]) {
      this.right();
      this.hasMovedX = true;
    }
    if (this.keys[1]) {
      this.left();
      this.hasMovedX = true;
    }
    if (this.keys[2] && (this.borderingPlatforms() || this.jumpCounter == 0)) {
      //
      boolean canJump = true;
      for (int k = 0; k < this.platforms.length; k++) {
        if (super.borderingTop(this.platforms[k], this.x, this.y, this.platforms[k].getX(), this.platforms[k].getY())) {
          //
          println("true");
          canJump = false;
        }
      }
      if (canJump) {
        if (this.borderingPlatforms()) {
          this.jumpCounter = 10;
          this.hasMovedY = true;
        } else if (!this.doubleJump && !this.hitTop) {
          this.jumpCounter = 7;
          this.doubleJump = true;
          this.hasMovedY = true;
        }
      }
    }
    // end of tick function:
    this.position();
  }
  public void die() {
    // for now just reposition it to the beginning
    // stop everything else, have the player draw every second consecutive tick for some number of times, then reset
    //this.dead = true;
    //this.center();
  }
  // game die
  public void gameDie() {
    //
    this.exit = "";
  }
  // I'll do the game win function later because that involves the exit sprite
  //
  public void testDie() {
    // will actually write this later
    return;
  }
}
