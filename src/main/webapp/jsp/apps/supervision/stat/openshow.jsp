<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=supervisionStatManager"></script>
<script type="text/javascript">
	$(document).ready(function() {
		var tjData = new Array();
		var names = $("#names").val();
		var displays = $("#displays").val();
		names = names.split(",");
		displays = displays.split(",");
		for ( var i = 0; i < names.length; i++) {
			tj = new Object();
			tj.name = names[i];
			tj.width = getTHWidthTable(names.length - 1);
			tj.display = displays[i];
			if (tj.name == "id") {
				tj.hide = true;//默认显示与否,
			}
			tjData[tjData.length] = tj;
		}
		var type = '${type}';
		var params = {};
		if (type == '2') {
			params = {
				departmentValue : '${departmentValue}',
				mbly : '${mbly}',
				sxzt : '${sxzt}',
				sxzt_over : '${sxzt_over}',
				accountId : '${accountId}',
				mainTableName : '${mainTableName}',
				tjfw : ${tjfw},
				blxz : '${blxz}',
				fromdate:'${fromDate}',
				todate:'${toDate}'
			};
		} else if (type == '4') {
			params = {
					departmentValue : '${departmentValue}',
					accountId : '${accountId}',
					mainTableName : '${mainTableName}',
					sonTableName : '${sonTableName}',
					tjfw : ${tjfw},
					blxz : '${blxz}',
					sxzt : '${sxzt}',
					sxzt_over : '${sxzt_over}',
					fromdate:'${fromDate}',
					todate:'${toDate}',
					level:'${level}'
				};
		}
		var ss = $("#mytjtable").ajaxgrid({
			click : openforminfo,
			dblclick : openforminfo,
			render : render,
			colModel : tjData,
			isHaveIframe : true,
			sortname : "id",
			sortorder : "asc",
			usepager : true,
			managerName : "supervisionStatManager",
			managerMethod : "${method}",
			showTableToggleBtn : false,
			parentId : $('.layout_center').eq(0).attr('id'),
			vChange : true,
			vChangeParam : {
				overflow : "hidden",
				autoResize : true
			},
			slideToggleBtn : false,
			params : params
		});
	});

	function getTHWidthTable(thCount) {
		if (thCount >= 10) {
			return "10%";
		}
		return (100 / thCount) + "%";
	}
	function render(text, row, rowIndex, colIndex, col) {
		return text
	}
	function openforminfo(data, r, c) {
		var url = _ctxPath
		+ "/supervision/supervisionController.do?method=formIndex&masterDataId="
		+ data.id + "&isFullPage=true&moduleId="
		+ data.id + "&moduleType=37&viewState=2";
		getCtpTop().openCtpWindow({"url":url});
		/* $('#checkForm')
				.attr(
						"src",
						_ctxPath
								+ "/supervision/supervisionController.do?method=formIndex&masterDataId="
								+ data.id + "&isFullPage=true&moduleId="
								+ data.id + "&moduleType=37&viewState=2"); */
	}
</script>
</head>
<body>
	<input type="hidden" value="${countSize }" id="countSize">
	<input type="hidden" id="names" name="names" value="${names}">
	<input type="hidden" id="displays" name="displays" value="${displays}">
	<div id='layout' class="comp page_color" comp="type:'layout'">
		<div class="layout_center page_color over_hidden"
			layout="border:false">
			<table id="mytjtable" class="flexme3" style="display: none;">
			</table>
			<!-- <div id="grid_detail">
				<iframe src="" id="checkForm" width="100%" height="100%"
					frameborder="0"></iframe>
			</div> -->
		</div>
	</div>
</body>
</html>
