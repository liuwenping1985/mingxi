<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<title>绑定参数</title>
<script type="text/javascript">
<!--
var methodName = "${methodName}";
var allParamValueType= new Object();
function OK(){
	var result = [];
	var success = true;
	result.push(methodName);
    result.push("(");
    <c:forEach var="funcParam" items="${params}" varStatus="status">
	    <c:if test='${status.count>1}'>
	    	result.push(",");
	    </c:if>
	    var paramValue${status.count}= $("#paramRealValue${status.count}").attr("value");
	    var paramType${status.count}= "${funcParam.type}";
	    if(paramValue${status.count}==""){
	    	$.alert("请为函数的第${status.count}个变量${funcParam.name }绑定参数!");
	    	return;
	    }
	    if((allParamValueType["paramRealValue${status.count}"] && allParamValueType["paramRealValue${status.count}"]=='1')
	    		|| paramType${status.count}=="Bool" || paramType${status.count}=="DateTime" || paramType${status.count}=="Numberic"){
	    	result.push(paramValue${status.count});
	    }else{
	    	result.push("'"+paramValue${status.count}+"'");
	    }
    </c:forEach>
    result.push(")");
	return result.join("");
}

var targetInputId= "";
var isBindFormField= false;
function bindFormField(inputId,appName,formAppId,fieldType){
	targetInputId= inputId;
	isBindFormField= true;
	$.selectStructuredDocFileds({'appName':appName,'formAppId':formAppId,'fieldType':fieldType,'onOk':onOk,'onCancel':onCancel,
		'showSystemVariables':true,'showFormVariables':'${param.showFormVariables}'});
}

function onCancel(){
	isBindFormField= false;
}

function onOk(v){
	if(v && v.fieldDbName && v.fieldDisplayName){
		var fieldDbName= v.fieldDbName;
		var fieldDisplayName= v.fieldDisplayName;
		if(fieldDbName.indexOf("getVar(")>=0){
			$("#"+targetInputId).attr("value",fieldDbName);
		}else{
			$("#"+targetInputId).attr("value","{"+fieldDisplayName+"}");
		}
		$("#"+targetInputId+"Name").attr("value","{"+fieldDisplayName+"}");
		$("#"+targetInputId+"Name").css("background","white");
		allParamValueType[targetInputId]='1'
	}
	isBindFormField= false;
}
function getDataType(v){
	if(v=="String"){
		return "varchar,longtext";
	}else if(v=="Numberic"){
		return "int,number,float";
	}else if(v=="DateTime"){
		return "date,dateTime";
	}else{
		return v.toLowerCase();
	}
}

function setParamRealValue(myId,targetObj){
	var newInputValue= $(targetObj).attr("value").trim();
	var oldInputValue= $("#"+myId).attr("value");
	$("#"+myId).attr("value",newInputValue);
	$(targetObj).css("background","yellow");
	allParamValueType[myId]='0';
}

function setBoolParamRealValue(myId,targetObj){
	var newInputValue= $(targetObj).attr("value").trim();
	var oldInputValue= $("#"+myId).attr("value");
	$("#"+myId).attr("value",newInputValue);
	$(targetObj).css("background","yellow");
	allParamValueType[myId]='0';
}

function changeParamRealValue(myId,targetObj,type){
	if(!isBindFormField){
		var newInputValue= $(targetObj).attr("value").trim();
		var oldInputValue= $("#"+myId).attr("value");
		if(type=="DateTime"){
			$("#"+myId).attr("value","TO_DATE('"+newInputValue+"')");
		}else{
			$("#"+myId).attr("value",newInputValue);
		}
		$(targetObj).css("background","yellow");
		allParamValueType[myId]='0';
	}
}
//-->
</script>
</head>
<body style="overflow: auto">
<form name="selForm" target="inserPeopleIframe" method="post">
<div class="form_area  relative">
<table class="only_table edit_table" id="params" border="0" cellSpacing="0" cellPadding="0" width="100%">
     <thead>
        <tr>
            <th width="30px">${ctp:i18n("workflow.customFunction.list.1") }</th>
            <th width="80px" >${ctp:i18n("workflow.customFunction.list.2") }</th>
			<th width="80px" >${ctp:i18n("common.datatype.label") }</th>
            <th>绑定参数</th>
        </tr>
     </thead>
     <tbody>
       <c:forEach var="funcParam" items="${params}" varStatus="status">
       <tr type="${funcParam.type }" style="height: 30px;line-height: 30px;">
          <td height="20px">${status.count } </td>
          <td height="20px">${funcParam.name } </td>
		  <td height="20px">${funcParam.type.text } </td>
          <td nowrap="nowrap" id="handDiv" title="${ funcParam.description}">
          	  <input type="hidden" id="paramRealValue${status.count }" name="paramRealValue${status.count }" value="">
          	  <c:choose>
                  <c:when test="${funcParam.type.name()=='String' }">
                    <input onkeypress="setParamRealValue('paramRealValue${status.count }',this);" onchange="changeParamRealValue('paramRealValue${status.count }',this,'String');" id="paramRealValue${status.count }Name" name="paramRealValue${status.count }Name" type="text" style="width:70%" class="validate" validate="type:'string',name:'${ctp:i18n('workflow.formBranch.manualInput.vLabel') }',notNull:false,isDeaultValue:true,character:'~!@#$%^&*()_+=&#34;\'{}[]\\/?|:\'&#34;',maxLength:255" />
                    <span class="ico32 form_32 hand" onclick="bindFormField('paramRealValue${status.count }','${appName }','${formAppId }',getDataType('${funcParam.type}'));" ></span>
                  </c:when>
                  <c:when test="${funcParam.type.name()=='DateTime' }">
                    <input onchange="changeParamRealValue('paramRealValue${status.count }',this,'DateTime');" id="paramRealValue${status.count }Name" name="paramRealValue${status.count }Name"  style="width:70%;" readonly="readonly" type="text"  class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true"/>
                  	<span class="ico32 form_32 hand" onclick="bindFormField('paramRealValue${status.count }','${appName }','${formAppId }',getDataType('${funcParam.type}'));" ></span>
                  </c:when>
                  <c:when test="${funcParam.type.name()=='Numberic' }">
                    <input onkeypress="setParamRealValue('paramRealValue${status.count }',this);" onchange="changeParamRealValue('paramRealValue${status.count }',this,'Numberic');" id="paramRealValue${status.count }Name" name="paramRealValue${status.count }Name"  style="width:70%;" id="hand" type="text"  class="validate" validate="type:'float',name:'${ctp:i18n('workflow.formBranch.manualInput.vLabel') }',notNull:false,isDeaultValue:true,character:'~!@#$%^&*()_+=&#34;\'{}[]\\/?|:\'&#34;',maxLength:255"/>
                  	<span class="ico32 form_32 hand" onclick="bindFormField('paramRealValue${status.count }','${appName }','${formAppId }',getDataType('${funcParam.type}'));" ></span>
                  </c:when>
				  <c:when test="${funcParam.type.name()=='Bool' }">
				  	<label for='paramRealValue${status.count }Name_TRUE'><input onclick="setBoolParamRealValue('paramRealValue${status.count }',this);" id="paramRealValue${status.count }Name_TRUE" name="paramRealValue${status.count }Name" value="true" type="radio" class="radio_com">是</label>
				  	<label for='paramRealValue${status.count }Name_FALSE'><input onclick="setBoolParamRealValue('paramRealValue${status.count }',this);" id="paramRealValue${status.count }Name_FALSE" name="paramRealValue${status.count }Name" value="false"  type="radio" class="radio_com">否</label>
				  </c:when>
				  <c:otherwise>
				  	<input onkeypress="setParamRealValue('paramRealValue${status.count }',this);" onchange="changeParamRealValue('paramRealValue${status.count }',this,'Object');" id="paramRealValue${status.count }Name" name="paramRealValue${status.count }Name"  type="text" style="width:70%" class="validate" validate="type:'string',name:'${ctp:i18n('workflow.formBranch.manualInput.vLabel') }',notNull:false,isDeaultValue:true,character:'~!@#$%^&*()_+=&#34;\'{}[]\\/?|:\'&#34;',maxLength:255" />
				  	<span class="ico32 form_32 hand" onclick="bindFormField('paramRealValue${status.count }','${appName }','${formAppId }','');" ></span>
				  </c:otherwise>
              </c:choose>
          </td>
    </tr>
    </c:forEach>
    </tbody>
</table>
</div>
</form>
</body>
</html>