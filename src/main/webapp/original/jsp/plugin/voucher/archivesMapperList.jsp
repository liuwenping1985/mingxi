<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>

<style>
    .stadic_head_height{
        height:0px;
    }
    .stadic_body_top_bottom{
        bottom: 37px;
        top: 0px;
    }
    .stadic_footer_height{
        height:37px;
    }
</style>
<script type="text/javascript"
    src="${path}/ajax.do?managerName=archivesMapperManager"></script>
<script type="text/javascript">
var flag=false;
$().ready(function() {
    var archivesMapper=new archivesMapperManager(); 
    var total = '${ctp:i18n("info.totally")}';
    $("#accountCfgForm").hide();    
    $("#button").hide();

    $("#btnok").click(function() { 
      if(!($("#accountCfgForm").validate())){  
        return;
      }
         if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();   
           
       archivesMapper.saveArchivesMapper($("#addForm").formobj(),{
              success: function() {
                try {getCtpTop().endProc();}catch(e) {}
                       $("#mytable").ajaxgridLoad(o);
                       location.reload();
     }
          });
     });
    function addform(){
        $("#accountCfgForm").clearform({clearHidden:true});
        $("#accountCfgForm").enable();
        $("#welcome").hide();
        $("#accountCfgForm").show();
        $("#button").show();
        var name="${ctp:i18n('voucher.plugin.cfg.archivesMapper.dataItemTarget')}";
        $("#append").html("<div class='common_txtbox_wrap' style='width: 195px'><input type='text' id='dataItemTarget' class='validate word_break_all' name='"+name+"' validate='notNull:true,minLength:1,maxLength:80'></div>");
        mytable.grid.resizeGridUpDown('middle');
    }
    $("#toolbar").toolbar({
        toolbar: [{
            id: "add",
            name: "${ctp:i18n('common.toolbar.new.label')}",
            className: "ico16",
            click: function() {
                addform();
            }
        },
        {
            id: "modify",
            name: "${ctp:i18n('common.button.modify.label')}",
            className: "ico16 editor_16",
            click: griddbclick
        },
        {
            id: "delete",
            name: "${ctp:i18n('common.button.delete.label')}",
            className: "ico16 del_16",
            click: function() {
                var v = $("#mytable").formobj({
                    gridFilter : function(data, row) {
                      return $("input:checkbox", row)[0].checked;
                    }
                  });
                if (v.length < 1) {
                    $.alert("${ctp:i18n('level.delete')}");
                } else {
                    $.confirm({
                        'msg': "${ctp:i18n('voucher.plugin.cfg.sure.delete')}",
                        ok_fn: function() {
                            var r=archivesMapper.isBuiltInData(v);
                            if(r!=null){
                                $.alert(r.name+"${ctp:i18n('voucher.plugin.cfg.archivesMapper.indata')}");
                            }else{
                                archivesMapper.deleteArchivesMapper(v, {
                                    success: function() {
                                        $("#mytable").ajaxgridLoad(o);
                                        $("#postform").hide();
                                        $("#button").hide();
                                        $("#welcome").show();
                                        $("#accountCfgForm").hide();
                                    }
                                  });
                            }
                        }
                    });
                };
            }
        }]
    });

    var mytable = $("#mytable").ajaxgrid({
        click: gridclk,       
        dblclick:griddbclick,       
        colModel: [{
            display: 'id',
            name: 'id',
            width: '5%',
            sortable: false,
            align: 'center',
            type: 'checkbox'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.archivesMapper.name')}",
            sortable: true,
            name: 'name',
            width: '10%'
        },
        {
            display:  "${ctp:i18n('voucher.plugin.cfg.archivesMapper.code')}",
            sortable: true,
            name: 'code',
            width: '10%'
        },
        {
            display:  "${ctp:i18n('voucher.plugin.cfg.archivesMapper.formName')}",
            sortable: true,
            name: 'formName',
            width: '20%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.archivesMapper.tableName')}",
            sortable: true,
            name: 'tableName',
            width: '10%'
        },
        {
            display:  "${ctp:i18n('voucher.plugin.cfg.archivesMapper.dataItemMapped')}",
            sortable: true,
            name: 'dataItemMapped',
            width: '15%'          
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.archivesMapper.dataItemTarget')}",
            sortable: true,
            name: 'dataItemTarget',
            width: '15%'          
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.archivesMapper.updateTime')}",
            sortable: true,
            name: 'updateTime',
            width: '15%'          
        }
        ],
        managerName: "archivesMapperManager",
        managerMethod: "showArchivesMapperList",
        parentId:'center',
        callBackTotle:getCount,
        slideToggleBtn: true,
        vChange: true       
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    mytable.grid.resizeGridUpDown('middle');
    function gridclk(data, r, c) {
        var mpostdetil = archivesMapper.viewArchivesMapper(data.id);
        var name="${ctp:i18n('voucher.plugin.cfg.archivesMapper.dataItemTarget')}";
        var byname="${ctp:i18n('voucher.plugin.cfg.archivesMapper.byname')}";
        var bycode="${ctp:i18n('voucher.plugin.cfg.archivesMapper.bycode')}";
        if(mpostdetil.code=="001"||mpostdetil.code=="002"||mpostdetil.code=="003"){
            $("#append").html("<div style='width: 195px'><select id='dataItemTarget' name='"+name+"' class='w100b'><option value='"+bycode+"'>"+bycode+"</option><option value='"+byname+"'>"+byname+"</option></select>");
        }else{
            $("#append").html("<div class='common_txtbox_wrap' style='width: 195px'><input type='text' id='dataItemTarget' class='validate word_break_all' name='"+name+"' validate='notNull:true,minLength:1,maxLength:80'></div>");
        }
        $("#addForm").fillform(mpostdetil);
        $("#accountCfgForm").disable();
        $("#accountCfgForm").show();
        $("#button").hide();
        $("#welcome").hide();
        mytable.grid.resizeGridUpDown('middle');
    }
  //搜索框
    var searchobj = $.searchCondition({
      top: 7,
      right: 10,
      searchHandler: function() {
        s = searchobj.g.getReturnValue();        
        $("#mytable").ajaxgridLoad(s);       
      },
      conditions: [{
          id: 'search_name',
          name: 'search_name',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.archivesMapper.name')}",
          value: 'name',
          maxLength:100
        },
      {
        id: 'search_code',
        name: 'search_code',
        type: 'input',
        text: "${ctp:i18n('voucher.plugin.cfg.archivesMapper.code')}",
        value: 'code',
        maxLength:40
      },
      {
        id: 'search_formName',
        name: 'search_formName',
        type: 'input',
        text: "${ctp:i18n('voucher.plugin.cfg.archivesMapper.formName')}",
        value: 'formName',
        maxLength:100
      },
        {//更新时间查询
            id: 'search_updateTime',
            name: 'search_updateTime',
            type: 'datemulti',
            text: "${ctp:i18n('voucher.plugin.cfg.archivesMapper.updateTime')}",
            value: 'updateTime',
            ifFormat:'%Y-%m-%d',
            dateTime: false
        }]
    });
    function griddbclick() {
        var v = $("#mytable").formobj({
            gridFilter : function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
        
        if (v.length < 1) {
            $.alert("${ctp:i18n('post.chosce.modify')}");
        }else if(v.length > 1){
            $.alert("${ctp:i18n('once.selected.one.record')}");
        }else{
            mytable.grid.resizeGridUpDown('middle');
            var mpostdetil = archivesMapper.viewArchivesMapper(v[0]["id"]);
            $("#accountCfgForm").clearform({clearHidden:true});
            var name="${ctp:i18n('voucher.plugin.cfg.archivesMapper.dataItemTarget')}";
            var byname="${ctp:i18n('voucher.plugin.cfg.archivesMapper.byname')}";
            var bycode="${ctp:i18n('voucher.plugin.cfg.archivesMapper.bycode')}";
            if(mpostdetil.code=="001"||mpostdetil.code=="002"||mpostdetil.code=="003"){
                $("#append").html("<div style='width: 195px'>&nbsp;<select id='dataItemTarget' name='"+name+"' class='w100b'><option value='"+bycode+"'>"+bycode+"</option><option value='"+byname+"'>"+byname+"</option></select>");
                $("#accountCfgForm").disable();
                $("#dataItemTarget").enable();
            }else{
                $("#append").html("<div class='common_txtbox_wrap' style='width: 195px'><input type='text' id='dataItemTarget' class='validate word_break_all' name='"+name+"' validate='notNull:true,minLength:1,maxLength:80'></div>");
                $("#accountCfgForm").enable();
            }
            $("#addForm").fillform(mpostdetil);         
            $("#accountCfgForm").show();
            $("#button").show();
            $("#welcome").hide();
        }
    }

    $("#btncancel").click(function() {
        location.reload();
    });
    function getCount(){
        $("#count")[0].innerHTML = total.format(mytable.p.total);
    }
        
});
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_voucher_archivesMapper'"></div>
    <div class="layout_north" layout="height:40,sprit:false,border:false">        
        <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
        <div id="grid_detail" class="relative" style="overflow-y:hidden">
            <div class="stadic_layout">
                <div class="stadic_layout_head stadic_head_height">
                    <div id="welcome">
                            <div class="color_gray margin_l_20">
                                <div class="clearfix">
                                    <h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;">
                                        ${ctp:i18n("voucher.plugin.cfg.archivesmapper")}
                                    </h2>
                                    <div class="font_size12 left margin_t_20 margin_l_10">
                                        <div class="margin_t_10 font_size14">
                                            <span id="count"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="line_height160 font_size14">
                                    ${ctp:i18n("voucher.achr_detail")}
                                </div>
                            </div>
                     </div>
                </div>
                <div class="stadic_layout_body stadic_body_top_bottom">                   
                    <div id="accountCfgForm" class="form_area" style="overflow-y:hidden">
                        <%@include file="archivesMapperForm.jsp"%></div>
                    </div>
                <div class="stadic_layout_footer stadic_footer_height">
                    <div id="button" align="center" class="page_color button_container">
                        <div class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">                           
                            <a id="btnok" href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
                            <a id="btncancel" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>