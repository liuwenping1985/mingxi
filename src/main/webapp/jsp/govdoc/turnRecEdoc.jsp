<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="bg_color_white">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
	var summaryId = "${summaryId}";
	function selectUnit() {
		var par = new Object();
		par.value = $("#selectUnitId").val();
		par.text = $("#selectUnit").val();
		par.dan = "1";
		$.selectPeople({
            panels: 'Account,Department',
            selectType: 'Account,Department',
			hiddenPostOfDepartment : true,
			isNeedCheckLevelScope : false,
			showAllOuterDepartment : true,
			params : par,
			minSize : 0,
			callback : function(ret) {
				$("#selectUnitId").val(ret.value);
				$("#selectUnit").val(ret.text);
			}
		});
	}
	function OK(){
		var selectUnitId = $("#selectUnitId").val();
		if(selectUnitId == ""){
			return null;
		}
		var obj = new Object();
		obj.selectUnitId = selectUnitId;
		obj.opinion = $("#opinion").val();
		return obj;
	}
</script>
<style type="text/css">
	.sendUintList{padding:30px 20px 0}
	.sendUintList li{ margin-bottom:20px}
	.sendUintList li span{ font-size: 12px}
	.sendUintList .handOptions{ vertical-align:top}
	.sendUintList li textarea{ width: 270px; height: 200px;}
</style>
</head>
<body>
	<ul class="sendUintList">
		<li>
			<span>送往单位:</span>
			<input type="text" name="selectUnit" id="selectUnit" onClick="selectUnit();" style="width:270px"> 
			<input type="hidden" name="selectUnitId" id="selectUnitId"></li>
		<li>
			<span class="handOptions">办理意见:</span>
			<textarea id="opinion"></textarea>
		</li>
	</ul>
</body>
</html>