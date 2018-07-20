<%--
 $Author: wuym $
 $Rev: 1395 $
 $Date:: 2012-10-18 15:19:22#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>枚举组件测试</title>
<script type="text/javascript">
  $(function() {
    $("#mybtn").click(function() {
      alert($("#testcode2").val());
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

  });
</script>
</head>
<body>
    <input type="button" id="mybtn" value="取值">
    <select id="testcode1" name="testcode1" class="codecfg" codecfg="codeId:'test_code',defaultValue:2">
        <option value="">请选择...</option>
    </select>
    <select id="testcode2" name="testcode2" class="codecfg"
        codecfg="codeType:'java',render:'new',codeId:'com.seeyon.apps.samples.test.enums.MyEnums',defaultValue:4">
        <option value="">请选择...</option>
    </select>
    <div id="testcode3" name="testcode3" class="codecfg"
        codecfg="codeType:'java',render:'radioh',codeId:'com.seeyon.apps.samples.test.enums.MyCustomCode'"></div>
    <div id="testcode4" name="testcode4" class="codecfg"
        codecfg="codeType:'java',render:'radiov',codeId:'com.seeyon.apps.samples.test.enums.MyCustomCode',defaultValue:'my4'">
    </div>
    <select id="testcode5" name="testcode5" class="codecfg"
        codecfg="codeType:'java',codeId:'com.seeyon.apps.samples.test.enums.MyCustomCode',defaultValue:'my4'">
        <option value="">请选择...</option>
    </select>
    <select id="testcode6" name="testcode6" class="codecfg"
        codecfg="codeType:'java',codeId:'com.seeyon.apps.samples.test.enums.MyCustomCode',mycfg:'mycfg'">
        <option value="">请选择...</option>
    </select>
    <table>
        <thead>
            <tr>
                <th>代码值</th>
            </tr>
        </thead>
        <tbody bgcolor="#FFFFFF">
            <tr>
                <td class="codecfg" codecfg="codeId:'test_code'">2</td>
            </tr>
            <tr>
                <td class="codecfg" codecfg="codeType:'java',codeId:'com.seeyon.apps.samples.test.enums.MyEnums'">6</td>
            </tr>
        </tbody>
    </table>
    <div id="searchDiv"></div>
    <input id="mytxtenum" type="text" value="5" class="codecfg" codecfg="codeType:'java',codeId:'com.seeyon.apps.samples.test.enums.MyEnums'">
</body>
</html>
