/*
                    ---VerticalTree---
 
 Subclass of Tree for artist nodes. It has a inverse tree disposition of the nodes. 
 We can see it by pressing the left mouse button on an artist's node.
 
 */

class VerticalTree extends Tree {
  private int nNodes;                                                                          //number of added nodes when click on an artist                                                             
  private boolean enableClick;

  VerticalTree() {
    nNodes = 5;                                                                                //this parameter can be changed! 
    enableClick = false;                                                                       //useful to avoid click events firing multiple times
  }
  void deleteNodes(Node prevNode) {                                                            //delete the nodes
    ArrayList<Node> children = prevNode.getOutLinks();

    if (prevNode == root) setRadius(defaultRadius);                                            //reset the radius when I delete all the nodes (excep the root)

    while (children.size() > 0) {                                                              //delete the children of the node I pressed

      for (int c = children.size(); c>0; c--) {
        ArrayList<Node> out = children.get(c-1).getOutLinks();

        for (int o = out.size(); o>0; o--) {
          children.add(out.get(o-1)); 
          nodes.remove(out.get(o-1));
        }

        nodes.remove(children.get(c-1));
        children.remove(children.get(c-1));
      }
    }
  }
  void setNodesPosition() {
    PVector firstPos = new PVector();

    firstPos.x = width/2;
    firstPos.y = height/7;

    int depth = getDepth(root);
    float yStep = (height-20)/depth; 

    root.setPos(firstPos.x, firstPos.y);
    root.setRadius(getRadius());                                                               //set the root radius with the global radius
    ArrayList<Node> children = root.getOutLinks();

    while (children.size()>0)                                                                  //children are all the nodes of a line (newnodes become children)
    {
      int colonN = children.size();                                                            //number of nodes in a line
      float xStep = (width-20) / colonN;  

      firstPos.x = 10 + (xStep/2); 
      firstPos.y += yStep;                                                                     

      ArrayList<Node> newnodes = new ArrayList<Node>();

      for (Node child : children) {
        child.setPos(firstPos.x, firstPos.y);

        if (child.getRadius()*colonN*2 > width || child.getRadius()*depth*2 > height) {        //check for node dimension
          setRadius(getRadius()-0.05);                    
        }

        for (Node n : child.getOutLinks()) {
          newnodes.add(n);
        }
        firstPos.x += xStep;
      }
      children = newnodes;                                                                     //update newnodes
    }
    drawNodes();
  }
  int getnNodes() {
    return nNodes;
  }
  void nodesClickChecker() {   

    for (int i=0; i<nodes.size(); i++) {                                                       
      Node selectedNode = nodes.get(i);                                                        //node that could be selected

      if (!mousePressed) {
        enableClick = true;                                                                    //avoid click events firing multiple times
      }
      if (mousePressed && mouseButton == RIGHT && enableClick && selectedNode.mouseOnNode() && selectedNode.getName()!=null && selectedNode.getTransparency() != 50) {      //mouse RIGHT pressed on node

        JSONArray albums = request.getAlbums(selectedNode.getId());

        circle.getRoot().setRadius(selectedNode.getRadius());                                                         //root is (a copy of) the parent node
        circle.getRoot().setPos(selectedNode.getXPos(), selectedNode.getYPos());                                      //set the same position of the root
        circle.setRadius(int(selectedNode.getRadius()*4));                                                            //radius of the circle tree
        circle.addNodes(selectedNode, albums, albums.size(), "circle");
        
        if (albums.size() < 1) {                                                                                      //checking for artists that has not albums
          addTransparency(vertical.getNodes(), 255);                                                                  //not add transparency to the lower level nodes
          text.setText("This artist has no albums.", width/2, height - 50, 2000);
        } else  addTransparency(getNodes(), 50);                                                                      //add transparency to the lower level nodes

        enableClick = true;
      }

      if (mousePressed && mouseButton == LEFT && enableClick && selectedNode.mouseOnNode() && selectedNode.getName()!=null) {        //mouse LEFT pressed on node 

        if (selectedNode.getOutLinks().size() == 0 && selectedNode.getId().length()>0) {

          if (radius>defaultRadius/2) {                                                                               //if node is too small we can't add more nodes
              
            JSONArray related = request.getRelatedArtists(selectedNode.getId());                                      //get related artists of parent (artist) node
            addNodes(selectedNode, related, getnNodes(), "vertical");
            
          } else {
            text.setText("The Tree is too big. Please, search again or click on the root node...", width/2, height - 50, 5000);
          }
        } else {
          deleteNodes(selectedNode);
        }
        enableClick = false;                                                                                          //enableClick for call the function only once
      }
      if (selectedNode.mouseOnNode()) {                                                                               //mouse over the node

        if (selectedNode.getTransparency() != 50) {                                                                   //if the node is hidden (with transparency) we couldn't see the name 
          String sName = (selectedNode.name != null) ? selectedNode.name : "";
          float sX =  selectedNode.getXPos();
          float sY =  selectedNode.getYPos();

          text(sName, sX, sY + radius*2);                                                                             //show the name of the artist on mouse over
        }
      }
    }
  }
}