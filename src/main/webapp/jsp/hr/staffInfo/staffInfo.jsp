<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html:link renderURL="/ldap.do" var="ldapSynchron"/> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/string.extend.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/plugin/ldap/js/ldap.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var flag=false;
function setPassword() {
    document.getElementById("password").value="";
    document.getElementById("password1").value="";
}
var onlyLoginAccount_dept=true;
var onlyLoginAccount_post=true;
var onlyLoginAccount_dept4Out=true;
var onlyLoginAccount_level=true;
var onlyLoginAccount_assistantPosts=true;
var isNeedCheckLevelScope_dept= false;
var isNeedCheckLevelScope_post= false;
var isNeedCheckLevelScope_dept4Out= false;
var isNeedCheckLevelScope_level= false;
var isNeedCheckLevelScope_assistantPosts= false;
var hiddenSaveAsTeam_dept = true;
var hiddenSaveAsTeam_post = true;
var hiddenSaveAsTeam_level = true;
var hiddenSaveAsTeam_dept4Out = true;
var hiddenSaveAsTeam_assistantPosts = true;
var quantity = null;
var url = null;
function uploadPhoto () { 
    url = downloadURL;
    quantity = fileUploadQuantity;
    var attachments = fileUploadAttachments;
    oldSize = fileUploadAttachments.size();
    downloadURL = "<html:link renderURL='/fileUpload.do?type=5&applicationCategory=0&extensions=jpeg,jpg,png,gif&maxSize=5242880&quantity=1'/>";
    fileUploadQuantity = 1;
    insertAttachment(null, null, 'callbackUploadUserPhoto', 'false');
    downloadURL = url;
}

function callbackUploadUserPhoto () { 
    var newSize = fileUploadAttachments.size();
    if(newSize != oldSize){
        var imgAttId = fileUploadAttachments.keys().get(fileUploadAttachments.size()-1);//获得上传图片ID
        document.getElementById("imageId").value = imgAttId;
        //获取图片的日期
        var createDate = fileUploadAttachments.get(imgAttId).createDate;
        var imgSrc = "/seeyon/fileUpload.do?method=showRTE&fileId="+imgAttId+"&createDate="+createDate+"&type=image";
        document.getElementById("showimg").src=imgSrc;
        
    }
    downloadURL = url;
    fileUploadQuantity = quantity;
}

/**
 * 人员管理FORM 系统权限设置弹出窗口
 */
function setMenuSecurity(linkURL){
    var securityIdsObj = document.getElementById("securityIds");
    if(securityIdsObj){
        linkURL += "&securityIds=" + securityIdsObj.value;
    }
    var result = v3x.openWindow({
        url     : linkURL,
        width   : 200,
        height  : 300,
        resizable   : "yes"
    }); 
    if(!result){
        return ;
    }
    document.all.securityIds.value = result[0];
    document.all.securityNames.value = result[1];
}
/**
 * 人员默认菜单权限切换
 * isOut 是否是外部人员
 */
//内部人员默认的权限
var defaultMenuRight = '${securityNames}|${securityIds}';
var defaultOutRight = '${outerSecurityName}|${outerSecurityId}';
function getDefaultMenu(isOut){
    if(isOut){
        if(defaultOutRight || defaultOutRight.length !=1){
            var right = defaultOutRight.split('|')
            document.all.securityIds.value = right[1];
            document.all.securityNames.value = right[0];
        }
    }else{
        if(defaultMenuRight){
            var right = defaultMenuRight.split('|');
            document.all.securityIds.value = right[1];
            document.all.securityNames.value = right[0];
        }
    }
}

//4.11号改弹出窗口去掉当前位置

    //if(${Manager}){
     //  getA8Top().showLocation(null, getA8Top().findMenuName(12), getA8Top().findMenuItemName(1202), "<fmt:message key='hr.staffInfo.label' bundle='${v3xHRI18N}'/>");
    //}
    //else{
      // getA8Top().showLocation(null, getA8Top().findMenuName(8), getA8Top().findMenuItemName(801), "<fmt:message key='hr.staffInfo.label' bundle='${v3xHRI18N}'/>");
    //}


function modify(){
    window.location.href="${hrStaffURL}?method=initStafferInfo&isManager=${isManager}&staffId="+document.getElementById("staffId").value;
}
function cancel(){
	var isNew = '${isNew}';
	if(isNew!='New'){
	    window.location.href="${hrStaffURL}?method=initStafferInfo&isReadOnly=ReadOnly&isManager=Manager&staffId="+document.getElementById("staffId").value;
	}else{
     	parent.window.location.href="${hrStaffURL}?method=initStaffListFrame";//新建不是弹出
	}
   
}

function changeState(){
      var state = document.getElementById("state").value;
      if(state=='1'){
        if(confirm(v3x.getMessage("organizationLang.orgainzation_employ_memeber"))){
          document.getElementById("enabled1").checked = true;
          document.getElementById("enabled2").checked = false;
        }
      }else if(state=='2'){
        if(document.getElementById("enabled1").checked){
          alert(v3x.getMessage("organizationLang.orgainzation_umemploy_memeber"));
          document.getElementById("enabled1").checked = false;
          document.getElementById("enabled2").checked = true;
        }
      }
}

/*
    身份证验证
*/
//--身份证号码验证-支持新的带x身份证
function isIdCardNo(num) 
{

    var factorArr = new Array(7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2,1);
    var error;
    var varArray = new Array();
    var intValue;
    var lngProduct = 0;
    var intCheckDigit;
    var intStrLen = num.length;
    var idNumber = num;    
    var aCity ={11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江",31:" 上海",32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北",43:" 湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏",61:" 陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外"};
    

    if ((intStrLen != 15) && (intStrLen != 18)) {       
        alert(v3x.getMessage("HRLang.hr_staffInfo_IDcard_notLegal"));  
        return false;
    }    
    for(i=0;i<intStrLen;i++) {
        varArray[i] = idNumber.charAt(i);
        if ((varArray[i] < '0' || varArray[i] > '9') && (i != 17)) {           
            alert(v3x.getMessage("HRLang.hr_staffInfo_IDcard_wrongNum_label"));
            return false;
        } else if (i < 17) {
            varArray[i] = varArray[i]*factorArr[i];
        }
    }
    if (intStrLen == 18) {    
    //地区判断
        idNumber=idNumber.replace(/x$/i,"a");
        //非法地区
        if(aCity[parseInt(idNumber.substr(0,2))]==null)
        {
                alert(v3x.getMessage("HRLang.hr_staffInfo_IDcard_notLegal"));
                return false;
        }
    //生日判断
        var sBirthday=idNumber.substr(6,4)+"-"+Number(idNumber.substr(10,2))+"-"+Number(idNumber.substr(12,2));

        var d=new Date(sBirthday.replace(/-/g,"/"))
        
        //非法生日
        if(sBirthday!=(d.getFullYear()+"-"+ (d.getMonth()+1) + "-" + d.getDate()))
        {   
                alert(v3x.getMessage("HRLang.hr_staffInfo_IDcard_notLegal"));
                return false;
        }        
        for(i=0;i<17;i++) {
            lngProduct = lngProduct + varArray[i];
        }        
        intCheckDigit = 12 - lngProduct % 11;
        switch (intCheckDigit) {
            case 10:
                intCheckDigit = 'X';
                break;
            case 11:
                intCheckDigit = 0;
                break;
            case 12:
                intCheckDigit = 1;
                break;
        }        
        if (varArray[17].toUpperCase() != intCheckDigit) {
            //alert("身份证效验位错误!...正确为： " + intCheckDigit + "!");
            alert(v3x.getMessage("HRLang.hr_staffInfo_IDcard_notLegal"));
            return false;
        }
    } 
    else{        //length is 15        
        var date6 = idNumber.substring(6,12);
        if (checkDate(date6) == false) {
            alert(v3x.getMessage("HRLang.hr_staffInfo_IDcard_notLegal"));
            return false;
        }
    }
   
    return true;
    
}

function checkDate(date)
{
    return true;
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function sub(){//确定提交方法
    var manager = ${Manager};
    ajax_logName();
    if(!manager){
      saveAttachment();
      staffInfoForm.submit();
      return true;
    }
   // TODO 原始代码  if(validateName()&&validatePassword()&&checkForm(staffInfoForm)&&checkWage()) TODO 原因 validateName（）方法被注释
    if(flag&&validatePassword()&&checkForm(staffInfoForm)&&checkWage()){


        var num = document.getElementById("ID_card").value ;
       if(num!=null && num!=""){

          if(!isIdCardNo(num)){//身份证验证！
            return;
          }
       }  
       saveAttachment();
       //点击toolbar新建,提交到当前页
       var isNew = '${isNew}';
       document.getElementById("submintButton").disabled = true;
       document.getElementById("submintCancel").disabled = true;
       if(isNew=='New'){
       staffInfoForm.target="_self";
       saveAttachment();
       staffInfoForm.submit();
       }else{
       //模态窗口,提交到hiddenIframe
       staffInfoForm.target="hiddenIframe";
       saveAttachment();
       staffInfoForm.submit();
       }
    }
}
function nameOr(){
	var names = document.getElementById("name").value;
	var  p =new Array ( "﹉", "＃", "＠", "＆", "＊", "※", "§", "〃", "№", "〓", "○",
			  "●", "△", "▲", "◎", "☆", "★", "◇", "◆", "■", "□", "▼", "▽",
			  "㊣", "℅", "ˉ", "￣", "＿", "﹍", "﹊", "﹎", "﹋", "﹌", "﹟", "﹠",
			  "﹡", "♀", "♂", "?", "⊙", "↑", "↓", "←", "→", "↖", "↗", "↙",
			  "↘", "┄", "—", "︴", "﹏", "（", "）", "︵", "︶", "｛", "｝", "︷",
			  "︸", "〔", "〕", "︹", "︺", "【", "】", "︻", "︼", "《", "》", "︽",
			  "︾", "〈", "〉", "︿", "﹀", "「", "」", "﹁", "﹂", "『", "』", "﹃",
			  "﹄", "﹙", "﹚", "﹛", "﹜", "﹝", "﹞", "\"", "〝", "〞", "ˋ",
			  "ˊ", "≈", "≡", "≠", "＝", "≤", "≥", "＜", "＞", "≮", "≯", "∷",
			  "±", "＋", "－", "×", "÷", "／", "∫", "∮", "∝", "∧", "∨", "∞",
			  "∑", "∏", "∪", "∩", "∈", "∵", "∴", "⊥", "∥", "∠", "⌒", "⊙",
			  "≌", "∽", "√", "≦", "≧", "≒", "≡", "﹢", "﹣", "﹤", "﹥", "﹦",
			  "～", "∟", "⊿", "∥", "㏒", "㏑", "∣", "｜", "︱", "︳", "|", "／",
			  "＼", "∕", "﹨", "¥", "€", "￥", "£", "®", "™", "©", "，", "、",
			  "。", "．", "；", "：", "？", "！", "︰", "…", "‥", "′", "‵", "々",
			  "～", "‖", "ˇ", "ˉ", "﹐", "﹑", "﹒", "·", "﹔", "﹕", "﹖", "﹗",
			  "-", "&", "*", "#", "`", "~", "+", "=", "(", ")", "^", "%",
			  "$", "@", ";", ",", ":", "'", "\\", "/", ".", ">", "<",
			  "?", "!", "[", "]", "{", "}" );
	for (var j = 0; j < p.length; j++) {
		   if (names.indexOf(p[j]) != -1) {
		    alert(v3x.getMessage("HRLang.hr_name_special_characters")+p[j]);
		    return false;
			}
	}
	return true;
	

}
function ajax_logName(){       
        var name=document.getElementById("loginName").value;//姓名
        var datas={logName:name};
        var oldName ='${member.loginName}';
    	if(name!=''&&name!=oldName){
        $.post(hrStaffURL+'?method=ajaxLogname',datas,function (json){
            var jso=eval(json);

              if(json.indexOf("true")>0)
                {
            	  alert(v3x.getMessage("HRLang.hr_staffInfo_checkname_label",jso[0].namme));
                   flag= false;
                }else{
                	
                       flag= true;
                 }
        });
    	}else{
    		flag= true;	
    	}
    	
    
}
function validateName(){
    var memberNameValue = document.getElementById("loginName").value;
            if(memberNameValue==""){
                alert(v3x.getMessage("HRLang.hr_staffInfo_loginName_notNull_label"));
                return false;
            }
            if ("${member.loginName}" != memberNameValue){
                var requestCaller = new XMLHttpRequestCaller(this, "ajaxOrgManagerDirect", "isPropertyDuplicated", false);
                requestCaller.addParameter(1, "String", "JetspeedPrincipal");
                requestCaller.addParameter(2, "String", "fullPath");
                requestCaller.addParameter(3, "String", memberNameValue);
                var isDbName = requestCaller.serviceRequest();
                if (isDbName=="true"){
                    var requestCaller1 = new XMLHttpRequestCaller(this, "ajaxOrgManager", "isAdministrator", false);
                    requestCaller1.addParameter(1, "String", memberNameValue);
                    var isAdmin = requestCaller1.serviceRequest();
                    if(isAdmin=="true"){
                        var requestCaller4 = new XMLHttpRequestCaller(this, "ajaxOrgManager", "getAccountByLoginName", false);
                        requestCaller4.addParameter(1, "String", memberNameValue);
                        var accountBylonginName = requestCaller4.serviceRequest();
                        var accountLongName = accountBylonginName.get("N");
                        if(accountLongName!=null){
                            alert(v3x.getMessage("HRLang.hr_staffInfo_login_account_name",accountBylonginName.get("N")));
                        }
                        else{
                            alert(v3x.getMessage("HRLang.hr_staffInfo_login_system_name"));
                        }
                    }
                    else{
                        var requestCaller2 = new XMLHttpRequestCaller(this, "ajaxOrgManagerDirect", "toValidateName", false);
                        requestCaller2.addParameter(1, "String", memberNameValue);
                        var toValidateName = requestCaller2.serviceRequest();
                        if(toValidateName!=null){
                            var name = toValidateName[0];
                            var accountId = toValidateName[1];
                            var requestCaller3 = new XMLHttpRequestCaller(this, "ajaxOrgManagerDirect", "getAccountById", false);
                            requestCaller3.addParameter(1, "Long", accountId);
                            var account = requestCaller3.serviceRequest();
                            if(account!=null){
                                alert(v3x.getMessage("HRLang.hr_staffInfo_longin_name",account.get("N"),name));
                            }
                        }
                    } 
                } 
                else{
                    return true;
                }
            }
            else{
                return true;
            }
}

function validatePassword(){
    var password = document.getElementById("password").value;
    var password1 = document.getElementById("password1").value;
       if(password==""){
          alert(v3x.getMessage("HRLang.hr_staffInfo_password_notNull_label"));
          return false;
       }
       else if(password1==""){
          alert(v3x.getMessage("HRLang.hr_staffInfo_passwordValidate_notNull_label"));
          return false;
       }     
       else if(password!=password1){
          alert(v3x.getMessage("HRLang.hr_staffInfo_password_notSame_label"));
          return false;
       }else if(password.length <6 || password.length >50){
          alert(v3x.getMessage("HRLang.hr_staffInfo_member_password_limited"));
          return false;
       }else{
            return true;
       }
}
function checkWage(){
   var wage = document.getElementById("recordWage").value;
   if(parseFloat(wage,10)!=(wage*1)&&wage!=""){
      alert(v3x.getMessage("HRLang.hr_date_error_message"));
      return false;
   }
   return true;
}
function memberSelectDepartment(){
    try{
    	parent.selectType = "dept";
        parent.selectPeopleFun_dept();//定义在父页面 infohome.jsp
    }catch(e){alert(e.message)}
}
function setSelectPeopleNameFun (selectType){
	if(parent.dept_flag || parent.post_flag || parent.level_flag || parent.secondPost_flag){
		if (selectType == 'dept') {
			document.getElementById("dept_name").value = parent.Full_valueName ; 
	        document.getElementById("orgDepartmentId").value = parent.Full_valueId ;
	    } else if (selectType == 'leve') {
	    	document.getElementById("level_name").value = parent.Full_valueName ; 
            document.getElementById("orgLevelId").value = parent.Full_valueId ;
	    } else if (selectType == 'post') {
	    	document.getElementById("primary_post_name").value = parent.Full_valueName ; 
            document.getElementById("orgPostId").value = parent.Full_valueId ;
	    } else if (selectType == 'AssistantPosts') {
	    	document.getElementById("second_post_name").value = parent.Full_valueName ; 
            document.getElementById("second_post_ids").value = parent.Full_valueId ;
	    }
	}
	parent.selectType = "";
}


function memberSelectLevel(){
	parent.selectType = "leve";
    parent.selectPeopleFun_level();
}

function memberSelectPost(){
	parent.selectType = "post";
    parent.selectPeopleFun_post();
}

function memberSelectAssistantPosts(){
	parent.selectType = "AssistantPosts";
    parent.selectPeopleFun_assistantPosts();
}

//没用到
function setMember(elements){   
    if (!elements) {
        return;
    }   
    var idsString =  getIdsString(elements,false);
    if(idsString.indexOf(",")!=-1)  {
      alert(v3x.getMessage("HRLang.hr_record_staffName_onlyOne"));
      return;
    }
    window.location.href="${hrStaff}?method=initStafferInfo&staffId="+getIdsString(elements,false);

}

function disabledElements(value){
    if (value==1) {
       document.staffInfoForm.loginName.disabled = false;
       document.staffInfoForm.password.disabled = false;
       document.staffInfoForm.password1.disabled = false;
       document.staffInfoForm.enabled["0"].disabled = false;
       document.staffInfoForm.enabled["1"].disabled = false;
    } else {
       document.staffInfoForm.loginName.disabled = true;
       document.staffInfoForm.password.disabled = true;
       document.staffInfoForm.password1.disabled = true;
       document.staffInfoForm.enabled["0"].disabled = true;
       document.staffInfoForm.enabled["1"].disabled = true;
       document.staffInfoForm.loginName.value = "";
       document.staffInfoForm.password.value = "";
       document.staffInfoForm.password1.value = "";
       document.staffInfoForm.enabled["0"].checked = false;
       document.staffInfoForm.enabled["1"].checked = false;
    }
}

function selectDateTime(whoClick,width,height){
   var history = whoClick.value;
   whenstart('${pageContext.request.contextPath}', whoClick, width, height);
   var date = whoClick.value;
   var newDate = new Date();
   var strDate = newDate.getYear()+"-"+(newDate.getMonth()+1)+"-"+newDate.getDate();
   
} 

function changeIntenal(){
      document.getElementById("dept_name").value="";
      document.getElementById("orgDepartmentId").value="";
      var isOut = document.getElementById("radioisI2").checked;
      if(isOut){
          document.getElementById("intenalDiv").style.display = "none";
          document.getElementById("primary_post_name").value = "";
          document.getElementById("primary_post_name").validate = "";
          document.getElementById("orgPostId").value = "";
         // document.getElementById("level_name").value = "";
         // document.getElementById("level_name").validate = "";
          document.getElementById("orgLevelId").value = "";
          getDefaultMenu(true);
      }else{
          document.getElementById("intenalDiv").style.display = "";
          document.getElementById("primary_post_name").validate = "notNull";
          //document.getElementById("level_name").validate = "notNull";
          getDefaultMenu(false);
      }
    }
    
/**
 * 是否是数字、字母、下划线和点
 */
function isCriterionWord4Member(element){
    var value = element.value;
    var inputName = element.getAttribute("inputName");

    if(!testRegExp(value, '^[\\w-.]+$')){
        writeValidateInfo(element, v3x.getMessage("HRLang.hr_validate_isCriterionWord4Member", inputName));
        return false;
    }else{
        if(value.indexOf('.')== 0 ||value.lastIndexOf('.') == value.length-1){
            writeValidateInfo(element, v3x.getMessage("HRLang.hr_validate_start_or_end", inputName));
            return false;       
        }
    }   
    return true;
};

function setLoginName(){
    if('${isNew}' != 'New'){
        if('${ReadOnly}' != 'true'){
            if(confirm(v3x.getMessage("HRLang.hr_member_change_loginName"))){
                $("#loginName").attr("onfocus", "");
                document.getElementById("loginName").readOnly = false;
                <c:if test="${editstate==null||!isModify}">
                document.getElementById("password").value="";
                document.getElementById("password1").value="";
                </c:if>
                document.getElementById("loginName").focus();
            }else{
                document.getElementById("loginName").readOnly = true;
                document.getElementById("loginName").value = "${member.loginName}";
                document.getElementById("password").value = "${member.password}";
                document.getElementById("password1").value = "${member.password}";
                document.getElementById("loginName").blur();
            }
        }
    }       
}

function changeState(){
      var state = document.getElementById("state").value;
      if(state=='1'){
        if(confirm(v3x.getMessage("HRLang.hr_employ_memeber"))){
          document.getElementById("enabled1").checked = true;
          document.getElementById("enabled2").checked = false;
        }
      }else if(state=='2'){
        if(document.getElementById("enabled1").checked){
          alert(v3x.getMessage("HRLang.hr_umemploy_memeber"));
          document.getElementById("enabled1").checked = false;
          document.getElementById("enabled2").checked = true;
        }
      }
}

function enabledMem(){
      var state = document.getElementById("state").value;
      if(state == '2'&&document.getElementById("enabled1").checked){
        alert(v3x.getMessage("HRLang.hr_unemploy_enable_memeber"));
        document.getElementById("enabled1").checked = false;
        document.getElementById("enabled2").checked = true;
      }
}
</script>

<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources" var="v3xOrgI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<fmt:message key="common.data.pattern" var="dataPattern" bundle="${v3xCommonI18N}"/>
<fmt:setBundle basename="com.seeyon.v3x.localeselector.resources.i18n.LocaleSelectorResources" var="localeI18N"/>

<c:set var="dis" value="${v3x:outConditionExpression(ReadOnly, 'disabled', '')}" />
<c:set var="ro" value="${v3x:outConditionExpression(ReadOnly, 'readOnly', '')}" />
<c:set var="mdis" value="${v3x:outConditionExpression(!Manager, 'disabled', '')}" />
<c:set var="mro" value="${v3x:outConditionExpression(!Manager, 'readOnly', '')}" />

</head>
<body id="bodyID" scroll="auto" bgcolor="#F6F6F6" onload="loadFun()">

	<v3x:selectPeople id="member" panels="Department" selectType="Member"
		jsFunction="setMember(elements)" />


	<iframe name="hiddenIframe" id="hiddenFrame" width="0" height="0"
		frameborder="0"></iframe>
	<form id="formID" name="staffInfoForm" action="${hrStaffURL}?method=updateStaffer"
		method="post" onsubmit="return checkForm(this)" style="height:100%;"
		enctype="multipart/form-data" target="_self">
		<table border="0" cellpadding="0" cellspacing="0" width="100%"
			height="100%" align="center" class="categorySet-bg">
			<tr>
				<td height="26"><script>
    var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />", "gray");
    if(${isNew==""}||${isNew==null}){
        if(${Manager}){
        myBar1.add(new WebFXMenuButton("modify", "<fmt:message key='hr.staffInfo.modify.label' bundle='${v3xHRI18N}' />", "modify()", "<c:url value='/common/images/toolbar/update.gif'/>", "", null));  
        }
        myBar1.enabled('modify');
    }
    //WebFXMenuButton对象参数：（HtmlId, 显示名称, 按钮事件, 图标, alt/title, 子菜单）
    document.write(myBar1);
    document.close();   
    </script></td>
			</tr>
			<tr>
				<td class="categorySet-4" height="8"></td>
			</tr>
			<tr>
				<td class="categorySet-head" height="23">
					<table width="100%" height="100%" border="0" cellspacing="0"
						cellpadding="0">
						<tr>
							<td class="categorySet-1" width="4"></td>
							<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message
									key="hr.staffInfo.label" bundle="${v3xHRI18N}" /></td>
							<td class="categorySet-2" width="7"></td>
							<td class="categorySet-head-space">&nbsp; <c:if
									test="${!ReadOnly}">
									<font color="red">*</font>
									<fmt:message key="hr.staffInfo.levelMustWrite.label"
										bundle="${v3xHRI18N}" />
								</c:if>
							</td>

						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="categorySet-head">
					<div class="categorySet-body">

						<table width="100%" border="0" cellspacing="0" cellpadding="0"
							align="center">
							<input type="hidden" id="isNew" name="isNew" value="${isNew}">
							<input type="hidden" id="isManager" name="isManager"
								value="${isManager}">
							<tr>
								<td width="50%" valign="top">
									<table width="95%" border="0" cellspacing="0" cellpadding="0"
										align="center">
										<tr>
											<td class="bg-gray">
												<div class="hr-blue-font">
													<strong> <fmt:message
															key="hr.staffInfo.Basic.Information.label"
															bundle="${v3xHRI18N}" />
													</strong>
												</div>
											</td>
											<td class="new-column">&nbsp;</td>
										</tr>
										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap">&nbsp;</td>
											<td class="new-column" width="75%" nowrap="nowrap">
												<table border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td class="new-column" width="25%" nowrap="nowrap">
															<div
																style="border: 1px #CCC solid; width: 106px; height: 126px; text-align: center; background-color: #FFF;">
																<div id="thePicture"
																	style="width: 100px; height: 120px; margin-top: 2px; text-align: center;">
																	<c:choose>
																	
																		<c:when test="${image == '0'}">
																			<img id="showimg"
																				src="${pageContext.request.contextPath }${imgsrc}"
																				width="100" height="120" />
																		</c:when>
																		<c:otherwise>
																			<img id="showimg"
																				src="<c:url value="/apps_res/v3xmain/images/personal/pic.gif" />"
																				width="100" height="120" />
																		</c:otherwise>
																	</c:choose>
																</div>
															</div>
														</td>
														<td class="new-column" width="75%" nowrap="nowrap"
															align="left"><c:if test="${!ReadOnly && Manager}">
																<strong><fmt:message
																		key="hr.staffInfo.currentPhoto.label"
																		bundle="${v3xHRI18N}" /></strong>
																<br>
																<br>
																<br>
																<font class="description-lable">100*120px</font>
																<br>
																<br>
																<div id="upfile">
                                                                    <input type="hidden" name="imageId" id="imageId" value="${imageId}"/>
                                                                    <input type="button" onclick="uploadPhoto()" class="button-default-2" value="选择文件"/>
																</div>
															</c:if></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td colspan="2"><br></td>
										</tr>
										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap"><font
												color="red">*</font>
											<fmt:message key="hr.staffInfo.name.label"
													bundle="${v3xHRI18N}" />:</td>
											<td class="new-column" width="75%" nowrap="nowrap"><input
												type="hidden" id="staffId" name="staffId"
												value="${member.id}"> <input type="text" id="name"
												name="name" class="input-100per" maxSize="40" maxlength="40"
												validate="notNull,maxLength,isWord" character="><|,"
												inputName="<fmt:message key="hr.staffInfo.name.label"  bundle="${v3xHRI18N}"/>"
												value="${v3x:toHTML(member.name)}" ${ro} ${mdis} /></td>
										</tr>
										<tr>
											<td class="bg-gray" nowrap="nowrap"><fmt:message
													key="hr.staffInfo.sex.label" bundle="${v3xHRI18N}" />:</td>
											<td class="new-column" nowrap="nowrap"><select
												class="input-100per" id="gender" name="gender" ${dis}
												${mdis}>
													<option value="-1" />
													<v3x:metadataItem metadata="${hrMetadata['hr_sex_type']}"
														showType="option" name="gender"
														selected="${member.gender}" />
											</select></td>
										</tr>
										<tr>
											<td class="bg-gray" nowrap="nowrap"><fmt:message
													key="hr.staffInfo.nation.label" bundle="${v3xHRI18N}" />:</td>
											<td class="new-column" nowrap="nowrap"><input
												type="text" id="nation" maxlength="250" name="nation"
												class="input-100per" value="${v3x:toHTML(staff.nation)}" ${ro} ${mdis} />
											</td>
										</tr>
										<tr>
											<td class="bg-gray" nowrap="nowrap"><fmt:message
													key="hr.staffInfo.birthplace.label" bundle="${v3xHRI18N}" />:
											</td>
											<td class="new-column" nowrap="nowrap"><input
												type="text" id="birthplace" maxlength="250"
												name="birthplace" class="input-100per"
												value="${v3x:toHTML(staff.birthplace)}" ${ro} ${mdis} /></td>
										</tr>
										<c:if test="${ReadOnly}">
											<tr class="hidden">
												<td class="bg-gray" nowrap="nowrap"><fmt:message
														key="hr.staffInfo.age.label" bundle="${v3xHRI18N}" />:</td>
												<td class="new-column" nowrap="nowrap"><input
													type="text" id="age" name="age" class="input-100per"
													value="${v3x:toHTML(staff.age)}" ${ro} ${mdis} /></td>
											</tr>
										</c:if>

										<tr>
											<td class="bg-gray" nowrap="nowrap"><fmt:message
													key="hr.staffInfo.usedname.label" bundle="${v3xHRI18N}" />:
											</td>
											<td class="new-column" nowrap="nowrap"><input
												type="text" id="usedname" maxlength="250" name="usedname"
												class="input-100per" value="${v3x:toHTML(staff.usedname)}" ${ro} ${mdis} />
											</td>
										</tr>
										<tr>
											<td class="bg-gray" nowrap="nowrap"><fmt:message
													key="hr.staffInfo.birthday.label" bundle="${v3xHRI18N}" />:
											</td>
											<td class="new-column" nowrap="nowrap"><input
												type="text" name="birthday" id="birthday"
												class="input-100per"
												onClick="whenstart('${pageContext.request.contextPath}', this, 175, 140);"
												readonly ${mdis}${dis}
                  value="<fmt:formatDate value="${member.birthday}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>">
											</td>
										</tr>
										<tr>
											<td class="bg-gray" nowrap="nowrap"><fmt:message
													key="hr.staffInfo.IDcard.label" bundle="${v3xHRI18N}" />:</td>
											<td class="new-column" nowrap="nowrap"><input
												type="text" id="ID_card" name="ID_card" class="input-100per"
												inputName="<fmt:message key="hr.staffInfo.IDcard.label"  bundle="${v3xHRI18N}"/>"
												value="${v3x:toHTML(staff.ID_card)}" ${ro} ${mdis} /></td>
										</tr>
										<tr>
											<td colspan='2'>&nbsp;</td>
										</tr>
										<tr>
									</table>

									<table width="95%" border="0" cellspacing="0" cellpadding="0"
										align="center">
										<tr>
											<td class="bg-gray">
												<div class="hr-blue-font">
													<strong><fmt:message
															key="org.member_form.system_fieldset.label" /></strong>
												</div>
											</td>
											<td class="new-column">&nbsp;</td>
										</tr>
										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap"><label
												for="member.loginName"><font color="red">*</font>
												<fmt:message key="org.member_form.loginName.label" />:</label></td>
											<td class="new-column" width="75%" nowrap="nowrap"><input
												class="input-100per" type="text" maxlength="250"
												name="loginName" ${ro} ${mdis} maxSize="100" maxLength="100"
												id="loginName" value="${v3x:toHTML(member.loginName)}"
												validate="notNull,isWord" character='\/:*?"<>|&$%'
												onfocus="setLoginName();"
												inputName="<fmt:message key="org.member_form.loginName.label" />"
												onblur="ajax_logName()" /></td>
										</tr>
										<%--<c:if test="${hasLDAPAD}">
											<fmt:setBundle
												basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources" />
											<tr <c:if test="${editstate}">style="display: none;"</c:if>>
												<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message
														key="ldap.lable.type" />:</td>
												<td class="new-column" width="75%" nowrap="nowrap"><label
													for="ldapType1"> <input id="ldapType1" type="radio"
														name="ldapType" value="1" onclick="hiddenEntry()" ${dis}
														${mdis} />
													<fmt:message key="ldap.lable.new" />
												</label> <label for="ldapType2"> <input id="ldapType2"
														type="radio" name="ldapType" value="0"
														onclick="showEntry()" ${dis} ${mdis} checked="checked" />
													<fmt:message key="ldap.lable.select" />
												</label></td>
											</tr>
											<tr
												<c:if test="${addstate && editstate != null}">style="display: none;"</c:if>
												id="entryLable">
												<td class="bg-gray" width="25%" nowrap="nowrap"><label
													for="member.password"><font color="red">*</font>
													<fmt:message key="ldap.lable.entry" />:</label></td>
												<td class="new-column" width="75%" nowrap="nowrap"><input
													class="input-100per" type="text" name="ldapUserCodes"
													${dis} ${mdis} id="ldapUserCodes"
													value="<c:out value="${v3x:toHTML(ldapADLoginName)}" escapeXml="true" default=""/>"
													<c:if test="${editstate || addstate !=null}">validate="notNull"</c:if>
													inputName="<fmt:message
                    key="ldap.lable.entry" />"
													onclick="openUserTree('${editstate}','${isModify}')"
													readonly /></td>
											</tr>
											<tr
												<c:if test="${editstate || addstate != null}">style="display: none;"</c:if>
												id="newEntryLable">
												<fmt:setBundle
													basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"
													var="organizationResources" />
												<td class="bg-gray" width="25%" nowrap="nowrap"><label
													for="member.password"><fmt:message
															key="ldap.lable.node" bundle="${organizationResources}" />:</label></td>
												<td class="new-column" width="75%" nowrap="nowrap"><input
													class="cursor-hand input-100per" type="text"
													name="selectOU" id="selectOU" value="" onclick="openLdap()" /></td>
											</tr>
										</c:if> --%>
										<c:if test="${Manager}">
											<tr>
												<td class="bg-gray" width="25%" nowrap="nowrap"><label
													for="member.password"><font color="red">*</font>
													<fmt:message key="org.member_form.password.label" />:</label></td>
												<td class="new-column" width="75%" nowrap="nowrap"><input
													<c:if test="${editstate!=null&&isModify}">disabled</c:if>
													class="input-100per" type="password" name="password" ${ro}
													${mdis} id="password"
													value="${v3x:toHTML(member.password =='' ?'123456':member.password)}"
													inputName="<fmt:message key="org.member_form.password.label" />" /></td>
											</tr>
											<tr>
												<td class="bg-gray" width="25%" nowrap="nowrap"><label
													for="member.password1"><font color="red">*</font>
													<fmt:message key="org.account_form.adminPass1.label" />:</label></td>
												<td class="new-column" width="75%" nowrap="nowrap"><input
													<c:if test="${editstate!=null&&isModify}">disabled</c:if>
													class="input-100per" type="password" name="password1" ${ro}
													${mdis} id="password1"
													value="${v3x:toHTML(member.password==''?'123456':member.password)}"
													inputName="<fmt:message key="org.account_form.adminPass1.label" />" /></td>
											</tr>
										</c:if>
										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message
													key="organization.member.state" />:</td>
											<td class="new-column" width="75%" nowrap="nowrap"><c:set
													value="${member.enabled ? 'checked' : ''}" var="c" /> <c:set
													value="${!member.enabled ? 'checked' : ''}" var="d" /> <c:set
													value="${v3x:outConditionExpression(!member.enabled, 'disabled', '')}"
													var="rdis" /> <label for="enabled1"> <input
													type="radio" name="enabled" id="enabled1" value="1" ${c}
													${dis} ${mdis} onclick="enabledMem()" /> <fmt:message
														key="common.state.normal.label" bundle="${v3xCommonI18N}" />
											</label> <label for="enabled2"> <input type="radio"
													name="enabled" id="enabled2" value="0" ${d} ${dis} ${mdis} />
													<fmt:message key="common.state.invalidation.label"
														bundle="${v3xCommonI18N}" />
											</label></td>
										</tr>

										<!--系统权限  
            <tr>
                <td class="bg-gray" width="25%" nowrap="nowrap">
                <font color="red">*</font><fmt:message key="hr.system_security.label"  bundle="${v3xHRI18N}"/>:</td>
                <td class="new-column" width="75%" nowrap="nowrap">
                    <input class="cursor-hand input-100per" type="text" name="securityNames" value="${v3x:toHTML(securityNames)}" readonly="readonly" ${dis} onclick="setMenuSecurity('<html:link renderURL="/menuManager.do"/>?method=showAllMenuSecurity&memberId=${param.id}')" ${ro} validate="notNull" inputName="<fmt:message key="hr.system_security.label"  bundle="${v3xHRI18N}"/>" />
                    <input type="hidden" id="securityIds" name="securityIds" value="${securityIds}"/>
                </td>
            </tr>
            -->
										<%-- <tr>
                <td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message key="org.member_form.space.label"/>:</td>
                <td class="new-column" width="75%" nowrap="nowrap">
                    <select name="spaceId" class="input-100per" ${dis}>
                    <c:forEach var="space" items="${spaceList}">
                        <option value="${space.id}" ${currentSpaceId == space.id?'selected':''}>${space.name }</option>
                    </c:forEach>
                    </select>
                </td>
            </tr>
            --%>
										<!--  -->
										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message
													key="org.member_form.primaryLanguange.label"
													bundle="${v3xOrgI18N}" />:</td>
											<td class="new-column" width="75%" nowrap="nowrap"><select
												name="primaryLanguange" class="input-100per" ${dis}>
													<c:forEach var="local" items="${v3x:getAllLocales()}">
                                                    <c:if test="${v3x:getSysFlagByName('sys_isGovVer') != 'true' || local != 'en'}">
														<option value="${local}"
															${memberLocale == local ? "selected" : ""}>
															<fmt:message key="localeselector.locale.${local}"
																bundle="${localeI18N}" />
														</option>
                                                    </c:if>
													</c:forEach>
											</select></td>
										</tr>
										<tr>
											<td colspan="2">&nbsp;</td>
										</tr>
										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap" valign="top">
												<div class="hr-blue-font">
													<strong><fmt:message
															key="hr.staffInfo.hobby.label" bundle="${v3xHRI18N}" />:</strong>
												</div>
											</td>
											<td class="new-column" width="75%" nowrap="nowrap"><textarea
													class="input-100per" name="hobby" id="hobby" rows="3"
													cols="" ${ro}>${staff.hobby}</textarea></td>
										</tr>
									</table>

								</td>


								<td valign="top">
									<table width="95%" border="0" cellspacing="0" cellpadding="0"
										align="center">
										<tr>
											<td class="bg-gray">
												<div class="hr-blue-font">
													<strong><fmt:message
															key="hr.staffInfo.company.label" bundle="${v3xHRI18N}" /></strong>
												</div>
											</td>
											<td class="new-column">&nbsp;</td>
										</tr>
										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message
													key="common.sort.label" bundle="${v3xCommonI18N}" />:</td>
											<td class="new-column" width="75%" nowrap="nowrap"><input
												type="text" id="sortId" name="sortId"
												inputName="<fmt:message key='common.sort.label'  bundle='${v3xCommonI18N}'/>"
												maxlength="6" min="1" class="input-100per"
												value="${member.sortId}" validate="isInteger,notNull" ${ro}
												${mdis} /></td>
										</tr>
										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message
													key="hr.staffInfo.memberno.label" bundle="${v3xHRI18N}" />:
											</td>
											<td class="new-column" width="75%" nowrap="nowrap"><input
												type="text" id="code" name="code" class="input-100per"
												maxlength="20" value="${member.code}" ${ro} ${mdis} /></td>
										</tr>

										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap"><font
												color="red">*</font>
											<fmt:message key="hr.staffInfo.department.label"
													bundle="${v3xHRI18N}" />:</td>
											<td class="new-column" width="75%" nowrap="nowrap"><input
												type="hidden" name="orgDepartmentId" id="orgDepartmentId"
												value="${member.orgDepartmentId}"> <input
												type="text" id="dept_name" name="dept_name"
												class="input-100per" value="${v3x:toHTML(webMember.department_name)}"
												inputName="<fmt:message key="hr.staffInfo.department.label"  bundle="${v3xHRI18N}"/>"
												onClick="memberSelectDepartment()"
												readonly ${mdis} ${dis} validate="notNull" /></td>
										</tr>
										<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

										<tr>
											<td colspan="2">
												<div id="intenalDiv">
													<table width="100%" border="0" cellspacing="0"
														cellpadding="0" align="center">


														<tr>
															<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message
																	key="hr.staffInfo.stafftype.label"
																	bundle="${v3xHRI18N}" />:</td>
															<td class="new-column" width="75%" nowrap="nowrap">
																<select class="input-100per" name="type" id="type"
																${dis} ${mdis}>
																	<v3x:metadataItem
																		metadata="${orgMeta['org_property_member_type']}"
																		showType="option" name="type"
																		selected="${member.type}" />
															</select>
															</td>
														</tr>
														<tr>
															<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message
																	key="hr.staffInfo.staffstate.label"
																	bundle="${v3xHRI18N}" />:</td>
															<td class="new-column" width="75%" nowrap="nowrap">
																<select class="input-100per" name="state" id="state"
																${dis} ${mdis} onchange="changeState()"
																disabled="disabled">
																	<v3x:metadataItem
																		metadata="${orgMeta['org_property_member_state']}"
																		showType="option" name="state"
																		selected="${member.state}" />
															</select>
															</td>
														</tr>

														<tr>
															<td class="bg-gray" width="25%" nowrap="nowrap"><font
																color="red">*</font>
															<fmt:message
																	key="hr.staffInfo.postlevel.label${v3x:suffix()}"
																	bundle="${v3xHRI18N}" />:</td>
															<td class="new-column" width="75%" nowrap="nowrap">
																<select name="orgLevelId" id="orgLevelId"
																inputName="<fmt:message key="hr.staffInfo.postlevel.label"  bundle="${v3xHRI18N}"/>"
																class="input-100per" ${dis} ${mdis}>
																	<c:if test="${member.orgLevelId == -1 && isNew!='New'}">
																		<option value="-1">${noPostLabel}</option>
																	</c:if>
																	<c:if test="${isNew!='New'}">
																		<c:forEach items="${levels}" var="item">
																			<option value="${item.id }"
																				${item.id==member.orgLevelId ? 'selected' : ''}>
																				<c:out value="${item.name}" escapeXml="true" />
																			</option>
																		</c:forEach>
																	</c:if>
																	<c:if test="${isNew=='New'}">
																		<c:forEach items="${levels}" var="item">
																			<option value="${item.id }"
																				${item.levelId==minLevelId ? 'selected' : ''}>
																				<c:out value="${item.name}" escapeXml="true" />
																			</option>
																		</c:forEach>
																	</c:if>
															</select>
															</td>
														</tr>
														<tr>
															<td class="bg-gray" width="25%" nowrap="nowrap"><font
																color="red">*</font>
															<fmt:message key="hr.staffInfo.primaryPostId.label"
																	bundle="${v3xHRI18N}" />:</td>
															<td class="new-column" width="75%" nowrap="nowrap">
																<input type="hidden" name="orgPostId" id="orgPostId"
																value="${member.orgPostId}"> <c:choose>
																	<c:when
																		test="${(member.orgPostId != -1)||(isNew == 'New')}">
																		<input type="text" id="primary_post_name"
																			name="primary_post_name" class="input-100per"
																			value="${webMember.post_name}"
																			inputName="<fmt:message key="hr.staffInfo.primaryPostId.label"  bundle="${v3xHRI18N}"/>"
																			onClick="memberSelectPost()"
																			readonly ${mdis} ${dis} validate="notNull" />
																	</c:when>
																	<c:otherwise>
																		<input type="text" id="primary_post_name"
																			name="primary_post_name" class="input-100per"
																			value="<fmt:message key='org.member.noPost'/>"
																			inputName="<fmt:message key="hr.staffInfo.primaryPostId.label"  bundle="${v3xHRI18N}"/>"
																			onClick="memberSelectPost()"
																			readonly ${mdis} ${dis} validate="notNull" />
																	</c:otherwise>
																</c:choose>
															</td>
														</tr>
														<tr>
															<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message
																	key="hr.staffInfo.secondPostId.label"
																	bundle="${v3xHRI18N}" />:</td>
															<td class="new-column" width="75%" nowrap="nowrap">
																<input type="hidden" name="second_post_ids"
																id="second_post_ids"
																value="${webMember.second_posts_ids}"> <input
																type="text" id="second_post_name"
																name="second_post_name" class="input-100per"
																value="${webMember.second_posts}"
																onclick="memberSelectAssistantPosts()" readonly ${mdis} ${dis}/>
															</td>
														</tr>

													</table>
												</div>
											</td>
										</tr>

										<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message
													key="hr.staffInfo.organization.label" bundle="${v3xHRI18N}" />:
											</td>
											<td class="new-column" width="75%" nowrap="nowrap"><input
												type="hidden" name="org_id" id="org_id" value=""> <input
												type="text" id="org_name" name="org_name"
												class="input-100per" value="${v3x:toHTML(webMember.org_name)}" readonly ${mdis} ${dis}/>
											</td>
										</tr>
										<tr>
											<td colspan='2'>&nbsp;</td>
										</tr>
										<tr>
											<td class="bg-gray">
												<div class="hr-blue-font">
													<strong><fmt:message
															key="hr.staffInfo.otherInfo.label" bundle="${v3xHRI18N}" /></strong>
												</div>
											</td>
											<td class="new-column">&nbsp;</td>
										</tr>
										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message
													key="hr.staffInfo.specialty.label" bundle="${v3xHRI18N}" />:
											</td>
											<td class="new-column" width="75%" nowrap="nowrap"><input
												type="text" id="specialty" maxlength="250" name="specialty"
												class="input-100per" maxlength="80"
												value="${v3x:toHTML(staff.specialty)}" ${ro} ${mdis} /></td>
										</tr>
										<!--  
            <tr>
                 <td class="bg-gray" width="25%" nowrap="nowrap">
                     <fmt:message key="hr.staffInfo.workingtime.label"  bundle="${v3xHRI18N}"/>:
                 </td>
                 <td class="new-column" width="75%" nowrap="nowrap">
                     <input type="text" id="workingTime" name="workingTime" class="input-100per"  value="${staff.working_time}" validate="isInteger" ${ro} ${mdis} />
                 </td>
            </tr>
        -->
										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message
													key="hr.staffInfo.workStartingDate.label"
													bundle="${v3xHRI18N}" />:</td>
											<td class="new-column" width="75%" nowrap="nowrap"><input
												type="text" name="work_starting_date"
												id="work_starting_date" class="input-100per"
												onClick="selectDateTime(this, 675, 340);"
												readonly ${mdis}${dis}
                   value="<fmt:formatDate value="${staff.work_starting_date}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>">
											</td>
										</tr>
										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message
													key="hr.staffInfo.recordWage.label" bundle="${v3xHRI18N}" />:
											</td>
											<td class="new-column" width="75%" nowrap="nowrap"><input
												type="text" id="recordWage" name="recordWage"
												class="input-100per" maxlength="30"
												value="${staff.record_wage_str}"
												inputName="<fmt:message key="hr.staffInfo.recordWage.label"  bundle="${v3xHRI18N}" />"
												${ro} ${mdis} /></td>
										</tr>
										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message
													key="hr.staffInfo.edulevel.label" bundle="${v3xHRI18N}" />:
											</td>
											<td class="new-column" width="75%" nowrap="nowrap"><select
												class="input-100per" name="edu_level" id="edu_level" ${dis}
												${mdis}>
													<option value="-1"></option>
													<v3x:metadataItem
														metadata="${hrMetadata['hr_staffInfo_edulevel']}"
														showType="option" name="edu_level"
														selected="${staff.edu_level}" />
													<!--          
                 <option value="1" <c:if test="${staff.edu_level == 1}">selected</c:if>><fmt:message key="hr.staffInfo.edulevel.1" bundle="${v3xHRI18N}"/>
                 <option value="2" <c:if test="${staff.edu_level == 2}">selected</c:if>><fmt:message key="hr.staffInfo.edulevel.2" bundle="${v3xHRI18N}"/>
                 <option value="8" <c:if test="${staff.edu_level == 8}">selected</c:if>><fmt:message key="hr.staffInfo.edulevel.8" bundle="${v3xHRI18N}"/>
                 <option value="9" <c:if test="${staff.edu_level == 9}">selected</c:if>><fmt:message key="hr.staffInfo.edulevel.9" bundle="${v3xHRI18N}"/>
                 <option value="10" <c:if test="${staff.edu_level == 10}">selected</c:if>><fmt:message key="hr.staffInfo.edulevel.10" bundle="${v3xHRI18N}"/>
                 <option value="3" <c:if test="${staff.edu_level == 3}">selected</c:if>><fmt:message key="hr.staffInfo.edulevel.3" bundle="${v3xHRI18N}"/>
                 <option value="4" <c:if test="${staff.edu_level == 4}">selected</c:if>><fmt:message key="hr.staffInfo.edulevel.4" bundle="${v3xHRI18N}"/>
                 <option value="5" <c:if test="${staff.edu_level == 5}">selected</c:if>><fmt:message key="hr.staffInfo.edulevel.5" bundle="${v3xHRI18N}"/>
                 <option value="6" <c:if test="${staff.edu_level == 6}">selected</c:if>><fmt:message key="hr.staffInfo.edulevel.6" bundle="${v3xHRI18N}"/>
                 <option value="7" <c:if test="${staff.edu_level == 7}">selected</c:if>><fmt:message key="hr.staffInfo.edulevel.7" bundle="${v3xHRI18N}"/>
                  -->
											</select></td>
										</tr>
										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message
													key="hr.staffInfo.position.label" bundle="${v3xHRI18N}" />:
											</td>
											<td class="new-column" width="75%" nowrap="nowrap"><select
												class="input-100per" name="political_position"
												id="political_position" ${dis} ${mdis}>
													<v3x:metadataItem
														metadata="${hrMetadata['hr_staffInfo_position']}"
														showType="option" name="political_position"
														selected="${staff.political_position}" />
													<!-- 
                 <option value="1" <c:if test="${staff.political_position == 1}">selected</c:if>><fmt:message key="hr.staffInfo.position.1" bundle="${v3xHRI18N}"/>
                 <option value="3" <c:if test="${staff.political_position == 3}">selected</c:if>><fmt:message key="hr.staffInfo.position.3" bundle="${v3xHRI18N}"/>
                 <option value="4" <c:if test="${staff.political_position == 4}">selected</c:if>><fmt:message key="hr.staffInfo.position.4" bundle="${v3xHRI18N}"/>
                 <option value="2" <c:if test="${staff.political_position == 2}">selected</c:if>><fmt:message key="hr.staffInfo.position.2" bundle="${v3xHRI18N}"/>
                 -->
											</select></td>
										</tr>
										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message
													key="hr.staffInfo.marriage.label" bundle="${v3xHRI18N}" />:
											</td>
											<td class="new-column" width="75%" nowrap="nowrap"><select
												class="input-100per" name="marriage" id="marriage" ${dis}
												${mdis}>
													<option value="-1"></option>
													<v3x:metadataItem
														metadata="${hrMetadata['hr_staffInfo_marriage']}"
														showType="option" name="marriage"
														selected="${staff.marriage}" />
													<!-- 
                 <option value="1" <c:if test="${staff.marriage == 1}">selected</c:if>><fmt:message key="hr.staffInfo.marriage.1" bundle="${v3xHRI18N}"/>
                 <option value="2" <c:if test="${staff.marriage == 2}">selected</c:if>><fmt:message key="hr.staffInfo.marriage.2" bundle="${v3xHRI18N}"/>
                 <option value="3" <c:if test="${staff.marriage == 3}">selected</c:if>><fmt:message key="hr.staffInfo.marriage.3" bundle="${v3xHRI18N}"/>
                 <option value="4" <c:if test="${staff.marriage == 4}">selected</c:if>><fmt:message key="hr.staffInfo.marriage.4" bundle="${v3xHRI18N}"/>
                  -->
											</select></td>
										</tr>
										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap" valign="top">
												<fmt:message key="common.attachment.label"
													bundle="${v3xCommonI18N}" />:
											</td>
											<td class="new-column" width="75%" nowrap="nowrap"><c:if
													test="${!ReadOnly && Manager}">
													<input type="button" onclick="insertAttachment();"
														value="<fmt:message key='hr.staffInfo.imattachment.label' bundle='${v3xHRI18N}' />"
														class="button-default-2"> 
                     &nbsp;<v3x:fileUpload attachments="${attachments}"
														canDeleteOriginalAtts="true" />
												</c:if> <c:if test="${ReadOnly}"> 
                      &nbsp;<v3x:fileUpload attachments="${attachments}"
														canDeleteOriginalAtts="false" />
												</c:if></td>
										</tr>
										<tr>
											<td colspan='2'>&nbsp;</td>
										</tr>
										<tr>
											<td class="bg-gray" width="25%" nowrap="nowrap" valign="top">
												<div class="hr-blue-font">
													<strong><fmt:message
															key="hr.staffInfo.remark.label" bundle="${v3xHRI18N}" />:</strong>
												</div>
											</td>
											<td class="new-column" width="75%" nowrap="nowrap"><textarea
													class="input-100per word_break_all" name="remark" id="remark" rows="6"
													cols="" ${ro}  style="width:285px;">${staff.remark}</textarea></td>
										</tr>
									</table>
								</td>



							</tr>


						</table>
					</div>
				</td>
			</tr>
			<c:if test="${!ReadOnly}">
				<tr>
					<td height="42" colspan="2" align="center"
						class="bg-advance-bottom"><input type="button"
						id="submintButton" onclick="sub()"
						value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />"
						class="button-default-2">&nbsp; <input type="button"
						id="submintCancel" onclick="cancel()"
						value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />"
						class="button-default-2"></td>
				</tr>
			</c:if>
		</table>
	</form>
	<script type="text/javascript">    //document.getElementById("name").focus();个人信息会报错误，姓名是置灰的。所以就设置不了焦点
	    var isMemberOut = '${member.isInternal}';         
	    if(isMemberOut == false){
	          document.getElementById("intenalDiv").style.display = "none";
	          document.getElementById("primary_post_name").validate = "";
	          //document.getElementById("level_name").validate = "";        
	    }
	    function loadFun(){
	    	document.getElementById("formID").style.width=document.getElementById("bodyID").clientWidth;
	    }
	</script>
</body>
</html>