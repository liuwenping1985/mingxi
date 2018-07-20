<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="com.seeyon.ctp.common.AppContext"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<fmt:message key="common.dateselected.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<form action="" name="mainForm" id="mainForm"  method="post" >
<input type="hidden" id="isalert" value="true">
<input type="hidden" id="method" value="${param.method}">
<v3x:table data="${docs}" var="docsList" htmlId="docgrid" className="sort ellipsis" isChangeTRColor="false" showHeader="true" showPager="true" pageSize="0" dragable="true">
	<c:set value="${vo.grids}" var="src" />
	<c:if test="${isNull == 'true' }">
		<v3x:column width="3%" label="<input type='checkbox'/>" align="center" />
	</c:if>
	<c:if test="${isNull == 'false' }">
		<c:set value="${docsList.grids}" var="src" />
		<c:if test="${param.method ne 'advancedQuery'}">
		<v3x:column width="3%" align="center" label="<input type='checkbox' onclick='docSelectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="${docsList.docResource.id}" isCollect="${docsList.isCollect}"
					onClick="chkMenuGrantControl('${docsList.allAcl }','${docsList.editAcl}','${docsList.addAcl}','${docsList.readOnlyAcl}','${docsList.browseAcl}','${docsList.listAcl}',this,'${docsList.docResource.isFolder}','${docsList.isFolderLink}','${docsList.isLink}','${docsList.appEnumKey}','${docsList.isSysInit}','${docsList.docResource.createUserId == v3x:currentUser().id}','${docsList.isCollect}','${onlyA6}','${onlyA6s}')" />
				<input type="hidden" id="isFolder${docsList.docResource.id}"
					value="${docsList.docResource.isFolder}">
                <input type="hidden" id="isCollect" name="isCollect" value="${docsList.isCollect}">
				<input type="hidden" id="prop_edit_${docsList.docResource.id}"
					value="${docsList.allAcl || docsList.editAcl}">
				<input type="hidden" id="appEnumKey_${docsList.docResource.id}"
					value="${docsList.appEnumKey}">
				<input type="hidden" id="sourceId_${docsList.docResource.id}"
					value="${docsList.docResource.sourceId}">
				<input type="hidden" id="createDate_${docsList.docResource.id}"
					value="${docsList.createDate}">
				<input type="hidden" id="isUploadFile_${docsList.docResource.id}"
					value="${docsList.isUploadFile}">
				
				<script type="text/javascript">
				pagedAclMap.put('${docsList.docResource.id}', 
					new docListAcl('${docsList.allAcl }','${docsList.editAcl}','${docsList.addAcl}',
								'${docsList.readOnlyAcl}','${docsList.browseAcl}','${docsList.listAcl}',
								'${docsList.docResource.isFolder}','${docsList.isFolderLink}','${docsList.isLink}','${docsList.appEnumKey}','${docsList.isSysInit}','${docsList.docResource.createUserId == v3x:currentUser().id}','${docsList.isCollect}','${onlyA6}','${onlyA6s}'));
				
			</script>	
		</v3x:column>
		</c:if>
	</c:if>
	<c:set value="" var="event" />
	<c:set value="" var="rid" />
	<c:forEach items="${src}" var="docsRows">
		<c:set value="" var="mover" />
		<c:set value="" var="mout" />
		<c:if test="${docsRows.isName == 'true' && docsList.settable == 'true'}">
			 <c:if test="${param.frType == '40' && param.method ne 'advancedQuery'}" >
			 	<c:set value="OnMouseUp(new DocResource('${docsList.docResource.id}','${v3x:toHTMLWithoutSpaceEscapeQuote(docsList.docResource.frName)}','${docsList.docResource.parentFrId}','${docsList.docResource.isFolder}','${docsList.isUploadFile}','${docsList.isLink}','${docsList.docResource.isCheckOut}','${docsList.docResource.checkOutUserId}','${docsList.isPig}','${docsList.isFolderLink}','${docsList.docResource.isLearningDoc}','${docsList.appEnumKey}','${docsList.isSysInit}','${docsList.docResource.mimeTypeId}', '${docsList.docResource.versionEnabled}', '${docsList.docResource.recommendEnable}'), new DocAcl('true','true','true','true','true','true','true'), '${entranceType}','${docsList.isCollect}', '${docsList.vForDocPropertyIframe}','${docsList.vForBorrow}','${docsList.openSquare}','${docsList.vForDocDownload}','${docsList.collect}','${onlyA6}','${onlyA6s}','${isGovVer}');" var="event" />
			 </c:if>
             <c:if test="${param.frType != '40' && param.method ne 'advancedQuery'}">
			 	<c:set value="OnMouseUp(new DocResource('${docsList.docResource.id}','${v3x:toHTMLWithoutSpaceEscapeQuote(docsList.docResource.frName)}','${docsList.docResource.parentFrId}','${docsList.docResource.isFolder}','${docsList.isUploadFile}','${docsList.isLink}','${docsList.docResource.isCheckOut}','${docsList.docResource.checkOutUserId}','${docsList.isPig}','${docsList.isFolderLink}','${docsList.docResource.isLearningDoc}','${docsList.appEnumKey}','${docsList.isSysInit}','${docsList.docResource.mimeTypeId}', '${docsList.docResource.versionEnabled}', '${docsList.docResource.recommendEnable}'), new DocAcl('${docsList.allAcl}','${docsList.editAcl}','${docsList.addAcl}','${docsList.readOnlyAcl}','${docsList.browseAcl}','${docsList.listAcl}','${docsList.docResource.createUserId == v3x:currentUser().id}'),'${entranceType}','${docsList.isCollect}', '${docsList.vForDocPropertyIframe}','${docsList.vForBorrow}','${docsList.openSquare}','${docsList.vForDocDownload}','${docsList.collect}','${onlyA6}','${onlyA6s}','${isGovVer}');" var="event" />
			 </c:if>
			<c:set value="editImg('${docsList.docResource.id}')" var="mover" />
			<c:set value="removeEditImg('${docsList.docResource.id}')" var="mout" />
			<c:set value="${docsList.createDate}" var="theDate" />			
		</c:if>
		<c:if test="${docsRows.isName == 'true'}">
			<c:set value="${docsList.docResource.hasAttachments}" var="attflag" />
			<c:set value="${docsList.docResource.isRelationAuthority}" var="authflag" />
			<c:set value="${v3x:_(pageContext, docsRows.value)}" var="theAlt" />
		</c:if>
		<c:if test="${docsRows.isName == 'false' }">
			<c:set value="${v3x:_(pageContext, docsRows.value)}" var="theAlt" />
			<c:set value="" var="attflag" />
		</c:if>

		
		<c:if test="${docsRows.isName != 'true' && docsRows.type.name == 'java.sql.Timestamp'}">
			<fmt:formatDate value="${docsRows.value}"	pattern="${datetimePattern }" var="theAlt" />
		</c:if>
		<c:if test="${docsRows.isName != 'true' && docsRows.type.name == 'java.util.Date'}">
			<fmt:formatDate value="${docsRows.value}"	pattern="${datePattern }" var="theAlt" />
		</c:if>
		<c:if test="${docsRows.type.name == 'java.lang.String' && docsRows.value == '&nbsp;'}">
			<c:set value="" var="theAlt" />
		</c:if>
		<c:if test="${docsRows.isImg == 'true'}">
		  <c:set value=" " var="theAlt" />
		</c:if>
		
		<c:choose>
			<c:when test="${docsRows.type.name=='java.lang.StringBuffer'}">
				<c:set value="String" var="sortType" />
			</c:when>
			<c:when test="${(docsRows.type.name == 'java.util.Date')||(docsRows.type.name=='java.sql.Timestamp')}">
				<c:set value="Date" var="sortType" />
			</c:when>
			<c:when test="${(docsRows.type.name == 'java.lang.Integer')}">
				<c:set value="Number" var="sortType" />
			</c:when>
            <c:when test="${(docsRows.type == null)}">
				
			</c:when>
			<c:otherwise>
				<c:set value="String" var="sortType" />
			</c:otherwise>
		</c:choose>
		
		
		<c:set value="${docsRows.percent}%" var="width" />
		
		
		<c:set value="${v3x:toHTMLWithoutSpace(docsList.docResource.frName)}" var="docResource" />
		<c:set value="${v3x:_(pageContext, docsRows.value)}" var="docsRowsValue" />
<v3x:column label="${v3x:toHTML(docsRows.title)}   " align="left" 
			onmouseover="${mover}" onmouseout="${mout}"
			type="${sortType}" alt="${theAlt}" width="${width}" widthFixed="${docsRows.isImg == 'true' ?'true':'false'}"  nowarp="${isNull eq 'true' ? 'true' : 'false'}">
			<c:if test="${docsRows.isName}"><input type="hidden" id="${docsList.docResource.id}_Name" value="${v3x:toHTML(v3x:_(pageContext, docsRows.value))}"></c:if>
            <input type="hidden" id="${docsList.docResource.id}_Size" value="${v3x:toHTML(v3x:_(pageContext, docsRows.value))}">
			<input type="hidden" id="${docsList.docResource.id}_IsPig" value="${docsList.isPig || docsList.isLink || docsList.isFolderLink}">
			<input type="hidden" id="${docsList.docResource.id}_UploadFileV" value="${docsList.vForDocDownload}">
			<c:choose>			
				<c:when
					test="${docsRows.isName == 'true' && docsList.isUploadFile == 'false' && docsList.docResource.isFolder == 'true'}">
					<a  class="font-12px defaulttitlecss" href="javascript:folderOpenFun('${docsList.docResource.id}','${docsList.docResource.frType}','${docsList.allAcl}','${docsList.editAcl}','${docsList.addAcl}','${docsList.readOnlyAcl}','${docsList.browseAcl}','${docsList.listAcl}', 'false','${docsList.v}','${docsList.docResource.projectTypeId}');">
					${v3x:toHTML(v3x:_(pageContext, docsRows.value))}</a>
					<span class="attachment_table_${attflag} ${attflag?'inline-block':''}"></span>
					<span class="relationAuthority_${authflag} ${authflag?'inline-block':''}"></span>
					<c:if test="${docsList.isPerson != 'true' && param.method ne 'advancedQuery'}">
						<span class="editContent"
							title="<fmt:message key='doc.menu.caozuo.label'/>"
							onclick="${event}" id="_${docsList.docResource.id}"></span>
					</c:if>
				</c:when>
				<c:when
					test="${docsRows.isName == 'true' && docsList.isUploadFile == 'false' && docsList.docResource.isFolder == 'false' && docsList.isLink == 'false' && docsList.isPig == 'false' && docsList.isFolderLink == 'false' }">
                    <a class="font-12px defaulttitlecss" href="javascript:fnOpenKnowledge('${docsList.docResource.id}','${entranceType}',null,false,true)">${v3x:toHTML(docsRowsValue)}</a>                 
					<span class="attachment_table_${attflag} ${attflag?'inline-block':''}"></span>
					<span class="relationAuthority_${authflag} ${authflag?'inline-block':''}"></span>
					<c:if test="${param.method ne 'advancedQuery'}">
					<span class="editContent"
						title="<fmt:message key='doc.menu.caozuo.label'/>"
						onclick="${event}" id="_${docsList.docResource.id}"></span>
					</c:if>
					
				</c:when>
				<c:when
					test="${docsRows.isName == 'true' && docsList.isUploadFile == 'false' && docsList.docResource.isFolder == 'false' && docsList.isLink == 'false'  && docsList.isPig == 'true' && docsList.isFolderLink == 'false' }">
					

						<a class="defaulttitlecss" href="javascript:fnOpenKnowledge('${docsList.docResource.id}','${entranceType}',null,false,true)">
							<c:if test="${docsList.workflowEndState}" >
								<span class="ico16 flow${docsList.workflowState}_16"></span>
							</c:if>
							${v3x:toHTML(v3x:_(pageContext, docsRows.value))}
						</a>
						<c:choose>
							<c:when test="${docsRows.isName}">
								<c:set
									value="docResId=${docsList.docResource.id}&all=${docsList.allAcl}&edit=${docsList.editAcl}&add=${docsList.addAcl}&readonly=${docsList.readOnlyAcl}&browse=${docsList.browseAcl}&isBorrowOrShare=${docsList.isBorrowOrShare}&list=${docsList.listAcl}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&isLink=false"
									var="docOpenUrl" />
								<c:set value="${v3x:encoderQueryString(docOpenUrl)}"
									var="docOpenEncoderUrl" />
								<input type="hidden" id="${docsList.docResource.id}_Url"
									value="${docOpenEncoderUrl}">
							</c:when>
						</c:choose>
						<span class="attachment_table_${attflag} ${attflag?'inline-block':''}"></span>
						<span class="relationAuthority_${authflag} ${authflag?'inline-block':''}"></span>
					<c:if test="${param.method ne 'advancedQuery'}">
					<span class="editContent"
						title="<fmt:message key='doc.menu.caozuo.label'/>"
						onclick="${event}" id="_${docsList.docResource.id}"></span>
					</c:if>
					
				</c:when>
				<c:when
					test="${docsRows.isName == 'true' && docsList.isUploadFile == 'false' && docsList.docResource.isFolder == 'false' && docsList.isLink == 'true' && docsList.isPig == 'false' && docsList.isFolderLink == 'false'}">
						<c:if test="${docsList.appEnumKey != 3 }">
                            <a class="defaulttitlecss" href="javascript:fnOpenKnowledge('${docsList.docResource.id}','${entranceType}',null,false,true)">${v3x:toHTML(v3x:_(pageContext, docsRows.value))}</a>
                        </c:if>
                        <c:if test="${docsList.appEnumKey == 3 }">
                            <a class="defaulttitlecss" href="javascript:fnOpenKnowledge('${docsList.docResource.id}','${entranceType}',null,false,true)">${v3x:toHTML(v3x:_(pageContext, docsRows.value))}</a>
                        </c:if>
						<c:choose>
							<c:when test="${docsRows.isName == 'true'}">
								<c:set
									value="docResId=${docsList.docResource.id}&all=${docsList.allAcl}&edit=${docsList.editAcl}&add=${docsList.addAcl}&readonly=${docsList.readOnlyAcl}&browse=${docsList.browseAcl}&isBorrowOrShare=${docsList.isBorrowOrShare}&list=${docsList.listAcl}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&isLink=false"
									var="docOpenUrl" />
								<c:set value="${v3x:encoderQueryString(docOpenUrl)}"
									var="docOpenEncoderUrl" />
								<input type="hidden" id="${docsList.docResource.id}_Url"
									value="${docOpenEncoderUrl}">
							</c:when>
						</c:choose>
						<span class="attachment_table_${attflag} ${attflag?'inline-block':''}"></span>
						<span class="relationAuthority_${authflag} ${authflag?'inline-block':''}"></span>
						<c:if test="${param.method ne 'advancedQuery'}">
						    <span class="editContent" title="<fmt:message key='doc.menu.caozuo.label'/>" onclick="${event}" id="_${docsList.docResource.id}"></span>
						</c:if>
					
				</c:when>
				<c:when
					test="${docsRows.isName == 'true' && docsList.isUploadFile == 'false' && docsList.docResource.isFolder == 'false' && docsList.isLink == 'false' && docsList.isPig == 'false' && docsList.isFolderLink == 'true'}">
					<a  class="font-12px defaulttitlecss" href="javascript:folderOpenFun('${docsList.docResource.sourceId}','${docsList.docResource.frType}','${docsList.allAcl}','${docsList.editAcl}','${docsList.addAcl}','${docsList.readOnlyAcl}','${docsList.browseAcl}','${docsList.listAcl}', 'true','${docsList.v}','${docsList.docResource.projectTypeId}');">
					${v3x:toHTML(v3x:_(pageContext, docsRows.value))}</a>
					<span class="attachment_table_${attflag} ${attflag?'inline-block':''}"></span>
					<span class="relationAuthority_${authflag} ${authflag?'inline-block':''}"></span>
					<c:if test="${docsList.isPerson != 'true'}">
						<span class="editContent"
							title="<fmt:message key='doc.menu.caozuo.label'/>"
							onclick="${event}" id="_${docsList.docResource.id}"></span>
						
					</c:if>

				</c:when>
				<c:when test="${docsRows.isImg == 'true' }">
					<img src="/seeyon/apps_res/doc/images/docIcon/${docsList.openSquare?'share_':''}${docsRows.value}" width="16" height="16"><c:if test="${docsList.docResource.isCheckOut == 'true'}"><img src="/seeyon/apps_res/doc/images/checkoutoverlay.gif" style="border:0;position:relative;left:-7px;"></c:if>
				</c:when>
				<c:when
					test="${docsRows.isName != 'true' && docsRows.type.name != 'java.sql.Timestamp' && docsRows.type.name != 'java.util.Date'}">
				      		<c:choose>
				      		<c:when test="${docsRows.type.name == 'java.lang.String' && docsRows.value == '&nbsp;'}">
								&nbsp;
							</c:when>
							<c:otherwise>
								${v3x:toHTML(v3x:_(pageContext, docsRows.value))}&nbsp;
							</c:otherwise>
				      		</c:choose>
				   </c:when>
				<c:when
					test="${docsRows.isName != 'true' && docsRows.type.name == 'java.sql.Timestamp'}">
				
					<c:if test="${docsRows.value != ''}">
						<fmt:formatDate value="${docsRows.value}"	pattern="${datetimePattern }" var="timeValue" />	
						${timeValue}
						</c:if>
					<c:if test="${docsRows.value == ''}">&nbsp;</c:if>
					
				</c:when>
				<c:when
					test="${docsRows.isName != 'true' && docsRows.type.name == 'java.util.Date'}">
				
					<c:if test="${docsRows.value != ''}">
						<fmt:formatDate value="${docsRows.value}"	pattern="${datePattern }" var="dateValue" />	
						${dateValue}</c:if>
					<c:if test="${docsRows.value == ''}">&nbsp;</c:if>
					
				</c:when>
				<c:when test="${docsRows.isName != 'true' && docsRows.type.name == 'java.lang.Boolean'}">
					<fmt:message key="${docsRows.value}" bundle="v3xCommonI18N" />					
				</c:when>
				<c:when test="${docsList.isUploadFile == 'true'}">
					<a class="font-12px defaulttitlecss" href="javascript:fnOpenKnowledge('${docsList.docResource.id}','${entranceType}',null,false,true)">${v3x:toHTML(docsRowsValue)}</a>
						<span class="attachment_table_${attflag} ${attflag?'inline-block':''}"></span>
					<c:if test="${param.method ne 'advancedQuery'}">
					<span class="editContent"
						title="<fmt:message key='doc.menu.caozuo.label'/>"
						onclick="${event}" id="_${docsList.docResource.id}">
					</span>
					</c:if>
				</c:when>
			</c:choose>
			<%--<c:choose>
					<c:when test="${docsRows.isName == 'true'}">
						<c:if test="${docsList.isCollect == 'true'}">
							<span class="ico16 collection_16"></span>
						</c:if>
                        
					</c:when>
			</c:choose>
		--%></v3x:column>
		<c:set value="" var="event" />
	</c:forEach>
	 <%
     	if(AppContext.hasPlugin("secret")){
     %>
	<v3x:column width="60px" align="center" label="${ctp:i18n('secret.doc.secretLevel')}">
		<c:if test="${docsList.docResource.secretLevel != null}">
				<c:forEach items="${secretLevelList }" var="item" varStatus="status">
						<c:if test="${item.value == docsList.docResource.secretLevel}" >${item.label }</c:if>
					</c:forEach>
			</c:if>
	</v3x:column>
	 <%
    }
    %>
	<% if(addinMenus !=null && addinMenus.size() != 0){%>
	<c:if test="${isLibOwner==true && isPrivateLib==false}">
		<v3x:column width="60px" align="center" label="doc.tree.move.pigeonhole">
		<c:choose>
			<c:when test="${docsList.docResource.third_hasPingHole==true}">
				<fmt:message key='doc.thirdM.pingHole.lable.true'/>
			</c:when>
			<c:otherwise>
				<fmt:message key='doc.thirdM.pingHole.lable.false'/>
			</c:otherwise>
		</c:choose>
		</v3x:column>
	</c:if>
	<%}%>
</v3x:table> 
<input type="hidden" name="oname" value=""> 
<input type="hidden" name="is_folder" value="">
<input type="hidden" name="isPersonalLib" value="">
<input type="hidden" name="parentId" value="${param.resId}">
<input type="hidden" name="docLibId" value="${param.docLibId}">
<input type="hidden" name="docLibType" value="${param.docLibType}">
<input type="hidden" name="selectedRowId" value="">
<div id="docUploadDiv" style="visibility:hidden"><div><v3x:fileUpload applicationCategory="3" /></div></div>
<script>
	var fileUploadQuantity = 5;
</script>
</form>