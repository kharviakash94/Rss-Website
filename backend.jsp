<%@page import="java.sql.*,java.net.URL,org.json.*,java.util.*,org.json.simple.parser.JSONParser,java.io.*,java.net.MalformedURLException,org.json.simple.JSONArray,org.json.simple.JSONObject,java.util.Iterator"%>
<%!
                public static String readRSS(String urlAddress) {

        try {
            URL rssurl = new URL(urlAddress);

            String sourcecode;
            try (BufferedReader in = new BufferedReader(new InputStreamReader(rssurl.openStream()))) {
                sourcecode = "";
                String line = "";
                while ((line = in.readLine()) != null) {
                    sourcecode += line + "\n";
                }
            }
            return sourcecode;
        } catch (MalformedURLException ue) {
            return "MalformedURLException";
        } catch (IOException ioe) {

            return "Io exception ";

        }

    }
    %>
<%
    
        int ok = 0, err = 0,totalRecords=0;
        
        JSONParser parser = new JSONParser();
        String feeds[] = new String[]{"https://api.rss2json.com/v1/api.json?rss_url=http://feeds.foxnews.com/foxnews/latest", "https://api.rss2json.com/v1/api.json?rss_url=http://rss.cnn.com/rss/edition_world.rss", "https://api.rss2json.com/v1/api.json?rss_url=https://www.hindustantimes.com/rss/topnews/rssfeed.xml", "https://api.rss2json.com/v1/api.json?rss_url=https://talksport.com/feed/", "https://api.rss2json.com/v1/api.json?rss_url=https://rss.nytimes.com/services/xml/rss/nyt/Technology.xml", "https://api.rss2json.com/v1/api.json?rss_url=https://www.theguardian.com/uk/rss", "https://api.rss2json.com/v1/api.json?rss_url=http://feeds.reuters.com/Reuters/worldNews"};
        for (String feed : feeds) {
            String jsonString = readRSS(feed);
            //try {
                
                JSONObject data = (JSONObject) parser.parse(jsonString);
                //System.out.println(data.toString());
                JSONObject src = (JSONObject)data.get("feed");
                //System.out.println(src.get("title").toString());
               
                JSONArray items = (JSONArray) data.get("items");
                for (Iterator it = items.iterator(); it.hasNext();) {
                    Object item1 = it.next();
                    JSONObject item = (JSONObject) item1;
                    //System.out.println("Star of insert");
                    ++totalRecords;
                     //Dbconn.insert(item.get("author").toString(), item.get("title").toString(), item.get("description").toString(), item.get("link").toString(), item.get("pubDate").toString(),src.get("title").toString());
                    //System.out.println("end of insert");
                    ++ok;
                    
                    String author=item.get("author").toString();
                    String title=item.get("title").toString();
                    String description=item.get("description").toString();
                    String link=item.get("link").toString();
                    String pubDate=item.get("pubDate").toString();
                    String provider=src.get("title").toString();
                    System.out.println("author");
                    
                    Connection conn=null;
                    Statement st=null;
                    ResultSet rs;
                    int issue=0,total=0;
            try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/test", "root", "");
            st = conn.createStatement();
            } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Exception: " + e);
            
            }   

            String query = "insert into rss_feeds(author, title, description, pubDate,link,provider) values ('" + author + "','" + title + "','" + description + "','" + pubDate + "','" + link + "','" + provider + "');";
            System.out.println(query);

            try {
            st.executeUpdate(query);
            ++total;
            } 
            catch (Exception e) {
            ++issue;
            e.printStackTrace();
            }finally{
        if(st != null){
            try{
                st.close();
            }catch(SQLException e){}
        }
        if(conn != null){
            try{
                conn.close();
            }catch(SQLException e){}
        }
    }
                    
                }

            
        }
        %>            
        
   