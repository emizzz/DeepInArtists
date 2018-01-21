/*
                                                              ---Deep in Artists---
                                          
                               A Spotify based application that allows us to discover new artists, albums and songs.
*/

import http.requests.*;                                                                                     //http library                                 
import org.gicentre.utils.move.*;                                                                           //zoom library
import controlP5.*;                                                                                         //GUI library
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import javax.xml.bind.DatatypeConverter;
import java.util.*;


color backgroundColor = #000026;                                                                           //global var for bg color
boolean internetConnection = false;                                                                        //global var for connection checker  

CircleTree circle = new CircleTree();                                                                      //circle graph (artist's albums)
VerticalTree vertical = new VerticalTree();                                                                //tree graph (related artists)
Text text;                                                                                                 //class for text handling
SpotifyRequests request = new SpotifyRequests();                                                           //class for spotify requests
ZoomPan zoomer = new ZoomPan(this);                                                                        //class for the zoom

void setup() {
  fullScreen();
  text = new Text();                                                                                                              
      
  zoomer.setMinZoomScale(0.8);                                                                             // set min zoom allowed
  zoomer.setMaxZoomScale(15);                                                                              // set max zoom allowed
  text.createInput(this);                                                                                  //create the input text field

                                                                       
  request.requestAccessToken();                                                                            //get the token for spotify requests

  JSONObject firstArtist = request.getFirstArtist();                                                       //load the first artist (artist with new releases) and add it id, name and image
  PImage img=loadImage(firstArtist.getString("image"), "jpg");
  vertical.getRoot().setId(firstArtist.getString("id"));              
  vertical.getRoot().setName(firstArtist.getString("name"));
  vertical.getRoot().setImg(img);

  text.setText("Left-click on the nodes to expand the tree.\n\nRight-click on the node" +                  //set initial text (how to use the app)
    "to discover artist's albums.\n\nGo over the album nodes to reveal the tracks.\n\nSearch" + 
    "an artist.\n\nDon't forget to zoom, you can use the mouse keys or the scroll wheel", 210, 100, 50000);
}
void draw() {
  //surface.setTitle(int(frameRate) + " fps");                                                               //for checking fps
  
  pushMatrix();

  zoomer.transform();
  background(backgroundColor);

  vertical.setNodesPosition();                                                                              //set position of vertical graph's nodes 
  circle.nodesClickChecker();                                                                               //check if user clicks on the circle graph's nodes
  vertical.nodesClickChecker();                                                                             //check if user clicks on the tree graph's nodes
  circle.setNodesPosition();                                                                                //set position of cicle graph's nodes

  popMatrix();

  text.connectionChecker();                                                                                 //check for internet connection (and display a message if connection is missing)
  text.timingText();                                                                                        //handle all the timing texts of the app
}