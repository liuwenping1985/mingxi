<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html style="height:100%;">
<head>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
	<script type="text/javascript">
		function setTeamDept(elements) {
		if (!elements) {
			return;
		}
		document.getElementById("deptName").value = getNamesString(elements);
		document.getElementById("textfields").value = getIdsString(elements,
				false);
	}
	function selectPersion(inputName) {
		var values = $("#" + inputName);
		var txt = $("#" + inputName + "_text");
		$.selectPeople({
			type : 'selectPeople',
			panels : 'Department,Team',
			selectType : 'Department,Member,Account',
			text : $.i18n('common.default.selectPeople.value'),
			hiddenOtherMemberOfTeam : true,
			maxSize : 1, // 最多选择一个人
			minSize : 1, // 至少选择一个人
			excludeElements : getExcludeElements(inputName),
			params : {
				text : txt.val(),
				value : values.val()
			},
			callback : function(ret) {
				txt.val(ret.text);
				values.val(ret.value);
			}
		});
	}

	/**
	 * 获取已选择人员
	 */
	function getExcludeElements(inputId) {
		var hiddens = $("input:hidden");
		var excludeElements = "";
		for (var i = 0; i < hiddens.length; i++) {
			var val = $(hiddens[i]).val();
			if (val.indexOf("Member") >= 0
					&& $(hiddens[i]).attr("id") != inputId) {
				excludeElements += $(hiddens[i]).val() + ",";
			}
		}
		return excludeElements.substring(0, excludeElements.length - 1);
	}

	function selectDateTime(whoClick, width, height) {
		var history = whoClick.value;
		whenstart('${pageContext.request.contextPath}', whoClick, width, height);
		var date = whoClick.value;
		var newDate = new Date();
		var strDate = newDate.getYear() + "-" + (newDate.getMonth() + 1) + "-"
				+ newDate.getDate();

	}
	onlyLoginAccount_salaryDept = true;

	function setSearchPeopleFields(elements) {
		document.getElementById("salaryDeptId").value = getIdsString(elements,
				false);
		document.getElementById("salaryDeptName").value = getNamesString(elements);
	}

	var pageFormMethod = "get"
	var pageQueryMap = new Properties();
	pageQueryMap.put('method', "transferSalaryRecord");
	pageQueryMap.put('toTime', "${toTime}");
	pageQueryMap.put('fromTime', "${fromTime}");
	pageQueryMap.put('condition', "${condition}");
	pageQueryMap.put('staffName', "${v3x:toHTML(staffName)}");
	pageQueryMap.put('salaryDeptId', "${salaryDeptId}");
	pageQueryMap.put('tansforfromTime', "${tansforfromTime}");
	pageQueryMap.put('tansfortoTime', "${tansfortoTime}");
	pageQueryMap.put('acceptPerson', "${v3x:toHTML(acceptPerson)}");

	</script>
</head>
<body>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td><input type="hidden" id="exCondition" value="" /><input
				type="hidden" id="exStaffName" value="" /></td>
			<td><input type="hidden" id="exFromTime" value="" /><input
				type="hidden" id="exToTime" value="" /></td>
			<td class="webfx-menu-bar" width="100%" height="100%">
				<form action="" name="searchForm" id="searchForm" method="post"
					onSubmit="return false" style="margin: 0px">
					<div class="div-float-right">
						<div class="div-float">
							<select name="condition" id="condition"
								onChange="showNextCondition(this)" class="condition">
								<option value=""><fmt:message
										key="common.option.selectCondition.text"
										bundle="${v3xCommonI18N}" /></option>
								<option value="staffName"><fmt:message
										key="hr.salary.search.name.label" bundle="${v3xHRI18N}" /></option>
								<option value="salaryDept"><fmt:message
										key="hr.salary.dept.label" bundle='${v3xHRI18N}' /></option>
								<option value="salaryDate"><fmt:message
										key="hr.salary.search.mounth.label" bundle="${v3xHRI18N}" /></option>
								<option value="acceptPerson"><fmt:message
										key="hr.transfer.salarydata.transferreport.acceptPerson.label"
										bundle="${v3xHRI18N}" /></option>
								<option value="tansferTimestamp"><fmt:message
										key="hr.transfer.salarydata.transferreport.time.label"
										bundle="${v3xHRI18N}" /></option>
							</select>
						</div>
						<div id="tansferTimestampDiv" class="div-float hidden">
							<input type="text" name="tansferfromTime" id="tansferfromTime"
								class="textfield" onClick="selectDateTime(this,250,200);"
								readonly>-<input type="text" name="tansfertoTime"
								id="tansfertoTime" class="textfield"
								onClick="selectDateTime(this,250,200);" readonly>
						</div>
						<div id="acceptPersonDiv" class="div-float hidden">
							<input type="text" id="acceptPerson" name="acceptPerson"
								class="textfield" onKeyDown="onEnterPress2()" />
							<v3x:selectPeople id="dept" minSize="0" maxSize="1"
								panels="Department" selectType="Department"
								jsFunction="setTeamDept(elements)" />
						</div>

						<div id="staffNameDiv" class="div-float hidden">
							<input type="text" id="staffName" name="staffName"
								class="textfield" onKeyDown="onEnterPress2()">
						</div>
						<div id="salaryDateDiv" class="div-float hidden">
							<input type="text" class="textfield" id="fromTime"
								style="cursor: hand; width: 80px;" name="fromTime"
								onClick="selectDates('fromTime'); return false;" readonly
								value="">-<input type="text" class="textfield"
								id="toTime" style="cursor: hand; width: 80px;" name="toTime"
								onClick="selectDates('toTime'); return false;" readonly value="">
						</div>
						<div id="salaryDeptDiv" class="div-float hidden">
							<v3x:selectPeople id="salaryDept" panels="Department"
								selectType="Department"
								jsFunction="setSearchPeopleFields(elements)" maxSize="1" />
							<input type="text" name="salaryDeptName" id="salaryDeptName"
								class="textfield" readonly="true"
								onClick="selectPeopleFun_salaryDept()" />
							<input type="hidden" name="salaryDeptId" id="salaryDeptId" />
						</div>
						<div onClick="javascript:searchSalaryRecords()"
							class="condition-search-button"></div>
					</div>
				</form>
			</td>
		</tr>
	</table>
	<div class="scrollList" style="overflow:hidden;">
		<form id="salaryform" name="salaryform" action="" method="post">
		<v3x:table data="${websalaryTransferRecords}" var="sal"   leastSize="0" className="sort ellipsis" showHeader="true"  showPager="true" pageSize="20" htmlId="listBean" >						
			<v3x:column width="16%" type="String" label="hr.salary.name.label" 
					value="${sal.staffPerson}" className="cursor-hand sort" maxLength="15" symbol="..." alt="${sal.staffPerson}"
			></v3x:column>
			<c:set value="${v3x:showOrgEntitiesOfIds(sal.orgDepartmentId, 'Department', pageContext)}" var="deptName" />
			<v3x:column width="16%" type="String" label="hr.salary.dept.label" 
					value="${deptName}" className="cursor-hand sort" symbol="..." alt="${deptName}"
			></v3x:column>
			<v3x:column width="16%" type="String" label="hr.salary.mounth.label"
					value="${sal.yearMonth}" className="cursor-hand sort" symbol="..." alt="${sal.yearMonth}"
			></v3x:column>	
			<v3x:column width="17%" type="String"label="hr.transfer.salarydata.transferreport.creatorPerson.label" 
					value="${sal.creatorPerson}" className="cursor-hand sort" symbol="..." alt="${sal.creatorPerson}"
			></v3x:column>
			<v3x:column width="18%" type="String" label="hr.transfer.salarydata.transferreport.acceptPerson.label" 
					value="${sal.acceptPerson}" className="cursor-hand sort" symbol="..." alt="${sal.acceptPerson}"
			></v3x:column>
			<v3x:column width="18%" type="String" className="cursor-hand sort" label="hr.transfer.salarydata.transferreport.time.label"  >
			    <fmt:formatDate value="${sal.salaryTransferRecord.tansferTimestamp}" type="both" dateStyle="full" pattern="yyyy/MM/dd  HH:mm" />
			</v3x:column>
		</v3x:table>
		</form>
	</div>
	<script type="text/javascript">
		try {
			$(window).resize(function() {
					if ($("body").height() - 23 > 0) {
				       $(".scrollList").height($("body").height() - 28);
				       $("#bDivlistBean").height($(".scrollList").height()-33-26);
			   }
			});
			if ($("body").height() - 23 > 0) {
				$(".scrollList").height($("body").height() - 28);
				$("#bDivlistBean").height($(".scrollList").height()-33-26);
				setTimeout(function(){
				  $(".scrollList").height($("body").height() - 28);
				  $("#bDivlistBean").height($(".scrollList").height()-33-26);
				},100);
			}
			var staffName = "<v3x:out value='${param.staffName}' escapeJavaScript='true' />";
			var fromTime = '${param.fromTime}';
			var toTime = '${param.toTime}';
			var salaryDeptName = '${param.salaryDeptName}';
			var acceptPerson = "<v3x:out value='${param.acceptPerson}' escapeJavaScript='true' />";
			var tansforfromTime = '${param.tansferfromTime}';
			var tansfortoTime = '${param.tansfertoTime}';
			document.getElementById('staffName').value = staffName;
			document.getElementById('fromTime').value = fromTime;
			document.getElementById('toTime').value = toTime;
			document.getElementById('acceptPerson').value = acceptPerson;
			document.getElementById('tansferfromTime').value = tansforfromTime;
			document.getElementById('tansfertoTime').value = tansfortoTime;
			document.getElementById('salaryDeptName').value = salaryDeptName;
			showCondition(
					"${param.condition}",
					"<v3x:out value='${param.textfield}' escapeJavaScript='true' />",
					"<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
		} catch (e) {

		}
	</script>
</body>
</html>