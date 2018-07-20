<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title></title>
		<%@ include file="header.jsp" %>
		<c:set value="全选" var="selectAllLabel" />
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript">

			$(function() {
				setTimeout(function() {
					if($("#headIDlistTable") != null) {
						$("#headIDlistTable").find("th").eq(0).find("div").attr("title", '${v3x:escapeJavascript(selectAllLabel)}');
					}
				}, 100);
			});
		
			function showDetail(id){
				var meetingRoomId = document.getElementById('id_'+id).value;
				//xiangfan 添加openWin参数，用来标示：是通过首页打开的页面，还是在会议室审核页面打开的。
				parent.detailFrame.location = "${mrUrl}?method=createPerm&id="+id+"&readOnly=true&openWin=openWin&flag=${v3x:escapeJavascript(param.flag)}&meetingRoomId="+meetingRoomId; 
			}

			function checkMoreSelect(formNode){
				var ns = formNode.getElementsByTagName("input");
				var ids = "";
				for(var i = 0; i < ns.length; i++){
					if(ns[i].type == "checkbox" && ns[i].name == "id" && ns[i].checked){
						ids += ns[i].value+",";
					}
				}
				if(ids != ""){
					ids = ids.substring(0,ids.length-1);
					return ids;
				}
				
				return "";
			}
			
			function doCancel(){
				/*修正不能批量撤销会议室申请的BUG*/
				var id = checkMoreSelect(document.listForm);
				//var isOne = checkSelectOne(document.listForm);
				var meetingName;
				/*
				if(isOne == "false"){
					alert("<fmt:message key='mr.alert.cancelselectone'/>");
					return false;
				}*/
				/** xiangfan 修改doCancel()  GOV-384 GOV-383  2012-04-16 */
				if(id!=''){
					var curretnDate = new Date();
					curretnDate = curretnDate.format("yyyy-MM-dd HH:mm");
					curretnDate = Date.parse(curretnDate.replace(/\-/g,"/"));
					var ids = id.split(",");
					var meetingName = "";
					var meetingNameStr = "";
					var meetingRoomStartTime = "";
					var meetingRoomEndTime = "";
					for(i = 0;i<ids.length;i++){
						meetingRoomStartTime = document.getElementById("startDatetime_"+ids[i]).value;
						meetingRoomStartTime = Date.parse(meetingRoomStartTime.replace(/\-/g,"/"));
						meetingRoomEndTime = document.getElementById("endDatetime_"+ids[i]).value;
						meetingRoomEndTime = Date.parse(meetingRoomEndTime.replace(/\-/g,"/"));
						if(document.getElementById(ids[i]).value != ""){
							meetingNameStr += document.getElementById(ids[i]).value+",";
							meetingName = document.getElementById(ids[i]).value;
						}
						if(curretnDate > meetingRoomStartTime && curretnDate < meetingRoomEndTime){
							//if(meetingName != ""){
							//	alert("会议： " + meetingName + " 正在召开中，不允许撤销会议室！");
							//}else{
						    //	alert("会议正在召开，不允许撤销会议室！");
							//}
							//alert("会议室正在使用中，不允许撤销会议室！");
							//return ;
						}else if(curretnDate > meetingRoomEndTime){
							//if(meetingName != ""){
							//	alert("会议： " + meetingName + " 已召开完毕，不允许撤销会议室！");
							//}else{
							//	alert("会议已召开完毕，不允许撤销会议室！");
							//}
							alert("会议室使用时间已过，不允许撤销会议室！");
							return ;
						}
						
					}
					if(meetingNameStr != ""){
						meetingNameStr = meetingNameStr.substring(0,meetingNameStr.length-1);
					}
					
				}
				var cancle = "<fmt:message key='mr.alert.meetingRoomCancle1'/>"+meetingNameStr+"<fmt:message key='mr.alert.meetingRoomCancle2'/>";
				if(id != ""){
					if(meetingNameStr!=""){
						if(confirm(cancle)){
							document.listForm.action = "${mrUrl}?method=execCancel";
							document.listForm.submit();
						}
					}else if(confirm("<fmt:message key='mr.alert.confirmcancel'/>")){
						document.listForm.action = "${mrUrl}?method=execCancel";
						document.listForm.submit();
					}
				}else{
					alert("<fmt:message key='mr.alert.pleaseselecttocancel'/>！");
					return false;
				}
			}
			function setBulPeopleFields(elements){
				if(elements.length > 0){
					var element = elements[0];
					document.getElementById("perId").value=element.id;
					document.getElementById("perName").value=element.name;
				}
			}
			function initSearchCondition(){
				<c:if test="${selectCondition!=null}">
					var selectNode = document.getElementById("selectCondition");
					selectNode.selectedIndex = ${selectCondition};
					showCondition(selectNode);
					<c:choose>
						<c:when test="${selectCondition == 1}">
							document.getElementById("name").value = "${v3x:escapeJavascript(conditionValue)}";
						</c:when>
						<c:when test="${selectCondition == 2}">
							document.getElementById("name").value = "${v3x:escapeJavascript(conditionValue[0])}";
							document.getElementById("name1").value = "${v3x:escapeJavascript(conditionValue[1])}";
						</c:when>
					</c:choose>
				</c:if>
			}
			/** xiangfan 注释 使用A8自带的方法  修复 GOV-1959 2012-04-20*/
			//function showCondition(node){
			//	var inputDiv = document.getElementById("condition_div");
			//	var str = "";
			//	if(node.value == "0"){
			//		str = "";
			//	}else if(node.value == "1"){
			//		str += "<input type='text'  id='name' name='name' inputName='<fmt:message key='mr.label.querycondition'/>：<fmt:message key='mr.label.meetingroomname'/>' validate='maxLength' maxLength='50' style='width:100px' autoComplete='off' />";
			//	}else if(node.value == "2"){
			//		str +="<fmt:message key='mr.label.start'/><input type='text' id='name' name='name' inputName=\"<fmt:message key='mr.label.start'/>\" style='width: 80px;' onclick=\"whenstart('${pageContext.request.contextPath}',this,175, 140);\" readonly/>&nbsp;&nbsp";
			//		str +="<fmt:message key='mr.label.end'/><input type='text'  id='name1' name='name1' inputName=\"<fmt:message key='mr.label.end'/>\" style='width: 80px;' onclick=\"whenstart('${pageContext.request.contextPath}',this,175, 140);\" readonly />";
			//	}else if(node.value == "3"){
			//		str += "<input type='hidden' name='perId' value='' />";
			//		str += "<input type='text' name='perName' inputName='<fmt:message key='mr.label.querycondition'/>：<fmt:message key='mr.label.appPerson'/>' deaultValue='<<fmt:message key='mr.alert.clickToSelectPerson'/>>' validate='notNull,isDeaultValue' value='<<fmt:message key='mr.alert.clickToSelectPerson'/>>' onclick='selectPeopleFun_per()' readonly />";
			//	}
			//	inputDiv.innerHTML = str;
			//}
			//function doSearch(){
			//	if(checkForm(document.searchForm)){
			//		document.searchForm.submit();
			//	}
			//}
			
			/** xiangfan 修改doClear()  GOV-385 GOV-386  2012-04-16 
			function doClear(){
				var id = checkSelect(document.listForm);
				var delFlag = true;
				if(id != ""){
					var meetingName = "";
					var meetingNameStr = "";
					var curretnDate = new Date();
					curretnDate = curretnDate.format("yyyy-MM-dd HH:mm");
					curretnDate = Date.parse(curretnDate.replace(/\-/g,"/"));
					var meetingRoomStartTime = "";
					var meetingRoomEndTime = "";
					var ns = document.listForm.getElementsByTagName("input");
					for(var i = 0; i < ns.length; i++){
						if(ns[i].type == "checkbox" && ns[i].name == "id" && ns[i].checked){
							meetingRoomStartTime = document.getElementById("startDatetime_"+ns[i].value).value;
							meetingRoomStartTime = Date.parse(meetingRoomStartTime.replace(/\-/g,"/"));
							meetingRoomEndTime = document.getElementById("endDatetime_"+ns[i].value).value;
							meetingRoomEndTime = Date.parse(meetingRoomEndTime.replace(/\-/g,"/"));
							if(document.getElementById(ns[i].value).value != ""){
								meetingNameStr += document.getElementById(ns[i].value).value+",";
								meetingName = document.getElementById(ns[i].value).value;
							}
							var isAllowed = document.getElementById("isAllowed_"+ns[i].value).value;
							if(isAllowed == "${MRConstants.Status_App_Wait}"){
								alert("<fmt:message key='mr.alert.cannotclear'/>！");
								return false;
							}
							if(curretnDate > meetingRoomStartTime && curretnDate < meetingRoomEndTime){
								delFlag = true;
								break;
							}else if(curretnDate > meetingRoomEndTime) {
								delFlag = true;
								break;
							}
						}
					}
					if(meetingNameStr != ""){
						meetingNameStr = meetingNameStr.substring(0,meetingNameStr.length-1);
					}
					var cancle = "<fmt:message key='mr.alert.meetingRoomCancle1'/>"+meetingNameStr+"<fmt:message key='mr.alert.meetingRoomDelete1'/>";
					if(delFlag) {
						if(meetingNameStr!="") {
							cancle = "该会议室已安排了 " +meetingNameStr+ " 会议，如果删除会影响会议的正常进行，确认是否删除?";
						} else {
							cancle = "该会议室已安排了会议，如果删除会影响会议的正常进行，确认是否删除?";
						}
					} else {
						cancle = "是否删除此会议室申请?";
					}
					if(confirm(cancle)){
						document.listForm.action = "${mrUrl}?method=execClearPerm";
						document.listForm.submit();
					}
				}else{
					alert("<fmt:message key='mr.alert.pleaseselecttoclear'/>！");
					return false;
				}
			}*/
			function doClear(){
				var id = checkSelect(document.listForm);
				if(id != ""){
					var ns = document.listForm.getElementsByTagName("input");
					for(var i = 0; i < ns.length; i++){
						if(ns[i].type == "checkbox" && ns[i].name == "id" && ns[i].checked){
							var isAllowed = document.getElementById("isAllowed_"+ns[i].value).value;
							if(isAllowed == "${MRConstants.Status_App_Wait}"){
								alert("<fmt:message key='mr.alert.cannotclear'/>！");
								return false;
							}
						}
					}
					if(confirm("<fmt:message key='mr.alert.confirmClear'/>")){
						document.listForm.action = "${mrUrl}?method=execClearPerm";
						document.listForm.submit();
					}
				}else{
					alert("<fmt:message key='mr.alert.pleaseselecttoclear'/>！");
					return false;
				}
			}
			function search_result(){
				var beginDate = document.getElementById("fromDate").value;
				var endDate = document.getElementById("toDate").value;
				if(compareDate(beginDate,endDate)>0){
					alert(v3x.getMessage("officeLang.meetingRoom_time_alert"));
					return ;
				}
				doSearch();
			}
			function ChangeEvent(o){
			  var beginDate = document.getElementById("fromDate");
		      var endDate = document.getElementById("toDate");
		      if(beginDate != null && endDate != null){
		         beginDate.value = "";
		         endDate.value = "";
		      } 
			  showCondition(o);
			}
			
		//isValid 人员是否是有效的，换句话说就是是否已经离职，离职不允许弹出人员卡片
      function displayPeopleCard(memberId, isValid){
        if(!isValid || isValid == "false"){
          return ;
        }
        showV3XMemberCardWithOutButton(memberId);
      }
		</script>
		<script type="text/javascript">
		var list = "${v3x:escapeJavascript(param.list)}";
		var flag = "${v3x:escapeJavascript(flag)}";
		var select = "${v3x:escapeJavascript(param.select)}";
		if(flag!=null){
			list=flag;
		}
		//lijl添加"当前位置"
		showCtpLocation("F09_meetingRoom");
		</script>
		<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
	</head>
	<v3x:selectPeople id="per" panels="Department" selectType="Member" jsFunction="setBulPeopleFields(elements);" minSize="1" maxSize="1" />
	<%-- xiangfan 2012-04-20 去掉onload事件 initSearchCondition()方法 ，改为A8的showCondition()方法保留查询历史--%>
	<body style="overflow: auto" style="padding: 0px" onload="">
	<div class="main_div_row2">
  		<div class="right_div_row2">
    		     <div class="top_div_row2">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   		<tr>
				<td height="22" class="webfx-menu-bar">
	   				<script type="text/javascript">
	   					var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","gray");
	   					if(list!='noReview'){
	   						myBar.add(new WebFXMenuButton("create", "<fmt:message key='common.toolbar.cancel.label' bundle='${v3xCommonI18N}'/>", "doCancel()", [3,8]));
	   					}
	   					if(list=='noReview'){
	   						myBar.add(new WebFXMenuButton("modify", "<fmt:message key='mr.button.del'/>", "doClear()", [1,3]));
	   					}
	   					document.write(myBar);
					    document.close();
	   				</script>
	   			</td>
	   			<td class="webfx-menu-bar">
	   			<%-- xiangfan 修改 2012-04-14  GOV-832 start
	   			<form name="searchForm" action="${mrUrl}?method=listMyApplication" method="get" onsubmit="">
	   			 --%>
	   			<form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
	   			<input type="hidden" name="flag" value="${v3x:toHTML(flag)}"/>
	   			<input type="hidden" name="method" value="listMyApplication"/>
	   			<%-- xiangfan 修改 2012-04-14  GOV-832 end --%>
	   			
	   			<%-- xiangfan 再次修改为的A8自带的方法和规则 修复 GOV-1959 2012-04-20 Start --%>
	   			<div class="div-float-right condition-search-div">
	   				<div class="div-float">
	   				<select id="condition" name="condition" onChange="ChangeEvent(this)" class="condition" >
	   					<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
	   					<option value="1"><fmt:message key='mr.label.meetingroomname'/></option>
	   					<option value="2"><fmt:message key='mr.label.appTime'/></option>
	   					<option value="3"><fmt:message key='mr.label.checkStatus'/></option>
	   				</select>
	   				</div>
	   				<!-- <div id="condition_div" class="div-float" style="height:30px;line-height:15px;vertical-align:middle;"></div> -->
	   				<div id="1Div" class="div-float hidden">
						<input type="text" name="textfield" class="textfield" />
					</div>
	   				<div id="2Div" class="div-float hidden">
						<input type="text" name="textfield" id="fromDate" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly /> 
						- 
						<input type="text" name="textfield1" id="toDate" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly />
					</div>
					<div id="3Div" class="div-float hidden">
						<select name="textfield">
							<option value="0,1,2">请选择</option>
							<option value="0">待审核</option>
							<option value="1">审核通过</option>
							<option value="2">审核未通过</option>
						</select>
					</div>
	   				<div onclick="search_result();" class="condition-search-button div-float"></div>
	   			</div>
	   			</form>
	   			</td>
	   			<%-- xiangfan 再次修改为的A8自带的方法和规则 修复 GOV-1959 2012-04-20 End --%>
	   		</tr>
	   	</table>
             </div>
    <div class="center_div_row2" id="scrollListDiv">
    <form name="listForm" id="listForm" method="post" style="margin: 0px">
    <v3x:table htmlId="listTable" data="list" var="bean" pageSize="${pageSize }" size="${size }" showHeader="true" showPager="true" isChangeTRColor="true">
		<v3x:column width="4%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
			<input type='checkbox' name='id' value="<c:out value='${bean.meetingRoomApp.id }'/>" />
			<input type='hidden' name='isAllowed_${bean.meetingRoomApp.id }' id='isAllowed_${bean.meetingRoomApp.id }' value='${bean.meetingRoomApp.status}'/>
			<input type='hidden' id='${bean.meetingRoomApp.id }' name='${bean.meetingRoomApp.id }' value='${bean.meetingRoomApp.meeting.title}'/>
			<input type="hidden" name="id_${bean.meetingRoomApp.id }" id="id_${bean.meetingRoomApp.id }" value="${bean.meetingRoomApp.meetingRoom.id}"/>
		</v3x:column>
		<v3x:column width="28%" type="String" onClick="showDetail('${bean.meetingRoomApp.id }')" 
			label="mr.label.meetingroomname" alt="${v3x:toHTML(bean.meetingRoomApp.meetingRoom.name)}" className="cursor-hand sort mxtgrid_black">
			<c:out value="${bean.meetingRoomApp.meetingRoom.name }" />
		</v3x:column>
		<%-- <v3x:column width="15%" type="String" onClick="showDetail('${bean.meetingRoomApp.id }')" 
			label="mr.label.appPerson" className="cursor-hand sort" alt="">
			<c:out value="${v3x:getMember(bean.meetingRoomApp.perId).name}" />
		</v3x:column> --%>
		<!--会议室的管理员不再是perid字段 xieFei-->
		<v3x:column width="10%" type="String" label="mr.label.admin" className="cursor-hand sort" alt="">
			<c:forEach var="admin" items="${bean.admins}">
				<!--<a class="click-link"  href="javascript:displayPeopleCard('${bean.meetingRoomApp.meetingRoom.perId }','${v3x:getMember(bean.meetingRoomApp.meetingRoom.perId).isValid}')"><c:out value="${v3x:showOrgEntitiesOfIds(bean.meetingRoomApp.meetingRoom.admin, 'Member', '')}"/></a>-->
				<a class="click-link"  href="javascript:displayPeopleCard('${admin}','${v3x:getMember(admin).isValid}')"><c:out value="${v3x:showOrgEntitiesOfIds(admin, 'Member', '')}"/></a>
			</c:forEach>
			
		</v3x:column>
		<%-- <v3x:column width="15%" type="String" onClick="showDetail('${bean.meetingRoomApp.id }')" 
			label="mr.label.appDept" className="cursor-hand sort" alt="">
			<c:out value="${v3x:getDepartment(bean.meetingRoomApp.departmentId).name }" />
		</v3x:column> --%>
		
		<v3x:column width="15%" type="String" onClick="showDetail('${bean.meetingRoomApp.id }')" 
			label="mr.label.meetName" className="cursor-hand sort" alt="${bean.meetingRoomApp.meeting.title}">
			<c:if test="${bean.meetingRoomApp.meeting==null}">
			<fmt:message key='mr.label.no'/>
			</c:if>
			<c:if test="${bean.meetingRoomApp.meeting!=null}">
			${bean.meetingRoomApp.meeting.title}
			</c:if>
		</v3x:column>
		<v3x:column width="15%" type="String" onClick="showDetail('${bean.meetingRoomApp.id }')" 
			label="mr.label.appTime" className="cursor-hand sort" alt="">
			<fmt:formatDate value="${bean.meetingRoomApp.appDatetime}" pattern="yyyy-MM-dd HH:mm"/>
		</v3x:column>
		<v3x:column width="10%" type="String" onClick="showDetail('${bean.meetingRoomApp.id }')" 
			label="mr.label.startDatetime" className="cursor-hand sort" alt="">
			<fmt:formatDate value="${bean.meetingRoomApp.startDatetime}" pattern="yyyy-MM-dd HH:mm"/>
			<input type="hidden" id="startDatetime_${bean.meetingRoomApp.id}" value="<fmt:formatDate value="${bean.meetingRoomApp.startDatetime}" pattern="yyyy-MM-dd HH:mm"/>"/>
		</v3x:column>
		<v3x:column width="10%" type="String" onClick="showDetail('${bean.meetingRoomApp.id }')" 
			label="mr.label.endDatetime" className="cursor-hand sort" alt="">
			<fmt:formatDate value="${bean.meetingRoomApp.endDatetime}" pattern="yyyy-MM-dd HH:mm"/>
			<input type="hidden" id="endDatetime_${bean.meetingRoomApp.id}" value="<fmt:formatDate value="${bean.meetingRoomApp.endDatetime}" pattern="yyyy-MM-dd HH:mm"/>"/>
		</v3x:column>
		
		<v3x:column width="15%" type="String" onClick="showDetail('${bean.meetingRoomApp.id }')" 
			label="mr.label.checkStatus" className="cursor-hand sort" alt="">
			<c:if test="${bean.meetingRoomApp.status==0}">
				<fmt:message key="mr.label.status.waitReview"/>
			</c:if>
			<c:if test="${bean.meetingRoomApp.status==1}">
				<fmt:message key="mr.label.status.passperm"/>
			</c:if>
			<c:if test="${bean.meetingRoomApp.status==2}">
				<fmt:message key="mr.label.status.noReview"/>
			</c:if>
		</v3x:column>
		
	</v3x:table>
	</form>
</div>
  </div>
</div>
<script type="text/javascript">
<!--
showDetailPageBaseInfo("detailFrame", "<fmt:message key='mr.tab.cancal'/>", [1,5], pageQueryMap.get('count'), _("officeLang.detail_info_meetingroom_cancel"));
showCondition("${v3x:escapeJavascript(param.condition)}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
initIpadScroll("scrollListDiv",550,870);
//-->
--></script>
	</body>
</html>
	