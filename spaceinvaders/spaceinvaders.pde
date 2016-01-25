
int gameState = 0;
int pixelsize = 4;
int score = 0;
int gridsize  = pixelsize * 7 + 5;
ArrayList enemies = new ArrayList();
ArrayList bullets = new ArrayList();
int direction = 1;
boolean incrementY = false;
Player player;


void setup() 
{
  background(0);
  noStroke();
  fill(255);
  size(1200, 800);
  player = new Player();
  createEnemies();
  
}

void draw() 
{
  background(0);
  if (gameState == 0)
  {
    text("start Game",width / 2, height / 2);
  }
  else if (gameState == 1)
  {
  player.draw();
  for (int i = 0; i < bullets.size(); i++) 
  {
    Bullet bullet = (Bullet) bullets.get(i);
    bullet.draw();
  }

  for (int i = 0; i < enemies.size(); i++) 
  {
    Enemy enemy = (Enemy) enemies.get(i);
    if (enemy.outside() == true) 
    {
      direction *= (-1);
      incrementY = true;
      break;
    }
  }
  for (int i = 0; i < enemies.size(); i++) 
  {
    Enemy enemy = (Enemy) enemies.get(i);
    if (!enemy.alive()) 
    {
      enemies.remove(i);
    } else 
    {
      enemy.draw();
    }
  }
  incrementY = false; 
  }
  else if (gameState == 2)
  {
       text("you win",width / 2, height / 2);   
  }
  else if (gameState == 3)
  {
        text("you Lose",width / 2, height / 2);
  }
}