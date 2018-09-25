try {
    getA8Top().endProc();
}
catch(e) {
}
//��������
function newArticle() {
//	alert(newActionURL);
	parent.location.href = newActionURL;
}	
//ɾ�����
function deleteRecord(baseUrl){
	var ids=document.getElementsByName('id');
	var id='';
	for(var i=0;i<ids.length;i++){
		var idCheckBox=ids[i];
		if(idCheckBox.checked){
			id=id+idCheckBox.value+',';
		}
	}
	if(id==''){
		alert(alertDelete);
		//alert(v3x.getMessage(alertDelete));
		return;
	}
	if(confirm(deleteConfirm))
		window.location.href=baseUrl+'&id='+id;
}
	
//ɾ������
function deleteArticle( actionURL ) {

    var theForm = document.getElementsByName("listForm")[0];
	
    if (!theForm) {
        return false;
    }

    var id_checkbox = document.getElementsByName("id");
	
    if (!id_checkbox) {
        return true;
    }

    var hasMoreElement = false;
    var len = id_checkbox.length;
    for (var i = 0; i < len; i++) {
        if (id_checkbox[i].checked) {
            hasMoreElement = true;
            break;
        }
    }

    if (!hasMoreElement) {
        alert(alertDeleteItem);
        return true;
    }

    if (window.confirm(deleteArticleConfirm)) {

		theForm.action = actionURL;
      
        theForm.target = "_self";
          theForm.submit();

		//alert(theForm.action);
    
       // return true;
    }
}


function test() {

   var theForm = document.getElementsByName("listForm")[0];
    if (!theForm) {
        return false;
    }


    var id_checkbox = document.getElementsByName("id");
	//alert(id_checkbox.length);
    if (!id_checkbox) {
        return true;
    }
    var famId = document.getElementsByName("familyId");
	alert(famId.length);
    var hasMoreElement = false;
    var len = id_checkbox.length;
    for (var i = 0; i < len; i++) {
        if (id_checkbox[i].checked) {
            hasMoreElement = true;
            break;
        }
    }

    if (!hasMoreElement) {
        alert(alertDeleteItem);
        return true;
    }

   
	  theForm.action = actionURL + "method=modifyFavoritesArticle";
       //theForm.target = "_self";
		//alert(theForm.action);
    	theForm.submit();
	
		
     //return true;
  
}
function modtifyArticleModel( actionURL ) {
	 var theForm = document.getElementsByName("listForm")[0];
    if (!theForm) {
        return false;
    }


    var id_checkbox = document.getElementsByName("id");
	
    if (!id_checkbox) {
        return true;
    }
    document.getElementById("familyId").value=document.getElementById("familyList").value;
	//alert(famId.length);
    var hasMoreElement = false;
    var len = id_checkbox.length;
    for (var i = 0; i < len; i++) {
        if (id_checkbox[i].checked) {
            hasMoreElement = true;
            break;
        }
    }

    if (!hasMoreElement) {
		alert(v3x.getMessage("BlogLang.blog_modify_select_alert"));
        window.location.reload(true);
        return true;
    }

      var sel = document.getElementById("familyList");
	     document.getElementById("familyId").value = sel.value;
		var vol = document.getElementById("familyId");
  if (document.getElementById("familyId").value == "")
	  {
		alert(v3x.getMessage("BlogLang.blog_modify_group_item_alert"));
		  return;
	  }
    // document.getElementById("familyId").value = sel.value;
     
	  theForm.action = actionURL;
       theForm.target = "_self";
	//	alert(theForm.action);
    	theForm.submit();
}

/**
 * 验证博客分类的名称有效性
 * 
 * */
  function validFamilyName(name, dataId, memberId){		
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxBlogArticleManager", "nameValid", false);
		requestCaller.addParameter(1, "String", name);
		requestCaller.addParameter(2, "long", dataId);
		requestCaller.addParameter(3, "long", memberId);
		var ds = requestCaller.serviceRequest();
		return ds;		
	}