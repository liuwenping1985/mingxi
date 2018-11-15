<%--
 $Author:  $
 $Rev:  $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<%@ include file="flowcommon.jsp" %>
</head>
<script type="text/javascript">
var isfirst = true;
$(document).ready(function(){
    $("table.flexme3").ajaxgrid({
      parentId : "center",
        colModel : [{
            display: "${ctp:i18n('common.subject.label')}",//标题
            name: 'subject',
            width: '34%'
        }, {
            display: "${ctp:i18n('cannel.display.column.sendUser.label')}",//发起人
            name: 'startMemberName',
            width: '10%'
        }, {
            display: "${ctp:i18n('common.date.sendtime.label')}",//发起时间
            name: 'startDate',
            width: '12%'
        }, {
            display: "${ctp:i18n('cannel.display.column.receiveTime.label')}",//接收时间
            name: 'receiveTime',
            width: '12%'
        },{
            display: "${ctp:i18n('collaboration.col.hasten.number.label')}",//催办次数
            name: 'hastenTimes',
            width: '10%'
        },{
            display: "${ctp:i18n('pending.deadlineDate.label')}",//处理期限
            name: 'nodeDeadLineName',
            width: '12%'
        },{
            display: "${ctp:i18n('common.deal.state')}",//处理状态
            name: 'subState',
            width: '10%'
        }],
        managerName : "formSectionManager",
        managerMethod : "getPendingColList",
        click :clk,
        dblclick : dblclk,
        usepager : true,
        useRp : true,
        showTableToggleBtn : true,
        callBackTotle:getCount,
        resizable : true,
        render:rend,
        vChange :true,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true
        }
      });
      loadData();
      function rend(txt, data, r, c) {
        //未读  11  加粗显示
        var subState = data.subState;
          if(data.subState === 11){
              txt = "<span class='font_bold'>"+txt+"</span>";
          }
          if(c === 0){
              //加图标
              //重要程度
              if(data.importantLevel !==""&& data.importantLevel !== 1){
                  txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt;
              }
              //附件
              if(data.hasAttsFlag === true){
                  txt = txt + "<span class='ico16 affix_16'></span>" ;
              }
              //协同类型
              if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"){
                  txt = txt+ "<span class='ico16 office"+data.bodyType+"_16'></span>";
              }
              //流程状态
              if(data.state){
                  txt = "<span class='ico16  flow"+data.state+"_16 '></span>"+ txt ;
              }
              return "<div class = 'grid_black'>" + txt + "</div>";
          }else if(c === 6){
            var titleTip = data.subState;
            if (subState === 16 || subState === 17 || subState === 18 ) {
               titleTip  = 16;
            };
            var toolTip = $.i18n('collaboration.toolTip.label' + titleTip);
            
            if(subState === 12){
                return "<span class='ico16 viewed_16' title='"+ toolTip +"'></span>" ;
            }else{
                return "<span class='ico16 pending" + subState + "_16' title='"+ toolTip +"'></span>" ;
            }
          }else{
              return txt;
          }
      }
      function clk(data, r, c) {
          var url = "${path}/collaboration/collaboration.do?method=summary&openFrom=listPending&isDialog=true&affairId="+data.affairId+"&processId="+data.processId;
          var title = data.subject;
          showSummayDialogByURL1(url,title);
      }
      function dblclk(data, r, c){
      }
});

function showSummayDialogByURL1(url,title){
  var parmas = [$('#summary'),$('.slideDownBtn'),$('#mytable')];
  getCtpTop().showSummayDialogByURL(url,title,parmas);
}

function getCount(){
  if (!isfirst){
    parent.parent.formFlow();
  }
}

function loadData(){
    var o = new Object();
    o.templateId = '${param.templateId}';
    o.method = '${param.method}';
    $("#mytable").ajaxgridLoad(o);
}
</script>
<body>
<div id='layout' class="comp page_color" comp="type:'layout'">
    <div  id="center" class="layout_center page_color over_hidden" layout="border:false">
        <table class="flexme3" style="display: none" id="mytable"></table>
    </div>
</div>
</body>
</html>