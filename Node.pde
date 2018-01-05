/*
                    ---Node---
 
 Node class represent a node in a tree. In the app they are shown like circles,
 but they are more than a simple drawing. They contain many information like id, 
 name, image, position, ...
 
*/


class Node { 
  private ArrayList<Node> inlinks;                                                                      //input linked nodes                                              
  private ArrayList<Node> outlinks;                                                                     //output linked nodes
  private PVector pos;                                                                                  
  private float radius;
  private color nodeColor;
  private String name;
  private String id;
  private PImage img;
  private String[] songs;
  private int imgTransparency;

  Node(float _x, float _y) {
    inlinks = new ArrayList<Node>();
    outlinks = new ArrayList<Node>();
    pos = new PVector();

    pos.x = _x;
    pos.y = _y;
    radius = 20;
    nodeColor = #F7B633;
    imgTransparency = 255;
    name = "";
    id = "";
    songs = new String[0];
  }
  void drawNode() {
    if (img != null) {                                                                                    //some artist objects don't have an image. I check it.
      int imageSize = int(radius*2);
      PGraphics mask;                                                                                     //mask is useful for create rounded corner images

      mask=createGraphics(img.width, img.height);
      mask.beginDraw();
      mask.smooth();
      mask.background(0);
      mask.fill(255, 255, 255, imgTransparency);
      mask.ellipse(img.width/2, img.height/2, img.width, img.height);                     

      mask.endDraw();

      img.mask(mask);
      imageMode(CENTER);          
      image(img, pos.x, pos.y, imageSize, imageSize);
    } else {                                                                                               //if the artist doesn't have any images, only a white ellipse is shown.
      fill(#ffffff);
      strokeWeight(0);
      ellipse(pos.x, pos.y, radius*2, radius*2);
    }
  }
  void setPos(float _x, float _y) {
    pos.x = _x;
    pos.y = _y;
  }
  void setRadius(float _r) {
    radius = _r;
  }
  void setName(String _name) {
    name = _name;
  }
  void setId(String _id) {
    id = _id;
  }
  void setImg(PImage _img) {
    img = _img;
  }
  void setImgTransparency(int _t) {
    imgTransparency = _t;
  }
  void setInLinksNode(Node _inNode) {
    inlinks.add(_inNode);
  }
  void setOutLinksNode(Node _outNode) {
    outlinks.add(_outNode);
  }
  int getTransparency() {
    return imgTransparency;
  }
  float getRadius() {
    return radius;
  }
  float getXPos() {
    return pos.x;
  }
  float getYPos() {
    return pos.y;
  }
  String getId() {
    return id;
  }
  String getName() {
    return name;
  }
  PImage getImg() {
    return img;
  }
  ArrayList<Node> getInLinks() {
    return inlinks;
  }
  ArrayList<Node> getOutLinks() {
    return outlinks;
  }
  int getOutLinksNum() {
    return outlinks.size();
  }
  boolean mouseOnNode() {                                                                                  //check if mouse is on a node                    
    PVector ellipsePos = new PVector(pos.x, pos.y);        
    ellipsePos.set(zoomer.getCoordToDisp(ellipsePos));                                                     //get position relative to zoom level (it allows to determine the node position also with a different zoom scale)
    double scaleFactor = zoomer.getZoomScale();

    if (mouseX > ellipsePos.x-radius*scaleFactor && mouseX < ellipsePos.x+radius*scaleFactor && mouseY < ellipsePos.y + radius*scaleFactor && mouseY > ellipsePos.y - radius*scaleFactor) return true;
    else return false;
  }
  void setSongs(String[] _songs) {
    songs = _songs;
  }
  String[] getSongs() {
    return songs;
  }
}