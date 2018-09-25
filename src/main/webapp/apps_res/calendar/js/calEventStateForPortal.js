function OK() {
		var fValidate = $("#stateInitDate").validate();
		//chrome浏览器不刷新portal的问题,需要设ajax为true
		  isChrome = window.navigator.userAgent.indexOf("Chrome")!==-1;
		if (fValidate) {
			$("#stateInitDate").jsonSubmit({
				ajax:isChrome
			});
		}
		return fValidate;
	}

function statesChoice(conditionObject) {
		if (conditionObject.value == 4) {
			$("#completeRate").val(100);
			$("#completeRate").attr("disabled", "true");
		} else {
			$("#completeRate").removeAttr("disabled");
		}
}