<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript" src="${path}/apps_res/doc/js/doc.js"></script>
<script type="text/javascript" src="${path}/apps_res/doc/js/docFavorite.js?V=V5_0_product.build.date"></script>
<script type="text/javascript">
<%@ include file="/WEB-INF/jsp/apps/doc/js/docUtil.js"%>
<%@ include file="/WEB-INF/jsp/apps/doc/js/knowledgeCenter.js"%>
</script>
<script type="text/javascript">
var LockStatus_AppLock = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.AppLock.key()%>";
var LockStatus_ActionLock = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.ActionLock.key()%>";
var LockStatus_DocInvalid = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.DocInvalid.key()%>";
var LockStatus_None = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.None.key()%>";
var LOCK_MSG_NONE = "<%=com.seeyon.apps.doc.util.Constants.LOCK_MSG_NONE%>"


function getFileRow() {
    return Math.floor(($("#centerOver").width() - 10) / ($(".file_box_area").width() + 12));
    
}


$(function () {
    
    var folderName='';
    //************右侧文档内容列表显示******************
    $('#myajaxgridbar').ajaxgridbar( {
      managerName :'knowledgeManager',
      managerMethod :'findAllDocsByAjax',
      callback : function(fpi) {
        var result = fpi.data;
        var resultLength = result.length;
        if(!folderName == '') {
            $('#frNameDiv').html(folderName+"("+fpi.total+")");
        }
        if(((fpi.page-1)*fpi.size+resultLength) == fpi.total) {
            $("#_afpNext").attr("disabled", "disabled").html("");
        } else {
            $("#_afpNext").removeAttr("disabled").html('${ctp:i18n("doc.jsp.knowledge.view")}${ctp:i18n("doc.jsp.knowledge.more")}');
        }
        for(var i=0; i<resultLength; i++) {
          var star = fnGetStarLevelClass(result[i].doc.avgScore);
          var icoClass = "ico32 fileType_"+result[i].doc.mimeTypeId+" margin_r_10 left";
          var docName = result[i].doc.frName;
          var docId = result[i].doc.id;
          var parentId = result[i].doc.parentFrId;
          var docLibId = result[i].doc.docLibId;
          var docMimeType = result[i].doc.mimeTypeId;
          var _sourceId = result[i].doc.sourceId;
          var createDate = result[i].doc.createTime;
          var collection = result[i].doc.collectCount;
          var evaluation = result[i].doc.commentCount;
          var sourceType = result[i].doc.sourceType;
          var sourceId;
          if(sourceType=='2'){
            sourceId = result[i].doc.sourceId;
          }else if(sourceType == '3' || sourceType == '4'){
            sourceId = result[i].doc.favoriteSource;
          }else{
            sourceId = docId;
          }
          var manualCreate = (result[i].doc.mimeTypeId >=22 && result[i].doc.mimeTypeId <=26);
          var colArchive = result[i].doc.mimeTypeId == 1;
          var linkFile = result[i].doc.mimeTypeId == 51;
          var author = result[i].name;
          var display1 = (colArchive || manualCreate || linkFile) ? "none" : "";
          var display2 = colArchive || linkFile ? "none" : "";
          var display3 = linkFile ? "none" : "";
          var divStr = "<div class=\"file_box_area\"><div class=\"clearfix padding_10\"><span class=\""+icoClass+"\"></span><div class=\"over_auto_hiddenY left_ie6\"><p class=\"file_box_area_title\" title=\""+docName+"\"><a href=\"javascript:openDocOnlyId(\'"+sourceId+"\');\">"+docName+"</a></p><span class=\""+star+"\"></span><p class=\"margin_t_5 color_gray\">"+$.i18n('doc.jsp.knowledge.author')+author+"</p></div></div>"+
          "<div class=\"clearfix border_t\"><span class=\"color_gray left padding_tb_5 padding_l_10\">"+$.i18n('doc.menu.collect.label')+"("+collection+")&nbsp;"+$.i18n('doc.jsp.comment')+"("+evaluation+")</span><span class=\"right\"><span class=\"file_box_menu\"><a href=\"javascript:doc_recommend(\'"+docId+"\');\" class=\"ico16 FBM_recommend\" title=\""+$.i18n('doc.jsp.knowledge.recommend')+"\"></a><a href=\"#\" class=\"ico16 FBM_setting\" title=\""+$.i18n('doc.menu.action.label')+"\"></a></span>"+
          "<div class=\"file_box_menu_list\"><ul class=\"lvl1\"><li><a href=\"#\">"+$.i18n('doc.menu.sendto.label')+"</a><span class=\"ico16 arrow_gray_r left\"></span><div class=\"lvl2_box\"><ul class=\"lvl2\"><li><a href=\"javascript:sendToCommonDoc(\'"+docId+"\');\">"+$.i18n('doc.favorite.title')+"</a></li><li style=\"display:"+display3+"\"><a href=\"javascript:sendToMyStudy(\'"+docId+"\');\">"+$.i18n('doc.menu.sendto.learning.label')+"</a></li><li style=\"display:"+display3+"\"><a href=\"javascript:sendToSpecificLocation(\'"+docId+"\',\'"+parentId+"\',\'"+docLibId+"\');\">"+$.i18n('doc.menu.sendto.other.label')+"</a></li></ul></div></li>"+
          "<li style=\"display:"+display3+"\"><a href=\"#\">"+$.i18n('doc.menu.forward.label')+"</a><span class=\"ico16 arrow_gray_r left\"></span><div class=\"lvl2_box\"><ul class=\"lvl2\"><li><a href=\"javascript:forwardDocToCol(\'"+docId+"\');\">"+$.i18n('doc.jsp.knowledge.forward.collaboration')+"</a></li><li><a href=\"javascript:forwardDocToEmail(\'"+docId+"\');\">"+$.i18n('doc.jsp.knowledge.forward.mail')+"</a></li></ul></div></li><li style=\"display:"+display2+"\"><a href=\"javascript:downloadDoc(\'"+docId+"\',\'"+docName+"\',\'"+docMimeType+"\',\'"+_sourceId+"\',\'"+createDate+"\');\">"+$.i18n('doc.menu.download.label')+"</a></li><li style=\"display:"+display2+"\"><a href=\"javascript:edit(\'"+docId+"\',\'"+docName+"\',\'"+docMimeType+"\');\">"+$.i18n('doc.menu.edit.label')+"</a></li><li><a href=\"javascript:moveDoc(\'"+docId+"\',\'"+parentId+"\',\'"+docLibId+"\');\">"+$.i18n('doc.menu.move.label')+"</a></li><li style=\"display:"+display1+"\"><a href=\"javascript:replaceDoc(\'"+docId+"\',\'"+parentId+"\',\'"+docName+"\');\">"+$.i18n('doc.menu.replace.label')+"</a></li><li><a href=\"javascript:deleteDoc(\'"+docId+"\');\">"+$.i18n('doc.shanchu')+"</a></li><li style=\"display:"+display3+"\"><a href=\"javascript:renameDoc(\'"+docId+"\');\">"+$.i18n('doc.jsp.rename.title')+"</a></li><li style=\"display:"+display3+"\"><a href=\"javascript:borrowDoc(\'"+docId+"\');\">"+$.i18n('doc.menu.lend.label')+"</a></li><li><a href=\"javascript:docProperties(\'"+docId+"\');\">"+$.i18n('doc.menu.properties.label')+"</a></li></ul></div></span></div></div>";
          $(divStr).appendTo('#docContentList');
        }

          
          //小块设置操作单机事件
          $(".file_box_area .file_box_menu .FBM_setting").click(function () {
              $(this).parents(".file_box_area").find(".file_box_menu_list").show();
          });
          $(".file_box_area .file_box_menu_list").mouseleave(function () {
              $(this).hide();
          });

          
          //小块菜单控制
          $(".file_box_area .lvl1 > li[class!='line']").each(function () {
              var item = $(this).find(".lvl2");
              $(this).mouseenter(function () {
                  $(this).addClass("current");
                  $(this).find("span").toggleClass("arrow_gray_r arrow_white_r");
                  item.show();
              }).mouseleave(function () {
                  $(this).removeClass("current");
                  $(this).find("span").toggleClass("arrow_gray_r arrow_white_r");
                  item.hide();
              });
              $(this).find(".lvl2 li").mouseenter(function () {
                  $(this).addClass("current");
              }).mouseleave(function () {
                  $(this).removeClass("current");
              });
          });
      }
    });
    var obj = new Object();
    obj.folderId = '${myDocId}';
    obj.columns = getFileRow();
    $('#myajaxgridbar').ajaxgridbarLoad(obj);
    
    //********学习区、知识链接斑马样式************
    $(".tab_iframe li:odd").css({ background: "#F7F7F7" });
    
    //********平分式页签***********
    $(".common_tabs2").each(function (index) {
        var _this = $(this);
        _this.find(".common_tabs_head a").click(function () {
            _this.find(".common_tabs_head a").removeClass("current");
            $(this).addClass("current");
            _this.find(".tab_iframe").hide();
            _this.find("." + $(this).attr("tgt")).show();
        });
    });
    
    //**********搜索************
    var searchobj = $('#searchDiv').searchCondition({
        searchHandler: function () {
            var jsonParam = searchobj.g.getReturnValue();
            var paramValue = jsonParam.value;
            var condition = jsonParam.condition;
            
            if(condition == 'createUser' || condition == 'createTime' || condition == 'sponsor' || condition == 'startDate') {
                if(paramValue[0] == '' || paramValue[1] == '') {
                    $.alert('${ctp:i18n("doc.jsp.knowledge.query.error")}');
                    return;
                }
                if(condition == 'createTime' || condition == 'startDate') {
                    var result = compareDate(paramValue[0], paramValue[1]);
                    if(result > 0) {
                        $.alert('${ctp:i18n("doc.jsp.knowledge.query.error")}');
                    }
                    
                }
            } else {
                if(paramValue == null || paramValue.trim() == '') {
                    $.alert('${ctp:i18n("doc.jsp.knowledge.query.error")}');
                    return;
                }
            }
            $('#docContentList').html('');
            var obj = new Object();
            obj.search = "search";
            obj.folderId = "${myDocId}";
            obj.condition = jsonParam.condition;
            obj.value = jsonParam.value;
            obj.columns = getFileRow();
            $('#myajaxgridbar').ajaxgridbarLoad(obj);
        },
        conditions: [{
            id: 'frName',
            name: 'frName',
            type: 'input',
            text: $.i18n('doc.jsp.knowledge.query.name'),
            value: 'frName'
        }, {
            id: 'contentType',
            name: 'contentType',
            type: 'select',
            text: $.i18n('doc.jsp.knowledge.query.contentType'),
            value: 'contentType',
            codecfg: "codeType:'java',codeId:'com.seeyon.apps.doc.enums.ContentTypeEnums'",
        }, {
            id: 'keyWords',
            name: 'keyWords',
            type: 'input',
            text: $.i18n('doc.jsp.knowledge.query.key'),
            value: 'keyWords'
        }, {
            id: 'createTime',
            name: 'createTime',
            type: 'datemulti',
            text: $.i18n('doc.jsp.knowledge.query.createTime'),
            value: 'createTime',
            ifFormat:'%Y-%m-%d'
        }, {
            id: 'createUser',
            name: 'createUser',
            type: 'selectPeople',
            text: $.i18n('doc.jsp.knowledge.query.createUser'),
            value: 'createUser',
            comp:"type:'selectPeople',mode:'open',panels:'Department,Team',selectType:'Member',maxSize:'1',showMe:'true'"
        }, {
            id: 'sponsor',
            name: 'sponsor',
            type: 'selectPeople',
            text: $.i18n('doc.jsp.knowledge.query.launched'),
            value: 'sponsor',
            comp:"type:'selectPeople',mode:'open',panels:'Department,Team',selectType:'Member',maxSize:'1',showMe:'true'"
        }, {
            id: 'startDate',
            name: 'startDate',
            type: 'datemulti',
            text: $.i18n('doc.jsp.knowledge.query.launchedTime'),
            value: 'startDate',
            ifFormat:'%Y-%m-%d'
        }]
    }); 
    
    //************左侧菜单**************
    var a = ${levelOneJson};
    var b = ${levelTwoJson};
    var allDocs = ${allDocs};
    
    $("#menu").pagemenu({
        max: 20,
        max_item: 20,
        all_number: allDocs,
        data: [a, b],
        handler: function (json) {
            $('#docContent').scrollTop(0);
            folderName = json.frName;
            $('#docContentList').html('');
            var obj = new Object();
            obj.folderId = json.id;
            obj.columns = getFileRow();
            $('#myajaxgridbar').ajaxgridbarLoad(obj);
        }
    });
});
    //加载个人借阅条数
    $(function() {
        var personBorrowNum = '${personStaut.personBorrowNum}';
        $("#personBorrowNumId").html(personBorrowNum);
    });
    //返回个人知识中心
    function fnGoToBorrowHandle(url) {
        parent.window.location.href = '${path}/doc/knowledgeController.do?method='
                + url;
    }
    //博客
    function fnGoToblogHome() {
        parent.window.location.href = '${path}/blog.do?method=blogHome';
    }
    //转到我的分享目录
    function fnGoToHomepageIndex() {
        parent.window.location.href = '${path}/doc.do?method=docHomepageIndex&docResId='+'${personStaut.resId}';
    }
</script>       
        
    
</head>
<body class="page_color">
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_center" layout="border:false,sprit:false">
            <div id='Div1' class="comp" comp="type:'layout'">
                <div class="layout_west" layout="width:131,border:false,sprit:false">
                    <div id="menu">
                    </div>
                </div>
                <div id="docContent" class="layout_center" layout="border:false,sprit:false">
                    <div class="font_size12 padding_l_10 padding_r_5 right" style="width: 251px;">
                        <div class="border_all bg_color_white clearFlow">
                            <div class="clearFlow font_size14 padding_l_10 margin_t_20 line_height160">
                                <strong class="left margin_r_5">${CurrentUser.name}</strong><a class="common_level left" title="${personStaut.degree}">${personStaut.degree}</a>
                            </div>
                            <div class="color_gray padding_l_10 margin_t_10">${personStaut.department.name}
                                ${personStaut.orgPost.name}</div>
                            <div class="clearfix padding_lr_10 margin_t_20">
                                <a href="#" onclick="fnGoToBorrowHandle('personalShare');"
                                    class="common_button common_button_emphasize left">${ctp:i18n('doc.want.to.share')}</a>
                                <span class="line_height200 right">${ctp:i18n('doc.jsp.knowledge.have.share.my')}${personStaut.shareNum}${ctp:i18n('doc.jsp.knowledge.have.share.pieces')}</span>
                            </div>
                            <div class="border_t margin_t_20 align_right padding_tb_5">
                                <a href="#" onclick="fnGoToHomepageIndex();"  class="margin_r_10">${ctp:i18n("doc.jsp.knowledge.sharing")}</a><a href="#"
                                    onclick="fnGoToblogHome();" class="margin_r_10">${ctp:i18n("doc.jsp.home.label.blog")}</a>
                            </div>
                        </div>
                        <div class="margin_t_5 bg_color_yellow">
                            <div class="padding_lr_10 padding_tb_10 border_all">
                                <strong>${ctp:i18n("doc.jsp.knowledge.borrowing")}</strong>&nbsp;${ctp:i18n("doc.jsp.knowledge.has")}<a
                                    class="color_blue" onclick="fnGoToBorrowHandle('link&path=borrowHandle');" href="#">${ctp:i18n_1("doc.jsp.knowledge.borrowings",
                                    '<span id="personBorrowNumId"></span>')}</a>${ctp:i18n("doc.jsp.knowledge.deal")}
                            </div>
                        </div>
                        <div class="margin_t_5">
                            <div class="bg_color_white padding_lr_10 padding_tb_5 border_lr border_t"><strong>${ctp:i18n("doc.jsp.knowledge.myStudy")}</strong></div>
                            <div class="common_tabs2">
                                <table width="100%" class="common_tabs_head" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td width="50%"><a href="javascript:void(0)" hidefocus="true" class="current" tgt="tab_iframe1"><span>${ctp:i18n("doc.jsp.knowledge.others.recommend")}</span></a></td>
                                        <td><a href="javascript:void(0)" hidefocus="true" tgt="tab_iframe2"><span>${ctp:i18n("doc.jsp.knowledge.personal.arrangement")}</span></a></td>
                                    </tr>
                                </table>
                                <div class="tab_iframe tab_iframe1">
                                    <ul class="line_height200 margin_l_10">
                                        <li><a href="#" class="text_overflow color_black w160b"><span class="ico16 word_16 margin_r_5"></span>${ctp:i18n('doc.jsp.knowledge.others.recommend')}</a><span class="color_gray margin_l_10">2012-12-12</span></li>
                                        <li><a href="#" class="text_overflow color_black w160b"><span class="ico16 word_16 margin_r_5"></span>1致远协同软件安装1致远协同软件安装</a><span class="color_gray margin_l_10">2012-12-12</span></li>
                                        <li><a href="#" class="text_overflow color_black w160b"><span class="ico16 word_16 margin_r_5"></span>1致远协同软件安装1致远协同软件安装</a><span class="color_gray margin_l_10">2012-12-12</span></li>
                                        <li><a href="#" class="text_overflow color_black w160b"><span class="ico16 word_16 margin_r_5"></span>1致远协同软件安装1致远协同软件安装</a><span class="color_gray margin_l_10">2012-12-12</span></li>
                                        <li><a href="#" class="text_overflow color_black w160b"><span class="ico16 word_16 margin_r_5"></span>1致远协同软件安装1致远协同软件安装</a><span class="color_gray margin_l_10">2012-12-12</span></li>
                                        <li><a href="#" class="text_overflow color_black w160b"><span class="ico16 word_16 margin_r_5"></span>1致远协同软件安装1致远协同软件安装</a><span class="color_gray margin_l_10">2012-12-12</span></li>
                                        <li><a href="#" class="text_overflow color_black w160b"><span class="ico16 word_16 margin_r_5"></span>1致远协同软件安装1致远协同软件安装</a><span class="color_gray margin_l_10">2012-12-12</span></li>
                                        <li><a href="#" class="text_overflow color_black w160b"><span class="ico16 word_16 margin_r_5"></span>1致远协同软件安装1致远协同软件安装</a><span class="color_gray margin_l_10">2012-12-12</span></li>
                                    </ul>
                                    <div class="border_t align_right padding_tb_5">
                                        <a href="#" class="valign_m">${ctp:i18n("doc.jsp.knowledge.more")}</a><span class="valign_m ico16 arrow_2_r margin_r_5"></span>
                                    </div>
                                </div>
                                <div class="tab_iframe tab_iframe2 hidden">
                                    <ul class="line_height200 margin_l_10">
                                        <li><a href="#" class="text_overflow color_black w160b"><span class="ico16 word_16 margin_r_5"></span>${ctp:i18n('doc.jsp.knowledge.personal.arrangement')}</a><span class="color_gray margin_l_10">2012-12-12</span></li>
                                        <li><a href="#" class="text_overflow color_black w160b"><span class="ico16 word_16 margin_r_5"></span>1致远协同软件安装1致远协同软件安装</a><span class="color_gray margin_l_10">2012-12-12</span></li>
                                        <li><a href="#" class="text_overflow color_black w160b"><span class="ico16 word_16 margin_r_5"></span>1致远协同软件安装1致远协同软件安装</a><span class="color_gray margin_l_10">2012-12-12</span></li>
                                        <li><a href="#" class="text_overflow color_black w160b"><span class="ico16 word_16 margin_r_5"></span>1致远协同软件安装1致远协同软件安装</a><span class="color_gray margin_l_10">2012-12-12</span></li>
                                        <li><a href="#" class="text_overflow color_black w160b"><span class="ico16 word_16 margin_r_5"></span>1致远协同软件安装1致远协同软件安装</a><span class="color_gray margin_l_10">2012-12-12</span></li>
                                        <li><a href="#" class="text_overflow color_black w160b"><span class="ico16 word_16 margin_r_5"></span>1致远协同软件安装1致远协同软件安装</a><span class="color_gray margin_l_10">2012-12-12</span></li>
                                        <li><a href="#" class="text_overflow color_black w160b"><span class="ico16 word_16 margin_r_5"></span>1致远协同软件安装1致远协同软件安装</a><span class="color_gray margin_l_10">2012-12-12</span></li>
                                        <li><a href="#" class="text_overflow color_black w160b"><span class="ico16 word_16 margin_r_5"></span>1致远协同软件安装1致远协同软件安装</a><span class="color_gray margin_l_10">2012-12-12</span></li>
                                    </ul>
                                    <div class="border_t align_right padding_tb_5">
                                        <a href="#" class="valign_m">${ctp:i18n("doc.jsp.knowledge.more")}</a><span class="valign_m ico16 arrow_2_r margin_r_5"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="margin_t_5">
                                <div class="bg_color_white padding_lr_10 padding_tb_5 border_lr border_t"><strong>${ctp:i18n("doc.jsp.knowledge.my.knowledge.link")}</strong></div>
                                <div class="common_tabs2">
                                    <table width="100%" class="common_tabs_head" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td width="50%"><a href="javascript:void(0)" hidefocus="true" class="current" tgt="tab_iframe1"><span>${ctp:i18n("doc.jsp.knowledge.personal.link")}</span></a></td>
                                            <td><a href="javascript:void(0)" hidefocus="true" tgt="tab_iframe2"><span>${ctp:i18n("doc.jsp.knowledge.system.link")}</span></a></td>
                                        </tr>
                                    </table>
                                    <div class="tab_iframe tab_iframe1">
                                        <ul class="line_height200 clearfix">
                                            <li class="clearfix">
                                                <a href="#" class="text_overflow color_black w115b"><span class="ico16 word_16 margin_r_5"></span>${ctp:i18n('doc.jsp.knowledge.personal.link')}</a>
                                                <a href="#" class="text_overflow color_black w115b"><span class="ico16 word_16 margin_r_5"></span>1致远协同软件安装1致远协同软件安装</a>
                                            </li>
                                            <li class="clearfix">
                                                <a href="#" class="text_overflow color_black w115b"><span class="ico16 word_16 margin_r_5"></span>${ctp:i18n('doc.netEase')}</a>
                                                <a href="#" class="text_overflow color_black w115b"><span class="ico16 word_16 margin_r_5"></span>${ctp:i18n('doc.netEase')}</a>
                                            </li>
                                            <li class="clearfix">
                                                <a href="#" class="text_overflow color_black w115b"><span class="ico16 word_16 margin_r_5"></span>${ctp:i18n('doc.netEase')}</a>
                                                <a href="#" class="text_overflow color_black w115b"><span class="ico16 word_16 margin_r_5"></span>${ctp:i18n('doc.netEase')}</a>
                                            </li>
                                            <li class="clearfix">
                                                <a href="#" class="text_overflow color_black w115b"><span class="ico16 word_16 margin_r_5"></span>${ctp:i18n('doc.netEase')}</a>
                                                <a href="#" class="text_overflow color_black w115b"><span class="ico16 word_16 margin_r_5"></span>${ctp:i18n('doc.netEase')}</a>
                                            </li>
                                            <li class="clearfix">
                                                <a href="#" class="text_overflow color_black w115b"><span class="ico16 word_16 margin_r_5"></span>${ctp:i18n('doc.netEase')}</a>
                                                <a href="#" class="text_overflow color_black w115b"><span class="ico16 word_16 margin_r_5"></span>${ctp:i18n('doc.netEase')}</a>
                                            </li>
                                            <li class="clearfix">
                                                <a href="#" class="text_overflow color_black w115b"><span class="ico16 word_16 margin_r_5"></span>${ctp:i18n('doc.netEase')}</a>
                                                <a href="#" class="text_overflow color_black w115b"><span class="ico16 word_16 margin_r_5"></span>${ctp:i18n('doc.netEase')}</a>
                                            </li>
                                            <li class="clearfix">
                                                <a href="#" class="text_overflow color_black w115b"><span class="ico16 word_16 margin_r_5"></span>${ctp:i18n('doc.netEase')}</a>
                                                <a href="#" class="text_overflow color_black w115b"><span class="ico16 word_16 margin_r_5"></span>${ctp:i18n('doc.netEase')}</a>
                                            </li>
                                            <li class="clearfix">
                                                <a href="#" class="text_overflow color_black w115b"><span class="ico16 word_16 margin_r_5"></span>${ctp:i18n('doc.netEase')}</a>
                                                <a href="#" class="text_overflow color_black w115b"><span class="ico16 word_16 margin_r_5"></span>${ctp:i18n('doc.netEase')}</a>
                                            </li>
                                        </ul>
                                        <div class="border_t align_right padding_tb_5">
                                            <a href="#" class="valign_m margin_r_10">${ctp:i18n("doc.jsp.knowledge.knowledge.link.config")}</a><a href="#" class="valign_m">${ctp:i18n("doc.jsp.knowledge.more")}</a><span class="valign_m ico16 arrow_2_r"></span>
                                        </div>
                                    </div>
                                    <div class="tab_iframe tab_iframe2 hidden">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="centerOver" class="over_auto border_all padding_b_10 font_size12" style="_margin-right: 261px;">
                        <div id="contentHead" class="clearfix padding_lr_10 padding_tb_5 border_b bg_color_gray">
                            <div id="frNameDiv" class="color_gray font_size14 left margin_t_5"></div>
                            <div id="searchDiv" class="right"></div>
                        </div>
                        <div id="docContentList" class="padding_r_10 clearFlow">
                        </div>
                        <div class="padding_t_10 padding_lr_10">
                            <div id="myajaxgridbar" class="number bg_color_white border_all align_center padding_5 color_gray" >
                            <a href="javascript:void(0);" id="_afpNext" >${ctp:i18n("doc.jsp.knowledge.view")}${ctp:i18n("doc.jsp.knowledge.more")}</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>