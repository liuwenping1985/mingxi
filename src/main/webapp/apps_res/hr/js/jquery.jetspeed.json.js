function getJetspeedJSON(options) {
	var settings = {
        url:  window.location,
  		params: {ajax:'true'}
	};
	if(options) { // check if options are present before extending the settings
		$.extend(settings, options);
	}
	
	//add ajaxParams
	var ajaxParams = settings.params;
	ajaxParams['ajax'] = 'true';
	
	
	var callback = settings.success;
    
    settings.success = function(data) {
    	var json = returnJSON(data);
        callback(json);
    };
    
    function returnJSON(response) {
    	try {
    		if (response != '' && response.indexOf("[{") != -1 && response.lastIndexOf("}]") != -1) {
           		var data = response.substring(response.indexOf("[{"), response.lastIndexOf("}]")+2);
            	return eval(data);    		
    		}
    	} catch(e) {
    		alert("Error in JSON response:"+e);
    	}
    	return [];   
    } 
    
    function sendJSON() {
    	$.post(settings.url, ajaxParams, settings.success);
    }   
	sendJSON();
}

