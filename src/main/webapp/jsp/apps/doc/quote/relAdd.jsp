<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<c:set var="current_user_id"
	value="${sessionScope['com.seeyon.current_user'].id}" />


<script type="text/javascript">

	function addDocLink(){
		var docLinkArray=document.getElementsByName("id");
		var temp=0;
		var str="";
		var addString='${addString}';			//已经选中的要添加的ID串
		for(var i=0;i<docLinkArray.length;i++){
			if(docLinkArray[i].checked){
				if(i != docLinkArray.length-1){
					str+=docLinkArray[i].value;		//保存被选中的文档id
					str+=",";
					str+=docLinkArray[i].title;		//保存被选中的文档名称
					str+=";";
				}else{
					str+=docLinkArray[i].value;		
					str+=",";
					str+=docLinkArray[i].title;
				}
				temp=temp+1;
				if('${sourceId}' == docLinkArray[i].value){
					alert(v3x.getMessage("DocLang.doc_rel_alert_link_self"))
					return;
				}else if(docLinkArray[i].isFolder == 'true'){
					alert(v3x.getMessage("DocLang.doc_rel_alert_link_folder"))
					return ;
				}else if(docLinkArray[i].isDocLib == 'true'){
					alert(v3x.getMessage("DocLang.doc_rel_alert_link_lib"))
					return ;
				}
			}
		}
		if(temp == 0){
			alert(v3x.getMessage("DocLang.doc_rel_alert_select"))
			return ;
		}
		
		if(addString != 'null'){
			var last_str=contactStr(str,addString);
		}
		document.getElementById("relIdAndRelName").value=last_str;
		var _theForm=document.getElementById("searchForm");
		_theForm.target="docLinkFrame";
		_theForm.action="${detailURL}?method=docRelAdd&sourceId=${sourceId}&userId=${current_user_id}&flag=${flag }&deletedId=${deletedId}&relIdAndRelName="+encodeURI(last_str);
		_theForm.submit();
	}
	
	function openFolder(docResId,docResType,_bool){
		if(_bool == 'true' ){
			return ;
		}
		var theParent=parent.docIframe;
		var addString=document.getElementById("relIdAndRelName").value;		//选择要添加的关联文档ID
		theParent.location="${detailURL}?method=docRelFind&id="+docResId+"&sourceId=${sourceId}&contentType="+docResType+"&userId=${current_user_id}&flag=${flag }&deletedId=${deletedId}&addString="+addString+"&docLibId=${docLibId}";
		theParent.location.reload(true);
	}
	
	function contactStr(newString , olderString){
		var temp_str=olderString;
		var new_len=newString.split(";");
		var older_len=olderString.split(";");
		for(var i=0;i<new_len.length;i++){
			var temp=0;
			for(var j=0;j<older_len.length;j++){
				if(new_len[i] == older_len[j]){
					break;
				}else{
					temp=temp+1;
				}
			}
			
			if(temp == older_len.length){
				if(temp_str == null || temp_str == ""){
					temp_str+=new_len[i];
				}else{
					temp_str+=";";
					temp_str+=new_len[i];
				}
			}
		}
		return temp_str;
		
	}
	
	function seachDocRel(){
		 var fvalue = searchForm.flag.value;
		 //if(fvalue == null || fvalue ==""){
		 	//alert('请输入查询条件');
		 	//return ;
		 //}
		 var theParent=parent.docIframe;
		 var addString=document.getElementById("relIdAndRelName").value;		//选择要添加的关联文档ID
		 var _src="";
		 var method = "";
		 if(fvalue == "subject") {
		 	var name=document.getElementById("name").value;
		 	_src="${detailURL}?method=findDocRelByName&name="+encodeURI(name)+"&userId=${current_user_id}&rootId=${rootId}&sourceId=${sourceId}&flag=${flag }&deletedId=${deletedId}&addString="+addString+"&docLibId=${docLibId}";
	 	}else if(fvalue == "searchtype") {
	 		var type = searchForm.type.value;
			//alert(type)
			if(type == 'notype') {
				alert(v3x.getMessage("DocLang.doc_search_type_select"));
				return;
			}
	 	
	 		var type_id="";
	 		for(var i=0;i<searchForm.type.length;i++){
	 			if(searchForm.type.options[i].selected == true){
	 				type_id+=searchForm.type.options[i].value;
	 				break;
	 			}
	 		}
	 		_src="${detailURL}?method=findDocRelByType&typeId="+type_id+"&userId=${current_user_id}&rootId=${rootId}&sourceId=${sourceId}&flag=${flag }&deletedId=${deletedId}&addString="+addString+"&docLibId=${docLibId}";
	 		
	 	}else if(fvalue == "creator") {
	 		var creator=document.getElementById("creater").value;
	 		var userName=encodeURI(creator);
	 		_src="${detailURL}?method=findDocRelByCreator&creator="+userName+"&userId=${current_user_id}&rootId=${rootId}&sourceId=${sourceId}&flag=${flag }&deletedId=${deletedId}&addString="+addString+"&docLibId=${docLibId}";
	 	}else if(fvalue == "createDate") {
	 		var startDate = document.getElementById("beginTime");
			var endDate = document.getElementById("endTime");
			//时间校验
			if(startDate.value != '' && endDate.value != ''){
				var result = compareDate(startDate.value, endDate.value);
				if(result > 0){
					alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
					return;
				}
			}
	 		
		 	var begin_time=document.getElementById("beginTime").value;	
	 		var end_time=document.getElementById("endTime").value;
	 		_src="${detailURL}?method=findDocRelByTime&beginTime="+begin_time+"&endTime="+end_time+"&userId=${current_user_id}&rootId=${rootId}&sourceId=${sourceId}&flag=${flag }&deletedId=${deletedId}&addString="+addString+"&docLibId=${docLibId}";
		 } else if(fvalue == 'keywords'){
		 	var keyword=document.getElementById("keywords").value;
		 	_src="${detailURL}?method=findDocRelByKeywords&keywords="+encodeURI(keyword)+"&userId=${current_user_id}&rootId=${rootId}&sourceId=${sourceId}&flag=${flag }&deletedId=${deletedId}&addString="+addString+"&docLibId=${docLibId}";		 
		 }
	 	theParent.location =_src;
		theParent.location.reload(true);
	 
	}
	
</script>
</head>
<body onkeydown="listenerKeyESC()">
<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0">
	<tr height="20px"><td>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="10%">
	<tr ><td id="canOpen" width="25%" valign="center" height="22" class="webfx-menu-bar" onclick="openFolder('${parent.id }','${parent.frType}','${bool }')">&nbsp;&nbsp;
	<img src="/seeyon/common/images/arrow_u.gif" />&nbsp;<fmt:message key='doc.jsp.rel.parent'/>
	</td>
	<td height="22" valign="top">		
	    	<script type="text/javascript">
	    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");

	    	//myBar.add(new WebFXMenuButton("", "<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />", "javascript:addDocLink()", "", "", null));
	
	    	document.write(myBar);
	    	document.close();
	    	</script>		
		</td>
	<%-- 	<td>当前位置:</td>
		<td>${path}</td>--%>
		
			<%-- 当不是库列表时显示查询按钮 --%>
		<c:if test="${bool == false }">
		<td class="webfx-menu-bar" valign="top">		
				<form action="" name="searchForm" id="searchForm" method="post"
			onsubmit="return false" style="margin: 0px" target="docFrame">
			<input type="hidden" value="subject" name="flag">
		<div class="div-float-right">
		<div class="div-float"><select name="condition" id="condition"
			onChange="setFlag(this.value);showNextCondition(this)" class="condition">
			<option value="subject"><fmt:message
				key="doc.search.label" /></option>
			<option value="subject"><fmt:message
				key="doc.metadata.def.name" /></option>
			<option value="searchtype"><fmt:message
				key="doc.metadata.def.type" /></option>
			<option value="createDate"><fmt:message
				key="doc.metadata.def.createtime" /></option>
			<option value="creator"><fmt:message
				key="doc.metadata.def.creater" /></option>
			<option value="keywords"><fmt:message
				key="doc.metadata.def.keywords" /></option>
		</select></div>			
		<div id="subjectDiv" class="div-float"><input type="text"
			name="name" class="textfield"
			onkeydown="javascript:if(event.keyCode==13)return false;" >
		</div>
		<div id="searchtypeDiv" class="div-float hidden">
		<select name="type" >
				<option value="notype"><fmt:message
				key="doc.search.category.default" /></option>
		<c:forEach items="${the_types }" var="t">
			<option value="${t.id}">${v3x:_(pageContext, t.name)}</option>
		</c:forEach>
						
		</select>
		</div>
			
		<div id="creatorDiv" class="div-float hidden"><input
			type="text" id="creater"
			deaultvalue=""
			value=""
			inputName="<fmt:message key='doc.search.creator.label' />" name="creater"
			size="20" ></div>
		<div id="createDateDiv" class="div-float hidden">
		
			<input type="text" name="beginTime" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly >
			
			<input type="text" name="endTime" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly >
			  	
		</div>
		
		<div id="keywordsDiv" class="div-float hidden"><input type="text"
			name="keywords" class="textfield" id="keywords"
			onkeydown="javascript:if(event.keyCode==13)return false;" >
		</div>
			
		<div onclick="seachDocRel();" class="condition-search-button"></div>
		</div>
		</form>
		
	
		</td>
		</c:if>	
	</tr>
	
</table>
	</td></tr>
	
	<tr valign="top"><td><form>
	<v3x:table data="${the_list}" var="vo" isChangeTRColor="true" showHeader="true" htmlId="relAddTable" width="100%" >

	<c:if test="${bool == false }">
	<v3x:column width="5%" align="center"
				label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' id="id" value="${vo.docRes.id}" isFolder="${vo.docRes.isFolder }" title="${vo.docRes.frName }"  />
			</v3x:column>
			
				<v3x:column width="40%" align="left" label="${v3x:_(pageContext, 'common.name.label')}" >
			<c:if test="${vo.docRes.isFolder == true}">
			<a href="javascript:openFolder('${vo.docRes.id }','${vo.docRes.frType }')">
			</c:if>
			<img src="/seeyon/apps_res/doc/images/docIcon/${vo.icon }"> ${v3x:getLimitLengthString(v3x:_(pageContext, vo.docRes.frName), 28,'...')}
			<c:if test="${vo.docRes.isFolder == true}">
			</a>
			</c:if>
	</v3x:column>
			<v3x:column width="20%" align="left" label="${v3x:_(pageContext, 'doc.metadata.def.type')}">
		${v3x:_(pageContext, vo.type)}
	</v3x:column>

			<v3x:column width="10%" align="left" label="${v3x:_(pageContext, 'common.creater.label')}" value="${vo.userName }">
				
			</v3x:column>
				
			<v3x:column width="30%" align="left" label="${v3x:_(pageContext, 'common.date.createtime.label')}">
				<fmt:formatDate value="${vo.docRes.createTime}" pattern="${ datetimePattern }"/>
			</v3x:column>

	</c:if>
<c:if test="${bool == true }">
	
	<v3x:column width="5%" align="center"
				label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' id="id" value="${vo.doclib.id}"  isDocLib="true" />
			</v3x:column>
	<v3x:column width="45%" align="left" label="${v3x:_(pageContext, 'common.name.label')}" >
			<img src="/seeyon/apps_res/doc/images/docIcon/${vo.icon}"> <a href="javascript:openFolder('${vo.root.docResource.id }','${vo.root.docResource.frType }')">${v3x:_(pageContext, vo.doclib.name)}</a>
	</v3x:column>
			<v3x:column width="15%" align="left" label="${v3x:_(pageContext, 'doc.metadata.def.type')}">
			<fmt:message key="${vo.docLibType }"/>
	</v3x:column>
			<v3x:column width="10%" align="left" label="${v3x:_(pageContext, 'common.creater.label')}" value="${vo.createName }">
				
			</v3x:column>
			<v3x:column width="30%" align="left" label="${v3x:_(pageContext, 'common.date.createtime.label')}">
				<fmt:formatDate value="${vo.doclib.createTime}" pattern="${ datetimePattern }"/>
			</v3x:column>
</c:if>
</v3x:table></form>
	</td></tr>
</table>




<input type="hidden" name="relIdAndRelName" id="relIdAndRelName" value="">

<iframe  name="docLinkFrame" id="docLinkFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</iframe> 
</body>
</html>
