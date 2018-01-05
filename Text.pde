/*
                    ---Text---
 
 Text class handles all the displayed text. Its methods are:
   -createInput() => creates the input field
   -setText() and timingText() => displays texts in a certain position and time
   -connectionChecker() => shows a message if there is not internet connection
   -setSongsPosition() => displays the song's names of an album.
 
 */

class Text {

  private float xPos;
  private float yPos;
  private Textfield input;                                                                       //a controlP5 class (http://www.sojamo.de/libraries/controlP5)
  private String text;
  private int time;
  private int delay;
  private int fontSize;

  Text() {
    text = "";
    xPos = 0;
    yPos = 0;
    delay = 5000;
    fontSize = 12;
    textAlign(CENTER);
  }
  void createInput(PApplet window) {                                                       //create the input text field for searching artists
    ControlP5 cp5;  
    String inputText;
    int textWidth = width/4;
    int textHeight = 30;
    xPos = width/2 - textWidth/2;
    yPos = height/30;

    cp5 = new ControlP5(window);
    inputText = "";                                                    
    PFont font = createFont("arial", 20);  

    input = cp5.addTextfield("input")                                                            //input text settings
      .setLabel("")                                                                              //hide the label
      .setText(inputText)
      .setPosition(xPos, yPos)
      .setSize(textWidth, textHeight)
      .setFont(font)
      .setFocus(true)
      .setColor(#37474F)
      .setColorBackground(#BDBDBD)
      ;

    input.addCallback(new CallbackListener() {                                                       
      public void controlEvent(CallbackEvent theEvent) {
        if (theEvent.getAction()==ControlP5.ACTION_BROADCAST && input.getText().length()>0) {    //when the user press Enter (and the string is not empty), the app calls the Spotify API to search for the artist           
          zoomer.reset();                                                                        //return to the initial zoom
          vertical.deleteNodes(vertical.getRoot());                                              //vertical tree reset
          circle.deleteNodes();                                                                  //circle tree reset

          JSONObject response = request.searchArtists(input.getText());                          //search the artist

          if (response.size() > 0) {                                                             //if object exist (the artist exist) the app set the root node with it
            PImage img=loadImage(response.getString("image"), "jpg");

            vertical.getRoot().setId(response.getString("id"));                
            vertical.getRoot().setName(response.getString("name"));
            vertical.getRoot().setImg(img);
          }
        }
      }
    }
    );
  }
  void setText(String txt, float _xPos, float _yPos, int _delay) {                               //set text in a specific position, for a certain time (in milliseconds)
    text = txt;
    xPos = _xPos;
    yPos = _yPos;

    time = millis(); 
    delay = _delay;
  }
  void timingText() {                                                                            //it is call every times the draw() method is call. It handles the time for display a text
    textSize(fontSize);
    textAlign(CENTER);
    text(text, xPos, yPos);

    if (millis() > time + delay) {
      text = "";
    }
  }
  void connectionChecker() {                                                                    //check the internet connection. If there isn't, show a message
    if (!internetConnection) {
      textSize(fontSize);
      textAlign(CENTER);
      text("There is no internet connection.", width/2, height/2);
    }
  }
  void setSongsPosition(Node n, Node root, String[] songs, float ang) {                    //manage the text's songs position depending on the position of the album node compared to the artist node 
    float dist = circle.getRadius();
    int fontSize = int((n.getRadius()*2)/5);
    int padding = fontSize;
    float x = root.getXPos() + dist * cos(ang);                
    float y = root.getYPos() + dist * sin(ang);
    textSize(fontSize);

    if (cos(ang) >= 0 && sin(ang) >= 0) {                                                       // I Quadrant (horizontal position)
      textAlign(LEFT);
      x += n.getRadius() + padding;
    }
    if (cos(ang) > 0 && sin(ang) < 0) {                                                         // IV Quadrant (horizontal position)             
      textAlign(LEFT);
      x += n.getRadius() + padding;
    }
    if (cos(ang) < 0 && sin(ang) > 0) {                                                         // II Quadrant (horizontal position)
      textAlign(RIGHT);
      x -= n.getRadius() + padding;
    }
    if (cos(ang) < 0 && sin(ang) < 0) {                                                         // III Quadrant (horizontal position)
      textAlign(RIGHT);  
      x -= n.getRadius() + padding;
    }
    if (sin(ang) < 0) {                                                                         // I e II quadrants (vertical position)
      y -= songs.length*padding + n.getRadius();
    }
    if (sin(ang) > 0) {                                                                         // III e IV quadrants (vertical position)                            
      y += n.getRadius();
    }

    text(n.getName(), x, y);                                                                    //write the album's title
    y+=padding;

    for (String song : songs) {
      fill(#BDBDBD);
      text(song, x, y+=padding);                                                                //write the song's title
    }
    fill(255);
  }
}