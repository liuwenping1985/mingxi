function  fnTabToggle(_this){
	var tgt = $(_this).attr("tgt");
	var src = $("#" + tgt).attr("src");
	$("#" + tgt).attr("src", src);
}

/**
 * 解决第一个页签，在IE8下不刷新问题
 */
function fnTabsReLoad4IE8() {
	$(window).load(function() {
		if ($.browser.msie && (parseInt($.browser.version, 10) < 9)) {
			var currentIframe = $(".current a").attr("tgt");
			$("#" + currentIframe).attr("src", $("#" + currentIframe).attr("src"));
		}
	});
}