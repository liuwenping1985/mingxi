

function showFullWin(){
  if(parent.myFrame.rows=="0%,*"){
     parent.myFrame.rows="255,*";
  }else{
    parent.myFrame.rows="0%,*";
  }
  
}

	function _checkSearch(){
		var frmObj = document.forms("searchForm");
		if(frmObj.all("fieldName").value==""){
		  frmObj.all("fieldValue").value="";	
		  
		}else{
		  if(frmObj.all("fieldValue").value==""){
		    alert($.i18n('office.select.cond.js'));
		    frmObj.all("fieldValue").focus();
		    return;
		  }
		}
		frmObj.submit();
   
	}
	
	
	function _cancelOper(){
		var frmObj = document.forms[0];
		
			frmObj.reset();
			  window.parent.location.reload();
	}
	
	
		    
     function isCheckAudit(id){
	    try {
		 	var requestCaller = new XMLHttpRequestCaller(this, "ajaxOfficeCommonManager", "selectOfficeAudit", false);
			requestCaller.addParameter(1, "String", id);
			var ds = requestCaller.serviceRequest();
	    	if(ds > 0){
	    		return 1;
	    	}else{
	    		return 0;
	    	}
	    }
	    catch (ex1) {
			alert("Exception : " + ex1);
	    }
	    }