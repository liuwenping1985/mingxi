<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@include file="projectHeader.jsp"%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
${v3x:skin()}
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
<script type="text/javascript">
	//getA8Top().hiddenNavigationFrameset();
	<%--点击知识文档后 恢复左边栏--%>
// 	if(getA8Top().contentFrame.document.getElementById("LeftRightFrameSet").cols == "0,*"){
// 		getA8Top().contentFrame.leftFrame.closeLeft();
// 	}
	
		
	function openDoc(docResId){
  		var flag = openType(docResId);
  		if(flag){
	    	var first = flag.charAt(0);
	   		if(first != 'c' && first != 'l'){
				//归档类型
				var loc = flag.indexOf(',');
				var key = flag.substring(0, loc);
				var srcid = flag.substring(loc + 1, flag.length);
		    	var existFlag = pigSourceExist(key, srcid);
		
		       	if(existFlag == 'false'){
			    	alert(v3x.getMessage('ProjectLang.project_doc_not_exsit'));
			    	return;
		        }
	     	}
  	  	}
    	var ret = openDetailURL('${docURL}?method=docOpenIframeOnlyId&docResId=' + docResId);
    	if(document.getElementById("refreshFlag")){
 			var flag = document.getElementById("refreshFlag").value;
		 	if(flag=="true"){
			 	if(window.location.href.indexOf("queryMoreProjectDocByCondition")!=-1){
			 		queryMoreProjectDocByCondition();
			 	}else{
					window.location.reload(true);
			 	}
		 	}
   		}
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
	
	function queryMoreProjectDocByCondition() {
		 var condition = document.getElementById('condition').value;
	        if (condition == 'modifyDate') {
	            return dateCheck();
	        } else {
			searchForm.submit();
	        }
	}
	
	function init(){
		var nameDiv = document.getElementById("nameDiv");
		var modifyDateDiv = document.getElementById("modifyDateDiv");
		var lastUserIdDiv = document.getElementById("lastUserIdDiv");
		if ("${condition }" == "lastUserId") {
			nameDiv.style.display = "none";
			lastUserIdDiv.style.display = "block";
			modifyDateDiv.style.display = "none";
		} else if ("${condition }" == "name") {
			nameDiv.style.display = "block";
			lastUserIdDiv.style.display = "none";
			modifyDateDiv.style.display = "none";
		} else if ("${condition }" == "modifyDate") {
			nameDiv.style.display = "none";
			lastUserIdDiv.style.display = "none";
			modifyDateDiv.style.display = "block";
		} else if ("${condition}" == "choice") {
			nameDiv.style.display = "none";
			lastUserIdDiv.style.display = "none";
			modifyDateDiv.style.display = "none";
		}
		loadMBX();
		
		var top_div_row2 = document.getElementById("top_div_row2");
		var scrollListDiv = document.getElementById("scrollListDiv");
		var scrollbDivdocs = document.getElementById("bDivdocs");
		top_div_row2.style.position="relative";
		top_div_row2.style.height="";
		scrollListDiv.style.position="relative";
		scrollListDiv.style.top="5px";
		scrollListDiv.style.height = document.body.clientHeight - 35 + "px";
		//设置列表内容的高度使其可以铺满一页
		scrollbDivdocs.style.height = document.body.clientHeight - 35-32-30 + "px";
	}

	function doMySearchEnter(){
		var evt = v3x.getEvent();
	    if(evt.keyCode == 13){
	    	queryMoreProjectDocByCondition();
	    }
	}
	
	function fnRefreshDocMoreProjectInfo() {
		//在栏目进入，会刷新栏目，
		window.location.reload();
		//getA8Top().reFlesh();
	}
	
	function loadMBX(){
        showCtpLocation("F02_projectPersonPage");
    }
	
	function folderOpenFunById(id,frType){
		$("#main",parent.parent.document).attr("src","${docURL}?method=docHomepageIndex&docResId=" + id + "&frType=" + frType + "&t="+new Date())
	}
	
</script>

</head>
<body scroll="no" onload="init()" class="with-header-tab">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div id="top_div_row2">
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="">
  <%@ include file="moreProjectBanner.jsp"%>
  <tr>
    <td valign="top">
    
     <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page2-list-border">
        <tr>
            <td valign="top">
            
			   <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="bbs-table">
			   <tr>
			    <td class="webfx-menu-bar" > 
				  &nbsp;&nbsp; <fmt:message key='project.document'/>
				</td>
				<td class="webfx-menu-bar">
						<form action="" id="searchForm" name="searchForm" method="get" onkeydown="doMySearchEnter()">
							<input type="hidden" name="method" id="projectId" value="queryMoreProjectDocByCondition" />
							<input type="hidden" name="projectId" id="projectId" value="${projectId }" />
							<input type="hidden" name="phaseId" id="phaseId" value="${phaseId }" />
							<input type="hidden" name="managerFlag" id="managerFlag" value="${param.managerFlag }" />
					    	<div class="div-float-right" style="vertical-align:middle;">
					    		<div class="div-float">
									<select name="condition" id="condition" style="height:22px;" onChange="showNextSpecialCondition(this)" class="">
								    	<option value="choice" <c:if test="${condition == 'choice'}">selected</c:if>><fmt:message key="project.document.query" /></option>
									    <option value="name" <c:if test="${condition == 'name'}">selected</c:if>><fmt:message key="project.document.query.name" /></option>
                                        <option value="lastUserId" <c:if test="${condition == 'lastUserId'}">selected</c:if>><fmt:message key="doc.lastuser.js" /></option>
									    <option value="modifyDate" <c:if test="${condition == 'modifyDate'}">selected</c:if>><fmt:message key="project.document.query.midify.time" /></option>
								  	</select>
							  	</div>
							  	<div id="nameDiv" class="div-float hidden">
									<input type="text" name="name" value="${name }" class="textfield-search" onkeydown="">
							  	</div>
                                <div id="lastUserIdDiv" class="div-float hidden">
                                  <input type="text" id="lastUserId" name="lastUserId" value="${lastUserId}" class="textfield-search" onkeydown="">
                                </div>
							  	<div id="modifyDateDiv" class="div-float hidden">
									<input type="text" id="startdate" name="beginTime" value="${ beginTime}"  class="textfield-search" onclick="whenstart('${pageContext.request.contextPath}',this,575,240);" readonly>
									<input type="text" id="enddate" name="endTime" value = "${endTime}"  class="textfield-search" onclick="whenstart('${pageContext.request.contextPath}',this,575,240);" readonly>
								</div>	
							  	<div id="grayButton" onclick="queryMoreProjectDocByCondition()" class="div-float condition-search-button"></div>
					    	</div>
					    </form>
					</td>
			   </tr>
	</table>
	</td>
				</tr>
			</table>
		
</td>
</tr>
</table>
	</div>
	<div class="center_div_row2" id="scrollListDiv">
	                     <form>
							<v3x:table htmlId="docs"  data="docList" var="doc" >
								<c:set value="${doc.docResource.hasAttachments}" var="attflag" />
								<v3x:column width="30%" label="project.docment.title" hasAttachments="${attflag}" type="String">
				    				<img src="${pageContext.request.contextPath}${doc.icon}" />
				    				<a class="title-more sort" href="javascript:fnOpenKnowledge('${doc.docResource.id}')" title="${v3x:toHTML(doc.name)}">
										${doc.name}
									</a>
				    			</v3x:column>
				    			<v3x:column width="10%" label="project.docment.category" className="sort" type="String">
				    				${doc.type}
				    			</v3x:column>
                                <v3x:column width="15%" type="String" label="doc.lastuser.js" className="cursor-hand sort" value="${v3x:showMemberName(doc.docResource.lastUserId)}" />
                                
                                <v3x:column width="10%" type="Date" label="project.docment.updateTime">
                                    <fmt:formatDate value="${doc.lastUpdate }" pattern="${datetimePattern}"/>
                                </v3x:column>
                                
				    			<v3x:column width="34%" label="project.document.folder" alt="${doc.pathString}" className="sort" type="String">
				    				<a href="javascript:folderOpenFunById('${doc.docResource.parentFrId}','${doc.docResource.frType}');">${v3x:toHTML(v3x:getLimitLengthString(doc.pathString,62,"..."))}</a>
				    			</v3x:column>
							</v3x:table>
						</form>
					</div>
				
</div></div>
</body>
</html>