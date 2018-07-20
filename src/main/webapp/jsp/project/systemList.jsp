<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<html>
<head>
<title>项目分类设置</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="projectHeader.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript">
    //getA8Top().showLocation(3309);
		function create(){
			parent.detailFrame.location.href="${basicURL}?method=addType";
		}
		var stateMap = new Properties();
	   function remove(){
			var id = getSelectIds();
			if(id){
				if(!confirm(v3x.getMessage("ProjectLang.sure_delete_project_class")))
					return false;
			
				var form1 = document.getElementById("phraseform");
				form1.action="${basicURL}?method=projectDelete&id="+id;
				form1.target="listFrame";
				window.parent.frames("detailFrame").location.href="<c:url value="/common/detail.jsp" />";
				form1.submit();
			}else{
				alert(v3x.getMessage("ProjectLang.select_at_least_one_to_delete"));  
				return false;
			}
		}
		function dbclick(id,type){
			parent.detailFrame.location.href = partitionURL+"?method=modify"+type+"&id="+id;
		}
		// 双击事件
		function phraseOndbclick(id){
			changeButton();
		 parent.detailFrame.location.href = "${basicURL}?method=getProject&projectId="+id+"&readonly=0";
		}
		// 单击事件
		function phraseOnclick(id,canView){
		  if(canView != 'yes'){
		    alert(canView);
		  }else{
		    changeButton();
		    parent.detailFrame.location.href = "${basicURL}?method=getProject&projectId="+id+"&readonly=1";
		  }
		}
		// 修改
		function modify(){
			var theForm = document.getElementsByName("phraseform")[0];
		    if (!theForm) {
		        return false;
		    }

			var ElementsObject= document.getElementsByName("id");
			var count = 0;
			var id="";
			for(var j = 0;j<ElementsObject.length;j++){
			    if (ElementsObject[j].checked == true)
			          {
			              id = ElementsObject[j].value;
			              //alert(id);
			              count++;
			          }
			}
			
			if(count == 0){
			  alert(v3x.getMessage("ProjectLang.please_select_one_to_update"));
			  return;
			}
			if(count > 1){
			  alert(v3x.getMessage("ProjectLang.only_select_one"));
			  return;   
			}
			parent.detailFrame.location.href = "${basicURL}?method=modifyProject&id="+id;	
		}
		
		function singleSelect(me){
			var inputs = document.getElementsByName("id");
        	for(var   i=0;i<inputs.length;   i++) {   
                inputs[i].checked   =   false;   
        }   
        me.checked=true;   
		}
		function changeButton(){
		 	parent.parent.disabledMyBar("new");	
		 	parent.parent.disabledMyBar("modify");
		 	parent.parent.disabledMyBar("delete");
		 	parent.parent.disabledMyBar("modifyLeader",true);
		 	
		}
		
		
	</script>
</head>
<body>
    <input id="projectTypeId" type="hidden" value="${projectTypeId}">
	<form id="phraseform" method="post">
		<v3x:table  htmlId="postlist" data="ptList" var="phrase" showPager="true" className="sort ellipsis">
			<c:set var="click" value="phraseOnclick('${phrase.projectSummary.id}','${phrase.canView}')" />
			<c:set var="dbclick" value="phraseOndbclick('${phrase.projectSummary.id}')" />
			
			<v3x:column width="5%" align="center" label="<input type='checkbox' disabled='disabled' id='allCheckbox' title='全选'/>">
				<input type="checkbox" onclick="changeButton()" name="id" value="${phrase.projectSummary.id}" />
			</v3x:column>
			
			<v3x:column width="14%" align="left" label="project.body.projectName.label" type="String" value="${phrase.projectSummary.projectName}" className="cursor-hand sort"  alt="${phrase.projectSummary.projectName}"
				onClick="${click}" onDblClick="${dbclick}"/>
                
			<v3x:column width="10%" align="left" label="project.body.projectNum.label" type="String" value="${phrase.projectSummary.projectNumber}" className="cursor-hand sort"  alt="${phrase.projectSummary.projectNumber}"
                onClick="${click}" onDblClick="${dbclick}"/>
                
			<v3x:column width="10%" align="left" label="project.body.projectType.label" type="String" value="${phrase.projectSummary.projectTypeName}" className="cursor-hand sort" maxLength="90" symbol="..." alt="${phrase.projectSummary.projectTypeName}"
				onClick="${click}" />	
			
			<v3x:column width="15%" align="left" label="project.body.responsible.label" type="String" value="${v3x:showOrgEntities(phrase.principalLists, 'id', 'entityType', pageContext)}" className="cursor-hand sort" maxLength="90" symbol="..." alt="${v3x:showOrgEntities(phrase.principalLists, 'id', 'entityType', pageContext)}"
				onClick="${click}" />
			
			<v3x:column width="14%" align="left" label="project.body.startdate.label" type="String" className="cursor-hand sort" maxLength="90" symbol="..." alt="${phrase.projectSummary.begintimeStr}"
				onClick="${click}" >
				<fmt:formatDate value="${phrase.projectSummary.begintime}" pattern="yyyy-MM-dd"/>
				</v3x:column>
			
			<v3x:column width="14%" align="left" label="project.body.enddate.label" type="String"  className="cursor-hand sort" maxLength="90" symbol="..." alt="${phrase.projectSummary.closetimeStr}"
				onClick="${click}">
				<fmt:formatDate value="${phrase.projectSummary.closetime}" pattern="yyyy-MM-dd"/>
				</v3x:column>
			<fmt:message key='project.body.projectstate.${phrase.projectSummary.projectState}' var="projectState" />
			<v3x:column width="10%" align="left" label="project.body.state.label" type="String" value="${projectState}" className="cursor-hand sort" maxLength="90" symbol="..." alt="${projectState }"
				onClick="${click}" />
			
			<v3x:column width="8%" align="left" label="project.process.label" type="String" className="cursor-hand sort" maxLength="90" symbol="..." alt="${phrase.projectSummary.projectProcessInt}%"
				onClick="${click}">
				<c:choose>
  				<c:when test="${phrase.projectSummary.projectProcessInt == null}">0</c:when>
 				<c:when test="${phrase.projectSummary.projectProcessInt == 100}">100</c:when>
  				<c:otherwise>${phrase.projectSummary.projectProcessInt}</c:otherwise>
 				</c:choose>%
 				
 				<script>
					<!--
						stateMap.put('${phrase.projectSummary.id}','${phrase.projectSummary.projectState}');
					//-->
					</script>
			</v3x:column>
		</v3x:table>
	</form>
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='work.area.setup.project' bundle='${v3xMainI18N}'/>", [2,2], pageQueryMap.get('count'), _("ProjectLang.detail_info_9102"));
</script>
</body>
</html>
