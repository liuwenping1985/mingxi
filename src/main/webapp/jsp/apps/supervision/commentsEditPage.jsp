<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma" contect="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<title>批示</title>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/supervision/css/supervisionEditPage.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" src="${path}/apps_res/supervision/js/supervisionPage.js"></script>
<script type="text/javascript">
	//复制自form.js
	function sendReq4AddOrDel() {
		//表单提交
		var formobj = $("#subTableForm");
		//模拟提醒记录
		var url = "${path}/supervision/supervisionController.do?method=saveSubTables&masterDataId=${masterDataId}&tableName=${tableName}&tag="
				+ (new Date()).getTime();
		if(!formobj.validate({errorBg:true,errorIcon:true})){
			validatamsg(formobj);
			return;
		}
		formobj.jsonSubmit({
			action : url,
			debug : false,
			validate : false,
			ajax : true,
			callback : function(objs) {
				var success=eval('('+objs+')').success;
				if(success=='true'){
					sendsuccess("批示成功");
					_closeWin('comments');
				}
			}
		});

	}
</script>
</head>
<body>
 <body>
 <form id="subTableForm">
<div class="xl-container xl-write_off-container">
    <table class="xl-content-table" style="width:480px">
        <colgroup>
            <col width="100px"/>
            <col width="90px"/>
            <col width="80px"/>      
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
                        <label>批示人：</label>
                    </div>
                </td>
                <td colspan="4">
                    <div>
                        <input class="xl-wo-person" id="commentsPerson" disabled style="min-height:28px;" type="text" value="">
                   		<input value="" type="hidden" name="field0111" id="field0111">
                    </div>
                </td>
        	</tr>
        	<tr>
        		<td align="right" style="vertical-align:top;">
                    <div>
                        <label>批示内容：</label>
                    </div>
                </td>
                <td colspan="4">
                    <div>
                        <textarea class="xl-wo-words validate" validate="name:'批示内容',type:'string',china3char:true,maxLength:4000,notNull:true" name="field0110"></textarea>
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
	//默认批示人
	$("#field0111").val($.ctx.CurrentUser.id);
	$("#commentsPerson").val($.ctx.CurrentUser.name);
</script>
</html>