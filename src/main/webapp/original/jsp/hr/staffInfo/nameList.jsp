<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
         <!DOCTYPE html>
<%@ include file="../header.jsp"%>
<html style="height:100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources" var="v3xOrgI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources"/>
<script type="text/javascript" src="<c:url value='/common/js/util/URI.js${v3x:resSuffix()}'/>"></script>
<script   language="JavaScript">

/**
 * 导出（excel）。依赖/common/js/util/URI.js中的getUriParam()及processUriParam()
 * @param exportType 导出类型：excel
 */
function exportAs(exportType) {
	var pageFrame = window;
	var exportFrame = parent.window;
	var pageUri = pageFrame.location.href;
	var pageMethod = getUriParam(pageUri, "method");
	var exportUri = pageUri;
	exportUri = processUriParam(exportUri, "method", "export");
	exportUri = processUriParam(exportUri, "exportType", exportType);
	exportUri = processUriParam(exportUri, "pageMethod", pageMethod);
	exportFrame.location.href = exportUri;
}

function exportExcel(){ 
	exportAs("excel");
//	parent.window.location.href = "<c:url value='/hrStaff.do'/>?method=exportNameListExcel&staffIds="+document.getElementById("staffIds").value+"&title="+encodeURI(document.getElementById("title").value)+"&items="+document.getElementById("items").value;
	//exportIt(url);
}
function printNameList(){
	   var oObj = document.getElementById('table-list');
	   var oMemberlist = document.getElementById('memberlist');
	   oObj.width = oObj.clientWidth;
	   oObj.height = oMemberlist.style.height;
	   var aa= "";
	   var mm = $('#editForm').html();
	   var list1 = new PrintFragment(aa,mm);
	   var tlist = new ArrayList();
	   tlist.add(list1);
	   var cssList=new ArrayList();
	   printList(tlist,cssList);
}
function cancel(){
       parent.window.location.href="${hrStaffURL}?method=initStaffListFrame";
    }
</script>
</head>
<body style="height:100%;">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg" scroll="no">
<tr>
	<td>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr><td>
			<script>	
			//def toolbar
			var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
			
			//add buttons
		    myBar1.add(new WebFXMenuButton("export", "<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />", "exportExcel()", "<c:url value='/common/images/toolbar/bodyType_excel.gif'/>"));
			myBar1.add(new WebFXMenuButton("print", "<fmt:message key='hr.toolbar.salaryinfo.print.label' bundle='${v3xHRI18N}' />", "printNameList()", "<c:url value='/common/images/toolbar/print.gif'/>", "", null));	
			myBar1.add(new WebFXMenuButton("cancel", "<fmt:message key='hr.staffInfo.return.lable' bundle='${v3xHRI18N}' />", "cancel()", "<c:url value='/common/images/toolbar/back.gif'/>"), "",null );
			//WebFXMenuButton对象参数：（HtmlId, 显示名称, 按钮事件, 图标, alt/title, 子菜单）
			document.write(myBar1);
			document.close();
			</script>
		</td>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td height="100%"  valign="top">
		<div id="scrollDiv" class="scrollList">
		<table border="0" cellpadding="0" cellspacing="0" width="100%"  align="center" class="categorySet-bg" style="table-layout: fixed;" scroll="no">
			<input type="hidden" name="staffIds" id="staffIds" value="${staffIds}">
			<input type="hidden" name="title" id="title" value="${title}">
			<input type="hidden" name="items" id="items" value="${items}">
			<tr>
				<td class="categorySet-4" height="8"></td>
			</tr>
			<tr>
				<td class="categorySet-head" height="23">
					<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="categorySet-1" width="4"></td>
							<td class="categorySet-title" width="80" nowrap="nowrap">
							   <fmt:message key="hr.nameList.label" bundle="${v3xHRI18N}"/>
		                    </td>
							<td class="categorySet-2" width="7"></td>
							<td class="categorySet-head-space">&nbsp;
						    </td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="categorySet-head">
					<div class="categorySet-body" style="padding: 0" id="namelist">
					<form id="editForm" method="post" action="">
		
					 <table id="table-list" border="0" cellspacing="0" cellpadding="0" width="100%" >
		               <tr height="20"><td align="center" colspan＝"2">
		                  <font size="4"><strong>${title}</strong></font>
		               </td>
		               </tr>
		               <tr height="10"><td colspan＝"2"></td>
		               </tr>
		               <tr>
			               <td valign="top" class="border-top"> 
				                 <form id="form1" method="post">
				                   <v3x:table data="memberlist" var="list" htmlId="memberlist" className="sort" showHeader="true"  showPager="${isPage}" pageSize="20" dragable="false">
				
				                    <v3x:column width="6%" label="hr.nameList.number.label" 
								            value="${list.nameList_number}" className="sort" 
								            symbol="..." alt="${list.nameList_number}"/>
				                      
									<c:forEach items="${items}" var="item">
										
											<c:if test="${item=='1'}">
													<v3x:column width="8%" nowarp="true" label="hr.staffInfo.name.label" 
								            value="${list.name}" className="sort" 
								            symbol="..." alt="${list.name}"/>
											</c:if>
											<c:if test="${item=='2'}">
											<v3x:column width="5%" label="hr.staffInfo.sex.label" className="sort" >
						                      <c:if test="${list.sex == '1'}">
									 		  <fmt:message key="hr.staffInfo.male.label" bundle="${v3xHRI18N}"/>
									 	      </c:if>
									 	      <c:if test="${list.sex == '2'}">
									 	      <fmt:message key="hr.staffInfo.female.label" bundle="${v3xHRI18N}"/>
									 	      </c:if>
								            </v3x:column>
										</c:if>
											<c:if test="${item=='3'}">
												<v3x:column width="6%" nowarp="true" label="hr.staffInfo.nation.label" 
								           		value="${list.nation}" className="sort" 
								            	symbol="..." alt="${list.nation}"/>
											</c:if>
											<c:if test="${item=='4'}">
												<v3x:column width="5%" label="hr.staffInfo.age.label" 
								            	value="${list.age == '0' ? '' : list.age}" className="sort" 
								            	symbol="..." alt="${list.age == '0' ? '' : list.age}"/>
											</c:if>
											<c:if test="${item=='5'}">
												<v3x:column width="10%" nowarp="true" label="hr.staffInfo.specialty.label" 
								            	value="${list.specialty}" className="sort" 
								            	symbol="..." alt="${list.specialty}"/>
											</c:if>
											<c:if test="${item=='6'}">
												<v3x:column width="10%" nowarp="true" label="hr.staffInfo.IDcard.label" 
								            	value="${list.ID_card}" className="sort" 
								            	symbol="..." alt="${list.ID_card}"/>
											</c:if>
										
											<c:if test="${item=='7'}">
											<v3x:column width="8%" label="hr.staffInfo.edulevel.label" className="sort" > 
						                      <c:if test="${list.edu_level == 1}">
									 		   <fmt:message key="hr.staffInfo.juniorschool.label" bundle="${v3xHRI18N}"/>
									 	      </c:if>
									 	      <c:if test="${list.edu_level == 2}">
									 	       <fmt:message key="hr.staffInfo.seniorschool.label" bundle="${v3xHRI18N}"/>
									 	      </c:if>
									 	      <c:if test="${list.edu_level == 3}">
									 		   <fmt:message key="hr.staffInfo.juniorcollege.label" bundle="${v3xHRI18N}"/>
									 	      </c:if>
									 	      <c:if test="${list.edu_level == 4}">
									 	       <fmt:message key="hr.staffInfo.university.label" bundle="${v3xHRI18N}"/>
									 	      </c:if>
									 	      <c:if test="${list.edu_level == 5}">
									 		   <fmt:message key="hr.staffInfo.postgraduate.label" bundle="${v3xHRI18N}"/>
									 	      </c:if>
									 	      <c:if test="${list.edu_level == 6}">
									 	       <fmt:message key="hr.staffInfo.doctor.label" bundle="${v3xHRI18N}"/>
									 	      </c:if>
									 	      <c:if test="${list.edu_level == 7}">
									 	       <fmt:message key="hr.staffInfo.other.label" bundle="${v3xHRI18N}"/>
									 	      </c:if>
									 	      <c:if test="${list.edu_level == 8}">
									 	       <fmt:message key="hr.staffInfo.edulevel.8" bundle="${v3xHRI18N}"/>
									 	      </c:if>
									 	      <c:if test="${list.edu_level == 9}">
									 	       <fmt:message key="hr.staffInfo.edulevel.9" bundle="${v3xHRI18N}"/>
									 	      </c:if>
									 	      <c:if test="${list.edu_level == 10}">
									 	       <fmt:message key="hr.staffInfo.edulevel.10" bundle="${v3xHRI18N}"/>
									 	      </c:if>
								            </v3x:column>
										</c:if>
										<c:if test="${item=='8'}">
											<v3x:column width="6%" nowarp="true" label="hr.staffInfo.position.label" className="sort" >
											<c:if test="${list.political_position != '0'}">
									 		  <fmt:message key="hr.staffInfo.position.${list.political_position}" bundle="${v3xHRI18N}"/>
									 	    </c:if>
									 		</v3x:column>
										</c:if>
										<c:if test="${item=='9'}">
											<v3x:column width="6%"  nowarp="true" label="hr.staffInfo.marriage.label" className="sort" >
						                      <c:if test="${list.marriage == 1}">
									 		  <fmt:message key="hr.staffInfo.single.label" bundle="${v3xHRI18N}"/>
									 	      </c:if>
									 	      <c:if test="${list.marriage == 2}">
									 	      <fmt:message key="hr.staffInfo.married.label" bundle="${v3xHRI18N}"/>
									 	      </c:if>
								            </v3x:column>
										</c:if>
										<c:if test="${item=='10'}">
											<v3x:column width="10%" nowarp="true" type="String" label="hr.staffInfo.workStartingDate.label" className="sort" >
						                      <fmt:formatDate value="${list.work_starting_date}" type="both" dateStyle="full" pattern="yyyy-MM-dd"  />
				                        	</v3x:column>
										</c:if>
											<c:if test="${item=='11'}">
											<v3x:column width="10%" nowarp="true" label="hr.staffInfo.recordWage.label" 
								            value="${list.record_wage}" className="sort" 
								            symbol="..." alt="${list.record_wage}"/>
										</c:if>
												<c:if test="${item=='12'}">
											<v3x:column width="6%" nowarp="true" label="hr.staffInfo.memberno.label" 
								            value="${list.code}" className="sort" 
								            symbol="..." alt="${list.code}"/>
										</c:if>
												<c:if test="${item=='13'}">
											<v3x:column width="6%" nowarp="true" label="hr.staffInfo.peopleType.label" className="sort" >
								             <c:choose>
						                      <c:when test="${list.people_type==true}">
									 		   <fmt:message key="people.isInternal" bundle="${v3xOrgI18N}"/>
									 	      </c:when>
									 	      <c:otherwise>
									 	       <fmt:message key="people.out" bundle="${v3xOrgI18N}"/>
									 	      </c:otherwise>
									 	     </c:choose>
								            </v3x:column>
										</c:if>
										<c:if test="${item=='14'}">
											<v3x:column width="6%" nowarp="true" label="hr.staffInfo.staffstate.label" className="sort" >
								             <c:choose>
						                      <c:when test="${list.state==1}">
									 		   <fmt:message key="org.metadata.member_state.in" bundle="${v3xOrgI18N}"/>
									 	      </c:when>
									 	      <c:otherwise>
									 	       <fmt:message key="org.metadata.member_state.out" bundle="${v3xOrgI18N}"/>
									 	      </c:otherwise>
									 	     </c:choose>
								            </v3x:column>
										</c:if>
										
											<c:if test="${item=='15'}">
											<v3x:column width="6%" nowarp="true" label="hr.staffInfo.stafftype.label" className="sort" >
									 	    	<v3x:metadataItemLabel metadata="${orgMeta['org_property_member_type']}" value="${list.type}" />
								            </v3x:column>
										</c:if>
												<c:if test="${item=='16'}">
											<v3x:column width="10%" nowarp="true" label="hr.staffInfo.department.label" 
								            value="${list.department_name}" className="sort" 
								            symbol="..." alt="${list.department_name}"/>
										</c:if>
											<c:if test="${item=='17'}">
											<v3x:column width="10%" nowarp="true" label="hr.staffInfo.postlevel.label${v3x:suffix()}" 
								            value="${list.level_name}" className="sort" 
								            symbol="..." alt="${list.level_name}"/>
										</c:if>
										<c:if test="${item=='18'}">
											<v3x:column width="10%" nowarp="true" label="hr.staffInfo.primaryPostId.label" 
								            value="${list.post_name}" className="sort" 
								            symbol="..." alt="${list.post_name}"/>
										</c:if>
										<c:if test="${item=='19'}">
											<v3x:column width="10%" nowarp="true" label="hr.staffInfo.secondPostId.label" 
								            value="${list.second_posts}" className="sort" 
								            symbol="..." alt="${list.second_posts}"/>
										</c:if>
										<c:if test="${item=='20'}">
											<v3x:column width="10%" nowarp="true" label="hr.staffInfo.birthday.label" 
								            value="${list.birthdayStr}" className="sort" 
								            symbol="..." alt="${list.birthdayStr}"/>
										</c:if>
										<c:if test="${item=='21'}">
											<v3x:column width="10%" nowarp="true" label="hr.staffInfo.worklocal.label" 
								            value="${list.worklocalStr}" className="sort" 
								            symbol="..." alt="${list.worklocalStr}"/>
										</c:if>
										<c:if test="${item=='22'}">
											<v3x:column width="10%" nowarp="true" label="hr.staffInfo.reporter.label" 
								            value="${list.reporterStr}" className="sort" 
								            symbol="..." alt="${list.reporterStr}"/>
										</c:if>
										
									</c:forEach>
				                   	</v3x:table>
				                 </form>  
					       </td>
				       </tr>
				       </table>
				       
				       </form>
					</div>		
				</td>
			</tr>
		</table>
		</div>
	</td>
</tr>
<tr>
	<td><div id="placeHolder"></div></td>
</tr>
</table>
<script type="text/javascript">
	$('#namelist').height(parent.window.document.body.clientHeight - 70);
</script>
</body>
</html>