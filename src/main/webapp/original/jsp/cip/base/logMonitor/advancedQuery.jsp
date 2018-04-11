<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.seeyon.apps.cip.base.enums.LogApplicationEnum" %>
<%-- <%@page import="com.seeyon.apps.cip.base.enums.LogActionEnum" %> --%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
 
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<%
LogApplicationEnum[] apps = LogApplicationEnum.values();
request.setAttribute("logApplicationEnumList", apps);
/* LogActionEnum[] acs = LogActionEnum.values();
request.setAttribute("logActionEnumList", acs); */
%>
<!DOCTYPE html>
<html>
   <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title></title>
    <head>
    
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
          
    	</c:forEach>
    }

  /*   function initLogAction(){
        var logAction = document.getElementById("logAction");
        $("#logAction").empty();
        <c:forEach items="${logActionEnumList}" var="data">
          var item = createOption("${data.value}", "${data.text}");
          logAction.add(item);
         
    	</c:forEach>
    } */
    
     $(document).ready(function () {
    	initLogApplication();
    	/* initLogAction(); */
    	$("#combinedQueryDIV").clearform();
    	var obj = window.parentDialogObj["queryDialog"].transParams;
    	if (!$.isEmptyObject(obj)) {
    		if (obj.memberId != "") {
    			$('#memberName').val(obj.memberId);
    		}
    		if (obj.logApplication != "") {
    			$('#logApplication').find("option[value='"+obj.logApplication+"']").attr("selected",true);
    		}
    		if (obj.logAction != "") {
    			/* $('#logAction').find("option[value='"+obj.logAction+"']").attr("selected",true); */
    			$('#logAction').val(obj.logAction);
    		}   		 
			if (obj.createDate !="" && "undefined" != typeof(obj.createDate)) {
    			var createDate = obj.createDate;
    			$('#from_createDate').val(createDate[0]);
    			$('#to_createDate').val(createDate[1]);
    		}
    	}
    	
    	if(_locale){
    		if(_locale == 'en'){
    			$("#query_table").css("margin-right","-60px");
    			$("#query_table").css("margin-left","-40px");
    		}
    	}
    	
    });
    
  	function OK(json) {
  		var o = new Object();
      	o.logApplication = $('#logApplication').val();
      	o.logAction = $('#logAction').val();
        o.memberId = $('#memberName').val();
        var from_createDate=$('#from_createDate').val();
        var to_createDate=$('#to_createDate').val();
        var date = [from_createDate,to_createDate];
        o.createDate=date;
        if(json.type==1){
        	if(from_createDate != "" && to_createDate != "" && from_createDate > to_createDate){
                $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
                return;
            }
        	return JSON.stringify(o);
        } if(json.type==2){//重置
            $("#combinedQueryDIV").clearform();
        }
    }
       
    </script>
    </head>
    
        <div class="form_area" id="combinedQueryDIV"  >
			<div class="one_row" style="width:70%;">
			<br>
            <form   name="addQuery" id="addQuery" method="post" class="align_center">
                 <table id="query_table" border="0" cellspacing="0" cellpadding="0" >                
                    <tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><fmt:message key="cip.base.form.logMonitor.log_application"/>:</label></th>
                        <td width="100%">
						<div class="common_selectbox_wrap">
                        	<select id="logApplication" name="logApplication"  class="w100b" >
                        	</select>
						</div>
                        </td>
                    </tr>
                    
                    
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><fmt:message key="cip.base.form.logMonitor.log_action"/>:</label></th>
                        <td width="100%">
						<div class="common_txtbox_wrap">
                         
                        	 <input  id="logAction"  type="text" name="logAction"  class="w100b" />
                        	 
                       </div>
                        </td>
                    </tr>
                    
                    <tr>
						<th nowrap="nowrap" ><label class="margin_r_10" for="text"><fmt:message key="cip.base.form.logMonitor.member_id"/>:</label></th>
						<td width="100%">
						<div class="common_txtbox_wrap">
                         <input  id="memberName"  type="text" name="memberName"  class="w100b" />
						</div>
						</td>
                    </tr>
                  
                    
                    <tr>
                        <th nowrap="nowrap" ><label class="margin_r_10" for="text"><fmt:message key="cip.base.form.logMonitor.create_date"/>:</label></th>
                        <td width="100%">
                            <input id="from_createDate" style="width: 134px;color: #333;" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,position:[120,10]"  >
                            <span class="padding_lr_5">-</span>
                            <input id="to_createDate" style="width: 134px;color: #333;" class="comp"  type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,position:[120,10]"  >
                        </td>
                    </tr>
                     
                      
                </table>
            </form>
        </div>
  
</html>