<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html style="overflow: hidden;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="doc.jsp.propEdit.title" /></title>
<script>
    var parentWin = '';
	function init() {
		parentWin = transParams.parentWin;
		var a = parentWin.document.getElementById("contentDiv");
		document.getElementById("contentDiv").innerHTML = a.innerHTML;
		var b = parentWin.document.getElementById("extendDiv");
		document.getElementById("extendDiv").innerHTML = b.innerHTML;
		//兼容innerHTML不回填的问题
        var parentObj = parentWin;
        var eles = document.mainForm.elements;
        for(var i = 0; i < eles.length; i++){
            var ele = eles[i];
            if(ele.type == 'hidden'){
                if(ele.value == ''){
                    if(ele.name.indexOf("datetime") != -1)
                        ele.value = dtb;
                    else if(ele.name.indexOf("date") != -1)
                        ele.value = dtb.substring(0, 10);
                }
            }
            if(ele.type=='button' || ele.type=='submit') continue;
            ele.value=parentObj.document.getElementById(ele.name).value;
        }		
	}

	function saveIt() {
		if(!checkForm(mainForm))
			return;
		var parentObj = parentWin;
		var eles = document.mainForm.elements;
		for(var i = 0; i < eles.length; i++){
			var ele = eles[i];
			if(ele.type == 'hidden'){
				if(ele.value == ''){
					if(ele.name.indexOf("datetime") != -1)
						ele.value = dtb;
					else if(ele.name.indexOf("date") != -1)
						ele.value = dtb.substring(0, 10);
				}
			}
			if(ele.type=='button' || ele.type=='submit') continue;
			parentObj.document.getElementById(ele.name).value = ele.value;
		}
		//检查发起时间(date)与结束时间的大小
		if(!checkSend2EndDate(mainForm)){
			return;
		}
		//huangfj  firefox的innerHTML不支持动态数据
		getA8Top().docPropertiesWin.close();
	}
	
	function checkSend2EndDate(mainForm){
		var eles = mainForm.elements;
		var sdate = null,edate=null;
		for(var i = 0; i < eles.length; i++){
			var ele = eles[i];
			if(ele.name.indexOf("date1") != -1){
				sdate = ele.value;
			}else if(ele.name.indexOf("date3") != -1){
				edate = ele.value;
			}
		}
		//如果同时存在就检查大小
		if(sdate!=null && edate!=null){
			sdate = parseDate(sdate);
			edate = parseDate(edate);
			if(edate.getTime()<sdate.getTime()){
				alert(v3x.getMessage('DocLang.doc_properties_date_viladation'));
				return false;
			}
		}
		return true;
	}
	
	// 正在调用选人组件的html组件id
	var sp_invoke_id = "";
	var sp_input_id = "";
	function sp_fun(id, type){
		sp_invoke_id = id;
		sp_input_id = id;
		if(type == 'Member'){
			selectPeopleFun_sp_member();
		}else if(type == 'Department'){
			selectPeopleFun_sp_dept();
		}
		
		sp_invoke_id = "";
	}
	function setPeopleFields(elements){
		if(!elements) { 
			return; 	
		}
		document.getElementById("name_" + sp_input_id).value = getNamesString(elements);		
		document.getElementById(sp_input_id).value=getIdsString(elements, false);
	}
	
	// 扩展属性辅助方法，暂时在 docProperties.jsp 有实现，这里不做实际处理。
	// 为了防止报js错，进行声明
	function userChange(flag){}
	function userChangeCalendar(ele, oldValue, prop){}
	function propertiesChanged(){}

</script>

<v3x:selectPeople id="sp_member" panels="Department,Team,Outworker" selectType="Member" maxSize="1" 
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setPeopleFields(elements)" />
<v3x:selectPeople id="sp_dept" panels="Department" selectType="Department" maxSize="1" 
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setPeopleFields(elements)" />

<script type="text/javascript">
    showOriginalElement_sp_member = false;
    showOriginalElement_sp_dept = false;
</script>

</head>
<body scroll="no" onkeydown="listenerKeyESC()" onload="init();" style="background:#fafafa;">
<form name="mainForm" id="mainForm" action="" method="post"  target="alertIframe">
	<table class="popupTitleRight" width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td height="20" class="PopupTitle" nowrap="nowrap" style="padding: 4px 0 0 20px;"><fmt:message key="doc.jsp.propEdit.title" />:&nbsp;&nbsp;</td>
	</tr>		
	<tr height="15"><td>&nbsp;</td></tr>	
	<tr><td><div class="doc-label-scrollList" style="overflow: auto;height: 380px;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr><td><div id="contentDiv"></div></td></tr>	
			<tr><td><div id="extendDiv"></div></td></tr>				
		</table></div>
	</td></tr>
	<tr height="42">
		<td align="right" class="bg-advance-bottom">
			<input type="button" name="b1" onclick="saveIt();" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
			<input type="button" name="b2" onclick="getA8Top().docPropertiesWin.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
	</table>
</form>
<form name="testForm" id="testForm" action="" method="post"  target="alertIframe">
	<div id='testDiv'></div>
</form>
<iframe name="alertIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"/>

</body>
</html>