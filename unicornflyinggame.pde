import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer jingle;

PImage player, startplayer, background, startscreen, stars, pipes; // variables

int x, y, vy = 2; // variables for velocity and player

int game = 1; // game = 0 means actual game screen, while game = 1 means the start screen

// variables for pipes
int[] px = new int[2];
int[] py = new int[2];
boolean[] pipePassed = new boolean[2]; // Track if the pipe has been passed

// variable for score
int score = 0;
int quit = 0;

void setup() {
  size(865, 868); // size of screen must be the same size as background
  
  player = loadImage("twins.png"); // loads image of player
  background = loadImage("sky.png"); // loads image of the background
  startscreen = loadImage("screen.png"); // loads image of start screen
  stars = loadImage("stars.png"); // loads image of stars
  pipes = loadImage("pipes.png"); // loads image of pipes
  
  minim = new Minim(this); 
  jingle = minim.loadFile("plasticlove.mp3"); // takes the music from file
  jingle.loop(); // allows the music to play again when the music finishes
  
  // Set the volume of the jingle
  jingle.setGain(-15); // Reduce volume by 10 dB.
  
  // Initialize pipePassed array
  for (int i = 0; i < 2; i++) {
    pipePassed[i] = false;
  }
}

void draw() {
  background(background); // image imported as background for game
  
  fill(127, 142, 204); // makes color of text into an orchid blue/purple color
  textSize(50); // size of text is 50
  
  if (game == 0) { // when screen is in actual game
    image(stars, 0, 0); // stars put over the background
    image(player, width / 2, y); // player loads at the top of the screen
    
    y += vy; // determines how "heavy" the player falls (gravity)
    vy += 1; 
    
    for (int i = 0; i < 2; i++) {
      image(pipes, px[i], py[i] - (pipes.height / 2 + 200)); 
      image(pipes, px[i], py[i] + (pipes.height / 2 + 200));
      
      if (px[i] < 0) { 
        py[i] = (int)random(200, height - 200);
        px[i] = width;
        pipePassed[i] = false; // Reset flag when pipe is repositioned
      }
      
      // Check if player has passed the pipe
      if (px[i] < width / 2 && !pipePassed[i]) {
        score++;
        pipePassed[i] = true; // Set flag to true after scoring
      }
      
      // Game over conditions
      if (y > height || y < 0 || (abs(width / 2 - px[i]) < 25 && abs(y - py[i]) > 100)) {
        game = 1; 
      }
      
      px[i] -= 6;
    }
    
    text("" + score, width / 2 - 15, 700); // score is displayed at the bottom of the screen in game screen
  } else {
    // sets images at the center of the screen
    imageMode(CENTER);
    image(startscreen, width / 2, height / 2);
    image(player, width / 2, height / 2);
    text("Press any key to start!", 50, 60); // displays at the top of screen
    text("Avoid the pipes!", 50, 780); // displays at the bottom of start screen
  }
}

void keyPressed() { // when any key is pressed
  vy = -15; // velocity at -15

  if (game == 1) { // when in start screen
    // Reset game variables
    px[0] = 600; // starting point of pipe 
    py[0] = height / 2; 
    px[1] = 900;
    py[1] = 500;
    x = 0;
    y = height / 2;
    score = 0; // Reset the score to 0
    game = 0; // Switch to game screen
    
    // Initialize pipePassed array
    for (int i = 0; i < 2; i++) {
      pipePassed[i] = false;
    }
  }
}
