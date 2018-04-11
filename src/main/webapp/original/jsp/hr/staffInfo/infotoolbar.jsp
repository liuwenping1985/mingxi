<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<script type="text/javascript">
<!--
function changedType(type){ 
    var isNew = "${isNew}";
    if(${infoType}==1 && isNew=="New"){
       alert(v3x.getMessage("HRLang.hr_staffInfo_info_first_label"));
       return;
    }
    parent.window.location='${hrStaffURL}?method=initInfoHome&infoType='+type+'&isReadOnly=ReadOnly&staffId=${staffId}&isManager=${isManager}';
}
function showPage(id){
	 var isNew = "${isNew}";
    if(${infoType}==1 && isNew=="New"){
       alert(v3x.getMessage("HRLang.hr_staffInfo_info_first_label"));
       return;
    }
    parent.window.location="${hrStaffURL}?method=userDefinedHome&page_id="+id+'&isReadOnly=ReadOnly&staffId=${staffId}&isManager=${isManager}';
}
//-->
</script>


<table width="100%" border="0" cellpadding="0" cellspacing="0">

<tr>
  <td valign="bottom" height="26" class="tab-tag">
	<div class="div-float">
	<c:choose>
	  <c:when test="${infoType=='1'}">
  		<div class="tab-tag-left-sel"></div>
		<div class="tab-tag-middel-sel" onclick="changedType(1)"><fmt:message key='hr.staffInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right-sel"></div>
		<div class="tab-separator"></div>								
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" onclick="changedType(2)"><fmt:message key='hr.staffInfo.contactInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" onclick="changedType(3)" ><fmt:message key='hr.staffInfo.family.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>			
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" onclick="changedType(4)"><fmt:message key='hr.staffInfo.workRecord.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>				
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" onclick="changedType(5)" ><fmt:message key='hr.staffInfo.eduAndTrain.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(6)" ><fmt:message key='hr.staffInfo.postchange.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(7)" ><fmt:message key='hr.staffInfo.assess.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>				
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(8)" ><fmt:message key='hr.staffInfo.rewardsAndPunishment.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>					
		<c:forEach items="${webPages}" var="webPage" >
   		<div class="tab-tag-left"></div>
			<div class="tab-tag-middel" onclick="showPage('${webPage.page_id}')" >
				<c:choose>
					<c:when test="${v3x:getLocale(pageContext.request) == 'zh_CN'}">
						${webPage.pageName_zh}
					</c:when>
					<c:otherwise>
						${webPage.pageName_en}
					</c:otherwise>
				</c:choose>
			</div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>
     	</c:forEach>						
   </c:when>
   <c:when  test="${infoType=='2'}">
  		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(1)" ><fmt:message key='hr.staffInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>								
		<div class="tab-tag-left-sel"></div>
		<div class="tab-tag-middel-sel"  onclick="changedType(2)"><fmt:message key='hr.staffInfo.contactInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right-sel"></div>				
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(3)" ><fmt:message key='hr.staffInfo.family.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>			
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(4)"><fmt:message key='hr.staffInfo.workRecord.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>				
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(5)" ><fmt:message key='hr.staffInfo.eduAndTrain.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(6)" ><fmt:message key='hr.staffInfo.postchange.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(7)" ><fmt:message key='hr.staffInfo.assess.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>				
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(8)" ><fmt:message key='hr.staffInfo.rewardsAndPunishment.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>					
		<c:forEach items="${webPages}" var="webPage" >
   		<div class="tab-tag-left"></div>
			<div class="tab-tag-middel" onclick="showPage('${webPage.page_id}')" >
				<c:choose>
					<c:when test="${v3x:getLocale(pageContext.request) == 'zh_CN'}">
						${webPage.pageName_zh}
					</c:when>
					<c:otherwise>
						${webPage.pageName_en}
					</c:otherwise>
				</c:choose>
			</div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>
     	</c:forEach>
   </c:when>
   <c:when test="${infoType=='3'}">	
  		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(1)" ><fmt:message key='hr.staffInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>								
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(2)"><fmt:message key='hr.staffInfo.contactInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>					
		<div class="tab-tag-left-sel"></div>
		<div class="tab-tag-middel-sel"  onclick="changedType(3)" ><fmt:message key='hr.staffInfo.family.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right-sel"></div>				
		<div class="tab-separator"></div>			
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(4)"><fmt:message key='hr.staffInfo.workRecord.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>				
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(5)" ><fmt:message key='hr.staffInfo.eduAndTrain.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(6)" ><fmt:message key='hr.staffInfo.postchange.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(7)" ><fmt:message key='hr.staffInfo.assess.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>				
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(8)" ><fmt:message key='hr.staffInfo.rewardsAndPunishment.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>					
		<c:forEach items="${webPages}" var="webPage" >
   		<div class="tab-tag-left"></div>
			<div class="tab-tag-middel" onclick="showPage('${webPage.page_id}')" >
				<c:choose>
					<c:when test="${v3x:getLocale(pageContext.request) == 'zh_CN'}">
						${webPage.pageName_zh}
					</c:when>
					<c:otherwise>
						${webPage.pageName_en}
					</c:otherwise>
				</c:choose>
			</div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>
     	</c:forEach>
   </c:when>
   <c:when  test="${infoType=='4'}">
  		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(1)" ><fmt:message key='hr.staffInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>								
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(2)"><fmt:message key='hr.staffInfo.contactInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(3)" ><fmt:message key='hr.staffInfo.family.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>			
		<div class="tab-tag-left-sel"></div>
		<div class="tab-tag-middel-sel"  onclick="changedType(4)"><fmt:message key='hr.staffInfo.workRecord.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right-sel"></div>				
		<div class="tab-separator"></div>				
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(5)" ><fmt:message key='hr.staffInfo.eduAndTrain.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(6)" ><fmt:message key='hr.staffInfo.postchange.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(7)" ><fmt:message key='hr.staffInfo.assess.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>				
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(8)" ><fmt:message key='hr.staffInfo.rewardsAndPunishment.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>					
		<c:forEach items="${webPages}" var="webPage" >
   		<div class="tab-tag-left"></div>
			<div class="tab-tag-middel" onclick="showPage('${webPage.page_id}')" >
				<c:choose>
					<c:when test="${v3x:getLocale(pageContext.request) == 'zh_CN'}">
						${webPage.pageName_zh}
					</c:when>
					<c:otherwise>
						${webPage.pageName_en}
					</c:otherwise>
				</c:choose>
			</div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>
     	</c:forEach>	
   </c:when>
   <c:when  test="${infoType=='5'}">
  		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(1)" ><fmt:message key='hr.staffInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>								
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(2)"><fmt:message key='hr.staffInfo.contactInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(3)" ><fmt:message key='hr.staffInfo.family.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>			
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(4)"><fmt:message key='hr.staffInfo.workRecord.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>				
		<div class="tab-tag-left-sel"></div>
		<div class="tab-tag-middel-sel"  onclick="changedType(5)" ><fmt:message key='hr.staffInfo.eduAndTrain.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right-sel"></div>
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(6)" ><fmt:message key='hr.staffInfo.postchange.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(7)" ><fmt:message key='hr.staffInfo.assess.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>				
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(8)" ><fmt:message key='hr.staffInfo.rewardsAndPunishment.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>					
		<c:forEach items="${webPages}" var="webPage" >
   		<div class="tab-tag-left"></div>
			<div class="tab-tag-middel" onclick="showPage('${webPage.page_id}')" >
				<c:choose>
					<c:when test="${v3x:getLocale(pageContext.request) == 'zh_CN'}">
						${webPage.pageName_zh}
					</c:when>
					<c:otherwise>
						${webPage.pageName_en}
					</c:otherwise>
				</c:choose>
			</div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>
     	</c:forEach>		
   </c:when>
   <c:when  test="${infoType=='6'}">
  		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(1)" ><fmt:message key='hr.staffInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>								
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(2)"><fmt:message key='hr.staffInfo.contactInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(3)" ><fmt:message key='hr.staffInfo.family.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>			
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(4)"><fmt:message key='hr.staffInfo.workRecord.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>				
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(5)" ><fmt:message key='hr.staffInfo.eduAndTrain.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>					
		<div class="tab-tag-left-sel"></div>
		<div class="tab-tag-middel-sel"  onclick="changedType(6)" ><fmt:message key='hr.staffInfo.postchange.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right-sel"></div>	
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(7)" ><fmt:message key='hr.staffInfo.assess.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>				
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(8)" ><fmt:message key='hr.staffInfo.rewardsAndPunishment.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>					
		<c:forEach items="${webPages}" var="webPage" >
   		<div class="tab-tag-left"></div>
			<div class="tab-tag-middel" onclick="showPage('${webPage.page_id}')" >
				<c:choose>
					<c:when test="${v3x:getLocale(pageContext.request) == 'zh_CN'}">
						${webPage.pageName_zh}
					</c:when>
					<c:otherwise>
						${webPage.pageName_en}
					</c:otherwise>
				</c:choose>
			</div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>
     	</c:forEach>
   </c:when>
   <c:when  test="${infoType=='7'}">
  		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(1)" ><fmt:message key='hr.staffInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>								
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(2)"><fmt:message key='hr.staffInfo.contactInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(3)" ><fmt:message key='hr.staffInfo.family.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>			
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(4)"><fmt:message key='hr.staffInfo.workRecord.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>				
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(5)" ><fmt:message key='hr.staffInfo.eduAndTrain.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(6)" ><fmt:message key='hr.staffInfo.postchange.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>					
		<div class="tab-tag-left-sel"></div>
		<div class="tab-tag-middel-sel"  onclick="changedType(7)" ><fmt:message key='hr.staffInfo.assess.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right-sel"></div>	
		<div class="tab-separator"></div>				
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(8)" ><fmt:message key='hr.staffInfo.rewardsAndPunishment.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>					
		<c:forEach items="${webPages}" var="webPage" >
   		<div class="tab-tag-left"></div>
			<div class="tab-tag-middel" onclick="showPage('${webPage.page_id}')" >
				<c:choose>
					<c:when test="${v3x:getLocale(pageContext.request) == 'zh_CN'}">
						${webPage.pageName_zh}
					</c:when>
					<c:otherwise>
						${webPage.pageName_en}
					</c:otherwise>
				</c:choose>
			</div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>
     	</c:forEach>		
   </c:when>
   <c:when  test="${infoType=='8'}">
  		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(1)" ><fmt:message key='hr.staffInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>								
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(2)"><fmt:message key='hr.staffInfo.contactInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(3)" ><fmt:message key='hr.staffInfo.family.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>			
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(4)"><fmt:message key='hr.staffInfo.workRecord.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>				
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(5)" ><fmt:message key='hr.staffInfo.eduAndTrain.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(6)" ><fmt:message key='hr.staffInfo.postchange.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(7)" ><fmt:message key='hr.staffInfo.assess.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>				
		<div class="tab-tag-left-sel"></div>
		<div class="tab-tag-middel-sel"  onclick="changedType(8)" ><fmt:message key='hr.staffInfo.rewardsAndPunishment.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right-sel"></div>	
		<div class="tab-separator"></div>					
		<c:forEach items="${webPages}" var="webPage" >
   		<div class="tab-tag-left"></div>
			<div class="tab-tag-middel" onclick="showPage('${webPage.page_id}')" >
				<c:choose>
					<c:when test="${v3x:getLocale(pageContext.request) == 'zh_CN'}">
						${webPage.pageName_zh}
					</c:when>
					<c:otherwise>
						${webPage.pageName_en}
					</c:otherwise>
				</c:choose>
			</div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>
     	</c:forEach>	
   </c:when>
   <c:otherwise>
        <div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(1)" ><fmt:message key='hr.staffInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>								
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(2)"><fmt:message key='hr.staffInfo.contactInfo.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(3)" ><fmt:message key='hr.staffInfo.family.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>			
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(4)"><fmt:message key='hr.staffInfo.workRecord.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>				
		<div class="tab-separator"></div>				
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(5)" ><fmt:message key='hr.staffInfo.eduAndTrain.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(6)" ><fmt:message key='hr.staffInfo.postchange.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>					
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(7)" ><fmt:message key='hr.staffInfo.assess.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>				
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"  onclick="changedType(8)" ><fmt:message key='hr.staffInfo.rewardsAndPunishment.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>					
		<c:forEach items="${webPages}" var="webPage" >
   		
   			<c:choose>
   			<c:when test="${webPage.page_id == page_id}">
   			    <div class="tab-tag-left-sel"></div>
				<div class="tab-tag-middel-sel"><a href="#" class="non-a" onclick="showPage('${webPage.page_id}')" >
					<c:choose>
						<c:when test="${v3x:getLocale(pageContext.request) == 'zh_CN'}">
							${webPage.pageName_zh}
						</c:when>
						<c:otherwise>
							${webPage.pageName_en}
						</c:otherwise>
					</c:choose>
				</div>
				<div class="tab-tag-right-sel"></div>
			</c:when>
			<c:otherwise>
		     	<div class="tab-tag-left"></div>
				<div class="tab-tag-middel"><a href="#" class="non-a" onclick="showPage('${webPage.page_id}')" >
					<c:choose>
						<c:when test="${v3x:getLocale(pageContext.request) == 'zh_CN'}">
							${webPage.pageName_zh}
						</c:when>
						<c:otherwise>
							${webPage.pageName_en}
						</c:otherwise>
					</c:choose>
				</div>
				<div class="tab-tag-right"></div>
			</c:otherwise>
			</c:choose>
		
		<div class="tab-separator"></div>
   	</c:forEach>
   </c:otherwise>
   </c:choose>	
	</div>
  </td>

  </tr>
</table>


