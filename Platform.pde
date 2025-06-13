// Platform.pde

class Platform extends Thing {
  // screen coords (computed each tick)
  public float currentX, currentY;

  // save these for resetting
  private final float originX, originY;

  // your platform image
  private final PImage sprite;

  // dev‐reset flag (if you press space, etc.)
  public boolean devReset = false;

  // Constructor: load the sprite and record its world x,y
  Platform(String imgName, float xpos, float ypos, int w, int h) {
    super(w, h, xpos, ypos, 0, 0);
    originX = xpos;
    originY = ypos;
    sprite = loadImage(imgName + ".png");
    sprite.resize(w, h);
  }

  /** 1) Position: scroll world coords and compute on‐screen coords */
  public void position(boolean moveX, boolean moveY) {
    if (moveX) x -= scrollX;
    if (moveY) y -= scrollY;
    currentX = x - scrollX;
    currentY = y - scrollY;
  }

  /** 2) Draw at the computed screen coords */
  public void draw() {
    image(sprite, currentX, currentY);
  }

  /** 3) Tick: update position → optional reset → draw */
  public void tick(boolean moveX, boolean moveY) {
    position(moveX, moveY);
    if (devReset) {
      // snap back
      x = originX;
      y = originY;
      devReset = false;
    }
    draw();
  }

  /** 4) Center helper for your reset logic */
  public void center() {
    x = originX;
    y = originY;
    scrollX = scrollY = 0;
  }
}
