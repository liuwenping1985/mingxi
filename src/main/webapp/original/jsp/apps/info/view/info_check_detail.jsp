<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- <%@ include file="../../include/taglib.jsp"%>
<%@ include file="../../include/header.jsp"%> --%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.office.auto.resources.i18n.SeeyonAutoResource" var="seeyonOfficeI18N"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${statName.name}</title> 
<%-- <script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
 --%>
<style>
/*.tableclass{
    border-top: solid 1px #999999;
	border-left: solid 1px #999999;
 }
 .tdclass{
   border-right:solid 1px #999999;
   border-bottom:solid 1px #999999;
 }
 .tdfirstclass{
	border-right:solid 1px #999999;
	border-bottom:solid 1px #999999;
 } */
.table_brder{
border-top:1px solid #cdcdcd;
border-left:1px solid #cdcdcd;
}
.table_brder td,.sort thead td{
border-right:1px solid #cdcdcd;
border-bottom:1px solid #cdcdcd;
line-height:24px;
}
</style>
</head>
<body style="overflow:hidden;">
 
<div id="print"  class="scrollList">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="2" align="center">   
	<%--<tr>
		<td align="center">
		 <span style="display:block; position:absolute;right:0;width:7%;height:30px;line-height:30px;" ><div id="printButtonDiv">
		 <input type="button" name="btn1" value="<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />" onclick="popprint();" class="button-default-2">
		</div></span>
		</td>
	</tr> --%>
	<tr valign="top">
		 <td align="center" valign="top">
			 <TABLE cellSpacing=0 border="0" cellPadding=0 width="100%" class="sort table_brder" >
			
					<tr class="sort"> 
						<td width="15%" > 
							<div style="margin-left:20px;">
								 <br>
								  ${statName.statResurlt}
							</div>  
						</td> 
					 </tr>		
			</table> 
		</td>	
	</tr>
</table>
</div>
</body>
</html>