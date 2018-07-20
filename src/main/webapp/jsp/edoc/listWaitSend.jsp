<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="edocHeader.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/exchange/js/exchange.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
//服务器时间和本地时间的差异
var server2LocalTime = <%=System.currentTimeMillis()%> - new Date().getTime();
var jsEdocType=${edocType};
var isEdocCreateRole=${isEdocCreateRole ? 'true' : 'false' };
var currentUserAccountId = "${currentUserAccountId}";
var list = "${listType}";
var _isOpenRegister = "${isOpenRegister}";//登记开关
var isG6 = "${isG6}";
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/listWaitSend.js${v3x:resSuffix()}" />"></script>
<style>
SELECT{
		FONT-SIZE: 10pt; 
		FONT-FAMILY: Times New Roman;
		MARGIN-TOP:1px;		
}
</style>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body scroll="no" onload="setMenuState('menu_darft');">
<div class="main_div_row2">
  		<div class="right_div_row2">
    		     <div class="top_div_row2">
<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22" class="webfx-menu-bar">
	    	<script type="text/javascript">
	    	var edocContorller="${detailURL}";
	    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
	    	//var waitSendControl = "${v3x:getSystemProperty('edoc.send.pending.page')}";

    		var resourceKey = "F07_sendNewEdoc";
    		var edocType = '${edocType}';
				myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.send.label' bundle='${v3xCommonI18N}' />", "javascript:sendFromWaitSend(${edocType})", [1,4], "", null));					
	    	
    		//多浏览器屏蔽
			//if("${v3x:getBrowserFlagByRequest('HideBrowsers', pageContext.request)}"=="true") {
	    		//编辑
	    		myBar.add(new WebFXMenuButton("edit", "<fmt:message key='common.toolbar.edit.label' bundle='${v3xCommonI18N}' />", "javascript:editFromWaitSend('${backBoxType}')", [1,2], "", null));
	    	//}
	    	if(list=="draftBox" || list=="listWaitSend"){
	    		myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "javascript:deleteItems('draft')", [1,3], "", null));
	    	}
	    	
	    	//lijl注销
			//myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "javascript:deleteItems('draft')", [1,3], "", null));    	
			if((list=="retreat" || list=="listWaitSend") && ${hasEdocLeft}){
				myBar.add(new WebFXMenuButton("", "<fmt:message key='menu.edocNew.return'/>", "javascript:distributeRetreat()", [4,1], "", null));
			}
			
			<c:if test="${edocType == 1}">
			
			    <%-- 收文回退按钮 --%>
			    myBar.add(new WebFXMenuButton("", "<fmt:message key='menu.edocNew.return' />", "javascript:distributeRetreat()", [10,4], "", null));
            </c:if>
			
			<v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
	    	document.write(myBar);
	    	document.close();
	    	
	    	</script>			
		</td>
		<td class="webfx-menu-bar border-right"><form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
			<input type="hidden" value="<c:out value='${param.method}' />" name="method">
			<input type="hidden" value="<c:out value='${param.listType}' />" name="listType">
			<input type="hidden" value="<c:out value='${edocType}' />" name="edocType" id="edocType">		
			<input type="hidden" value="${v3x:toHTML(param.list)}" name="list">	
			<div class="div-float-right">
				<div class="div-float">
					<select id="condition" name="condition" onChange="showNextSpecialCondition(this)" class="condition" style="width:90px">
				    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
					    <option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" /></option>
					    <option value="secretLevel"><fmt:message key="edoc.element.secretlevel.simple"/></option>
					    <option value="docMark"><fmt:message key="edoc.element.wordno.label" /></option>
					    <c:if test="${isG6Ver != 'true'}">
						    <option value="docInMark"><fmt:message key="edoc.element.wordinno.label" /></option>
						    <option value="createDate"><fmt:message key="edoc.supervise.startdate"/></option>
						    <%-- 根据国家行政公文规范,去掉主题词
						    <option value="keywords"><fmt:message key="edoc.element.keyword"/></option> --%>
						    <option value="urgentLevel"><fmt:message key="edoc.element.urgentlevel"/></option>
					    </c:if>
					    
					    <c:if test="${isG6Ver == 'true'}">
					    	<option value="sendUnit"><fmt:message key="edoc.element.sendunit"/></option>
					    	<!--不是收文的话显示发起时间 -->
					    	<c:if test="${edocType != 1}">
						    	<option value="createDate"><fmt:message key="edoc.supervise.startdate"/></option>
	                        </c:if> 
	                        <!--是收文的话根据登记开关显示登记时间或签收时间 -->
							<c:if test="${isOpenRegister == 'true' && edocType == 1}">
								<option value="registerDate"><fmt:message key="edoc.element.registration_date"/></option>
							</c:if>
						    <c:if test="${isOpenRegister != 'true' && edocType == 1}">
						    	<option value="recieveDate"><fmt:message key="edoc.element.receipt_date"/></option>
	                        </c:if>    
					    </c:if>
					    <c:if test="${v3x:hasPlugin('sursenExchange') && isOpenRegister != 'true'  && edocType == 1}"> 
							<option value="exchangeMode"  <c:if test="${condition == 'exchangeMode'}">selected</c:if>><fmt:message key="edoc.exchangeMode" /></option>  <%-- 交换方式 --%>
						</c:if>
					    <!--状态 -->
					    <option value="subState"><fmt:message key="edoc.element.subState.simple"/></option>
				  	</select>
			  	</div>
			  	<div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
			  	<div id="docMarkDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
			  	<div id="secretLevelDiv" class="div-float hidden">
			  		<select name="textfield" class="condition" style="width:90px">
			  			<option value=""><fmt:message key="common.pleaseSelect.label" /></option>
			  			<c:forEach var="secret" items="${colMetadata['edoc_secret_level'].items}"> 
			  				<c:if test="${secret.state == 1}">
			  				<option value="${secret.value}">
			  					<c:choose>
								<c:when test="${secret.i18n == 1 }">
								${v3x:_(pageContext, secret.label)}
								</c:when>
								<c:otherwise>
								${secret.label}
								</c:otherwise>
								</c:choose>
			  				</option>
			  				</c:if>
			  			</c:forEach>
			  		</select>	
			  	</div>
			  	<!-- 状态选择 -->
			  	<div id="subStateDiv" class="div-float hidden">
			  		<select name="textfield" class="condition" style="width:90px">
			  			<!-- 请选择 -->
			  			<option value=""><fmt:message key="common.pleaseSelect.label" /></option>
			  			<!-- 撤销 -->
			  			<option value="3"><fmt:message key="edoc.element.subState.cancel"/></option>
			  			<!-- 草稿 -->
			  			<option value="1"><fmt:message key="edoc.element.subState.draft"/></option>
			  			<!-- 回退-->
			  			<option value="2"><fmt:message key="edoc.element.subState.isStepedBack"/> </option>
			  		</select>
			  	</div>
			  	<c:if test="${isG6Ver != 'true'}">
				  	<div id="docInMarkDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
				  	<div id="createDateDiv" class="div-float hidden">
	                    <input type="text" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
	                    -
	                    <input type="text" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
                    </div>
				  	<div id="urgentLevelDiv" class="div-float hidden">
				  		<select name="textfield" class="condition" style="width:90px">
				  			<option value=""><fmt:message key="common.pleaseSelect.label" /></option>
				  			<c:forEach var="urgent" items="${colMetadata['edoc_urgent_level'].items}"> 
				  				<c:if test="${urgent.state == 1}">
				  				<option value="${urgent.value}">
				  				<c:choose>
									<c:when test="${urgent.i18n == 1 }">
									${v3x:_(pageContext, urgent.label)}
									</c:when>
									<c:otherwise>
									 ${urgent.label}
									</c:otherwise>
									</c:choose>
				  				</option>
				  				</c:if>
				  			</c:forEach>
				  		</select>
				  	</div>
			  	</c:if>
			  	
			  	<c:if test="${isG6Ver == 'true'}">
				  	<div id="sendUnitDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
				  	<!--不是收文的话显示发起时间 -->
			        <c:if test="${edocType != 1}">
			            <div id="createDateDiv" class="div-float hidden">
	                        <input type="text" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
	                        -
	                        <input type="text" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
	                    </div>
			        </c:if>
				  	<c:if test="${isOpenRegister == 'true' && edocType == 1}">
					  	<div id="registerDateDiv" class="div-float hidden">
					  		<input type="text" name="textfield" id="registerDateBegin" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
					  		-
					  		<input type="text" name="textfield1" id="registerDateEnd" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
					  	</div>
					</c:if>
					<c:if test="${isOpenRegister != 'true' && edocType == 1}">
					  	<div id="recieveDateDiv" class="div-float hidden">
					  		<input type="text" name="textfield" id="recieveDateBegin" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
					  		-
					  		<input type="text" name="textfield1" id="recieveDateEnd" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
					  	</div>
					</c:if>
			  	</c:if>
			  	<c:if test="${v3x:hasPlugin('sursenExchange') && isOpenRegister != 'true'}">
				  	<div id="exchangeModeDiv" class="div-float hidden">
						<select name="textfield">
							<option value=0><fmt:message key='edoc.exchangeMode.internal'/></option>   <%-- 内部公文交换 --%>
							<option value=1><fmt:message key='edoc.exchangeMode.sursen'/></option>  <%-- 书生公文交换 --%>
						</select>
				  	</div>
				</c:if>
			  	<div onclick="javascript:doSearch2()" class="condition-search-button"></div>
		  	</div></form>
		</td>		
	</tr>                              
	</table>
             </div>
    <div class="center_div_row2" id="scrollListDiv">
		
			<form name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
			<input type="hidden" name="edocType" value="${edocType}"/>
			<input type="hidden" value="${v3x:toHTML(param.list)}" name="list">
			<input type="hidden" name="__ActionToken" readonly value="SEEYON_A8" > <%-- post提交的标示，先写死，后续动态 --%>
			<!-- 接收从弹出页面提交过来的数据 -->
			<input type="hidden" name="popJsonId" id="popJsonId" value="">
			<input type="hidden" name="popNodeSelected" id="popNodeSelected" value="">
			<input type="hidden" name="popNodeCondition" id="popNodeCondition" value="">
			<input type="hidden" name="popNodeNewFlow" id="popNodeNewFlow" value="">
			<input type="hidden" name="allNodes" id="allNodes" value="">
			<input type="hidden" name="nodeCount" id="nodeCount" value="">
			<input type="hidden" name="isSendBackBox" id="isSendBackBox" value="${param.subState==4}">
			<v3x:table htmlId="pending" data="pendingList" var="col" className="sort ellipsis edocellipsis">
                <v3x:column width="3%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
					<input type='checkbox' name='id' value="${col.summary.id}" 
					docMark="${col.summary.docMark}" 
					serialNo="${col.summary.serialNo}" 
					affairId="${col.affairId}" 
					isQuickSend="${col.summary.isQuickSend}" 
					caseId="${col.summary.caseId}" 
					processId="${col.summary.processId }" 
					templeteId="${col.summary.templeteId }" 
					deadlineDatetime="${col.summary.deadlineDatetime }" 
					substate="${col.affair.subState}" 
					subject="${col.summary.subject}"
					registerType="${col.registerType}"
					registerId="${col.registerId}"
					autoRegister="${col.autoRegister}"
					exchangeMode="${col.exchangeMode}"
					receiveId="${col.receiveId}"/>
				</v3x:column>			
				<c:set value="${v3x:escapeJavascript(col.summary.subject)}" var="subject"  />
					<!-- lijl update click 注销的click是进入编辑状态 -->
<!--				<c:set var="click" value="editWaitSend('${col.summary.id}','${col.affairId}',0)"/>-->
				<c:set var="click" value="openDetail('', 'affairId=${col.affairId}&from=listWaitSend')"/>
				<c:set var="isRead" value="true"/>
				<v3x:column width="6%" type="String" label="edoc.element.secretlevel.simple" className="cursor-hand sort" read="${isRead}"
				  onClick="${click}">
				<span title="<v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/>"><v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/></span>&nbsp;
				</v3x:column>
				
				<v3x:column width="30%"  type="String" label="common.subject.label" className="cursor-hand sort mxtgrid_black" read="${isRead}" importantLevel="${col.summary.urgentLevel}" 
				bodyType="${col.bodyType}"  value="${col.summary.subject}" alt="${col.summary.subject}" hasAttachments="${col.summary.hasAttachments}"  onClick="${click}" />
				
				<v3x:column width="18%"  type="String" label="edoc.element.wordno.label" className="cursor-hand sort" read="${isRead}"
				alt="${col.summary.docMark}"  onClick="${click}">
					<span title="${ctp:toHTML(col.summary.docMark=='null' ? '' : (col.summary.docMark))}">${ctp:toHTML(col.summary.docMark=='null' ? '' : (col.summary.docMark))}</span>&nbsp;
				</v3x:column>
				
				<v3x:column width="17%"  type="String" label="edoc.element.wordinno.label" className="cursor-hand sort" read="${isRead}"
				 alt="${col.summary.serialNo}"  onClick="${click}" >
				    <span title="${ctp:toHTML(col.summary.serialNo=='null' ? '' : (col.summary.serialNo))}">${ctp:toHTML(col.summary.serialNo=='null' ? '' : (col.summary.serialNo))}</span>				
				</v3x:column>
				<%-- 
				<v3x:column width="10%" type="String" label="common.sender.label" value="${col.summary.startMember.name}"
				className="cursor-hand sort" read="${isRead}"
				 onClick="${click}" />
				--%>
				<v3x:column width="18%" type="Date" label="edoc.supervise.startdate" className="cursor-hand sort" read="${isRead}"
				 onClick="${click}">
					<span title="<fmt:formatDate value="${col.summary.createTime}" pattern="${datePattern}"/>"><fmt:formatDate value="${col.summary.createTime}" pattern="${datePattern}"/></span>&nbsp;
				</v3x:column>
				<v3x:column width="10%" type="String" label="process.cycle.label" className="cursor-hand sort deadline-${col.summary.worklfowTimeout}" 
				read="${isRead}"  onClick="${click}" alt="${v3x:_(pageContext, isOvertop)}" >
					<span id="deadline${col.affairId}">
						<c:if test='${col.deadlineDisplay ne ""}'>
							${col.deadlineDisplay}
						</c:if>
						<c:if test='${col.deadlineDisplay eq ""}'>
							<v3x:metadataItemLabel metadata="${colMetadata.collaboration_deadline}" value="${col.summary.deadline}"/>	
						</c:if>
					</span>
					<script>
					 if(document.getElementById("deadline${col.affairId}").innerHTML.length==0){document.getElementById("deadline${col.affairId}").innerHTML="无";}
					</script>
				</v3x:column>
		
				
				<%--G6收文的 --%>
				<c:if test="${isG6Ver == 'true' && edocType == 1}">
					
					<c:if test="${isOpenRegister=='true' }">
						<v3x:column width="10%" type="String" label="exchange.edoc.booker"
							className="cursor-hand sort" 
							 onClick="${click}" >
							<span title="${col.registerUserName}">${col.registerUserName}</span>&nbsp;
						</v3x:column>
					
						<v3x:column width="10%" type="String" label="edoc.element.registration_date"
								className="cursor-hand sort" 
								 onClick="${click}" >
							<span title="<fmt:formatDate value="${col.registerDate}"  pattern="yyyy-MM-dd"/>"><fmt:formatDate value="${col.registerDate}"  pattern="yyyy-MM-dd"/></span>&nbsp;
						</v3x:column>
					</c:if>
					
					<c:if test="${isOpenRegister=='false' }">
						
						<v3x:column width="10%" type="String" label="exchange.edoc.receivedperson"
							className="cursor-hand sort" 
							 onClick="${click}" >
							<span title="${col.recUserName}">${col.recUserName}</span>&nbsp;
						</v3x:column>
						<v3x:column width="10%" type="String" label="exchange.edoc.receiveddate"
							className="cursor-hand sort" 
							 onClick="${click}" >
							<span title="<fmt:formatDate value="${col.recieveDate}"  pattern="yyyy-MM-dd"/>"><fmt:formatDate value="${col.recieveDate}"  pattern="yyyy-MM-dd"/></span>&nbsp;
						</v3x:column>
						
					</c:if>
				
				</c:if>
				<v3x:column width="10%" type="String" label="edoc.element.subState.simple"
					className="cursor-hand sort" >
					<!-- 草稿 -->
					<c:if test="${col.state eq '1' }">
						<span title="<fmt:message key='edoc.element.subState.draft' />"><fmt:message key='edoc.element.subState.draft' /></span>&nbsp;
					</c:if>
					<!-- 回退-->
					<c:if test="${col.state eq '2' or col.state eq '16' or col.state eq '18' }">
						<span title="<fmt:message key='edoc.element.subState.isStepedBack' />"><fmt:message key='edoc.element.subState.isStepedBack' /></span>&nbsp;
					</c:if>
					<!-- 撤销 -->
					<c:if test="${col.state eq '3' }">
						<span title="<fmt:message key='edoc.element.subState.cancel' />"><fmt:message key='edoc.element.subState.cancel' /></span>&nbsp;
					</c:if>
				</v3x:column>
				<c:if test="${v3x:hasPlugin('sursenExchange') && isOpenRegister != 'true'  && edocType == 1}"> 
					<v3x:column width="10%" type="String" onClick="editItem('${bean.recieveId}', '${modelType }');"
						label="edoc.exchangeMode" className="cursor-hand sort" symbol="...">  <%-- 交换方式 --%> 
						<c:if test="${col.exchangeMode==0}"><fmt:message key='edoc.exchangeMode.internal'/></c:if> <%-- 内部公文交换 --%> 
						<c:if test="${col.exchangeMode==1}"><fmt:message key='edoc.exchangeMode.sursen'/></c:if> <%-- 书生公文交换 --%>
					</v3x:column>
				</c:if>
			</v3x:table>
			<div style="display:none" id="processModeSelectorContainer">
			</div>
			
			</form>
		</div>
  </div>
</div>
<%--<c:if test="${not empty flash}" >
    <c:out value="${flash}" escapeXml="false" />
</c:if>--%>
<iframe name=tempIframe id=tempIframe style="height:0px;width:0px;"></iframe>
<script type="text/javascript">
<!--
initIpadScroll("scrollListDiv",550,870);
//showDetailPageBaseInfo("detailFrame", "<fmt:message key='edoc.workitem.state.darft' />", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_2011"));
showCondition("${v3x:escapeJavascript(param.condition)}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
//-->
initIpadScroll("scrollListDiv",550,870);
</script>
</body>
</html>