public abstract class Danger extends Thing {
  //
  public Danger(float xpos, float ypos, int xlen, int ylen) {
    //
    super(xlen, ylen, xpos, ypos, 0, 0); // all danger sx, sy are 0. Moving stuff will be in a different class, Enemy.
  }
}
