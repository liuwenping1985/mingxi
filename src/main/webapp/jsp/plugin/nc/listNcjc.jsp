<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<style>
.stadic_head_height{
    height:0px;
}
.stadic_body_top_bottom{
    bottom: 30px;
    top: 0px;
}
.stadic_footer_height{
    height:37px;
}
</style>
<script type="text/javascript"
src="${path}/ajax.do?managerName=ncMultiJCManager"></script>
<script type="text/javascript">
var dialog;
$().ready(function() {
	var total = '${ctp:i18n("info.totally")}';
	var pManager = new ncMultiJCManager();
	
	 $("#ncjcform").hide();
  $("#button").hide();
  
    function addform() {
    $("#ncjcform").clearform({
      clearHidden: true
    });
    $("#ncjcform").enable();
    $("#ncjcform").show();
    $("#welcome").hide();
    $("#button").show();
    $("#lconti").show();
    $("#conti").attr("checked", true);
    $("input[id=enable]:eq(0)").attr("checked", 'checked');
    $("#typeId").val(1);

  }
  
  
var toolbar = $("#toolbar").toolbar({
    toolbar: [{
      id: "add",
      name: "${ctp:i18n('common.toolbar.new.label')}",
      className: "ico16",
      click: function() {
        addform();
        mytable.grid.resizeGridUpDown('middle');
        $("#codeflg").hide();
      }
	
    },
    {
      id: "modify",
      name: "${ctp:i18n('common.button.modify.label')}",
      className: "ico16 editor_16",
      click: griddblclick

    },
    {
      id: "delete",
      name: "${ctp:i18n('common.button.delete.label')}",
      className: "ico16 del_16",
      click: function() {
        var v = $("#mytable").formobj({
          gridFilter: function(data, row) {
            return $("input:checkbox", row)[0].checked;
          }
        });

        if (v.length < 1) {
          $.alert("${ctp:i18n('ntp.multi.delete')}");

        } else {
          var postname = "";
          for (i = 0; i < v.length; i++) {
            if (i != v.length - 1) {
              postname = postname + v[i].name + "、";
            } else {
              postname = postname + v[i].name;
            }
          }

          $.confirm({
            'msg': $.i18n('ntp.multi.delete.ok.js', postname),
            ok_fn: function() {
              pManager.deleteNCConf(v, {
                success: function() {
                	location.reload();
                }
              });
            }
          });
        };
      }
    }
    ]
  });
  var mytable = $("#mytable").ajaxgrid({
  click: gridclk,
    dblclick: griddblclick,
    colModel: [{
      display: 'codeflg',
      name: 'codeflg',
      width: '5%',
      sortable: true,
      align: 'center',
      type: 'checkbox'
    },
   	{
      display: "${ctp:i18n('ntp.multi.code')}",
      name: 'id',
      width: '10%',
      sortable: true
    },
    {
      display: "${ctp:i18n('ntp.multi.name')}",
      sortable: true,
      name: 'name',
      width: '15%'
    },
    {
      display: "${ctp:i18n('ntp.multi.accountcode')}",
      sortable: true,
      name: 'accountCode',
      width: '10%'
    },
    {
      display: "URL",
      sortable: true,
      name: 'url',
      width: '20%'
    },
    {
      display: "${ctp:i18n('ntp.multi.sort')}",
      sortable: true,
      name: 'sort',
      sortname: 'sort',
      sortType: 'number',
      width: '5%'
    } ,
    {
      display: "${ctp:i18n('ntp.multi.enable')}",
      sortable: true,
      codecfg: "codeId:'common.enabled'",
      name: 'enable',
      sortname: 'enable',
      width: '10%'
    },
    {
      display: "${ctp:i18n('ntp.multi.description')}",
      sortable: true,
      name: 'description',
      width: '25%'
    }  ],
    managerName: "ncMultiJCManager",
    managerMethod: "showNCConfList",
    parentId: 'center',
    vChangeParam: {
      overflow: 'hidden',
      position: 'relative'
    },
    slideToggleBtn: true,
    showTableToggleBtn: true,
    callBackTotle:getCount,
    vChange: true
  });
  var o = new Object();
  $("#mytable").ajaxgridLoad(o);
  mytable.grid.resizeGridUpDown('middle');
  
 $("#btncancel").click(function() {
    location.reload();
  });
   $("#btnok").click(function() {
    if (! ($("#ncjcform").validate())) {
      return;
    }
   if (getCtpTop() && getCtpTop().startProc) getCtpTop().startProc();
    pManager.createNCConf($("#addForm").formobj({
      includeDisabled: true
    }), {
      success: function(rel) {
      	  var error = false;
      	 if (rel == "iderror") {
                $.alert("${ctp:i18n('ntp.multi.error.iderror')}");
                error=true;
         }else if(rel == "ehrerror") {
                $.alert("${ctp:i18n('ntp.multi.error.ehrerror')}");
                error=true;
         }else if(rel == "ehrnameerror") {
             $.alert("${ctp:i18n('ntp.multi.error.ehrnameerror')}");
             error=true;
         }else if(rel == "urltwoerror") {
             $.alert("${ctp:i18n('ntp.multi.error.urltwoerror')}");
             error=true;
         }else if(rel == "urlaccerror") {
                $.alert("${ctp:i18n('ntp.multi.error.urlaccerror')}");
                error=true;
         }else if(rel == "nameerror") {
                $.alert("${ctp:i18n('ntp.multi.error.nameerror')}");
                error=true;
         }else if(rel == "sorterror") {
                $.alert("${ctp:i18n('ntp.multi.error.sorterror')}");
                error=true;
         }
         
        try {
          if (getCtpTop() && getCtpTop().endProc) {
            getCtpTop().endProc()
          }
        } catch(e) {};
        if(error){
        	return;
        }
        $("#mytable").ajaxgridLoad(o);
        if ($("#conti").attr("checked") == "checked") {
          lashpsottype = $("#typeId").val();
          addform();
        } else {
        	location.reload();
        }
        $("#codeflg").hide();
      }
    });
  });
  
  
  function gridclk(data, r, c) {
    mytable.grid.resizeGridUpDown('middle');
    $("#ncjcform").disable();
    $("#ncjcform").show();
    $("#welcome").hide();
    $("#button").hide();
    var postdetil = pManager.viewNCConf(data.id);
    $("#codeflg").hide();
    $("#addForm").fillform(postdetil);
  }
  
  function griddblclick() {
    var v = $("#mytable").formobj({
      gridFilter: function(data, row) {
        return $("input:checkbox", row)[0].checked;
      }
    });
    if (v.length < 1) {
      $.alert("${ctp:i18n('ntp.multi.chosce.modify')}");
    } else if (v.length > 1) {
      $.alert("${ctp:i18n('once.selected.one.record')}");
    } else {
      mytable.grid.resizeGridUpDown('middle');
      var mpostdetil = pManager.viewNCConf(v[0]["id"]);
      $("#ncjcform").clearform({
        //clearHidden: true
      });
      $("#addForm").fillform(mpostdetil);
      $("#conti").removeAttr("checked");
      $("#ncjcform").enable();
      $("#button").show();
      $("#ncjcform").show();
      $("#welcome").hide();
      
      $("#id").disable();
      $("#codeflg").hide();
      
      $("#lconti").hide();
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
    <div class="comp" comp="type:'breadcrumb',code:'F21_ncjc001'"></div>
    <div class="layout_north" layout="height:30,sprit:false,border:false">
        <div id="toolbar"></div>
        <div id="searchDiv"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
        <div id="grid_detail" class="relative">
            <div class="stadic_layout">
                <div class="stadic_layout_head stadic_head_height">
                	<div id="welcome">
                            <div class="color_gray margin_l_20">
                                <div class="clearfix">
                                    <h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;">
                                    	${ctp:i18n("ntp.menu.integrationparamcfg")}
                                    </h2>
                                    <div class="font_size12 left margin_t_20 margin_l_10">
                                        <div class="margin_t_10 font_size14">
                                            <span id="count"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="line_height160 font_size14">
                                	${ctp:i18n("ntp.detail.nc")}
                                </div>
                            </div>
                     </div>
                </div>
                <div class="stadic_layout_body stadic_body_top_bottom">
                    
                    <div id="ncjcform">
                        <%@include file="ncjcform.jsp" %></div>
                </div>
                <div class="stadic_layout_footer stadic_footer_height">
                    <div id="button" align="center" class="page_color button_container">
                        <div class="common_checkbox_box clearfix stadic_footer_height padding_t_5 border_t">
                            <label for="conti" class="margin_r_10" id="lconti">
                                <input type="checkbox" id="conti" class="radio_com" checked="checked">${ctp:i18n('continuous.add')}</label>
                            <a id="btnok" href="javascript:void(0)" class="common_button common_button_gray margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
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