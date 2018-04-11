<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="header.jsp"%>
<script>
function setSelApp()
{
try{
  parent.listFrame.myBar.disabled("newdata");
  parent.listFrame.myBar.disabled("editdata");
  parent.listFrame.myBar.disabled("deldata");
  }catch(e){}
}
</script>
</head>
<script type="text/javascript">
<%--选中树节点显示数据项列表	
 function showValuesList(metadataId){

      parent.parent.toolbarFram.location.href = metadataURL + "?method=userDefinedtoobar&from=metadata&isSystem=true&id="+metadataId;
      parent.listFrame.location.href = metadataURL+"?method=userDefinedmetadataItemList&isSystem=true&parentType=metadata&parentId="+metadataId+"&org_account_id="+'${account_id}';
}
--%>
function showTypeList(){
    var selectValue = document.getElementById("org_account_ids").value ;
    if(selectValue == '') {
      return ;
    }
    parent.parent.toolbarFram.location.href = metadataURL + "?method=userDefinedtoobar&from=metadataType&isSystem=true&id=";
	parent.listFrame.location.href = metadataURL+"?method=userDefinedmetadataListRep&org_account_id="+'${account_id}';
}
function showItemList(metadataId ,metadataType){
    var selectValue = document.getElementById("account_id").value ;
    parent.parent.toolbarFram.location.href = metadataURL + "?method=userDefinedtoobar&from=metadataType&isSystem=true&id="+metadataId;
    parent.listFrame.location.href = metadataURL + "?method=userDefinedmetadataList&parentId="+metadataId+"&metadataType="+metadataType+"&isSystem=true&org_account_id="+selectValue ;
}


function showOrgMeata(){
  var selectObj = document.getElementById("org_account_ids") ;
  var selectID = selectObj.value ;
  parent.listFrame.location.href = metadataURL+"?method=showOrgAccountMeataData&org_account_id="+selectID  ;
  parent.treeFrame.location.href = metadataURL +"?method=metadataTree&&org_account_id="+selectID ;
}

	function showNextSpecialCondition(conditionObject) {
	   var options = conditionObject.options;
	   for (var i = 0; i < options.length; i++) {
	       var d = document.getElementById(options[i].value + "Div");
	       if (d) {
	           d.style.display = "none";
	       }
	   }
	   if(document.getElementById(conditionObject.value + "Div") == null) return;
		   document.getElementById(conditionObject.value + "Div").style.display = "block";
	}
	
	function queryMetaDataByCondition() {
		var searchForm = document.getElementById("searchForm");
		var options = searchForm.condition.options;
		for (var i = 0; i < options.length; i++) {
			if (searchForm.condition.value == options[i].value){
				continue;
			}
			var d = document.getElementById(options[i].value + "Div");
	        if (d) {
	            d.innerHTML = "";
	        }
		}
		var urlStr = "";
		var conditionObject = document.getElementById("condition");
		if(document.getElementById(conditionObject.value + "Div") != null){
			urlStr = "&condition="+conditionObject.value+"&textfield="+encodeURIComponent(document.getElementById(conditionObject.value + "Div").firstChild.value);
		}
		var accountIdObj = document.getElementById("account_id");
		if(accountIdObj){
			urlStr += "&account_id=" + accountIdObj.value;
		}
		window.location.href = metadataURL+"?method=queryMetaDataLikeByCorp"+urlStr;
	}
 
</script>
<body scroll="no" onresize="resizeBody(100,'treeandlist','min','left')">
<c:if test="${systemFlag != 'ORG' }">
<div>
 <select onchange="showOrgMeata()" style="width:100%;" name="org_account_ids" id="org_account_ids">
 <option value=""><fmt:message key='metadata.manager.account.lable' bundle="${v3xMainI18N}"/></option>
    ${categoryHTML } 
 </select>
</div>
</c:if>
<c:if test="${systemFlag == 'ORG' }">
<div>
 <select onchange="showOrgMeata()" class="hidden" style="width:100%;" name="org_account_ids" id="org_account_ids" >
  <option value="${accountId }" ></option>    
 </select>
</div>
</c:if>
<c:if test="${metadatasList != null }">
	<form id="searchForm" action="" method="post">
		<table style="width: 100%;">
			<tr bordercolor="red">
				<td width="30%">
				<div>
					<input type="hidden" id="account_id" name="account_id" value="${account_id}" />
					<select id="condition" name="condition" onChange="showNextSpecialCondition(this)" class="">
						<!-- <option value="choice"><fmt:message key="metadadta.select" /></option> -->
						<option value=""><fmt:message key="metadata.select.find"/></option>
						<option value="metaData"><fmt:message key="metadata.select.enum.name"/></option>
						<option value="metaDataDisplay"><fmt:message key="metadata.select.value.name"/></option>
					</select>
				</div>
				</td>
				<td width="70%">
					<div id="metaDataDiv" class="div-float hidden" style="width: 70%">
						<input type="text" name="textfield" id="metadata" value="" style="width: 95%"/>
					</div>
					<div id="metaDataDisplayDiv" class="div-float hidden" style="width: 70%">
						<input type="text" name="textfield" id="metadataItem" value="" style="width: 95%"/>
					</div>
					<div id="grayButton" onclick="queryMetaDataByCondition()" class="div-float condition-search-button" />
				</td>
			</tr>
		</table>
	</form>
</c:if>
<div class="scrollList  border-padding" style="overflow:auto;width: 100%;height:90%">
<script type="text/javascript">
<c:choose>
<c:when test="${empty condition || empty textfield}">
var root = new WebFXTree("0", "<fmt:message key='metadata.manager.account' bundle="${v3xMainI18N}"/>", "javascript:showTypeList();");
root.icon = "${pageContext.request.contextPath}/common/js/xtree/images/foldertypeicon.gif" ;
root.openIcon = "${pageContext.request.contextPath}/common/js/xtree/images/foldertypeicon.gif" ;
<c:forEach items="${metadatasList}" var="meta">
   	 var src = "<c:url value='/enum.do?method=xmlForTree&id=${meta.id}&type=CtpEnum'/>";
	 <c:choose>
	   <c:when test="${meta.type !='3'}">
	   	 var metadata${fn:replace(meta.id, '-', '_')}= new WebFXLoadTreeItem('${meta.id}',"${v3x:escapeJavascript(v3x:messageFromResource(EnumI18N, meta.label))}",src,"javascript:showValuesList('${meta.id}','${account_id}')");
       </c:when>
       <c:otherwise>
       	 var metadata${fn:replace(meta.id, '-', '_')}= new WebFXLoadTreeItem('${meta.id}',"${v3x:escapeJavascript(v3x:messageFromResource(EnumI18N, meta.label))}",src,"javascript:showItemList('${meta.id}','${meta.type}')");
             metadata${fn:replace(meta.id, '-', '_')}.icon = "${pageContext.request.contextPath}/common/js/xtree/images/foldertypeicon.gif" ;
             metadata${fn:replace(meta.id, '-', '_')}.openIcon = "${pageContext.request.contextPath}/common/js/xtree/images/foldertypeicon.gif" ;
       </c:otherwise>
    </c:choose> 
	metadata${fn:replace(meta.id, '-', '_')}.is_formEnum = '${meta.type}' ;
	metadata${fn:replace(meta.id, '-', '_')}.sort = '${meta.sort}' ;
	metadata${fn:replace(meta.id, '-', '_')}.type="metadata" ;
</c:forEach>


<c:forEach items="${metadatasList}" var="meta">
    <c:choose>
		<c:when test="${meta.parentid == '0'}">
		    root.add(metadata${fn:replace(meta.id, '-', '_')});
		</c:when>
	</c:choose>     
</c:forEach>

document.write(root);
document.close();
webFXTreeHandler.select(root);
</c:when>
<c:otherwise>
	var root = new WebFXTree("0", "<fmt:message key='metadata.manager.account' bundle="${v3xMainI18N}"/>", "javascript:showTypeList();");
	root.icon = "${pageContext.request.contextPath}/common/js/xtree/images/foldertypeicon.gif" ;
    root.openIcon = "${pageContext.request.contextPath}/common/js/xtree/images/foldertypeicon.gif" ;
	<c:forEach items="${metadatasList}" var="meta">
		 <c:choose>
		   <c:when test="${meta.type !='3'}">
	         var metadata${fn:replace(meta.id, '-', '_')}= new WebFXTreeItem('${meta.id}',"${v3x:escapeJavascript(v3x:messageFromResource(EnumI18N, meta.label))}","javascript:showValuesList('${meta.id}','${account_id}')");
	       </c:when>
	       <c:otherwise>
	         var metadata${fn:replace(meta.id, '-', '_')}= new WebFXTreeItem('${meta.id}',"${v3x:escapeJavascript(v3x:messageFromResource(EnumI18N, meta.label))}","javascript:showItemList('${meta.id}','${meta.type}')");
	             metadata${fn:replace(meta.id, '-', '_')}.icon = "${pageContext.request.contextPath}/common/js/xtree/images/foldertypeicon.gif" ;
	             metadata${fn:replace(meta.id, '-', '_')}.openIcon = "${pageContext.request.contextPath}/common/js/xtree/images/foldertypeicon.gif" ;
	       </c:otherwise>
	    </c:choose> 
    	metadata${fn:replace(meta.id, '-', '_')}.is_formEnum = '${meta.type}' ;
    	metadata${fn:replace(meta.id, '-', '_')}.sort = '${meta.sort}' ;
    	metadata${fn:replace(meta.id, '-', '_')}.org_account_id = '${meta.org_account_id}' ;
    	metadata${fn:replace(meta.id, '-', '_')}.type="metadata" ;
    </c:forEach>
    
    <c:forEach items="${metadataItemList}" var="metaItem">
		var metadata${fn:replace(metaItem.id, '-', '_')}= new WebFXTreeItem('${metaItem.id}',"${v3x:escapeJavascript(metaItem.label)}","javascript:showChildOfMetadataItem('${metaItem.id}','metadataItem','${account_id}')");
		metadata${fn:replace(metaItem.id, '-', '_')}.parentid = '${metaItem.parentId}' ;
		metadata${fn:replace(metaItem.id, '-', '_')}.metadataId = '${metaItem.metadataId}' ;
		metadata${fn:replace(metaItem.id, '-', '_')}.type = "metadataItem" ;
		metadata${fn:replace(metaItem.id, '-', '_')}.isref = "${metaItem.isRef}" ;
	</c:forEach>

    
    <c:forEach items="${metadatasList}" var="meta">
	    <c:choose>
				<c:when test="${meta.parentid == '0'}">
				    root.add(metadata${fn:replace(meta.id, '-', '_')}) ;
				</c:when>
				<c:otherwise>
				   metadata${fn:replace(meta.parentid, '-', '_')}.add(metadata${fn:replace(meta.id, '-', '_')}) ;
				</c:otherwise>
		  </c:choose>     
    </c:forEach>

	<c:forEach items="${metadataItemList}" var="metaItem">
		var metaItemParentId="${metaItem.parentId}" ;
		var metaItemMetdataId="${metaItem.metadataId}" ;
		if(metaItemParentId == ''){
			metadata${fn:replace(metaItem.metadataId, '-', '_')}.add(metadata${fn:replace(metaItem.id, '-', '_')}) ;
	  	}else if(metaItemMetdataId == '' || metaItemMetdataId == '0'){
	  		metadata${fn:replace(metaItem.parentId, '-', '_')}.add(metadata${fn:replace(metaItem.id, '-', '_')}) ;			  		
		}
	</c:forEach>
    
	document.write(root);
	document.close();
	try{
		var condition = "${condition}";
		if(condition != ""){
			<c:forEach items="${metadatasList}" var="meta">
				var childNodesLength = metadata${fn:replace(meta.id, '-', '_')}.childNodes.length;
				if(childNodesLength > 0){
					metadata${fn:replace(meta.id, '-', '_')}.expand();
				}
			</c:forEach>
			if(condition == "metaDataDisplay"){
				<c:forEach items="${metadataItemList}" var="metaItem">
					var childNodesLength = metadata${fn:replace(metaItem.id, '-', '_')}.childNodes.length;
					if(childNodesLength > 0){
						metadata${fn:replace(metaItem.id, '-', '_')}.expand();
					}
				</c:forEach>
			}
		}
	} catch (e){}
</c:otherwise>
</c:choose>
</script>
</div>
<script type="text/javascript">
<!--
showCondition("${condition}", "<v3x:out value='${textfield}' escapeJavaScript='true' />");
//-->
</script>
</body>
</html>
