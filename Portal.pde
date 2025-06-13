class Portal extends Thing {
  PImage sprite;
  boolean active = false;

  // add these at the top
  public float currentX, currentY;

  Portal(String imgName, float xpos, float ypos, int w, int h) {
    super(w, h, xpos, ypos, 0, 0);
    sprite = loadImage(imgName + ".png");
    sprite.resize(w, h);
  }

  // compute on-screen coords
  public void position(float scrollX, float scrollY) {
    currentX = x - scrollX;
    currentY = y - scrollY;
  }

  // only draw once active
  public void draw() {
    if (active) {
      image(sprite, currentX, currentY);
    }
  }

  // tick needs to update position & then draw
  public void tick(Player p) {
    position(p.getScrollX(), p.getScrollY());
    draw();
  }

  // whether player overlaps portal
  public boolean reached(Player p) {
    return active && p.touching2(this, p.x, p.y, x, y);
  }
}
