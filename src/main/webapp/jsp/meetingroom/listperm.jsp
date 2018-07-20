<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title></title>
		<%@ include file="header.jsp" %>
		<fmt:setBundle basename="com.seeyon.v3x.meeting.resources.i18n.MeetingResources" var="mtI18n"/>
		<c:set value="全选" var="selectAllLabel" />
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript">
		var list = "${v3x:escapeJavascript(param.list)}";
		var flag = "${v3x:escapeJavascript(flag)}";
		if(flag!=null){
			list=flag;
		}
		showCtpLocation("F09_meetingRoom");
		</script>
		<script type="text/javascript">
		
			$(function() {
				setTimeout(function() {
					if($("#headIDlistTable") != null) {
						$("#headIDlistTable").find("th").eq(0).find("div").attr("title", '${selectAllLabel}');
					}
				}, 100);
			});
			
			function createPerm(){
				var id = checkSelectOne(document.listForm);
				if(id == ""){
					alert("<fmt:message key='mr.alert.pleaseselectapptoperm'/>");
					return false;
				}
				if(id == "false"){
					alert("<fmt:message key='mr.alert.permselectone'/>");
					return false;
				}
				var meetingRoomId = document.getElementById('id_'+id).value;
				parent.detailFrame.location = "${mrUrl}?method=createPerm&id="+id+"&meetingRoomId="+meetingRoomId;
			}
			function showPerm(id, proxy, proxyId){
				var meetingRoomId = document.getElementById('id_'+id).value;
				var url = "${mrUrl}?method=createPerm&id="+id+"&readOnly=true&openWin=openWin&meetingRoomId="+meetingRoomId;
				if(typeof(proxy)!='undefined') {
					url += "&proxy="+proxy+"&proxyId="+proxyId;
				}
				parent.detailFrame.location = url;
			}
			function audit(id){
				parent.detailFrame.location = "${mrUrl}?method=createPerm&id="+id;
			}
			function doClear(){
				var flag = "${v3x:escapeJavascript(flag)}";
				var id = checkSelect(document.listForm);
				var curretnDate = new Date();
				curretnDate = curretnDate.format("yyyy-MM-dd HH:mm");
				curretnDate = Date.parse(curretnDate.replace(/\-/g,"/"));
				if(id != ""){
					var ns = document.listForm.getElementsByTagName("input");
					for(var i = 0; i < ns.length; i++){
						if(ns[i].type == "checkbox" && ns[i].name == "id" && ns[i].checked){
							var isAllowed = document.getElementById("isAllowed_"+ns[i].value).value;
							if(isAllowed == "${MRConstants.Status_App_Wait}"){
								alert("<fmt:message key='mr.alert.cannotclear'/>！");
								return false;
							}
							if(flag == "passperm"){
								var startTime = ns[i].getAttribute("startTime");
								startTime = Date.parse(startTime.replace(/\-/g,"/"));
								var endTime = ns[i].getAttribute("endTime");
								endTime = Date.parse(endTime.replace(/\-/g,"/"));
								var meetingName = ns[i].getAttribute("mtName");
								if(curretnDate >= startTime && curretnDate <= endTime){
									alert("会议室：《"+ meetingName +"》正在使用中，暂时无法删除！");
									return ;
								}else if(curretnDate < startTime){
									alert("会议室：《"+ meetingName +"》未被使用，暂时无法删除！");
									return ;
								}
							}
						}
					}
					//if(confirm("<fmt:message key='mr.alert.confirmClear'/>？")){
					if(confirm("该操作不能恢复，是否进行删除操作?")){
						document.listForm.action = "${mrUrl}?method=execClearPerm";
						document.listForm.submit();
					}
				}else{
					//alert("<fmt:message key='mr.alert.pleaseselecttoclear'/>！");
					alert("请选择要删除的会议室申请。");
					return false;
				}
			}
			
			function ChangedEvent(obj) {
				var beginDate = document.getElementById("fromDate");
				var endDate = document.getElementById("toDate");
				if(beginDate != null && endDate != null){
					beginDate.value = "";
					endDate.value = "";
				}
				showNextCondition(obj);
			}
				
			function search_result() {
				var beginDate = document.getElementById("fromDate").value;
				var endDate = document.getElementById("toDate").value;
				if(compareDate(beginDate,endDate)>0){
					alert("开始时间不能大于结束时间！");
					return ;
				}
				doSearch();
			}
		</script>
		<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
	</head>
	<v3x:selectPeople id="per" panels="Department" selectType="Member" jsFunction="setBulPeopleFields(elements);" minSize="1" maxSize="1" />
	<body srcoll="no" style="overflow: hidden" style="padding: 0px" onUnLoad="UnLoad_detailFrameDown()">
	<div class="main_div_row2">
  		<div class="right_div_row2">
				<div class="top_div_row2">
					<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   					<tr>
							<td class="webfx-menu-bar" style="height:30px;">
				   				<script type="text/javascript">
				   				/*puyc 2012-2-6修改*/
				   			
				   					var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","gray");
				   				/*	if(list=='waitReview'){
				   						myBar.add(new WebFXMenuButton("create", "<fmt:message key='mr.button.review'/>", "createPerm()", "/seeyon/apps_res/meetingroom/images/audit.gif"));
				   					}
				   					*/

				   					if(list=='passperm'||list=='noReview'||list=='all'){
				   						myBar.add(new WebFXMenuButton("modify", "<fmt:message key='mr.button.del'/>", "doClear()", [1,3]));
				   					}
				   					document.write(myBar);
								    document.close();
								  
								    /*puyc 2012-2-6修改 结束*/
				   				</script>
	   						</td>
	   						<td class="webfx-menu-bar" style="height:30px;">
	   						<%-- xiangfan 修改 改为get的方式提交数据 GOV-1750--%>
	   							<form id="searchForm" name="searchForm" method="post" onsubmit="return false" action="${mrUrl }">
	   								<input type="hidden" name="flag" value="${v3x:toHTML(flag)}"/>
	   								<input type="hidden" name="method" value="listPerm" />
						   			<div class="div-float-right condition-search-div">
						   				<div class="div-float">
						   					<select name="condition" id="condition" onChange="ChangedEvent(this)" inputName="<fmt:message key='mr.label.querycondition'/>" validate="notNull">
							   					<option value="">--<fmt:message key='mr.label.querycondition'/>--</option>
							   					<option value="1"><fmt:message key='mr.label.meetingroom'/></option>
							   					<option value="2"><fmt:message key='mr.label.appPerson'/></option>
							   					<option value="3"><fmt:message key='mr.label.appDept'/></option>
							   					<option value="4"><fmt:message key='mr.label.meetingTime'/></option>
							   					<option value="5"><fmt:message key='mr.label.checkStatus'/></option>
						   					</select>
						   				</div>
						   				
						   				<div id="4Div" class="div-float hidden">
					   						<input type="text" name="textfield" id="fromDate" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly /> 
											- 
											<input type="text" name="textfield1" id="toDate" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly />
										</div>

						   				<div id="1Div" class="div-float hidden">
						   					<input type='text' name='textfield' id='textfield' validate='maxLength' maxLength='50' style='width:100px' autoComplete='off' />
						   				</div>
						   				
						   				<div id="2Div" class="div-float hidden">
						   					<input type='text' name='textfield' id='textfield' validate='maxLength' maxLength='50' style='width:100px' autoComplete='off'/>
						   				</div>
						   				
						   				<div id="3Div" class="div-float hidden">
						   					<input type='text' name='textfield' id='textfield' validate='maxLength' maxLength='50' style='width:100px' autoComplete='off' />
						   				</div>

						   				<div id="5Div" class="div-float hidden">
						   					<select name="textfield">
												<option value="0,1,2">请选择</option>
												<option value="0">待审核</option>
												<option value="1">审核通过</option>
												<option value="2">审核未通过</option>
											</select>
						   				</div>
						   				
						   				<div onclick="search_result();" class="condition-search-button">&nbsp;</div>
						   			</div>
						   		</form>
						   	</td>
	   					</tr>
	   				</table>
             </div>
    <div class="center_div_row2" id="scrollListDiv">
    <form name="listForm" id="listForm" method="post" style="margin: 0px">
    <v3x:table htmlId="listTable" data="list" var="bean" pageSize="${pageSize }" size="${size }" showHeader="true" showPager="true" isChangeTRColor="true">
		<v3x:column width="4%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
			<input type='checkbox' name='id' value="<c:out value='${bean.appId }'/>" startTime="<fmt:formatDate value="${bean.meetingRoomApp.startDatetime}" pattern="yyyy-MM-dd HH:mm"/>" endTime="<fmt:formatDate value="${bean.meetingRoomApp.endDatetime}" pattern="yyyy-MM-dd HH:mm"/>" mtName="${v3x:toHTML(bean.meetingRoomApp.meetingRoom.name)}"  />
			<input type='hidden' name='isAllowed_${bean.appId }' id='isAllowed_${bean.appId }' value='${bean.isAllowed }'/>
			<input type="hidden" name="id_${bean.appId}" id="id_${bean.appId}" value="${bean.meetingRoomApp.meetingRoom.id}"/>
		</v3x:column>
		<c:set var="onClick" value="showPerm('${bean.appId}', '${bean.proxy}', '${bean.proxyId}');"/>
		<c:set var="onDBClick" value="audit('${bean.appId}');"/>
		<%-- <c:set value="${departmentName[v3x:toString(bean.meetingRoomApp.perId)]}" var="departname"/> --%>
		
		<c:choose>
			<c:when test="${bean.proxy}">
				<c:set value="1" var="proxy" />
				<c:set value="${bean.proxyId}" var="proxyId" />
			</c:when>
			<c:otherwise>
				<c:set value="0" var="proxy" />
				<c:set value="-1" var="proxyId" />
			</c:otherwise>
		</c:choose>
		
		<v3x:column width="15%" type="String" onClick="${onClick }" 
			label="mr.label.meetingroomname" className="cursor-hand sort mxtgrid_black proxy-${bean.proxy }" alt="${createAccountName}${v3x:toHTML(bean.meetingRoomApp.meetingRoom.name)}">
			
			<c:choose>
				<c:when test="${bean.proxy}">
					${createAccountName}${v3x:toHTML(bean.meetingRoomApp.meetingRoom.name)}
					<c:if test="${proxyId ne null }">
					  (<fmt:message key="mt.agent" bundle="${mtI18n }"/>${v3x:showMemberName(bean.proxyId)})
					</c:if>
				</c:when>
				<c:otherwise>
					${createAccountName}${v3x:toHTML(bean.meetingRoomApp.meetingRoom.name)}
				</c:otherwise>
			</c:choose>
			
		</v3x:column>
		<v3x:column width="9%" type="String" onClick="${onClick }" 
			label="mr.label.appPerson" className="cursor-hand sort" alt="">
			<c:out value="${v3x:showMemberNameOnly(bean.meetingRoomApp.perId)}" />
		</v3x:column>
		<v3x:column width="10%" type="String" onClick="${onClick }" 
			label="mr.label.appDept" className="cursor-hand sort" alt="">
			<c:out value="${bean.departmentName}" />
		</v3x:column>
		<v3x:column width="20%" type="String" onClick="${onClick }" 
			label="mr.label.meetName" className="cursor-hand sort" alt="${bean.meetingRoomApp.meeting.title}">
			<c:if test="${bean.meetingRoomApp.meeting==null}">
			<fmt:message key='mr.label.no'/>
			</c:if>
			<c:if test="${bean.meetingRoomApp.meeting!=null}">
			${bean.meetingRoomApp.meeting.title}
			</c:if>
		</v3x:column>
		<v3x:column width="12%" type="String" onClick="${onClick }" 
			label="mr.label.appTime" className="cursor-hand sort" alt="">
			<fmt:formatDate value="${bean.meetingRoomApp.appDatetime}" pattern="yyyy-MM-dd HH:mm"/>
		</v3x:column>
		<v3x:column width="12%" type="String" onClick="${onClick }" 
			label="mr.label.startDatetime" className="cursor-hand sort" alt="">
			<fmt:formatDate value="${bean.meetingRoomApp.startDatetime}" pattern="yyyy-MM-dd HH:mm"/>
		</v3x:column>
		<v3x:column width="12%" type="String" onClick="${onClick }" 
			label="mr.label.endDatetime" className="cursor-hand sort" alt="">
			<fmt:formatDate value="${bean.meetingRoomApp.endDatetime}" pattern="yyyy-MM-dd HH:mm"/>
		</v3x:column>
		<v3x:column width="7%" type="String" onClick="${onClick }" 
			label="mr.label.status" className="cursor-hand sort" alt="" nowarp="nowarp">
			<c:if test="${bean.isAllowed == MRConstants.Status_App_Wait }">
				<fmt:message key='mr.label.status.waitReview'/>
			</c:if>
			<c:if test="${bean.isAllowed == MRConstants.Status_App_Yes }">
				<fmt:message key='mr.label.status.passperm'/>
			</c:if>
			<c:if test="${bean.isAllowed == MRConstants.Status_App_No }">
				<fmt:message key='mr.label.status.noReview'/>
			</c:if>
		</v3x:column>
	</v3x:table>
	</form>
</div>
  </div>
</div>
<script type="text/javascript">
showCondition("${v3x:escapeJavascript(param.condition)}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
initIpadScroll("scrollListDiv",550,870);
<!--
function showDetail(){
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='mr.tab.review'/>", [2,3], pageQueryMap.get('count'), _("officeLang.detail_info_meetingroom_pass"));		
}
showDetail();

-->
</script>

	</body>
</html>
	