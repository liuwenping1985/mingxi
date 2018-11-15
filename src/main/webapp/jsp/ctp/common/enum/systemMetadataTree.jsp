<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<script type="text/javascript">
<!--
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
		searchForm.action = metadataURL+"?method=selectTreeFrame";
		searchForm.submit();
}
//-->
</script>
<body scroll="no" onresize="resizeBody(100,'treeandlist','min','left')">
<form id="searchForm" action="" method="post">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr bordercolor="red">
			<td width="90px">
				<div>
					<select name="condition" id="condition"  onChange="showNextSpecialCondition(this)" class="">
						<option value=""><fmt:message key="metadata.select.find"/></option>
						<option value="metaData"><fmt:message key="metadata.select.enum.name"/></option>
					</select>
				</div>
			</td>
			<td>
				<div id="metaDataDiv" class="div-float hidden">
					<input type="text" name="textfield" value=""/>
				</div>
				<div id="grayButton" onclick="queryMetaDataByCondition()" class="div-float condition-search-button" />
			</td>
		</tr>
	</table>
</form>
<div class="scrollList border-padding" style="height: 95%;">
 <script type="text/javascript">
  var root = new WebFXTree("0", "<fmt:message key='metadata.manager.public'/>");
  //root.target = "systemDataTree" ;
 	<c:forEach items="${treeData}" var="meta">
		 <c:choose>
		   <c:when test="${meta.is_formEnum =='1'}">
	         var metadata${fn:replace(meta.id, '-', '_')}= new WebFXTreeItem('${meta.id}',"${v3x:escapeJavascript(v3x:messageFromResource(meta.resourceBundle, meta.label))}");
	       </c:when>
	       <c:otherwise>
	         var metadata${fn:replace(meta.id, '-', '_')}= new WebFXTreeItem('${meta.id}',"${v3x:escapeJavascript(v3x:messageFromResource(meta.resourceBundle, meta.label))}");
	             metadata${fn:replace(meta.id, '-', '_')}.icon = "/seeyon/common/js/xtree/images/foldericon.png" ;
	             metadata${fn:replace(meta.id, '-', '_')}.openIcon = "/seeyon/common/js/xtree/images/openfoldericon.png" ;
	       </c:otherwise>
	    </c:choose> 
    	metadata${fn:replace(meta.id, '-', '_')}.is_formEnum = ${meta.is_formEnum} ;
    	metadata${fn:replace(meta.id, '-', '_')}.sort = ${meta.sort} ;
    	//metadata${fn:replace(meta.id, '-', '_')}.target = "systemDataTree" ;
    </c:forEach>
    
     <c:forEach items="${treeData}" var="meta">
	    <c:choose>
			    <c:when test="${meta.parentid == '0'&& meta.is_formEnum =='1'}">
				    root.add(metadata${fn:replace(meta.id, '-', '_')}) ;
				</c:when>
				<c:when test="${meta.parentid == '0'}">
				    root.add(metadata${fn:replace(meta.id, '-', '_')}) ;
				</c:when>
				<c:otherwise>
				   //root.add(metadata${fn:replace(meta.id, '-', '_')}) ;
				   metadata${fn:replace(meta.parentid, '-', '_')}.add(metadata${fn:replace(meta.id, '-', '_')}) ;
				</c:otherwise>
		  </c:choose>     
    </c:forEach>
    
    
	document.write(root);
	document.close();
	webFXTreeHandler.select(root); 

	try{
		var condition = "${condition}";
		if(condition != ""){
			<c:forEach items="${treeData}" var="meta">
				var childNodesLength = metadata${fn:replace(meta.id, '-', '_')}.childNodes.length;
				if(childNodesLength > 0){
					metadata${fn:replace(meta.id, '-', '_')};
				}
			</c:forEach>
		}
	} catch (e){}      
 </script>
</div>
<iframe name="systemDataTree" width="100%" height="100%" id="systemDataTree" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<script type="text/javascript">
<!--
showCondition("${condition}", "<v3x:out value='${textfield}' escapeJavaScript='true' />");
//-->
</script>
</body>
</html>