<%--
 $Author: wuym $
 $Rev: 2371 $
 $Date:: 2012-11-23 19:32:29#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>组件测试</title>
<script>
  $(function() {
    $("#mybtn").toggle(function() {
      $("#mycal1").disable();
      $("#testRegion").disable();
    }, function() {
      $("#mycal1").enable();
      $("#testRegion").enable();
    });
    $("#clonebtn").click(function() {
      var cl = $("#testRegion").clone();
      $("body").append(cl);
      cl.comp();
    });
    $("#refreshbtn").click(function() {
      alert($("#spc2").val());
      $("#spc2").comp({
        panels : 'Account,Department',
        selectType : 'Member'
      });
      alert($("#spc2").val());
    });
    $("#fillbtn")
        .click(
            function() {
              var d = {};
              d.spc2 = '{"text":"部门经理,部门主管","value":"Post|-9057375129202243787,Post|1616554687614503756"}';
              $("#testRegion").fillform(d);
            });
    //综合查询组件测试
    var searchobj = $('#searchDiv')
        .searchCondition(
            {
              searchHandler : function() {
                alert('执行查询')
              },
              conditions : [
                  {
                    id : 'title',
                    name : 'title',
                    type : 'input',
                    text : '标题',
                    value : 'subject'
                  },
                  {
                    id : 'importent',
                    name : 'importent',
                    type : 'select',
                    text : '重要程度',
                    value : 'importantLevel',
                    codecfg : "codeType:'java',codeId:'com.seeyon.apps.samples.test.enums.MyEnums'",
                    items : [ {
                      text : '普通',
                      value : '0'
                    }, {
                      text : '重要',
                      value : '1'
                    }, {
                      text : '非常重要',
                      value : '2'
                    } ]
                  }, {
                    id : 'spender',
                    name : 'spender',
                    type : 'input',
                    text : '发起人',
                    value : 'startMemberName'
                  }, {
                    id : 'datetime',
                    name : 'datetime',
                    type : 'datemulti',
                    text : '发起时间',
                    value : 'createDate',
                    dateTime : true
                  } ]
            });
    var counter = 0;
    $("#refreshFile").click(function() {
      counter++;
      $("#myfile").comp({
        attsdata : [ {
          type : 0,
          filename : counter + "测试文件.txt",
          mimeType : "application/octet-stream",
          size : 2050,
          createdate : "2012-10-29",
          fileUrl : "-4575555329817492136" + counter,
          icon : "default.gif",
          extension : "txt"
        } ]
      });
    });
  });
</script>
<script type="text/javascript" src="${path}/common/office/js/i18n/zh-cn.js"></script>
<script type="text/javascript" src="${path}/common/office/js/office.js"></script>
</head>
<body leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
    <input type="button" id="mybtn" value="禁用/启用">
    <input type="button" id="clonebtn" value="克隆">
    <input type="button" id="refreshbtn" value="刷新选人组件">
    <input type="button" id="fillbtn" value="选人数据回填">
    <div id="testRegion">
        <a href="javascript:void(0)" class="common_button common_button_gray">按钮1</a><a href="javascript:void(0)"
            class="common_button common_button_gray">按钮2</a> <input type="text" class="comp"
            comp="type:'calendar',ifFormat:'%m-%Y-%d'"> <input type="checkbox"><input type="radio">
        <textarea></textarea>
        <input type="text" id="spc1" name="spc1" class="comp"
            comp="type:'selectPeople',mode:'open',value:'Department | -884316703172445_1,Member | 1730833917365171641',text:'开发中心、人员2',panels:'Account,Department,Team,Post,Level,Role',selectType:'Member'" />
        <input type="text" id="spc2" name="spc2" class="comp"
            comp="type:'selectPeople',mode:'open',value:'Department | -884316703172445_1,Member | 1730833917365171641',text:'开发中心、人员2',panels:'Account,Department,Team,Post,Level,Role',selectType:'Member'" />
        <div id="searchDiv"></div>
    </div>
    <input type="button" id="refreshFile" value="刷新文件">
    <input id="myfile" type="text" class=""
        comp="type:'fileupload',applicationCategory:'1',canDeleteOriginalAtts:false,originalAttsNeedClone:false"
        attsdata='[{type:0,filename:"测试文件.txt",mimeType:"application/octet-stream",size:2050,createdate:"2012-10-29",fileUrl:"-4575555329817492136",icon:"default.gif",extension:"txt"}]'>
    <input type="button" onclick="insertAttachment()" value="上传附件">
    <label for="mycal">日历:</label>
    <input id="mycal1" type="text" class="comp" comp="type:'calendar',ifFormat:'%m-%Y-%d'">
    <div class="comp" comp="type:'office',fileType:'.doc',fileId:'1234567',canEdit:1"></div>
</body>
</html>
