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
src="${path}/ajax.do?managerName=ncBusiBindManager"></script>
<script type="text/javascript">
$().ready(function() {
	var total = '${ctp:i18n("info.totally")}';
	 var pManager = new ncBusiBindManager();
	 $("#busibindform").hide();
     $("#button").hide();
  
    function addform() {
    $("#busibindform").clearform({
      clearHidden: true
    });
    $("#busibindform").enable();
    $("#busibindform").show();
    $("#button").show();
    $("#welcome").hide();
    $("#lconti").show();
    $("#conti").attr("checked", true);
    $("input[id=enable]:eq(0)").attr("checked", 'checked');
     pManager.addBusiBind({
      success: function(rel) {
        $("#sortId").val(rel["sortId"]);

      }
    });
	$("#sortId").disable();
  }
  
var toolbar = $("#toolbar").toolbar({
    toolbar: [{
      id: "add",
      name: "${ctp:i18n('common.toolbar.new.label')}",
      className: "ico16",
      click: function() {
        addform();
        mytable.grid.resizeGridUpDown('middle');
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
          $.alert("${ctp:i18n('ncbusinessplatform.business.delete')}");

        } else {
          var postname = "";
          for (i = 0; i < v.length; i++) {
            if (i != v.length - 1) {
              postname = postname + v[i].templete_name + "、";
            } else {
              postname = postname + v[i].templete_name;
            }
          }

          $.confirm({
            'msg': $.i18n('ncbusinessplatform.business.delete.ok.js', postname),
            ok_fn: function() {
              pManager.deleteBusiBind(v, {
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
      display: 'id',
      name: 'id',
      width: '5%',
      sortable: true,
      align: 'center',
      type: 'checkbox'
    },
   	{
      display: "${ctp:i18n('ncbusinessplatform.business.band.templetename')}",
      name: 'templete_name',
      width: '15%',
      sortable: true
    },
    {
      display: "${ctp:i18n('ncbusinessplatform.business.band.billtempname')}",
      sortable: true,
      name: 'billtemp_name',
      width: '15%'
    },

    {
      display: "NC",
      sortable: true,
      name: 'ncMultiJcName',
      width: '15%'
    },
    {
      display: "${ctp:i18n('ncbusinessplatform.business.label.sort')}",
      sortable: true,
      name: 'sortId',
      sortname: 'sortId',
      sortType: 'number',
      width: '5%'
    } ,
    {
      display: "${ctp:i18n('ncbusinessplatform.business.label.enable')}",
      sortable: true,
      codecfg: "codeId:'common.enabled'",
      name: 'enable',
      sortname: 'enable',
      width: '10%'
    },
    {
      display: "${ctp:i18n('ncbusinessplatform.business.label.busistate')}",
      sortable: true,
      name: 'extAttr1',
      width: '10%'
    }],
    managerName: "ncBusiBindManager",
    managerMethod: "showBusiBindList",
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
    if (! ($("#busibindform").validate())) {
      return;
    }
   if (getCtpTop() && getCtpTop().startProc) getCtpTop().startProc();
   
    pManager.createBusiBind($("#addForm").formobj({
      includeDisabled: true
    }), {
      success: function(rel) {
      	  var error = false;
      	 if (rel == "tempiderror") {
                $.alert("${ctp:i18n('ncbusinessplatform.business.error.tempiderror')}");
                error=true;
         }else if(rel == "nciderror") {
                $.alert("${ctp:i18n('ncbusinessplatform.business.error.nciderror')}");
                error=true;
         }else if(rel == "tempnameerror") {
                $.alert("${ctp:i18n('ncbusinessplatform.business.error.tempnameerror')}");
                error=true;
         }else if(rel == "nameerror") {
                $.alert("${ctp:i18n('ncbusinessplatform.business.error.nameerror')}");
                error=true;
         }else if(rel == "sorterror") {
                $.alert("${ctp:i18n('ncbusinessplatform.business.error.sorterror')}");
                error=true;
         }else  if(rel == "busistaterror"){
                $.alert("${ctp:i18n('ncbusinessplatform.business.error.busistaterror')}");
                error=true;
         }
         
        try {
          if (getCtpTop() && getCtpTop().endProc) {
            getCtpTop().endProc();
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
        
      }
    });
  });
  
  
  function gridclk(data, r, c) {
    mytable.grid.resizeGridUpDown('middle');
    $("#busibindform").disable();
    $("#busibindform").show();
    $("#welcome").hide();
    $("#button").hide();
    var postdetil = pManager.viewBusiBind(data.id);
    $("#addForm").fillform(postdetil);
  }
  
  function griddblclick() {
    var v = $("#mytable").formobj({
      gridFilter: function(data, row) {
        return $("input:checkbox", row)[0].checked;
      }
    });
    if (v.length < 1) {
      $.alert("${ctp:i18n('ncbusinessplatform.business.choose.modify')}");
    } else if (v.length > 1) {
      $.alert("${ctp:i18n('once.selected.one.record')}");
    } else {
      mytable.grid.resizeGridUpDown('middle');
      var mpostdetil = pManager.viewBusiBind(v[0]["id"]);
      $("#busibindform").clearform({
        //clearHidden: true
      });
      $("#addForm").fillform(mpostdetil);
      $("#conti").removeAttr("checked");
      $("#busibindform").enable();
      $("#button").show();
      $("#busibindform").show();
      $("#welcome").hide();
      $("#id").disable();
      $("#sortId").disable();
      
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
    <div class="comp" comp="type:'breadcrumb',code:'F21_ncjc002'"></div>
    <div class="layout_north" layout="height:40,sprit:false,border:false">
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
                                    	${ctp:i18n("ntp.menu.ncbusinessbinding")}
                                    </h2>
                                    <div class="font_size12 left margin_t_20 margin_l_10">
                                        <div class="margin_t_10 font_size14">
                                            <span id="count"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="line_height160 font_size14">
                                	${ctp:i18n("ntp.detail.business")}
                                </div>
                            </div>
                     </div>
                </div>
                <div class="stadic_layout_body stadic_body_top_bottom">
                    <div id="busibindform">
                        <%@include file="busibindform.jsp" %></div>
                </div>
                <div class="stadic_layout_footer stadic_footer_height">
                    <div id="button" align="center" class="page_color button_container">
                        <div class="common_checkbox_box clearfix stadic_footer_height padding_t_5 border_t">
                            <label for="conti" class="margin_r_10" id="lconti">
                                <input type="checkbox" id="conti" class="radio_com" checked="checked">${ctp:i18n('continuous.add')}</label>
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