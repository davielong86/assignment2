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
Table table;

Player player;

void setup() 
{
  noStroke();
  fill(0, 255, 0);
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

  String[] strings = loadStrings("data.csv"); // Load each line into a String array
  playerScore = new ArrayList<Integer>(); // Create an arraylist
  playerName = new ArrayList<String>(); // Create an arraylist

  for (String s : strings)
  {

    String[] line = s.split(",");

    playerScore.add(Integer.parseInt(line[0]));
    playerName.add((line[1]));
  }
}
void saveData(String playerN, int pscore)
{
  table = new Table();

  table.addColumn("Score");
  table.addColumn("Name");

  TableRow newRow = table.addRow();
  newRow.setInt("Score", pscore);
  newRow.setString("Name", playerN);

  saveTable(table, "data/data.csv");
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
    text("YOU WIN", 200, 200);
    text("LEVEL:"+ level, 200, 250);
    text("YOUR SCORE IS:"+ score, 200, 300);

    cleanup();
    creatE = true;
    display = true;
  } else if (gameState == 3)
  {
    text("YOU LOSE", 200, 200);
    text("LEVEL:"+ level, 200, 250);
    text("YOUR SCORE IS:"+ pscore, 200, 300);
    text("ENTER NAME:" + playerN, 200, 350);
    
    enterName = true;
    cleanup();
    saveData(playerN, pscore);
    creatE = true;
    display = true;
  }
}