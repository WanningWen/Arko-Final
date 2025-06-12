public class Spike extends Danger {
  private final float originX, originY;
  private final PImage p;
  public boolean devReset = false;

  public Spike(String costume, float xpos, float ypos, int w, int h) {
    super(xpos, ypos, w, h);
    originX = xpos; 
    originY = ypos;
    p = loadImage(costume + ".png");
    p.resize(w, h);
  }

  @Override
  public void draw() {
    // draw using screen coords
    image(p, currentX, currentY);
  }

  @Override
  public void tick(boolean moveX, boolean moveY) {
    if (devReset) {
      x = originX;
      y = originY;
      devReset = false;
    }
    super.tick(moveX, moveY);  // calls Danger.position(moveX,moveY) + draw()
  }

  /** Reset this spike back to its original world position */
  public void center() {
    x = originX;
    y = originY;
    // if you ever scroll outside of draw, clear those too:
    scrollX = 0;
    scrollY = 0;
    devReset = false;
  }

}
