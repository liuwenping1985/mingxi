<%@page import="com.seeyon.ctp.util.Strings"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,java.io.*,com.seeyon.ctp.common.cache.*,com.seeyon.ctp.util.*,org.apache.commons.beanutils.BeanUtils
" %>
<%@ page import="java.util.*,java.io.*,com.seeyon.ctp.common.cache.*,com.seeyon.ctp.organization.manager.*,com.seeyon.ctp.organization.bo.*,com.seeyon.ctp.login.online.*,com.seeyon.ctp.common.*,org.apache.commons.beanutils.BeanUtils,com.thoughtworks.xstream.XStream,com.thoughtworks.xstream.io.json.*
,com.thoughtworks.xstream.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%
if(session.getAttribute("GoodLuckA8") != null){

}
else{
    response.sendError(404);
    return;
}
%>

<html>
    <head><title>Cluster Cache Dump</title>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <style type="text/css">
    table{
        border-width: 1px;
        border-spacing: ;
        border-style: solid;
        border-color: gray;
        border-collapse: collapse;
        background-color: white;
    }
    table tr {
        border-width: 1px;
        padding: 2px;
        border-style: inset;
        border-color: gray;
        background-color: white;
        -moz-border-radius: ;
    }
    table td,table th{
        border-width: 1px;
        padding: 4px;
        border-style: inset;
        border-color: gray;
        background-color: white;
        -moz-border-radius: ;
        font-size:11pt;
    }

    </style>
    </head>
<body>
            
<%!
    Object writeNumber(int v){
        if(v == 0){
            return ""; 
        }
        return v;
    }
    String dumpAll() throws Exception {
        StringBuffer sb = new StringBuffer();
        String[] groupNames = CacheFactory.getGroups();
        for (String g : groupNames) {
            CacheFactory factory = (CacheFactory) CacheFactory.getInstance(g);
            String[] cacheNames = factory.getCacheNames();
            for (String cacheName : cacheNames) {
                final GroupCacheable cache = factory.lookup(cacheName);
                sb.append(dump(cache));
//                if(cache instanceof CacheMap){
//                    sb.append(dumpMap((CacheMap) cache));
//                }
            }
        }
        return sb.toString();
    }

    String dumpMap(CacheMap map) {
        StringBuffer sb = new StringBuffer();
        Map m = map.toMap();
        //Set keyset = m.keySet();
        Set<Map.Entry> es = m.entrySet();
        for (Map.Entry entry : es) {
            sb.append(entry.getKey());
            sb.append(entry.getValue());
        }
        return sb.toString();

    }

    String dump(Object o) throws Exception {
        if(o == null){
            return "<NULL>";
        }
        if(o instanceof String 
                || o instanceof Date 
                || o instanceof Long 
                || o instanceof Number
                || o instanceof Integer 
                || o instanceof Byte 
                || o instanceof Float 
                || o instanceof Boolean
                || o instanceof Collection
                || o instanceof Map
                ){
            return o.toString();
        }
        return com.seeyon.ctp.util.json.JSONUtil.toJSONString(o);
        // return BeanUtils.describe(o).toString();
        /*
        Map tem = BeanUtils.describe(o);
        StringBuilder sb = new StringBuilder();
        sb.append(o.getClass().getCanonicalName()).append("{<br>");
        for(java.util.Iterator<Map.Entry> iterator = tem.entrySet().iterator(); iterator.hasNext();){
            Map.Entry entry = iterator.next();
            if("class".equals(entry.getKey())){
                continue;
            }
            sb.append("&nbsp;&nbsp;&nbsp;&nbsp;").append(entry.getKey()).append("=").append(com.seeyon.v3x.util.Strings.toHTML(String.valueOf(entry.getValue()))).append("<br>");
        }
        sb.append("}");
        return sb.toString();
        */
    }
%>
<%
    String q = request.getParameter("q");
    String g = request.getParameter("g");
    String c = request.getParameter("c");
    String k = request.getParameter("k");
    g = g==null?"":g;
    c = c==null?"":c;
    k = k==null?"":k;
    CacheFactory factory = (CacheFactory)CacheFactory.getInstance(g);
    String[] groupNames = CacheFactory.getGroups();
          out.write("\t<a href=\"cacheDump.do\">Home</a> - ");
      out.print(g);
      out.write(' ');
      out.write('-');
      out.write(' ');
      out.print(c);
      out.write("<br/>\r\n");

      boolean reset = "resetStat".equals(q);
%>
<div><a href="?q=resetStat">重置统计</a></div>
    Group:<br/><select id="gSelect" name="g" value="<%=g%>" onchange="location.href='cacheDump.do?g='+this.value;">

    <% for(int i = 0;i<groupNames.length;i++){
        String v = groupNames[i];
    %>
    <option value="<%=v%>"><%=v%></option>
    <% }%></select><br/>
<%if(g.length()!=0){%>
    <script>
        document.getElementById('gSelect').value='<%=g%>';
    </script>
    <br/>
    <%
        String[] cacheNames = factory.getCacheNames();
    %>
        CacheName:<br/>
        <select id="cSelect" name="c" onclick="location.href='cacheDump.do?g=<%=g%>&c='+this.value;//document.getElementById('form').submit()">
            <% for(int i=0;i<cacheNames.length;i++){%>
                <option value="<%=cacheNames[i]%>"><%=cacheNames[i]%></option>  
            <%}%>
        </select>
        <script>
            document.getElementById('cSelect').value='<%=c%>';
        </script>       
    <!--<b>Search:</b><br/>-->
    <form id="form" action="cacheDump.do" method="POST" style="display:none">
        <!--Group:<br/>-->
        <input type="hidden" name="g" value="<%=g%>" size="100"/><br/>
        CacheName:<br/>
        <select id="cSelect1" name="c1" onchange="location.href='cacheDump.do?g=<%=g%>&c='+this.value;//document.getElementById('form').submit()">
            <% for(int i=0;i<cacheNames.length;i++){%>
                <option value="<%=cacheNames[i]%>"><%=cacheNames[i]%></option>  
            <%}%>
        </select>
        <script>
            document.getElementById('cSelect').value='<%=c%>';
        </script>   
        <br/>
        <!--Key:<br/>--><input type="hidden" name="k" value="<%=k%>" size="100"/><br/>
        <!--<input type="submit"/>-->
    </form><br/>
    <%if(c.length()!=0){%>
        <%
            GroupCacheable cache = CacheFactory.getInstance(g).lookup(c);
            int size =cache.size();
        %>
        <b>Content:</b><br/>
        <%out.println(dump(cache));%><br/>
        <b>Items:</b><%=size%><br/>
        <b><%=g%>::<%=c%></b><br/>      
        
        <%if(cache instanceof CacheMap){%>
            <%
              CacheMap map = (CacheMap)cache;
              String s = dump(map);
                out.println(s);
                if(k.length()!=0)
                    out.println(dump(map.get(k)));
                Map m = map.toMap();
                //Set keyset = m.keySet();
                Set<Map.Entry> es = m.entrySet();
                
            %>  
            <br/>
            <table border="1">

                <% for(Map.Entry e:es){%>
                    <tr>
                            <td>
                                <a href="cacheDump.do?g=<%=g%>&c=<%=c%>&k=<%=e.getKey()%>"><%=e.getKey()%></a><br/>
                            </td>
                            <td>
                                 <c:out value="<%=dump(map.get((Serializable)e.getKey()))%>"/>
                            </td>
                    </tr>               
                <%}%>               
        </table>
        <%}%>       
        
    
    
        <% if(cache instanceof CacheObject){%>
        <%
          CacheObject o = (CacheObject)cache;
            out.println(dump(o.get()));
        %>  
        <%}%>
        
            
    <%}%>       
<%}%>
<%
if(g.length()==0&&c.length()==0){
%>
<%
int index =1;
%>
<table>
<tr>
<th>序号</th>
<th>名称</th>
<th>类型</th>
<th>大小</th>

<th>值集合大小</th>

<th>读取</th>
<th>更新</th>
<th>删除</th>
<th>清除</th>
<th>脱靶</th>
<th>创建时间</th>
<th>最后更新时间</th>
<th>分组</th>
<th>值类型</th>
</tr>
<%      
 for(int i = 0;i<groupNames.length;i++){
        String v = groupNames[i];
        CacheFactory cf = (CacheFactory)CacheFactory.getInstance(v);
        String[] cNames = cf.getCacheNames();
        int cacheCount = cNames.length;
%>


<%    
 for(int j=0;j<cacheCount;j++){
      String cn = cNames[j];
      String color = "black";
      String type = "Object";
      String stat  = "";
      String valueType = "";
      GroupCacheable cache = CacheFactory.getInstance(v).lookup(cn);
      boolean isCollection = false;
      int citemSize = 0;
      CacheStatistics cs = cache.getStatistics();
      if(reset){
        cs.resetStatistics();
      }
      if(cache instanceof CacheMap){
        CacheMap map = (CacheMap)cache;

        type = "Map";
        Collection values = map.values();
        boolean st = false;
        boolean sh = false;

        for(Object item : values){
            if(item instanceof Collection){
                isCollection = true;
                Collection citem = (Collection)item;
                citemSize = citemSize > citem.size() ? citemSize : citem.size();
                if(citemSize>1000){
                    st = true;
                }
                if(citemSize>100){
                    sh = true;
                }                
            }
            valueType = item==null?"": item.getClass().getName();
        }
            if(valueType.length()>0){
                valueType = valueType.substring(valueType.lastIndexOf(".")+1);
            }

        if(isCollection){
            //type +="C";
            color = "orange";
        }

        if(st){
            //type +="t";
            color = "red";
        }else if(sh){
            //type +="h";
            color = "orangered";
        }
      }else if(cache instanceof CacheSet){
        type = "Set";
      }


 %>
 
 <tr>
     <td><%=index++%></td>
     <td>

<a href="cacheDump.do?g=<%=v%>&c=<%=cn%>"><%=cn%> </a></td>
<td><span style="color:<%=color%>"><%=type%></span></td>
<td><%=writeNumber(cache.size())%></td>
<td><%=writeNumber(citemSize)%></td>

<td style="color:green"><%=writeNumber(cs.getReadCount())%></td>
<td style="color:blue"> <%=writeNumber(cs.getWriteCount())%></td>
<td style="color:red"><%=writeNumber(cs.getDeleteCount())%></td>
<td style="color:darkred"><%=writeNumber(cs.getClearCount())%></td>
<td><%=writeNumber(cs.getMisses())%></td>
<td><%=DateUtil.formatDateTime(new Date(cs.getCreated())).substring(5)%></td>
<td><%=DateUtil.formatDateTime(new Date(cs.getLastUpdated())).substring(5)%></td>

            <td><%=v%></td>
  <td><%=valueType%></td>            
</tr>
 <%
}
 %>

 <%
}
 %>
</table>
<%
}
      out.write("\r\n");
      out.write("\t<a href=\"cacheDump.do?q=dumpAll\">Dump All</a><br/>\r\n");

%>
<%if("dumpAll".equals(q)){%>
<c:out value="<%=dumpAll()%>"/>
<%}%>
<%if("groovy".equals(q)){%>
<%
    String [][] arr = {
        //{"在线用户","onlineManager","getOnlineList"},
        {"在线用户总数","onlineManager","getOnlineNumber"},
        {"新闻类型","newsTypeManager","getAllNewsTypes"},
        {"新闻类型","newsTypeManager","getAclMap","com.seeyon.v3x.news.util.Constants.NewsTypeAclType.manager"},
        {"新闻类型","newsTypeManager","getAclMap","com.seeyon.v3x.news.util.Constants.NewsTypeAclType.audit"},
        {"新闻类型","newsTypeManager","getAclMap","com.seeyon.v3x.news.util.Constants.NewsTypeAclType.writer"},     
        {"调查类型","inquiryManager","getAllInquiryTypes"}, 
        {"调查","inquiryManager","getLockInfo4Dump"}, 
        {"公告类型","bulTypeManager","getAllBulletinTypes"},
        {"公告类型","bulTypeManager","getAclMap","com.seeyon.v3x.bulletin.util.Constants.BulTypeAclType.manager"},      
        {"公告类型","bulTypeManager","getAclMap","com.seeyon.v3x.bulletin.util.Constants.BulTypeAclType.audit"},    
        {"公告类型","bulTypeManager","getAclMap","com.seeyon.v3x.bulletin.util.Constants.BulTypeAclType.writer"},           
    };

%>





<%!

    public Object eval(String beanName,String func,String param) throws Exception{
        String p  = param==null ? "":param;
        String script = "com.seeyon.ctp.common.AppContext.getBean(\""+beanName+"\")" ;
        //System.out.println(func);
        if(func!=null && !"".equals(func)){
        script += "." + func + "(" + p + ")" ;
        }else{
            return com.seeyon.ctp.common.AppContext.getBean(beanName);
        }
        //System.out.println( script);
        Object o = com.seeyon.ctp.common.script.ScriptEvaluator.getInstance().eval(script,new java.util.HashMap());
        String s = "";
        if(o!=null){
            s=o.getClass().getName();
            if(o instanceof Collection){
                Collection map = (Collection) o;
                s=s+" : " + map.size() ;
            }
        }
        return s+"\n"+toJSON(o);
    }
    public String toJSON(Object o){
        XStream xstream = new XStream(new JsonHierarchicalStreamDriver() {
            public HierarchicalStreamWriter createWriter(Writer writer) {
                return new JsonWriter(writer, JsonWriter.DROP_ROOT_MODE);
            }

        });
        xstream.aliasSystemAttribute(null, "class");
        //xstream.aliasSystemAttribute(null, "defined-in");
        
        return xstream.toXML(o);
    }

    public Map getAllOnlineUser() throws Exception{
        Map m = new HashMap();
        OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
        List<V3xOrgAccount> accounts = orgManager.getAllAccounts();
        for(V3xOrgAccount acc:accounts){
            m.putAll(OnlineRecorder.getAllOnlineUser(acc.getId()));
        }
        return m;
    }

%>

<table>
<%
    for(int i = 0;i<arr.length ;i++){
        String b = arr[i][1];
        String m = arr[i][2];
        String p = "";
        if(arr[i].length>3){
            p = arr[i][3];
        }
        String d = arr[i][0];

%>
    <tr>
        <td><%=b%></td>
        <td><a href="?q=groovy&b=<%=b%>&m=<%=m%>&p=<%=p%>"><%=m%>(<%=p%>)</a></td>
        <td><%=d%></td>
    </tr>
<%
    }
%>
    <tr>
        <td>OnlineRecord</td>
        <td><a href="?q=groovy&b=onlineRecord&m=getAllOnlineUsers&p=none">OnlineRecord.getAllOnlineUsers</a></td>
        <td>在线用户</td>
    </tr>
</table>
<%
    String beanName = request.getParameter("b");
    String methodName = request.getParameter("m");
    String param = request.getParameter("p");
%>
<form>
    <input type="hidden" name="q" value="groovy"/>
    Bean:<input name="b" value="<%=beanName%>" size="80"/>
    方法：<input name="m" value="<%=methodName%>"/>
    参数：<input name="p" value="<%=param%>" size="80"/>
    <input type="submit" value="查看"/>
</form>
<%  
    if(beanName!=null && methodName!=null){
%>
<textarea rows="36" cols="160">
<%

    if("onlineRecord".equals(beanName)){
        Map all = getAllOnlineUser();
        out.println(all.size());
        out.println(toJSON(all));
    }else{

        if(methodName.startsWith("get")||methodName.equals("")){
            out.println(eval(beanName,methodName,param));
        }else{
            out.println("只能执行名称为getXXX的方法。");
        }
    }

%>
</textarea>

<%}%>
<%}%>
</body>
</html>