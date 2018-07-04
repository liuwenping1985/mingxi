<%--
 $Author: maxc $
 $Rev: 3116 $
 $Date:: 2012-08-30 12:48:37#$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>Role2Member</title>
<script type="text/javascript">
  var accountId = "${accountId}";
  var _clickSelect= "<${ctp:i18n('org.click.select.mem')}>";
  function OK() {
   var frmobj = $("#myfrm").formobj();
   var valid = $._isInValid(frmobj);
    if (valid) {
      return "";
    }
    var r= $("#authValue").val();
    return r;
  }

  $(function() {
    if("${ctp:escapeJavascript(ctp:showOrgEntities(members,'id','entityType',null))}" == "")
    {
        $("#roles").val(_clickSelect);
    }
    else{
        $("#roles").val("${ctp:escapeJavascript(ctp:showOrgEntities(members,'id','entityType',null))}");
    }

    $("#authValue").val("${ctp:escapeJavascript(ctp:parseElements(members,'id','entityType'))}");

    var rm = new roleManager();
    var o = new orgManager();
    var role = o.getRoleById('${roleId}');
    function clk(e, treeId, node) {
        $("#roles").val('');
        $("#authValue").val('');
        if (node.level == 0){
            $("#roles").disable();
            return;
        }else{
            $("#roles").enable();
        }
        var result = o.getMembersByDepartmentRoleByStr("Department|"+node.id,'${roleId}');
        $("#roles").val(result['names']);
        $("#authValue").val(result['values']);

    }
    $("#deptTree").tree({
        onClick: clk,
        idKey: "id",
        pIdKey: "parentId",
        nameKey: "name",
        managerName: "departmentManager",
        managerMethod: "showDepartmentTree",
        asyncParam : {
            accountId : accountId
        },
        nodeHandler: function(n) {
          if (n.data.parentId == n.data.id) {
            n.open = true;
          } else {
            n.open = false;
          }
        }
      });

    $("#layout").layout().setWest(0);
    if(role.bond=="2"){
        $("#roles").disable();
        $("#layout").layout().setWest(200);
        $("#deptTree").treeObj().reAsyncChildNodes(null, "refresh", false);
    }

    $(".rolemember").click(function(){

    //只有自建角色、普通人员、外部人员角色能够选择外部人员
    var isoutworker = "";
    if("${isGroup}"=="false"&&(!o.isBaseRole(role.code)||role.code=="ExternalStaff"||role.code=="GeneralStaff")){
        isoutworker = ",Outworker";
    }else{
        isoutworker = "";
    }
    var isgroup = "";
    if("${isGroup}"=="true"){
        isgroup = "Account,";
    }else{
        isgroup = "";
    }
    var isonlyLoginAccount = true;
    if(role.bond=="0"){
        isonlyLoginAccount = false;
    }else{
        isonlyLoginAccount = true;
    }

    //部门授权
    if(role.bond=="2"){
        var deptid=$("#deptTree").treeObj().getSelectedNodes()[0].id;
        var extdeptid=$("#deptTree").treeObj().getSelectedNodes()[0].id;
        if(role.code=="DepLeader"){
            extdeptid=null;
        }
         $.selectPeople({
                text: $("#roles").val(),
                value: $("#authValue").val(),
                type : 'selectPeople',
                panels : 'Department',
                selectType : "Member",
                minSize: 0,
                hiddenPostOfDepartment:true,
                onlyLoginAccount : isonlyLoginAccount,
                accountId : "${accountId}",
                isCheckInclusionRelations:false,
                //showDepartmentsOfTree:extdeptid,
                params: {
                  value: $("#authValue").val()
                },
                callback : function(ret) {
                  var check = rm.checkOnlyOneRole('${roleId}',ret.value.substring(7),deptid);
                  if(check!=null&&check!="null"&&check!=""){
                      $.alert(check);
                      return;
                    }

                  rm.batchRole2Entity('${roleId}', ret.value+"^"+deptid, {
                      success : function() {
                        $("#roles").val(ret.text);
                        $("#authValue").val(ret.value);
                      }
                    });

                }
              });
    }else{
      $.selectPeople({
        text: $("#roles").val(),
        value: $("#authValue").val(),
        type : 'selectPeople',
        panels : isgroup+'Department,Post,Level'+isoutworker,
        selectType : "Account,Member,Department,Post,Level",
        minSize: 0,
        hiddenPostOfDepartment:true,
        onlyLoginAccount : isonlyLoginAccount,
        accountId : "${accountId}",
        isCheckInclusionRelations:false,
        params: {
          value: $("#authValue").val()
        },
        callback : function(ret) {
          if(ret.text == ""){
              $("#roles").val(_clickSelect);
          }
          else{
              $("#roles").val(ret.text);
          }
          //$("#roles").val(ret.text);
          $("#authValue").val(ret.value);


        }
      });
    }
    });

  });
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'" style="background:#fff;">
<div class="layout_center" layout="sprit:false">
    <div class="margin_5" style="margin-top:20px;">
  <form id="myfrm" name="myfrm" method="post" class="font_size12">

    <div style="float:left;margin-left:15px;">${ctp:i18n('member.choose')}：</div>
    <div>
    <textarea style="cursor: pointer;width: 80%" readonly="readonly" id="roles" name="roles"  rows="8"  class="rolemember"></textarea>
    </div style="float:left;">
    <!-- <input style="cursor: pointer;" class="rolemember" type="text" id="roles" name="roles" readonly="readonly"/> -->
    <input type="hidden" id="authValue" name="authValue"/>
  </form>
  </div>
  </div>

  <div id="west" class="layout_west"
            layout="sprit:false,width:200,minWidth:50,maxWidth:300">
            <div id="deptTree"></div>
    </div>
</div>
</body>
</html>