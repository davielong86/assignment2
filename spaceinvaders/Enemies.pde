class Enemy extends SpaceShip 
{
  Enemy(int xpos, int ypos) 
  {
    x = xpos;
    y = ypos;
    sprite    = new String[5];
    sprite[0] = "1011101";
    sprite[1] = "0101010";
    sprite[2] = "1111111";
    sprite[3] = "0101010";
    sprite[4] = "1000001";
  }

  void updateObj() 
  {
    if (frameCount%20 - level == 0) x += direction * gridsize;
    if (incrementY == true) y += gridsize / 2;
    if (y >= height - 90) gameState = 3;
  }

  boolean alive() 
  {
    for (int i = 0; i < bullets.size(); i++) 
    {
      Bullet bullet = (Bullet) bullets.get(i);
      if (bullet.x > x && bullet.x < x + 7 * pixelsize + 5 && bullet.y > y && bullet.y < y + 5 * pixelsize) 
      {
        bullets.remove(i);
        return false;
      }
    }
    println(score);

    return true;
  }

  boolean outside() 
  {
    if (x + (direction*gridsize) < 0 || x + (direction*gridsize) > width) 
    {
      return true;
    }
    else 
    {
      return false;
    }
  }
}

void createEnemies() 
{
  for (int i = 0; i < width/gridsize/2; i++) 
  {
    for (int j = 0; j <= 5; j++) 
    {
      enemies.add(new Enemy(i*gridsize, j*gridsize));
    }
  }
}

void create()
{
  if (creatE == true)
  {
    createEnemies();
  }
}