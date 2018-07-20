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
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<script type="text/javascript" src="${path}/ajax.do?managerName=superviseManager"></script>
<html>
<head>
<title></title>
<script text="text/javascript">
  var grid;
  $(function() {
    grid = $("table.flexme3").ajaxgrid({
      parentId : "center",
      colModel : [
      { display : "${ctp:i18n('supervise.subject.label')}",     
        name : 'title',
        width : '18%'
      },
      { display : "${ctp:i18n('supervise.sender.label')}",        
        name : 'senderName',
        width : '12%'
      },
      { display : "${ctp:i18n('supervise.date.sendtime.label')}",       
        name : 'sendDate',
        width : '12%',
        cutsize : 10
      },  
      { display : "${ctp:i18n('supervise.process.cycle.label')}",       
        name : 'deadlineName',
        width : '12%'
      },  
      { display : "${ctp:i18n('supervise.col.deadline')}",       
        name : 'awakeDate',
        width : '12%'
      },  
      { display : "${ctp:i18n('supervise.hasten.label')}",       
        name : 'count',
        width : '12%'
      },  
      { display : "${ctp:i18n('supervise.form.bind.flow.label')}",       
        name : '',
        width : '12%'
      },  
      { display : "${ctp:i18n('supervise.col.description')}",       
        name : '',
        width : '10%'
      }
      ],
      click : toDetailPage,
      render : rend,
      showTableToggleBtn: true,
      vChange: true,
      isHaveIframe:true,
      managerName : "formSectionManager",
      managerMethod : "getSuperviseColList"
    });
    loadData();
    function rend(txt, data, r, c) {
        if(c == 0){
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
            //流程状态
            if(data.state !== null && data.state !=="" && data.state!== undefined){
                txt = "<span class='ico16  flow"+data.state+"_16 '></span>"+ txt ;
            }
            return "<div class = 'grid_black'>" + txt + "</div>";
        }else if(c==4){
            //督办期限
            if(data.status == 1){
                if(data.isRed){
                    return "<font color='red'>"+txt+"</font>";
                }else{
                    return txt;
                }
            }else{
                if(data.isRed){
                    return "<a id='ssss"+data.id+"' class='noClick' href='javascript:void(0)' onclick='changeAwake(event,\""+data.id+"\")'><font color='red'>"+txt+"</font></a>";
                }else{
                    return "<a id='ssss"+data.id+"' class='noClick' href='javascript:void(0)' onclick='changeAwake(event,\""+data.id+"\")'>"+txt+"</a>";
                }
            }
       }else if(c==5){
          //催办次数
          var id = data.id;
          if(data.status == 1){
              return "<a href='javascript:void(0)' onclick='showSuperviseLog(\""+id+"\")'>"+txt+"次</a>";
          }else{
              return "<a href='javascript:void(0)' onclick='showSuperviseLog(\""+id+"\")'>"+txt+"次</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='ico16 notify_16' onclick='showWFCDiagram(top,\""+data.caseId+"\",\""+data.processId+"\",false,true,\""+data.id+"\",null,\"collaboration\")'></a>";
          }
      }else if(c==6){
          return "<a href='javascript:void(0)' class='ico16 process_16' onclick='superviousWFCDiagram(top,\""+data.caseId+"\",\""+data.processId+"\",\""+data.isTemplate+"\",window,\"collaboration\",\""+data.flowPermAccountId+"\");'></a>";
      }else if (c == 7){
          var summaryId = data.summaryId;
          var id = data.id;
          return "<a href='javascript:void(0)' onclick='superviseContent(\""+summaryId+"\","+data.status+",\""+id+"\")'>[${ctp:i18n('phrase.title.content.label')}]</a>";
      }
      return txt;
    }
  
    function toDetailPage(data, rowIndex, colIndex) {
      if(colIndex>3 || colIndex <0){
        return;
      }
        var url = "${path}/"+data.detailPageUrl+"&affairId=&summaryId="+data.summaryId+"&openFrom=supervise&casetId="+data.caseId+"&processId="+data.processId+"&type="+0;
        var title = data.title;
        var dialog = $.dialog({
            url: url,
            width: $(top).width()-100,
            height: $(top).height()-100,
            targetWindow:getCtpTop(),
            title: title,
            buttons: [{
                text: "${ctp:i18n('common.button.close.label')}",
                handler: function () {
                   dialog.close();
                }
            }]
        });
    }
  });
  
  
  function getCurrentTime(){
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth()+1; 
    var day = date.getDate();
    var hour = date.getHours();       
    var time = year+"-"+month+"-"+day+" "+hour+":"+"00";
    return time;
  }
  
  function getCurrentDate(){
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth()+1; 
    var day = date.getDate();
    var date = year+"-"+month+"-"+day;
    return date;
  }
  var changeAwakeID;
  function changeAwake(e,id){
    changeAwakeID=id;
    var time = getCurrentTime();
    $.calendar({
      displayArea:"ssss"+id,
      returnValue: true,
      ifFormat:"%Y-%m-%d %H:%M",
      daFormat:"%Y-%m-%d %H:%M",
      dateString:time,
      singleClick:true,
      showsTime:true,
      onUpdate:getDateTime,
      autoShow:true,
      isClear:true
    });
  }
  function getDateTime(awake){
    var date1 = getCurrentDate();;
    var date1s = date1.split("-");
    var bdate = new Date(date1s[0],date1s[1]-1,date1s[2]);
    var date2 = awake.substring(0,10);
    var date2s = date2.split("-");
    var edate = new Date(date2s[0],date2s[1]-1,date2s[2]);
    var url = _ctxPath + "/supervise/supervise.do?method=modifySupervise&srcFrom=bizconfig&superviseId="+changeAwakeID+"&awakeDate="+awake+"&app=1";
    var sup = new superviseManager();
    if(bdate.getTime() > edate.getTime()){
        var confirm = $.confirm({
            'msg': '${ctp:i18n("collaboration.common.supervise.thisTimeXYouset")}', //您设置的督办日期小于当前日期,是否继续?
            ok_fn: function () { 
		      sup.changeAwakeDate(changeAwakeID,awake);
              loadData();
            },
            cancel_fn:function(){
                confirm.close();
            }
        });
    }else{
      sup.changeAwakeDate(changeAwakeID,awake);
      loadData();
    }
  }
  
  function getTime(awake){
    var date1 = getCurrentDate();;
    var date1s = date1.split("-");
    var bdate = new Date(date1s[0],date1s[1]-1,date1s[2]);
    
    var date2 = awake.substring(0,10);
    var date2s = date2.split("-");
    var edate = new Date(date2s[0],date2s[1]-1,date2s[2]);
    var url = "${path}/supervise/supervise.do?method=modifySupervise&srcFrom=bizconfig&superviseId="+changeAwakeID+"&awakeDate="+awake+"&app=${param.app}";
    if(bdate.getTime() > edate.getTime()){
      
      $.messageBox({
        'type' : 1,
        'msg' : '${ctp:i18n("formsection.infocenter.alertTimeIsOverDue")}',
        ok_fn : function() {
          $("#changeTime").prop("src",url);
          loadData();
        }
      });
      
    }else{
         $("#changeTime").prop("src",url);
         loadData();
    }
    
  }
 
  //催办日志
  function showSuperviseLog(superviseId){
    var url = "${path}/supervise/supervise.do?method=showLog&superviseId="+superviseId;
    var dialog = $.dialog({
      url : url,
      width : 815,
      height : 500,
      targetWindow:getCtpTop(),
      title : "${ctp:i18n('supervise.col.title.label')}"
    });
    
  }

  //督办摘要
  function superviseContent(summaryId,status,superviseId){
    var url = _ctxPath + "/supervise/supervise.do?method=showDescription&summaryId="+summaryId+"&superviseId="+superviseId;
    var but = new Array();
    var dialogs = "";
    //当是未办结状态时，才显示确定按钮
    if(status == 0){
        but.push({
            text : "${ctp:i18n('common.button.ok.label')}",
            handler : function() {
                var returnValue = dialogs.getReturnValue();
                if(returnValue != null){
                    var map =  $.parseJSON(returnValue); 
                    var content = map.content;
                    var url = _ctxPath + "/supervise/supervise.do?method=updateContent&content=" + content + "&superviseId=" + map.superviseId;
                    $("#grid_detail").jsonSubmit({
                         action : url,
                         callback:function(){
                           loadData();
                         } 
                    });
                    dialogs.close(); 
                }
            }
        });
    }
    but.push({
          text : "${ctp:i18n('common.button.cancel.label')}",
          handler : function() {
            dialogs.close();
          }
        });
    //督办摘要 弹出dialog
    dialogs = $.dialog({
      url : url,
      width : 500,
      height : 350,
      targetWindow:getCtpTop(),
      title : "${ctp:i18n('supervise.col.label')}",
      buttons : but
    });
  }
  
</script>
</head>
<body>
<div id='layout' class="comp page_color" comp="type:'layout'">
    <div  id="center" class="layout_center page_color over_hidden" layout="border:false">
        <table class="flexme3" style="display: none" id="mytable"></table>
    </div>
</div>
    <div>
    <table class="flexme3" style="display: none" id="superviseList"></table>
    </div>      
<iframe id="changeTime" width="0" height="0" style="display: none;"></iframe>
<script type="text/javascript">
function loadData(){
    var o = new Object();
    o.templateId = '${param.templateId}';
    o.method = '${param.method}';
    $("#mytable").ajaxgridLoad(o);
}
</script>
</body>
</html>