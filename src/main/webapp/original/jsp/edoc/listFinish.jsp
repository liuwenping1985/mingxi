<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Insert title here</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="edocHeader.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<%-- <%@ include file="../doc/pigeonholeHeader.jsp" %> --%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript">
<!--
var jsEdocType=${edocType};

//-->
</script>


<style>
SELECT{
		FONT-SIZE: 10pt; 
		FONT-FAMILY: Times New Roman;
		MARGIN-TOP:1px;
} 
</style>
</head>
<body scroll="no" onload="setMenuState('menu_finish');">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="22"  class="webfx-menu-bar">
			    	<script type="text/javascript">
			    	var edocContorller="${detailURL}";
			    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
			    	//myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.pigeonhole.label' bundle='${v3xCommonI18N}' />", "pigeonholeForEdoc('finish',jsEdocType);", [1,9], "", null));
			    	<c:if test="${ihasArchive==0}">
			    	var pigeonholemain=new WebFXMenu;
			    	pigeonholemain.add(new WebFXMenuItem("","<fmt:message key='edoc.action.companypigeonhole.label'/>","pigeonholeForEdoc('finish')",""));
			    	pigeonholemain.add(new WebFXMenuItem("","<fmt:message key='edoc.action.DepartPigeonhole.label'/>","listDepartPigeonhole('<%=ApplicationCategoryEnum.edoc.getKey()%>','true')",""));
			    	//lijl注销,原因是点击"已办结"的"未归档"中有两个归档,因此注销了一个
			    	//if(v3x.getBrowserFlag('hideMenu')){
						//myBar.add(new WebFXMenuButton("pigeonhole","3<fmt:message key='common.toolbar.pigeonhole.label' bundle='${v3xCommonI18N}' />",null,[1,9],"",pigeonholemain));
			    	//}
                    </c:if>

			    	<c:if test="${ihasArchive==1 && isArchiveRole}">
			    	myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", "javascript:editFromArchived()", [1,9], "", null));    	
			    	myBar.add(new WebFXMenuButton("", "<fmt:message key='toolbar.updatehistory.label'/>", "javascript:showArchiveModifyLog_iframe()", [1,9], "", null));    	
			    	</c:if>
			    	
			    	if(v3x.getBrowserFlag('hideMenu')){
			    		var pigeonholemain=new WebFXMenu;
				    	pigeonholemain.add(new WebFXMenuItem("","<fmt:message key='edoc.action.companypigeonhole.label'/>","pigeonholeForEdoc('finish')",""));
				    	pigeonholemain.add(new WebFXMenuItem("","<fmt:message key='edoc.action.DepartPigeonhole.label'/>","listDepartPigeonhole('<%=ApplicationCategoryEnum.edoc.getKey()%>','true')",""));

			    		myBar.add(new WebFXMenuButton("pigeonhole","<fmt:message key='common.toolbar.pigeonhole.label' bundle='${v3xCommonI18N}' />",null,[1,9],"",pigeonholemain));
			    		myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "javascript:deleteItems('finish')", [1,3], "", null));
			    		/* myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.takeBack.label' bundle='${v3xCommonI18N}' />", "javascript:takeBack('finish')", [4,1], "", null)); */
			    					    	//具有公文发起权的角色拥有“转发文”操作
		               if(${isSendEdocCreateRole} && ${edocType==1}) {  
			    		 myBar.add(new WebFXMenuButton("", "<fmt:message key='edoc.new.type.forwardarticle' />", "javascript:showForwardWDTwo()", [1,2], "", null));
		               }
					}

			    	<v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
			    	document.write(myBar.toString());
			    	document.close();
			    	</script>			
				</td>
				<td class="webfx-menu-bar"><form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
					<input type="hidden" value="<c:out value='${param.method}' />" name="method">
					<input type="hidden" value="<c:out value='${param.listType}' />" name="lisetTyp">
					<input type="hidden" value="<c:out value='${edocType}' />" name="edocType">		
					<input type="hidden" id="appName" name="appName" value='<%=ApplicationCategoryEnum.edoc.getKey()%>'/>	
					<div class="div-float-right">
						<div class="div-float">
							<select name="condition" id= "condition" onChange="showNextSpecialCondition(this)" class="condition" style="width:90px">
						    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							    <option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" /></option>
							    <c:if test="${edocType==0}">
							    <option value="docMark"><fmt:message key="edoc.element.wordno.label" /></option>
							    </c:if>	
							    <c:if test="${edocType==1}">
							    <option value="docMark"><fmt:message key="edoc.element.wordno.label" /></option>
							    </c:if>
							    <option value="docInMark"><fmt:message key="edoc.element.wordinno.label" /></option>
							    <option value="startMemberName"><fmt:message key="common.sender.label" bundle="${v3xCommonI18N}" /></option>
							    <option value="createDate"><fmt:message key="edoc.supervise.startdate" /></option>
							    <c:if test="${edocType==0}">
							    	<option value="receiveTime"><fmt:message key="edoc.supervise.receiveTime"/></option>
								    <%-- 根据国家行政公文规范,去掉主题词
								    <option value="keywords"><fmt:message key="edoc.element.keyword"/></option> --%>
								    <option value="secretLevel"><fmt:message key="edoc.element.secretlevel.simple"/></option>
								    <option value="urgentLevel"><fmt:message key="edoc.element.urgentlevel"/></option>
							    </c:if>	
						  	</select>
					  	</div>
					  	<div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<div id="startMemberNameDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<div id="docMarkDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<div id="docInMarkDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<div id="createDateDiv" class="div-float hidden">
					  		<input type="text" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
					  		-
					  		<input type="text" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
					  	</div>
					  	
					  	<div id="receiveTimeDiv" class="div-float hidden">
					  		<input type="text" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
					  		-
					  		<input type="text" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
					  	</div>
					  	<div id="secretLevelDiv" class="div-float hidden">
					  		<select name="textfield" class="condition" style="width:90px">
					  			<option value=""><fmt:message key="common.pleaseSelect.label" /></option>
					  			<c:forEach var="secret" items="${colMetadata['edoc_secret_level'].items}"> 
					  				<c:if test="${secret.outputSwitch == 1}">
					  				<option value="${secret.value}">
					  					<c:choose>
										<c:when test="${secret.i18n == 1 }">
										<fmt:message key="${secret.label}"/>
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
					  	<div id="urgentLevelDiv" class="div-float hidden">
					  		<select name="textfield" class="condition" style="width:90px">
					  			<option value=""><fmt:message key="common.pleaseSelect.label" /></option>
					  			<c:forEach var="urgent" items="${colMetadata['edoc_urgent_level'].items}"> 
					  				<c:if test="${urgent.outputSwitch == 1}">
					  				<option value="${urgent.value}">
					  				<c:choose>
										<c:when test="${urgent.i18n == 1 }">
										<fmt:message key="${urgent.label}"/>
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
					  	<div onclick="javascript:searchDateCheck(searchForm);" class="div-float condition-search-button"></div>
				  	</div></form>
				</td>
				<td  class="webfx-menu-bar" width="80">
				<form name="combForm" id="combForm" method="post" onsubmit="return false" style="margin: 0px">
				  <input type="hidden" value="<c:out value='${edocType}' />" name="edocType">	
				  <INPUT TYPE="hidden" name="comb_condition" id="comb_condition" value="${combCondition}" />
				  <INPUT TYPE="hidden" name="subject" id="comb_subject" value="${combQueryObj.subject}" />
				  <INPUT TYPE="hidden" name="docMark" id="comb_docMark" value="${combQueryObj.docMark}" />
				  <INPUT TYPE="hidden" name="serialNo" id="comb_serialNo" value="${combQueryObj.serialNo}" />
				  <INPUT TYPE="hidden" name="createPerson" id="comb_createPerson" value="${combQueryObj.createPerson}" />
				  <INPUT TYPE="hidden" name="createTimeB" id="comb_createTimeB" value="<fmt:formatDate value="${combQueryObj.createTimeB}" pattern="yyyy-MM-dd" />" />
				  <INPUT TYPE="hidden" name="createTimeE" id="comb_createTimeE" value="<fmt:formatDate value="${combQueryObj.createTimeE}" pattern="yyyy-MM-dd" />" />
				  <INPUT TYPE="hidden" name="secretLevel" id="comb_secretLevel" value="${combQueryObj.secretLevel}" />
				  <INPUT TYPE="hidden" name="urgentLevel" id="comb_urgentLevel" value="${combQueryObj.urgentLevel}" />
				  <INPUT TYPE="hidden" name="keywords" id="comb_keywords" value="${combQueryObj.keywords}" />
				  <INPUT TYPE="hidden" name="receiveTimeB" id="comb_receiveTimeB" value="<fmt:formatDate value="${combQueryObj.receiveTimeB}" pattern="yyyy-MM-dd" />" />
				  <INPUT TYPE="hidden" name="receiveTimeE" id="comb_receiveTimeE" value="<fmt:formatDate value="${combQueryObj.receiveTimeE}" pattern="yyyy-MM-dd" />" />
				  <INPUT TYPE="hidden" name="sendUnit" id="comb_sendUnit" value="${combQueryObj.sendUnit}" />
				  <INPUT TYPE="hidden" name="registerDateB" id="comb_registerDateB" value="<fmt:formatDate value="${combQueryObj.registerDateB}" pattern="yyyy-MM-dd" />" />
				  <INPUT TYPE="hidden" name="registerDateE" id="comb_registerDateE" value="<fmt:formatDate value="${combQueryObj.registerDateE}" pattern="yyyy-MM-dd" />" />
				  <INPUT TYPE="hidden" name="recieveDateB" id="comb_recieveDateB" value="<fmt:formatDate value="${combQueryObj.recieveDateB}" pattern="yyyy-MM-dd" />" />
				  <INPUT TYPE="hidden" name="recieveDateE" id="comb_recieveDateE" value="<fmt:formatDate value="${combQueryObj.recieveDateE}" pattern="yyyy-MM-dd" />" />
				  <input type="button" style="width:70px" name="btn"  onclick="combQueryEvent(${edocType},6)" value="<fmt:message key='common.combsearch.label'/>">
				</form>
				</td>
			</tr>   
		</table>
    
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<form name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
		<input type="hidden" value="" name="archiveId" id="archiveId">		
		<c:url value='/common/images/overTime.gif' var="overTime" />
		<c:url value='/common/images/timeout.gif' var="timeOut" />
		<v3x:table htmlId="pending" data="pendingList" var="col" className="sort ellipsis">
               
                <c:set value="${v3x:toHTML(col.summary.subject)}" var="subject"  />
                
               <v3x:column width="3%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="${col.summary.id}" affairId="${col.affairId}" processId="${col.summary.processId}" 
				nodePolicy="${col.nodePolicy}" hasArchive="${col.summary.hasArchive}" subject="${subject}" finished="${col.finshed}" archiveId="${col.summary.archiveId}"/>
			</v3x:column>			

			<c:set var="click" value="openDetail('', 'from=Done&affairId=${col.affairId}&from=Pending')"/>
			<c:set var="isRead" value="true"/>
			<v3x:column width="4%" type="String" label="edoc.element.secretlevel.simple" className="cursor-hand sort" read="${isRead}"
			  onClick="${click}">
			<span title="<v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/>"><v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/></span>&nbsp;
			</v3x:column>
			<c:choose>
				<c:when test="${col.deadLine ne null && col.deadLine ne ''&& col.deadLine ne '0'}">
					<v3x:column type="String" label="common.subject.label" className="cursor-hand sort proxy-${col.proxy}"
					bodyType="${col.bodyType}" hasAttachments="${col.summary.hasAttachments}" importantLevel="${col.summary.urgentLevel}" 
					onClick="${click}"  value="${col.summary.subject}" 
					symbol="..."   extIcons="${col.overtopTime eq true ? timeOut : overTime }" flowState="${col.summary.state}"/>
				</c:when>
				<c:otherwise>
					<v3x:column type="String" label="common.subject.label" className="cursor-hand sort proxy-${col.proxy}"
					bodyType="${col.bodyType}" hasAttachments="${col.summary.hasAttachments}" importantLevel="${col.summary.urgentLevel}" 
					onClick="${click}"  value="${col.summary.subject}" 
					symbol="..." flowState="${col.summary.state}"/>
				</c:otherwise>
			</c:choose>
		
            <v3x:column width="20%" maxLength="34"  symbol="..." type="String" label="common.subject.label" className="cursor-hand sort mxtgrid_black" read="${isRead}"
            bodyType="${col.bodyType}" value="${col.summary.subject}" hasAttachments="${col.summary.hasAttachments}"  onClick="${click}" 
            />
			<v3x:column width="14%" type="String" label="edoc.element.wordno.label" className="cursor-hand sort" read="${isRead}"
			 onClick="${click}">
				<span title="${v3x:toHTML(col.summary.docMark)}">${v3x:toHTML(col.summary.docMark)}</span>&nbsp;
			</v3x:column>
			<v3x:column width="12%" type="String" label="edoc.element.wordinno.label" className="cursor-hand sort" read="${isRead}"
			 onClick="${click}">
				<span title="${v3x:toHTML(col.summary.serialNo)}">${v3x:toHTML(col.summary.serialNo)}</span>&nbsp;
			</v3x:column>
			<v3x:column width="7%" type="String" label="common.sender.label"
			className="cursor-hand sort" read="${isRead}"
			 onClick="${click}">
				<span title="${col.summary.startMember.name}">${col.summary.startMember.name}</span>&nbsp;
			</v3x:column>
			<v3x:column width="14%" type="Date" label="edoc.supervise.startdate"  className="cursor-hand sort" read="${isRead}"
			 onClick="${click}">
				<span title="<fmt:formatDate value="${col.summary.createTime}" pattern="${datePattern}"/>"><fmt:formatDate value="${col.summary.createTime}" pattern="${datePattern}"/></span>&nbsp;
			</v3x:column>	
			<v3x:column width="10%" type="Date" label="edoc.supervise.managedate"  className="cursor-hand sort" read="${isRead}"
			 onClick="${click}">
				<span title="<fmt:formatDate value="${col.dealTime}" pattern="${datePattern}"/>"><fmt:formatDate value="${col.dealTime}" pattern="${datePattern}"/></span>&nbsp;
			</v3x:column>
			<v3x:column width="8%" type="String" label="edoc.node.cycle.label" className="cursor-hand sort" 
			read="${isRead}"  onClick="${click}" alt="${v3x:_(pageContext, isOvertop)}" >
				<v3x:metadataItemLabel metadata="${colMetadata.collaboration_deadline}" value="${col.deadLine}"/>	
			</v3x:column>
			<v3x:column width="6%" type="String" align="center" label="edoc.isTrack.label">
				<div class="link-blue" onclick="preChangeTrack('${col.affairId}', ${col.isTrack})">
		    		<span id="track${col.affairId}"><fmt:message key="common.${col.isTrack}" bundle="${v3xCommonI18N}"/></span>
		    	</div>
			</v3x:column>													
			<v3x:column width="8%" type="Number" align="center" label="hasten.number.label" className="cursor-hand sort" read="${isRead}"
			 onClick="${click}" value="${col.hastenTimes}">					
			</v3x:column>
			<!-- lijl添加流程日志 -->
			<v3x:column width="9%" type="String" align="center" label="processLog.list.title.label" >
				<span onclick="showDetailAndLog('${col.summary.id}','${col.summary.processId}','','${col.summary.edocTypeEnum}');" class="icon_com display_block flowdaily_com cursor-hand"></span>
			</v3x:column>
			<%--
			<v3x:column width="10%" type="String" align="center" label="processLog.list.title.label" >
				<img src="<c:url value='/apps_res/collaboration/images/workflowDetail.gif' />" onclick="showProcessLog('${col.summary.processId}');" class="cursor-hand sort">
			</v3x:column>
			--%>
		</v3x:table>
		</form>  
    </div>
  </div>
</div>
</div>
    <input type="hidden" value="0" name="forwardCheckOption" id="forwardCheckOption"/>
    <input type="hidden" name="newContactReceive" id="newContactReceive"/>
<iframe name=tempIframe id=tempIframe style="height:0px;width:0px;display: none;"></iframe>
<script type="text/javascript">
<!--
initIpadScroll("scrollListDiv",550,870);
//showDetailPageBaseInfo("detailFrame", "<fmt:message key='edoc.workitem.state.done' />", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_2014"));
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
//-->
</script>
${v3x:showAlert(pageContext)}

</body>
</html>