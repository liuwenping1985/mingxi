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
<body>
<div id='layout' class="comp page_color" comp="type:'layout'">
    <div  id="center" class="layout_center page_color over_hidden" layout="border:false">
        <table class="flexme3" style="display: none" id="mytable"></table>
    </div>
</div>
<script type="text/javascript">
$(document).ready(function(){
    $("table.flexme3").ajaxgrid({
      parentId : "center",
        colModel : [{
            display: '${ctp:i18n("common.subject.label")}',//标题
            name: 'subject',
            width: '34%'
        }, {
            display: '${ctp:i18n("cannel.display.column.sendUser.label")}',//发起人
            name: 'startMemberName',
            width: '14%'
        }, {
            display: '${ctp:i18n("common.date.sendtime.label")}',//发起时间
            name: 'startDate',
            width: '12%'
        }, {
            display: '${ctp:i18n("common.date.donedate.label")}',//处理时间
            name: 'dealTime',
            width: '12%'
        },{
            display: '${ctp:i18n("pending.deadlineDate.label")}',//处理期限
            name: 'deadLineDateName',
            width: '12%'
        },{
            display : '${ctp:i18n("formsection.infocenter.isend")}',
            name : 'state',
            width : '8%',
            sortable : true,
            align : 'left'
        },{
            display: '${ctp:i18n("collaboration.isTrack.label")}',//跟踪状态
            name: 'isTrack',
            width: '8%'
        }],
        managerName : "formSectionManager",
        managerMethod : "getDoneColList",
        click :clk,
        dblclick : dblclk,
        usepager : true,
        useRp : true,
        showTableToggleBtn : true,
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
          if(c === 0){
	            //如果是代理 ，颜色变成蓝色
	            if(data.proxy){
	                txt = "<span class='color_blue'>"+txt+"</span>";
	            }
	          //加图标
              //重要程度
              if(data.importantLevel !==""&& data.importantLevel !== 1){
                  txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt ;
              }
              //附件
              if(data.hasAttsFlag === true){
                  txt = txt + "<span class='ico16 affix_16'></span>" ;
              }
              //协同类型
              if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"){
                  txt = txt+ "<span class='ico16 office"+data.bodyType+"_16'></span>";
              }
              return "<div class = 'grid_black'>" + txt + "</div>";
          }else if(c === 5 ){
              //流程状态
              if(data.state ==="3" || data.state === 3){
                  txt = "${ctp:i18n('systemswitch.yes.lable')}";
              }else{
                  txt="${ctp:i18n('systemswitch.no.lable')}";
              }
          }else if(c === 6){
              if(txt === null || txt === false){
                  return "${ctp:i18n('systemswitch.no.lable')}";
              }else{
                  return "${ctp:i18n('systemswitch.yes.lable')}";
              }
          }else{
              return txt;
          }
          return txt;
      }
      function clk(data, r, c) {
          var url = "${path}/collaboration/collaboration.do?method=summary&openFrom=listDone&summaryId="+data.workitemId+"&affairId="+data.affairId+"&processId="+data.processId;
          var title = data.subject;
          doubleClick(url,title);
      }
      function dblclk(data, r, c){
        clk(data, r, c);
      }
});

function loadData(){
    var o = new Object();
    o.templateId = '${param.templateId}';
    o.method = '${param.method}';
    $("#mytable").ajaxgridLoad(o);
}
</script>
</body>
</html>