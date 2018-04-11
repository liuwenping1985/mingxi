<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<%@ include file="../../../common/common.jsp"%>
<%@ include file ="./misignatureConfig_js.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
	<div class="comp" comp="type:'breadcrumb',code:'m3_isignatureServer'"></div> 
     <div class="layout_north" layout="height:30,sprit:false,border:false">
         <div id="toolbar"></div>
     </div>
	 <div id="center"  class="layout_center" layout="border:true">
		    <form id="form1" action="<c:url value='/m3/msignature.do'/>?method=isignatureConfig" method="post">
				<br>
				<fieldset>
					<legend><font>${ctp:i18n("m3.isignature.server.configLebel")}</font></legend>
					<table>
						<tr></tr>
						<tr>
							<th><span>&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n("m3.isignature.server.serverLibel")}</span></th>
							<td>
								<input type="text" id="address" name = "address" class="validate w100b"  style="width:500px ;height:30px"
									validate="type:'string',name:'${ctp:i18n("m3.isignature.server.serverLibel")}',notNull:true,minLength:1,maxLength:100,avoidChar:'-!@#$%><^&amp;*()_+'">
							
							</td>
						</tr>
						<tr></tr>
					</table>
				</fieldset>
			</form>
	
		<div id="btnArea" class="stadic_layout_footer">
                 <div id="button_area" align="center" class="page_color button_container border_t padding_t_5" style="height:35px;">
                     <table  >
                         <tbody>
                             <tr>
                                 <td >
                                     <a href="javascript:void(0)" id="btnok"
                                         class="common_button common_button_emphasize">${ctp:i18n('common.button.ok.label')}</a>&nbsp;&nbsp;
                                     <a href="javascript:void(0)" id="btncancel"
                                         class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
                                 </td>
                             </tr>
                         </tbody>
                     </table>
                 </div>
			 </div>
		</div>
</div>
</body>
</html>