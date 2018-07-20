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
<style>
.stadic_head_height {
  height: 75px;
}

.stadic_body_top_bottom {
  bottom: 0px;
  top: 75px;
}

.stadic_footer_height {
  height: 30px;
}
</style>

<script type="text/javascript">
  var zTree;
  $().ready(function() {
    $("#roots").tree({
      idKey : "id",
      pIdKey : "parentFrId",
      onClick :fnTreeClick,
      nameKey : "frName"
    });
    $("#btnadd").bind("click", add);
    zTree = $("#roots").treeObj();
    var nodes = zTree.getNodes();
    if (nodes.length > 0) {
      zTree.expandNode(nodes[0]);
      setTimeout(function(){
    	  zTree.selectNode(nodes[0]);
      },500); 
    };
    $("#btnok").click(function() {
        var keyWords = $('#keyword').val().trim();
        var strs = new Array();
        strs = keyWords.split(" ");
        if (strs.length > 3) {
            alert($.i18n('doc.label.count.limit'));
        }else{
            nodes = zTree.getSelectedNodes();
            $("#destResId").val(nodes[0].id);
            var requestCaller = new XMLHttpRequestCaller(this, "knowledgeFavoriteManager", "updateDocFavorite", false);
            requestCaller.addParameter(1, "Long", $("#docId").val());
            requestCaller.addParameter(2, "Long", nodes[0].id);
            requestCaller.addParameter(3, "String", $("#keyword").val());
            requestCaller.addParameter(4, "Long", '${CurrentUser.id}');
            
            requestCaller.addParameter(5, "Integer", $("#appName").val());
            requestCaller.addParameter(6, "Long", $("#sourceId").val());
            requestCaller.addParameter(7, "boolean", $("#hasAtts").val());
            requestCaller.addParameter(8, "Integer", $("#favoriteType").val());
            var data = requestCaller.serviceRequest();
            if(data === 'ok') {
            	alert($.i18n('doc.favorite.sort.success'));
           	 if('${param.isReload}'==='true'){
           	  if(getA8Top().frames['main'] && getA8Top().frames['main'].frames['rightFrame']) {
                  // 刷新文档中心
                  getA8Top().frames['main'].frames['rightFrame'].location.reload();
              }
             }else{
                 parent.dialog.close();
             }
            }else if(data == "fail"){
            	alert("文档名称重复！请修改收藏分类 ");
            } else {
            	alert(data);
            }
        }
    });
    
    $("#btncancel").click(function() {
    	if('${param.isReload}'==='true'){
    	    if(getA8Top().frames['main'] && getA8Top().frames['main'].frames['rightFrame']) {
                // 刷新文档中心
                getA8Top().frames['main'].frames['rightFrame'].location.reload(true);
            }
        }else{
            parent.dialog.close();
        }
    });
    upOrDownDiv();
    
    $("#btnok").disable();
  });
  
  function getA8Top(){
      try {
        var A8TopWindow =  getA8ParentWindow(window);
        if(A8TopWindow){
          return A8TopWindow;
        }else{
          return top;
        }
      }
      catch (e) {
        return top;
      }
    }
    function getA8ParentWindow(win){
        var currentWin = win;
        for(var i = 0; i < 20; i++){
            if(typeof currentWin.isCtpTop != 'undefined' && currentWin.isCtpTop){
                return currentWin;
            }
            else{
                currentWin = currentWin.parent;
            }
        }
    }

  function fnTreeClick(e, treeId, node){
      var oBtn = $("#btnok");
      if(node.parentFrId!=0&&node.parentFrId!='0'){
          oBtn.enable();
      }else{
          oBtn.disable();
      }
  }
  
  function favDel(){
     $("#tableForm")[0].action="${path}/doc/knowledgeController.do?method=favoriteCancel";
     $("#tableForm").jsonSubmit();
     if(getCtpTop().dialog){
         getCtpTop().dialog.close(); 
     }
  };
  
  function upOrDownDiv(){
	if("old"=="${param.flag}"){
		return;
	}
    var d = document.getElementById("divCenter");
    var b = document.getElementById("divBottom");
    if(d.style.display==""){
      b.style.display="none";
      d.style.display="none";
      $("#upDownIco").attr("class","ico16 arrow_2_b");
      parent.dialog.reSize({width:300,height:110}); 
    }else{
      b.style.display="";
      d.style.display="";
      $("#upDownIco").attr("class","ico16 arrow_2_t");
      parent.dialog.reSize({width:300,height:420}); 
    }
  }
  
  function add() {
    var dhManager = new docHierarchyManager();
    var newNode;
    var dialog = $.dialog({
      id : 'html',
      htmlId : 'addId',
      title : '${ctp:i18n("doc.doclib.jsp.newfolder")}',
      width : 320,
      height : 90,
      overflow : 'hidden',
      buttons : [ {
  	    id:'btnok',
        text : "${ctp:i18n('common.button.ok.label')}",
        handler : function() {
          var sTitle=$("#title").val().trim();
          $("#title").val(sTitle); 
	      if(!$("#addId").validate())
		      return;
          nodes = zTree.getSelectedNodes(), treeNode = nodes[0];
          if (!treeNode) {
            treeNode = zTree.getNodes()[0];
          }

          var dhManager = new docHierarchyManager();
          var obj = new Object();
          var titleVal = $("#title").val();
          obj.parentId = treeNode.id;
          obj.title = titleVal;
          dhManager.updateFolderPigeonhole(obj, {
            success : function(data) {
              //如果后台异常，则提示信息，同时return;
              if (data.eMessage != null) {
	            	if(data.eMessage == 'doc_upload_dupli_name_failure_alert'||data.eMessage == 'doc_upload_dupli_name_folder_failure_alert'){
	            		alert(v3x.getMessage('DocLang.'+data.eMessage,obj.title));
	            	}else{
		            	if(data.eParam!=null){
		            		alert(v3x.getMessage('DocLang.'+data.eMessage,data.eParam));
		            	}else{
		            		alert(v3x.getMessage('DocLang.'+data.eMessage,titleVal));
		            	}
	            	}
                  return;
              }
              zTree.addNodes(treeNode, {
                id : data.id,
                parentFrId : treeNode.id,
                isParent : 'false',
                frName : titleVal
              });
              zTree.selectNode(zTree.getNodeByParam("id", data.id, treeNode));
              $("#btnok").enable();
            }
          });
          dialog.close();
        }
      }, {
        text : "${ctp:i18n('common.button.cancel.label')}",
        handler : function() {
          dialog.close();
        }
      } ]
    });
    $("#title").focus();
  }
</SCRIPT>

</head>
<body class="h100b over_hidden page_color">
<div class="form_area h100b bg_color_white">
  <FORM id=tableForm action="${path}/doc/knowledgeController.do?method=favorite" class="display_block h100b w100b">
          <div id='favoritedDiv'>
             <c:if test="${!isFavorited && !favoritedFail}">
             <div id='favoritednew' class="align_center">
                <table class="w100b" border="0" cellpadding="0" cellspacing="0">
                  <tr><td align="center" valign="top" class="padding_t_5"  rowspan="3"><span class="msgbox_img_0"></span></td>
                      <td class="align_left padding_t_5"><span>${ctp:i18n('doc.collect.successful')}</span></td></tr>
                  <tr><td class="align_left padding_t_5"><span>${ctp:i18n_1('doc.log.favorite.save',1)}</td></tr>
                      <td class="align_left padding_t_5">${ctp:i18n_1('doc.log.favorite.save',2)}<a onclick="upOrDownDiv()">${ctp:i18n_1('doc.log.favorite.save',3)}</a></span></td></tr>
                  </table>                  
                <br>
             </div>
             </c:if>
             <c:if test="${favoritedFail}">
	          <div id='favoritednew' class="align_center">
	            <table class="align_center w100b" border="0" cellpadding="0" cellspacing="0">
	              <tr><td align="right" rowspan="3" class="padding_r_5 padding_t_5" valign="top"><span class="msgbox_img_2"></span></td>
	                  <td class="align_left padding_t_5"><span>${msg eq ''?ctp:i18n('doc.collect.fail'):msg}</span></td></tr>
	              <tr><td class="align_left padding_t_5"><span>${ctp:i18n_1('doc.log.favorite.save',4)}</td></tr>
	              <tr>
	                <td class="align_left padding_t_5">${ctp:i18n_1('doc.log.favorite.save',5)}</span></td>
	              </tr>
	              <tr><td colspan="2" class="align_left padding_t_5"><div><span onclick="upOrDownDiv()" class="margin_l_5">${ctp:i18n_1('doc.log.favorite.assort',4)}<c:if test="${empty param.flag}"><span id="upDownIco" class="ico16 arrow_2_t"></span></c:if></span></div></td></tr>
	              </table>
	         </div>
         	</c:if>
        </div>
        <div id="divCenter" class="border_t">
        <table class="w100b" border="0" cellpadding="0" cellspacing="0">
	        <tr>
	            <th nowrap="nowrap" style="width: 20%"><label class="margin_r_5">${ctp:i18n('doc.jsp.knowledge.category')}:</label></th>
	            <td style="width: 80%"><LABEL class="margin_r_10 left title" for=text>${ctp:i18n('doc.jsp.favorite.folder.select')}</LABEL></td>
	        </tr>
	        <tr>
	            <td></td>
	            <td>
              		<DIV class="common_txtbox clearfix over_auto border_all" style="height: 180px; width: 210px;">
                  		<div id="roots" class="border_all"></div>
              		</DIV>
              	</td>
	        </tr>
	        <tr>
	            <th><label class="margin_r_5"></label></th>
	            <td><a id="btnadd" class="common_button common_button_gray"
            			href="javascript:void(0)">${ctp:i18n('doc.jsp.createf.title')}</a>
              	</td>
	        </tr>
	        <tr>
	            <th nowrap="nowrap"><label class="margin_r_5">${ctp:i18n('doc.jsp.knowledge.query.key')}:</label></th>
	            <td>
              		<INPUT type="text" id="keyword" name="keyword" value="<c:out value='${keyword}'/>" 
              			class="validate " validate="name:'${ctp:i18n('doc.jsp.knowledge.query.key')}',isWord:true,maxLength:80" style="width: 210px;" >
	            </td>
	        </tr>
          <tr>
            <td></td>
            <td class="color_gray">(${ctp:i18n('doc.jsp.compart.space')})</td>
          </tr>
        </table>
        </div>        
      </div>
      <div id="divBottom" class="stadic_layout_footer stadic_footer_height align_right border_t padding_t_5 bg_color_black">
        <a id="btnok" class="common_button common_button_emphasize">${ctp:i18n('common.button.ok.label')}</a>
        <a id="btncancel" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
        &nbsp;&nbsp;&nbsp;
      </div>
    </div>
    <INPUT type="hidden" id="destResId" name="destResId"> 
    <INPUT type="hidden" id="parentId" name="parentId" value="${parentId}">
    <INPUT type="hidden" id="docId" name="docId" value="${docId}"> <INPUT
      type="hidden" id="sourceId" name="sourceId" value="${param.sourceId}">
    <INPUT type="hidden" id="appName" name="appName" value="${param.appName}">
    <INPUT type="hidden" id="hasAtts" name="hasAtts" value="${param.hasAtts}">
    <INPUT type="hidden" id="favoriteType" name="favoriteType" value="${param.favoriteType}">
      
  </FORM>
  </div>
<table id="addId" class="display_none w100b h100b margin_t_10" border="0" cellpadding="0" cellspacing="0"> 
    <tr>
        <td class="w30b" nowrap="nowrap" valign="top" align="right">${ctp:i18n('doc.jsp.createf.name')}:&nbsp;</td>
            <td valign="top">
                <div class="form_area">
                    <div>
        				<input type="text" name="title" id="title" class="validate w100b" style="width:90%" 
        				 validate="name:'${ctp:i18n('doc.jsp.createf.name')}',notNull:true,maxLength:80,isWord:true,avoidChar:'!@#$%^*()<>'"/>
                    </div>
                </div>
        </td>
    </tr>
</table>
</body>
</html>