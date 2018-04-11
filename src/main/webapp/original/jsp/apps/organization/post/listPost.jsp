<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../common/common.jsp"%>
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
<script type="text/javascript">
var dialog;
var inHand=false;
var accountId = "${accountId}";
var isgroup = ${isGroup};
$().ready(function() {
  var ssss;
  var cnt;
  var lashpsottype = 1;
  var msg = '${ctp:i18n("info.totally")}';
  var pManager = new postManager();
  var imanager = new iOManager();
  $("#postform").hide();
  $("#button").hide();
  //$("#welcome").hide();
  $("#welcome").show();

  function addform() {
    $("#postform").clearform({
      clearHidden: true
    });
    $("#postform").enable();
    $("#postform").show();
    $("#button").show();
    $("#welcome").hide();
    $("#lconti").show();
    $("#conti").attr("checked", 'checked');
    $("#conti").attr("checked", 'checked');
    $("input[id=enabled]:eq(0)").attr("checked", 'checked');
    $("input[id=sortIdtype]:eq(0)").attr("checked", 'checked');
    pManager.addPost(accountId, {
      success: function(rel) {
        $("#sortId").val(rel["sortId"]);

      }
    });
    $("#typeId").val(lashpsottype);
  if(!$("#typeId").val()){
        $("#typeId").val(5);
    }

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
          $.alert("${ctp:i18n('post.delete')}");

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
            'msg': $.i18n('post.delete.ok.js', postname),
            ok_fn: function() {
              pManager.deletePost(v, {
                success: function() {
                  $("#mytable").ajaxgridLoad(o);
                }
              });
            }
          });
        };
      }
    },
    {
      id: "importbase",
      name: "${ctp:i18n('org.post_form.importbase')}",
      className: "ico16 reference_benchmark_kong_16",
      click: function() {
        $.selectPeople({
          type: 'selectPeople',
          panels: 'Post',
          selectType: 'Post',
          onlyLoginAccount: true,
          accountId: '-1730833917365171641',
          callback: function(ret) {
            pManager.createPostFormBase(accountId, ret.value);
            $("#mytable").ajaxgridLoad(o);
          }
        });
      }
    },
    {
      id: "bdingbase",
      name: "${ctp:i18n('org.post_form.bdingbase')}",
      className: "ico16 binding_benchmark_kong_16",
      click: function() {
        var v = $("#mytable").formobj({
          gridFilter: function(data, row) {
            return $("input:checkbox", row)[0].checked;
          }
        });
        if (v.length < 1) {
          $.alert("${ctp:i18n('org.post_form.bding.record')}");
        } else {
          pManager.bdingBasePost(accountId, v, {
            success: function(rel) {
              if (rel != "") {
                $.alert("${ctp:i18n('org.post_form.not.bding.following')}" + rel);
              }
              $("#mytable").ajaxgridLoad(o);
            }
          });
        }
      }
    },
    {
      id: "import",
      name: "${ctp:i18n('org.post_form.import.batch.list')}",
      className: "ico16 import_16",
      subMenu: [{
        name: "${ctp:i18n('import.excel')}",
        click: function() {
          dialog = $.dialog({
            width: 600,
            height: 400,
            isDrag: false,
            //targetWindow: top,
            id: 'importdialog',
            url: '${path}/organization/organizationControll.do?method=importExcel&importType=post&accountId=' + accountId,
            title: "${ctp:i18n('import.excel')}",
            closeParam: {
              'show': true,
              handler: function() {
                $("#mytable").ajaxgridLoad(o);
              }
            }
          });

        }
      },
      {
        name: "${ctp:i18n('org.post_form.template.download')}",
        click: function() {
          var downloadUrl = "${path}/organization/organizationControll.do?method=downloadTemplate&type=Post&accountId=" + accountId;
          var eurl = "<c:url value='" + downloadUrl + "' />";
          exportIFrame.location.href = eurl;
        }
      }]
    },
    {
      id: "export",
      name: "${ctp:i18n('org.post_form.export.info')}",
      className: "ico16 export_excel_16",
      click: function() {
        //var ok=imanager.canIO();
        imanager.canIO({
          success: function(rel) {
            if ('ok' == rel) {
              //parent.detailFrame.location.href="${organizationURL}?method=toExpBase&tomethod=exportPost";
              //alert('导出数据需要一段时间处理，请耐心等待');
              //var infor = $.infor("organizationLang.organization_export_wait");
              //alert(v3x.getMessage("organizationLang.organization_export_wait"));
              var downloadUrl_e = "${path}/organization/postController.do?method=exportPost1&condition=" + $.toJSON(ssss) + "&accountId=" + accountId;
              var eurl_e = "<c:url value='" + downloadUrl_e + "' />";
              exportIFrame.location.href = eurl_e;
            } else {
              //alert('后台正在进行导入导出操作');
              //var infor = $.infor("organizationLang.organization_back_deal");
              //alert(v3x.getMessage("organizationLang.organization_back_deal"));
            }
          }
        });

      }

    }]
  });

  var mytable = $("#mytable").ajaxgrid({
    click: gridclk,
    dblclick: griddblclick,
    colModel: [{
      display: 'id',
      name: 'id',
      width: '5%',
      sortable: false,
      align: 'center',
      type: 'checkbox'
    },
    {
      display: "${ctp:i18n('org.metadata.post_typeId.label')}",
      sortable: true,
      codecfg: "codeId:'organization_post_types',query:'true'",
      name: 'typeId',
      sortname: 'type',
      width: '10%'
    },
    {
      display: "${ctp:i18n('org.post_form.name')}",
      sortable: true,
      name: 'name',
      width: '25%'
    },
    {
      display: "${ctp:i18n('org.post_form.type.code')}",
      sortable: true,
      name: 'code',
      width: '18%'
    },
    {
      display: "${ctp:i18n('organization.metadate.post')}",

      name: 'posttype',
      sortable: true,
      width: '15%',
      hide: isgroup
    },
    {
      display: "${ctp:i18n('common.sort.label')}",
      sortable: true,
      name: 'sortId',
      sortType: 'number',
      width: '15%'
    },

    {
      display: "${ctp:i18n('common.state.label')}",
      sortable: true,
      codecfg: "codeId:'common.enabled'",
      name: 'enabled',
      sortname: 'enable',
      width: '10%'
    }],
    managerName: "postManager",
    managerMethod: "showPostList",
    parentId: 'center',
    vChangeParam: {
      overflow: 'hidden',
      position: 'relative'
    },
    slideToggleBtn: true,
    showTableToggleBtn: true,
    vChange: true,
    callBackTotle: getCount
  });
  var o = new Object();
  o.accountId = accountId;
  $("#mytable").ajaxgridLoad(o);
  function gridclk(data, r, c) {
    mytable.grid.resizeGridUpDown('middle');
    $("#postform").disable();
    $("#postform").show();
    $("#welcome").hide();
    $("#button").hide();
    var postdetil = pManager.viewPost(data.id);
    $("#addForm").fillform(postdetil);
    $("input[id=sortIdtype]:eq(0)").attr("checked", 'checked');
  if(!$("#typeId").val()){
        $("#typeId").val(1);
    }
  if(!$("#typeId").val()){
        $("#typeId").val(5);
    }
  }
  var groupver = "${ctp:getSystemProperty('org.GroupPost')}";
  if(isgroup || groupver=="false"){
    toolbar.hideBtn("bdingbase");
    toolbar.hideBtn("importbase");
  }
  function griddblclick() {
    var v = $("#mytable").formobj({
      gridFilter: function(data, row) {
        return $("input:checkbox", row)[0].checked;
      }
    });
    if (v.length < 1) {
      $.alert("${ctp:i18n('post.chosce.modify')}");
    } else if (v.length > 1) {
      $.alert("${ctp:i18n('once.selected.one.record')}");
    } else {
      mytable.grid.resizeGridUpDown('middle');
      var mpostdetil = pManager.viewPost(v[0]["id"]);
      var isbase = v[0]["posttype"];
      $("#postform").clearform({
        clearHidden: true
      });
      $("#addForm").fillform(mpostdetil);
      $("#conti").removeAttr("checked");
      $("#postform").enable();
      $("#button").show();
      if (isbase == "集团基准岗" && !isgroup) {
        $("#name").disable();
        $("#code").disable();
        $("#typeId").disable();
        $("#description").disable();
        $("input[id=enabled]:eq(0)").disable();
        $("input[id=enabled]:eq(1)").disable();
      } else {}

      $("#postform").show();
      $("#lconti").hide();
      $("#welcome").hide();
      $("input[id=sortIdtype]:eq(0)").attr("checked", 'checked');
    }
  if(!$("#typeId").val()){
        $("#typeId").val(1);
    }
  if(!$("#typeId").val()){
        $("#typeId").val(5);
    }
  }
  $("#btncancel").click(function() {
    location.reload();
  });
  $("#btnok").click(function() {
    if (! ($("#postform").validate()) || inHand) {
      return;
    }
    if (getCtpTop() && getCtpTop().startProc) {
      getCtpTop().startProc();
      inHand = true;
      };
    pManager.createPost(accountId, $("#addForm").formobj({
      includeDisabled: true
    }), {
      success: function(depBean) {
        try {
          if (getCtpTop() && getCtpTop().endProc) {
            getCtpTop().endProc();
            inHand = false;
          }
        } catch(e) {};
        $("#mytable").ajaxgridLoad(o);
        if ($("#conti").attr("checked") == "checked") {
          lashpsottype = $("#typeId").val();
          addform();
        } else {
          $("#postform").hide();
          $("#button").hide();
          $("#welcome").show();
        }
      },
      error: function(returnVal){
          var sVal=$.parseJSON(returnVal.responseText.replace(/\\/g,''));
          $.alert(sVal.message);
          if (getCtpTop() && getCtpTop().endProc) {
              getCtpTop().endProc();
              inHand = false;
            }
      }
    });
  });

  var searchobj = $.searchCondition({
    top: 7,
    right: 10,
    searchHandler: function() {
      ssss = searchobj.g.getReturnValue();
      ssss.accountId = accountId;
      $("#mytable").ajaxgridLoad(ssss);
    },
    conditions: [{
      id: 'search_name',
      name: 'search_name',
      type: 'input',
      text: "${ctp:i18n('org.post_form.name')}",
      value: 'name'
    },
    {
      id: 'search_code',
      name: 'search_code',
      type: 'select',
      text: "${ctp:i18n('org.metadata.post_typeId.label')}",
      value: 'type',
      codecfg: "codeId:'organization_post_types',query:'true'"
    },
    {
      id: 's_code',
      name: 's_code',
      type: 'input',
      text: "${ctp:i18n('org.post_form.type.code')}",
      value: 'code'
    }]
  });
  function getCount() {
    cnt = mytable.p.total;
    $("#count").get(0).innerHTML = msg.format(cnt);
  }
});
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
 	<c:if test="${ctp:isRoleByCode('GroupAdmin')!=true || accountId==-1730833917365171641}">
    	<div class="comp" comp="type:'breadcrumb',code:'T02_showPostframe'"></div>
    </c:if>
    <div class="layout_north" layout="height:40,sprit:false,border:false">
        <div id="toolbar"></div>
        <div id="searchDiv"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
        <div id="grid_detail" class="relative">
            <div class="stadic_layout">
                <div class="stadic_layout_head stadic_head_height"></div>
                <div class="stadic_layout_body stadic_body_top_bottom">
                    <div id="welcome">
                        <div class="color_gray margin_l_20">
                            <div class="clearfix">
                                <h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;">${ctp:i18n("common.job.information")}</h2>
                                <div class="font_size12 left margin_t_20 margin_l_10">
                                    <div class="margin_t_10 font_size14">
                                        <span id="count"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="line_height160 font_size14">
                                <c:if test="${isGroup}">${ctp:i18n('organization.detail_post_group')}</c:if>
                                <c:if test="${!isGroup&&ctp:getSystemProperty('org.GroupPost')=='true'}">${ctp:i18n('organization.detail_post')}</c:if>
                                <c:if test="${!isGroup&&ctp:getSystemProperty('org.GroupPost')=='false'}">${ctp:i18n('organization.detail_post_nogroup')}</c:if>
                            </div>
                        </div>
                    </div>
                    <div id="postform">
                        <%@include file="postform.jsp" %></div>
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
<iframe width="0" height="0" name="exportIFrame" id="exportIFrame"></iframe>
</body>
</html>