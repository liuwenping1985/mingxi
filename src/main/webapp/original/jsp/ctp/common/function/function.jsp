<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title></title>

<script type="text/javascript">
var descinfo = new Properties();
var retinfo;
$(document).ready(function(){
	$("#functionmod").text($.i18n('functionmod.title.Explain'));
	$('#functioninfo').click(function(){

		var items = document.getElementById("functioninfo");
		
		if (items != null && items.length > 0) {
			for (var i = 0; i < items.length; i++) {
				var item = items[i];
				if (item.selected) {
					selectedIndex = item.index;
					settitle(item.value);
					setlable(item.value);
					setret(item.value+'()');
				}
			}
		}
	});
	});

	
	function setret(value){
		retinfo= value;
	}
	function OK(){
		return retinfo;
	}
	function onOk(){
		return retinfo;
	}

	function settitle(value) {
		$("#titleinfo").text(value);
	}

	function setlable(key) {
		$("#labelinfo").text(descinfo.get(key));
	}

	<!--
//-->
</script>
</head>
<body>
	<c:forEach items="${functions}" var="func">
		<script>
			descinfo.put('${func.methodName}', '${ctp:i18n(func.description)}');
		</script>
	</c:forEach>

	<select id="functioninfo" name="functioninfo"
		style="width: 95%; height: 120px; padding: 5px;margin:10px"
		 value="functioninfo" multiple="multiple">
		<c:forEach items="${functions}" var="func">
			<option value='${func.methodName}'>${ctp:i18n(func.title)}</option>
		</c:forEach>
	</select>
<div class="scrollList" >
<table style="border:0;cellspacing:0;cellpadding:0;width: 98%;padding: 5px;margin:4px;">
<tr>
<td>
<fieldset style="height: 200px;">
<legend id="functionmod" ></legend>
	<span id="titleinfo" class="margin_r_5 left"
		style="font-weight: bold; padding: 8px; width: 100%; color: #000; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">

	</span>

	<div style="height: 32px; padding: 8px">
		<label class="margin_r_5" id="labelinfo" for="text"> </label>
	</div>
	</fieldset>
	</td>
	</tr>
	</table>
	</div>
</body>
</html>