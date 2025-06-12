public abstract class Danger extends Thing {
  float currentX, currentY;  // on-screen coords
  // if you want sprites:
  // PImage sprite;

  public Danger(float xpos, float ypos, int xlen, int ylen) {
    super(xlen, ylen, xpos, ypos, 0, 0);
    // sprite = loadImage("spike.png");  // load if you have an image
  }

  /** 1) Compute currentX,currentY from world x,y and scroll offsets */
  public void position(boolean moveX, boolean moveY) {
    if (moveX) x -= scrollX;
    if (moveY) y -= scrollY;
    currentX = x - scrollX;
    currentY = y - scrollY;
  }

  /** 2) Draw placeholder (override in subclass to use images) */
  public void draw() {
    // default: a red rectangle
    fill(255, 0, 0);
    rect(currentX, currentY, xsize, ysize);
  }

  /** 3) Tick = reposition + render */
  public void tick(boolean moveX, boolean moveY) {
    position(moveX, moveY);
    draw();
  }
}
