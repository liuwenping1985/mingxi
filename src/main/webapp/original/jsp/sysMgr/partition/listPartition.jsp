<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<html>
<head>
<title>分区管理</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript">
showCtpLocation("F13_sysSubarea");

function create(){
	parent.detailFrame.location.href="${partitionURL}?method=addPartition";
}

function removePrak(){
	var count = validateCheckbox("id");
	if(count <= 0){
		alert(v3x.getMessage("sysMgrLang.system_partition_delete")); 
		return false;
	}
	else{
		var idObjs = document.getElementsByName('id');
		for(var i=0; i<idObjs.length; i++){
			var idCheckBox = idObjs[i];
			if(idCheckBox.checked && idCheckBox.getAttribute("partitionState") == 0){
				alert(v3x.getMessage("sysMgrLang.system_partition_show", " '" + idCheckBox.getAttribute("partitionName") + "' "));
				return false;
			}
		}
		var id = getCheckboxSingleValue("id");
		if(!confirm(v3x.getMessage("sysMgrLang.system_partition_delete_ok")))
		return false;

		var form1 = document.getElementById("partitionFrom");
		form1.action=partitionURL+"?method=removePartition&id="+id;
		form1.submit();
	} 
}

function getBegin(){
	var element = getCheckboxSingleObject("id");
	return element.getAttribute("begin");
}
function getEnd(){
	var element = getCheckboxSingleObject("id");
	return element.getAttribute("end");
}
function split(){
	var count = validateCheckbox("id");
	switch(count){
		case 0:
				alert(v3x.getMessage("sysMgrLang.system_partition_split"));  
				return false;
				break;
		case 1: 
				var id = getCheckboxSingleValue();
				parent.detailFrame.location.href="${partitionURL}?method=splitPartition&id="+id+"&startDate="+getBegin()+"&endDate="+getEnd();
				break;
		default:
				alert(v3x.getMessage("sysMgrLang.choose_one_only"));
				return false;			
	}
}

function dbclick(id){
	parent.detailFrame.location.href = partitionURL+"?method=modifyPartition&id="+id;
}
// 修改
function modify(){
	var count = validateCheckbox("id");
	switch(count){
		case 0:
				alert(v3x.getMessage("sysMgrLang.system_choice_one_sign"));
				return false;
				break;
		case 1:
				var id = getCheckboxSingleValue("id");
				parent.detailFrame.location.href="${partitionURL}?method=modifyPartition&id="+id;
				break;
		default:
				alert(v3x.getMessage("sysMgrLang.choose_one_only"));
				return false;			
	}
}
</script>
</head>
<body>

<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="40" colspan="2"><script type="text/javascript">
					var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
					myBar.add(new WebFXMenuButton("add","<fmt:message key="partition.menu.addpratiton" />","create()",[1,1], "",null));
					myBar.add(new WebFXMenuButton("mod","<fmt:message key="common.toolbar.update.label" bundle='${v3xCommonI18N}'/>","modify()",[1,2],"", null));
					myBar.add(new WebFXMenuButton("rem","<fmt:message key="partition.menu.removepratiton" />","removePrak()",[1,3],"", null));
					myBar.add(new WebFXMenuButton("spl","<fmt:message key="partition.menu.splitpratiton" />","split()",[2,1],"", null));
					document.write(myBar);
			    	document.close();
			    	</script></td>
			</tr>
		</table>	
    
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<form id="partitionFrom" method="post">
			<v3x:table htmlId="partitionlist" data="partitionlist" var="partition" showPager="true" subHeight="0">
				<c:set var="click" value="showDetail('${partition.id}','Partition',parent.detailFrame)" />
				<c:set var="dbclick" value="dbclick('${partition.id}')"/>
				<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
					<input type="checkbox" name="id" value="${partition.id}" partitionName="${partition.name}" partitionState="${partition.state}" begin="<fmt:formatDate value="${partition.startDate}" pattern="yyyy-MM-dd" />"  end="<fmt:formatDate value="${partition.endDate}" pattern="yyyy-MM-dd" />"/>
				</v3x:column>
				<v3x:column width="21%" align="left"
					label="partition.fieldname.names" type="String"
					value="${partition.name}" className="cursor-hand sort"
					maxLength="26" symbol="..." alt="${partition.name}"
					onClick="${click}" onDblClick="${dbclick}" />
				<v3x:column width="10%" align="left" label="partition.fieldname.state" type="String"
					className="cursor-hand sort" maxLength="7" symbol="..." onClick="${click}" onDblClick="${dbclick}">
					<fmt:message key="${partition.state==0?'common.state.normal.label':'common.state.invalidation.label'}" bundle='${v3xCommonI18N}'/>
				</v3x:column>
				<v3x:column width="40%" align="left" label="partition.fieldname.path"
					type="String" value="${partition.path}" className="cursor-hand sort"
					alt="${partition.path}" maxLength="50" symbol="..." onClick="${click}" onDblClick="${dbclick}"/>
				<v3x:column width="12%" type="Date" align="left"
					label="partition.fieldname.starttime" className="cursor-hand sort"
					onClick="${click}" onDblClick="${dbclick}">
					<fmt:formatDate value="${partition.startDate}" pattern="yyyy-MM-dd" />
				</v3x:column>
				<v3x:column width="12%" type="Date" align="left"
					label="partition.fieldname.endtime" className="cursor-hand sort"
					onClick="${click}" onDblClick="${dbclick}">
					<fmt:formatDate value="${partition.endDate}" pattern="yyyy-MM-dd" />
				</v3x:column>
			</v3x:table>
		</form>
    </div>
  </div>
</div>
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.system.subarea' bundle='${v3xMainI18N}'/>", [3,3], null, _("sysMgrLang.detail_info_2302"));
</script>
</body>
</html>
