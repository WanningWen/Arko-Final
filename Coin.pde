public float currentX, currentY;

class Coin extends Thing {
  // add these fields:
  public float currentX, currentY;
  public PImage sprite;
  public boolean collected = false;

  Coin(String imgName, float xpos, float ypos, int w, int h) {
    super(w, h, xpos, ypos, 0, 0);
    sprite = loadImage(imgName + ".png");
    sprite.resize(w, h);
  }

  // 1) Compute screen coords without changing world x/y
  public void position(float scrollX, float scrollY) {
    currentX = x - scrollX;
    currentY = y - scrollY;
  }

  // 2) Draw only if not yet collected
  public void draw() {
    if (!collected) {
      image(sprite, currentX, currentY);
    }
  }

  // 3) Tick: update position, check collision, then draw
  public void tick(Player p) {
    // pass in the players scroll offsets
    position(p.getScrollX(), p.getScrollY());

    // collision with player (world x/y vs world x/y)
    if (!collected && p.touching2(this, p.x, p.y, x, y)) {
      collected = true;
      p.collected++;
    }

    draw();
  }
  
  public float getWorldX() { return x; }
  public float getWorldY() { return y; }
}
