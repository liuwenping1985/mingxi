<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%-- 自动分支条件设置 --%></title>
</head>
<script type="text/javascript">
$(function() {
	//查询框
    $('#searchbtn').click(function() {
        search();
    });
    $("#searchtext").keyup(function(event) {
        if (event.keyCode == 13) {
            search();
        }
    });
    //缓存表单字段
    $("#sheetselectForm option").each(function(){
        var text = this.text;
        var oValue = this.value;
        var displayName = $(this).attr("displayName");
        var op = [];
        op[0] = oValue;
        op[1] = text;
        op[2] = displayName;
        formFieldDatas[formFieldDatas.length] = op;
    });
});
//IE不支持displayNone， 只能进行页面缓存
var formFieldDatas = [];


//查询表单域
function search(){
    var searchText =$("#searchtext").val();
    var newHtml = "";
    for(var i = 0, len = formFieldDatas.length; i < len; i++){
        var op = formFieldDatas[i];
        if(searchText == "" || op[1].indexOf(searchText) != -1){
            newHtml += '<option value="'+op[0]+'" displayName="'+op[2]+'">'+op[1]+'</option>';
        }
    }
    $("#sheetselectForm").html(newHtml);
}

function showFormfieldExpresion(){
	var formFieldOptions = document.getElementById('sheetselectForm').options;
	var selectedCount= 0;
	var fieldDbName= "";
	var fieldDisplayName= "";
	for(var i=0;i<formFieldOptions.length;i++){
		var fieldOption= formFieldOptions[i];
		if(fieldOption.selected){
			fieldDbName= $(fieldOption).attr("value");
			fieldDisplayName= $(fieldOption).attr("displayName");
			selectedCount ++;
		}
		if(selectedCount>1){
			break;
		}
	}
	if(selectedCount>1){
		$.alert("${ctp:i18n('workflow.customFunction.formfield.alert.onlyone')}");
	}else if(selectedCount<1){
		$.alert("${ctp:i18n('workflow.customFunction.formfield.alert.mustone')}");
	}else{
		parent.document.getElementById("fieldDbName").value= fieldDbName;
		parent.document.getElementById("fieldDisplayName").value= fieldDisplayName;
	}
}
</script>
<body class="padding_5">
<form id="myform" name="myform" action="<c:url value='/custom/function.do?method=showFormFileds'/>&appName=${ appName}&formAppId=${formAppId }&fieldType=${ fieldType}" method="post">
<table width="100%" border="0" align="center">
    <tr>
    <td width="60%" class="margin_t_5">
            <span id="showsearch">
                <input type="text" id="searchtext" style="width:40%;"/>
                <span class="ico16 search_16" id="searchbtn" href="javascript:void(0)"></span> 
            </span>
        </td>  
      <td>&nbsp;</td>
    </tr>
    <tr>
        <td width="60%" valign="top">
            <select id="sheetselectForm" name="sheetselectForm" size="10" style="width: 472px; height: 365px;" multiple="multiple" class="font_size12">
                <c:forEach items="${formFieldsDefinitionMap}" var="map">
                    <option value="${map.value.fieldName}" displayName="${map.value.display}">${map.value.fieldDisplayLabel}</option>
                </c:forEach>
            </select>
        </td>
    </tr>
</table>
</form>
</body>
</html>