class Thing {
  //
  public int level, collected, collectedMax, tick, platformSX, platformSY;
  public float time, impulseX, impulseY;
  public float[] highScores;
  public int[] levels;
  public String collectedDisplay, exit;
  public int xsize, ysize;
  public float x, y;
  public int sx;
  public float sy;
  public float scrollX, scrollY;
  public Thing(int xlen, int ylen, float xpos, float ypos, int sxp, float syp) {
    //
    this.scrollX = 0;
    this.scrollY = 0;
    this.level = 1;
    this.collected = 0;
    this.collectedMax = 20; // placeholder
    this.tick = 0;
    this.platformSX = 0;
    this.platformSY = 0;
    this.time = 0.0;
    this.xsize = xlen;
    this.ysize = ylen;
    this.x = xpos;
    this.y = ypos;
    this.exit = "";
    this.sx = sxp;
    this.sy = syp;
  }
  // check if two things are touching
  public boolean touching(Thing obj, float xpos, float ypos, float objx, float objy) {
    // check if this Thing is touching obj
    // get all pixels covered by this and object
    // testing:
    //System.out.println("this.x: " + xpos + "\n this.y: " + ypos + "\n this.xsize: " + this.xsize + "\n this.ysize: " + this.ysize + "\n obj.x: " + obj.x + "\n obj.y: " + obj.y + "\n obj.xsize: " + obj.xsize + "\n obj.ysize: " + obj.ysize);
    // end testing
    if (xpos <= obj.x + obj.xsize && xpos + this.xsize >= obj.x) {
      //
      if (ypos <= obj.y + obj.ysize && ypos + this.ysize >= obj.y) {
        // touching!
        //println("touching");
        return true;
      }
    }
    // placeholder:
    return false;
  }
  public boolean touching2(Thing obj, float xpos, float ypos, float objx, float objy) {
    // check if this Thing is touching obj
    // get all pixels covered by this and object
    if (!((xpos > objx + obj.xsize && xpos + this.xsize > objx + obj.xsize ) || (xpos < objx && xpos + this.xsize < objx))) {
      //
      if (!((ypos > objy + obj.ysize && ypos + this.ysize > objy + obj.ysize ) || (ypos < objy && ypos + this.ysize < objy))) {
        // touching!
        return true;
      }
    }
    // placeholder:
    return false;
  }
  public boolean borderingRight(Thing obj, float xpos, float ypos, float objx, float objy) {
    // platform is on the RIGHT side of the player
    if (ypos + this.ysize <= objy || objy + obj.ysize <= ypos) {
      // not overlapping ypos so cannot be overlapping xpos for the purposes of this function
      return false;
    }
    if (xpos + this.xsize + this.sx < objx) {
      return false;
    }
    if (xpos + this.xsize <= objx && xpos + this.xsize + this.sx >= objx) {
      this.x += (objx - this.xsize - xpos);
      return true;
    }
    return false;
  }
  public boolean borderingLeft(Thing obj, float xpos, float ypos, float objx, float objy) {
    // platform is on the LEFT side of the player
    if (ypos + this.ysize <= objy || objy + obj.ysize <= ypos) {
      // not overlapping ypos so cannot be overlapping xpos for the purposes of this function
      return false;
    }
    if (objx + obj.xsize + this.sx < xpos) {
      return false;
    }
    if (objx + obj.xsize <= xpos && objx + obj.xsize + this.sx >= xpos) {
      this.x += (objx + obj.xsize -xpos);
      return true;
    }
    return false;
  }
  public boolean borderingTop(Thing obj, float xpos, float ypos, float objx, float objy) {
    // platform is on TOP of the player, we do not want to jump
    if (xpos + this.xsize <= objx || objx + obj.xsize <= xpos) {
      return false;
    }
    if (objy >= ypos) {
      return false;
    }
    if (ypos >= objy + obj.ysize && ypos <= objy + obj.ysize + 20) {
      return true;
    }
    return false;
  }
  public boolean xOverlapBool(Thing obj, float xpos, float ypos, float objx, float objy) {
    //
    if (ypos + this.ysize <= objy || objy + obj.ysize <= ypos) {
      // not overlapping ypos so cannot be overlapping xpos for the purposes of this function
      return false;
    }
    if (xpos + this.xsize <= objx || objx + obj.xsize <= xpos) {
      // not overlapping xpos
      return false;
    }
    return true;
  }
  public float xOverlap(Thing obj, float xpos, float ypos, float objx, float objy) {
    // check if the xpos are overlapping
    // first we need to make sure that the ypos make sense
    if (ypos + this.ysize <= objy || objy + obj.ysize <= ypos) {
      // not overlapping ypos so cannot be overlapping xpos for the purposes of this function
      return (float) 0;
    }
    // ypos is overlapping, now we handle the xpos:
    if (xpos + this.xsize <= objx || objx + obj.xsize <= xpos) {
      // not overlapping xpos
      return (float) 0;
    }
    // they are overlapping!
    if (keyCode == RIGHT) {
      // we want to move left -> decrease x -> return negative value
      // we need to make xpos = objx - this.xsize
      // so we need to change xpos by (-1 * xpos + objx - this.xsize)
      keyCode = ALT;
      return (float) (objx - xpos - this.xsize);
    }
    if (keyCode == LEFT) {
      // want to move right -> increase x -> return positive value
      // need to make xpos = objx + obj.xsize
      keyCode = ALT;
      return (float) (objx + obj.xsize - xpos);
    }
    // something has gone terribly wrong, I think (that is, if this point is reached)
    return (float) 0;
  }
  // check if two things are bordering
  public boolean bordering(Thing obj, int xpos, int ypos, int objx, int objy) {
    // check if this Thing is touching obj
    // get all pixels covered by this and object
    if (xpos == objx + obj.xsize || xpos + this.xsize == objx) {
      //
      //println("x condition in super bordering function is true");
      if (ypos == objy + obj.ysize || ypos + this.ysize == objy) {
        // touching!
        //println("y condition in super bordering function is true");
        return true;
      }
    }
    // testing
    if ((xpos == objx + obj.xsize || xpos + this.xsize == objx) && (ypos <= objy + obj.ysize && ypos + this.ysize >= objy)) {
      //
      return true;
    }
    if ((ypos == objy + obj.ysize || ypos + this.ysize == objy) && (xpos <= objx + obj.xsize && xpos + this.xsize >= objx)) {
      //
      return true;
    }
    // placeholder:
    return false;
  }  
  
  /** Return this objects world X coordinate */
  public float getX() {
    return x;
  }

  /** Return this objects world Y coordinate */
  public float getY() {
    return y;
  }

}
