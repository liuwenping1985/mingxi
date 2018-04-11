<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="com.seeyon.apps.cip.base.enums.LogApplicationEnum" %>
<%-- <%@page import="com.seeyon.apps.cip.base.enums.LogActionEnum" %> --%>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>

<%
LogApplicationEnum[] apps = LogApplicationEnum.values();
request.setAttribute("logApplicationEnumList", apps);
/* LogActionEnum[] acs = LogActionEnum.values();
request.setAttribute("logActionEnumList", acs); */

%>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript">

function createOption(value, text) {
	var option = document.createElement("option");
	option.value = value;
	option.text = text;	
	return option;
}


function initLogApplication(){
    var logApplication = document.getElementById("logApplication");
    $("#logApplication").empty();
    <c:forEach items="${logApplicationEnumList}" var="data">
      var item = createOption("${data.value}", "${data.text}");
      logApplication.add(item);
      if("${data.value}"== "${logDetail.logApplication}"){
       	item.selected=true;
      }
	</c:forEach>
}

/* function initLogAction(){
    var logAction = document.getElementById("logAction");
    $("#logAction").empty();
    <c:forEach items="${logActionEnumList}" var="data">
      var item = createOption("${data.value}", "${data.text}");
      logAction.add(item);
      if("${data.value}"== "${logDetail.logAction}"){
       	item.selected=true;
      }
	</c:forEach>
} */

function getDate(strDate) { 
	
  var st = strDate; 
  var a = st.split(" "); 
  var b = a[0].split("-"); 
  var c = a[1].split(":"); 
  var date = b[0]+"-"+b[1]+"-"+b[2]+" "+c[0]+":"+c[1]; 
  return date; 
} 

$().ready(function() {
	var c = "${logDetail.createDate}";
	if(c!=null && c != ''&& typeof c != 'undefined'){
		var date = getDate(c);
		//var fromDate=date.format("yyyy-MM-dd HH:mm");
		$("#createDate").val(date);//开始时间：默认显示当前时间
	}
	
	
	
	initLogApplication();
	/* initLogAction(); */
});

</script>

</head>

 
 <div class="form_area" >
     <div class="one_row" style="width:70%;">
     <br>
         <table border="0" cellspacing="0" cellpadding="0">
            <tbody>
           
           
            
            <tr>
                <th nowrap="nowrap"><label class="margin_r_10" for="text"><fmt:message key="cip.base.form.logMonitor.log_application"/>:</label></th>
                <td width="100%">
				<div class="common_selectbox_wrap">
                        <select  readonly="readonly" disabled="disabled" id = "logApplication" name="logApplication"  class="w100b validate" ></select>
						</div>
                </td>
            </tr>
            
            <tr>
                <th nowrap="nowrap"><label class="margin_r_10" for="text"><fmt:message key="cip.base.form.logMonitor.log_action"/>:</label></th>
                <td width="100%">
				<div class="common_txtbox_wrap">   
                         <input type="text"  readonly="readonly" disabled="disabled" id="logAction" name="logAction" value="${logDetail.logAction}"  class="w100b" >
				</div>
                </td>
            </tr>
            
            <tr>
                <th nowrap="nowrap" ><label class="margin_r_10" for="text"><fmt:message key="cip.base.form.logMonitor.log_detail"/>:</label></th>
                <td width="100%">
					<div class="common_txtbox  clearfix">
                     <textarea type="text"  readonly="readonly" cols="19" rows="7" disabled="disabled"
                      id= "logDetail" name="logDetail"  class="w100b" >${logDetail.logDetail}</textarea>
					</div>
				<td>
            </tr> 
            
            <tr>
                <th nowrap="nowrap" ><label class="margin_r_10" for="text"><fmt:message key="cip.base.form.logMonitor.member_id"/>:</label></th>
                <td width="100%">
                  <div class="common_txtbox_wrap">
                     <input type="text"  readonly="readonly" disabled="disabled" id="memberName" name="memberName" value="${logDetail.memberName}"  class="w100b" >
                 </div>
				<td>
            </tr> 
            
            <tr>
                <th nowrap="nowrap" ><label class="margin_r_10" for="text"><fmt:message key="cip.base.form.logMonitor.create_date"/>:</label></th>
                <td width="100%">
                  <div class="common_txtbox clearfix">
                     <input type="text"  readonly="readonly" disabled="disabled"  id="createDate" name="createDate"   class="w100b" >
                 </div>
				<td>
            </tr>         
            
           
            
            
            
   			</tbody>
   		</table>
    </div>
    <div class="align_center">
        <input type="hidden" id="id" name="id" size="70" value="${logDetail.id}"/>   
        <input type="hidden" id="memberId" name="memberId" size="70" value="${logDetail.memberId}"/>   
          
    </div>
</div>
 
</html>
