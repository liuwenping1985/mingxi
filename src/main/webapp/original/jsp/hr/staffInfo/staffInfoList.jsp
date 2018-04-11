<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String queryString = request.getQueryString(); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
<fmt:setBundle basename="com.seeyon.v3x.plugin.ldap.resource.i18n.LDAPSynchronResources" var="ldaplocale"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>    
<script   language="JavaScript">
var queryString = "<%= queryString %>";
var onlyLoginAccount_dept=true;
getA8Top().showLocation(1202);
try {
	getA8Top().endProc();
} catch(e) {
}

function nameList(){
     getA8Top().nameListWin = getA8Top().$.dialog({
         title:" ",
         transParams:{'parentWin':window},
         url: '${hrStaffURL}?method=initSetNameList',
         width: 430,
         height: 520,
         isDrag:false
     });
}

function nameListCollBack (returnValue) {
   getA8Top().nameListWin.close();
   if(returnValue != null && returnValue != undefined){
	   window.location='${hrStaffURL}?'+returnValue;
   }
}
function query(){
     getA8Top().queryWin = getA8Top().$.dialog({
         title:" ",
         transParams:{'parentWin':window},
         url: '${hrStaffURL}?method=highLevelSerchList',
         width: 350,
         height: 430,
         isDrag:false
     });
}

function queryCallBack(returnValue) {
	getA8Top().queryWin.close();
	if(returnValue != null && returnValue != undefined){
	   window.location='${hrStaffURL}?'+returnValue;
	}
}
function viewStaffer(id){
	getA8Top().viewStafferWin = getA8Top().$.dialog({
        title:" ",
        transParams:{'parentWin':window},
        closeParam :{'show':true,handler:function(){
        	viewStafferCallBack();
        }},
        url: '${hrStaffURL}?method=initInfoHome&staffId='+id+'&isReadOnly=ReadOnly&isManager=Manager',
        width: 900,
        height: 600,
        isDrag: false
    });
}

function viewStafferCallBack () {
	getA8Top().viewStafferWin.close();
	window.location.href=window.location;
}
function add(){
  	parent.window.location='${hrStaffURL}?method=initInfoHome&isManager=Manager&isNew=New';
}
function modify(){
   if(getSelectId(this)){
 		if(checkSelectedId(this)){
			alert(v3x.getMessage("HRLang.hr_userDefined_data_choose_message"));
			return false;
		}
		var id = getSelectId(this);
	    getA8Top().viewStafferWin = getA8Top().$.dialog({
	        title:" ",
	        transParams:{'parentWin':window},
	        closeParam :{'show':true,handler:function(){
	            viewStafferCallBack();
	        }},
	        url: '${hrStaffURL}?method=initInfoHome&staffId='+id+'&isManager=Manager',
	        width: 900,
	        height: 600,
	        isDrag:false
	    });
	}else{
        alert(v3x.getMessage("HRLang.hr_staffInfo_choose_modify"));
		return;
    }
}
function Del(){
    if(getSelectIds(this)){
		if(!confirm(v3x.getMessage("HRLang.hr_staffInfo_is_delete"))){
			return;
		}
		var ids = getSelectIds(this);
		window.location='${hrStaffURL}?method=deleteStaffer&staffIds='+ids;
	}else{
		alert(v3x.getMessage("HRLang.hr_staffInfo_choose_delete"));
		return;
	}
}
//档案模板下载
function downloadTemplate() {
    var url = '${hrStaffURL}?method=downloadTemplate';
    exportIFrame.location.href = url;
}
//导出档案数据
function exportToExcel() {
    getA8Top().$.alert({
        'title': "",
        'msg': v3x.getMessage("HRLang.hr_staffInfo_attendance_record_tip"),
        ok_fn: function() {
            var theForm = document.getElementsByName("searchForm")[0];
            var condition = theForm.condition.value;
            var options = theForm.condition.options;
            var textfield = "";
            var textfield1= "";
            for (var i = 0; i < options.length; i++) {
                if (condition == options[i].value) {
                    var theDiv = document.getElementById(options[i].value + "Div");
                    if (theDiv) {
                        var childs = theDiv.childNodes;
                        for (var j = 0; j < childs.length; j++) {
                            if (childs[j].name == "textfield" && "items" != condition) {
                                	textfield = encodeURI(childs[j].value);
                            }else if(childs[j].name == "textfield1" && "items" == condition){
                                	textfield1=encodeURI(childs[j].value);
                            }
                        }
                    
                    }
                }
            }
            if("items"==condition){
            	var itemDiv = document.getElementById("textArea");
            	if(itemDiv){
            		textfield = encodeURI(itemDiv.value);
            	}
            }
            var	from = "";
            var highQueryCondition = "";
            if(queryString != "undefined" && queryString.indexOf("highLevelQueryList") != -1){
            	from = "highLevelQueryList";
            	highQueryCondition = queryString.substring(queryString.indexOf("&"));
            }
            var url = '${hrStaffURL}?method=exportStaff&condition=' + condition + '&textfield=' + textfield+ '&textfield1=' + textfield1+"&from="+from+highQueryCondition;
            exportIFrame.location.href = url;
        }
    });
}

function importExcel() {
    var dialog = getA8Top().$.dialog({
        width: 600,
        height: 400,
        isDrag: false,
        id: 'importdialog',
        url: '${hrStaffURL}?method=importToExcel&importType=member',
        title: v3x.getMessage("HRLang.hr_staffInfo_import"),
        closeParam: {
            'show': true,
            handler: function() { //关闭窗口刷新数据
                var theForm = document.getElementById("searchForm");
                theForm.submit();
            }
        }
    });
}

// 添加选人方法
function setTeamDept(elements) {
   	if (!elements) {
       	return;
   	}
   	document.getElementById("deptName").value = getNamesString(elements);
   	document.getElementById("textfields").value = getIdsString(elements, false);
}

//添加岗位方法
function setPost(elements){
    if(!elements){return;}
    document.getElementById("postName").value = getNamesString(elements);
    document.getElementById("postld").value = getIdsString(elements,false);
}

function showNextCondition(conditionObject) {
    var options = conditionObject.options;

    for (var i = 0; i < options.length; i++) {
        var d = document.getElementById(options[i].value + "Div");

        if (d) {
            d.style.display = "none";
            document.getElementById("textAreaDiv").style.display = "none";
        }
    }
    if (document.getElementById(conditionObject.value + "Div") == null) return;
    document.getElementById(conditionObject.value + "Div").style.display = "block";
    if (conditionObject.value == "items") {
		if(${empty propertylist}){
			document.getElementById(conditionObject.value + "Div").style.display = "none";
		    alert(v3x.getMessage("HRLang.hr_staffInfo_find_list_propertys_null"));
		    return;
		}
		document.getElementById("textAreaDiv").style.display = "block";
	} else {
	 	document.getElementById("textAreaDiv").style.display = "none" 
	}
}

var logWin;
function viewLog(){
	if(!logWin){
		logWin = window.open("${hrLogURL}?method=viewLog&model=staff","","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,left=220,top=150,width=750,height=500");
	}else{
		logWin.focus();
	}
}

function showTextArea(_item) {
	if (!_item && !_item.value){
		return;
	}
	document.getElementById("textAreaDiv").style.display = "block";
	document.getElementById("textArea").value = "";
    showTime();
}

function showTime(){ 
	var textArea = $("#textArea");
	var selecttype = $("#items option:selected").attr("type");
	if(selecttype == '3'){//日期类型	
		textArea.attr("onclick","whenstart('${pageContext.request.contextPath}',textArea,250,200)");		
	}else{
		textArea.attr("onclick","");
	}
}

window.onload=function(){
	showTime();
}
/**
 * 搜索按钮事件
 */
function doSearchHr() {
    var selecttype = $("#items option:selected").attr("type");
	var textAreaValue = $("#textArea").val();
	var selectoptions = $("#condition option:selected").val();
	if(selectoptions == "items"){
    	//判断整数
    	if(selecttype == "1" && !(/^-?\d+$/.test(textAreaValue))){
    		alert(v3x.getMessage("HRLang.hr_staffInfo_find_list_propertys_not_integer"));
    		return false;
    	}
    	//判断小数
    	if(selecttype == "2" && !(/^(-?\d+)(\.\d+)?$/.test(textAreaValue))){
    		alert(v3x.getMessage("HRLang.hr_staffInfo_find_list_propertys_not_decimal"));
    		return false;
    	}
	}
	doSearch();
}

</script>
</head>
<body scroll="no" class="bg-body">
<v3x:selectPeople id="dept" minSize="0" maxSize="1" panels="Department" selectType="Department" jsFunction="setTeamDept(elements)"  />
<v3x:selectPeople id="post" panels="Post" maxSize="1" selectType="Post" jsFunction="setPost(elements)" />
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
<table height="100%" width="100%" border="0" cellspacing="0"
    cellpadding="0">
    <tr>
        <td height="24">
    <script>    
    var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
    
    myBar1.add(new WebFXMenuButton("new", "<fmt:message key='hr.toolbar.salaryinfo.new.label' bundle='${v3xHRI18N}' />",  "add()", [1,1]));
    myBar1.add(new WebFXMenuButton("modify", "<fmt:message key='hr.staffInfo.modify.label' bundle='${v3xHRI18N}' />", "modify()", [1,2]));
    myBar1.add(new WebFXMenuButton("delete", "<fmt:message key='hr.toolbar.salaryinfo.delete.label' bundle='${v3xHRI18N}' />", "Del()", [1,3]));
    myBar1.add(new WebFXMenuButton("aaa", "<fmt:message key='hr.namelist.label' bundle='${v3xHRI18N}' />",  "nameList()", [1,5]));
    myBar1.add(new WebFXMenuButton("log", "<fmt:message key='hr.log.view.label' bundle='${v3xHRI18N}'/>",  "viewLog()", [6,8]));    
    myBar1.add(new WebFXMenuButton("query", "<fmt:message key='hr.toolbar.salaryinfo.advanceQuery.label' bundle='${v3xHRI18N}'/>",  "query()", [6,8])); 
    var subItems = new WebFXMenu;
    subItems.add(new WebFXMenuItem("imp", "<fmt:message key='import.excel' bundle='${v3xHRI18N}'/>",  "importExcel()", ""));
    subItems.add(new WebFXMenuItem("down","<fmt:message key='hr.staffInfo.import.template.label' bundle='${v3xHRI18N}'/>", "downloadTemplate()", ""));
    subItems.add(new WebFXMenuItem("exp", "<fmt:message key='org.post_form.export.exel' bundle='${v3xHRI18N}'/>",  "exportToExcel()", ""));
    myBar1.add(new WebFXMenuButton("impexp", "<fmt:message key='export.or.import' bundle='${v3xHRI18N}'/>",  "", [6,8],"",subItems));
    document.write(myBar1);
    document.close();
    </script>
</td>
        <td class="webfx-menu-bar" width="50%" height="100%"><form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
            <input type="hidden" value="initStaffInfoList" name="method">
            <div class="div-float-right">
                <div class="div-float margin_r_5">
                    <select name="condition" id="condition" onChange="showNextCondition(this)" class="textfield">
                        <option value=""><fmt:message key="member.list.find"/></option>
                        <option value="name"><fmt:message key="member.list.find.name"/></option>
                        <option value="loginName"><fmt:message key="member.list.find.login"/></option>
                        <option value="code"><fmt:message key="org.member_form.code"/></option>
                        <option value="orgDepartmentId"><fmt:message key="member.list.find.depart"/></option>       
                        <option value="type"><fmt:message key="org.metadata.member_type.label"/></option>
                        <option value="state"><fmt:message key="org.metadata.member_state.label"/></option>
                        <option value="orgPostId"><fmt:message key="member.list.find.mainpost"/></option>
                        <option value="orgLevelId"><fmt:message key="member.list.find.level${v3x:suffix()}"/></option>
                        <option value="items"><fmt:message key="hr.staffInfo.find.list.propertys"/></option>
                    </select>
                </div>
                <div id="nameDiv" class="div-float hidden">
                    <input type="text" name="textfield" class="textfield" onkeydown="javascript:if(event.keyCode==13)return false;">
                </div>
                <div id="orgPostIdDiv" class="div-float hidden">
                    <fmt:message key="common.default.team.value2" var="defaultPT"/>
                    <input type="hidden" name="textfield" id="postld" value="${post.id}"/>
                    <input type="text" name="textfield1" size="18" id="postName" value="<c:out value='${postName}' default='${defaultPT}' escapeXml='true' />" 
                        onclick="selectPeopleFun_post()" readonly="readonly" style="cursor:hand" validate="notNull"/>
                </div>
                <div id="orgLevelIdDiv" class="div-float hidden">
                    <select name="textfield" class="textfield">
                        <c:forEach var="level" items="${levellist}">
                            <option value="<c:out value="${level.id}"/>"><c:out value="${level.name}"/></option>
                        </c:forEach>
                    </select>
                </div>
                <div id="orgDepartmentIdDiv" class="div-float hidden">
                    <fmt:message key="common.default.team.value" var="defaultTP"/>
                    <input type="hidden" name="textfield" id="textfields" value="${department.id}" />
                    <input type="text" name="textfield1" id="deptName" 
                        value="<c:out value='${department.name}' default='${defaultTP}' escapeXml='true' />" style="cursor:hand" readonly="readonly" size="18" onclick="selectPeopleFun_dept()" defaultValue="${defaultTP}" inputName="<fmt:message key='org.team_form.part'/>" validate="notNull,isDefaultValue"
                     />
                </div>
                <div id="typeDiv" class="div-float hidden">
                    <select name="textfield" class="textfield">
                    <v3x:metadataItem metadata="${orgMeta['org_property_member_type']}" showType="option" name="type"
                      selected="${member.type}" switchType="chax"/>
                    </select>
                </div>
                <div id="stateDiv" class="div-float hidden">
                    <select name="textfield" class="textfield">
                    <v3x:metadataItem metadata="${orgMeta['org_property_member_state']}" showType="option" name="state"
                      selected="${member.state}" switchType="chax"/>
                    </select>
                </div>              
                <div id="codeDiv" class="div-float hidden">
                    <input type="text" name="textfield" class="textfield" onkeydown="javascript:if(event.keyCode==13)return false;"></div>              
                <div id="loginNameDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield" onkeydown="javascript:if(event.keyCode==13)return false;"></div>
				 
                <div id="itemsDiv" class="div-float hidden margin_r_5">
                    <select id="items" name="textfield1" class="textfield" onChange="showTextArea(this)">
                            <c:forEach var="property" items="${propertylist}">
                            <option type="${property.type}" value="<c:out value="${property.id}_${property.type}"/>"><c:out value="${property.name}"/></option>
                            </c:forEach>
                    </select>
                </div>

				<div id="textAreaDiv" class="div-float hidden">
					 <input id="textArea" type="text" name="textfield" class="textfield" 
					 onkeydown="javascript:if(event.keyCode==13)return false;">   				
                </div>	
                <div onclick="javascript:doSearchHr()" class="div-float condition-search-button"></div>
            </div></form>
        </td>
                
    </tr>
</table>    
    </div>
    <div class="center_div_row2" id="scrollListDiv">
        <form id="memberform" method="post">
        <fmt:message key='hr.staffInfo.primaryPostId.label'  bundle='${v3xHRI18N}' var="postName" scope="page"/>
        <v3x:table htmlId="memberlist" data="memberlist" var="member" className="sort ellipsis">
            <c:set var="click" value="viewStaffer('${member.v3xOrgMember.id}')"/>   
            <v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
                <input type="checkbox" name="id" value="${member.v3xOrgMember.id}">
            </v3x:column>
            
            <c:if test="${member.stateName==''||member.stateName==null}"><c:set var="showALT" value="${member.v3xOrgMember.loginName}"/></c:if>     
            <c:if test="${member.stateName!=''&&member.stateName!=null}"><c:set var="showALT" value=""/></c:if>
            
            <v3x:column width="10%" align="left" label="org.member_form.name.label" type="String" onClick="${click}"
                value="${member.v3xOrgMember.name}" className="cursor-hand sort" 
                alt="${member.v3xOrgMember.name}" />
            <v3x:column width="10%" align="left" label="org.member_form.loginName.label" type="String" onClick="${click}" className="cursor-hand sort" alt="${showALT}">
              ${member.v3xOrgMember.loginName}
                <c:if test="${member.stateName!=''&&member.stateName!=null}">
&nbsp;<img style="display:inline;vertical-align:middle;" src="<c:url value='/common/images/ldapbinding.gif'/>" title="<fmt:message key='ldap.user.prompt' bundle='${ldaplocale}'><fmt:param value='${member.stateName}'></fmt:param></fmt:message>"/>
                </c:if>
        </v3x:column>
            <v3x:column width="10%" align="left" label="org.member_form.code" type="String" onClick="${click}"
                value="${member.v3xOrgMember.code}" className="cursor-hand sort" />
                
            <v3x:column width="10%" align="left" label="common.sort.label" type="Number" onClick="${click}"
                value="${member.v3xOrgMember.sortId}" className="cursor-hand sort" />
            <v3x:column width="15%" align="left" label="org.member_form.deptName.label" type="String" onClick="${click}"
                value="${member.departmentName}" className="cursor-hand sort" 
                alt="${member.departmentName}" />
            <v3x:column width="15%" align="left" label="org.member_form.levelName.label" type="String" onClick="${click}"
                value="${member.levelName}" className="cursor-hand sort" 
                alt="${member.levelName}" />
            <v3x:column width="15%" align="left" label="${postName }" type="String" onClick="${click}"
                value="${member.postName}" className="cursor-hand sort" 
                alt="${member.postName}" />
            <v3x:column width="10%" align="left" label="org.metadata.member_type.label" type="String" onClick="${click}"
                className="cursor-hand sort" >
                <v3x:metadataItemLabel metadata="${orgMeta['org_property_member_type']}" value="${member.v3xOrgMember.type}" /> 
            </v3x:column>
            <v3x:column width="10%" align="left" label="org.metadata.member_state.label" type="String" onClick="${click}"
                className="cursor-hand sort" >
                <v3x:metadataItemLabel metadata="${orgMeta['org_property_member_state']}" value="${member.v3xOrgMember.state}"/>
            </v3x:column>
        </v3x:table></form>
    
    
    </div>
  </div>
</div>
<script type="text/javascript">
showCondition("${param.condition}", "<v3x:out value='${textfileds}' escapeJavaScript='true' />", "<v3x:out value='${textfield1s}' escapeJavaScript='true' />");
showCtpLocation("F03_hrStaff");
if("${param.condition}" == "items" && ("${textfield1s}") != ""){
	document.getElementById("textAreaDiv").style.display = "block";
	document.getElementById("textArea").value ="<v3x:out value='${param.textfield}' escapeJavaScript='true' />";	
}
</script>
 <iframe width="0" height="0" name="exportIFrame" id="exportIFrame"></iframe>
</body>
</html>