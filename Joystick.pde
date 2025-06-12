public class Joystick {
  //
  public int joyX;
  public int joyY;
  public Joystick() {
    //
    this.joyX = 0;
    this.joyY = 0;
  }
  public void tick() {
    //
    this.joyX = 0;
    this.joyY = 0;
    if (keyPressed) {
      //
      if (keyCode == UP) {
        //
        this.joyY = 1;
      }
      if (keyCode == DOWN) {
        //
        this.joyY = -1;
      }
      if (keyCode == LEFT) {
        //
        this.joyX = -1;
      }
      if (keyCode == RIGHT) {
        //
        this.joyX = 1;
      }
    }
  }
}
