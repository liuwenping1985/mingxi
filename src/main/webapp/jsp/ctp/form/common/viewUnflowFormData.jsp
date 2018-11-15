<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015-11-5 0005
  Time: 10:16
  Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="common.js.jsp"%>
<html>
<head>
<title>
  查看
</title>
<script>
    var dialogArg = window.dialogArguments;//所有参数
    //var dataIds = dialogArg.dataIds;//点击时，当前页面所有的id(前台传递，第一种方案;第二种方案，直接获取)
    var dataIds = new Array;//父页面列表Id集合
    var win = dialogArg?dialogArg.win:window;//父页面对象,全文检索穿透过来的没有dialogArg
    if(!win){//全文检索没有传递父页面window
        win = window;
    }
    var totalPage = 1;//总共页数
    var currPage = 1;//当前页数
    var _from = 1;//来源：1，有分页的列表；2，首页栏目列表（没有分页）
    var _moduleId = "${moduleId}";//当前id
    var _formId = "${formId}";
    var _moduleType = "${moduleType}";
    var _rightId = "${rightId}";
    //var canOpen = ${canOpen};
    var toolbar;

    $().ready(function(){
        //if(!canOpen){
        ///    $.alert({msg:"${ctp:i18n('form.unFlow.data.view.forbidden.tips.label')}",ok_fn:function(){
        //        window.close();
        //    }});
        //}
        $("#print").click(function(){
            print();
        });
        $("#previous").click(function(){
            previousOrNext("previous");
        });
        $("#next").click(function(){
            previousOrNext("next");
        });
        $("#mytable",win.document).find("input[type='checkbox']").each(function(){
            dataIds.push($(this).val());
        });
        if(dataIds == undefined || dataIds.length == 0){
            _from = 2;
        }
        if(_from == 2){
            $("#mytable",win.document).find("tr").each(function(){
                if($(this).attr("id")){
                    dataIds.push($(this).attr("id"));
                }
            });
        }
        if(_from == 1){
            var pageObj = $("#mytable",win.document).parent().parent().find(".total_page");
            if(pageObj){
                totalPage = $(pageObj).text().replace(/[^0-9]/ig,"");
            }
            var currPageObj = $("#mytable",win.document).parent().parent().find(".pagePrev").parent().next().find("input[type=text]");
            if(currPageObj){
                currPage = currPageObj.val();
            }
        }
        hasPreOrNext("load");//控制上一条下一条的显隐
        //禁止点击鼠标右键，因为前台通过弹出窗口传递的参数，右键刷新后就没了。
        $(document).bind("contextmenu", function() { return false; });
        if($("#print").css("visibility")=="hidden"&&$("#previous").css("visibility")=="hidden"&&$("#next").css("visibility")=="hidden"){
            $("#north").css("height","0px");
        }
    });
</script>
<script type="text/javascript" src="${path}/common/form/common/viewUnflowFormData.js${ctp:resSuffix()}"></script>
</head>
<body scroll="no">
<div class="comp" comp="type:'layout'" id="layout">
  <div class="layout_north" layout="height:30,maxHeight:30,minHeight:30,sprit:false" style="border:0px" id="north">
      <!--<div id="toolbar"></div>-->
      <div id="bth" style="font-size: 12px;text-align: right">
      <a href="javascript:void(0)" id="print" <c:if test="${!allowprint}">style="visibility: hidden;" </c:if> title="${ctp:i18n("form.print.printbutton")}" class=" margin_r_20"><em class="ico16 print_16"></em></a>
      <a href="javascript:void(0)" id="previous" <c:if test="${!displayNextAndPre}">style="visibility: hidden;" </c:if> title="${ctp:i18n("form.newdata.previous.label")}" class=" margin_r_20"><em class="ico16 arrow_2_l"></em></a>
      <a href="javascript:void(0)" id="next" <c:if test="${!displayNextAndPre}">style="visibility: hidden;" </c:if> title="${ctp:i18n("form.newdata.next.label")}" class=" margin_r_30"><em class="ico16 arrow_2_r"></em></a>
    </div>
  </div>
  <div class="layout_center" style="overflow: hidden;">
      <%--<c:if test="${canOpen eq true}" >--%>
      <iframe id="viewFrame" width="100%" height="100%" frameBorder="no" src='${path }/content/content.do?isFullPage=true&_isModalDialog=true&moduleId=${ctp:toHTML(moduleId)}&moduleType=${ctp:toHTML(moduleType)}&rightId=${ctp:toHTML(rightId)}&contentType=20&viewState=2'></iframe>
      <%--</c:if>--%>
  </div>
</div>
</body>
</html>
