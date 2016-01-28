import controlP5.*;
ControlP5 controlP5;
controlP5.Button b;

int gameState = 0;
int pixelsize = 4;
int score = 0;
int gridsize  = pixelsize * 7 + 5;
ArrayList enemies = new ArrayList();
ArrayList bullets = new ArrayList();
int direction = 1;
boolean incrementY = false;
boolean display = false;
Player player;


void setup() 
{
  background(0);
  noStroke();
  fill(255);
  size(1200, 800);
  player = new Player();
  createEnemies();


  controlP5 = new ControlP5(this);  
  ControlFont cf1 = new ControlFont(createFont("Times", 15));
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
  if (score == 107)
  {
    gameState = 2;
  }
}
void draw() 
{
  background(0);
  textSize(30);
  hideButton();
  check();
  if (gameState == 0)
  {
    display = true;
    // text("your score is:"+ score,200,200);
  } else if (gameState == 1)
  {

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
      } else 
      {
        enemy.draw();
      }
    }
    incrementY = false;
  } else if (gameState == 2)
  {
    text("you win", width / 2, height / 2);
  } else if (gameState == 3)
  {
    text("you Lose", width / 2, height / 2);
  }
}