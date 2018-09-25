var nodeId='';


function searchTemplate(){
    var url = _ctxPath+"/template/template.do?method=templateChoose";
    if(templateChoose === "true"){
      url += "&templateChoose=true";
    }
    if(templateChoose === "false"){
        url += "&templateChoose=false";
      }
	if($("#searchType").val() =='0'){
		window.location.href = url + "&category=" + category + "&accountId=" + accountId;
	// 模板名称去查询
	}else if($("#searchType").val()=="1"){
		var sName = $("#templateName").val();
		window.location.href = url + "&category=" + category + "&accountId=" + accountId +
		         "&sName=" + encodeURIComponent(sName) + "&searchType=" + $("#searchType").val();
	}else if($("#searchType").val() =="2"){
		var smtype = $("#templateTypes").val();
		window.location.href = url + "&category=" + category + "&accountId=" + accountId +
        "&smtype="+smtype+"&searchType="+$("#searchType").val();
	}
  }

function doSerch(obj){
	if(obj.value=='0'){
		$("#templateName").hide();
		$("#templateTypes").hide();
	}
	if(obj.value=='1'){
		$("#templateName").show();
		$("#templateTypes").hide();
		$("#searchSpan").show();
	}
	if(obj.value=='2'){
		$("#templateName").hide();
		$("#templateTypes").show();
		$("#searchSpan").show();
	}
  }

  function tranCharacter(str){
		if(!str){
			return "";
		}
		if(str.indexOf('"') >-1){
			str = str.replace(/"/g,'&quot;');
		}
		if(str.indexOf('<') >-1){
			str= str.replace(/</g,'&lt;');
		}
		if(str.indexOf('>') >-1){
			str= str.replace(/>/g,'&gt;');
		}
		return str;
	}
  
  
  
  function showHelp() {
	    var nodes = $("#tree").treeObj().getSelectedNodes();
	    if (nodes.length <= 0) {
	      return;
	    }
	    var templateId = "";
	    if (nodes) {
	      templateId = nodes[0].data.id;
	    }
	    if (nodes[0].data.type == "category"
	        || nodes[0].data.type == "template_coll"
	        || nodes[0].data.type == "text_coll"
	        || nodes[0].data.type == "workflow_coll"
	        || nodes[0].data.type == "personal"
	        || nodes[0].data.type =='edoc_coll') {
	      return;
	    }
	    $(".left>li").removeClass("current");
	    $("#workFlowDescBut").addClass("current");
	    var url = _ctxPath+'/template/template.do?method=getDes&templateId='+ templateId + '&moduleType=4';
	    $("#displayIframe").attr('src', url);
	  }
	  function checkTemType() {
	    var nodes = $("#tree").treeObj().getSelectedNodes();
	    if (nodes.length < 0) {
	      return;
	    }
	    var templateId = "";
	    if (nodes) {
	      templateType = nodes[0].data.type;
	      if (templateType == "text") {
	        $("#contentBut").removeAttr("style");
	        $("#contentBut a").addClass("last_tab");
	        $("#workFlowBut").attr("style", "display:none");
	        $("#workFlowDescBut").attr("style", "display:none");
	      } else if (templateType == "workflow") {
	        $("#workFlowBut").removeAttr("style");
	        $("#workFlowDescBut").removeAttr("style");
	        $("#contentBut").attr("style", "display:none");
	      } else if(nodes[0].data.categoryType == '404' || nodes[0].data.categoryType == '401' || nodes[0].data.categoryType == '402' || nodes[0].data.categoryType == '403'){
			$("#workFlowBut").removeAttr("style");
	        $("#workFlowDescBut").removeAttr("style");
	        $("#contentBut").attr("style", "display:none");
		  }else {
	        $("#contentBut a").removeClass("last_tab");
	        $("#contentBut").removeAttr("style");
	        $("#workFlowBut").removeAttr("style");
	        $("#workFlowDescBut").removeAttr("style");
	      }
	    }
	  }
	 
	  function showContentViewInfo(){
		  	addScrollForIframe();
		    var nodes = $("#tree").treeObj().getSelectedNodes();
		    if (nodes.length <= 0) {
		      return;
		    }
		    var templateId = "";
		    if (nodes) {
		      templateId = nodes[0].data.id;
		    }
		    if (nodes[0].data.type == "category") {
			      return;
			}
		    var url = _ctxPath+"/content/content.do?isFullPage=true&moduleId="+ templateId + "&moduleType=32&viewState=3";
		    $(".left>li").removeClass("current");
		    $("#contentInfoBut").addClass("current");
		    removeScrollForIframe(nodes[0].data);
		    $("#displayIframe").attr('src', url);
	  }
	  //新公文文单
	  function govdocShowDocPage() {
		
		addScrollForIframe();
	    var nodes = $("#tree").treeObj().getSelectedNodes();
	    if (nodes.length <= 0) {
	      return;
	    }
	    var templateId = "";
	    if (nodes) {
	      templateId = nodes[0].data.id;
	    }
	    if(nodes[0].data.categoryType == null){
	    	return;
	    }
	    var url = _ctxPath+"/content/content.do?isFullPage=true&moduleId="+ templateId + "&govdocForm=1&viewState=3&moduleType="+nodes[0].data.categoryType;
	    $(".left>li").removeClass("current");
	    $("#govdocArticleBut").addClass("current");
	    removeScrollForIframe(nodes[0].data);
	    $("#displayIframe").attr('src', url);
	  }
	  //新公文正文
	  function showGovdocContent() {
		  var contentType =  document.getElementById("editFrame").contentWindow.document.getElementById("govdocContentType").value;
		  var fileId=document.getElementById("editFrame").contentWindow.document.getElementById("contentFileId").value;
		  var paras = document.getElementById("editFrame").contentWindow.officeParams;
		  if(contentType == 46){//查看OFD
				window.ofdobject = getA8Top().$.dialog({
					title : '版式文档',
					closeParam:{'show':false},
					transParams : {
						'parentWin' : window,
						"fileId" : fileId,
						"filename" : fileId + ".ofd",
						"webRoot" : paras.webRoot,
						"sessionparas" : paras,
						"popWinName" : "ofdobject",
						"popCallbackFn" : function() {
							alert('FShowOFD.html');
						}
					},
					url : paras.webRoot + "/common/ofd/ofd.html",
					targetWindow : this.parent.getA8Top(),
					width : this.parent.getA8Top().screen.availWidth,
					height : this.parent.getA8Top().screen.availHeight
				});
		  }else{
			  var editframe = document.getElementById("editFrame").contentWindow;
			  editframe.dealPopupContentWin();
		  }
//		addScrollForIframe();
//	    var nodes = $("#tree").treeObj().getSelectedNodes();
//	    if (nodes.length <= 0) {
//	      return;
//	    }
//	    var templateId = "";
//	    if (nodes) {
//	      templateId = nodes[0].data.id;
//	    }
//	    var url = _ctxPath+"/content/content.do?isFullPage=true&moduleId="+ templateId + "&moduleType=1&viewState=3&govdoc=1&govdoc=1";
//	    $(".left>li").removeClass("current");
//	    $("#govdocContentBut").addClass("current");
//	    removeScrollForIframe(nodes[0].data);
//	    $("#displayIframe").attr('src', url);
	  }

	  function showContentView() {
		addScrollForIframe();
	    var nodes = $("#tree").treeObj().getSelectedNodes();
	    if (nodes.length <= 0) {
	      return;
	    }
	    var templateId = "";
	    if (nodes) {
	      templateId = nodes[0].data.id;
	    }
	    if (nodes[0].data.type == "category"
	        || nodes[0].data.type == "template_coll"
	        || nodes[0].data.type == "text_coll"
	        || nodes[0].data.type == "workflow_coll"
	        || nodes[0].data.type == "personal"
	        || nodes[0].data.type =='edoc_coll') {
	      return;
	    }
	    var url = _ctxPath+"/content/content.do?isFullPage=true&moduleId="+ templateId + "&moduleType=1&viewState=3";
	    $(".left>li").removeClass("current");
	    $("#contentBut").addClass("current");
	    removeScrollForIframe(nodes[0].data);
	    $("#displayIframe").attr('src', url);
	  }

	  function addScrollForIframe(){
		  $("#displayIframe").css("overflow","scroll");	
	  }
	  
	  function removeScrollForIframe(obj){
		  try{
			if(obj.bodyType =='41' ||obj.bodyType =='42' ||obj.bodyType =='43' ||obj.bodyType =='44'){
				$("#displayIframe").css("overflow","hidden");	
			}
		  }catch(e){}
	  }
	  
	  
//察看报送单
  function showFormListView(){
  	addScrollForIframe();
      var templateId = "";
      var nodes = $("#tree").treeObj().getSelectedNodes();
      if (nodes) {
    	  templateId = nodes[0].data.id;
    	}
      if (nodes[0].data.type == "category") {
  	      return;
  	}
      var url = _ctxPath+"/govTemplate/govTemplate.do?method=showFormList&isFullPage=true&moduleId="+ templateId + "&appType=32&isNew=false";
      $(".left>li").removeClass("current");
      $("#formlist").addClass("current");
      removeScrollForIframe(nodes[0].data);
      $("#displayIframe").attr('src', url);
  }
	  
function showDocContentView(){
	addScrollForIframe();
	var nodes = $("#tree").treeObj().getSelectedNodes();
    if (nodes.length <= 0) {
      return;
    }
    var templateId = "";
    var moduleType = "";
    if (nodes) {
      templateId = nodes[0].data.id;
      moduleType = nodes[0].data.categoryType;
    }
    if (nodes[0].data.type == "category"
        || nodes[0].data.type == "template_coll"
        || nodes[0].data.type == "text_coll"
        || nodes[0].data.type == "workflow_coll"
        || nodes[0].data.type == "personal"
        || nodes[0].data.type =='edoc_coll') {
      return;
    }
    var url = _ctxPath+"/content/content.do?isFullPage=true&moduleId="+ templateId + "&moduleType="+moduleType+"&isNew=false";
    $(".left>li").removeClass("current");
    $("#articleContentBut").addClass("current");
    removeScrollForIframe(nodes[0].data);
    $("#displayIframe").attr('src', url);
}


function showDocPage(){
	addScrollForIframe();
	var nodes = $("#tree").treeObj().getSelectedNodes();
	if (nodes.length <= 0) {
	  return;
	}
	var templateId = "";
	if (nodes) {
	  templateId = nodes[0].data.id;
	}
	if (nodes[0].data.type == "category"
	|| nodes[0].data.type == "personl" || nodes[0].data.type=='edoc_coll') {
	  return;
	}
	//查看文单的URL
	var url = _ctxPath+"/edocTempleteController.do?method=detail&id="+templateId;
	$(".left>li").removeClass("current");
	$("#articleBut").addClass("current");
	removeScrollForIframe(nodes[0].data);
	$("#displayIframe").attr('src', url);
		    
}

//流程图
function showWorkFlow() {
  var nodes = $("#tree").treeObj().getSelectedNodes();
  if (nodes.length <= 0) {
    return;
  }
  var workflowId = "";
  if (nodes) {
    workflowId = nodes[0].data.workflowId;
  }
  if(workflowId == null){
	  return;
  }
  if (nodes[0].data.type == "category"
      || nodes[0].data.type == "template_coll"
      || nodes[0].data.type == "text_coll"
      || nodes[0].data.type == "workflow_coll"
      || nodes[0].data.type == "personal"
      || nodes[0].data.type =='edoc_coll') {
    return;
  }
  //根据模板ID去取工作流图
  $(".left>li").removeClass("current");
  $("#workFlowBut").addClass("current");
  var url = _ctxPath+'/workflow/designer.do?method=showDiagram&isTemplate=true&isDebugger=false&scene=2&isModalDialog=false&processId='
      + workflowId+'&currentUserName='+encodeURIComponent($.ctx.CurrentUser.name );
  if(nodes[0].data.isEdoc){
	  url +="&appName=edoc&wendanId="+nodes[0].data.wendanId;
  }
  $("#displayIframe").attr('src', url).css("overflow","hidden");
}
	


function OK() {
    if (templateChoose === "true") {
      var nodeIds = new Array();
      var nodes = $("#tree").treeObj().getCheckedNodes(true);
      $(nodes).each(function(index, elem) {
        if (elem.data.type != "category" && (!elem.chkDisabled || elem.chkDisabled == false)) {
          nodeIds.push(elem.id);
        }
      });
      return nodeIds;
    } else {
      var nodes = $("#tree").treeObj().getSelectedNodes();
      if (nodes.length <= 0) {
          return 'notclicktemplate';
      }
      var templateId = "";
      if(nodes[0].data.type == "category" ||nodes[0].data.type=="template_coll"
    	||nodes[0].data.type=="text_coll" ||nodes[0].data.type=="workflow_coll"
        	|| nodes[0].data.type=="personal" || nodes[0].data.type =='edoc_coll'){
			return "notclicktemplate";
      }
      if (nodes) {
        templateId = nodes[0].data.id;
      }
      return templateId;
    }
  }
  
function clk(e, treeId, node) {

    if (node.data.type == 'category') {
      //展开树
      nodeId = node.data.id;
    }else if(node.data.isInfo){//信息报送单
    	$("#formlist").show();
    	$("#contentInfoBut").show();
    	$("#articleBut").hide();
    	$("#articleContentBut").hide();
    	$("#contentBut").hide();
    	showFormListView();
    } else {
      if (node.data.isEdoc) {
          
    	  setDisPlay();
    	  $("#workFlowBut").css("display","");
    	  $("#workFlowDescBut").show();
	      if(node.data.type=='workflow'){
	          $("#articleBut").attr("style","display:none");
	          $("#articleContentBut").attr("style","display:none");
	          $("#contentBut").attr("style","display:none");
	          showWorkFlow();
	      }else if(node.data.type=='text'){
	    	   setDisPlay();
	          $("#workFlowBut").hide();
	          $("#workFlowDescBut").attr("style","display:none");
	          showDocPage();
	      } else{
    	    showDocPage();
    	  }
      } else {
		if(node.data.categoryType == '404' || node.data.categoryType == '401' || node.data.categoryType == '402' || node.data.categoryType == '403'){

		    var url = _ctxPath+"/content/content.do?method=checkNotFormContent&templateId="+ node.data.id ;
		    setDisPlay(20);
			$.ajax({
				url:url,
				dataType:"text",
				success:function(data){
					if("true" == data){//如果是有正文表单
						document.getElementById("editFrame").contentWindow.location.href = _ctxPath+"/form/bindDesign.do?method=editFrame&fbid="+node.data.id;
					}else{
						$("#govdocContentBut").hide();//无正文表单  不显示正文按钮
					}
				}
				
			});	
		}else{
			setDisPlay(1);
		}
        checkTemType();
        //TODO正文展示
        if (node.data.type == "workflow") {
          showWorkFlow();
        } else if (node.data.type == "text") {
          showContentView();
        } else if(node.data.categoryType == '404' ||node.data.categoryType == '401' || node.data.categoryType == '402' || node.data.categoryType == '403'){
			govdocShowDocPage();
		}else {
          if('personal' == node.data.type){return;}
          showContentView();
        }
      }
      nodeId = node.data.id;
    }
  }


function setDisPlay(type){
	if(type =='1'){//协同
		$("#articleBut").hide();
		$("#articleContentBut").hide();
		$("#contentBut").show();
		$("#govdocArticleBut").hide();
		$("#govdocContentBut").hide();
	}else if(type == '20'){
		$("#articleBut").hide();
		$("#articleContentBut").hide();
		$("#contentBut").hide();
		$("#govdocArticleBut").show();
		$("#govdocContentBut").show();
	}else{//公文
		$("#articleBut").show();
		$("#articleContentBut").show();
		$("#contentBut").hide();
		$("#govdocArticleBut").hide();
		$("#govdocContentBut").hide();
	}
	$("#formlist").hide();
	$("#contentInfoBut").hide();
}



//我的模板配置设置
function templateConfig() {
  //if (templateChoose === "true") {
    // 默认展开和选中首节点
    var treeObj = $.fn.zTree.getZTreeObj("tree");
    var nodes = treeObj.getNodes();
    $(nodes).each(function(index, domEle) {
      //domEle.nocheck = true;
    });
    // 设置节点的勾选只关联子级
    treeObj.setting.check.chkboxType.N = "s";
    treeObj.setting.check.chkboxType.Y = "s";
    if (nodes.length > 0) {
      treeObj.expandNode(nodes[0], true, false, true);
    }
    treeObj.selectNode(nodes[0]);
    if ($._autofill) {
      // 获取后台request参数
      var $af = $._autofill, $afg = $af.filllists;
      var treeNodes = $afg.templeteList;
      $(treeNodes).each(function(index, domEle) {
        var node = treeObj.getNodeByParam("id", domEle, null);
        if (node) {
          treeObj.checkNode(node, true, false);
          treeObj.setChkDisabled(node, true);
          //node.chkDisabled = true;
        }
      });
    }
  //}
}

function ss(node){
	if(node.data.type=='template' || node.data.type=='templete'||node.data.type=='workflow' || node.data.type=='text'){
		 return false;
	}
	if(node.data.type=='category' || node.data.type=='personal'||node.data.type=='template_coll'
		 ||node.data.type=='text_coll' || node.data.type=='workflow_coll' || node.data.type=='edoc_coll'){
		if(!node.children){
			return true;
		}
		if(node.children.length == 0){
			return true;
		}
		for(var c = 0; c < node.children.length; c++){
			ss(node.children[c]);
		}
	}
}



function SearchCategory(nodeArray,treeObj){
    var ii  = [];
    for(var count = 0 ; count < nodeArray.length; count ++ ){
        var node = nodeArray[count];
        if(ss(node)){
        	ii.push(node);
        }
    }
    for(var  xx = 0 ; xx< ii.length ; xx ++){
    	treeObj.removeNode(ii[xx]);
    }
    if(ii.length > 0){//当数组为空时，说明没有空目录了
    	var nodess = treeObj.transformToArray(treeObj.getNodes());
		SearchCategory(nodess,treeObj);
    }
}




$(function() {
	  $("#tree").tree({
	      idKey : "id",
	      pIdKey : "pId",
	      nameKey : "name",
	      title: 'fullName',
	      enableCheck : templateChoose === "true" ? true : false,
	      onClick : clk,
	      nodeHandler : function(n) {
	        if (n.data.type == 'category' || n.data.type=='personal' || n.data.type=='template_coll'
	  	        ||n.data.type=='text_coll' || n.data.type=='workflow_coll' || n.data.type=='edoc_coll') {
	            n.isParent = true;
	        }
	    }
	  });
	  var objTree = $.fn.zTree.getZTreeObj("tree");
	  if(searchType == '1' || searchType == '2'){
	      var nodes = objTree.transformToArray(objTree.getNodes());
	      SearchCategory(nodes,objTree);
	      objTree.expandAll(true);//查询的时候展开显示
	  }
	  try{
		//var nodeP = objTree.getNodeByParam("id", 101, null);
		//objTree.expandNode(nodeP, true, true, true);
	  }catch(e){
		  
	  }
	 	
	 	
	  templateConfig();
	  $("#displayIframe").height($("#layout_center_id").height() - 27);
		$("#searchSpan").bind("click",function(){
			searchTemplate();
	  });
	  if(!searchType){
	  	$("#templateName").hide();
		$("#templateTypes").hide(); 
	  }else if(searchType == '1'){
	  	$("#templateName").show();
		$("#templateTypes").hide(); 
		$("#searchSpan").show();
	  }else if(searchType == '2'){
	  	$("#templateName").hide();
		$("#templateTypes").show(); 
		$("#searchSpan").show();
		var  obj2 = document.getElementById("templateTypes");
		for(var i = 0 ; i < obj2.length; i ++){
				if(smtype == obj2[i].value){
					obj2.selectedIndex =  i ;
					break;
				}
	  	}
	  }
		$("#templateName").keydown(function(event){
			if(event.keyCode === 13){
				searchTemplate();
			}
		});
		$("#templateTypes").keydown(function(event){
			if(event.keyCode === 13){
				searchTemplate();
			}
		});
		var nodes = objTree.transformToArray(objTree.getNodes());
		$(nodes).each(function(index,elem){
	    	try{
	          	var m = elem.data;
				if(!elem.children && (m.type=='category' || m.type=='template_coll' 
					||m.type=='text_coll' || m.type=='workflow_coll') && (elem.level ==0 ||elem.level ==1)){
					var nodeEXPAND = objTree.getNodeByParam("id", m.id, null);
					objTree.expandNode(nodeEXPAND, true, true, true);
				}
			}catch(e){}
		});
		
		_addOnloadEventToIframe();
});

//为displayIframe添加加载完成事件，用于Word转成HTML后高度计算
function _addOnloadEventToIframe(){
    var displayIframeEl = document.getElementById("displayIframe");
    if(displayIframeEl){
        if (displayIframeEl.attachEvent){
            displayIframeEl.attachEvent("onload", function(){
                _calculateOfficeHtmlHeight();
            });
        } else {
            displayIframeEl.onload = function(){
                _calculateOfficeHtmlHeight();
            };
        }
    }
}

function _calculateOfficeHtmlHeight(){
    var displayIframeEl = document.getElementById("displayIframe");
    if(displayIframeEl){
        
        var dIframeDoc = displayIframeEl.contentWindow.document;
        
        var mainBody0El = dIframeDoc.getElementById("mainbodyHtmlDiv_0");
        if(mainBody0El){
            mainBody0El.style.height = "100%";
        }
        
        var _docIframe = dIframeDoc.getElementById("officeTransIframe");
        
        if(_docIframe != null){
            var docIframe = _docIframe.contentWindow.document.getElementById("htmlFrame");
            if (docIframe) {
                
                //去掉纵向滚动条
                var htmlIframeDoc = docIframe.contentWindow.document;
                var htmlIframeHTML = htmlIframeDoc.documentElement;
                var htmlIframeBody = htmlIframeDoc.body;
                
                var htmlIframeHeight = Math.max( htmlIframeBody.scrollHeight, htmlIframeBody.offsetHeight, 
                        htmlIframeHTML.clientHeight, htmlIframeHTML.scrollHeight, htmlIframeHTML.offsetHeight);
                
                var htmlIframeWidth = Math.max(htmlIframeBody.scrollWidth, htmlIframeBody.offsetWidth, 
                        htmlIframeHTML.clientWidth, htmlIframeHTML.scrollWidth, htmlIframeHTML.offsetWidth);
                
                var bodyBlockEl = dIframeDoc.getElementById("bodyBlock");
                var mainBodyEl = dIframeDoc.getElementById("mainbodyDiv");
                
                if(mainBodyEl){
                    
                    //处理正文组件的一些样式
                    _docIframe.style.margin = "0px";
                    _docIframe.style.border = "0px";
                    _docIframe.style.height = "100%";
                    _docIframe.style.width = "100%";
                    htmlIframeBody.style.overflow = "hidden";
                    bodyBlockEl.style.overflow = "auto";
                    
                    mainBodyEl.style.height = htmlIframeHeight+'px';
                    mainBodyEl.style.width = htmlIframeWidth + 'px';
                }
            }
        }else{
            if(mainBody0El){
                mainBody0El.style.minHeight = 10 + 'px';//正文组件不知为何要设置minHeight=500px
            }
        }
    }
}


//树滚动条在最顶端
function timeOutScroll()
{
    try{document.getElementById("west1").scrollTop = 0;}catch(e){}
}
setTimeout("timeOutScroll()",500);
  