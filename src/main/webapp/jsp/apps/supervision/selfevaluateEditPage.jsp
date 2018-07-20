<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@page import= "java.text.SimpleDateFormat"%>
<%@page import= "java.util.Date"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma" contect="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<title>自评</title>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/supervision/css/supervisionEditPage.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" src="${path}/apps_res/supervision/js/supervisionPage.js"></script>
<style type="text/css">
	#field0103{
		width:350px;
	    box-sizing: border-box;
	    border:1px solid #D7D7D7;
	    border-radius:5px;
	}
</style>
</head>
<body>
<form id="subTableForm">
    <div class="xl-container xl-sel-container" style="padding-top:5px;">
    	<!-- xl 6-28 -->
        <p>
            <input id="field0127" name="field0127" type="hidden" value="${CurrentUser.id}"/>
        </p>
        <table class="xl-content-table">
        <colgroup>
            <col width="100px"/>
            <col width="90px"/>
            <col width="50px"/>
            <col width="120px"/>
             <col width="90px"/>
        </colgroup>
        <tbody>
		    <tr style="text-align:left;display:none;" id="errorTr">
		   		<td></td>
		   		<td colspan="4" id="errorMsg">
		   			<ul><li><img src="${path}/apps_res/supervision/img/error.png"></li></ul>
		   		</td>
		   	</tr>
	       <tr>
	           <td align="right" valign="top">
	               <div>
	                   	<label>评价内容：</label>
	               </div>
	           </td>
	           <td colspan="4">
	               <div>
	                    <textarea id="field0103" name="field0103" class="xl-selfeva-words validate" validate="name:'自评内容',type:'string',china3char:true,maxLength:4000,notNullWithoutTrim:true"></textarea>
	               </div>
	           </td>
	       </tr>
	       <tr>
	            <td colspan="3"></td>
				<td align="center">
					<div>
						<input type="button" value="取消" class="xl_btn_cancel"
							onclick="_closeWin()" />
					</div>
				</td>
				<td align="right">
					<div>
						<input type="button" value="提交" class="xl_btn"
							onclick="sendReq4AddOrDel()" />
					</div>
				</td>
	       </tr>
		  </tbody>
		  </table>
    </div>
    </form>
</body>
<script type="text/javascript">
	function sendReq4AddOrDel() {
		//表单提交
		var formobj = $("#subTableForm");
		if(!formobj.validate({errorBg:true,errorIcon:true})){
			validatamsg(formobj);
			return;
		}
		var url = "${path}/supervision/supervisionController.do?method=saveSubTables&masterDataId=${masterDataId}&tableName=selfevaluate&timestamp='" + (new Date()).getTime()+"'&field0116=''&field0108=''";
		formobj.jsonSubmit({
			action : url,
			debug : false,
			validate : false,
			ajax : true,
			callback : function(objs) {
				var success=eval('('+objs+')').success;
				if(success=='true'){
					sendsuccess("评价成功");
					_closeWin('selfevaluate');
				}
			}
		});
	}
</script>
</html>