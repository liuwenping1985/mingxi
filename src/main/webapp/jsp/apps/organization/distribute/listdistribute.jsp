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
    bottom: 0px;
    top: 0px;
}
.stadic_footer_height{
    height:0px;
}

.stadic_right{
    float:right;
    width:100%;
    height:100%;
    position:absolute;
    z-index:100;
}
.stadic_right .stadic_content{
    margin-left:49%;
    height:100%;
}
.stadic_left{
    width:48%; 
    float:left;
    position:absolute;
    height:100%;
    z-index:300;
}
</style>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=distributeManager,memberManager,orgManager"></script>
<script type="text/javascript">
$().ready(function() {
  var cnt;
  var msg = '${ctp:i18n("info.totally")}';
  var pManager = new distributeManager();
  var mManager = new memberManager();
  $("#postform").hide();
  $("#button").hide();
  function addform() {
    $("#postform").show();
    $("#postform").enable();
    $("#postform").clearform({
      clearHidden: true
    });
    $("#button").show();
    $("#welcome").hide();

    $("#lconti").show();
    pManager.addTeam({
      success: function(rel) {
        $("#sortId").val(rel["sortId"]);

      }
    });
    $("input[name=enabled]:eq(0)").attr("checked", 'checked');
    $("input[name=sortIdtype]:eq(0)").attr("checked", 'checked');
    $("input[name=scope]:eq(1)").attr("checked", 'checked');
    $("#type").val(2);
    $("#scopeout").disable();
    mytable.grid.resizeGridUpDown('middle');
  }

  $("#toolbar").toolbar({
    toolbar: [{
      id: "modify",
      name: "${ctp:i18n('member.redistribution')}",
      className: "ico16 editor_16",
      click: function() {
        var v = $("#mytable").formobj({
          gridFilter: function(data, row) {
            return $("input:checkbox", row)[0].checked;
          }
        });

        if (v.length < 1) {
          $.alert("${ctp:i18n('post.chosce.modify')}");
        } else {
          showSelectAccount();
        }
      }
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
          $.alert("${ctp:i18n('member.delete')}");

        } else {
          $.confirm({

            'msg': "${ctp:i18n('member.delete.ok')}",
            ok_fn: function() {
              pManager.deleteMember(v, {
                success: function() {
                  $("#mytable").ajaxgridLoad(o);
                }
              }

              );
            }
          });
        };
      }
    }]
  });

  var mytable = $("#mytable").ajaxgrid({
    click: gridclk,
    colModel: [{
      display: 'id',
      name: 'id',
      width: '5%',
      sortable: false,
      align: 'center',
      type: 'checkbox'
    },
    {
      display: "${ctp:i18n('org.member_form.name.label')}",
      sortable: true,
      name: 'name',
      width: '15%'
    },
    {
      display: "${ctp:i18n('org.member_form.loginName.label')}",
      sortable: true,
      name: 'loginName',
      width: '10%'
    },
    {
      display: "${ctp:i18n('org.dept.previous')}",
      sortable: true,
      name: 'orgAccountIdname',
      sortname: 'orgAccountId',
      width: '20%'

    },
    {
      display: "${ctp:i18n('org.dept.belong')}",
      sortable: true,
      name: 'orgDepartmentIdname',
      sortname: 'orgDepartmentId',
      width: '20%'
    },
    {
      display: "${ctp:i18n('org.member_form.primaryPost.label')}",
      sortable: true,
      name: 'orgPostIdname',
      sortname: 'orgPostId',
      width: '10%'
    },

    {
      display: "${ctp:i18n('org.dept.service.grade')}",
      sortable: true,
      name: 'orgLevelIdname',
      sortname: 'orgLevelId',
      width: '10%'
    },
    {
      display: "${ctp:i18n('org.dept.personnel.type')}",
      sortable: true,
      name: 'type',
      width: '10%',
      codecfg: "codeId:'org_property_member_type'"

    }],
    managerName: "distributeManager",
    managerMethod: "showDistributeList",
    parentId: 'center',
    vChangeParam: {
      overflow: "hidden"
    },
    slideToggleBtn: true,
    vChange: true,
    callBackTotle: getCount
  });
  var o = new Object();
  $("#mytable").ajaxgridLoad(o);

  function gridclk(data, r, c) {
    mytable.grid.resizeGridUpDown('middle');
    $("#button").hide();
    $("#postform").show();
    $("#welcome").hide();
    var memberDetail = mManager.viewOne(data.id);
    $("#memberForm").fillform(memberDetail);
    $("#postform").disable();
    fillSelectPeople(memberDetail);
  }
  var oManager = new orgManager();
  //选人界面的回写方法
  function fillSelectPeople(memberData) {
    if (null != memberData["orgAccountId"]) {
      //原单位
      var accountInfo = oManager.getAccountById(memberData["orgAccountId"]);
      if (null != accountInfo) {
        $("#sourceAccount").val(accountInfo.name);
      }
    }
    if (null != memberData["orgDepartmentId"]) {
      //部门
      var deptInfo = oManager.getDepartmentById(memberData["orgDepartmentId"]);
      if (null != deptInfo) {
        $("#deptName").val(deptInfo.name);
      }
    }
    if (null != memberData["orgPostId"]) {
      //主岗
      var primaryPostInfo = oManager.getPostById(memberData["orgPostId"]);
      if (null != primaryPostInfo) {
        $("#primaryPost").val(primaryPostInfo.name);
      }
    }
    if (null != memberData["orgLevelId"]) {
      //职务级别
      var levelInfo = oManager.getLevelById(memberData["orgLevelId"]);
      if (null != levelInfo) {
        $("#levelName").val(levelInfo.name);
      }
    }
  }
  function showSelectAccount() {
    var v = $("#mytable").formobj({
      gridFilter: function(data, row) {
        return $("input:checkbox", row)[0].checked;
      }
    });
    $.selectPeople({
      type: 'selectPeople',
      panels: 'Account',
      selectType: "Account",
      maxSize: 1,
      isCanSelectGroupAccount:false,
      callback: function(ret) {
        $.confirm({
          'msg': "${ctp:i18n('org.dept.confirm.member.call')}" + ret.text,
          ok_fn: function() {
            if (getCtpTop() && getCtpTop().startProc) getCtpTop().startProc();
            pManager.saveDistributeMessage(v, ret.value, {
              success: function(o) {
                mytable.grid.resizeGridUpDown('down');
                $("#mytable").ajaxgridLoad(o);
                try {
                  if (getCtpTop() && getCtpTop().endProc) {
                    getCtpTop().endProc()
                  }
                } catch(e) {};
              }
            });
          }
        });
      }
    });
  }
  var searchobj = $.searchCondition({
    top: 2,
    right: 10,
    searchHandler: function() {
      var ssss = searchobj.g.getReturnValue();
      $("#mytable").ajaxgridLoad(ssss);
    },
    conditions: [{
      id: 'search_name',
      name: 'search_name',
      type: 'input',
      text: "${ctp:i18n('member.list.find.name')}",
      value: 'name'
    },
    {
      id: 's_orgAccountIdname',
      name: 's_orgAccountIdname',
      type: 'input',
      text: "${ctp:i18n('org.dept.previous')}",
      value: 'orgAccountIdname'
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
    <div class="comp" comp="type:'breadcrumb',code:'T02_showDistributeframe'"></div>
    <div class="layout_north" layout="height:30,sprit:false,border:false">
      <div id="searchDiv"></div>
      <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
      <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
      <div id="grid_detail">
        <div class="stadic_layout">
            <div class="stadic_layout_head stadic_head_height">
            </div>
            <div class="stadic_layout_body stadic_body_top_bottom border_t">
              <div id="welcome">
                <div class="color_gray margin_l_20">
                  <div class="clearfix">
                    <h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;">${ctp:i18n("menu.organization.without.member")}</h2>
                    <div class="font_size12 left margin_t_20 margin_l_10">
                      <div class="margin_t_10 font_size14">
                        <span id="count"></span>
                      </div>
                    </div>
                  </div>
                  <div class="line_height160 font_size14">${ctp:i18n("organization.detail_info_listdistribute")}</div>
                </div>
              </div>
              <div id="postform" class="form_area">
                <%@include file="memberForm4distribute.jsp"%>
              </div>
            </div>
        </div>
      </div>
    </div>
  </div>

  </div>

  <div class="form_area align_center hidden" id="accountform">
  <form id="addForm" class="align_center">
    <table border="0" cellspacing="0" cellpadding="0" width="250" align="center">
      <tbody>
        <tr>
          <th nowrap="nowrap">
            <label class="margin_r_10" for="text">${ctp:i18n('org.dept.redistribute')}</label>
          </th>
          <td width="100%">
            <div class="common_txtbox_wrap">
              <input type="text" id="newAccount" class="comp validate" comp="type:'selectPeople',panels:'Account',selectType:'Account',maxSize:'1'" 
                validate="type:'string',name:'调入单位',notNull:true,minLength:1,maxLength:500"></div>
          </td>
        </tr>
      </tbody>
    </table>
  </form>
  </div>

  </body>
  </html>