import controlP5.*;
ControlP5 controlP5;
controlP5.Button b;
ControlFont cf1;

int gameState = 0;
int pixelsize = 6;
int score = 0;
int level = 1;
int pscore = 0;
int direction = 1;
int gridsize  = (pixelsize * 7) + 5;

String playerN = new String();

ArrayList enemies = new ArrayList();
ArrayList bullets = new ArrayList();
ArrayList playerScore = new ArrayList();
ArrayList playerName = new ArrayList();

boolean incrementY = false;
boolean display = false;
boolean creatE = true;
boolean enterName = false;

PrintWriter output;

Player player;

void setup() 
{
  //noStroke();
  loadData();
  fill(0, 255, 0);
  fullScreen();
  player = new Player();
  
  controlP5 = new ControlP5(this);  
  cf1 = new ControlFont(createFont("Times", 25));
  createButton("PLAY", 1, 50, 50, color(255, 0, 0), cf1);
  createButton("QUIT", 4, 50, 100, color(255, 0, 0), cf1);

  controlP5.addBang("ENTER")
     .setPosition(240,400)
     .setSize(80,40)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;   
}

public void ENTER()
{
    playerName.add(playerN);
    playerScore.add(pscore);
    saveData();
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
    controlP5.hide();
  } else 
  {
    b.show();
    controlP5.show();
  }
}

void keyPressed()
{
  if (key > '0' && key <='4')
  {
    gameState = key - '0';
  }
  if (enterName == true)
  {
    if (key == BACKSPACE && playerN.length() > 0)
    {
      playerN = playerN.substring(0, playerN.length() - 1);
    } else
    {
      playerN += key;
    }
  }
}

void check()
{
  if (enemies.size() == 0)
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

void loadData()
{

  String[] strings = loadStrings("data/data.csv"); // Load each line into a String array
  playerScore = new ArrayList<Integer>(); // Create an arraylist
  playerName = new ArrayList<String>(); // Create an arraylist

  for (String s : strings)
  {

    String[] line = s.split(",");

    playerScore.add(Integer.parseInt(line[0]));
    playerName.add((line[1]));
  }
}
void saveData()
{
  output = createWriter("data/data.csv");
  for (int i = 0; i < playerScore.size(); i ++)
  {
  output.println(playerScore.get(i) + "," + playerName.get(i));
  output.flush();  // Writes data to the file
  }
  output.close();  // Finish file writing
}

void draw() 
{
  background(0);
  textSize(30);
  hideButton();
  if (gameState == 0)
  {
    display = true;
  } else if (gameState == 1)
  {

    playerN = "";
    enterName = false;
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
    text("YOU WIN", 50, 200);
    text("LEVEL:"+ (level-1), 50, 250);
    text("YOUR SCORE IS:"+ score, 50, 300);
    text("HIGH SCORES", width - 400, 50);
    for (int i = 0; i < playerScore.size(); i ++)
    {
      text("Score:"+ playerScore.get(i) + " Name:"+ playerName.get(i), width - 400,100+(50*i));
    }
    cleanup();
    creatE = true;
    display = true;
  } else if (gameState == 3)
  {
    text("YOU LOSE", 50, 200);
    text("LEVEL:"+ level, 50, 250);
    text("YOUR SCORE IS:"+ pscore, 50, 300);
    text("ENTER NAME:" + playerN, 50, 350);

    enterName = true;
    cleanup();
    creatE = true;
    display = true;
  }
  else if (gameState == 4)
  {
    saveData();
    exit();
  }
}