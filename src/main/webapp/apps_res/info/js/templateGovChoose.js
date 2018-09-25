var nodeId='';


function searchTemplate(){
    var url = _ctxPath+"/govTemplate/govTemplate.do?method=templateChoose&category="+category;
	if($("#searchType").val() =='0'){
		window.location.href = url + "&accountId=" + accountId;
	// 模板名称去查询
	}else if($("#searchType").val()=="1"){
		var sName = $("#templateName").val();
		window.location.href = url + "&accountId=" + accountId +
		         "&sName=" + encodeURIComponent(sName) + "&searchType=" + $("#searchType").val();
	}
  }

function doSerch(obj){
	if(obj.value=='0'){
		$("#templateName").hide();
	}
	if(obj.value=='1'){
		$("#templateName").show();
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
	      } else {
	        $("#contentBut a").removeClass("last_tab");
	        $("#contentBut").removeAttr("style");
	        $("#workFlowBut").removeAttr("style");
	        $("#workFlowDescBut").removeAttr("style");
	      }
	    }
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
		    if (nodes[0].data.type == "category") {
		      return;
		    }
		    $(".left>li").removeClass("current");
		    $("#workFlowDescBut").addClass("current");
		    var url = _ctxPath+'/template/template.do?method=getDes&templateId='+ templateId + '&moduleType=4';
		    $("#displayIframe").attr('src', url);
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
	    if (nodes[0].data.type == "category") {
		      return;
		}
	    var url = _ctxPath+"/content/content.do?isFullPage=true&moduleId="+ templateId + "&moduleType=32&viewState=3";
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
  if (nodes[0].data.type == "category") {
      return;
   }
  //根据模板ID去取工作流图
  $(".left>li").removeClass("current");
  $("#workFlowBut").addClass("current");
  var url = _ctxPath+'/workflow/designer.do?method=showDiagram&isTemplate=true&isDebugger=false&scene=2&isModalDialog=false&processId='
      + workflowId+'&currentUserName='+encodeURIComponent($.ctx.CurrentUser.name );
  $("#displayIframe").attr('src', url);
}
	


function OK() {
   
      var nodes = $("#tree").treeObj().getSelectedNodes();
      if (nodes.length <= 0) {
          return 'notclicktemplate';
      }
      var templateId = "";
      if(nodes[0].data.type == "category" ){
			return "notclicktemplate";
      }
      if (nodes) {
        templateId = nodes[0].data.id;
      }
      return templateId;
    
  }
  

function clk(e, treeId, node) {
    if (node.data.type == 'category') {
      //展开树
      nodeId = node.data.id;
      return;
    } else {
      showFormListView();
    }
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
	      onClick : clk,
	      nodeHandler : function(n) {
	        if (n.data.type == 'category' || n.data.type=='personal' || n.data.type=='template_coll'
	  	        ||n.data.type=='text_coll' || n.data.type=='workflow_coll' || n.data.type=='edoc_coll') {
	            n.isParent = true;
	        }
	    }
	  });
	  var objTree = $.fn.zTree.getZTreeObj("tree");
	 // if(searchType == '1' || searchType == '2'){ //注释查询
	      var nodes = objTree.transformToArray(objTree.getNodes());
	      //SearchCategory(nodes,objTree);
	      objTree.expandAll(true);//查询的时候展开显示
	 // }
	  try{
		var nodeP = objTree.getNodeByParam("id", 101, null);
		objTree.expandNode(nodeP, true, true, true);
	  }catch(e){
		  
	  }
	 	
	  $("#displayIframe").height($("#layout_center_id").height() - 27);
	  $("#searchSpan").bind("click",function(){
			searchTemplate();
	  });
	  if(!searchType){
	  	$("#templateName").hide();
	  }else if(searchType == '1'){
	  	$("#templateName").show();
		$("#searchSpan").show();
	  }
		$("#templateName").keydown(function(event){
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
});

//树滚动条在最顶端
function timeOutScroll()
{
    document.getElementById("west1").scrollTop = 0;
}
setTimeout("timeOutScroll()",50);
  