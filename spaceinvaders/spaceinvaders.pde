import controlP5.*;
ControlP5 controlP5;
controlP5.Button b;
ControlFont cf1;

int gameState = 0;
int pixelsize = 6;
int score = 0;
int level = 1;
int pscore;
int gridsize  = (pixelsize * 7) + 5;
ArrayList enemies = new ArrayList();
ArrayList bullets = new ArrayList();
int direction = 1;
boolean incrementY = false;
boolean display = false;
boolean creatE = true;
Player player;

void setup() 
{
  noStroke();
  fill(0,255,0);
  fullScreen();
  player = new Player();

  controlP5 = new ControlP5(this);  
  cf1 = new ControlFont(createFont("Times", 15));
  createButton("PLAY", 1, width/2, height/2, color(255, 0, 0), cf1);
}

Button createButton(String theName, int theValue, int theX, int theY, color theColor, ControlFont font) 
{

  b = controlP5.addButton(theName, theValue, theX, theY, 100, 40);
  b.setColorActive(theColor); // color for mouse-over
  b.setColorBackground(color(0)); // default color
  b.getCaptionLabel().setFont(font);
  b.setSwitch(true);
  return b;
}

void controlEvent(ControlEvent theEvent)
{
  gameState = (int)theEvent.getValue();
}


void hideButton() 
{
  if (display == false) 
  {
    b.hide();
  } else 
  {
    b.show();
  }
}

void keyPressed()
{
  if (key > '0' && key <='3')
  {
    gameState = key - '0';
  }
}
void check()
{
  if (score == 119 * level)
  {
    gameState = 2;
    level += 1;
  }
}

void cleanup()
{
  for (int i = 0; i < enemies.size(); i++) 
    {
      Enemy enemy = (Enemy) enemies.get(i);
      if (enemy.alive()) 
      {
        enemies.remove(i);
      }
    }
    for (int i = 0; i < bullets.size(); i++) 
    {
        bullets.remove(i);
    }
    if (gameState == 3)
    {
      score = 0;
      level = 1;
    }
}

void draw() 
{
  background(0);
  textSize(30);
  hideButton();
  if (gameState == 0)
  {
    display = true;
  } 
  else if (gameState == 1)
  {
    create();
    creatE = false;
    display = false;
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
        check();
        score ++;
        pscore = score;
      } else 
      {
        enemy.draw();
      }
    }
    incrementY = false;
  } else if (gameState == 2)
  {
    text("you win", 200, 200);
    text("LEVEL:"+ level, 200, 250);
    text("your score is:"+ score, 200, 300);
    
    cleanup();
    creatE = true;
    display = true;
  } else if (gameState == 3)
  {
    text("you lose", 200, 200);
    text("LEVEL:"+ level, 200, 250);
    text("your score is:"+ pscore, 200, 300);
    
    cleanup();
    creatE = true;
    display = true;
  }
}