class Platform extends Thing {
  // private variables
  private float originX, originY;
  private float pDir, pOffset, pRadius, pTimer;
  private String name; // costume
  private int typ; // is it stationary, gliding, temporary, trampoline, etc?
  private boolean visible; // 0 = hidden, 1 = visible I think
  private float x, y;
  private PImage p;
  public float scrollX, scrollY;
  private float currentX, currentY;
  public boolean devReset;
  public Platform(String costume, float xpos, float ypos, int xlen, int ylen) {
    //
    // xlen, ylen will be given in an array in Game.pde based on the lengths of the different platforms
    super(xlen, ylen, xpos, ypos, 0, 0);
    this.x = xpos;
    this.y = ypos;
    this.originX = xpos;
    this.originY = ypos;
    this.name = costume;
    this.typ = 0;
    this.pTimer = 0;
    this.scrollX = 0;
    this.scrollY = 0;
    this.currentX = this.x;
    this.currentY = this.y;
    this.devReset = false;
    PImage img;
    img = loadImage(this.name + ".png");
    img.resize(xlen, ylen);
    this.p = img;
    image(p, this.x, this.y);
  }
  public void draw() {
    // draw all platforms
    image(this.p, this.x, this.y);
  }
  public float getX() {
    //
    return this.x;
  }
  public float getY() {
    //
    return this.y;
  }
  public void center() {
    // reset
    this.x = this.originX;
    this.y = this.originY;
    this.scrollX = 0;
    this.scrollY = 0;
  }
  // position function:
  public void position(boolean moveX, boolean moveY) {
    //
    if (moveX) {
      this.x -= this.scrollX;
    }
    if (moveY) {
      this.y -= this.scrollY;
    }
    //println("scrollX: " + scrollX + "\n scrollY: " + scrollY);
  }
  public void tick(boolean moveX, boolean moveY) {
    //
    this.position(moveX, moveY);
    if (this.devReset) {
      this.center();
    }
    this.draw();
  }
}
