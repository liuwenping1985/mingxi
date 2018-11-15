<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="com.sun.xml.bind.v2.runtime.unmarshaller.XsiNilLoader.Array"%>

<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*,java.util.Map.Entry"%>
<%@page import="com.seeyon.ctp.common.SystemEnvironment"%>
<%@page import="com.seeyon.ctp.util.Datetimes"%>
<%@page import="com.seeyon.ctp.util.Strings"%>
<%@page import="com.seeyon.ctp.common.cache.*"%>
<%@page import="com.seeyon.ctp.util.UniqueList"%>

<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<style type="text/css">
<!--
body{
    font-family: Arial;
    font-size: 12px;
}

.c{
    border-top: 1px solid #CCCCCC;
    padding: 5px 0px 5px 5px;
}
.t{
    font-size: 16px;
    font-weight: bolder;
    padding: 10px 0px 10px 0px;
}
//-->
</style>
</head>
<body>
<%!
static CacheAccessable c = CacheFactory.getInstance("topClickAndTime");

Map<String, Integer> topClick=new HashMap<String, Integer>();

static CacheObject<ArrayList<Entry<String, Integer>>> top100Click = null;
static CacheObject<ArrayList<String>> top100Time = null;

static CacheObject<Long> timeStamp = null;
static{
    if(c.isExist("refreshTime")){
        top100Click = c.getObject("top100Click");
        top100Time = c.getObject("top100Time");
        timeStamp = c.getObject("refreshTime");
    }
    else{
        top100Click = c.createObject("top100Click");
        top100Time = c.createObject("top100Time");
        timeStamp = c.createObject("refreshTime");
    }
}


List<String[]> readFile(File file) throws Exception{
	return FileUtils.readLines(file);
}

void url2Number(List<Object[]> logs){
    for(Object[] log : logs){
        String url = (String)log[4];
        
        Integer pv = Strings.escapeNULL(topClick.get(url), 0);
        topClick.put(url, pv + 1);
    }
}

void readF() throws Exception {
    String path = SystemEnvironment.getApplicationFolder() + File.separator + "logs";
    File[] files = new File(path).listFiles(new FilenameFilter(){
        public boolean accept(File dir, String name){
            return name.contains("capability");
        }
    });
    
    ArrayList<String> totalLogs=new ArrayList<String>();
    String url=null;
    for(File f : files){
        List<String> lines = FileUtils.readLines(f);
        for(String line:lines){
        	url=line.split("[,]")[4];
            Integer pv = Strings.escapeNULL(topClick.get(url), 0);
            topClick.put(url, pv + 1);
        }

        //合并多个文件的top
        
        Collections.sort(lines, new Comparator<String>() {
            public int compare(String arg0, String arg1) {
            	int time0=Integer.parseInt(arg0.split("[,]")[5]);
            	int time1=Integer.parseInt(arg1.split("[,]")[5]);
                return time1-time0;
            }
        });
        
        //取前一百保留
        totalLogs.addAll(lines.subList(0, Math.min(lines.size(), 100)));
        
    }

    Collections.sort(totalLogs, new Comparator<String>() {
        public int compare(String arg0, String arg1) {
        	int time0=Integer.parseInt(arg0.split("[,]")[5]);
        	int time1=Integer.parseInt(arg1.split("[,]")[5]);
            return time1-time0;
        }
    });
    
    
    List<Entry<String, Integer>> topClickList=new ArrayList<Entry<String, Integer>>(topClick.entrySet());

    Collections.sort(topClickList, new Comparator<Entry<String, Integer>>() {
        public int compare(Entry<String, Integer> arg0, Entry<String, Integer> arg1) {
            return arg1.getValue()-arg0.getValue();
        }
    });
    top100Time.set(new ArrayList(totalLogs.subList(0, Math.min(totalLogs.size(), 100))));
    top100Click.set(new ArrayList(topClickList.subList(0, Math.min(topClickList.size(), 100))));
}


%>
<%
synchronized(timeStamp){
    Long lastTimeStamp = timeStamp.get();
    if(lastTimeStamp == null || System.currentTimeMillis() - lastTimeStamp >= 30 * 60 * 1000){
        topClick.clear();
        readF();
        timeStamp.set(System.currentTimeMillis());
    }    

}

%>


<table>
    <tr>
    <td>行号</td><td>点击数</td><td>controller</td><td>耗时排行</td>
    </tr>
    <%
     ArrayList<Entry<String, Integer>> click = top100Click.get();
     ArrayList<String> time = top100Time.get();
    
    for(int i=0; i<top100Click.get().size(); i++){ %>
    <tr>
    <td><%= i+1 %></td>
    <td><%= click.get(i).getValue() %></td>
    <td><%= click.get(i).getKey() %></td>
    <td><%= time.get(i) %></td>
    </tr>
    <%} %>
</table>

</body>
</html>