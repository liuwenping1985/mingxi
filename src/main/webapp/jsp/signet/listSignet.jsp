<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.Properties;"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<html>
<head>
<title>印章管理</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<fmt:setBundle basename="com.seeyon.v3x.system.resources.i18n.SysMgrResources" var="sysI18n"/>
<script type="text/javascript">
//getA8Top().showLocation(1602);
showCtpLocation('F13_signet');
 window.onload = function(){
	    <%--branches_a8_v350sp1_r_gov 政务 向凡 注释 修复 GOV-4840，输入特殊字符查询后界面显示JS代码
	    showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	    --%>
        }
		function create(){
			parent.detailFrame.location.href="${signetURL}?method=addSignet";
		}
		
		function getTypeSelectId(){
		var ids=document.getElementsByName('id');
		var count = 0;
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				count += 1;
				if(count > 1) {
					id='false';
					break;
				}
				id=idCheckBox.value;		
			}
		}
		return id;	
	}
		
		
		function modify(){
		var id=getTypeSelectId();
		if(id=='false'){
			alert(v3x.getMessage("sysMgrLang.choose_one_only"));
			return;
		}
		if(id==''){
			alert("<fmt:message key='signet.modify.ok'/>");
			return;
		}
		parent.detailFrame.location.href="${signetURL}?method=modifySignet&id="+id;
	}
		
		
		
		
	   function removeItem(){
			var id = getSelectIds(parent.listFrame);
			if(id){
				if(!confirm(v3x.getMessage("sysMgrLang.system_delete_signet")))
					return false;
				var form1 = document.getElementById("signetListform");
				var signetIds = document.getElementsByName('id');
				for(var i=0; i<signetIds.length; i++){
					var idCheckBox = signetIds[i];
					if(idCheckBox.checked){
						var hiddenObj = document.createElement('INPUT');
						hiddenObj.setAttribute("TYPE","hidden");
						hiddenObj.setAttribute("name","signetNames");
						hiddenObj.setAttribute("value",idCheckBox.getAttribute("markName"));
						form1.appendChild(hiddenObj);
					}
				}
				form1.action=signetURL+"?method=removeSignet";
				form1.submit();
			}else{
				alert(v3x.getMessage("sysMgrLang.system_partition_delete"));  
				return false;
			}
		}
	</script>
</head>
<style>
.search-menu-bar{
    border-top: 1px #A4A4A4 solid;
	background-image: url(/seeyon/common/skin/default/images/xmenu/toolbar_bg.gif);
	background-repeat: repeat-x;
}
div{line-height:1em;}
</style>
<body>
<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0" class="">
	<tr>
		<td height="22" colspan="2"   id="toolbar-top-border" class="webfx-menu-bar border_b"><script type="text/javascript">
			var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
			myBar.add(new WebFXMenuButton("add","<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}'  />","create()",[1,1], "",null));
			myBar.add(new WebFXMenuButton("mod","<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}'/>","modify()",[1,2],"", null));
			myBar.add(new WebFXMenuButton("rem","<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />","removeItem()",[1,3],"", null));
			document.write(myBar);
	    	document.close();
	    	</script></td>
	    	<td class="webfx-menu-bar">
		<form name="searchForm" method="get" action="${signetURL}">
		<input type="hidden" name="method" value="listSerachSignet"/>
		<div class="div-float-right">
			<div class="div-float">
				<select name="condition" id="condition"  onChange="showNextCondition(this)">
				<option value="0">--<fmt:message key='signet.alert.selectcondition'/>--</option>
					<option value="1"><fmt:message key='signet.menu.signetname'/></option>
					<option value="2"><fmt:message key='signet.menu.type.list'/></option>
					<option value="3"><fmt:message key='signet.menu.leveluser'/></option>
				</select>
			</div>
			<div id="1Div" class="div-float hidden">
					<input type='text' class='textfield' name='textfield' />
			</div>
			<div id="2Div" class="div-float hidden">
					<select name="textfield" style="width:133px">
							<option value="1" ><fmt:message key="signet.type.sig"/></option>
						    <option value="0"><fmt:message key="signet.type.underwrite"/></option>
					</select>
			</div>
			<div id="3Div" class="div-float hidden">
					<input type='text' class='textfield' name='textfield' />
			</div>
			<div onclick="javascript:doSearch()" class="condition-search-button">&nbsp;</div>
		</div>
		</form></td>
	</tr>
	<tr>
		<td colspan="3">
		<div class="scrollList">
		<form id="signetListform" method="post">
			<v3x:table htmlId="partitionlist" data="signetList" var="signet" subHeight="30">
			<c:set var="click" value="showDetailSignet('${signet.id}',parent.detailFrame)" />
			<c:set var="dbclick" value="showDbDetailSignet('${signet.id}',parent.detailFrame)" />
				<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
					<input id="id" type="checkbox" name="id" value="${signet.id}" markName="${signet.markName}" />
				</v3x:column>
				<v3x:column width="35%" align="left" label="signet.menu.signetname" type="String" value="${signet.markName}" className="cursor-hand sort" maxLength="40" symbol="..."
					alt="${signet.markName}" onClick="${click}" onDblClick="${dbclick}" />
				<v3x:column width="10%" align="center" label="signet.menu.type.list" type="String"
					className="cursor-hand sort" maxLength="7" symbol="..." onClick="${click}" onDblClick="${dbclick}">
					<fmt:message key="${signet.markType==1 ? 'signet.type.sig' : 'signet.type.underwrite'}" bundle="${sysI18n}"/>
				</v3x:column>
				<v3x:column width="50%" align="left" label="signet.menu.leveluser" type="String" value="${v3x:showOrgEntitiesOfIds(signet.userName, 'Member', pageContext)}"
					className="cursor-hand sort" maxLength="40" symbol="..."
					alt="${v3x:showOrgEntitiesOfIds(signet.userName, 'Member', pageContext)}" onClick="${click}" onDblClick="${dbclick}" />
			</v3x:table>
		</form>
		</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='work.area.setup.signet' bundle='${v3xMainI18N}'/>", [3,5], pageQueryMap.get('count'), _("sysMgrLang.detail_info_9005"));	
showCondition("${param.condition}", "${v3x:escapeJavascript(param.textfield)}", "${v3x:escapeJavascript(param.textfield1)}");<%--branches_a8_v350sp1_r_gov 政务 向凡添加 修复GOV-4840，查询输入特殊字符报js错误，不能保存查询条件信息错误。--%>
</script>
</body>
</html>
