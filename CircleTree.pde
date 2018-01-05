/*
                    ---CircleTree---
 
 Subclass of Tree for album nodes. It has a circle disposition of the nodes. 
 We can see it by pressing the right mouse button on an artist's node.
 
 */

class CircleTree extends Tree {

  CircleTree() {
    nodes.remove(root);                                                                                 //best choice for set nodes position
  }
  void deleteAllNodes() {                                                                               //clean the array of nodes
    nodes.removeAll(nodes);
  }
  void setNodesPosition() {
    
    for (int i=0; i<nodes.size(); i++) {
      Node n = nodes.get(i);
      n.setRadius(min((radius * PI)/nodes.size(), root.getRadius()));                                   //size of album's nodes (the min size is equal to the parent node size) 

      float angle = i * TWO_PI / nodes.size();                                                          //calculate the nodes position in an immaginary circle
      float x = root.getXPos() + radius * cos(angle);                
      float y = root.getYPos() + radius * sin(angle);                
      n.setPos(x, y);                                                                                   //set the node position
    }
    drawNodes();                                                                                        //draw all the nodes
  }   
  void drawNodes() {
    for (Node n : nodes) {
      drawLine(root, n);                                                                                //draw the lines between root and album's nodes
      n.drawNode();                                                                                     //draw the node
    }
  }
  void nodesClickChecker() {    
    for (int i=0; i<nodes.size(); i++) {
      Node selectedNode = nodes.get(i);                                                                 //node that could be selected

      if (mousePressed &&  mouseButton == LEFT && !zoomer.isPanning()) {                                //if I click everywhere (for closing the album-level nodes)

        addTransparency(vertical.getNodes(), 255);                                                      //return to the non-tranparent nodes
        deleteAllNodes();                                                                               //delete all the nodes
      }

      if (selectedNode.mouseOnNode()) {                                                                 //if I'm on node with mouse...

        if (selectedNode.getSongs().length == 0) {                                                      //I get the song of that album and I store them in an array
          String[] songs = request.getSongs(selectedNode.getId());
          selectedNode.setSongs(songs);
        } else {                                                                                        //if I already have the "songs" array, I use it instead of sending again the request
          float angle = i * TWO_PI / nodes.size();                                                      //calculate the angle for text position
          text.setSongsPosition(selectedNode, root, selectedNode.getSongs(), angle);                    //method for set song's text position
        }
      }
    }
  }
}