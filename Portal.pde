class Portal extends Thing {
  PImage sprite;
  boolean active = false;

  Portal(String imgName, float xpos, float ypos, int w, int h) {
    super(w, h, xpos, ypos, 0, 0);
    sprite = loadImage(imgName + ".png");          // preload portal sprite :contentReference[oaicite:6]{index=6}
    sprite.resize(w, h);
  }

  public void position() {
    currentX = x - scrollX;
    currentY = y - scrollY;
  }

  public void draw() {
    if (active) image(sprite, currentX, currentY);
  }

  public void tick(Player p) {
    position();
    draw();
  }

  public boolean reached(Player p) {
    return active && p.touching2(this, p.x, p.y, x, y);
  }
}
