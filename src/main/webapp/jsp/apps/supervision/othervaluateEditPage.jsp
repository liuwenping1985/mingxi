<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@page import= "java.text.SimpleDateFormat"%>
<%@page import= "java.util.Date"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma" contect="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<title>评价</title>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/supervision/css/supervisionEditPage.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" src="${path}/apps_res/supervision/js/supervisionPage.js"></script>
</head>
<body>
 <form id="subTableForm">
<div class="xl-container xl-evaluate-container">

    <input id="field0108" name="field0108" type="hidden" value="${CurrentUser.id}"/>
    <table class="xl-content-table">
        <colgroup>
           <col width="100px"/>
            <col width="80px"/>
            <col width="70px"/>
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
		           <td align="right">
		               <div>
		                   <label>评价人：</label>
		               </div>
		           </td>
		           <td colspan="4">
		               <div>
		                    <input style="min-height:28px;" value="${CurrentUser.name}" type="text" disabled class="xl-eva-person">
		               </div>
		           </td>
		       </tr>
		       <tr>
		           <td align="right">
		               <div>
		                   <label>等级：</label>
		               </div>
		           </td>
		           <td colspan="4">
		               <div class="xl-select" style="margin:0px;padding-left:0px">
		                    <select id="field0105" name="field0105" >
					            <option value="">请选择</option>
		                    	<c:forEach var="enum" items="${enumItemList}">
							    	<option value="${enum.id}">${enum.showvalue}</option>
								</c:forEach>
					        </select>
		               </div>
		           </td>
		       </tr>
		       <tr>
		           <td align="right">
		               <div>
		                   <label>得分：</label>
		               </div>
		           </td>
		           <td colspan="4">
		               <div>
		                    <input id="field0106" name="field0106" style="min-height:28px;" value="" type="text"  class="xl-eva-person validate" validate="name:'得分',isInteger:true,minValue:0,maxValue:100,notNull:true"/>
		               </div>
		           </td>
		       </tr>
		       
		       <tr>
		           <td align="right" style="vertical-align:top;">
		               <div>
		                   <label>评价内容：</label>
		               </div>
		           </td>
		           <td colspan="4">
		               <div>
		                    <textarea validate="name:'评价内容',type:'string',china3char:true,maxLength:4000,notNull:true" id="field0107" name="field0107" class="xl-eva-words validate"></textarea>
		               </div>
		           </td>
		       </tr>
		       <tr>
					<td colspan="3"></td>
					<td align="center">
						<div>
							<input type="button" value="取消" onclick="_closeWin()" class="xl_btn_cancel">
						</div>
					</td>
					<td align="right">
						<div>
		        			<input type="button" value="提交" onclick="sendReq4AddOrDel()" class="xl_btn">
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
	var url = "${path}/supervision/supervisionController.do?method=saveSubTables&masterDataId=${masterDataId}&tableName=othervaluate";
	formobj.jsonSubmit({
		action : url,
		debug : false,
		ajax : true,
		callback : function(objs) {
			var success=eval('('+objs+')').success;
			if(success=='true'){
				sendsuccess("评价成功");
				_closeWin('othervaluate');
				}
			}
	});
}
</script>
</html>