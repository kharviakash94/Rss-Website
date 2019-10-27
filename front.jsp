<%@page import="java.sql.*,org.json.*"%>

<%
            //int start =0;
            //int end =15;
            
            Connection conn=null;
            Statement st=null;
            ResultSet rs=null;
            Class.forName("com.mysql.jdbc.Driver");
        try{
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/test?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC", "root", "");
            st = conn.createStatement();
            String query = "SELECT DISTINCT title,link,provider,pubDate,dateofentry FROM `rss_feeds` ORDER BY dateofentry desc" ;
            
            rs = st.executeQuery(query);
            if(!rs.next()){
            out.print("0");
            }else{
            JSONArray array=new JSONArray();
            do{
                JSONObject obj = new JSONObject();
                obj.put("title",rs.getString("title"));
                obj.put("link",rs.getString("link"));
                obj.put("provider",rs.getString("provider"));
                obj.put("pubDate",rs.getString("pubDate"));
                obj.put("dateofentry",rs.getString("dateofentry"));
                
                array.put(obj.toString());}
        
                while(rs.next());
                out.print(array);
            
            }
        }catch(SQLException e){
         out.print("Exception: "+e);
    }
     
         finally{
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

            
            

        %>