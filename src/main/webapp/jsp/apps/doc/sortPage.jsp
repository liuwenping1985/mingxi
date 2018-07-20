<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<%@ include file="docHeader.jsp" %>
<%@include file="../../common/INC/noCache.jsp" %>
<html>
<head>

<title></title>

<script type="text/javascript">

	function sortValidate(sortType){
		var docResIds = document.getElementsByName("id");
		var docResId = -1;
		var choosedBoxSum = 0;
		for(var i = 0; i < docResIds.length; i++){
			if(docResIds[i].checked){
				docResId = docResIds[i].value;
				choosedBoxSum = choosedBoxSum + 1;
//				break;
			}
		}
		if(choosedBoxSum == 0){
			alert(v3x.getMessage('DocLang.doc_no_data_sort_alert'));
			return false;
		}
		if(choosedBoxSum >1){
			alert(v3x.getMessage('DocLang.doc_more_data_sort_alert'));
			return false;
		}
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
	 							"isNeedSort", false); //???
		requestCaller.addParameter(1, "Long", docResId);
		requestCaller.addParameter(2, "String", sortType);			
		var isNeedSort = requestCaller.serviceRequest();
			
		if(isNeedSort == 'false'){
			if(sortType == "upwards" || sortType == "top"){
				alert(v3x.getMessage('DocLang.doc_sort_already_top_alert'));
				return false;
			}
			else if(sortType == "downwards" || sortType == "end"){
				alert(v3x.getMessage('DocLang.doc_sort_already_end_alert'));
				return false;
			}
		}
		else if(isNeedSort == 'true'){
			return true;
		}
	}

	//置顶
	function top1(){		
		sort("top");
	}
	
	//上移
	function upwards(){		
		sort("upwards");
	}
	//下移
	function downwards(){		
		sort("downwards");
	}
	
	//置底
	function end(){		
		sort("end");
	}
	//移动
	function sort(sortType){
	    window.returnValue = 1 ;
		var sortValidateResult =  sortValidate(sortType);
		if(!sortValidateResult){
			return;
		}
				
		var docResIds = document.getElementsByName("id");
		var docResId = -1;
		
		for(var i = 0; i < docResIds.length; i++){
			if(docResIds[i].checked){		
				docResId = docResIds[i].value;	
				break;			
			}
		}
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
	 							"sort", false); //???
		requestCaller.addParameter(1, "Long", docResId);
		requestCaller.addParameter(2, "String", sortType);			
		var result = requestCaller.serviceRequest();
		if(result == 'true'){
			var firstDocId = docResIds[0].value;
			var lastDocId = docResIds[docResIds.length - 1].value;

			if(sortType == "upwards" && docResId == firstDocId){
				removeParam("false",docResId);				
				prev();
				
			}
			else if(sortType == "downwards" && docResId == lastDocId){
				removeParam("false",docResId);				
				next();
				
			}
			else if(sortType == "top"){
				removeParam("false",docResId);				
				first();
			
			}
			else if(sortType == "end"){
				removeParam("false",docResId);	
				
				var count = Number(pageQueryMap.get("count"));

				var pageSize = pageQueryMap.get("pageSize");
				var size = 1;
				
				if(typeof pageSize != "string"){
					pageSize = 20;
				}
				
				if(count < pageSize || count == pageSize){
					size = 1;
				}
				else{
					if(count%pageSize == 0){
						size = count/pageSize;
				}
					else{
						size = parseInt( count/pageSize) + 1;
					}
				}
						
				last(this,size);
			
			}
			else{
				removeParam("true",docResId);
				window.location.href = window.location.href + "&isCurrentPage=true&docCheckedId=" + docResId;
			}
		}
	}
	function removeParam(isCurrentPage,docResId){
		pageQueryMap.remove("docResId");
		pageQueryMap.remove("isCurrentPage");
		pageQueryMap.remove("docCheckedId");
		//if(isCurrentPage == "false"){
			pageQueryMap.put("docResId",docResId);
		//}
	}
--></script>

<script text="text/javascript" language="javascript">
	function cancleAllButton(checkedBox){
		if(checkedBox.checked == true){
			checkedBox.checked == false;
		}
	} 
Array.prototype.forEach = function(action) {
    for (var i=0; i<this.length; i++)
        action(this[i], i, this);
};

function singleSelect(name) {
    with ([]) {
        forEach.call(document.getElementsByName(name), function(i) { push(i); });
        forEach(function(item, i) {
            item.onclick = function() {
                forEach(function(e, ii) { e.checked = i==ii; });
            };
        });
    }
}

window.onload = function() {
    singleSelect("id");
};

</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
${v3x:skin()}
</head>
<body onkeydown="listenerKeyESC();" scroll="no">
	<div class="main_div_row2">
		<div class="right_div_row2">
    		<div class="top_div_row2">
				<table width="100%" height="30" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td width="100%">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<a class="font-12px" href="javascript:top1();">[<fmt:message key='doc.jsp.sort.top'/>]</a>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<a class="font-12px" href="javascript:upwards();">[<fmt:message key='doc.jsp.sort.upwards'/>]</a>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<a class="font-12px" href="javascript:downwards();">[<fmt:message key='doc.jsp.sort.downwards'/>]</a>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<a class="font-12px" href="javascript:end();">[<fmt:message key='doc.jsp.sort.end'/>]</a>
						</td>
					</tr>
				</table>
			</div>
			<div class="center_div_row2" id="scrollListDiv">
			<form name="sortPage" id="sortPage"  method="post" action="">
		<div id="sortProperty" >
		  	<v3x:table data="docs" var="doc" isChangeTRColor="true" className="ellipsis sort" showHeader="true" htmlId="docSortPage" showPager="true" pageSize="0" dragable="true">
				<v3x:column width="5%" align="center" label="">
					<input type='radio' name='id' value="${doc.id}" onclick="cancleAllButton(this);"
						 <c:if test="${docResId != null}">
							 <c:if test="${param.docResId == doc.id}">
							 	checked
							 </c:if>
						</c:if>
						 <c:if test="${docCheckedId == doc.id}">
						 	checked
						 </c:if>
						 />
				</v3x:column>
				<v3x:column label="doc.metadata.def.icon" width="10%" align="center">
					<img src="/seeyon/apps_res/doc/images/docIcon/${doc.openSquare?'share_':''}${doc.docImageType}" height="16">
				</v3x:column>
                <v3x:column label="doc.metadata.def.name" width="40%" alt="${doc.docName}" value="${doc.docName}"></v3x:column> 
                <c:choose>
                   <c:when test="${isEodcLib}">
                       <v3x:column label="doc.metadata.def.edoc.number" width="20%" alt="${doc.edocNumber}" value="${doc.edocNumber}"></v3x:column>
                       <v3x:column label="doc.metadata.def.edoc.Inumber" width="20%" alt="${doc.edocInNumber}" value="${doc.edocInNumber}"></v3x:column>  
                   </c:when>
                   <c:otherwise>
                        <v3x:column label="doc.metadata.def.type" width="15%" value="${v3x:_(pageContext, doc.docContentType)}"></v3x:column>
                   </c:otherwise>
                </c:choose> 
                <v3x:column label="doc.metadata.def.creater" width="10%" value="${doc.docCreater}"></v3x:column>
				 <v3x:column label="doc.metadata.def.lastupdate" width="20%" align="left">
				 	<fmt:formatDate value="${doc.docLastUpdateDate}" pattern="${datetimePattern}"/>
				 </v3x:column>
		  	</v3x:table>
	  	</div>
  </form>
  </div>
  </div>
  </div>
  <iframe id="sortIframe" name="sortIframe" frameborder="0" marginheight="0" marginwidth="0" ></iframe>
  <script>
  initIpadScroll("sortProperty",600,600);
  initFFScroll("sortProperty",580,635);
  </script>
</body>
</html>