<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title></title>
		<%@ include file="header.jsp" %>
		<c:set value="全选" var="selectAllLabel" />
		<v3x:selectPeople id="dep" panels="Account,Department" selectType="Account,Department" jsFunction="setBulDepartFields(elements);" minSize="-1" maxSize="-1" originalElements="${defaultMngdepId}" />
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript">
			showCtpLocation("F03_meetingDataBase");
		</script>
		<script type="text/javascript">
			$(function() {
				setTimeout(function() {
					if($("#headIDlistTable") != null) {
						$("#headIDlistTable").find("th").eq(0).find("div").attr("title", '${selectAllLabel}');
					}
				}, 100);
			});
			// 申请范围回调方法
		    function setBulDepartFields(elements) {
		    	document.getElementById("applyrange").value="";
		    	if(elements.length>0) {
		    		var mngdepId = "";
		    		var mngdepName="";
		    		for(var i=0; i<elements.length; i++){
		    			if(mngdepId != "") {
		    				mngdepId += ",";
		    				mngdepName += ",";
		    			}
		    			//mngdepId += elements[i].type + "|" + elements[i].id;
		    			mngdepId += elements[i].id;
		    			mngdepName += elements[i].name;
		    		}
		    		document.getElementById("mngdepId").value = mngdepId;
		    		document.getElementById("applyrange").value = mngdepName;
		    	}
		    }
			function doCreate(){
				parent.detailFrame.location = "meetingroom.do?method=createAdd&flag=register";
			}
			function showModify(id){
				parent.detailFrame.location = "meetingroom.do?method=createAdd&id="+id;
			}
			function showDetail(id){
				parent.detailFrame.location = "meetingroom.do?method=createAdd&id="+id+"&readOnly=true";
			}
			function doModify(){
				var id = checkSelectOne(document.listForm);
				if(id == ""){
					alert("<fmt:message key='mr.alert.pleaseselectroom'/>");
					return false;
				}
				if(id == "false"){
					alert("<fmt:message key='mr.alert.modifyselectone'/>");
					return false;
				}
				parent.detailFrame.location = "meetingroom.do?method=createAdd&flag=edit&id="+id;
				
			}
			function doDelete(){
				var id = checkSelect(document.listForm);
				if(id == ""){
					alert("<fmt:message key='mr.alert.pleaseselecttodel'/>");
					return false;
				}else{
					if(confirm("<fmt:message key='mr.alert.delconfirm'/>？")){
						document.listForm.action = "meetingroom.do?method=execDelRoom";
						document.listForm.submit();
					}
				}
			}
			function initSearchCondition(){
				<c:if test="${selectCondition!=null}">
					var selectNode = document.getElementById("selectCondition");
					selectNode.selectedIndex = ${selectCondition};
					showCondition(selectNode);
					<c:choose>
						<c:when test="${selectCondition == 1}">
							var name="<v3x:out value='${conditionValue}' escapeJavaScript='true' />";
							document.getElementById("name").value = name;
						</c:when>
						<c:when test="${selectCondition == 2}">
							var adminname="<v3x:out value='${conditionValue}' escapeJavaScript='true' />";
							document.getElementById("adminname").value = adminname;
						</c:when>
						<c:when test="${selectCondition == 3}">
							<c:if test="${conditionValue == 0}">
								document.getElementById("status").selectedIndex = 0;
							</c:if>
							<c:if test="${conditionValue == 1}">
								document.getElementById("status").selectedIndex = 1;
							</c:if>
						</c:when>
						<c:when test="${selectCondition == 4}">
							document.getElementById("seatCount").value = "${conditionValue[0]}";
							<c:choose>
								<c:when test="${conditionValue[1]==2}">
									document.getElementById("seatCountCondition").selectedIndex = 0;
								</c:when>
								<c:when test="${conditionValue[1]==4}">
									document.getElementById("seatCountCondition").selectedIndex = 1;
								</c:when>
								<c:when test="${conditionValue[1]==0}">
									document.getElementById("seatCountCondition").selectedIndex = 2;
								</c:when>
							</c:choose>
						</c:when>
						<c:when test="${selectCondition == 5}">
							document.getElementById("applyrange").value = "${conditionValue}";
						</c:when>
					</c:choose>
				</c:if>
			}
			function showCondition(node){
				var inputDiv = document.getElementById("condition_div");
				var inputDiv_Input = document.getElementById("condition_div_input");
				var str = "";
				var str_input = "";
				inputDiv_Input.style.display = "none";
				if(node.value == "0"){
					str = "";
				}else if(node.value == "1"){
					str += "<input type='text' id='name' name='name' inputName='<fmt:message key='mr.label.querycondition'/>：<fmt:message key='mr.label.meetingroomname'/>' validate='maxLength' maxLength='50' style='width:100px' />";
				}else if(node.value == "2"){
					str += "<input type='text' id='adminname' name='adminname' inputName='<fmt:message key='mr.label.querycondition'/>：<fmt:message key='mr.label.admin'/>' validate='maxLength' maxLength='50' style='width:100px' />";
				}else if(node.value == "3"){
					str += "<select name='status' id='status'><option value='0'><fmt:message key='mr.label.status.normal'/></option><option value='1'><fmt:message key='mr.label.status.stop'/></option></select>";
				}else if(node.value == "4"){
					str += "<select name='seatCountCondition' id='seatCountCondition'>";
					str += "<option value='2'><fmt:message key='mr.label.gt'/></option>";
					str += "<option value='4'><fmt:message key='mr.label.lt'/></option>";
					str += "<option value='0'><fmt:message key='mr.label.eq'/></option>";
					str += "</select>";
					str_input += "<input type='text' id='seatCount' name='seatCount' inputName='<fmt:message key='mr.label.querycondition'/>：<fmt:message key='mr.label.seatCount'/>' validate='notNull,maxLength,isInteger' min='1' maxLength='3' style='width:100px' />";
				}else if(node.value == "5"){
					str += "<input type='hidden' name='mngdepId' id='mngdepId'/><input type='text' id='applyrange' name='applyrange' inputName='<fmt:message key='mr.label.querycondition'/>：<fmt:message key='mr.label.applyrange'/>' validate='maxLength' maxLength='50' style='width:100px'  onclick='selectPeopleFun_dep()'/>";
				}
				inputDiv_Input.innerHTML = str_input;
				inputDiv_Input.style.display = "";
				inputDiv.innerHTML = str;
			}
			
			function doSearch(){
				var patrn = /^[\d]+$/; 
				var seatCountObj = document.getElementById("seatCount");
				if(seatCountObj != null){
					if(seatCountObj.value == ""){
						alert("可容纳人数不能为空！");
						return ;
					}else if(!patrn.exec(seatCountObj.value)){
						alert("请输入正整数！");
						return ;
					}
				}
				document.searchForm.submit();
			}
			
			//isValid 人员是否是有效的，换句话说就是是否已经离职，离职不允许弹出人员卡片
			function displayPeopleCard(memberId, isValid){
				if(!isValid || isValid == "false"){
					return ;
			  	}
			  	var windowObj = parent.window.detailMainFrame;//上下结构打开的方式赋null，通过getA8Top()来获得窗口句柄
				if(typeof windowObj == 'undefined') {
				    windowObj =  parent.parent.window.detailMainFrame;
			   	}
				if(typeof windowObj == 'undefined') {
				    windowObj = parent.parent.parent.window.detailMainFrame;
			          }
			  	showV3XMemberCardWithOutButton(memberId, windowObj);
			}
		</script>
		<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
	</head>
	<body srcoll="no" style="overflow: hidden" style="padding: 0px" onload="initSearchCondition()" onUnLoad="UnLoad_detailFrameDown()">
		<div class="main_div_row2">
  		<div class="right_div_row2">
    		     <div class="top_div_row2">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   		<tr>
				<td height="22" class="webfx-menu-bar">
	   				<script type="text/javascript">
	   					var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","gray");
	   					myBar.add(new WebFXMenuButton("create", "<fmt:message key='mr.button.register'/>", "doCreate()", [1,1]));
	   					myBar.add(new WebFXMenuButton("modify", "<fmt:message key='mr.button.edit'/>", "doModify()", [1,2]));
	   					myBar.add(new WebFXMenuButton("delete", "<fmt:message key='mr.button.del'/>", "doDelete()", [1,3]));
	   					document.write(myBar);
					    document.close();
	   				</script>
	   			</td>
	   			<td class="webfx-menu-bar">
	   			<form name="searchForm" action="meetingroomList.do?method=listAdd" method="post" onsubmit="">
	   			<div class="div-float-right">
	   				<div class="div-float"><select id="selectCondition" name="selectCondition" class="condition" onChange="showCondition(this)" inputName="<fmt:message key='mr.label.querycondition'/>" validate="notNull">
	   					<option value="">--<fmt:message key='mr.label.querycondition'/>--</option>
	   					<option value="1"><fmt:message key='mr.label.meetingroomname'/></option>
	   					<option value="2"><fmt:message key='mr.label.admin'/></option>
	   					<option value="3"><fmt:message key='mr.label.status'/></option>
	   					<option value="4"><fmt:message key='mr.label.seatCount'/></option>
	   					<option value="5"><fmt:message key='mr.label.applyrange'/></option>
	   				</select></div>
	   				<div id="condition_div" style="margin-right:2px;margin-top:3px;" class="div-float"></div>
                    <div id="condition_div_input" style="display: none;margin-top:3px;" class="div-float"></div>
	   				<div onclick="javascript:doSearch();" class="condition-search-button">&nbsp;</div>
	   			</div></form></td>
	   		</tr>
	   		</table>
             </div>
    <div class="center_div_row2" id="scrollListDiv">
    <form name="listForm" id="listForm" method="post" style="margin: 0px">
    <v3x:table htmlId="listTable" data="list" var="bean" pageSize="${pageSize }" size="${size }" showHeader="true" showPager="true" isChangeTRColor="true">
		<v3x:column width="4%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
			<input type='checkbox' name='id' value="<c:out value='${bean.roomId }'/>" />
		</v3x:column>
		<v3x:column width="26%" type="String" onDblClick="showModify('${bean.roomId }')" onClick="showDetail('${bean.roomId }')" 
			label="mr.label.meetingroomname" className="cursor-hand sort mxtgrid_black" alt="${bean.roomName }">
			<c:out value="${bean.roomName }" />
			<c:if test="${bean.roomNeedApp == '0' || bean.roomNeedApp == '2'}">
				※
			</c:if>
		</v3x:column>
		<v3x:column width="15%" type="String" label="mr.label.admin" className="cursor-hand sort">
			<c:forEach var="admin" items="${bean.adminIds}">
				<c:set value="${v3x:getMember(admin).isValid}" var="memberIsValid"></c:set>
				<c:if test="${memberIsValid eq true }">
					<a class="click-link"  href="javascript:displayPeopleCard('${admin}', '${memberIsValid }')">
						<c:out value="${v3x:showOrgEntitiesOfIds(admin, 'Member', '')}"/>
					</a>
				</c:if>
			</c:forEach>
		</v3x:column>
		<v3x:column width="15%" type="String" onDblClick="showModify('${bean.roomId }')" onClick="showDetail('${bean.roomId }')" label="mr.label.applyrange" className="cursor-hand sort" alt="${v3x:showOrgEntitiesOfTypeAndId(mngdep,'')}">
			<c:forEach var="mngdep" items="${bean.mngdepIds}">
				<c:out value="${v3x:showOrgEntitiesOfTypeAndId(mngdep,'')}"/>
			</c:forEach>
		</v3x:column>
		<v3x:column width="15%" type="String" onDblClick="showModify('${bean.roomId }')" onClick="showDetail('${bean.roomId }')" 
			label="mr.label.place" className="cursor-hand sort" alt="${bean.roomPlace }">
			<c:out value="${bean.roomPlace }" />
		</v3x:column>
		<v3x:column width="15%" type="Number" onDblClick="showModify('${bean.roomId }')" onClick="showDetail('${bean.roomId }')" 
			label="mr.label.seatCount" className="cursor-hand sort" alt="${bean.roomSeatCount }">
			<c:out value="${bean.roomSeatCount }" />
		</v3x:column>
		<v3x:column width="10%" type="String" onDblClick="showModify('${bean.roomId }')" onClick="showDetail('${bean.roomId }')" 
			label="mr.label.status" className="cursor-hand sort" alt="">
			<c:out value="${bean.roomStatusName }" />
		</v3x:column>
	</v3x:table>
	</form>
</div>
  </div>
</div>
<script type="text/javascript">
initIpadScroll("scrollListDiv",550,870);
showDetailPageBaseInfo("detailFrame", "<fmt:message key='mr.tab.add'/>", [2,3], pageQueryMap.get('count'), _("officeLang.detail_info_meetingroom_sigin"));
</script>
<iframe id="hiddenIframe" name="hiddenIframe" style="display:none;with:0px;height:0px;"></iframe>
	</body>
</html>
	