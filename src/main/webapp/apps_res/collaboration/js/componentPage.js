
function _init_(){
  //正文加载
    document.getElementById("zwIframe").src = zwIframeSrc;

    _addOnloadEventToIframe();

    setOfficeHeight();

    $("#cc #mainbodyDiv").css("overflow",'visible');
    if(affairBodyType == '20'){
    	setTimeout(function(){
            try{
                if(zwIframe.window.getFlowDealOpinion().length>0){
                  parent.$("#isHidden").attr("disabled",true);
                }
            }catch(e){
            }
        },1000);


       $("#cc").css("width",'auto');
    }else if(affairBodyType=='41'
        || affairBodyType=='42'
        || affairBodyType=='43'
        || affairBodyType=='44'
        || affairBodyType=='45'){
         $("#cc").attr("style",'width:100%;margin-bottom:2px;');
         $(".content_text").css("padding-top",'0px').css("padding-left",'5px').css("padding-right",'0px').css("padding-bottom",'0px');
    } else if (affairBodyType=='10') {
        $("#cc").css("overflow",'hidden');
    }
    $(parent.window.document.getElementById("content_workFlow")).css("visibility","visible");

    setTimeout(function(){
        var _ccc = document.getElementById('cc');
        var _cccScrollWidth = parseInt(_ccc.scrollWidth);
        var _cccClientWidth = parseInt(_ccc.clientWidth);

        if(affairBodyType=='20'){
            var _htmlWidth = parseInt(document.documentElement.scrollWidth);
            var _bodyWidth = parseInt(document.body.clientWidth);
            if(_bodyWidth<_htmlWidth){
                _ccc.style.width = (_htmlWidth+35)+"px";
            }
        }else{
            if(_cccScrollWidth>_cccClientWidth){
                _ccc.style.width = (_cccScrollWidth+35)+"px";
                $('#display_content_view').width(_cccScrollWidth+35).css("margin","0 auto");
                $(".content_view").css("height","");
            }
        }
    },100);


    var _oldcss = $("#compontentHtml").css("overflow");
    //让转发的表单中的关联文档可以查看

    setTimeout(function(){
        try{
            var glwdClick = $(window.frames["zwIframe"].document).contents().find("a[onclick^='openDetailURL']");
            glwdClick.each(function(n){
                $(this).attr("onclick", $(glwdClick[n]).attr("onclick").replace(/openDetailURL/gm ,'parent.openDetailUR4ForwardForm'));
            });

            var glwdClick2 = $(window.frames["zwIframe"].document).contents().find("a[onclick^='openDetail']");
            glwdClick2.each(function(n){
                $(this).attr("onclick", $(glwdClick2[n]).attr("onclick").replace(/openDetail/gm ,'parent.openDetailUR4ForwardForm2'));
            });
        }catch(e){}
        //正文加载完毕的时候,关闭加载项
        var intervera = setInterval(function(){
        	if(window.parent.colseProce){
        		clearInterval(intervera);
                window.parent.colseProce();
            }
        });
    },700);

    //正文区域居中显示
    $(window).resize(function(){
        var nWindowWith = $(window).width() * 1;
        var objContentViewUl = $("#display_content_view");
        var objContent = $("#cc");
        if (objContent.width() * 1 <= nWindowWith) {
            objContentViewUl.width(nWindowWith);
        };
        if(isFromTransform == 'true'){
            //OA-71948  流程表单转发协同，已发或已办中查看转发后的协同正文，没有纵向滚动条，导致单据信息及处理意见查看不全。
            $("#compontentHtml").css("overflow","scroll");
        }
    });
}

var count  = 0 ;
function setOfficeHeight() {

    count ++ ;
    if($.browser.mozilla){
        return;
    }
    setTimeout(function(){
        try{
            var _docIframe = document.getElementById("zwIframe").contentWindow.document.getElementById("officeTransIframe");

            if(_docIframe != null){
                var docIframe = _docIframe.contentWindow.document.getElementById("htmlFrame");
                if ($(docIframe).size() > 0) {
                    //officeExecl,WpsExecl不做高度计算
                    if (affairBodyType!='42' && affairBodyType!='44')  {
                        var docIframeHeight = docIframe.document.body.clientHeight;
                        $("#cc").css("height",parseInt(docIframeHeight+50)+'px');
                    }
                    //Office转换后的正文，当宽度比外层的iframe宽的时候，设置外层iframe的宽度，避免出现滚动条
                    var docIframeWidth=docIframe.document.body.clientWidth;
                    var tableWidth=$("table",docIframe.document).width();
                    if(docIframeWidth<tableWidth){
                        $("#cc").css("width",parseInt(tableWidth+100)+'px');
                    }

                    //去掉纵向滚动条
                    var htmlIframeDoc = docIframe.contentWindow.document;
                    var htmlIframeHTML = htmlIframeDoc.documentElement;
                    var htmlIframeBody = htmlIframeDoc.body;

                    var htmlIframeHeight = Math.max( htmlIframeBody.scrollHeight, htmlIframeBody.offsetHeight,
                            htmlIframeHTML.clientHeight, htmlIframeHTML.scrollHeight, htmlIframeHTML.offsetHeight);
                    htmlIframeHeight = htmlIframeHeight * (100/99) * (100/98);
                    $("#zwIframe,#cc").css("height",htmlIframeHeight+'px');
                }
            }
        }catch(e){
            if(count < 20){
               setOfficeHeight();
            }
        }
    },300);
}

//为zwIframe添加加载完成事件
function _addOnloadEventToIframe(){
    var displayIframeEl = document.getElementById("zwIframe");
    if(displayIframeEl){
        if (displayIframeEl.attachEvent){
            displayIframeEl.attachEvent("onload", function(){
                _contentSetText();
            });
        } else {
            displayIframeEl.onload = function(){
                _contentSetText();
            };
        }
    }
}

function openDetailUR4ForwardForm(url){
	url = url.replace(/baseApp=2/,"baseApp=1");
	url = url.replace(/baseObjectId=(.\d+)&/,"baseObjectId="+parent.summaryId+"&");
	openDetailURL(url);
}

function openDetailUR4ForwardForm2(object,url){
	url = _ctxPath + "/collaboration/collaboration.do?method=summary&"+url;
	url = url.replace(/baseApp=2/,"baseApp=1");
	url = url.replace(/baseObjectId=(.\d+)&/,"baseObjectId="+parent.summaryId+"&");
	openDetailURL(url);
}



var officecanPrint =  parent.officecanPrint;
var canEdit = parent.canEdit;
var officecanSaveLocal = parent.officecanSaveLocal;
var formandrepealFlag = openFrom == 'repealRecord';
function _contentSetText(){
	var _formC = $("#formTextId").text();
	if(formandrepealFlag && _formC){
		document.zwIframe.$("#mainbodyHtmlDiv_0")[0].innerHTML=_formC;
	}

	setTimeout(function(){
        try{
            if(window.parent.contentAnchor != ""){
                $('html,body').animate({scrollTop: $("#"+window.parent.contentAnchor).offset().top}, 100);
                 //window.location.hash = "#"+window.parent.contentAnchor;
            }
        }catch(e){
        }
    },1000);


	try{
		if(document.zwIframe.$("#officeTransIframe").size() <= 0){
			parent.$("#viewOriginalContentA").hide();
		}
	}catch(e){

	}
	//更换了文单后重新绑定密级事件
	bindFormSecretLevelChanged();
}
function errorHandle(e){
	if(typeof disableOperation!="undefined"){
		disableOperation();
	}else if(typeof parent.disableOperation!="undefined"){
		parent.disableOperation();
	}
}
function bindFormSecretLevelChanged() {
	var formSecretLevelSelect;
	var arr = document.zwIframe.document.getElementsByTagName("select");
	if (arr && arr.length > 0) {
		for (var i = 0; i < arr.length; i++) {
			if ($(arr[i]).attr("mappingField") == "secret_level") {
				formSecretLevelSelect = arr[i];
				break;
			}
		}
		if (!formSecretLevelSelect) {
			return;
		}
		formSecretLevelSelect.onchange = function() {
			var newV = parent.document.getElementById("secretLevel").value;
			for (var i = 0; i < this.options.length; i++) {
				var opt = this.options[i];
				if (opt.selected == true || opt.selected == "selected") {
					newV = opt.getAttribute('val4cal');
					break;
				}
			}
			parent.document.getElementById("secretLevel").value = newV;
		}

	}
}