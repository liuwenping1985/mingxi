<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<%@ include file="../edocHeader.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
<!--
	

	//保存公文备考
	function saveRemark() {
		if(!checkForm(myform))
		return;//验证form
		
		var aId = myform.id.value;
		myform.action = "${edocStat}?method=saveEdocRemark&id=" + aId;
		//myform.target = "empty";
		myform.submit();
	}

//-->
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<style>
.linetop {/*<用友致远发文单>*/
	font-family: Arial, Helvetica, sans-serif;
	font-size: 25px;
	color: #FF0000;
	text-indent: 10pt;
	border-bottom-width: 2px;
	border-bottom-style: solid;
	border-bottom-color: #FF0000;
	align:center;
}
.linel{/*<公文要素名称>*/
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	color: #FF0000;
	text-indent: 10pt;
	border-bottom-width: 1px;
	border-right-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #FF0000;
	border-right-style: solid;
	border-right-color: #FF0000;
	font-weight: bold;
	height: 38px;
	width: 80px;
}
.linec{/*<用户输入区(公文要素)>*/
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	color: #000000;
	text-indent: 6pt;
	border-bottom-width: 1px;
	border-right-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #FF0000;
	border-right-style: solid;
	border-right-color: #FF0000;	
	line-height: 30px;
	height: 20px;
}
.liner{/*<用户输入区边框右侧为空>*/
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	color: #000000;
	text-indent: 6pt;
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #FF0000;
	height: 20px;
}
</style>
</head>
<body scroll="" id="bodyDetail">
<script type="text/javascript">
getDetailPageBreak();
</script>
<form id="myform" name="myform" method="post">
<input type="hidden" name="id" value="${edocStatObj.id}">
<TABLE width="100%" height="100%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0">
	<TR>						
		<TD align="center" VALIGN="top">
			<div  style="overflow:auto;" id="doStatResult">
			<TABLE width="80%" cellspacing="0" border="0" height="100%">
				<TR>
					<TD class="linetop" colspan="4">&nbsp;</TD>							
				</TR>
				<TR>
					<TD class="linel"><fmt:message key='edoc.supervise.title'/></TD>
					<TD colspan="3" class="liner">${v3x:toHTML(edocSummary.subject)}</TD>
				</TR>
				<TR>
					<TD class="linel"><fmt:message key='edoc.element.doctype'/></TD>
					<TD class="linec" style="width:38%">${v3x:_(pageContext, docType)}&nbsp;</TD>
					<TD class="linel"><fmt:message key='edoc.element.sendtype'/></TD>
					<TD class="liner" style="width:38%">${v3x:_(pageContext, sendType)}&nbsp;</TD>
				</TR>
				<TR>
					<TD class="linel"><fmt:message key='edoc.element.wordno.label'/></TD>
					<TD class="linec" style="width:38%">${v3x:toHTML(edocStatObj.docMark)}&nbsp;
					</TD>
					<TD class="linel"><fmt:message key='edoc.docmark.inner.title'/></TD>
					<TD class="liner" style="width:38%">${v3x:toHTML(edocSummary.serialNo)}&nbsp;</TD>
				</TR>
				<TR>
					<TD class="linel"><fmt:message key='edoc.element.secretlevel'/></TD>
					<TD class="linec" style="width:38%">${v3x:_(pageContext, secretLevel)}&nbsp;</TD>
					<TD class="linel"><fmt:message key='edoc.element.urgentlevel'/></TD>
					<TD class="liner" style="width:38%">${v3x:_(pageContext, urgentLevel)}&nbsp;</TD>
				</TR>				
				<TR>
					<TD class="linel"><fmt:message key='edoc.create.person'/></TD>
					<TD class="linec" style="width:38%">${v3x:toHTML(edocSummary.createPerson)}&nbsp;</TD>
					<TD class="linel"><fmt:message key='edoc.element.keepperiod'/></TD>
					<TD class="liner" style="width:38%">${v3x:_(pageContext, keepPeriod)}&nbsp;</TD>
				</TR>
				<TR>
					<TD class="linel"><fmt:message key='edoc.element.sendtounit'/></TD>
					<TD colspan="3" class="liner">${v3x:toHTML(edocStatObj.sendTo)}&nbsp;</TD>
				</TR>
				<TR>
					<TD class="linel"><fmt:message key='edoc.element.copytounit'/></TD>
					<TD colspan="3" class="liner">${v3x:toHTML(edocStatObj.copyTo)}&nbsp;</TD>
				</TR>
				<TR>
					<TD class="linel"><fmt:message key='edoc.element.sendunit'/></TD>
					<TD class="linec" style="width:38%">${edocStatObj.contentNo==2?edocSummary.sendUnit2:edocSummary.sendUnit}&nbsp;</TD>
					<TD class="linel"><fmt:message key='edoc.element.issuer'/></TD>
					<TD class="liner" style="width:38%">${v3x:toHTML(edocSummary.issuer)}&nbsp;</TD>
				</TR>
				<TR>
					<TD class="linel"><fmt:message key='edoc.element.printedunit'/></TD>
					<TD class="linec" style="width:38%">${edocSummary.printUnit}&nbsp;</TD>
					<TD class="linel"><fmt:message key='edoc.element.copies'/></TD>
					<TD class="liner" style="width:38%">${edocStatObj.copies}&nbsp;</TD>
				</TR>
				<%-- 根据国家行政公文规范,去掉主题词
				<TR>
					<TD class="linel"><fmt:message key='edoc.element.keyword'/></TD>
					<TD colspan="3" class="liner">${v3x:toHTML(edocSummary.keywords)}&nbsp;</TD>
				</TR> --%>
				<TR>
					<TD class="linel"><fmt:message key='edoc.element.printer'/></TD>
					<TD colspan="3" class="liner">${v3x:toHTML(edocSummary.printer)}&nbsp;</TD>
				</TR>						
				<TR>
					<TD class="linel"><fmt:message key='edoc.for.reference'/></TD>
					<!-- fixing td bug 39642 -->
					<TD colspan="3" class="liner"><textarea id="remark" name="remark" cols="3" style="width:100%" inputName="备考" maxSize="200" validate="maxLength">${v3x:toHTMLAlt(edocStatObj.remark)}</textarea></TD>
				</TR>
				<TR>
					<TD colspan="4" height="85" align="center">
					<%--GOV-4611 公文统计，统计出来的已封发公文，填写备考后的提交按钮丢失 --%>
					<input type="button" name="btn" onclick="saveRemark();" value="<fmt:message key='common.button.submit.label' bundle='${v3xCommonI18N}'/>">
					
					</TD>
				</TR>
			</TABLE>
			</div>
		</TD>				
	</TR>			
	<tr height="10px;">
		<td>
		&nbsp;
		</td>
	</tr>
</TABLE>		
<script>
$(function() {
	function scrollList_fn(){
    	var _scrollList_Obj = $("#doStatResult");
        _scrollList_Obj.hide();
        _scrollList_Obj.css("overflow","auto");
		_scrollList_Obj.height(_scrollList_Obj.parent().height());
        _scrollList_Obj.show();
    }
    scrollList_fn();
    $(window).resize(scrollList_fn);
});
</script>
</form>
<iframe id="empty" name="empty" src="" width="0" height="0" frameborder="0"/>
</body>
</html>