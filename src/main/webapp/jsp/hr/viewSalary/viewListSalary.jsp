<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript">
<!--
	function viewSalary(salaryId){
		if(v3x.getBrowserFlag('pageBreak')){
			parent.detailFrame.location.href = hrSalaryURL + "?method=viewSalary&sId=" + salaryId + "&dis=true";
		}else{
		    v3x.openWindow({
			     url: hrSalaryURL + "?method=viewSalary&sId=" + salaryId + "&dis=true",
			     dialogType:"open",
			     workSpace:"yes"
			});
		}
	}
//-->
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
<body>
<div class="scrollList" id="scrollList">
	<input type="hidden" id="resultCount" value="${resultCount}" />
	<form id="salaryform" name="salaryform" action="" method="post">
		<div class="mxt-grid-header">
			<table id="salarylist" class="sort docellipsis" width="100%"  border="0" cellspacing="0" cellpadding="0" onClick="sortColumn(event, true)" dragable="true">
				<thead class="mxt-grid-thead">
					<tr class="sort">
						<td width="30" align="center">&nbsp;</td>
						<td colspan="2" align="center"><b><fmt:message key="hr.fieldset.salaryinfo.label" bundle='${v3xHRI18N}'/></b></td>
						<c:forEach items="${hrPages}" var="hrPage" varStatus="ordinal">
							<c:if test="${!empty pageProperties[hrPage.id]}">
								<td colspan="${fn:length(pageProperties[hrPage.id])}" align="center"><b>${v3x:toHTML(hrPage.pageName)}</b></td>
							</c:if>
						</c:forEach>
					</tr>
					<tr class="sort">
						<td width="30" align="center" style="padding-left: 0px"><input type='checkbox' id='allCheckbox' onclick='selectAll(this, "id")'/></td>
						<td type="String"><fmt:message key="hr.salary.name.label" bundle='${v3xHRI18N}'/></td>
						<td type="Month"><fmt:message key="hr.salary.mounth.label" bundle='${v3xHRI18N}'/></td>
						<c:forEach items="${pageProperties}" var="pp">
							<c:forEach items="${pp.value}" var="pro">
								<td>${v3x:toHTML(propertyTypes[pro.id])}</td>
							</c:forEach>
						</c:forEach>
					</tr>
				</thead>
				<tbody class="mxt-grid-tbody">
					<c:forEach items="${salarys}" var="sal">
						<c:set var="click" value="viewSalary('${sal.id}')"/>
						<tr class="sort">
							<td width="30" align="center" class="cursor-hand" style="border-bottom: solid 1px #D7D7D7;"><input type="checkbox" name="id" value="${sal.id}"></td>
							<td onclick="${click}" title="${sal.name}" class="cursor-hand sort">${sal.name}</td>
							<td onclick="${click}" title="${sal.year}-${sal.month}" class="cursor-hand sort">${sal.year}-${sal.month}</td>
							<c:forEach items="${pageProperties}" var="pp">
								<c:forEach items="${pp.value}" var="pro">
									<td onclick="${click}" title="${propertyValues[sal.id][pro.id]}" class="cursor-hand sort">${propertyValues[sal.id][pro.id]}&nbsp;</td>
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
							pageQueryMap.put('method', "${param.method}");
							pageQueryMap.put('_spage', '');
							pageQueryMap.put('page', '${page}');
							pageQueryMap.put('count', "${size}");
							pageQueryMap.put('pageSize', "${pageSize}");
						//-->
						</script>
						               <DIV class="common_over_page align_right">
                        <fmt:message key='taglib.list.table.page.html' bundle="${v3xCommonI18N}">
                            <fmt:param ><input type="text" maxlength="3" class="pager-input-25-undrag" value="${pageSize}" name="pageSize" onChange="pagesizeChange(this)" onkeypress="enterSubmit(this, 'pageSize')"></fmt:param>
                            <fmt:param>${pages}</fmt:param>
                            <fmt:param>${size}</fmt:param>
                          <fmt:param>
                             <a href="javascript:first(this)" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.first.label' bundle="${v3xCommonI18N}" />"><EM class=pageFirst></EM></a>
                             <a href="javascript:prev(this)" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.prev.label' bundle="${v3xCommonI18N}" />"><EM class=pagePrev></EM></a>
                             <a href="javascript:next(this)" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.next.label' bundle="${v3xCommonI18N}" />"><EM class=pageNext></EM></a>
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
<script type="text/javascript">
    document.getElementById('scrollList').style.height = document.body.clientHeight +"px";
    window.onresize = function () {
        if (document.body.clientHeight > 0) {
            document.getElementById('scrollList').style.height = document.body.clientHeight +"px";
        }
    }
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.hr.salary.view.manager' bundle='${v3xMainI18N}'/>", [2,4], pageQueryMap.get('count'), v3x.getMessage("HRLang.detail_hr_802"));
	initIpadScroll("scrollListDiv", 550, 870);
</script>
</body>
</html>