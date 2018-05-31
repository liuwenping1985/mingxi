/**
 * 对ajax请求进行封装, 设置Authorization值
 * 统一异常处理
 * @param $
 */
(function($) { 
	$.commons = {
		ajax : function(opts) {
			var parentBeforeSend = opts.beforeSend;
			opts.beforeSend = function(reqObj, settings){
				var urls = opts.url; //get请求url要加上参数
				var data = opts.data;
		        if(opts.type == "GET" && data){
		        	if(urls.indexOf('?') < 0){
		        		urls += "?";
		        	}else{
		        		urls += "&";
		        	}
		        	for(var key in data){
		        		urls += key + "=" + encodeURIComponent(data[key]).replace(/%20/g, "+" ) + "&";
		        	}
		        	urls = urls.substr(0, urls.length-1);
		        }
		    	var auths = $.getAuthHeader(window.location.host, urls, opts.type.toUpperCase());
				if(typeof auths !== "undefined"){
					reqObj.setRequestHeader('Authorization', auths);
				}
		    	var schoolCode = $.getCookie('school_code');
		    	reqObj.setRequestHeader('schoolCode', schoolCode);
		    	if(parentBeforeSend){
		    		parentBeforeSend(reqObj, settings);
		    	}
			};
			var parentError = opts.error;
			opts.error = function(XMLHttpRequest, textStatus, errorThrown) {
				switch (XMLHttpRequest.status){
					case 401:
						//未授权的情况下，跳转到登录页
						window.location.href = "/admin/login.html";
						break;
					default :
						if(parentError){
							parentError(XMLHttpRequest, textStatus, errorThrown);
						}else{
							if(XMLHttpRequest.responseText){
								var respJson = $.parseJSON(XMLHttpRequest.responseText);
								if($.messager){
									$.messager.alert("提示", respJson.code + ":" + respJson.message);
								}else{
									alert(respJson.code + ":" + respJson.message);
								}
							}
						}
						break;
				}
             }
			return $.ajax(opts);
		}
	}
})(jQuery);


