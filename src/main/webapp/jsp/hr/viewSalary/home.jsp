<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
<!--
	function checkViewPage() {
	    getA8Top().winSalaryPwd = getA8Top().$.dialog({
		        title:' ',
		        transParams:{'parentWin':window},
		        url: hrViewSalaryURL + "?method=${viewPage}",
		        width: 400,
		        height: 280,
		        isDrag:false
		});
	}
	
	function dialogCollFun (returnValue) {
		getA8Top().winSalaryPwd.close();
		if (returnValue == 'true') {
            detailIframe.location.href = "${urlHrViewSalary}?method=homeEntry";
        } else {
            getA8Top().showShortcut("/portal/portalController.do?method=personalInfo");
        }
	}
	
	
    try{
    	var skinPathKey = getA8Top().skinPathKey == null ? "harmony" : getA8Top().skinPathKey;
    	var html = '<span class="nowLocation_ico"><img src="'+getA8Top()._ctxPath+'/main/skin/frame/'+skinPathKey+'/menuIcon/'+getA8Top().currentSpaceType+'.png"></span>';
    	html += '<span class="nowLocation_content">';
    	html += "<a class=\"hand\" onclick=\"showMenu('"+getA8Top()._ctxPath+"/portal/portalController.do?method=personalInfo')\">" + getA8Top().$.i18n("menu.personal.affair") + "</a>";
    	html += " &gt; <a class=\"hand\" onclick=\"showMenu('" + getA8Top()._ctxPath+ "/portal/portalController.do?method=personalInfoFrame&path=/hrViewSalary.do?method=viewSalary')\">" + getA8Top().$.i18n("menu.hr.salary.show") + "</a>";
    	html += '</span>';
    	getA8Top().showLocation(html);
    }catch(e){
    	
    }
//-->
</script>
</head>
<body class="tab-body" scroll="no" onload="checkViewPage()">
	<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="line">
		<tr>
			<td><iframe noresize="noresize" frameborder="no" src="" id="detailIframe" name="detailIframe" style="width: 100%; height: 100%;" border="0px"></iframe>
			</td>
		</tr>
	</table>
</body>
</html>