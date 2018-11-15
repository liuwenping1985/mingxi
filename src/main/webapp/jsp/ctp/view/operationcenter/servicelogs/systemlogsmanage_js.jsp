<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=systemLogsManager"></script>
<script type="text/javascript">
var systemLogsManager = new systemLogsManager();
var mytable;
//树结构参数
/*var nodes = [{
    id:0,name:"00000",isParent:true
},{
  id:1,name:"11111",isParent:true
},{
    id:2,name:"22222",isParent:false
}];*/
//树刷新方法
function refleshTree(o){
    $("#"+o).treeObj().reAsyncChildNodes(null, "refresh");
}
$().ready(function() {
  //$.fn.zTree.init($("#tree"), {}, nodes);
  $("#tree").empty();
    $("#tree").tree({
      onClick : clk,//1
      //managerName : "systemLogsManager",//4
      //managerMethod : "getSystemLogEnumList",//5
      idKey : "type",
      pIdKey : "parentid",
      nameKey : "display",
      enableCheck : false,//6
      enableEdit : false,//7
      enableRename : false,//8
      enableRemove : false,//9
      nodeHandler : function(n) {//11
        n.open = false;//12
        n.isParent = true;
      },
      render : function(name, data) {//14
        return data.orgid + " - " + name;
      }
    });
    refleshTree("tree");
    function clk(e, treeId, node) {
      //alert($.toJSON(node.data));
      //node.children[0].data 取第0个子节点的数据对象
        var o = {"type":node.data.type};
      $("#mytable").ajaxgridLoad(o);
    }
    mytable = $("#mytable").ajaxgrid({
    /* click : clk, */
    colModel: [{
      display: 'id',
      name: 'logstype',
      width: '5%',
      sortable: false,
      align: 'center',
      type: 'checkbox'
    },{
      display: "${ctp:i18n('systemlogsmanage.classification.title')}",
      name: 'name',
      sortable: true,
      width: '40%'
    },{
        display: "时间",
        name: 'time',
        sortable: true,
        width: '54%'
      }],
      width: 'auto',
      parentId: "roleList_stadic_body_top_bottom",
      managerName: "systemLogsManager",
      managerMethod: "logsList",
      vChangeParam: {
        overflow: "hidden",
        autoResize: true
      },
      resizeGridUpDown:"down",
      slideToggleBtn: true,
      showTableToggleBtn: true,
      isHaveIframe:true,
      vChange: true
   });
   reloadtab();
   
  var searchobj;
  var ver = "${ctp:getSystemProperty('org.isGroupVer')}";
  var topSearchSize = 2;
  if($.browser.msie && $.browser.version=='6.0'){
      topSearchSize = 5;
  }
   
 
  // 工具栏
  var toolbar = $("#toolbar").toolbar({
    toolbar: [{
      id: "export1",
      name: "${ctp:i18n('systemlogsmanage.export.info')}",
      className: "ico16 import_16",
      click: function() {
        exportlogs();
      }
    },
    /*{
        id: "view",
        name: "${ctp:i18n('systemlogsmanage.view.info')}",
        className: "ico16 search_16",
        click: function() {
          seelogs();
        }
      },*/
    {
      id: "delmodify",
      name: "${ctp:i18n('systemlogsmanage.delete.info')}",
      className: "ico16 del_16",
      click: function() {
       dellogs();
      }
    }
    ]
  });
  var searchobj = $.searchCondition({
      top: 7,
      right: 10,
      searchHandler: function() {
        s = searchobj.g.getReturnValue();
        s.type = getLogtype();
        $("#mytable").ajaxgridLoad(s);       
      },
      conditions: [
        {//更新时间查询
            id: 'search_update',
            name: 'search_update',
            type: 'datemulti',
            text: "日期",
            value: 'search',
            ifFormat:'%Y-%m-%d',
            dateTime: false
        }]
    });
  
  //查看
function seelogs(){
  if(!isCanOpeSingle(true)){
    return;
  }
  var logstype = getCheckboxValue(1);
       var dialog = $.dialog({
            url: _ctxPath + '/systemlogsmanage.do?method=conditionsLog&link=seelogs&logstype='+logstype,
            width: 400,
            height: 340,
            isDrag:false,
            title: "${ctp:i18n('systemlogsmanage.condition.info')}",
            targetWindow: getCtpTop(),
            transParams:{
              logstype:logstype
            },
            buttons: [{
              id: "btnok",
              text: "${ctp:i18n('common.button.ok.label')}",
              handler: function() {
                
                var conditions = dialog.getReturnValue();
                  if (conditions==undefined||conditions.valid) {
                    return;
                  }
                var date=new Date();
              var today=date.print("%Y-%m-%d");

              var fn = conditions.log_type_info;
              var date = conditions.fromdate;
              var index = conditions.log_index;
              var url = null;
              if(today == date){
                url = "logs/" + fn + ".log";
              }
              else{
                url = "logs/" + date + "/" + fn + ".log." + date + "." + index + ".log";
              }
              //window.open(url);
              var seelogsUrl = _ctxPath + '/systemlogsmanage.do?method=seelogs&filename='+url;
              $("#bottomIframe").attr("src",seelogsUrl);
              dialog.close();
                }     
            },
            {
              id:"btncancel",
              text: "${ctp:i18n('systemswitch.cancel.lable')}",
              handler: function() {
                dialog.close();
              }
            }]
          }); 
    
  }
  
  //导出
function exportlogs(){
    if(!isCanOpeMulti(true)){
        return;
    }
    var tform = $("#tempForm");
    tform.empty();
    var fileNames = getCheckboxValue(2);
    if(fileNames!=null && fileNames.length>0){
      var tempstring = [];
      for(var i=0,len=fileNames.length; i<len; i++){
        tempstring.push('<input name="filename" value="'+fileNames[i]+'"/>');
      }
      tform.html(tempstring.join(""));
      tform.submit();
    }
    tform = null;
}

  //删除
function dellogs() {
    if(!isCanOpeMulti(true)){
        return;
    }
    var filenames = getCheckboxValue(2);
    if(filenames==null || filenames.length<=0){
      return;
    }
    var cannotDelLogname = getLogtype()+".log", fileNameLen = cannotDelLogname.length;
    var hasCannotDel = false;
    for(var i=0,len=filenames.length; i<len; i++){
      if(filenames[i].lastIndexOf(cannotDelLogname)==(filenames[i].length-fileNameLen)){
        hasCannotDel = true;
        break;
      }
    }
    var tempTitle = "";
    if(hasCannotDel){
        if(filenames.length==1){
          tempTitle = "日志文件:"+cannotDelLogname+"正被系统占用，无法删除。";
            $.alert(tempTitle);
            return;
        }else{
          tempTitle = "日志文件:"+cannotDelLogname+"正被系统占用，无法删除。其他日志文件删除后将不能恢复，是否继续？";
        }
      $.confirm({
        msg:tempTitle
            ,ok_fn:function(){
                __dellongs(filenames);
            }
        });
      return;
    }else{
      tempTitle = "删除后将不能恢复，是否继续？";
    }
    $.confirm({
      msg:tempTitle
      ,ok_fn:function(){
        __dellongs(filenames);
      }
    });
}
function __dellongs(filenames){
  $.ajax({
        'url':_ctxPath + '/systemlogsmanage.do?method=delLogs'
        ,'cache':false
        ,'method':'post'
        ,'data':{
            'filename':filenames
        }
        ,success:function(msg){
            try{
                var obj = $.parseJSON(msg);
                if(obj.success){
                    $.alert(obj.msg);
                }
            }catch(e){}
            reloadtab();
        }
    });
}

//获取选中
function getTableChecked() {
  return $(".mytable").formobj({
    gridFilter: function(data, row) {
      return $("input:checkbox", row)[0].checked;
    }
  });
}

  
//加载列表
function reloadtab(){
    var o = new Object();
    //o.type = "${ctp:i18n('systemlogsmanage.application.title')}";
    o.type = getLogtype();
    $("#mytable").ajaxgridLoad(o);
    mytable.grid.resizeGridUpDown('down');
}
  
//返回查询结果
  function selectResult(condition, value){
   var fromDate = $('#from_datetime').val();
      var toDate = $('#to_datetime').val();
      var boxs = $(".mytable").formobj({
        gridFilter : function(data, row) {
            return $("input:checkbox", row)[0].checked;
        }
    });
      if (fromDate==""|| toDate==""||boxs.length==0) {
          return $.alert("${ctp:i18n('systemlogsmanage.prompt.info')}");
      }
      
      var logTypeinfo="";
      if(boxs.length<2){
        logTypeinfo=boxs[0].id;
      }else{
        logTypeinfo="all";
         }
  
  var dialog = $.dialog({
    url: _ctxPath+ '/systemlogsmanage.do?method=selectLogs&startDay='+fromDate+'&endDay='+toDate+'&type='+logTypeinfo,
    width : 400,
    height : 340,
    isDrag : true,
    targetWindow : getCtpTop(),
    title : "${ctp:i18n('systemlogsmanage.information.info')}",
    buttons : [
        {
          id : "btncancel",
          text : "${ctp:i18n('systemswitch.cancel.lable')}",
          handler : function() {
            dialog.close();
          }
        } ]

  });
  }
  $(".slideUpBtn").click();
});
function isCanOpeSingle(flag){
  var result = true, errorMsg = "";
  var tempCheckObj = $("#mytable :checkbox:checked");
  if(tempCheckObj.size()<=0){
    result = false;
    errorMsg = "请至少选择一项！";
  }else if(tempCheckObj.size()>1){
    result = false;
        errorMsg = "请只选择一项！";
  }
  tempCheckObj = null;
  if(flag==true && result==false){
    $.alert(errorMsg);
  }
  return result;
}
function isCanOpeMulti(flag){
    var result = true, errorMsg = "";
    var tempCheckObj = $("#mytable :checkbox:checked");
    if(tempCheckObj.size()<=0){
        result = false;
        errorMsg = "请至少选择一项！";
    }
    if(flag==true && result==false){
        $.alert(errorMsg);
    }
    tempCheckObj = null;
    return result;
}
function getCheckboxValue(flag){
  var result = null;
  var tempCheckObj = $("#mytable :checkbox:checked");
  if(tempCheckObj.size()>0){
      if(flag==1){
          //取单个
        result = tempCheckObj.eq(0).val();
      }else if(flag==2){
        //取多个
        result = [];
        tempCheckObj.each(function(){
          result.push($(this).val());
        });
      }
  }
  tempCheckObj = null;
  return result;
}
function getLogtype(){
  var nodes = $("#tree").treeObj().getSelectedNodes();
  if(nodes==null || nodes.length==0){
    return "ctp";
  }else{
    return nodes[0].data.type;
  }
}
</script>