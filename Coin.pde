public float currentX, currentY;

class Coin extends Thing {
  PImage sprite;
  boolean collected = false;

  Coin(String imgName, float xpos, float ypos, int w, int h) {
    super(w, h, xpos, ypos, 0, 0);
    sprite = loadImage(imgName + ".png");          // loadImage in setup() is best practice :contentReference[oaicite:3]{index=3}
    sprite.resize(w, h);
  }

  public void position() {
    currentX = x - scrollX;
    currentY = y - scrollY;
  }

  public void draw() {
    if (!collected) image(sprite, currentX, currentY);
  }

  public void tick(Player p) {
    position();
    if (!collected && p.touching2(this, p.x, p.y, x, y)) {
      collected = true;
      p.collected++;                                // track on Player
    }
    draw();
  }
}
