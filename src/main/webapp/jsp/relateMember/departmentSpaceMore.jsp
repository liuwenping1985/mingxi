<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.peoplerelate.resources.i18n.RelateResources" var="v3xRelateI18N" />
<html:link renderURL="/relateMember.do?method=relateMemberInfo" psml="default-page.psml" var="memberUrl" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/memberMenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">

document.oncontextmenu=function(){event.returnValue=false};//屏蔽右键
${alertString}
</script>
<c:set var="currentUser" value="${v3x:currentUser() }"/>
<c:set var="hasSendColl" value="${v3x:hasNewCollaboration()}"/>
<c:set var="hasSendMsg" value="${v3x:hasPlugin('uc')}"/>
<c:set var="hasSendMail" value="${v3x:hasNewMail()}"/>
<c:choose>
    <c:when test="${isSpace}">
    	<c:set var="spaceName" value="${space.spaceName}"/>
    </c:when>
    <c:otherwise>
    	<c:set var="spaceName" value="${myDept.name}"/>
    </c:otherwise>
</c:choose>
<script type="text/javascript">
	function changeState2(id){
		var divContent = document.getElementById(id + "DeptMember");
		//加载数据
		if(divContent.rows.length<=0){
			var currUserId = "${v3x:currentUser().id}";
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxPeopleRelateManager", "getDeptMeMberForAjax", false);
			requestCaller.addParameter(1, "Long", id);
			requestCaller.addParameter(2, "Long", "${v3x:currentUser().loginAccount}");
			var result =  requestCaller.serviceRequest();
			var members = new Array();
			if(result != null && result!= ""){
				var arr = result.split("$$");
				for(var i=0; i<arr.length; i++){
					var men = arr[i].split("|");
					var mem = new Object();
					mem.id = men[0];
					mem.name = men[1];
					mem.emailAddress = men[2];
					mem.telNumber = men[3];
					mem.officeNum = men[4];
					mem.userImageSrc = men[5];
					members[i] = mem;
				}
				var tr =new Object();
				for(var i=0; i<members.length; i++){
					if(i%4==0){
						tr = divContent.insertRow(-1);
					}
					var m = members[i];
					var td0 = tr.insertCell(-1);
					td0.style.width = "25%";
					td0.className="departmentSpace-memberName sorts";
					var toHtml = '<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0"><tr><td width="52" valign="top">'
						+'<div style=" width: 52px; height: 52px; text-align: center; background-color: #FFF;">';
					var surl = '${memberUrl}&relatedId='+currUserId+'&memberId='+m.id+'&departmentId='+id;
					if(currUserId==m.id){
						toHtml = toHtml+'<img style="-moz-border-radius: 1000px;-khtml-border-radius: 1000px;-webkit-border-radius: 1000px;border-radius: 1000px;" src="'+m.userImageSrc+'" width="52" height="52" border="0" />';
					}else{
						toHtml = toHtml+'<a href="'+surl+'" target="_parent"><img style="-moz-border-radius: 1000px;-khtml-border-radius: 1000px;-webkit-border-radius: 1000px;border-radius: 1000px;" src="'+m.userImageSrc+'" width="52" height="52" border="0" /></a>';
					}
					toHtml = toHtml+'</div></div></td><td><table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0"><tr><td>';
					if(currUserId==m.id){
						toHtml = toHtml+'<span>'+m.name+'</span>';
					}else{
						toHtml = toHtml+'<span onMouseOver="showMemberMenu(\'' + m.id + '\', \'' + m.name + '\', \''
						+m.emailAddress+'\', \'${hasSendColl}\', \'${hasSendMsg}\', \'${hasSendMail}\', \'_parent\', document.getElementById(\''
						+m.id+'Img\'))" onMouseOut="leave()"><a href="'+surl+'" target="_parent">'+m.name+'<img id="'
						+m.id+'Img" src="'+v3x.baseURL+'/apps_res/peoplerelate/images/button.gif" border="0"></a></span>';
					}
					toHtml = toHtml+'</td></tr><tr><td title="'+m.officeNum
						+'"><fmt:message key="relate.memberinfo.tel" bundle="${v3xRelateI18N}"/>'+m.officeNum
						+'</td></tr><tr><td><fmt:message key="relate.memberinfo.handphone3" bundle="${v3xRelateI18N}"/>'
						+m.telNumber+'</td></tr><tr><td><br></td></tr></table>';	
					td0.innerHTML = toHtml;
				}
				var k = 4 - members.length % 4;
				for(var i=0; i<k; i++){
					var td0 = tr.insertCell(-1);
					td0.style.width = "25%";
				}
			}
		}
		var divTitle1 = document.getElementById(id + "Title1");
		var divTitle2 = document.getElementById(id + "Title2");
		var divContent = document.getElementById(id + "Content");
		if(divContent.className == "hidden"){
			divContent.className = "";
			divTitle2.className = "show";
			divTitle1.className = "hidden";
		}else{
			divContent.className = "hidden";
			divTitle1.className = "show";
			divTitle2.className = "hidden";
		}
	}
	
	function changeState(id){
		var divTitle1 = document.getElementById(id + "Title1");
		var divTitle2 = document.getElementById(id + "Title2");
		var divContent = document.getElementById(id + "Content");
		if(divContent.className == "hidden"){
			divContent.className = "";
			divTitle2.className = "show";
			divTitle1.className = "hidden";
		}else{
			divContent.className = "hidden";
			divTitle1.className = "show";
			divTitle2.className = "hidden";
		}
	}
	
	function openRelateMember(url) {
	  getA8Top().$("#main").attr("src", url);
	}
</script>

</head>
<body scroll="auto" style="padding-left: 5px;">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr style="padding-bottom: 10px;">
		<td valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="sortsHead">
						<table>
							<tr>
								<td>
									${v3x:toHTML(spaceName)}
								</td>
								<td>
						        	<a onclick="javascript:changeState('${spaceName}')" id="${spaceName}Title1" class="hidden" style="cursor: pointer;">[<fmt:message key="relate.open" bundle="${v3xRelateI18N}"/>]</a>
									<a onclick="javascript:changeState('${spaceName}')" id="${spaceName}Title2" class="show" style="cursor: pointer;">[<fmt:message key="relate.close" bundle="${v3xRelateI18N}"/>]</a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr id="${spaceName}Content">
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<c:forEach items="${myMemberList}" var="m" varStatus="ordinal">
									<td class="departmentSpace-memberName sorts" width="25%">
										<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<html:link renderURL="/relateMember.do?method=relateMemberInfo&memberId=${m.relateMemberId}&relatedId=${currentUser.id}&departmentId=${myDept.id}" psml="default-page.psml" var="url" />
												<td width="52" valign="top">
													<div style=" width: 52px; height: 52px; text-align: center; background-color: #FFF;">
														<div style="width: 52px; height: 52px; text-align: center;">
															<c:if test="${currentUser.id!=m.relateMemberId}">
																<a onclick="javascript:openRelateMember('${url}')">
															</c:if>
															<img style="-moz-border-radius: 1000px;-khtml-border-radius: 1000px;-webkit-border-radius: 1000px;border-radius: 1000px;" src="${v3x:avatarImageUrl(m.relateMemberId)}" width="52" height="52" border="0" />

								                			<c:if test="${currentUser.id==m.relateMemberId}">
																</a>
															</c:if>
								                		</div>
							                		</div>
						                		</td>
						                		<td>
						                			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="margin_l_5">
						                				<tr>
						                					<td>
						                						<c:choose>
																	<c:when test="${currentUser.id!=m.relateMemberId}">
																		<span onMouseOver="showMemberMenu('${m.relateMemberId}', '${v3x:escapeJavascript(m.relateMemberName)}', '${m.relateMemberEmail}', '${hasSendColl }', '${hasSendMsg }', '${hasSendMail}', '_parent', document.getElementById('${m.relateMemberId}Img'))" onMouseOut="leave()">
												                			<a href="${url}" target="_parent">
																				${v3x:toHTML(m.relateMemberName)}<img id="${m.relateMemberId}Img" src="<c:url value="/apps_res/peoplerelate/images/button.gif"/>" border="0">
																			</a>
																		</span>
																	</c:when>
																	<c:otherwise>
																		<span>${v3x:toHTML(m.relateMemberName)}</span>
																	</c:otherwise>
																</c:choose>
						                					</td>
						                				</tr>
						                				<tr>
						                					<td title="${v3x:toHTML(m.relateMemberTel)}">
						                						<fmt:message key="relate.memberinfo.tel" bundle="${v3xRelateI18N}"/>${v3x:toHTML(v3x:getLimitLengthString(m.relateMemberTel,13,"..."))}
						                					</td>
						                				</tr>
						                				<tr>
						                					<td>
						                						<fmt:message key="relate.memberinfo.handphone3" bundle="${v3xRelateI18N}"/>${v3x:toHTML(m.relateMemberHandSet)}
						                					</td>
						                				</tr>
						                				<tr>
						                					<td>
						                						<br>
						                					</td>
						                				</tr>
						                			</table>
												</td>
					                		</tr>
										</table>
									</td>
									${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
									<c:set value="${(ordinal.index + 1) % 4}" var="i" />
								</c:forEach>
								<c:if test="${i !=0}">					
								<c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
									<td class="departmentSpace-memberName sorts" width="25%">&nbsp;</td>
								</c:forTokens>
								</c:if>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
    </tr>
    <c:forEach items="${deptsMap}" var="dept">
    <tr style="padding-bottom: 15px;">
		<td valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="sortsHead">
						<table id="subDept">
							<tr>
								<td>${dept.value}</td>
								<td>
									<a onclick="javascript:changeState2('${dept.key}')" id="${dept.key}Title1" class="show" style="cursor: pointer;">[<fmt:message key="relate.open" bundle="${v3xRelateI18N}"/>]</a>
									<a onclick="javascript:changeState2('${dept.key}')" id="${dept.key}Title2" class="hidden" style="cursor: pointer;">[<fmt:message key="relate.close" bundle="${v3xRelateI18N}"/>]</a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr id="${dept.key}Content" class="hidden">
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" id="${dept.key}DeptMember">
						</table>
					</td>
				</tr>
			</table>
		</td>
    </tr>
    </c:forEach>
</table>
<div id="memberMenuDIV" onMouseOver="divOver()" onMouseOut="divLeave()" style="width:82px; height:80px; padding-left:5px; border:#ccc 1px solid; background-color:#fff; display:none; position:absolute; line-height:20px;"></div>
</body>
</html>