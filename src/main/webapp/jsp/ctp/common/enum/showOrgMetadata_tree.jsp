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
  parent.listFrame.myBar.disabled("editdata");
  parent.listFrame.myBar.disabled("deldata");
  }catch(e){}
}
</script>
</head>
<script type="text/javascript">
<%--选中树节点显示数据项列表
function showValuesList(metadataId){
	  if(parent.toolbarFram!=null){
		  try{
			  var oMetadataToolbar = parent.toolbarFram.document.getElementById('metadataToolbar');
			  var oUnMetadataToolbar = parent.toolbarFram.document.getElementById('unMetadataToolbar');
			  if(oMetadataToolbar!=null && oUnMetadataToolbar!=null){
			  	oMetadataToolbar.className = "show";
			  	oUnMetadataToolbar.className = "hidden";
			  }
		  }catch(e){
		      parent.parent.toolbarFram.location.href = metadataURL + "?method=userDefinedtoobar&from=metadata&isSystem=true&id="+metadataId;
		  }
	  }
      parent.listFrame.location.href = metadataURL+"?method=userDefinedmetadataItemList&isSystem=true&id="+metadataId;
}
function showTypeList(){
	  if(parent.toolbarFram!=null){
		  try{
			  var oMetadataToolbar = parent.toolbarFram.document.getElementById('metadataToolbar');
			  var oUnMetadataToolbar = parent.toolbarFram.document.getElementById('unMetadataToolbar');
			  if(oMetadataToolbar!=null && oUnMetadataToolbar!=null){
			  	oMetadataToolbar.className = "hidden";
			  	oUnMetadataToolbar.className = "show";
			  }
		  }catch(e){
		      parent.parent.toolbarFram.location.href = metadataURL + "?method=userDefinedtoobar&from=metadataType&isSystem=true&id=";
		  }
      }
	parent.listFrame.location.href = metadataURL+"?method=showOrgMetadataList";
}

--%>	
function showItemList(metadataId ,metadataType){
	  if(parent.toolbarFram!=null){
		  try{
		  	  var oMetadataToolbar = parent.toolbarFram.document.getElementById('metadataToolbar');
			  var oUnMetadataToolbar = parent.toolbarFram.document.getElementById('unMetadataToolbar');
			  var oMetadataValueToolbar = parent.toolbarFram.document.getElementById('metadataValueToolbar');
			  if(oUnMetadataToolbar!=null && oMetadataToolbar!=null && oMetadataValueToolbar != null){
			  	oUnMetadataToolbar.className = "hidden";
			  	oMetadataValueToolbar.className = "hidden";
			  	oMetadataToolbar.className = "show";
			  }
		  }catch(e){
		      parent.parent.toolbarFram.location.href = metadataURL + "?method=userDefinedtoobar&from=metadataType&isSystem=true&id="+metadataId;
		  }
	  }
  parent.listFrame.location.href = metadataURL + "?method=showOrgMetadataList&metadataId="+metadataId+"&metadataType="+metadataType+"&isSystem=true" ;
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
			var textfield = document.getElementById(conditionObject.value + "Div").getElementsByTagName("INPUT")[0].value;
			urlStr = "&condition="+conditionObject.value+"&textfield="+encodeURIComponent(textfield);
		}
		window.location.href = metadataURL+"?method=showOrgMetadataTree"+urlStr;
		///searchForm.action = metadataURL+"?method=showOrgMetadataTree";
		//searchForm.submit();
}

</script>
<body scroll="no" onresize="resizeBody(100,'treeandlist','min','left')">
<form id="searchForm" action="" method="post">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr bordercolor="red">
			<td width="30%">
				<div>
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
<div class="scrollList border-padding" style="overflow:auto;width: 100%;height:96%" >
<script type="text/javascript">
<c:choose>
<c:when test="${empty condition || empty textfield}">
	var root = new WebFXTree("0", "<fmt:message key='metadata.manager.account' bundle="${v3xMainI18N}"/>", "javascript:showTypeList('${acconutId}');");
	root.icon = "${pageContext.request.contextPath}/common/js/xtree/images/foldertypeicon.gif" ;
    root.openIcon = "${pageContext.request.contextPath}/common/js/xtree/images/foldertypeicon.gif" ;
	<c:forEach items="${metadatasList}" var="meta">
         var src = "<c:url value='/enum.do?method=xmlForTree&id=${meta.id}&type=CtpEnum'/>";
		 <c:choose>
		   <c:when test="${meta.type !='3'}">
	         //var metadata${fn:replace(meta.id, '-', '_')}= new WebFXTreeItem('${meta.id}',"${v3x:escapeJavascript(v3x:messageFromResource(meta.resourceBundle, meta.label))}","javascript:showValuesList('${meta.id}')");
	         var metadata${fn:replace(meta.id, '-', '_')}= new WebFXLoadTreeItem('${meta.id}',"${v3x:escapeJavascript(v3x:messageFromResource(EnumI18N, meta.label))}",src,"javascript:showValuesList('${meta.id}')");
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
var root = new WebFXTree("0", "<fmt:message key='metadata.manager.account' bundle="${v3xMainI18N}"/>", "javascript:showTypeList('${acconutId}');");
root.icon = "${pageContext.request.contextPath}/common/js/xtree/images/foldertypeicon.gif" ;
root.openIcon = "${pageContext.request.contextPath}/common/js/xtree/images/foldertypeicon.gif" ;
<c:forEach items="${metadatasList}" var="meta">
	 <c:choose>
	   <c:when test="${meta.type !='3'}">
         var metadata${fn:replace(meta.id, '-', '_')}= new WebFXTreeItem('${meta.id}',"${v3x:escapeJavascript(v3x:messageFromResource(EnumI18N, meta.label))}","javascript:showValuesList('${meta.id}')");
       </c:when>
       <c:otherwise>
         var metadata${fn:replace(meta.id, '-', '_')}= new WebFXTreeItem('${meta.id}',"${v3x:escapeJavascript(v3x:messageFromResource(EnumI18N, meta.label))}","javascript:showItemList('${meta.id}','${meta.type}')");
             metadata${fn:replace(meta.id, '-', '_')}.icon = "${pageContext.request.contextPath}/common/js/xtree/images/foldertypeicon.gif" ;
             metadata${fn:replace(meta.id, '-', '_')}.openIcon = "${pageContext.request.contextPath}/common/js/xtree/images/foldertypeicon.gif" ;
       </c:otherwise>
    </c:choose> 
	metadata${fn:replace(meta.id, '-', '_')}.is_formEnum = '${meta.type}' ;
	metadata${fn:replace(meta.id, '-', '_')}.sort = '${meta.sort}' ;
	metadata${fn:replace(meta.id, '-', '_')}.type="metadata" ;
</c:forEach>

<c:forEach items="${metadataItemList}" var="metaItem">
	var metadata${fn:replace(metaItem.id, '-', '_')}= new WebFXTreeItem('${metaItem.id}',"${v3x:toHTML(metaItem.label)}","javascript:showChildOfMetadataItem('${metaItem.id}','metadataItem')");
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
   	<c:choose>
		<c:when test="${metaItem.parentId == '0'}">
		metadata${fn:replace(metaItem.metadataId, '-', '_')}.add(metadata${fn:replace(metaItem.id, '-', '_')}) ;
		</c:when>
		<c:when test="${empty metaItem.metadataId || metaItem.metadataId == '0'}">
		metadata${fn:replace(metaItem.parentId, '-', '_')}.add(metadata${fn:replace(metaItem.id, '-', '_')}) ;	
		</c:when>
   	</c:choose>
	</c:forEach>


document.write(root);
document.close();
webFXTreeHandler.select(root);
showTypeList('${acconutId}');
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
</script></div>
<script type="text/javascript">
<!--
showCondition("${condition}", "<v3x:out value='${textfield}' escapeJavaScript='true' />");
//-->
</script>
</body>
</html>
