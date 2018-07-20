<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>增加关联</title>
<%@include file="header.jsp"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<script type="text/javascript">
getDetailPageBreak();
    function submitForm(onlyMap){
        var form = document.getElementById("addForm");
        if(checkForm(form)){
        	var isMenberChecked = document.getElementById("people").checked;
        	var departMentCheckBox = document.getElementById("department").checked;
        	var postMentCheckBox = document.getElementById("post").checked;
         	var levelMentCheckBox = document.getElementById("level").checked;
        	if(!isMenberChecked&&!departMentCheckBox&&!postMentCheckBox&&!levelMentCheckBox){
        		alert(v3x.getMessage("ncPlugLang.syn_content"));
        		return;
        	}
        	
          form.action = "${urlNCSynchron}?method=createConfig&onlyMap="+onlyMap;
          document.getElementById("submintCancel").disabled = true;
          document.getElementById("submintConfig").disabled = true;
          getA8Top().startProc('');
          form.submit();         
        }
    }
    function cancel(){
    	previewFrame('Down');
    	//window.location.href='<c:url value="/common/detail.jsp" />';
    }
</script>
</head>
<body style="overflow: no">
	
<form name="addForm" id="addForm" method="post" target="addConfigFrame" action="">						
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
    <tr>
        <td class="categorySet-4" height="8"></td>
    </tr>
    <tr>
        <td class="categorySet-head" height="23">
            <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="categorySet-head-space">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
		<td class="categorySet-head">
			<div class="scrollList" style="background: #ffffff;">
			<%@include file="config.jsp"%>
			</div>		
		</td>
	</tr>
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<table width="100%" border="0">
			  <tr>
				<td  width="100%" align="center">
					<input id="submintConfig" type="button" onclick="submitForm(1)" value="<fmt:message key='nc.org.hand.save.list'/>" class="button-default-2">
					<input id="submintCancel" type="button" onclick="cancel()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
				</td>
			  </tr>
			</table>
		</td>
	</tr>
</table>
</form>
<iframe name="addConfigFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>