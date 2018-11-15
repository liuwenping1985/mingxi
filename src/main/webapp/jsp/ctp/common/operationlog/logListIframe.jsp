<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="logHeader.jsp" %>
<title></title>
<style>
SELECT{
		FONT-SIZE: 10pt; 
		FONT-FAMILY: Times New Roman;
		MARGIN-TOP:1px;
}
</style>	
<script type="text/javascript">	

	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	
	//
	//myBar.add(
	//	new WebFXMenuButton(
	//		"newBtn", 
	//		"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />",
	//		"deleteLog();",
	//		"<c:url value='/common/images/toolbar/delete.gif'/>", 
	//		"", 
	//		null
	//		)
	//);

	baseUrl='${log}?method=';
	
	function showByStatus(){
		window.document.searchForm.submit();
	}


function deleteLog() {
		  var checkedIds = document.getElementsByName('id');

		  var len = checkedIds.length;
		  
		  var str = "";

		  for(var i = 0; i < len; i++) {
		  		var checkedId = checkedIds[i];
				if(checkedId && checkedId.checked && checkedId.parentNode.parentNode.tagName == "TR" ){			
					str += checkedId.value;
					str +=","
				}
			}
			
		 //-- justify is any id has been chose.

		  if(str==null || str==""){
		  	alert(v3x.getMessage("LogLang.log_alertDontSelectMulti_delete"));
		  	return false;
		  }

		 //-- justification end.	
		 	
			str = str.substring(0,str.length-1);
			
			if(window.confirm(v3x.getMessage("LogLang.log_confirmdel"))){
			
			
					searchForm.target = "temp-iframe";
					searchForm.action = "${log}?method=deleteById&id="+str;
					searchForm.submit();
					//document.location.href='${log}?method=deleteById&id='+str;
			}
		}	
		
		
		function showDate(){
			var dateDiv = document.getElementById("date-div");
			dateDiv.className= "";
		}
		
		function hiddenDate(){
			var dateDiv = document.getElementById("date-div");
			dateDiv.className= "hidden";	
		}
		
	function changeSortType() {
		var category = searchForm.flowState.options[searchForm.flowState.selectedIndex].value;
		if (category == "0") {
			document.getElementById("date-div").style.display = "";
			document.getElementById("category-div").style.display = "none";
		}
		else {
			document.getElementById("date-div").style.display = "none";
			document.getElementById("category-div").style.display = "";
		}
	}
	
	function searchByself(){
		var b_date_obj = document.getElementById("beginDate");
		var e_date_obj = document.getElementById("endDate");
		var b_date = null;
		var e_date = null;
		if(b_date_obj && e_date_obj){
			b_date = b_date_obj.value;
			e_date = e_date_obj.value;
			if(b_date!=null && b_date!="" && e_date!=null && e_date!=""){
				var b = parseDate(b_date);
				var e = parseDate(e_date);
					if(e<b){
						alert(v3x.getMessage("LogLang.log_search_overtime"));
						return;
					}
			}
		}
		
		
		searchForm.target = "_self";
		searchForm.action = "${log}?method=list";
		searchForm.submit();
	}

function showLogCondition(conditionObject) {
    var options = conditionObject.options;
	var d = document.getElementById("date-div");//得到唯一查询条件赋值框：时间DIV
	if(options.value == '-1'){//如果选择的是--查询条件--
		d.style.display = "none";
		var bDate = document.getElementById("beginDate");
		if(bDate){
			bDate.value = '';
		}
		var eDate = document.getElementById("endDate");
		if(eDate){
			eDate.value = '';
		}
	}else{
		d.style.display = "block";
	}

    //for (var i = 0; i < options.length; i++) {
    //    var d = document.getElementById("date-div");
    //    if (d) {
   //         d.style.display = "none";
   //     }
  //  }
//if(!document.getElementById(conditionObject.value + "Div")) return;
 //   document.getElementById(conditionObject.value + "Div").style.display = "block";
}

window.onload = function(){
	var cate = document.getElementById("category");
	if(cate && cate.value!="-1"){
	var d = document.getElementById("date-div");//得到唯一查询条件赋值框：时间DIV
		d.style.display = "block";
	}
}
</script>
</head>
<body scroll="no" style="padding:0px">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="border-top">
	<tr>
		<td>
			<script type="text/javascript">
				document.write(myBar);	
				document.close();
			</script>
		</td>
		<td class="webfx-menu-bar">
			<form action="" name="searchForm" id="searchForm" method="post">
				<div class="div-float-right">
				<div id="category-div" name="category-div" class="div-float" style="valign:center">
				<fmt:message key="log.query.label.category" />
					<select id="category" name="category" class="condition" onchange="showLogCondition(this);">
						<option value="-1" <c:if test="${category == -1}"> selected </c:if> ><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}"/></option><!-- 全部 -->
						<option value="1" <c:if test="${category == 1}"> selected </c:if> ><fmt:message key="menu.collaboration" bundle="${v3xMainI18N}"/></option><!-- 协同 -->
						<option value="3" <c:if test="${category == 3}"> selected </c:if> ><fmt:message key="menu.doc" bundle="${v3xMainI18N}"/></option><!-- 知识管理 -->
						<c:if test="${edocEnabled == 'true'}">
						<option value="4" <c:if test="${category == 4}"> selected </c:if> ><fmt:message key="menu.edoc.edocManager" bundle="${v3xMainI18N}"/></option><!-- 公文 -->
						</c:if>
						<option value="7" <c:if test="${category == 7}"> selected </c:if> ><fmt:message key="menu.bulletin" bundle="${v3xMainI18N}"/></option><!-- 公告 -->
						<option value="8" <c:if test="${category == 8}"> selected </c:if> ><fmt:message key="menu.news" bundle="${v3xMainI18N}"/></option><!-- 新闻 -->
						<option value="10" <c:if test="${category == 10}"> selected </c:if> ><fmt:message key="menu.inquiry" bundle="${v3xMainI18N}"/></option><!-- 调查 -->												
						<option value="14" <c:if test="${category == 14}"> selected </c:if> ><fmt:message key="menu.project" bundle="${v3xMainI18N}"/></option><!-- 项目 -->
						<c:if test="${edocEnabled == 'true'}">
						<option value="16" <c:if test="${category == 16}"> selected </c:if> ><fmt:message key="menu.edoc.exchangeManager" bundle="${v3xMainI18N}"/></option><!-- 公文交换 -->
						</c:if>	
						<option value="17" <c:if test="${category == 17}"> selected </c:if> ><fmt:message key="application.17.label" bundle="${v3xCommonI18N}"/></option><!-- 人力资源 -->
						<option value="28" <c:if test="${category == 28}"> selected </c:if> ><fmt:message key="menu.modifypassword" bundle="${v3xMainI18N}"/></option><!-- 密码修改 -->
					</select>
				</div>
				
				<div class="div-float hidden" id="date-div" name="date-div">
					&nbsp;<fmt:message key="log.query.label.time" />&nbsp;
					<input type="text" name="beginDate" value="${beginDate}" class="textfield" size="10" maxlength="10" onclick="whenstart('/seeyon',this,300,340);" readonly>
					 - 
					<input type="text" name="endDate" value="${endDate}" class="textfield" size="10" maxlength="10" onclick="whenstart('/seeyon',this,425,340);" readonly>
				</div>
					
				<div onclick="javascript:searchByself();" class="condition-search-button"></div>
				
				</div>
			</form>
		</td>
	</tr>
	
	
<tr>
	<td height="100%" valign="top" colspan="2">
<div class="scrollList">
<form>
<v3x:table data="totalList" var="bean" htmlId="listTable" showHeader="true" showPager="true">
	<v3x:column width="15%" type="String"
		label="log.toolbar.title.operationTime" className="cursor-hand sort" symbol="..." maxLength="30">
	<fmt:formatDate value="${bean.operationLog.actionTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd HH:mm:ss"/>
	</v3x:column>
	<v3x:column width="30%" type="String" value="${bean.contentValue}" alt="${bean.contentValue }"
		label="log.toolbar.title.operation" className="cursor-hand sort" symbol="..." maxLength="40">
	</v3x:column>
	<v3x:column width="10%" type="String" value="${bean.category}"
		label="log.toolbar.title.category" className="cursor-hand sort" symbol="..." maxLength="18">
	</v3x:column>
	<v3x:column width="10%" value="${bean.ipAddress }"
		label="logon.search.ip" maxLength="40"  />	
	<v3x:column width="10%" type="String" value="${bean.personnel}"
		label="log.toolbar.title.stuff" className="cursor-hand sort" symbol="..." maxLength="18">
	</v3x:column>
	<v3x:column width="25%" type="String" value="${bean.accountName}"
		label="log.toolbar.title.account" className="cursor-hand sort" symbol="..." maxLength="35">
	</v3x:column>
</v3x:table>
</form>
</div>
</td>
</tr>
</table>
<div id="temp-div" name="temp-div" style="display:none">
<iframe name="temp-iframe" id="temp-iframe">&nbsp;</iframe>
</div>
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.log' bundle='${v3xMainI18N}'/>", [3,2], pageQueryMap.get('count'), _("LogLang.detail_info_2401"));	
</script>
</body>
</html>