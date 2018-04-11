<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css"
	href="<c:url value="/common/SelectPeople/css/css.css${v3x:resSuffix()}" />" />
<script   language="JavaScript">
	var onlyLoginAccount_member = true;
	var showAllOuterDepartment_member = true;
function moveLtoR(fObj,tObj){
  var i;
  var opt;
  for(i=0;i<fObj.options.length;i++)
  {
    if(fObj.options[i].selected==true)
    {
      	  for(var j=0;j<tObj.length;j++){
      	  	if(fObj.options[i].text == tObj.options[j].text){
				break;
      	  	}
		  }
		  if(j==tObj.length){
		  	 opt=document.createElement("OPTION");
	     	 tObj.options.add(opt);
		 	 opt.value=fObj.options[i].value;
		  	 opt.text=fObj.options[i].text;  
		  }
   	 }   	 
  }
}
function moveRtoL(fObj,tObj){
  var i;
  var opt;
  for(i=0;i<fObj.options.length;i++)
  {
    if(fObj.options[i].selected==true)
    {
	  fObj.remove(i);
	  i--;
    }
  }
}

/**select选择的项上移*/
function up(selObj){
  var i;
  var optValue,optTxt;
  for(i=0;i<selObj.options.length;i++)
  {
    if(selObj.options[i].selected==true)
	{
	  if(i==0){return;}
	  optValue=selObj.options[i-1].value;
	  optTxt=selObj.options[i-1].text;
	  selObj.options[i-1].value=selObj.options[i].value;
	  selObj.options[i-1].text=selObj.options[i].text;
	  selObj.options[i].value=optValue;
	  selObj.options[i].text=optTxt;
	  selObj.options[i].selected=false;
	  selObj.options[i-1].selected=true;
	}
  }
}
/**select选择的项下移*/
function down(selObj){
  var i;
  var optValue,optTxt;  
  for(i=selObj.options.length-1;i>=0;i--)
  {
     
    if(selObj.options[i].selected==true)
	{
	  if(i==(selObj.options.length-1)){return;}
	  optValue=selObj.options[i+1].value;
	  optTxt=selObj.options[i+1].text;
	  selObj.options[i+1].value=selObj.options[i].value;
	  selObj.options[i+1].text=selObj.options[i].text;
	  selObj.options[i].value=optValue;
	  selObj.options[i].text=optTxt;
	  selObj.options[i].selected=false;
	  selObj.options[i+1].selected=true;
	}
  }
}

function transformValue(){
        var setForm = document.getElementById("setForm");
        if(!checkForm(setForm)) return;
		var obj =  document.getElementById("selected");
		
		var staffIds = document.getElementById("staffIds").value;
		if(staffIds==null||staffIds==""){
		   alert(v3x.getMessage("HRLang.hr_staffInfo_selectStaff_label"));
		   return;
		}
		
		var title = document.getElementById("title").value;
		if(title==null||title==""){
		   alert(v3x.getMessage("HRLang.hr_staffInfo_fillInTitle_label"));
		   return;
		}
			
		var items = '';
		for(var i=0;i<obj.options.length;i++){	
		   items = items + obj.options[i].value+',';
		}
		if(items==null||items==""){
		      alert(v3x.getMessage("HRLang.hr_staffInfo_selectItem_label"));
		      return;
		}
		 
		var page = "";
		if(document.getElementById("page").checked){
		   page = "page";
		}
		var returnValue="method=initNameList&staffIds="+encodeURI(staffIds)+"&ispage="+page+"&title="+encodeURI(title)+"&items="+items;
		//window.opener.location.href="${hrStaffURL}?method=initNameList&staffIds="+staffIds+"&ispage="+page+"&title="+encodeURI(title)+"&items="+items;
		transParams.parentWin.nameListCollBack(returnValue);
}

function setMember(elements){
    if (!elements) {
        return;
    }
    document.getElementById("people").value = getNamesString(elements);
    document.getElementById("staffIds").value = getIdsString(elements,true);

}
</script>
<title><fmt:message key="hr.nameList.set.label" bundle="${v3xHRI18N}"/></title>
</head>
<body scroll="no">


<form name="setForm" id="setForm" method="post">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="popupTitleRight">
	<tr>
		<td class="PopupTitle"><fmt:message key="hr.nameList.set.label" bundle="${v3xHRI18N}"/></td>
	</tr>
    <tr align="top">
    <td align="center">
	<table width="400" class="" align="center">
	  <tr>
	  	<td colspan="4">
	  		<fieldset class="fieldset-align">
	  			<legend><fmt:message key="hr.basic.set.label" bundle="${v3xHRI18N}"/></legend>
	  			<table>
	  			<tr>
	  				<td><fmt:message key="hr.nameList.title.label" bundle="${v3xHRI18N}"/>：</td>
	  				<td><input inputName="<fmt:message key='hr.nameList.title.label' bundle='${v3xHRI18N}'/>" type="text" size="40" name="title" id="title" validate="isWord" character="@#$%^&*|"></td>
	  			</tr>
	  			<tr>
	  				<td>
	  				<v3x:selectPeople id="member" panels="Department" selectType="Account,Department" jsFunction="setMember(elements)"/>
	  				<fmt:message key="hr.nameList.listPeople.label" bundle="${v3xHRI18N}"/>：</td>
	  				<td>
		           <input type="text" size="40" name="people" id="people" style="cursor:hand" onClick="selectPeopleFun_member()" readOnly>
		           <input type="hidden" name="staffIds" id="staffIds">
	  				</td>
	  			</tr>
	  			<tr>
	  				<td>
	  				<label for="page">
	  				<input type="checkbox" name="page" id="page"><fmt:message key="hr.nameList.pagination.label" bundle="${v3xHRI18N}"/>
	  				</label>
	  				</td>
	  			</tr>
	  			</table>
	  		</fieldset>
	  	</td>
	  </tr>
	  <tr>
	  	<td colspan="4">
	  	<br/>
	  		<fieldset class="fieldset-align">
	  			<legend><fmt:message key="hr.col.set.label" bundle="${v3xHRI18N}"/></legend>
	  		<table>
			  <tr><td align="left"><fmt:message key="hr.nameList.optionalItem.label" bundle="${v3xHRI18N}"/>
			      </td>
			      <td>
			      </td>
			      <td align="left"><fmt:message key="hr.nameList.selectedItem.label" bundle="${v3xHRI18N}"/>
			      </td>
			      <td>
			      </td>
			  </tr>
			  <tr><td id="Area1">
					 <select id="reserve" name="reserve"
					 ondblclick="moveLtoR(setForm.reserve,setForm.selected);"
					 multiple size="20" style="width:160px;">
					 <option value="1"><fmt:message key="hr.staffInfo.name.label" bundle="${v3xHRI18N}"/>
					 <option value="2"><fmt:message key="hr.staffInfo.sex.label" bundle="${v3xHRI18N}"/>
					 <option value="3"><fmt:message key="hr.staffInfo.nation.label" bundle="${v3xHRI18N}"/>
					 <option value="4"><fmt:message key="hr.staffInfo.age.label" bundle="${v3xHRI18N}"/>
					 <option value="5"><fmt:message key="hr.staffInfo.specialty.label" bundle="${v3xHRI18N}"/>
					 <option value="6"><fmt:message key="hr.staffInfo.IDcard.label" bundle="${v3xHRI18N}"/>
					 <option value="7"><fmt:message key="hr.staffInfo.edulevel.label" bundle="${v3xHRI18N}"/>
					 <option value="8"><fmt:message key="hr.staffInfo.position.label" bundle="${v3xHRI18N}"/>
					 <option value="9"><fmt:message key="hr.staffInfo.marriage.label" bundle="${v3xHRI18N}"/>
					 <option value="10"><fmt:message key="hr.staffInfo.workStartingDate.label" bundle="${v3xHRI18N}"/>
					 <option value="11"><fmt:message key="hr.staffInfo.recordWage.label" bundle="${v3xHRI18N}"/>
					 <option value="12"><fmt:message key="hr.staffInfo.memberno.label" bundle="${v3xHRI18N}"/>
					 <option value="14"><fmt:message key="hr.staffInfo.staffstate.label" bundle="${v3xHRI18N}"/>
					 <option value="15"><fmt:message key="hr.staffInfo.stafftype.label" bundle="${v3xHRI18N}"/>
					 <option value="16"><fmt:message key="hr.staffInfo.department.label" bundle="${v3xHRI18N}"/>
					 <option value="17"><fmt:message key="hr.staffInfo.postlevel.label${v3x:suffix()}" bundle="${v3xHRI18N}"/>
					 <option value="18"><fmt:message key="hr.staffInfo.primaryPostId.label" bundle="${v3xHRI18N}"/>
					 <option value="19"><fmt:message key="hr.staffInfo.secondPostId.label" bundle="${v3xHRI18N}"/>
					 <option value="20"><fmt:message key="hr.staffInfo.birthday.label" bundle="${v3xHRI18N}"/>
					 <option value="21"><fmt:message key="hr.staffInfo.worklocal.label" bundle="${v3xHRI18N}"/>
					 <option value="22"><fmt:message key="hr.staffInfo.reporter.label" bundle="${v3xHRI18N}"/>
					 </select>
				  </td>
		
			      <td width="7%" valign="middle"  align="center">
				     <p><img src="<c:url value="/common/SelectPeople/images/arrow_a.gif"/>"
				     alt='<fmt:message key="selectPeople.alt.select" bundle="${v3xHRI18N}"/>' width="24"
				     height="24" class="cursor-hand" onClick="moveLtoR(setForm.reserve,setForm.selected);"></p><br/>
				     <p><img src="<c:url value="/common/SelectPeople/images/arrow_del.gif"/>"
				     alt='<fmt:message key="selectPeople.alt.unselect" bundle="${v3xHRI18N}" />' width="24"
				     height="24" class="cursor-hand" onClick="moveRtoL(setForm.selected,setForm.reserve);"></p>
			      </td>
		
				  <td id="Area1">
					 <select id="selected" name="selected" ondblclick="moveRtoL(setForm.selected,setForm.reserve);"
					 multiple="multiple" size="20"  style="width:160px;">
					 </select>
				  </td>
				  
			      <td width="9%" valign="middle">
				     <p><img src="<c:url value="/common/SelectPeople/images/arrow_u.gif"/>"
				     alt='<fmt:message key="selectPeople.alt.up" bundle="${v3xHRI18N}"/>'width="24"
				     height="24" class="cursor-hand" onClick="up(setForm.selected)"></p><br/>
				     <p><img src="<c:url value="/common/SelectPeople/images/arrow_d.gif"/>"
				     alt='<fmt:message key="selectPeople.alt.down" bundle="${v3xHRI18N}"/>' width="24"
				     height="24" class="cursor-hand" onClick="down(setForm.selected)"></p>
			      </td>
			  </tr>
	  		</table>
	  		</fieldset>
	  	</td>
	  </tr>


	</table>
	</td>
	</tr>	  
    <tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input name="Submit" type="button" onClick="transformValue();" class="button-default-2"
				value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />"  />
			<input name="close" type="button" onclick="getA8Top().nameListWin.close();" class="button-default-2"
				value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" />
		</td>
	</tr>
    
</table>
</form>
</body>