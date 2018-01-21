/*
                    ---Tree---
 
 Tree class allows to manage a set of nodes. In this app it is the parent class
 of 2 classes: CircleTree and VerticalTree.
 
 */

class Tree {
  protected Node root;
  protected ArrayList<Node> nodes;                                                               //list of nodes in the tree                   
  protected color lineColor;
  protected float lineWeight;
  protected float radius;                                                                        //global radius (for all the nodes in the tree)
  protected float defaultRadius;                                                                 //initial global radius value

  Tree() {
    root = new Node(0, 0);
    nodes = new ArrayList<Node>();
    lineColor = #e9d700;
    defaultRadius = 20;
    radius = defaultRadius;
    lineWeight = 0.05;
    nodes.add(root);                                                                             //add root to the nodes
  }
  Node getRoot() {
    return root;
  }
  void drawLine(Node n1, Node n2) {                                                              //draw the line between 2 nodes
    strokeWeight(lineWeight);
    stroke(lineColor);
    line(n1.getXPos(), n1.getYPos(), n2.getXPos(), n2.getYPos());
  }
  void addNodes(Node prevNode, JSONArray spotifyRequest, int limit, String type) {               //add nodes to the tree   
    if (spotifyRequest.size()>0) {
      for (int i=0; i<limit; i++) {                                                                       
        JSONObject song = spotifyRequest.getJSONObject(i);
        PImage img=loadImage(song.getString("image"), "jpg");
  
        Node newNode = new Node(0, 0);           
        newNode.setName(song.getString("name"));                                                 //set information to the tree
        newNode.setId(song.getString("id"));
        newNode.setImg(img);
  
        if (type=="vertical")  prevNode.setOutLinksNode(newNode);                                          
        newNode.setInLinksNode(prevNode);
  
        nodes.add(newNode);                                                                      //add the node to nodes
      }
    }
  }
  void drawNodes() {
    root.drawNode();                                                                             //draw root

    for (Node n : nodes) {
      for (Node o : n.outlinks) {
        o.setRadius(getRadius());                                                                //set radius to all the nodes

        drawLine(n, o);
        o.drawNode();
      }
    }
  }
  void deleteNodes() {                                                                           //clean the array of nodes
    nodes.removeAll(nodes);
  }
  void addTransparency(ArrayList<Node> nds, int _t) {                                            //add alpha value to images of the nodes
    for (Node n : nds) {
      n.setImgTransparency(_t);
    }
  }
  int getDepth(Node _n)                                                                          //get depth of the tree
  {
    if (_n.getOutLinksNum()==0) return 1;
    int d = 0;
    ArrayList<Node> outgoing = _n.getOutLinks();
    for (Node child : outgoing) {
      int dc = getDepth(child);
      if (dc>d) { 
        d=dc;
      }
    }
    return 1+d;
  }
  float getRadius() {
    return radius;
  }
  ArrayList<Node> getNodes() {
    return nodes;
  }
  void setRadius(float _r) {
    radius = _r;
  }
}