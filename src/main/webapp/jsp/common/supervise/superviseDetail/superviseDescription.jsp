<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>    
    <title></title>
	<script type="text/javascript">
		
		function OK(){
			var content = $.trim($("#content").val());
	        if(content !="" && content.length > 200){
                //督办摘要不能多于200个字，当前共有"+content.length+"个字!
	            $.alert("${ctp:i18n_1('collaboration.common.supervise.supervisionSummary','"+content.length+"')}");
	            return;
	        }
	        var superviseId = $.trim($('#superviseId').val());
			
			var returnValue = "{\"content\":\""+encodeURIComponent(content)+"\",\"superviseId\":\""+superviseId+"\"}";
	        return returnValue;
		}
	
	</script>
</head>
<body scroll="no">
	<form name="messageForm" id="messageForm" method="post" target="targetFrame">
		<input type="hidden" name="superviseId" id="superviseId" value="${param.superviseId}">
		<table class="popupTitleRight" border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
			<tr>
			    <td class="PopupTitle"><fmt:message key='supervise.col.label' /></td><!-- 协同督办 -->
			</tr>
			<tr>
			    <td align="left" class="font_size12">
		            <div style="padding:15px 15px 5px 15px ">${ctp:i18n('supervise.col.title')}:</div> <!-- 督办主题 -->
			        <div style="padding: 0px 15px 0px 15px ">
                        <textarea name="title" id="title" rows="" cols="" disabled
			        		  style="width: 100%;height: 100px;font-size:12px;" class="font-12px"
			        		  inputName="${ctp:i18n('supervise.col.title') }" ><c:out value='${title}' escapeXml='true' default='${title}' /></textarea>
                    </div>
			    </td>
			</tr>
			<tr>
			    <td align="left" class="font_size12">
		            <div style="padding:10px 15px 5px 15px ">${ctp:i18n('supervise.col.remark')}:</div><!-- 督办摘要 -->
			        <div style="padding: 0px 15px 0px 15px ">
                        <textarea name="content" id="content" rows="" cols="" ${status==1?"disabled":"" } 
			        		  style="width: 100%;height: 100px;font-size:12px;" class="font-12px"  validate="maxLength" 
			        		  maxSize="10" inputName="${ctp:i18n('supervise.col.remark')}" ><c:out value='${content}' escapeXml='true' default='${content}' /></textarea>
                    </div>
			    </td>
			</tr>
		</table>
	</form>
	<iframe id="targetFrame" name="targetFrame" height="0" width="0" frameborder="0"></iframe>
</body>
</html>