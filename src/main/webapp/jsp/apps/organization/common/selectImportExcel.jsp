<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="organizationHeader.jsp"%>
<%@ include file="../../../common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
<meta HTTP-EQUIV="Expires" CONTENT="0">
<title><fmt:message key="import.local.excel" /></title>
<script type="text/javascript"
    src="${path}/ajax.do?managerName=orgManager"></script>

<script type="text/javascript">
var isDept ="${importType == 'department'}";
var oManager = new orgManager();
$().ready(function() {
	if(isDept === "true"){
		$("#importOptions").hide();
		//$("#importOptions").attr("visible", false);
		var deptlist = oManager.getChildDepartments($.ctx.CurrentUser.loginAccount,true);
        if(deptlist.length>0){
            $("#ddepartlabel").hide();
            $("#_imptype").text("${ctp:i18n('import.dept')}"+"${ctp:i18n('import.type.dept.role')}");
            $("#drole").attr("checked",'checked');
        }else{
            $("#rdepartlabel").hide();
        }
	}else{
		$("#departImp").hide();
	}
	
})
	var accountflag=0;
	function listenerKeyPress(){
		if(event.keyCode == 27){
			window.parent.dialog.close();
		}
	}
	
	function submitform(){
		var fileURL = document.getElementById('file1').value;
		if("" == fileURL) {
			$.alert("${ctp:i18n('choose_import_file')}");
			return;
		}
		var filePostfix = fileURL.substring(fileURL.lastIndexOf('.')+1);
		if(filePostfix.toLowerCase()!='xls' && filePostfix.toLowerCase() != 'xlsx'){//tanglh
			$.alert("${ctp:i18n('file_error_choose_excel')}");
			return;
		}
		var form = document.all("uploadFormOrgImp");
		if(document.getElementById('file1').value!=""&&document.getElementById('file1').value.length!=0){
			var sele = document.all("tablename");
			var selevalue = "";
			if(sele != null){
				var opt = sele.options;
				for(var i=0;i<opt.length;i++){
					if(i==sele.selectedIndex){
						selevalue = opt.value;
						accountflag=1;
					}
				}				
				if("" == selevalue) {
					$.alert("${ctp:i18n('orgainzation_import_seletable')}");
					return;
				}
			}else{
				var inputtype = document.all("importType");
				selevalue=inputtype.value;
			}
			var selanguage = document.all("language");
			var languagevalue;
			var selanguageopt = selanguage.options;
			for(var i=0;i<selanguageopt.length;i++){
				if(i==selanguage.selectedIndex){
					languagevalue = selanguageopt[i].value;
				}
			}
			var shn = document.all("sheetnumber");
			if(shn != null){
				if(shn.value==""){
					shn.value = 0;
				}
			}
			document.all("impURL").value = document.getElementById('file1').value;
			document.all("selectvalue").value = selevalue;
			//document.all("radiovalue").value = radiovalue;
			document.all("languagevalue").value = languagevalue;

			var rep = document.all("repeat");
			var repvalue;
			if(rep[0].checked){
				repvalue = rep[0].value;
			}else{
				repvalue = rep[1].value;
			}
		
			try{if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();}catch(e){}
			form.action="${organizationURL}?method=doImport&repeat="+repvalue;

	        showProcDiv();
			form.submit();
			try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
		}else{
			$.alert("${ctp:i18n('choose_import_file')}");
			return;
		}
	}
    function showProcDiv(){
        var width = 280;
        var height = 120;
        
        var left = (document.body.scrollWidth - width) / 2;
        var top = (document.body.scrollHeight - height) / 2;
        var title = "${ctp:i18n('org.member.import.process.label')}";    
        var str = "";
            str += '<div id="procDIV" style="position:absolute;left:'+left+'px;top:'+top+'px;width:'+width+'px;height:'+height+'px;z-index:50;border:solid 2px #DBDBDB;">';
            str += "<table width=\"100%\" height=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" bgcolor='#F6F6F6'>";
            str += "  <tr>";
            str += "    <td align='center' id='procText' height='40' valign='bottom' class='color_red font_bold'>&nbsp;</td>";
            str += "  </tr>";
            str += "  <tr>";
            str += "    <td align='center'><span class='process'>&nbsp;</span></td>";
            str += "  </tr>";
            str += "</table>";
            str += "</div>";
            
        document.getElementById("procDiv1").innerHTML = str;
        var procTextE = document.getElementById("procText");
        if(procTextE){
            procTextE.innerText = title;
        }
        document.close();
    }   	
 	function checksheet(a)	{
 		var id = a.id;
 		if(id.indexOf("single") != -1){
 			var kk = document.getElementById("sheetnum");
 			kk.style.display="none";
 		}else  if(id.indexOf("multi") != -1){
 			var kk = document.getElementById("sheetnum");
 			kk.style.display="";
 		}
 	}
 	function seleaccount(){
 		var tname = document.all("tablename");
 		var op = tname.options;
 		for(var i=0;i<op.length;i++){
 			if(op[i].selected == true){
 				if(op[i].value != ""){
	 				if(op[i].value == "account"){
	 					accountflag=0;
	 				}else{
	 					accountflag=1;
	 				}
 				}else{
 					accountflag=0;
 				}
 			}
 		}
 	}
 	function closeMe() {
 		window.parentDialogObj['importdialog'].close();
 	}

</script>
</head>
<body scroll="no" onkeydown="listenerKeyPress()" >
	<div style="overflow:hidden">
<form enctype="multipart/form-data" name="uploadFormOrgImp" method="post">
	<table class="popupTitleRight bg_color_white" width="100%" height="100%"  align="center" border="0" cellspacing="0" cellpadding="0">
		<input type="hidden" id="importType" name="importType" value="${ctp:toHTML(importType)}">
		<input type="hidden" id="selectvalue" name="selectvalue">
		<input type="hidden" id="radiovalue" name="radiovalue">
		<input type="hidden" id="impURL" name="impURL">
		<input type="hidden" id="languagevalue" name="languagevalue">
		<tr>
			<td height="20" class="PopupTitle" id ="_imptype">
				<c:choose>
					<c:when test="${importType == 'level' }">
						${ctp:i18n('import.level')}
					</c:when>
					<c:when test="${importType == 'post' }">
						${ctp:i18n('import.post')}
					</c:when>
					<c:when test="${importType == 'member' }">
						${ctp:i18n('import.member')}
					</c:when>
					<c:when test="${importType == 'department' }">
						${ctp:i18n('import.dept')}
					</c:when>
					<c:when test="${importType == 'team' }">
						${ctp:i18n('import.team')}
					</c:when>
					<c:when test="${importType == 'account' }">
						${ctp:i18n('import.account')}
					</c:when>
				</c:choose>
			</td>
		</tr>
		<tr>
			<td id="upload1" height="30" style="padding-left: 12px">${ctp:i18n('import.choose.file')}
			</td>
		</tr>
		<tr>
			<td id="upload1" height="30" style="padding-left: 12px">
				<input type="file" name="file1" id="file1" style="width: 95%"/>
			</td>
		</tr>
		<tr class="bg-imges2" id="departImp">
			<td  class="bg-imges2" height="30" align="left" style="padding-left: 12px" colspan="3">
				${ctp:i18n('import.depart')}:&nbsp;
				<label for="ddepart" id = "ddepartlabel">
					<input type="radio" name="depart" value="1" checked="checked" id="ddepart">
					${ctp:i18n('import.depart.ddepart')}
				</label>
				<label for="drole" id = "rdepartlabel">
					<input type="radio" name="depart" value="0" id="drole">
					${ctp:i18n('import.depart.drole')}&nbsp;&nbsp;
				</label>
			</td>
		</tr>					
		<tr class="bg-imges2"  id="importOptions">
			<td  class="bg-imges2" height="30" align="left" style="padding-left: 12px" colspan="3">
				${ctp:i18n('import.option')}:&nbsp;
				<label for="overleap">
					<input type="radio" name="repeat" value="1" checked="checked" id="overleap">
					${ctp:i18n('import.repeatitem.overleap')}
				</label>
				<label for="overcast">
					<input type="radio" name="repeat" value="0" id="overcast">
					${ctp:i18n('import.repeatitem.overcast')}&nbsp;&nbsp;
				</label>
			</td>
		</tr>
		<tr>
			<td height="30" align="left" style="padding-left: 12px">
				${ctp:i18n('import.choose.language')}:&nbsp;
				<c:set var="currentLocale" value="${local}" />
				<select name="language">
				    <c:forEach var="l" items="${allLocales}">
                        <c:set var="key" value="localeselector.locale.${l}" />
				        <option value="${l}" ${currentLocale == l ? "selected" : ""}>${ctp:i18n(key)}</option>
				    </c:forEach>
				</select>
			</td>
		</tr>		

		<tr class="bg-imges2">
			<td class="bg-imges2" align="left" style="padding-left: 15px" colspan="3">
				<div style="display:none" id="sheetnum">
				${ctp:i18n('organization.sheetnumber')}:<input name="sheetnumber" type="text">
				</div>
			</td>
		</tr>		
		<c:if test="${importType == 'organization'}">
		
		<tr class="bg-imges2">
			<td  class="bg-imges2" height="30" align="left" style="padding-left: 15px" colspan="3">
				<select	name="tablename" onchange="seleaccount()">
					<option value="">${ctp:i18n('organization.tablename')}<fmt:message key="organization.tablename"/></option>
					<option value="account">${ctp:i18n('import.type.account')}<fmt:message key="import.type.account"/></option>
					<option value="post">${ctp:i18n('import.type.post')}<fmt:message key="import.type.post"/></option>
					<option value="level">${ctp:i18n('import.type.level')}<fmt:message key="import.type.level"/></option>
					<option value="member">${ctp:i18n('import.type.member')}<fmt:message key="import.type.member"/></option>
					<option value="role">${ctp:i18n('import.type.role')}<fmt:message key="import.type.role"/></option>
					<option value="department">${ctp:i18n('import.type.dept')}<fmt:message key="import.type.dept"/></option>
					<option value="team">${ctp:i18n('import.type.team')}<fmt:message key="import.type.team"/></option>
				</select>
			</td>
		</tr>		
		</c:if>							
		<tr>
			<td height="42" align="right" class="bg-advance-bottom">
				<input type="button" name="b1" onclick="submitform()"value="${ctp:i18n('common.button.ok.label')}" class="button-default-2">&nbsp;
				<input id="submintCancel" type="button" onclick="closeMe()" value="${ctp:i18n('common.button.cancel.label')}" class="button-default-2">
			</td>
		</tr>
	</table>
</form>
	<!--</iframe>-->
	<div id="procDiv1"></div>
	<div>
<iframe width="0" height="0" name="fileUpload"id="fileUpload"></iframe>
	</div>
</div>
</body>
</html>