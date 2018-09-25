/**
 * 远程访问数据
 */
function RemoteDataService() {	
	this.remoteAjaxData = function (asyncParam, callbackOpt, params, managerName, bsMethod) {
		var callbackOption = null;
		var ajaxUrl = "";
		var result = null;
		if (callbackOpt != null && typeof (callbackOpt.success) != "undefined" && $.isFunction(callbackOpt.success)) {
			callbackOption = callbackOpt;
		}
		if (callbackOption != null && typeof (callbackOption) != "undefined" && callbackOption.success) {
			asyncParam = true;
			callbackOption = $.extend(new CallerResponder(), callbackOption);
		} else {
			asyncParam = false;
			callbackOption = new CallerResponder();
			callbackOption.success = function(resultObj) {
				if (typeof resultObj === 'string') {
					try {
						result = resultObj;
					}catch(e) {
						result = "data error!";
					}
				} else {
				  result = resultObj;
				}
			}
		}
		if (managerName != null && managerName.length > 0) {
			ajaxUrl = _ctxPath + "/ajax.do?method=ajaxAction&managerName=" + managerName;
		}
		var dataParams = new Object();
		dataParams.managerMethod = bsMethod;
		dataParams.arguments = $.toJSON(params);
		
		if (ajaxUrl.length == 0) {
			return result;
		}
		$.ajax({
			type : "POST",
			url : ajaxUrl + '&rnd=' + parseInt(Math.random()*100000),
			data : dataParams,
			dataType : "json",
			async : asyncParam,
			success : callbackOption.success,
			error : callbackOption.error,
			complete : callbackOption.complete
		});
		return result;
	}
}