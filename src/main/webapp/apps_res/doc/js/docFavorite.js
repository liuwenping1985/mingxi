
/*************************************** 收藏 ******************************************************
 * appName:应用 枚举key; 
 * id:要归档的源数据id；附件的url
 * hasAtts:是否含有附件
 * type：收藏类型，正文收藏：3（默认）  附件收藏：4
 */
var  dialog;

function favorite_old(appName, id, hasAtts,type,index,reLoad,isCloseBtnHide){
	var targetWindow = getA8Top();
	if (getA8Top().isGeniusTopWindow) {
		targetWindow = window;
	}
	
	targetWindow.dialog = new MxtWindow({
		   id:"docFavoriteDialog",
	       url: v3x.baseURL+"/doc/knowledgeController.do?method=toFavorite&sourceId="+id+"&isReload="+reLoad+"&appName=" + appName + "&hasAtts=" + hasAtts + "&favoriteType="+type+"&flag=old&t="+new Date(),
	       targetWindow: targetWindow,
	       width: 380,
	       height:480,
	       closeHidden:isCloseBtnHide,
	       title: v3x.getMessage('DocLang.doc_favorite')
	   });
	  var docFavoriteDialog = document.getElementById('docFavoriteDialog');
	  if(docFavoriteDialog){
	  	docFavoriteDialog.style.height = "100px";
	  }
	  //切换收藏,取消收藏
	  if(!isCloseBtnHide){
	      favoriteTip(true,id,index,_("V3XLang.doc_cancel_favorite_success")); 
	  }
}

/**
 * 收藏的tip
 */
function favoriteTip(isFavorite,id,index,msg,offsetTop){
    if(typeof(id)=== 'undefined' ){
        id='';
    }
    
    if(typeof(index)!== 'undefined'){
         id = String(id) + String(index);
    }
    
    if(!msg){
        msg = $.i18n('doc.cancel.collect.success.js');
    }
    
    if(typeof(offsetTop)=== 'undefined'){
        offsetTop = -30;
    }
    
    if(isFavorite){
        $("#favoriteSpan"+id).hide();
        $("#cancelFavorite"+id).show();
        //替换下拉菜单的图标和文字显示
        try{
        	$("#_favId")[0].innerHTML = $("#_favId")[0].innerHTML.replace("unstore_16","stored_16");
        	$("#_favId")[0].innerHTML = $("#_favId")[0].innerHTML.replace($.i18n('collaboration.summary.favorite'),$.i18n('collaboration.summary.favorite.cancel'));
        }catch(e){}
    }else{
    	try{
    		new MxtTip({
                targetId: "cancelFavorite"+ id,
                content:msg,
                offsetTop:offsetTop,
                targetWindow:getA8Top(),
                beforeShowCallBack:function(){
                    $("#favoriteSpan"+id).show();
                    $("#cancelFavorite"+id).hide();
                    $("#cancelFavorite"+id).removeAttr("disabled");
                }
            });
    	}catch(e){
    		$("#_favId")[0].innerHTML = $("#_favId")[0].innerHTML.replace("stored_16","unstore_16");
        	$("#_favId")[0].innerHTML = $("#_favId")[0].innerHTML.replace($.i18n('collaboration.summary.favorite.cancel'),$.i18n('collaboration.summary.favorite'));
    	}
        
    }
    return;
}

/**
 * 取消收藏
 * @param {app:,id:,hasAtts:,type:}
 * @param {hasCount:,hasIcon:,has}
 */
function cancelFavorite_old(appName, sourceId, hasAtts, type,index,reLoad,offsetTop,isCloseBtnHide) {
        var requestCaller = new XMLHttpRequestCaller(this, "knowledgeFavoriteManager", "favoriteCancel", false);
        requestCaller.addParameter(1, "Long", -1);
        requestCaller.addParameter(2, "Long", sourceId);
        var flag = requestCaller.serviceRequest();
        if(!isCloseBtnHide){
            favoriteTip(false,sourceId,index,_("V3XLang.doc_cancel_favorite_success"),offsetTop); 
        }
        
        if(reLoad){
            window.location.reload(true);
        }
        return flag;
}


/*************************************推荐 ************************
 * 
 * @param id 推荐的文档ID
 * @param hasEnable 是否允许推荐
 */
function doc_recommend(id,hasEnable){
	if(hasEnable==0||hasEnable==='false'||!hasEnable){
		$.alert($.i18n('doc.alert.disable.recommend'));
		return;
	}
  var dialog = $.dialog({
    id:"docRecommendDialog",
    url: _ctxPath+"/doc/knowledgeController.do?method=toRecommend&sourceId="+id+"&t="+new Date(),
    isClear:false,
    width: 380,
    height:220,
    targetWindow : getA8Top(),
    title: $.i18n('doc.log.document.recommend')
  });
	var main = getA8Top().frames['main'];
	if (!main) {
		main = getA8Top();
	}
	main._dialog = dialog;
}

function doc_recommend_old(id,hasEnable){
	if(hasEnable==0){
		alert(v3x.getMessage('DocLang.doc_alert_disable_recommend'));
		return;
	}
  var dialog = new MxtWindow({
    url: v3x.baseURL+"/doc/knowledgeController.do?method=toRecommend&sourceId="+id+"&t="+new Date(),
    width: 380,
    height:270,
    targetWindow : getA8Top(),
    title: v3x.getMessage('DocLang.doc_title_recommend')
  });
  var main = getA8Top().frames['main'];
	if (!main) {
		main = getA8Top();
	}
	main._dialog = dialog;
}


function openToSquare_old(docId,isFolder) {
    // 3个人借阅，2，个人共享
    var shareType = isFolder == 'false'? 3:2;

	var requestCaller = new XMLHttpRequestCaller(this, "knowledgePageManager", "openDocToSquare", false);
    requestCaller.addParameter(1, "Long", docId);
    requestCaller.addParameter(2, "String",  shareType);
    var hasOP = requestCaller.serviceRequest();
    if(hasOP === 'true') {
    	getA8Top().$.messageBox({
    		type : 0,
    		imgType : 0,
    		width : 380,
    	    height : 80,
    		title: getA8Top().$.i18n('doc.jsp.knowledge.opentosquare.title'),
    		msg : v3x.getMessage('DocLang.doc_alert_public'),
    		ok_fn : function() {
    			window.location.reload(true);
    		}
    	});
    }else{
    	getA8Top().$.confirm({
    		title : getA8Top().$.i18n('doc.jsp.knowledge.opentosquare.title'),
    	    msg : v3x.getMessage('DocLang.doc_confirm_cancel'),
            width : 380,
            height : 80,
    	    ok_fn: function () { 
    	    	var requestCaller = new XMLHttpRequestCaller(this, "knowledgePageManager", "updateCancelPublic", false);
        	    requestCaller.addParameter(1, "Long", docId);
        	    var hasOP = requestCaller.serviceRequest();       	    
    			if(hasOP == "true") {
    				getA8Top().$.messageBox({
                		type : 0,
                		imgType : 0,
                		width : 380,
                	    height : 80,
                		title: getA8Top().$.i18n('doc.jsp.knowledge.opentosquare.title'),
                		msg : v3x.getMessage('DocLang.doc_cancel_success'),
                		ok_fn : function() {
                			window.location.reload(true);
                		}
                	});
    			}
    		}
    	});

    }
}