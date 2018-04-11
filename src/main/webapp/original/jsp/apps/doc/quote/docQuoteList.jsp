<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../docHeader.jsp"%>
<%@page import="java.util.List" %>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<title></title>
<c:set var="current_user_id" value="${sessionScope['com.seeyon.current_user'].id}" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
<script type="text/javascript">
    var paramFrom ="${v3x:escapeJavascript(param.from)}";
	var docLibId = '${param.docLibId}';
	if(docLibId == '')
		docLibId = '${docLibId}';
	var docLibType = '${param.docLibType}';
	if(docLibType == '')
		docLibType = '${docLibType}';
	function seachDocRel(){
		if(!checkForm(searchForm))
			return;
		 var fvalue = searchForm.flag.value;
		 var method = "";
		 
		 if(fvalue==""){
			 fvalue ="frName|0|true";
		 }
		 
		 if(fvalue && fvalue != '') {
			method = "docQuoteSimpleSearch&propertyNameAndType=" + encodeURI(fvalue);
			var name_type = fvalue.split('|');
			try {
				var propName = name_type[0];
				var propType = name_type[1];
				var isDefault = name_type[2];
				if(propType == '4' || propType == '5') {
					var startDate = document.getElementById(propName + "beginTime");
					var endDate = document.getElementById(propName + "endTime");
					//时间校验
					if(startDate.value != '' && endDate.value != ''){
						var result = compareDate(startDate.value, endDate.value);
						if(result > 0){
							alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
							return;
						}
					}
					
					method += "&" + propName + "beginTime=" + document.getElementById(propName + "beginTime").value;
					method += "&" + propName + "endTime=" + document.getElementById(propName + "endTime").value;
				}else {
					// frType页面中已有全局变量定义，避免重复
					var appendFlag= "";
					if(propType == '10') {
						if(document.getElementById("frTypeValue").value == -1) {
							alert(v3x.getMessage("DocLang.doc_type_alter_not_select"));
							return;
						}
						appendFlag = "Value";
					}
					method += "&" + propName + appendFlag + "=" + encodeURIComponent(document.getElementById(propName + appendFlag).value);
					if(propType == '9') {
						method += "&" + propName + "Name=" + encodeURIComponent(document.getElementById(propName + "Name").value);
					}
				}
				method += ("&" + propName + "IsDefault=" + isDefault);
			} catch(e) {
				
			}
		 } else {
			 return;
		 }
		 var src = "${detailURL}?method=" + method + "&queryFlag=true&parentId=${parentId}&docLibId=" + docLibId + "&docLibType=" + docLibType + "&isQuote=true&from=${v3x:escapeJavascript(param.from)}";
	 	 parent.listFrame.location.href = src;
	}
	<%-- 
	function docQuoteAdvancedSearch() {
		var src = "${detailURL}?method=docQuoteAdvancedSearch&queryFlag=true&parentId=${parentId}&docLibId=" + docLibId + "&docLibType=" + docLibType + "&isQuote=true";
		document.getElementById("advancedSearchButton").disabled = true;
		advancedSearchForm.action = src;
		advancedSearchForm.submit();
	}
	--%>
	window.onload = function() {
		if('${param.queryFlag}' == 'true' && '${param.method}' != 'docQuoteAdvancedSearch') {
			var	conditionValue = '${simpleQueryModel.propertyName}|${simpleQueryModel.propertyType}|${simpleQueryModel.simple}';
			var	textfieldValue = "<v3x:out value='${simpleQueryModel.value1}' escapeJavaScript='true' />";	
			var	textfield1Value = "<v3x:out value='${simpleQueryModel.value2}' escapeJavaScript='true' />";
			docMenuShowCondition(conditionValue, textfieldValue, textfield1Value);
		}
	}
	
	function docMenuShowCondition(condition, value, value1){
		var conditionObj = document.getElementById("condition");
		selectUtil(conditionObj, condition);
	    showNextCondition(conditionObj);
	    setFlag(condition);

	    if(condition.indexOf('frType') != -1) {
	    	selectUtil(document.getElementById("frTypeValue"), value);
	    }
	    else {
	    	document.getElementById("${simpleQueryModel.paramName1}").value = value;
			try {
				if("${simpleQueryModel.paramName2}" != "")
					document.getElementById("${simpleQueryModel.paramName2}").value = value1;
			} catch(e) {}
	    }
	}
	
	var isLibOwner = "false";
	
	//选中关联项
	function _doSelectData(obj, jsSubject, pType, pAffairId){
	    
	    var rBrReg = /<br\/?>/ig;
	    var rBrReg1 = /\r/ig;
	    var rBrReg2 = /\n/ig;
	    var rBrReg3 = /\r\n/ig;
	    jsSubject = jsSubject.replace(rBrReg, "");
	    jsSubject = jsSubject.replace(rBrReg1, "");
	    jsSubject = jsSubject.replace(rBrReg2, "");
	    jsSubject = jsSubject.replace(rBrReg3, "");
	    
	    parent.parent.quoteDocumentSelected(obj, jsSubject, pType, pAffairId);
	}

</script>
<style type="text/css">
.bg_color {
  background: #fafafa;
}
.border_b_l_r{
    border-bottom: solid 1px #b6b6b6;
    border-left:solid 1px #b6b6b6;
    border-right:solid 1px #b6b6b6;
}
.sort img{
	margin-bottom:-4px;
	margin-top:5px;
	*margin-top:0px;
}
.sort input[type="checkbox"] {
	margin-top:0px;
	*margin-top:3px;
}
</style>
</head>
<c:set value="${v3x:currentUser()}" var="currentUser" />
<body onkeydown="listenerKeyESC()" scroll="no" class="bg_color">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table cellpadding="0" cellspacing="0" width="100%" height="40" border="0">
			<tr>
			<td id="canOpen"  valign="center">
				<%
					List addinMenus = (List)request.getAttribute("AddinMenus");
				%>
				<%@ include file="../simplesearch.jsp"%>
			</td>
			</tr>
		</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<form>
            <c:set value="${param.from == 'bizMap' ? 'radio' : 'checkbox'}" var="inputType" />
			<v3x:table data="${the_list}" var="vo"  isChangeTRColor="false" showHeader="true" htmlId="relAddTable" width="100.2%" >
				<fmt:formatDate value="${vo.docRes.createTime}" pattern="yyyy-MM-dd HH:mm:ss" var="createDate"/>
				<v3x:column width="5%" align="center" label="">
					<c:set value="${v3x:toHTMLWithoutSpaceEscapeQuote(vo.docRes.frName)}" var="theFrName"/>
                    <c:if test="${param.from != 'bizMap'}">
                        <c:set value="_doSelectData(this, '${theFrName}', 'km', '${vo.docRes.id}')" var="clickFun" />
                    </c:if>
					<input type="${inputType}" id="id" name="id" class="cursor-hand" value="${vo.docRes.id}" createDate="${createDate}" isFolder="${vo.docRes.isFolder}"
					onclick="${clickFun}"
					${v3x:outConditionExpression(vo.docRes.isFolder == 'true' && (param.from != 'bizMap' && param.from != 'dataRelation')  , 'disabled', '')}
                    ${v3x:outConditionExpression(vo.docRes.id == '900' && (param.from == 'bizMap' || param.from == 'dataRelation'), 'disabled', '')}
                    ${v3x:outConditionExpression(vo.docRes.onlyList == 'true' && vo.link == 'false', 'disabled', '')}
					${v3x:outConditionExpression(vo.docRes.isFolder == 'false' && vo.isFolderLink == 'true', 'disabled', '')}
					${v3x:outConditionExpression(param.referenceId == vo.docRes.id, 'disabled', '')}
					/>
				</v3x:column>
				
				<v3x:column width="40%" align="left" className="sort" type="String" label="${v3x:_(pageContext, 'common.name.label')}" alt="${vo.docRes.frName}">
					<c:if test="${vo.docRes.isFolder == false && vo.isFolderLink == false}">
			        	<a href="javascript:fnOpenKnowledge('${vo.docRes.id}',8,'${vo.docRes.onlyList}',null,'${vo.link}');">
			        </c:if>
			        <c:if test="${vo.docRes.isFolder == true}">
			        	<a href="javascript:folderOpenFunQuote('${vo.docRes.id}', '${vo.docRes.frType}','${vo.allAcl}', '${vo.editAcl}', '${vo.addAcl}', '${vo.readOnlyAcl}', '${vo.browseAcl}', '${vo.listAcl}', 'false', '${vo.docRes.docLibId}', '${vo.docLibType}','${param.referenceId}','${vo.docRes.projectTypeId}')">
			        </c:if>
			        <c:if test="${vo.docRes.isFolder == false && vo.isFolderLink == true}">
			        	<a href="javascript:folderOpenFunQuote('${vo.docRes.sourceId}', '${vo.docRes.frType}','${vo.allAcl}', '${vo.editAcl}', '${vo.addAcl}', '${vo.readOnlyAcl}', '${vo.browseAcl}', '${vo.listAcl}', 'true', '${vo.docRes.docLibId}', '${vo.docLibType}','${param.referenceId}','${vo.docRes.projectTypeId}')">
			        </c:if>
					<img src="/seeyon/apps_res/doc/images/docIcon/${vo.icon }"/> ${v3x:toHTMLWithoutSpace(vo.docRes.frName)} 
                    <c:set value="${vo.docRes.hasAttachments}" var="attflag" />
         	        <span class="attachment_table_${attflag} ${attflag?'inline-block':''}"></span>
					</a>
				</v3x:column>
				
				<v3x:column width="20%" align="left"  className="sort" type="String"  label="${v3x:_(pageContext, 'doc.metadata.def.type')}">
					${v3x:_(pageContext, vo.type)}
				</v3x:column>
	
				<v3x:column width="10%" align="left"  className="sort" type="String" label="${v3x:_(pageContext, 'common.creater.label')}" value="${vo.userName }">
				</v3x:column>
					
				<v3x:column width="25%" align="left"  className="sort" type="Date"  label="${v3x:_(pageContext, 'common.date.lastupdate.label')}">
					<fmt:formatDate value="${vo.docRes.lastUpdate}" pattern="${ datetimePattern }"/>
				</v3x:column>
			</v3x:table>
		</form>
    </div>
  </div>
</div>
<input type="hidden" name="relIdAndRelName" id="relIdAndRelName" value="">
<iframe  name="docLinkFrame" id="docLinkFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</iframe> 
<script type="text/javascript">
var allCheckBox = document.getElementsByName("id");
var selectedOptions = parent.parent.fileUploadAttachments.instanceKeys.instance;
for(var i = 0; i < allCheckBox.length; i++){
    //业务导图
    if (parent.parent.backLinkType) {
        if(parent.parent.backLinkType == "doc" && parent.parent.backSourceValue == allCheckBox[i].value){
          allCheckBox[i].checked=true;
        }
    }
    //关联文档
	for(var k = 0; k <selectedOptions.length; k++){
		if(selectedOptions[k] == allCheckBox[i].value){
			allCheckBox[i].checked=true;
		}
	}
}
function selectRow(obj){
	return;
}
</script>
</body>
</html>