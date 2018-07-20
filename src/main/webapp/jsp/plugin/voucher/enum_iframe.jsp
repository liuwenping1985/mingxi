<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>EnumIframe</title>
<script type="text/javascript">
	function OK() {
		var target = $($(".current")[0]).find("a").attr("tgt");
		var doc= document.getElementById(target).contentWindow.document;
		var table = doc.getElementById("mytable");
	    var boxs = $(table).find("input:checked");
		if (boxs.length != 1) {
		    $.alert("${ctp:i18n('voucher.plugin.cfg.chose.please')}");
		    return false;
		}
		var parent = $(boxs[0]).parent().parent("td");
		var div = parent.next("td").find("div");
		return {"enumId":boxs[0].value,"enumName":div.html()};
	}
</script>
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
        <div id="tabs" style="height: 100%"  class="comp"
		comp="type:'tab',parentId:'tabs'">
		<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left">
				<li class="current"><a hidefocus="true"
					href="javascript:void(0)" tgt="tab1_iframe"><span>${ctp:i18n("metadata.manager.public")}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab2_iframe"><span>${ctp:i18n("metadata.manager.account")}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab3_iframe"><span>${ctp:i18n("metadata.unitImageEnum.tab.label")}</span></a></li>
			</ul>
		</div>
		<div id="tabs_body" class="common_tabs_body" style="height: 100%;">
			<iframe id="tab1_iframe" width="100%" height="100%" src="${path}/voucher/subjectMapperController.do?method=selectEnum&enumType=2" frameborder="no"
				border="0"></iframe>
			<iframe id="tab2_iframe" width="100%" height="100%" src="${path}/voucher/subjectMapperController.do?method=selectEnum&enumType=3" frameborder="no"
				border="0"></iframe>
			<iframe id="tab3_iframe" width="100%" height="100%" src="${path}/voucher/subjectMapperController.do?method=selectEnum&enumType=5" frameborder="no"
				border="0"></iframe>
		</div>
    </div>
	</div>
</body>
</html>