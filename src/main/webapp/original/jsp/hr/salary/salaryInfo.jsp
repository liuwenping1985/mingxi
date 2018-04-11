<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html style="height:100%;">
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<script type="text/javascript">
<!--
    var setPasswordI18n = "<fmt:message key='system.password.protecd.set' />";
	function viewSalary(salaryId){
		parent.detailFrame.location.href = hrSalaryURL+"?method=viewSalary&sId="+salaryId+"&dis=true";
	}
	
	function modify(){
		if(checkSelectedId(parent.listFrame)){
			alert(v3x.getMessage("HRLang.hr_userDefined_data_choose_message"));
			return false;
		}
		var salaryId = getSelectId(parent.listFrame);
		parent.detailFrame.location.href = hrSalaryURL+"?method=viewSalary&sId="+salaryId+"&dis=false";
	}

//-->  
	function transferSalaryRecord() {
		$.ajax({
			type : 'post',
			url : hrSalaryURL + "?method=check",
			cache : false,
			data : "json",
			success : function(data) {
				var obj = eval('(' + data + ')');
				if (obj.msg == "false") {				
					alert(v3x.getMessage("HRLang.hr_message_salarydata_transferreport_empty"));
					
				} else {
					getA8Top().winSalaryPwd = getA8Top().$.dialog({
								title : "<fmt:message key='hr.transfer.salarydata.transferreport' bundle='${v3xHRI18N}' />",
								transParams : {
									'parentWin' : window
								},
								url : hrSalaryURL + "?method=transferSalaryRecord",
								width : 850,
								height : 680,
								isDrag : false
							});
				}
			},
			error : function(data) {
				alert("error");
			}
		})
	}
</script>
<style type="text/css">
	.docellipsis{
		table-layout: auto;
	}
	.docellipsis td{
		white-space:nowrap;
		overflow:hidden;
		text-overflow:ellipsis;
	}
</style>
</head>
<body style="height:100%; background:#f0f0f0; ">

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="50%">
        <script type="text/javascript">
            onlyLoginAccount_salaryDept = true;
            
            function setSearchPeopleFields(elements) {
                document.getElementById("salaryDeptId").value = getIdsString(elements, false);
                document.getElementById("salaryDeptName").value = getNamesString(elements);
            }
            
            var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
        
            myBar1.add(new WebFXMenuButton("newSalaryInfo", "<fmt:message key='hr.toolbar.salaryinfo.new.label' bundle='${v3xHRI18N}' />", "newSalaryInfo()", [1,1]));
            myBar1.add(new WebFXMenuButton("modify", "<fmt:message key='hr.staffInfo.modify.label' bundle='${v3xHRI18N}' />", "modify()", [1,2], "", null));
            myBar1.add(new WebFXMenuButton("deleteSalary", "<fmt:message key='hr.toolbar.salaryinfo.delete.label' bundle='${v3xHRI18N}' />", "deleteSalary()", [1,3]));
            myBar1.add(new WebFXMenuButton("import", "<fmt:message key='hr.toolbar.salaryinfo.import.label' bundle='${v3xHRI18N}' />", "importExcel()", [2,6]));
            myBar1.add(new WebFXMenuButton("export", "<fmt:message key='common.toolbar.download.label' bundle='${v3xCommonI18N}' />", "exportTemplate()", [3,4]));
            myBar1.add(new WebFXMenuButton("setNewPassWrod", "<fmt:message key='system.password.protecd.person'/>", "setMembersNewPassWrod()", [9,9]));
            //这里是数据交接的按钮
            var forwardSubItems = new WebFXMenu;
            var listMembers = '${listMembers}';
            var members=eval(listMembers);
            for(var i=0;i<members.length;i++){
                var userName = members[i].userName;
                var userId = members[i].userId;
                forwardSubItems.add(new WebFXMenuItem("transferSalary"+i, userName, "transferSalary('"+userId+"','"+userName+"')", ""));
            }
            myBar1.add(new WebFXMenuButton("forward", "<fmt:message key='hr.transfer.selectpeople' bundle='${v3xHRI18N}' />", "",[17,1],"<fmt:message key='common.advance.label' bundle='${v3xCommonI18N}'/>", forwardSubItems));
            myBar1.add(new WebFXMenuButton("transferSalaryRecord", "<fmt:message key='hr.transfer.salarydata.transferreport' bundle='${v3xHRI18N}' />", "transferSalaryRecord()", [21,7]));
            document.write(myBar1);
            document.close();           
        </script>
    </td>
    <td><input type="hidden" id="exCondition" value="" /><input type="hidden" id="exStaffName" value="" /></td>
    <td><input type="hidden" id="exFromTime" value="" /><input type="hidden" id="exToTime" value="" /></td>
    <td class="webfx-menu-bar" width="50%" height="100%">
        <form action="" name="searchForm" id="searchForm" method="post" onSubmit="return false" style="margin: 0px">
            <div class="div-float-right" >
                <div class="div-float">
                    <select name="condition" id="condition"  onChange="showNextCondition(this)" class="condition">
                        <option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
                        <option value="staffName"><fmt:message key="hr.salary.search.name.label" bundle="${v3xHRI18N}" /></option>
                        <option value="salaryDate"><fmt:message key="hr.salary.search.mounth.label" bundle="${v3xHRI18N}" /></option>
                        <option value="salaryDept"><fmt:message key="hr.salary.dept.label" bundle='${v3xHRI18N}'/></option>
                    </select>
                </div>
                <div id="staffNameDiv" class="div-float hidden"><input type="text" id="staffName" name="staffName" class="textfield" onKeyDown="onEnterPress()"></div>
                <div id="salaryDateDiv" class="div-float hidden">
                    <input type="text" class="textfield" id="fromTime" style="cursor:hand;width: 80px;" name="fromTime" onClick="selectDates('fromTime'); return false;" readonly value="">-
                    <input type="text" class="textfield" id="toTime" style="cursor:hand;width: 80px;" name="toTime" onClick="selectDates('toTime'); return false;" readonly value="">
                </div>
                <div id="salaryDeptDiv" class="div-float hidden">
                    <v3x:selectPeople id="salaryDept" panels="Department" selectType="Department" jsFunction="setSearchPeopleFields(elements)" maxSize="1" />
                    <input type="text" name="salaryDeptName" id="salaryDeptName" class="textfield" readonly="true" onClick="selectPeopleFun_salaryDept()" />
                    <input type="hidden" name="salaryDeptId" id="salaryDeptId" />
                </div>
                <div onClick="javascript:searchSalarys()" class="condition-search-button"></div>
            </div>
        </form>
        <div class="hidden">
            <form name="formExcel" method="post" target="formExcelIframe">
                <table>
                    <tr id="attachmentTR" class="bg-summary" style="display:none;">
                        <td nowrap="nowrap" height="18" class="bg-gray" valign="bottom"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /></td>
                     <v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" originalAttsNeedClone="false" encrypt="false"/>
                    </tr>
                </table>
             </form>
        </div>
    </td>
  </tr>
</table>
<div class="scrollList">
	<form id="salaryform" name="salaryform" action="" method="post">
		<input type="hidden" id="sIds" name="sIds" value="" />
		<div class="mxt-grid-header">
			<table id="salarylist" class="sort docellipsis" width="100%"  border="0" cellspacing="0" cellpadding="0" onClick="sortColumn(event, true)" dragable="true">
				<thead class="mxt-grid-thead">
					<tr class="sort">
						<td width="30" align="center">&nbsp;</td>
						<td colspan="3" align="center"><b><fmt:message key="hr.fieldset.salaryinfo.label" bundle='${v3xHRI18N}'/></b></td>
						<c:forEach items="${hrPages}" var="hrPage" varStatus="ordinal">
							<c:if test="${!empty pageProperties[hrPage.id]}">
								<td colspan="${fn:length(pageProperties[hrPage.id])}" align="center"><b>${v3x:toHTML(hrPage.pageName)}</b></td>
							</c:if>
						</c:forEach>
					</tr>
					<tr class="sort">
						<td width="20" align="center" style="padding-left: 0px"><input type='checkbox' id='allCheckbox' onclick='selectAll(this, "id")'/></td>
						<td type="String"><fmt:message key="hr.salary.name.label" bundle='${v3xHRI18N}'/></td>
						<td type="String"><fmt:message key="hr.salary.dept.label" bundle='${v3xHRI18N}'/></td>
						<td type="Month"><fmt:message key="hr.salary.mounth.label" bundle='${v3xHRI18N}'/></td>
						<c:forEach items="${pageProperties}" var="pp">
							<c:forEach items="${pp.value}" var="pro" varStatus="idxStatus">
								<td>
                                      ${v3x:toHTML(propertyTypes[pro.id])}&nbsp;
                                </td>
							</c:forEach>
						</c:forEach>
					</tr>
				</thead>
				<tbody class="mxt-grid-tbody">
					<c:forEach items="${salarys}" var="sal">
						<c:set var="click" value="viewSalary('${sal.salary.id}')"/>
						<c:set var="dbclick" value="modify();"/>
						<tr class="sort">
							<td width="30" align="center" class="cursor-hand" style="border-bottom: solid 1px #fafafa;"><input type="checkbox" name="id" value="${sal.salary.id}"></td>
							<td onclick="${click}" ondblclick="${dbclick}" title="${sal.salary.name}" class="cursor-hand sort">${sal.salary.name}</td>
                            <c:set value="${v3x:showOrgEntitiesOfIds(sal.orgDepartmentId, 'Department', pageContext)}" var="deptName" />
							<td onclick="${click}" ondblclick="${dbclick}" title="${deptName}" class="cursor-hand sort">${v3x:toHTML(deptName)}</td>
							<td onclick="${click}" ondblclick="${dbclick}" title="${sal.yearMonth}" class="cursor-hand sort">${sal.yearMonth}</td>
							<c:forEach items="${pageProperties}" var="pp">
								<c:forEach items="${pp.value}" var="pro">
									<td onclick="${click}" ondblclick="${dbclick}" title="${propertyValues[sal.salary.id][pro.id]}" class="cursor-hand sort">${propertyValues[sal.salary.id][pro.id]}&nbsp;</td>
								</c:forEach>
							</c:forEach>
						</tr>
					</c:forEach>
				</tbody>
				<tFoot>
					<tr>
					<td colspan="${fn:length(propertyTypes) + 4}" id="pagerTd" class="table_footer" nowrap="nowrap">
						<script type="text/javascript">
						<!--
							var pageFormMethod = "get"
							var pageQueryMap = new Properties();
							pageQueryMap.put('method', "salaryInfo");
							pageQueryMap.put('_spage', '');
							pageQueryMap.put('page', '${page}');
							pageQueryMap.put('count', "${size}");
							pageQueryMap.put('pageSize', "${pageSize}");
							pageQueryMap.put('toTime',"${toTime}");
							pageQueryMap.put('fromTime',"${fromTime}");
							pageQueryMap.put('condition',"${condition}");
							pageQueryMap.put('staffName',"${v3x:escapeJavascript(staffName)}");
							pageQueryMap.put('salaryDeptId',"${salaryDeptId}");
						//-->
						</script>
						 <DIV class="common_over_page align_right">
						<fmt:message key='taglib.list.table.page.html' bundle="${v3xCommonI18N}">
							<fmt:param ><input type="text" maxlength="3" class="pager-input-25-undrag" value="${pageSize}" name="pageSize" onChange="pagesizeChange(this)" onkeypress="enterSubmit(this, 'pageSize')"></fmt:param>
							<fmt:param>${pages}</fmt:param>
							<fmt:param>${size}</fmt:param>
						  <fmt:param>
                             <a href="javascript:first(this)" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.first.label' bundle="${v3xCommonI18N}" />"><EM class=pageFirst></EM></a>
                             <a href="javascript:prev_salary(this)" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.prev.label' bundle="${v3xCommonI18N}" />"><EM class=pagePrev></EM></a>
                             <a href="javascript:next_salary(this)" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.next.label' bundle="${v3xCommonI18N}" />"><EM class=pageNext></EM></a>
                             <a href="javascript:last(this, '${pages }')" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.last.label' bundle="${v3xCommonI18N}" />"><EM class=pageLast></EM></a>
                             </fmt:param>
							<fmt:param>
								<input type="text" maxlength="10" class="pager-input-25-undrag" value="${page}" onChange="pageChange(this)" pageCount="${size}" onkeypress="enterSubmit(this, 'intpage')">
							</fmt:param>
						</fmt:message>
						<A id=grid_go class=common_over_page_btn href="javascript:pageGo(this);">go</A>&nbsp;&nbsp;&nbsp;&nbsp;
                        
						</DIV>
					</td>
					</tr>
				</tFoot>
			</table>
		</div>
	</form>
</div>
<iframe id="formExcelIframe" name="formExcelIframe" width="0" height="0" style="display:none;"></iframe>
<script type="text/javascript">
try{
	 $(window).resize(function(){
	        if ($("body").height()-40 > 0) {
	            $(".scrollList").height($("body").height()-40);
	        }
	    });
	    if ( $("body").height()-40 > 0) {
	        $(".scrollList").height($("body").height()-40);
	    }
	    showDetailPageBaseInfo("detailFrame", "<fmt:message key='hr.userDefined.model.salary.label' bundle='${v3xHRI18N}'/>", [2,4], pageQueryMap.get('count'),  v3x.getMessage("HRLang.detail_hr_1203"));
	    var staffName = '${param.staffName}';
	    var fromTime = '${param.fromTime}';
	    var toTime = '${param.toTime}';
	    var salaryDeptName = '${param.salaryDeptName}';
	    document.getElementById('staffName').value = staffName;
	    document.getElementById('fromTime').value = fromTime;
	    document.getElementById('toTime').value = toTime;
	    document.getElementById('salaryDeptName').value = salaryDeptName;
	    showCondition("${param.condition}", "<v3x:out value='${param.staffName}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
}catch(e){
	
}

function next_salary(obj) {
	var page = parseInt(pageQueryMap.get('page'));
	var counts = parseInt('${pages}');
	if (page >= counts) {
		return ;
	}
	next(obj);
}

function prev_salary(obj) {
	var page = parseInt(pageQueryMap.get('page'));
	if (page <= 1) {
		return ;
	}
	prev(obj);
}
</script>
</body>
</html>