<%--
 $Author: wuym $
 $Rev: 906 $
 $Date:: 2012-09-13 10:40:05#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>layout</title>
<script>
  $(document).ready(function() {
    $("#mytable").ajaxgrid({
      click : tclk,
      colModel : [ {
        display : 'id',
        name : 'orgid',
        width : '40',
        sortable : false,
        align : 'center',
        type : 'checkbox'
      }, {
        display : '组织名称',
        name : 'orgname',
        width : '180'
      }, {
        display : '父组织ID',
        name : 'parentid',
        width : '180',
        codecfg : "codeType:'form',codeId:'4171705351394184829'"
      } ],
      managerName : "testPagingManager",
      managerMethod : "testPaging",
      height : 200,
      vChange : {
        'parentId' : 'center',
        'changeTar' : 'form_area',
        'subHeight' : 90
      }
    });

    function tclk(data, r, c) {
      $("#form_area").fillform(data);
    }

    $("#tree").tree({
      onClick : clk,
      managerName : "testCRUDManager",
      managerMethod : "testLoadAll",
      idKey : "orgid",
      pIdKey : "parentid",
      nameKey : "orgname",
      nodeHandler : function(n) {
        n.open = true;
        n.isParent = true;
      },
      render : function(name, data) {
        return data.orgid + " - " + name;
      }
    });

    function clk(e, treeId, node) {
      var o = new Object();
      o.parentid = node.data.orgid;
      $("#mytable").ajaxgridLoad(o);
    }

    $("#submitbtn").click(function() {
      var obj = $("#form_area").formobj();
      alert("Invalid:" + $._isInValid(obj));
    });

    $("#cancelbtn").click(function() {
      alert($("#testhd").val());
      $("#myfrm").clearform();
      alert($("#testhd").val());
    });
  });
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" id="north" layout="height:57">
            <div class="common_tabs clearfix">
                <ul class="left">
                    <li class="current"><a href="javascript:void(0)">正文</a></li>
                    <li><a href="javascript:void(0)" class='no_b_border'>流程</a></li>
                    <li><a href="javascript:void(0)" class='no_b_border'>编辑</a></li>
                    <li><a href="javascript:void(0)" class="last_tab no_b_border">表单</a></li>
                </ul>
            </div>
            <div id="toolbar"></div>
        </div>
        <div class="layout_west" id="west" layout="width:200">
            <div id="tree"></div>
        </div>
        <div class="layout_center" id="center" layout="border:false">
            <table id="mytable" class="flexme3" style="display: none"></table>
            <div class="form_area" id='form_area'>
                <div class="one_row">
                    <form id="myfrm">
                        <input type="hidden" id="testhd" value="测试数据">
                        <table border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <th><label class="margin_r_10" for="text">组织id:</label></th>
                                <td><div class="common_txtbox_wrap">
                                        <input type="text" id="orgid" class="validate"
                                            validate="notNull:true,isInteger:true, maxValue:150,minValue:0" />
                                    </div></td>
                            </tr>
                            <tr>
                                <th><label class="margin_r_10" for="text">组织名称:</label></th>
                                <td><div class="common_txtbox_wrap">
                                        <input type="text" id="orgname" class="validate"
                                            validate="type:'string',notNull:true,minLength:4,maxLength:20" />
                                    </div></td>
                            </tr>
                            <tr>
                                <th><label class="margin_r_10" for="text">父组织id:</label></th>
                                <td><div class="common_txtbox  clearfix">
                                        <textarea id="parentid" cols="30" rows="7" class="w100b validate"
                                            validate="notNull:true,isInteger:true, maxValue:150,minValue:0"></textarea>
                                    </div></td>
                            </tr>
                            <tr>
                                <th><label class="margin_r_10" for="text">选择:</label></th>
                                <td><div class="common_txtbox  clearfix">
                                        <select id="mysel" cols="30" rows="7" class="w100b"><option value="11">11</option>
                                            <option value="11">12</option></select> <input type="checkbox"><input
                                            type="radio">
                                    </div></td>
                            </tr>
                        </table>
                    </form>
                </div>
                <div class="align_center">
                    <a href="javascript:void(0)" id="submitbtn" class="common_button common_button_gray">确定</a> <a
                        href="javascript:void(0)" id="cancelbtn" class="common_button common_button_gray">取消</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>