var layout = null;
var proce = null;

$(document).ready(function () {
	//正文加载
	proce = $.progressBar();
  
	/* 初始化样式相关 */
	initStyle();
	
});

 function initStyle() {
	//页面加载 样式初始化
    layout = new MxtLayout({
        'id': 'layout',
        'centerArea': {
            'id': 'center',
            'border': true,
            'minHeight': 20
        }
    });
	
	if ($.browser.msie) {
		 if ($.browser.version < 8) {
		    $( "#iframe_content" ).css("height" , $(".stadic_layout_body" ).height());
		 }
		 if($.browser.version < 8) {
			 setIframeHeight_IE7();
			 $(window).resize(function(){
				 setIframeHeight_IE7();
			 });
		 }
	}
	 
	$("#content_workFlow").css("overflow","auto");
	
	initOfficeStyle();
	
	summaryHeadHeight();

 }

function loadClick() {
	
	//右侧 半屏展开
	$( "#deal_area_show").click( function () {
	    $( ".deal_area #hidden_side").trigger( "click" );
	});

	//右侧  收缩	
	$( ".deal_area #hidden_side").click(function() {
	    if ($( "#east" ).outerWidth() == 350) {
	          layout.setEast(38);
	          $( ".deal_area" ).hide();
	          $( "#deal_area_show" ).show();
	      } else {
	          layout.setEast(348);
	          $( ".deal_area" ).show();
	          $( "#deal_area_show" ).hide();
	      }
	});
	
	loadDealClick();
}

function doAudit(action){
	 var url =_ctxPath+"/info/magazine.do?method=doAudit&action="+action+"&useLocalFile="+useLocalFile;
	 /*var domains =[];
  	 domains.push("dealAreaThisRihgt");
  	 domains.push("comment_deal");
  	 //domains.push("content_workFlow");
  	 domains.push("_currentDiv");
  	 $("#center").jsonSubmit({
         domains : domains,
         action:url,
         debug : false,
         callback: function(data){
        	 closeCollDealPage("listMagazineAuditPending");
           }
     });*/
  	$.content.getContentDomains(function(domains) {
  		domains.push("comment_deal");
  		domains.push("dealAreaThisRihgt");
		var jsonSubmitCallBack = function() {
            setTimeout(function() {
            	$("#layout").jsonSubmit({
                    domains : domains,
                    debug : false,
                    action:url,
                    callback: function(data){
                    	closeInfoDealPage("listMagazineAuditPending");
		           	}
                });
			},300);
        }
		jsonSubmitCallBack();
	},'saveAs',null,function(){});
}

//将标题部分高度改为动态值
function summaryHeadHeight(){
	$("#content_workFlow").css("top", $("#summaryHead").height()+10);
}

function closeCollDealPage(listType){
	  var fromDialog = true;
	  var dialogTemp= null;
	  try{
	    dialogTemp=window.parentDialogObj['dialogDealColl'];
	  }catch(e){
	    fromDialog = false;
	  }
	  try{
	      window.parent.$('.slideDownBtn').trigger('click');
	      window.parent.$('#listPending').ajaxgridLoad();
	      try{window.parent.$('#listStatistic').ajaxgridLoad();}catch(e){}
	    
	  }catch(e){// 弹出对话框模式
	      try{
	          if(window.dialogArguments){
	              window.dialogArguments[0].attr('src','');
	              window.dialogArguments[1].trigger('click');
	              var obj=new Object();
	              obj.listType=listType;
	              window.dialogArguments[2].ajaxgridLoad(obj);
	          }
	        
	      }catch(e){}
	  }
	 
	  // 首页更多
	  try{
	    if(window.dialogArguments){
	        if(typeof(window.dialogArguments.callbackOfPendingSection) == 'function'){
	          var iframeSectionId=window.dialogArguments.iframeSectionId;
	            var selectChartId=window.dialogArguments.selectChartId;
	            var dataNameTemp=window.dialogArguments.dataNameTemp;
	            window.dialogArguments.callbackOfPendingSection(iframeSectionId,selectChartId,dataNameTemp);
	            return;
	        }
	        if(typeof(window.dialogArguments.callbackOfEvent) == 'function'){
	          window.dialogArguments.callbackOfEvent();
	          // 协同V5.0 OA-45058 时间线上点击待办协同进行处理，点击提交按钮后，协同页面一直不消失
	          if(dialogTemp!=null&&typeof(dialogTemp)!='undefined'){
	              dialogTemp.close();
	          }
	          return;
	        }
	    }
	  }catch(e){
	  }
	  try{
	      if(dialogTemp!=null && typeof(dialogTemp)!='undefined'){
	          if (getCtpTop().main.sectionHandler != undefined){
	              getCtpTop().main.sectionHandler.reload("pendingSection",true);
	          }
	          dialogTemp.close();
	      }
	  }catch(e){}
	  // 不是dialog方式打开的都用window.close
	  if(!fromDialog){
	    // 刷新首页待办栏目
	      try{
	          if(getA8Top().dialogArguments){
	          getA8Top().dialogArguments.main.sectionHandler.reload("pendingSection",true);
	          }else{
	            getA8Top().opener.main.sectionHandler.reload("pendingSection",true);
	          }
	      }catch(e){}
	      window.close();
	  }
}


function initOfficeStyle() {
	 
	 $("#cc #mainbodyDiv").css("overflow",'visible');
    $("#cc").attr("style",'height:500px;width:100%;margin-bottom:2px;');
	 $(".content_text").css("padding-top",'0px').css("padding-left",'5px').css("padding-right",'0px').css("padding-bottom",'0px');
	 $(parent.window.document.getElementById("content_workFlow")).css("visibility","visible");
	 $("#replyContent_sender").hide();
	 $("#currentComment").find("span.li_title").html($.i18n('infosend.label.opinion.handleOpinion', commentCount));//html(处理人意见（共+commentCount+条）);
	 
	function setOfficeHeight() {
		setTimeout(function(){ 
			try{
				var docIframe = document.frames["officeTransIframe"].document.frames["htmlFrame"];
				if ($(docIframe).size() > 0) {
					var docIframeHeight = docIframe.document.body.clientHeight;
					$("#cc").css("height",parseInt(docIframeHeight+50)+'px');
					
					//Office转换后的正文，当宽度比外层的iframe宽的时候，设置外层iframe的宽度，避免出现滚动条
		            var docIframeWidth=docIframe.document.body.clientWidth;
		            var tableWidth=$("table",docIframe.document).width();
		 			if(docIframeWidth<tableWidth){
		 				$("#cc").css("width",parseInt(tableWidth+100)+'px');
		 			}
				}
			}catch(e){
				setOfficeHeight(); 
			}
		}, 300);
	}
	setOfficeHeight();
	//正文加载完毕的时候,关闭加载项
	closeProce();
}

function closeProce(){
	  if (proce==""){
	      setTimeout(colseProce,300);
	  }else{
	      proce.close();
	  }
}

function setIframeHeight_IE7(){
    setTimeout(function(){
            $("#content_workFlow").height($("#center").height()-$("#summaryHead").height()-10);
            $("#iframeright").height($("#content_workFlow").height());
            $("#componentDiv").height($("#content_workFlow").height());
    },0);
}