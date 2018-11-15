
<%@ page language="java" contentType="text/plain; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%
String endTime=request.getParameter("endTime");
if(endTime!=null){
    String addC="alter table wf_process_running add (colcdate timestamp);\r\n"
            +"alter table WF_CASE_HISTORY add (colcdate timestamp);\r\n"
                    +"alter table WF_CASE_RUN add (colcdate timestamp);\r\n"
                            +"alter table WF_WORKITEM_HISTORY add (colcdate timestamp);\r\n"
                                    +"alter table WF_WORKITEM_RUN add (colcdate timestamp);\r\n"
                                            +"alter table CTP_AFFAIR add (colcdate timestamp);\r\n"
                                                   // +"alter table CTP_CONTENT_ALL add (colcdate timestamp);\r\n"
                                                            +"alter table CTP_COMMENT_ALL add (colcdate timestamp);\r\n";
    
    String dropC="alter table wf_process_running drop (colcdate);\r\n"
            +"alter table WF_CASE_HISTORY drop (colcdate);\r\n"
            +"alter table WF_CASE_RUN drop (colcdate);\r\n"
            +"alter table WF_WORKITEM_HISTORY drop (colcdate);\r\n"
            +"alter table WF_WORKITEM_RUN drop (colcdate);\r\n"
            +"alter table CTP_AFFAIR drop (colcdate);\r\n"
            //+"alter table CTP_CONTENT_ALL drop (colcdate);\r\n"
            +"alter table CTP_COMMENT_ALL drop (colcdate);\r\n";
    
    
String updateSql="  UPDATE wf_process_running a "
+"SET a.colcdate = (SELECT b.create_date FROM col_summary b WHERE a.id = b.process_id and b.create_date<to_date('"+endTime+"','yyyy-mm-dd') and rownum<2) "
+"WHERE EXISTS (SELECT b.create_date FROM col_summary b WHERE  a.id = b.process_id and b.create_date<to_date('"+endTime+"','yyyy-mm-dd')); \r\n"
+"UPDATE WF_CASE_HISTORY a "
+"SET a.colcdate = (SELECT b.create_date FROM col_summary b WHERE a.PROCESSID  = b.process_id and b.create_date<to_date('"+endTime+"','yyyy-mm-dd') and rownum<2) "
+"WHERE EXISTS (SELECT b.create_date FROM col_summary b WHERE  a.PROCESSID  = b.process_id and b.create_date<to_date('"+endTime+"','yyyy-mm-dd')); \r\n"
+"UPDATE WF_CASE_RUN a "
+"SET a.colcdate = (SELECT b.create_date FROM col_summary b WHERE a.PROCESSID  = b.process_id and b.create_date<to_date('"+endTime+"','yyyy-mm-dd') and rownum<2) "
+"WHERE EXISTS (SELECT b.create_date FROM col_summary b WHERE  a.PROCESSID  = b.process_id and b.create_date<to_date('"+endTime+"','yyyy-mm-dd')); \r\n"
+"UPDATE WF_WORKITEM_HISTORY a "
+"SET a.colcdate = (SELECT b.create_date FROM col_summary b WHERE a.PROCESSID  = b.process_id and b.create_date<to_date('"+endTime+"','yyyy-mm-dd') and rownum<2) "
+"WHERE EXISTS (SELECT b.create_date FROM col_summary b WHERE  a.PROCESSID  = b.process_id and b.create_date<to_date('"+endTime+"','yyyy-mm-dd')); \r\n"
+"UPDATE WF_WORKITEM_RUN a "
+"SET a.colcdate = (SELECT b.create_date FROM col_summary b WHERE a.PROCESSID  = b.process_id and b.create_date<to_date('"+endTime+"','yyyy-mm-dd') and rownum<2) "
+"WHERE EXISTS (SELECT b.create_date FROM col_summary b WHERE  a.PROCESSID  = b.process_id and b.create_date<to_date('"+endTime+"','yyyy-mm-dd')); \r\n"
+"UPDATE CTP_AFFAIR a "
+"SET a.colcdate = (SELECT b.create_date FROM col_summary b WHERE a.object_id = b.id and b.create_date<to_date('"+endTime+"','yyyy-mm-dd')) "
+"WHERE EXISTS (SELECT b.create_date FROM col_summary b WHERE  a.object_id = b.id and b.create_date<to_date('"+endTime+"','yyyy-mm-dd')); \r\n"
//+"UPDATE CTP_CONTENT_ALL a "
//+"SET a.colcdate = (SELECT b.create_date FROM col_summary b WHERE a.module_id = b.id and b.create_date<to_date('"+endTime+"','yyyy-mm-dd')) "
//+"WHERE EXISTS (SELECT b.create_date FROM col_summary b WHERE  a.module_id = b.id and b.create_date<to_date('"+endTime+"','yyyy-mm-dd')); \r\n"
+"UPDATE CTP_COMMENT_ALL a "
+"SET a.colcdate = (SELECT b.create_date FROM col_summary b WHERE a.module_id = b.id and b.create_date<to_date('"+endTime+"','yyyy-mm-dd')) "
+"WHERE EXISTS (SELECT b.create_date FROM col_summary b WHERE  a.module_id = b.id and b.create_date<to_date('"+endTime+"','yyyy-mm-dd')); \r\n";
//+" create DIRECTORY  seeyondbp as 'c:\\seeyondbp'; \r\n";

String deleteSql=" delete from wf_process_running where colcdate>to_date('1970-01-01','yyyy-mm-dd') and colcdate<to_date('"+endTime+"','yyyy-mm-dd');\r\n"
+" delete from WF_CASE_HISTORY where colcdate>to_date('1970-01-01','yyyy-mm-dd') and colcdate<to_date('"+endTime+"','yyyy-mm-dd');\r\n"
+" delete from WF_CASE_RUN where colcdate>to_date('1970-01-01','yyyy-mm-dd') and colcdate<to_date('"+endTime+"','yyyy-mm-dd');\r\n"
+" delete from WF_WORKITEM_HISTORY where colcdate>to_date('1970-01-01','yyyy-mm-dd') and colcdate<to_date('"+endTime+"','yyyy-mm-dd');\r\n"
+" delete from WF_WORKITEM_RUN where colcdate>to_date('1970-01-01','yyyy-mm-dd') and colcdate<to_date('"+endTime+"','yyyy-mm-dd');\r\n"
+" delete from CTP_AFFAIR where colcdate>to_date('1970-01-01','yyyy-mm-dd') and colcdate<to_date('"+endTime+"','yyyy-mm-dd');\r\n"
//+" delete from CTP_CONTENT_ALL where colcdate>to_date('1970-01-01','yyyy-mm-dd') and colcdate<to_date('"+endTime+"','yyyy-mm-dd');\r\n"
+" delete from CTP_COMMENT_ALL where colcdate>to_date('1970-01-01','yyyy-mm-dd') and colcdate<to_date('"+endTime+"','yyyy-mm-dd');\r\n"
+" delete from col_summary where create_date<to_date('"+endTime+"','yyyy-mm-dd');\r\n";

//expdp -->exp "expdp v3x/v3x directory=seeyondbp  dumpfile=col_summary"+endTime+".dmp tables=col_summary query=\" where create_date<to_date('"+endTime+"','yyyy-mm-dd')\" \r\n"
String shellExp="exp v3x/v3x file=col_summary"+endTime+".dmp tables=col_summary query=\\\" where create_date<to_date('"+endTime+"','yyyy-mm-dd')\\\" \r\n"
+"exp v3x/v3x file=wf_process_running"+endTime+".dmp tables=wf_process_running query=\\\" where colcdate>to_date('1970-01-01','yyyy-mm-dd') and colcdate<to_date('"+endTime+"','yyyy-mm-dd')\\\" \r\n"
+"exp v3x/v3x file=WF_CASE_HISTORY"+endTime+".dmp tables=WF_CASE_HISTORY query=\\\" where colcdate>to_date('1970-01-01','yyyy-mm-dd') and colcdate<to_date('"+endTime+"','yyyy-mm-dd')\\\" \r\n"
+"exp v3x/v3x file=WF_CASE_RUN"+endTime+".dmp tables=WF_CASE_RUN query=\\\" where colcdate>to_date('1970-01-01','yyyy-mm-dd') and colcdate<to_date('"+endTime+"','yyyy-mm-dd')\\\" \r\n"
+"exp v3x/v3x file=WF_WORKITEM_HISTORY"+endTime+".dmp tables=WF_WORKITEM_HISTORY query=\\\" where colcdate>to_date('1970-01-01','yyyy-mm-dd') and colcdate<to_date('"+endTime+"','yyyy-mm-dd')\\\" \r\n"
+"exp v3x/v3x file=WF_WORKITEM_RUN"+endTime+".dmp tables=WF_WORKITEM_RUN query=\\\" where colcdate>to_date('1970-01-01','yyyy-mm-dd') and colcdate<to_date('"+endTime+"','yyyy-mm-dd')\\\" \r\n"
+"exp v3x/v3x file=CTP_AFFAIR"+endTime+".dmp tables=CTP_AFFAIR query=\\\" where colcdate>to_date('1970-01-01','yyyy-mm-dd') and colcdate<to_date('"+endTime+"','yyyy-mm-dd')\\\" \r\n"
//+"exp v3x/v3x file=CTP_CONTENT_ALL"+endTime+".dmp tables=CTP_CONTENT_ALL query=\\\" where colcdate>to_date('1970-01-01','yyyy-mm-dd') and colcdate<to_date('"+endTime+"','yyyy-mm-dd')\\\" \r\n"
+"exp v3x/v3x file=CTP_COMMENT_ALL"+endTime+".dmp tables=CTP_COMMENT_ALL query=\\\" where colcdate>to_date('1970-01-01','yyyy-mm-dd') and colcdate<to_date('"+endTime+"','yyyy-mm-dd')\\\" \r\n";

String sqlCd=" create DIRECTORY  seeyondbp as 'c:\\seeyondbp'; \r\n";
//"imp v3x/v3x directory=seeyondbp  dumpfile=col_summary"+endTime+".dmp\r\n "

String shellImp="imp v3x/v3x file=col_summary"+endTime+".dmp  full=y\r\n "
+"imp v3x/v3x file=wf_process_running"+endTime+".dmp  full=y\r\n "
+"imp v3x/v3x file=WF_CASE_HISTORY"+endTime+".dmp  full=y\r\n "
+"imp v3x/v3x file=WF_CASE_RUN"+endTime+".dmp  full=y\r\n "
+"imp v3x/v3x file=WF_WORKITEM_HISTORY"+endTime+".dmp  full=y\r\n "
+"imp v3x/v3x file=WF_WORKITEM_RUN"+endTime+".dmp  full=y\r\n "
+"imp v3x/v3x file=CTP_AFFAIR"+endTime+".dmp  full=y\r\n "
//+"imp v3x/v3x file=CTP_CONTENT_ALL"+endTime+".dmp  full=y\r\n "
+"imp v3x/v3x file=CTP_COMMENT_ALL"+endTime+".dmp  full=y\r\n ";

    response.setHeader("Content-disposition", "attachment;filename=dataseparatorscript.txt");
    response.setContentType("text/plain;charset=UTF-8");
    BufferedWriter outp = new BufferedWriter(new OutputStreamWriter(response.getOutputStream()));
    outp.write("1、标记需要导出的数据，请执行下面sql:");
    outp.newLine();
    outp.write(addC);
    outp.newLine();
    outp.write(updateSql);
    outp.newLine();
    outp.write("2、从在线库中导出已标记的数据，请在oracle服务器控制台中执行下面脚本：");
    outp.newLine();
    outp.write(shellExp);
    outp.newLine();
    outp.write("3、请从生产库中拷贝生成的文件至离线库中，拷贝完成后在离线库服务器控制台中执行下面脚本");
/*     outp.newLine();
    //outp.write(sqlCd);
    outp.newLine();
    outp.write("4、在离线库服务器控制台中执行下面脚本"); */
    outp.newLine();
    outp.write(shellImp);
    outp.newLine();
    outp.write("4、删除已标记的数据，请执行下面SQL");
    outp.newLine();
    outp.write(deleteSql);
    outp.newLine();
    outp.write(dropC);
    
    outp.flush();   
    outp.close();
    outp = null;
    out.clear();
    out = pageContext.pushBody();

}
%>