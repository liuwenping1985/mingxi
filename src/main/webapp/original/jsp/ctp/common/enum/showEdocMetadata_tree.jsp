<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Insert title here</title>
		<%@ include file="../header.jsp"%>
		<script>

			function disaplayToolBar(type){
				if(type ==3){
					<c:if test="${v3x:getSysFlagByName('sys_isGovVer')!='true'}">
					if(parent.mainFrame.rows == "0,*"){
		  				parent.mainFrame.rows = "30,*";
			  		}
			  		</c:if>
				}else{
					if(parent.mainFrame.rows == "30,*"){
		  				parent.mainFrame.rows = "0,*";
			  		}
				}
			}

			function changeMenu(type){
				var oUnMetadataToolbar = parent.toolbarFram.document.getElementById('unMetadataToolbar');
				var oMetadataToolbar = parent.toolbarFram.document.getElementById('metadataToolbar');
				var oMetadataValueToolbar = parent.toolbarFram.document.getElementById('metadataValueToolbar');
				if(oUnMetadataToolbar!=null && oMetadataToolbar!=null && oMetadataValueToolbar != null){
			  		if(type == "unMetadataToolbar"){
				  		oUnMetadataToolbar.className = "show";
				  		oMetadataToolbar.className = "hidden";
				  		oMetadataValueToolbar.className = "hidden";
			  		}else if(type == "metadataToolbar"){
				  		oUnMetadataToolbar.className = "hidden";
				  		oMetadataToolbar.className = "show";
				  		oMetadataValueToolbar.className = "hidden";
				  	}else{
				  		oUnMetadataToolbar.className = "hidden";
				  		oMetadataToolbar.className = "hidden";
				  		oMetadataValueToolbar.className = "show";
					}
	  			}
			}
			
			function showList(type,acconutId){
				disaplayToolBar(type);
		  		if(type == 1){
		  			parent.listFrame.location.href = metadataURL+"?method=systemMetadataList";
		  		}else if(type == 2){
			  		parent.listFrame.location.href = metadataURL+"?method=userDefinedmetadataList";
		  		}else{
		  			changeMenu("unMetadataToolbar");
			  		parent.listFrame.location.href = metadataURL+"?method=userDefinedmetadataList&org_account_id="+acconutId;	
			  		<c:if test ="${v3x:getSysFlagByName('sys_isGovVer')=='true'}">
						parent.listFrame.location.href = metadataURL+"?method=userDefinedmetadataList&org_account_id="+acconutId+"&edocTree=true";
					</c:if>  
			  	}
			}

			function showChildOfMetadataItem(type,metadataItemId,parentType){
				disaplayToolBar(type);
				changeMenu("metadataValueToolbar");
				parent.listFrame.location.href = metadataURL + "?method=userDefinedmetadataItemList&parentId="+metadataItemId+"&parentType="+parentType+"&isSystem=true" ;
			}
			
			function showMetadataItemList(type,metadataId ,metadataType){
				disaplayToolBar(type);
				changeMenu("metadataToolbar");
				if(type == 2){
				   	parent.listFrame.location.href = metadataURL + "?method=userDefinedmetadataList&parentId="+metadataId+"&metadataType="+metadataType+"&isSystem=true" ;
				}else{

					//branches_a8_v350_r_gov GOV-2962 常屹 修改 
					//GOV-2962 【公文管理】-【基础数据】-【枚举管理】，点击单位枚举下的枚举类型或者枚举后，当前位置和左导航就变成'表单管理-枚举管理-单位枚举'了
					var url = "?method=showOrgMetadataList&metadataId="+metadataId+"&metadataType="+metadataType+"&isSystem=true"
					<c:if test ="${v3x:getSysFlagByName('sys_isGovVer')=='true'}">
						//当是政务版时，这里增加一个参数
						url += "&edocTree=true";
					</c:if>
					parent.listFrame.location.href = metadataURL + url ;
				}
			}

			function showMetadataValuesList(type,metadataId){
				disaplayToolBar(type);
				changeMenu("metadataValueToolbar");
				if(type == 1){
					parent.listFrame.location.href = metadataURL+"?method=systemMetadataListItemList&id="+metadataId;
				}else{
					parent.listFrame.location.href = metadataURL+"?method=userDefinedmetadataItemList&isSystem=true&parentType=metadata&parentId="+metadataId;
					<c:if test ="${v3x:getSysFlagByName('sys_isGovVer')=='true'}">
						parent.listFrame.location.href = metadataURL+"?method=userDefinedmetadataItemList&isSystem=true&parentType=metadata&parentId="+metadataId+"&edocTree=true";
					</c:if>
				}
			}
		</script>
	</head>
	<body scroll="no" onresize="resizeBody(100,'treeandlist','min','left')">
		<div class="scrollList border-padding">
			<script type="text/javascript">
				var root = new WebFXTree("root", "<fmt:message key = 'metadata.manager.metadatamgr' />");
				root.setBehavior('classic');
				root.icon = "<c:url value='/common/images/left/icon/5101.gif'/>";
				root.openIcon = "<c:url value='/common/images/left/icon/5101.gif'/>";
				var systemMetaData = new WebFXTreeItem("system", "<fmt:message key='metadata.manager.name'/>", "javascript:showList(1);");
				systemMetaData.icon = "<c:url value='/common/js/xtree/images/foldericon.png'/>";
				systemMetaData.openIcon = "<c:url value='/common/js/xtree/images/openfoldericon.png'/>";
				var publicMetaData = new WebFXTreeItem("system", "<fmt:message key='metadata.manager.public'/>", "javascript:showList(2);");
				publicMetaData.icon = "<c:url value='/common/js/xtree/images/foldericon.png'/>";
				publicMetaData.openIcon = "<c:url value='/common/js/xtree/images/openfoldericon.png'/>";
				var orgMetaData = new WebFXTreeItem("system", "<fmt:message key='metadata.manager.account' bundle="${v3xMainI18N}"/>", "javascript:showList(3, '${acconutId}');");
				orgMetaData.icon = "<c:url value='/common/js/xtree/images/foldericon.png'/>";
				orgMetaData.openIcon = "<c:url value='/common/js/xtree/images/openfoldericon.png'/>";
		
				//系统枚举
				<c:forEach items="${sysMetadatasList}" var="meta">
					<c:if test="${meta.canEdit == 'true'}">
						var metadata${fn:replace(meta.id, '-', '_')}= new WebFXTreeItem('meta_${meta.id}',"${v3x:messageFromResource(meta.resourceBundle, meta.label)}","javascript:showMetadataValuesList(1, '${meta.id}')");
						systemMetaData.add(metadata${fn:replace(meta.id, '-', '_')});
					</c:if>	
				</c:forEach>
					
				//公共枚举
				<c:forEach items="${publicMetadatasList}" var="meta">
				 	<c:choose>
				   		<c:when test="${meta.is_formEnum =='1'}">
			         		var metadata${fn:replace(meta.id, '-', '_')}= new WebFXTreeItem('${meta.id}',"${v3x:escapeJavascript(v3x:messageFromResource(meta.resourceBundle, meta.label))}","javascript:showMetadataValuesList(2, '${meta.id}')");
			       		</c:when>
			       		<c:otherwise>
			         		var metadata${fn:replace(meta.id, '-', '_')}= new WebFXTreeItem('${meta.id}',"${v3x:escapeJavascript(v3x:messageFromResource(meta.resourceBundle, meta.label))}","javascript:showMetadataItemList(2, '${meta.id}','${meta.is_formEnum}')");
			             	metadata${fn:replace(meta.id, '-', '_')}.icon = "/seeyon/common/js/xtree/images/foldericon.png" ;
			             	metadata${fn:replace(meta.id, '-', '_')}.openIcon = "/seeyon/common/js/xtree/images/openfoldericon.png" ;
			       		</c:otherwise>
			    	</c:choose> 
				  	metadata${fn:replace(meta.id, '-', '_')}.is_formEnum = '${meta.is_formEnum}' ;
				  	metadata${fn:replace(meta.id, '-', '_')}.sort = '${meta.sort}' ;
				  	metadata${fn:replace(meta.id, '-', '_')}.type="metadata" ;
		  		</c:forEach>
		
			  	<c:forEach items="${publicMetadataItemList}" var="metaItem">
					var metadata${fn:replace(metaItem.id, '-', '_')}= new WebFXTreeItem('${metaItem.id}',"${v3x:escapeJavascript(metaItem.label)}","javascript:showChildOfMetadataItem(2, '${metaItem.id}','metadataItem')");
					metadata${fn:replace(metaItem.id, '-', '_')}.parentid = '${metaItem.parentId}' ;
					metadata${fn:replace(metaItem.id, '-', '_')}.metadataId = '${metaItem.metadataId}' ;
					metadata${fn:replace(metaItem.id, '-', '_')}.type = "metadataItem" ;
					metadata${fn:replace(metaItem.id, '-', '_')}.isref = "${metaItem.isRef}" ;
				</c:forEach>
			  
			  	<c:forEach items="${publicMetadatasList}" var="meta">
				    <c:choose>
						<c:when test="${meta.parentid == '0'&& meta.is_formEnum =='1'}">
							publicMetaData.add(metadata${fn:replace(meta.id, '-', '_')}) ;
						</c:when>
						<c:when test="${meta.parentid == '0'}">
							publicMetaData.add(metadata${fn:replace(meta.id, '-', '_')}) ;
						</c:when>
						<c:otherwise>
						   	metadata${fn:replace(meta.parentid, '-', '_')}.add(metadata${fn:replace(meta.id, '-', '_')}) ;
						</c:otherwise>
				  	</c:choose>     
				</c:forEach>
		  
			   	<c:forEach items="${publicMetadataItemList}" var="metaItem">
			   		var metaItemParentId="${metaItem.parentId}" ;
			   		var metaItemMetdataId="${metaItem.metadataId}" ;
				 	if(metaItemParentId == ''){
				 		metadata${fn:replace(metaItem.metadataId, '-', '_')}.add(metadata${fn:replace(metaItem.id, '-', '_')}) ;
					}else if(metaItemMetdataId == '' || metaItemMetdataId == '0'){
						metadata${fn:replace(metaItem.parentId, '-', '_')}.add(metadata${fn:replace(metaItem.id, '-', '_')}) ;			  		
					}
				</c:forEach>
		
		
				//单位枚举
				<c:forEach items="${orgMetadatasList}" var="meta">
				 	<c:choose>
				   		<c:when test="${meta.is_formEnum =='1'}">
			         		var metadata${fn:replace(meta.id, '-', '_')}= new WebFXTreeItem('${meta.id}',"${v3x:escapeJavascript(v3x:messageFromResource(meta.resourceBundle, meta.label))}","javascript:showMetadataValuesList(3, '${meta.id}')");
			       		</c:when>
			       		<c:otherwise>
			         		var metadata${fn:replace(meta.id, '-', '_')}= new WebFXTreeItem('${meta.id}',"${v3x:escapeJavascript(v3x:messageFromResource(meta.resourceBundle, meta.label))}","javascript:showMetadataItemList(3, '${meta.id}','${meta.is_formEnum}')");
			             	metadata${fn:replace(meta.id, '-', '_')}.icon = "/seeyon/common/js/xtree/images/foldericon.png" ;
			             	metadata${fn:replace(meta.id, '-', '_')}.openIcon = "/seeyon/common/js/xtree/images/openfoldericon.png" ;
			       		</c:otherwise>
			    	</c:choose> 
		    		metadata${fn:replace(meta.id, '-', '_')}.is_formEnum = ${meta.is_formEnum} ;
		    		metadata${fn:replace(meta.id, '-', '_')}.sort = ${meta.sort} ;
		    		metadata${fn:replace(meta.id, '-', '_')}.type="metadata" ;
		    	</c:forEach>
		
			    <c:forEach items="${orgMetadataItemList}" var="metaItem">
					var metadata${fn:replace(metaItem.id, '-', '_')}= new WebFXTreeItem('${metaItem.id}',"${v3x:toHTML(metaItem.label)}","javascript:showChildOfMetadataItem(3, '${metaItem.id}','metadataItem')");
					metadata${fn:replace(metaItem.id, '-', '_')}.parentid = '${metaItem.parentId}' ;
					metadata${fn:replace(metaItem.id, '-', '_')}.metadataId = '${metaItem.metadataId}' ;
					metadata${fn:replace(metaItem.id, '-', '_')}.type = "metadataItem" ;
					metadata${fn:replace(metaItem.id, '-', '_')}.isref = "${metaItem.isRef}" ;
				</c:forEach>
		    
			    <c:forEach items="${orgMetadatasList}" var="meta">
				    <c:choose>
					    <c:when test="${meta.parentid == '0'&& meta.is_formEnum =='1'}">
					    	orgMetaData.add(metadata${fn:replace(meta.id, '-', '_')}) ;
						</c:when>
						<c:when test="${meta.parentid == '0'}">
							orgMetaData.add(metadata${fn:replace(meta.id, '-', '_')}) ;
						</c:when>
						<c:otherwise>
						   	metadata${fn:replace(meta.parentid, '-', '_')}.add(metadata${fn:replace(meta.id, '-', '_')}) ;
						</c:otherwise>
			  		</c:choose>     
			    </c:forEach>
		
			   	<c:forEach items="${orgMetadataItemList}" var="metaItem">
			   		<c:choose>
						<c:when test="${empty metaItem.parentId}">
							metadata${fn:replace(metaItem.metadataId, '-', '_')}.add(metadata${fn:replace(metaItem.id, '-', '_')}) ;
						</c:when>
						<c:when test="${empty metaItem.metadataId || metaItem.metadataId == '0'}">
							metadata${fn:replace(metaItem.parentId, '-', '_')}.add(metadata${fn:replace(metaItem.id, '-', '_')}) ;	
						</c:when>
			   		</c:choose>
				</c:forEach>

				root.add(systemMetaData);
				root.add(publicMetaData);
				root.add(orgMetaData);
				document.write(root);
				document.close();
			 	systemMetaData.expand();
		
		   		if(parent.toolbarFram!=null){	
			   		var treeId = parent.toolbarFram.treeSelectId ;
			   		var parentId = parent.toolbarFram.parentId ;	
				   	if(treeId && parentId){
					  	if(treeId.indexOf('-') >= 0){
					     	treeId = treeId.substr(1 ,treeId.length) ;
					     	treeId = "_" + treeId ;
					  	}
					  	if(parentId.indexOf('-') >= 0){
						  	parentId = parentId.substr(1 ,parentId.length) ;
						  	parentId = "_" + parentId ;
					  	}    
					  	try{
					     	var selectObj = eval("metadata" + treeId) ;
					     	var parentObj = eval("metadata" + parentId) ;
					     	webFXTreeHandler.expentSelect(selectObj,parentObj) ;
					   	}catch(e){
						   	try{
							   	var selectObj = eval("metadata" + treeId) ;
						       	webFXTreeHandler.select(selectObj);
						   	}catch(e){
							   	webFXTreeHandler.select(root);
						   	}
					   	}
					}else{
						if(treeId){
							if(treeId.indexOf('-') >= 0){
								treeId = treeId.substr(1 ,treeId.length) ;
							    treeId = "_" + treeId ;
							}
							try{
								var selectObj = eval("metadata" + treeId) ;
							 	webFXTreeHandler.select(selectObj);
							}catch(e){
								webFXTreeHandler.select(root);
							}
						} else {
							webFXTreeHandler.select(root);
						}
					}
				}
			</script>
		</div>
	</body>
</html>
