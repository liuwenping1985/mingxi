package cn.com.cinda.taskcenter.util;

import java.io.IOException;
import java.io.PrintWriter;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;


import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import cn.com.cinda.taskcenter.dao.QueryTodolistNew;

public class CountTodoByGroup extends HttpServlet{

	private static final String CONTENT_TYPE = "text/html; charset=GB18030"; 

//	Initialize global variables 
	public void init() throws ServletException { 
	}
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//HttpServletResponse httpResponse = (HttpServletResponse) response;
		response.addHeader("P3P", "CP=CAO PSA OUR");
		response.setHeader("Pragma", "No-cache"); // HTTP 1.1
		response.setHeader("Cache-Control", "no-cache"); // HTTP 1.0
		response.setHeader("Expires", "0"); // proxy no cache
		//response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=GBK");
		PrintWriter out = response.getWriter(); 
		try {
			String userId=((HttpServletRequest) request).getUserPrincipal().getName();
//			String userId="jsbzyp";
			QueryTodolistNew todolist=new QueryTodolistNew();
			HashMap result=todolist.getCountByGrours(userId);
			 int i=0;
		        if(result.size()>0)
		        {
		                Set  entries = result.entrySet(); 
		                Iterator iter = entries.iterator(); 
		                while(iter.hasNext())
		                {
		                i++;
		                Map.Entry entry = (Map.Entry)iter.next(); 
		                Object key = entry.getKey();
		                String value=(String)entry.getValue();
		                String content=key.toString()+"("+value+")";
		                System.out.println(content);
		                out.println("<li style=\"margin-left:0px;height:10px;padding-top:0px;padding-bottom:2px\"><a href=\"#\" style=\"font-size:12px;\" onclick=\"openUrl()\">&nbsp;&nbsp;&nbsp"+content+"</a></li>");
		                
		                
		                }
		        }
		 out.close();
		} catch (Exception iox) {
			
			iox.printStackTrace();
		}
	}

	public void doPost() 
			{}

}
