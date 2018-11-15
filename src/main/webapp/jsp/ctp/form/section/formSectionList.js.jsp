<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript">
var v3x = new V3X();
var ss;
var processBar;
$(document).ready(function(){
  //搜索框
    var searchobj = $.searchCondition({
        top:7,
        right:10,
        searchHandler: function(){
            var o = new Object();
            var conditon= $('#'+searchobj.p.id).find("option:selected").val();
            if(conditon === "name"){
                o.name=$("#namesearch").val();
            }else if(conditon === "createName"){
                o.createName = $("#createNamesearch").val();
            }else if(conditon === "createDate"){
                var startTime = $('#from_datetime').val();
                var endTime = $('#to_datetime').val();
                if(startTime.trim()!=""){
                    o.startTime =startTime;
                }
                if(endTime.trim()!=""){
                    o.endTime = endTime;
                }
            }else if(conditon === "type"){
                o.type=$("#typesearch").val();
            }
            $("#mytable").ajaxgridLoad(o);
        },
        conditions: [{
            id: 'namesearch',
            name: 'namesearch',
            type: 'input',
            text: '${ctp:i18n('formsection.config.name.label') }',//标题
            value: 'name'
        },{
            id: 'createNamesearch',
            name: 'createNamesearch',
            type: 'input',
            text: '${ctp:i18n('form.section.creater.label') }',//创建人
            value: 'createName'
        },{
            id: 'datetime',
            name: 'datetime',
            type: 'datemulti',
            text: '${ctp:i18n('form.section.create.date.label') }',//发起时间
            value: 'createDate',
            dateTime: false,
            ifFormat:'%Y-%m-%d'
        },{
            id: 'typesearch',
            name: 'typesearch',
            type: 'select',
            text: '${ctp:i18n('formsection.config.type') }',//创建人
            value: 'type',
            items:[{
                text:'${ctp:i18n('formsection.config.type0.label')}',
                value:0
            },
            {text:'${ctp:i18n('formsection.config.type1.label')}',
                value:1
            },{
                text:'${ctp:i18n('formsection.config.type2.label')}',
                value:2
            },
            {
                text:'${ctp:i18n('formsection.config.type3.label')}',
                value:3
            }]
        }]
    });
          ss = $("table.flexme3").ajaxgrid({
              parentId : "center",
            colModel : [ {
              display : 'id',
              name : 'id',
              width : '5%',
              sortable : false,
              align : 'center',
              type : 'checkbox'
            }, {
              display : '${ctp:i18n('formsection.config.name.show') }',
              name : 'name',
              width : '47%',
              sortable : true,
              align : 'left'
            }, {
              display : '${ctp:i18n('form.section.creater.label') }',
              name : 'createName',
              width : '10%',
              sortable : true,
              align : 'left'
            }, {
              display : '${ctp:i18n('form.section.create.date.label') }',
              name : 'createDate',
              width : '20%',
              sortable : true,
              align : 'center'
            }, {
              display : '${ctp:i18n('formsection.config.type') }',
              name : 'formType',
              width : '17%',
              sortable : true,
              align : 'left'
            }],
            managerName : "formSectionManager",
            managerMethod : "getFormSectionList",
            click :clk,
            dblclick : dblclk,
            usepager : true,
            useRp : true,
            showTableToggleBtn : true,
            resizable : true,
            render:rend,
            callBackTotle:getCount,
            vChange :true,
            vChangeParam: {
                overflow: "hidden",
                autoResize:true
            },
            showToggleBtn: false,
          slideToggleBtn: true
          });
          loadData();
          function rend(txt, data, r, c) {
              if(c===4){
                  return $.i18n('formsection.config.type'+txt+'.label');
              } else if (c==1){
                  return "<div class = 'grid_black'>" + txt + "</div>";
              }else{
                  return txt;
              }
          }
          function clk(data, r, c) {
              $("#viewFrame").prop("src","${path }/form/formSection.do?method=show&type=view&id="+data.id);
          }
          function dblclk(data, r, c){
              editFormSection();
          }
    //查询事件绑定
    $("#searchBtn").click(function(){
            doSearch();
    });
    $("#toolbar").toolbar({
        toolbar : [
           {
               name : "${ctp:i18n('common.toolbar.new.label')}",

               click : function() {
                  ss.grid.resizeGridUpDown('middle');
                   $("#viewFrame").prop("src","${path }/form/formSection.do?method=show&type=create");
               },
               className : "ico16"
            },
            {
                name:"${ctp:i18n('common.toolbar.update.label')}",
                click:function(){
                    editFormSection();
                },
                className:"ico16 editor_16"
            },{
                name:"${ctp:i18n('common.toolbar.delete.label')}",
                click:function(){
                    deleteSection();
                },
                className:"ico16 delete del_16  "
            },{
                name:"${ctp:i18n('common.toolbar.saveAs.label')}",
                click:function(){
                    saveAs();
                },
                className:"ico16 save_as_16"
            }]
        });
});
function getCount(n){
  $("#viewFrame").prop("src","${path }/form/formSection.do?method=desc&size="+n);
}
function loadData(){
      var o = new Object();
      $("#mytable").ajaxgridLoad(o);
}

function proccess(){
  //top.processBar =  $.progressBar({text: "${ctp:i18n('bizconfig.create.saveing')}"});
  //getCtpTop().startProc("${ctp:i18n('bizconfig.create.saveing')}");
  try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
  if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
}

function saveAs(){
    var obj = getSeclectSection();
    if(obj.length===0){
      $.alert('${ctp:i18n('formsection.config.choose.saveas')}');
        return;
    }
    if(obj.length>1){
      $.alert('${ctp:i18n('formsection.config.choose.saveas.more')}');
        return;
    }
        var dialog = $.dialog({
            'title' : '${ctp:i18n('common.toolbar.saveAs.label')}',
            'width':300,
            'height':100,
            targetWindow:getCtpTop(),
            'url':'${path}/form/formSection.do?method=saveAs',
            buttons : [ {
                text : "${ctp:i18n('common.button.ok.label')}",
                isEmphasize: true,
                handler : function() {
                  var div = dialog.getReturnValue();
                if(div && div.success){
                  var manager = new formSectionManager();
                  manager.doSaveAsFormSection(obj[0].id,div.value);
                   loadData();
                  dialog.close();
                    }
                }
              }, {
                text : "${ctp:i18n('common.button.cancel.label')}",
                handler : function() {
                  dialog.close();
                }
              } ]

          });
}

function doSearch(){
    var o = new Object();
    var conditon= $('#'+searchobj.p.id).find("option:selected").val();
    if(conditon === "name"){
        o.name=$("#namesearch").val();
    }else if(conditon === "createName"){
        o.createName = $("#createNamesearch").val();
    }else if(conditon === "createDate"){
        var startTime = $('#from_datetime').val();
        var endTime = $('#to_datetime').val();
        if(startTime.trim()!=""){
            o.startTime =startTime;
        }
        if(endTime.trim()!=""){
            o.endTime = endTime;
        }
    }else if(conditon === "type"){
        o.type=$("#typesearch").val();
    }
    $("#mytable").ajaxgridLoad(o);
}

function editFormSection(){
    var obj = getSeclectSection();
    if(obj.length===0){
      $.alert('${ctp:i18n('formsection.config.choose.modify.must')}');
        return;
    }
    if(obj.length>1){
      $.alert('${ctp:i18n('formsection.config.choose.modify.onlyone')}');
        return;
    }
    if(!obj[0].isCreater){
      $.alert('${ctp:i18n('formsection.config.choose.modify.no.right')}');
        return;
    }
    ss.grid.resizeGridUpDown('middle');
    $("#viewFrame").prop("src","${path }/form/formSection.do?method=show&type=edit&id="+obj[0].id);
}

function getSeclectSection(){
    var v = $("#mytable").formobj({
        gridFilter : function(data, row) {
          return $("input:checkbox", row)[0].checked;
        }
      });
    return v;
}

function deleteSection(){
    var obj = getSeclectSection();
    if(obj.length===0){
      $.alert('${ctp:i18n('formsection.config.choose.delete.must')}');
        return;
    }
    var ids = "";
    for(var i=0;i<obj.length;i++){
        if(!obj[i].isCreater){
            continue;
        }
        ids = ids+obj[i].id+",";
    }
    if(ids===""){
      $.alert('${ctp:i18n('formsection.config.choose.delete.no.right')}');
        return;
    }
    $.confirm({
        'msg' : '${ctp:i18n('formsection.config.choose.delete.confirm')}',
        ok_fn : function() {
            $("#jsonSubmit").jsonSubmit({
                action:"${path}/form/formSection.do?method=delete&ids="+ids,
                callback:function(objs){
                    loadData();
                    getCtpTop().refreshMenus();
                    $("#viewFrameDiv").hide();
                }
            });
        },
        cancel_fn:function(){
        }
    });
}

function getFormTemplete(sectionId){
    var dialog = $.dialog({
        'title' : '${ctp:i18n('formsection.config.choose.template.title')}',
        'width':600,
        'height':410,
        targetWindow:getCtpTop(),
        'url':'${path}/form/formSection.do?method=formTemplate&sectionId='+sectionId+'&templateId='+$("#viewFrame").contents().find("#templateId").val(),
        buttons : [ {
            text : "${ctp:i18n('common.button.ok.label')}",
            isEmphasize: true,
            handler : function() {
                var o = dialog.getReturnValue();
                if(o==="length"){
                    return;
                }
                if(o=="must"){
                  $.alert('${ctp:i18n('formsection.config.choose.template.must')}');
                    return;
                }
                if(o){
                  $("#viewFrame").get(0).contentWindow.chooseFormTemplet(o);
                dialog.close();
                }
            }
          }, {
              text : "${ctp:i18n('common.button.cancel.label')}",
            handler : function() {
              dialog.close();
            }
          } ]

      });
}
</script>