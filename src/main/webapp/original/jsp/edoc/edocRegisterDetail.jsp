<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="edocHeader.jsp"%>
<title><fmt:message key="common.page.title" bundle="${v3xCommonI18N}" /></title>
<script>
//ie以外的浏览器关闭窗口时不能从内关闭外面的窗口
function closeWindow(){
	if(window.dialogArguments){
		window.returnValue = "true";
		window.close();
	}else if(window.opener){
		window.close();
	}else{
		try{
			parent.parent.location.reload(true);
		}catch(e){
			parent.getA8Top().reFlesh();
		}
	}
}
</script>
</head>
<frameset rows="0,*" cols="*" framespacing="0" frameborder="no" border="0" scrolling="no">
  <frame src='' scrolling="no">
  
  <frame frameborder="no" src="${detailURL}?method=edocRegister&registerId=${registerId}&forwardType=${v3x:toHTML(param.forwardType)}&viewMode=OfficeWord&from=${(from=='supervise' || !empty from) ? from : param.from}" name="detailMainFrame" id="detailMainFrame" scrolling="no" />
</frameset>

<noframes><body scroll="no">
</body>
</noframes>

</html>