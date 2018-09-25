try {
    getA8Top().endProc();
}
catch(e) {
}
/**
 * 得到选中的id串
 */
 function getSelectedIds(){
	var chkid = document.getElementsByName('id');
	var ids = "";
	for(var i = 0; i < chkid.length; i++){
		if(chkid[i].checked){
			ids += "," + chkid[i].value;
		}
	}
	
	if(ids != "")
		ids = ids.substring(1, ids.length);
	return ids;    
}
function thirdPMenuSend(url){
	var rowid = getSelectedIds();
	if(rowid == ""){
		alert(v3x.getMessage('DocLang.doc_alert_select_item'));
		return false;
	}
	var formObj = document.getElementById("thirdMenuForm") ;
	if(!formObj){
		var frm = document.createElement('form');
		frm.id = 'thirdMenuForm' ;
		frm.name = 'thirdMenuForm';
		frm.action = url;
		var input = document.createElement('input');
		input.id = 'thirdMenuIds';
		input.name = 'thirdMenuIds';
		input.type = 'hidden';
		frm.appendChild(input);
		document.body.appendChild(frm);
	}
	if(!document.getElementById('emptyIframe')){
	    var iframe; 
	    try{ 
	    	// ie
	        iframe = document.createElement('<iframe name="emptyIframe">'); 
	    }catch(e){ 
	        iframe = document.createElement('iframe'); 
	    } 
		iframe.id = 'emptyIframe';
		iframe.name = 'emptyIframe';
		iframe.setAttribute('frameborder','0',0);
		iframe.height='0'; 
		iframe.width='0'; 
		iframe.scrolling='no'; 
		iframe.marginheight='0'; 
		iframe.marginwidth='0';
		document.body.appendChild(iframe);			
	}	
	formObj = document.getElementById("thirdMenuForm") 

	var thirdMenuIdsObj = document.getElementById("thirdMenuIds") ;
	if(thirdMenuIdsObj){
		thirdMenuIdsObj.value = rowid ;
	}
	if(formObj) {
		formObj.action = url ;
		formObj.target = 'emptyIframe' ;
		formObj.submit() ;
	}
}

