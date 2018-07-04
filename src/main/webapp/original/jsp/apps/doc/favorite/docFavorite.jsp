<%--
 $Author:
 $Rev: 
 $Date:: 
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="../docHeaderOnPigeonhole.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n('doc.tree.move.pigeonhole')}</title>
<script type="text/javascript">
  var dialog =null;
  var zTree = null;
  var isV5member = ${CurrentUser.externalType == 0};
  $().ready(function() {
    upOrDownDiv();
    $("#roots").tree({
      idKey : "id",
      pIdKey : "parentFrId",
      nameKey : "frName",
      onClick :fnTreeClick,
      nodeHandler : function(node) {
          node.isParent = true;
      }
    });
    
    $("#btnadd").bind("click", add);
    zTree = $("#roots").treeObj();
    var nodes = zTree.getNodes();
    if (nodes.length > 0) {
      zTree.selectNode(nodes[0]);
      zTree.expandNode(nodes[0]);
    };
    
    $("#btnok").click(fnBtnOk);
    
    $("#btncancel").click(function() {
    	//刷新
    	fnFavoriteReload(true);
    });
    
    //收藏成功
    if('${isFavorited}'==='false'&& '${favoritedFail}'==='false'){
    	//fnFavoriteReload(false);
    }else if('${favoritedFail}'==='true'){//收藏失败
    	toggleTip(false);
        if(isV5member){
	        upOrDownDiv();
        }
    }
    
    $("#btnok").disable();
  });
  
  function fnTreeClick(e, treeId, node){
      var oBtn = $("#btnok");
      if(node.parentFrId!=0&&node.parentFrId!='0'){
          oBtn.enable();
      }else{
          oBtn.disable();
      }
  }
  
  function fnBtnOk(){
      //禁用自己
      $("#btnok").disable();
      var keyWords = $('#keyword').val().trim();
      var strs = new Array();
      strs = keyWords.split(" ");
      if (strs.length > 3) {
          $.messageBox({
              'type': 0,
              'imgType':2,
              'msg': $.i18n('doc.label.count.limit')
          });
          $("#btnok").enable();
      }else{
          nodes = zTree.getSelectedNodes();
          $("#destResId").val(nodes[0].id);

          var obj = new Object();
          obj.destFolderId = nodes[0].id;
          obj.docId = $("#docId").val();
          obj.keyword = $("#keyword").val();
          obj.userId = "${CurrentUser.id}";
          
          obj.appEnumKey = "${appEnumKey}";
          obj.sourceId = "${sourceId}";
          obj.hasAtts = "${hasAtts}";
          obj.favoriteType = "${favoriteType}";
          
          
          var KFManager = new knowledgeFavoriteManager();
          KFManager.updateDocFavorite(obj, {
              success : function(data) {
                  if (data == "ok") {
                      if (navigator.userAgent.toLowerCase().indexOf("nt 10.0") != -1 && navigator.userAgent.toLowerCase().indexOf("trident") != -1) {
                          alert($.i18n('doc.favorite.sort.success'));
                          if (getA8Top().dialog.close) {
                              getA8Top().dialog.close();
                          }
                      } else {
                          var random = $.messageBox({
                              'title': "${ctp:i18n('doc.collect')}",
                              'type': 100,
                              'imgType': 0,
                              'msg': $.i18n('doc.favorite.sort.success'),
                              buttons: [{
                                  id: 'btn2',
                                  text: "${ctp:i18n('common.button.ok.label')}",
                                  handler: function() {
                                	  setTimeout(function(){
  										if (getA8Top().dialog.close) {
  											getA8Top().dialog.close();
  										}
  									  },50)
                                  }
                              }]
                          });
                      }
                  } else {
                      $.alert("${ctp:i18n('doc.collect.fail')}${ctp:i18n_1('doc.log.favorite.save',4)}!");
                  }
                  fnFavoriteReload(false);
            	  toggleTip(true);
              }
          })
      }
  }
  
  //取消收藏
  function favDel(){
     $("#tableForm")[0].action="${path}/doc/knowledgeController.do?method=favoriteCancel";
     $("#tableForm").jsonSubmit({callback:function(){
    	 fnFavoriteReload(true);
     }});
  };
  
  function upOrDownDiv(){
	if("old"=="${param.flag}"){
		return;
	}
    var d = document.getElementById("divCenter");
    var b = document.getElementById("divBottom");
    
    var sHeight = $(getA8Top()).height()-55;
    var sDisplay = "none";
    var oReSize= {width:300,height:95,cHeight:sHeight};
    var sCss = "ico16 arrow_2_b";
    
    if(d.style.display!=""){
        sDisplay="";
        oReSize = {width:300,height:425,cHeight:sHeight};
        sCss = "ico16 arrow_2_t";
    }
    b.style.display=sDisplay;
    d.style.display=sDisplay;
    
    getA8Top().dialog.reSize(oReSize); 
    $("#upDownIco").attr("class",sCss);
  }
  
  function add(){
    $("#btnok").disable();
    var dhManager = new docHierarchyManager();
    var newNode = null;
    dialog = $.dialog({
      id : 'html',
      htmlId : 'addId',
      title : '${ctp:i18n("doc.doclib.jsp.newfolder")}',
      width : 260,
      height : 70,
      overflow : 'hidden',
      buttons : [{
	    id:'btnok',
        text : "${ctp:i18n('common.button.ok.label')}",
        handler : fnAddFolderSubmit
      },{
        text : "${ctp:i18n('common.button.cancel.label')}",
        handler : function() {
          dialog.close();
          $("#btnok").enable();
        }
      } ]
    });
    $("#title").focus();
  }
  
  //新建文件夹提交事件
  function fnAddFolderSubmit(){
      //对空字检测   去掉两边空格
      var sTitle=$("#title").val().trim();
      $("#title").val(sTitle);
      if(!$("#addId").validate())
          return;
      nodes = zTree.getSelectedNodes(), treeNode = nodes[0];
      if (!treeNode) {
        treeNode = zTree.getNodes()[0];
      }

      var dhManager = new docHierarchyManager();
      var titleVal = $("#title").val();
      var obj = {"parentId":treeNode.id,"title":titleVal};
      dhManager.updateFolderPigeonhole(obj, {
        success : function(data) {
          //如果后台异常，则提示信息，同时return;
          if (data.eMessage != null) {
                if(data.eMessage == 'doc_upload_dupli_name_failure_alert'||data.eMessage == 'doc_upload_dupli_name_folder_failure_alert'){
                    $.error(v3x.getMessage('DocLang.'+data.eMessage,obj.title));
                }else{
                    if(data.eParam!=null){
                        $.error(v3x.getMessage('DocLang.'+data.eMessage,data.eParam));
                    }else{
                        $.error(v3x.getMessage('DocLang.'+data.eMessage));
                    }
                }
                $("#btnok").enable();
                return;
          }
          zTree.addNodes(treeNode, {
            id : data.id,
            parentFrId : treeNode.id,
            isParent : 'false',
            frName : titleVal
          });
          $("#btnok").enable();
          zTree.selectNode(zTree.getNodeByParam("id", data.id, treeNode));
        }
      });
      //关闭新建文件夹对话框
      dialog.close();
    }
  
//刷新知识查看
  function fnReloadKnowledgeBrowse(){
      if(getA8Top().docOpenDialogOnlyId_main_iframe && getA8Top().docOpenDialogOnlyId_main_iframe.fnReloadKnowledgeBrowse){
          getA8Top().docOpenDialogOnlyId_main_iframe.fnReloadKnowledgeBrowse();
      }
      //老界面刷新
      var oldIframe = $(".mxt-window-body-iframe",getA8Top().document.body);
      if(oldIframe[0] && oldIframe[0].contentWindow && oldIframe[0].contentWindow.fnReloadKnowledgeBrowse){
          oldIframe[0].contentWindow.fnReloadKnowledgeBrowse();
      }
  }
  
  //刷新个人知识中心
  function fnReloadPersonalKnowledgeCenter(){
     if(typeof(getA8Top().main) != "undefined" && getA8Top().main.window.fnReload){
          getA8Top().main.window.fnReload();
     }
  }
  
  //刷新知识广场
  function fnReloadSquarePublicity(){
     if(typeof(getA8Top().main) != "undefined" && getA8Top().main.window.fnPageDataLoad){
          getA8Top().main.window.fnPageDataLoad(true);
      }
  }
  
  function fnFavoriteReload(isClose){
	  fnReloadSquarePublicity();
	  fnReloadPersonalKnowledgeCenter();
	  fnReloadKnowledgeBrowse();
	  
	  if(isClose && getA8Top().dialog){
          if(getA8Top().dialog.close){
              getA8Top().dialog.close();
          }
      }
  }
  
  function OK(){
	  fnFavoriteReload(false);
  }
  
  function toggleTip(favorited){
    var fDialog = window.parentDialogObj["docOpenDialogOnlyId"];
	
  	if(fDialog == null){
	   fDialog = window.parentDialogObj["docFavoriteDialog"];
  	}
  	
  	var favoriteId = "favoriteSpan"+"${sourceId}";
  	var cancelFavoriteId = "cancelFavorite"+"${sourceId}";
  	var oFavorite = {},oCancelFavorite = {};
  	
  	if(fDialog){
  		if(fDialog.getObjectById(favoriteId).size()>0){//弹出框中未找到
  			oFavorite = fDialog.getObjectById(favoriteId);
  			oCancelFavorite = fDialog.getObjectById(cancelFavoriteId);
  		}
  	}
  	
    if(!oFavorite.size || oFavorite.size()==0){
  		var oldIframe = $(".mxt-window-body-iframe",getA8Top().document.body);
  		if(oldIframe[0]==null){//协同弹出框
  	  		oldIframe = $("#dialogDealColl_main_iframe_content",getA8Top().document.body);
  		}
  		
  		if(oldIframe[0]==null && getA8Top().main && getA8Top().main.document){//协同列表
  			oldIframe = $("#summary",getA8Top().main.document.body);
  		}
  		
  		if(oldIframe[0] && oldIframe[0].contentWindow && oldIframe[0].contentWindow.document){
  			var dmt = oldIframe[0].contentWindow.document;
  			oFavorite = $("#"+favoriteId,dmt);
  			oCancelFavorite = $("#"+cancelFavoriteId,dmt);
  			
  			//协同附件列表
  			var attachmentListIframe = $("#attachmentList",dmt.body);
  			if(attachmentListIframe[0] && attachmentListIframe[0].contentWindow && attachmentListIframe[0].contentWindow.document){
  				var dmt = attachmentListIframe[0].contentWindow.document;
  				var oFavoriteList = $("#"+favoriteId,dmt);
  				var oCancelFavoriteList = $("#"+cancelFavoriteId,dmt);
  				
  				if(favorited && oFavoriteList.hide){
  					oFavoriteList.hide();
  					oCancelFavoriteList.show();
  			  	}else if(oFavorite.show){
  			  		oFavoriteList.show();
  			  		oCancelFavoriteList.hide();
  			  	}
  			}
  		}
  	}else{//弹出窗口
  		var attachmentListIframe = $("#attachmentList",parent.window.document);
		if(attachmentListIframe[0] && attachmentListIframe[0].contentWindow && attachmentListIframe[0].contentWindow.document){
			var dmt = attachmentListIframe[0].contentWindow.document;
			var oFavoriteList = $("#"+favoriteId,dmt);
			var oCancelFavoriteList = $("#"+cancelFavoriteId,dmt);
			
			if(favorited && oFavoriteList.hide){
				oFavoriteList.hide();
				oCancelFavoriteList.show();
		  	}else if(oFavorite.show){
		  		oFavoriteList.show();
		  		oCancelFavoriteList.hide();
		  	}
		}
  	}
  	
  	if(favorited && oFavorite.hide){
  		oFavorite.hide();
  		oCancelFavorite.show();
  	}else if(oFavorite.show){
  		oFavorite.show();
  		oCancelFavorite.hide();
  	}
  }
</SCRIPT>
</head>
<body class="h100b over_hidden page_color">
<div class="form_area h100b bg_color_white">
  <form id=tableForm action="${path}/doc/knowledgeController.do?method=favorite" class="display_block h100b w100b">
      <div id='favoritedDiv'>
         <c:if test="${!favoritedFail}">
         <div id='favoritednew' style="background: rgb(250,250,250);height:97px;" class="align_center">
            <table class="align_center w100b" border="0" cellpadding="0" cellspacing="0">
              <tr><td align="right" rowspan="3" class="padding_r_5 padding_t_5" valign="top"><span class="msgbox_img_0"></span></td>
                  <td class="align_left padding_t_5" style="color:#333;"><span>${ctp:i18n('doc.collect.successful')}</span></td></tr>
              <tr><td style="color:#333;" class="align_left padding_t_5"><span>${ctp:i18n_1('doc.log.favorite.save',1)}</td></tr>
              <c:if test="${CurrentUser.externalType == 0}">
	              <tr>
	                <td style="color:#333;" class="align_left padding_t_5">${ctp:i18n_1('doc.log.favorite.save',2)}<a onclick="upOrDownDiv()">${ctp:i18n_1('doc.log.favorite.save',3)}</span><c:if test="${empty param.flag}"><span id="upDownIco" class="ico16 arrow_2_t"></span></c:if></a></td>
	              </tr>
              </c:if>
              </table>
         </div>
         </c:if>
         <c:if test="${favoritedFail}">
	          <div id='favoritednew' class="align_center">
	            <table class="align_center w100b" border="0" cellpadding="0" cellspacing="0">
	              <tr><td align="right" rowspan="3" class="padding_r_5 padding_t_5" valign="top"><span class="msgbox_img_2"></span></td>
	                  <td class="align_left padding_t_5"><span>${msg eq ''?ctp:i18n('doc.collect.fail'):msg}</span></td></tr>
	              <c:if test="${CurrentUser.externalType == 0}">
	              <tr><td class="align_left padding_t_5"><span>${ctp:i18n_1('doc.log.favorite.save',4)}</td></tr>
	              </c:if>
	              <tr>
	                <td class="align_left padding_t_5">${ctp:i18n_1('doc.log.favorite.save',5)}</span></td>
	              </tr>
	              <c:if test="${CurrentUser.externalType == 0}">
	              <tr><td colspan="2" class="align_left padding_t_5"><div><span onclick="upOrDownDiv()" class="margin_l_5">${ctp:i18n_1('doc.log.favorite.assort',4)}<c:if test="${empty param.flag}"><span id="upDownIco" class="ico16 arrow_2_t"></span></c:if></span></div></td></tr>
	              </c:if>
	              </table>
	         </div>
         </c:if>
      </div>
    <div id="divCenter" class="border_t" style="background: rgb(250,250,250);">
        <table class="w100b" border="0" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <th nowrap="nowrap" style="width: 20%"><label class="margin_r_5">${ctp:i18n('doc.jsp.knowledge.category')}:</label></th>
                <td style="width: 80%"><label class="margin_r_10 left" for=text>${ctp:i18n('doc.jsp.favorite.folder.select')}</label></td>
            </tr>
            <tr>
                <td></td>
                <td>
              		<div class="common_txtbox clearfix over_auto border_all padding_t_5" style="height: 172px; width: 210px;">
                  		<div id="roots" class="border_all"></div>
              		</div>
              	</td>
            </tr>
            <tr>
                <th><label class="margin_r_5"></label></th>
                <td class="padding_t_5"><a id="btnadd" class="common_button common_button_grayDark"	href="javascript:void(0)">${ctp:i18n('doc.jsp.createf.title')}</a>
              	</td>
            </tr>
            <tr>
                <th nowrap="nowrap"><label class="margin_r_5">${ctp:i18n('doc.jsp.knowledge.query.key')}:</label></th>
                <td>
              		<input type="text" id="keyword" name="keyword" value="<c:out value='${keyword}'/>" 
              			class="validate " validate="name:'${ctp:i18n('doc.jsp.knowledge.query.key')}',isWord:true,maxLength:80" style="width: 210px;" >
                </td>
            </tr>
          <tr>
            <td></td>
            <td class="color_gray">(${ctp:i18n('doc.jsp.compart.space')})</td>
          </tr>
        </table>
    </div> 
  <div id="divBottom" class="stadic_layout_footer stadic_footer_height align_right border_t bg_color_black padding_t_5">
    <a id="btnok" class="common_button common_button_emphasize">${ctp:i18n('common.button.ok.label')}</a>
    <a id="btncancel" class="common_button common_button_grayDark" style="background:#99948c;color:#fff; margin-left: 6px;border: 1px solid #99948c;">${ctp:i18n('common.button.cancel.label')}</a>
    &nbsp;&nbsp;&nbsp;
  </div>
    <input type="hidden" id="destResId" name="destResId"> 
    <input type="hidden" id="parentId" name="parentId" value="${parentId}">
    <input type="hidden" id="docId" name="docId" value="${docId}"> 
    <input type="hidden" id="sourceId" name="sourceId" value="${param.sourceId}">
    <input type="hidden" id="appName" name="appName" value="${param.appName}">
    <input type="hidden" id="hasAtts" name="hasAtts" value="${param.hasAtts}">
    <input type="hidden" id="favoriteType" name="favoriteType" value="${param.favoriteType}">
  </form>
</div>
<!-- 新建文档夹 -->
<table id="addId" class="display_none w100b h100b" cellpadding="0" cellspacing="0">
        <tr>
            <td nowrap="nowrap"><label class="margin_r_5 right">${ctp:i18n('doc.jsp.createf.name')}:</label>
            </td>
            <td>
                <div class="form_area">
                    <div>
                        <input type="text" name="title" id="title" class="validate" style="width:130px"
                            validate="name:'${ctp:i18n('doc.jsp.createf.name')}',notNull:true,maxLength:80,isWord:true,avoidChar:'!@#$%^*()<>'" />
                    </div>
                </div>
            </td>
        </tr>
    </table>
</body>
</html>