<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" />
<html>
<head>
<script type="text/javascript">
//if("${isManager}"=="Manager"){
//    getA8Top().showLocation(null, getA8Top().findMenuName(12), getA8Top().findMenuItemName(1202), "<fmt:message key='hr.staffInfo.rewardsAndPunishment.label' bundle='${v3xHRI18N}'/>");
//}
//else{
//    getA8Top().showLocation(null, getA8Top().findMenuName(8), getA8Top().findMenuItemName(801), "<fmt:message key='hr.staffInfo.rewardsAndPunishment.label' bundle='${v3xHRI18N}'/>");
//}
	</script>
<script language="JavaScript">
function add(){
     if("${isManager}"!="Manager"){
        alert(v3x.getMessage("HRLang.hr_staffInfo_addByself_forbidden_label"));
        return;
     }
     parent.detailFrame.window.location="${hrStaffURL}?method=initDetail&staffId=${staff.id}&isManager=${isManager}&isNew=New&infoType=8";
}

function getTypeSelectId(){
		var ids=document.getElementsByName('id');
		var count = 0;
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				count += 1;
				if(count > 1) {
					id='false';
					break;
				}
				id=idCheckBox.value;		
			}
		}
		return id;	
	}

function modify(){  
     if("${isManager}"!="Manager"){
        alert(v3x.getMessage("HRLang.hr_staffInfo_modifyByself_forbidden_label"));
        return;
     }     
     /*if(getSelectId(this)){
		var id = getSelectId(this);
		parent.detailFrame.window.location='${hrStaffURL}?method=initDetail&staffId=${staff.id}&id='+id+'&isManager=${isManager}&infoType=8';
	 }else{
		alert(v3x.getMessage("HRLang.hr_staffInfo_choose_modify"));
		return false;
	 }	*/
	  var id=getTypeSelectId();
		if(id=='false'){
			alert(v3x.getMessage("HRLang.hr_staffInfo_choose_modify"));
			return;
		}
		if(id==''){
			alert(v3x.getMessage("HRLang.hr_staffInfo_choose_modify"));
			return;
		}
		parent.detailFrame.window.location='${hrStaffURL}?method=initDetail&staffId=${staff.id}&id='+id+'&isManager=${isManager}&infoType=8';
		 
}
function viewRewardsAndPunishment(id){
	 parent.detailFrame.window.location='${hrStaffURL}?method=initDetail&id='+id+'&isReadOnly=ReadOnly&isManager=${isManager}&infoType=8';
} 
function del(){
    if("${isManager}"!="Manager"){
        alert(v3x.getMessage("HRLang.hr_staffInfo_deleteByself_forbidden_label"));
        return;
    }
    if(getSelectIds(this)){
		if(!confirm(v3x.getMessage("HRLang.hr_staffInfo_is_delete"))){
			return;
		}
		var ids = getSelectIds(this);
		window.location='${hrStaffURL}?method=deleteRewardsAndPunishment&staffId=${staff.id}&ids='+ids+'&isManager=${isManager}&infoType=8';
	}else{
		alert(v3x.getMessage("HRLang.hr_staffInfo_choose_delete"));
		return;
	}
}
 

</script>
<style type="text/css">
	.table_footer {height: 47px;}
</style>
</head>
<body scroll="yes">

	<script>	
	if("${isManager}"=="Manager"){	
		//def toolbar
		var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />", "gray");
		
		//add buttons
		myBar1.add(new WebFXMenuButton("new", "<fmt:message key='hr.toolbar.salaryinfo.new.label' bundle='${v3xHRI18N}' />",  "add()", "<c:url value='/common/images/toolbar/new.gif'/>"));
		myBar1.add(new WebFXMenuButton("modify", "<fmt:message key='hr.staffInfo.modify.label' bundle='${v3xHRI18N}' />", "modify()", "<c:url value='/common/images/toolbar/update.gif'/>", "", null));
		myBar1.add(new WebFXMenuButton("delete", "<fmt:message key='hr.toolbar.salaryinfo.delete.label' bundle='${v3xHRI18N}' />", "del()", "<c:url value='/common/images/toolbar/delete.gif'/>"));
		//myBar1.add(new WebFXMenuButton("export", "<fmt:message key='hr.staffInfo.export.label' bundle='${v3xHRI18N}'/>",  null, "<c:url value='/common/images/toolbar/exportExcel.gif'/>", "", null));	
		
		document.write(myBar1);
		document.close();
	}
	</script>
<input type="hidden" name="isManager" id="isManager" value="${isManager}"> 
			<div class="scrollList" id="scrollList" style="overflow:hidden">
				<form id="form1" method="post">
					<v3x:table data="${list}" var="bean"  showHeader="true"  showPager="true" pageSize="20" htmlId="listBean">
			        <c:set var="click" value="viewRewardsAndPunishment('${bean.id}');"/>			       
                    <v3x:column width="4%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
				            <input type="checkbox" name="id" id="id" value="${bean.id}">
			        </v3x:column>
			        <%--
                    <v3x:column width="7%" label="hr.staffInfo.name.label" type="String"
							value="${staff.name}" onClick="${click}" className="cursor-hand sort" 
					 		symbol="..." alt="${staff.name}"
					></v3x:column>		
					<v3x:column width="7%" label="hr.staffInfo.memberno.label" type="String"
							value="${staff.code}" onClick="${click}" className="cursor-hand sort"
					 		symbol="..." alt="${staff.code}"
					></v3x:column>	
                    --%>
					<v3x:column width="20%" label="hr.staffInfo.RAndPdate.label" type="String" onClick="${click}" className="cursor-hand sort">
					 		<fmt:formatDate value="${bean.time}" type="both" dateStyle="full" pattern="yyyy-MM-dd"  />
                    </v3x:column>
					
										
					<v3x:column width="20%" label="hr.staffInfo.RAndPtype.label" type="String" onClick="${click}" className="cursor-hand sort">
					 	   <c:choose>
		                   <c:when test="${bean.type == 1}">
					 		  <fmt:message key="hr.staffInfo.reward.label"  bundle="${v3xHRI18N}"/>
					 	   </c:when>
					 	   <c:when test="${bean.type == 2}">
					 	      <fmt:message key="hr.staffInfo.punishment.label"  bundle="${v3xHRI18N}"/>
					 	   </c:when>
					 	   </c:choose>	
					</v3x:column>	
					<v3x:column width="50%" label="hr.staffInfo.RAndP.organization.label" type="String"
							value="${bean.organization}" onClick="${click}" className="cursor-hand sort"
					 		alt="${bean.organization}"
					></v3x:column>								
					</v3x:table>                   					
                </form>
			</div>              
	<script type="text/javascript">
      showDetailPageBaseInfo("detailFrame", "<fmt:message key='hr.staffInfo.rewardsAndPunishment.label' bundle='${v3xHRI18N}'/>", [2,4], pageQueryMap.get('count'),  v3x.getMessage("HRLang.detail_hr_120208"));
      $(function(){
        function fixHeight(){
            setTimeout(function(){
                var bodyHeight = $("body").height();
                $("#scrollList").height(bodyHeight-40);
                $("#bDivlistBean").height(bodyHeight-115);
            }, 10);
        }
        fixHeight();
        
        $(window).resize(function() {
            fixHeight();
        });
      });
    </script>
</body>
</html>