<%--
 $Author:  zhaifeng$
 $Rev:  $
 $Date:: 2012-11-15#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<TABLE class="only_table edit_table" border=0 cellSpacing=0 cellPadding=0 width="100%">
		<THEAD>
			<TR>
				<TH><input id="checkAll" onclick="sel(this)" name="catagorycheck" type="checkbox"></TH>
				<TH>
					<%--名称 --%>
	                ${ctp:i18n("collaboration.eventsource.category.name")}
                </TH>
			</TR>
		</THEAD>
		<TBODY>
			<c:if test="${ctp:hasPlugin('collaboration')}">
				<TR>
					<TD><input id="catagoryColl" name="catagory" type="checkbox" value="catagory_coll"></TD>
					<TD>
					    <%--个人模板 --%>
	                    ${ctp:i18n("collaboration.showAttributeSet.personalTemplates")}         
	                </TD>
				</TR>
				<TR>
	                <TD><input id="catagoryCollOrFormTemplete" name="catagory" type="checkbox" value="catagory_collOrFormTemplete"></TD>
	                <TD>
	                    <%--协同/表单模版 --%>
	                    ${ctp:i18n("collaboration.eventsource.category.collOrFormTemplete")}
	                </TD>
	            </TR>
            </c:if>
            <c:if test="${ctp:hasPlugin('edoc')}">
            	<TR>
	                <TD><input id="catagoryEdoc" name="catagory" type="checkbox" value="catagory_edoc"></TD>
	                <TD>
	                    <%--公文模板--%>
	                    ${ctp:i18n("collaboration.showAttributeSet.officialDocumentTemplates")}
	                </TD>
            	</TR>
            </c:if>
            
            <c:if test="${openFrom ne 'other'}">
            <TR>
                <TD><input id="catagoryEdoc" name="catagory" type="checkbox" value="catagory_meet"></TD>
                <TD>
                    <%--会议--%>
                    ${ctp:i18n("application.6.label")}
                </TD>
            </TR>
            </c:if>
		</TBODY>
    </TABLE>
</body>
<script type="text/javascript">
function OK(){
	var obj = document.getElementsByName("catagory");
	var count = 0;
	for(var i=0 ; i<obj.length ;i++){
		if(!obj[i].checked) count ++;
	}
	if(count == obj.length) {
		location.reload();
	}
	var objstr = [];
	var allValue = [];
	var resMap = new Properties();
	if(obj){
		for(var i=0 ; i<obj.length ;i++){
			var ob = obj[i];
			if(ob && ob.checked){
				resMap.put(ob.value,ob.value);
			}
		}
	}
	var keys = resMap.keys();
	for(var i = 0 ; i < keys.size();i++){
		allValue[allValue.length] = keys.get(i);
	}

	if(allValue.length != 0){
		objstr[0] = allValue;
	} else {
		objstr[0] = [];//应对portal-common.js中的统一至少选择一项的提示判断，增加代码
	}
	return objstr;
}
function sel(v){
	var obj = document.getElementsByName("catagory");
	if(obj){
		for(var i=0 ; i<obj.length ;i++){
			obj[i].checked = v.checked;
		}
	}
}
window.onload = function () {
	var values = window.parentDialogObj['setPanelValue_id'].getTransParams();
	var obj = document.getElementsByName("catagory");
	if(obj && values){
		for(var i=0 ; i<obj.length ;i++){
			var valuestr  = values.split(",");
			for(var j=0 ; j<valuestr.length ;j++){
				if(valuestr[j]  == obj[i].value){
					obj[i].checked = true;
				}
			}
		}
	}else{//20120301需求变更默认勾选协同表单模板
		//document.getElementById("catagoryCollOrFormTemplete").checked = true;
		//默认勾选全部
		/*
		if(obj){
			for(var i=0 ; i<obj.length ;i++){
				obj[i].checked = true ;
			}
		}
		var checkAll = document.getElementById("checkAll");
		if(checkAll){
			checkAll.checked = true ;
		}*/
	}
}
</script>
</html>