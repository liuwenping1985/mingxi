<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>${ctp:i18n('doc.jsp.knowledge.center')}</title>
	<link rel="stylesheet" href="${path}/common/skin/default/skin.css">
    <script type="text/javascript" src="${path}/main/common/js/frame-common.js"></script>
	<script type="text/javascript"  src="<c:url value="/apps_res/webmail/js/webmail.js" />"></script>
	<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/doc.js" />"></script>
    <script type="text/javascript">
    v3x.loadLanguage("/apps_res/doc/i18n");

        $(document).ready(function () {
      	  
            //登出
            $("#logout").click(function(){
            	window.close();
            });

        //前进
        $("#historyForward").click(function(){
          historyForward();
        });
        //后退
        $("#historyBack").click(function(){
          historyBack();
        });
        //左导航控制
        $("#closeopenleft").toggle(function(){
          hideLeftNavigation();
        },function(){
          showLeftNavigation();
        });
        //刷新
        $("#refreshPage").click(function(){
          reFlesh();
        });

        //banner折叠
        $("#collapse_banner").toggle(
          function () {
            $(this).removeClass('collapse_icon').addClass("unfold_icon");
            $('#logo').css({
                'height':37
            });
            $('#accountNameDiv').css({
                'marginTop':8
            });
            $('#accountSecondNameDiv').hide();
            $('#area_l').css({
                'height':37
            });
            $('#area_r').css({
                height:34,
                'paddingTop':3
            });
            $('#stadic_layout_head').height(50);
            $('#stadic_layout_body').css({
                'top':52
            });
          },
          function () {
            $(this).removeClass("unfold_icon").addClass('collapse_icon');
            $('#logo').css({
                'height':67
            });
            $('#accountNameDiv').css({
                'marginTop':15
            });
            $('#accountSecondNameDiv').show();
            $('#area_l').css({
                'height':67
            });
            $('#area_r').css({
                'height':44,
                'paddingTop':24
            });
            $('#stadic_layout_head').height(80);
            $('#stadic_layout_body').css({
                'top':82
            });
          }
        );
        mainReSize();
        $(window).resize(function(){
            mainReSize();
        });
    });
    function mainReSize(){
        $('#main').height($('#stadic_layout_body').height());
    }  
    </script>
</head>
<body class="h100b over_hidden frount" >
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F04_showKnowledgeNavigation'"></div>
    <div id="stadic_layout" layout="border:false">
        <div id="stadic_layout_head" layout="border:false">
            <div class="area">
                <div class="area_l"><a href="#"></a></div>
                <div class="area_r">
                            <a class="right" id="logout"><em class="ico24 close_icon" title="${ctp:i18n('common.button.close.label')}"></em></a>
                            <a class="right"><em id="collapse_banner" class="ico24 collapse_icon" title="${ctp:i18n('doc.title.shrink')}"></em></a>
                            <a class="right" id="refreshPage"><em class="ico24 refresh_icon" title="${ctp:i18n('seeyon.top.reload.alt')}"></em></a>
                            <a class="right" id="historyForward"><em class="ico24 back_icon" title="${ctp:i18n('seeyon.top.forward.alt')}"></em></a>
                            <a class="right" id="historyBack"><em class="ico24 front_icon" title="${ctp:i18n('seeyon.top.back.alt')}"></em></a>
                </div>
                <div class="area_c"></div>
            </div>
        </div>
        <div id="stadic_layout_body" layout="border:false">
            <div id="main_layout" class="margin_l_10 margin_r_10">
                <iframe src="${path}/doc/knowledgeController.do?method=personalKnowledgeCenterIndex&openFlag=${openFlag}" id="main" frameborder="0" class="w100b h100b"></iframe>
            </div>
        </div>
    </div>
</body>
</html>