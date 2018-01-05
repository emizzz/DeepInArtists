/*
                    ---SpotifyRequests---
 
 SpotifyRequests handles all the requests to Spotify server. It allows to:
   -requestAccessToken();
   -getFirstArtist();
   -searchArtists();
   -getRelatedArtists();
   -getAlbums();
   -getSongs();
 
 */

class SpotifyRequests {
  private String CLIENTID;
  private String CLIENTSECRET;
  private String accessToken;

  public SpotifyRequests() {
    CLIENTID = "your client id";                     //substitute it width your Spotify client id  (https://developer.spotify.com/web-api/authorization-guide/)
    CLIENTSECRET = "your client secret";             //substitute it width your Spotify client secret 
    accessToken = "";
  }
  public void requestAccessToken() {                                                                                         
    try {
      String b64Auth = DatatypeConverter.printBase64Binary((CLIENTID + ":" + CLIENTSECRET).getBytes());                 

      PostRequest post = new PostRequest("https://accounts.spotify.com/api/token");
      post.addData("grant_type", "client_credentials");
      post.addHeader("Authorization", "Basic " + b64Auth);
      post.send();
      String content = post.getContent();
      JSONObject responseJson = parseJSONObject(content);
      accessToken = responseJson.getString("access_token");
      println("access token: done.");
      if (accessToken == null) {
        throw new NullPointerException("null value for access token recived");
      }
      internetConnection = true;                                                                                                                              //if the request is successful, then the connection works
    }
    catch(NullPointerException e) {
      internetConnection = false;
    }
  }
  public JSONObject getFirstArtist() {                                                                                                                         //output (JSONObject): artist's id (String), name (String) and image (String) -or- empty obj (artist that give a new release)
    JSONObject artist = new JSONObject();

    try {
      GetRequest get = new GetRequest("https://api.spotify.com/v1/browse/new-releases?limit=1");    
      get.addHeader("Authorization: Bearer " + accessToken, "application/json");
      get.send();

      String artistItem = parseJSONObject(get.getContent()).getJSONObject("albums").getJSONArray("items").getJSONObject(0).getJSONArray("artists").getJSONObject(0).getString("name");
      artist = searchArtists(artistItem);                                                                                                                      //call to the method for search an artist

      internetConnection = true;
    }
    catch(NullPointerException e) {
      internetConnection = false;                                                                                                                              //variable to check the internet connection. If it is false, the app will display a message.
      request.requestAccessToken();                                                                                                                            //if the connection is restored, the app try to request the access token again
      println(e.getMessage());
    }
    return artist;
  }
  public JSONObject searchArtists(String txt) {                                                                                                               //input (String): artist to search  --- output (JSONObject): artist's id (String), name (String) and image (String) -or- empty obj
    JSONObject artist = new JSONObject();

    try {
      String searchedArtist = URLEncoder.encode(txt, "UTF-8");
      GetRequest get = new GetRequest("https://api.spotify.com/v1/search?q=" + searchedArtist + "&type=artist&limit=1");    
      get.addHeader("Authorization: Bearer " + accessToken, "application/json");
      get.send();

      JSONArray artistsItem = parseJSONObject(get.getContent()).getJSONObject("artists").getJSONArray("items");

      if (artistsItem.size() < 1) {                                                                                                                           //if the artist doesn't exist the app displays a message
        text.setText("This artist does not exist! Please, write the correct name.", width/2, height - 50, 5000);
        throw new NullPointerException("This artist does not exist! Please, write the correct name.");
      } else {
        JSONObject artistEl = artistsItem.getJSONObject(0);
        int sizeImage = artistEl.getJSONArray("images").size();

        String id = artistEl.getString("id");
        String name = artistEl.getString("name");
        String img = "";

        if (sizeImage > 0) {                                                                                                                                  //some artists doesn't have any image
          img = artistEl.getJSONArray("images").getJSONObject(1).getString("url");                                                                            //get url of the image
        }

        artist.setString("id", id);                                                                                 
        artist.setString("name", name);                                                                                                                     
        artist.setString("image", img);
      }

      internetConnection = true;
    }
    catch(NullPointerException e) {
      internetConnection = false;
      request.requestAccessToken();                                                
      println(e.getMessage());
    }
    catch(UnsupportedEncodingException e) {
    }
    return artist;
  }
  public JSONArray getRelatedArtists(String _id) {                                                                                                            //input (String): id of an artist --- output (JSONArray): [{artist's id (String), name (String) and image (String)}] -or- empty obj
    JSONArray relatedArtists = new JSONArray();
    JSONArray related = new JSONArray();

    try {
      GetRequest get = new GetRequest("https://api.spotify.com/v1/artists/" + _id + "/related-artists");    
      get.addHeader("Authorization: Bearer " + accessToken, "application/json");
      get.send();

      relatedArtists = parseJSONObject(get.getContent()).getJSONArray("artists");

      for (int i=0; i<vertical.getnNodes(); i++) {                                                                                                            //take the number of nodes set in the vertical tree
        JSONObject el = relatedArtists.getJSONObject(i);
        JSONObject newEl = new JSONObject();
        int sizeImages = el.getJSONArray("images").size();
        String id = el.getString("id");
        String name = el.getString("name");
        String img = "";

        if (sizeImages > 0) {
          img = el.getJSONArray("images").getJSONObject(sizeImages - 1).getString("url");                                                                     //get url of the last image (the smallest)
        }

        newEl.setString("id", id);
        newEl.setString("name", name);
        newEl.setString("image", img);

        related.setJSONObject(i, newEl);
      }

      internetConnection = true;
    }
    catch(Exception e) {
      internetConnection = false;
      request.requestAccessToken();                                                  
      println("There is an error, try to check the connection");
    }
    return related;
  }
  public JSONArray getAlbums(String _id) {                                                                                                                    //input (String): id of an artist --- output (JSONArray): [{album's name (String) and album's image (String)}] -or- empty obj
    JSONArray allAlbums = new JSONArray();
    JSONArray albums = new JSONArray();

    try {
      GetRequest get = new GetRequest("https://api.spotify.com/v1/artists/" + _id + "/albums?album_type=album&limit=50");    
      get.addHeader("Authorization: Bearer " + accessToken, "application/json");
      get.send();

      allAlbums = parseJSONObject(get.getContent()).getJSONArray("items");
      String prevAlbum = "";

      for (int i=0; i<allAlbums.size(); i++) {
        JSONObject album = allAlbums.getJSONObject(i);
        JSONObject newAlbum = new JSONObject();

        String name = album.getString("name");
        String id = album.getString("id");
        int sizeImages = album.getJSONArray("images").size();

        String img = "";

        if (sizeImages > 0) {
          img = album.getJSONArray("images").getJSONObject(sizeImages - 1).getString("url");
        }

        newAlbum.setString("id", id); 
        newAlbum.setString("name", name); 
        newAlbum.setString("image", img); 

        if (!prevAlbum.equals(name)) {                                                                                                                        //check for duplicate albums
          albums.append(newAlbum);
        }
        prevAlbum = name;
      }

      internetConnection = true;
    }
    catch(Exception e) {
      internetConnection = false;
      request.requestAccessToken();                                                 
      println("There is an error, try to check the connection");
    }
    return albums;
  }
  public String[] getSongs(String _id) {                                                                                                                      //input (String): id of an album --- output (String[]): [songs's name (String)] -or- empty array
    JSONArray allSongs = new JSONArray();
    String[] songs = new String[0];

    try {
      GetRequest get = new GetRequest("https://api.spotify.com/v1/albums/" + _id + "/tracks");    
      get.addHeader("Authorization: Bearer " + accessToken, "application/json");
      get.send();

      allSongs = parseJSONObject(get.getContent()).getJSONArray("items");

      songs = new String[allSongs.size()];

      for (int i=0; i<allSongs.size(); i++) {
        JSONObject song = allSongs.getJSONObject(i);
        String name = song.getString("name");                                  
        songs[i] = name;
      }

      internetConnection = true;
    }
    catch(Exception e) {
      internetConnection = false;
      request.requestAccessToken();                                                 
      println("There is an error, try to check the connection");
    }
    return songs;
  }
}