// Coin.pde

class Coin extends Thing {
  // screen coords (updated each tick)
  public float currentX, currentY;

  // save for reset
  private final float originX, originY;

  // coin sprite
  private final PImage sprite;

  // state flags
  public boolean collected = false;
  public boolean devReset  = false;

  /** Load the coin image and remember its starting world x,y. */
  Coin(String imgName, float xpos, float ypos, int w, int h) {
    super(w, h, xpos, ypos, 0, 0);
    originX = xpos;
    originY = ypos;
    sprite  = loadImage(imgName + ".png");
    sprite.resize(w, h);
  }

  /** 1) Scroll world coords and compute on-screen coords */
  public void position(boolean moveX, boolean moveY) {
    if (moveX) x -= scrollX;
    if (moveY) y -= scrollY;
    currentX = x - scrollX;
    currentY = y - scrollY;
  }

  /** 2) Draw the coin sprite if it hasn’t been collected */
  public void draw() {
    if (!collected) {
      image(sprite, currentX, currentY);
    }
  }

  /**
   * 3) Full tick:
   *    – position() to scroll it
   *    – reset if devReset
   *    – check collision with player
   *    – draw if still active
   */
  public void tick(boolean moveX, boolean moveY, Player p) {
    position(moveX, moveY);

    if (devReset) {
      // snap back to original world position
      x = originX;
      y = originY;
      collected = false;
      devReset  = false;
    }

    // collision in world-space
    if (!collected && super.touching2(p, this.x, this.y, p.x, p.y)) {
      collected = true;
      p.collected++;  // increment player’s score if you track it
    }

    draw();
  }

  /** 4) Center helper for resetLevel() */
  public void center() {
    x = originX;
    y = originY;
    scrollX = scrollY = 0;
    collected = false;
  }
}
