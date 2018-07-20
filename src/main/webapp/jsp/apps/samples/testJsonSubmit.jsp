<%--
 $Author: wuym $
 $Rev: 2045 $
 $Date:: 2012-11-12 15:29:12#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>表单Json提交测试</title>
<script language="javascript">
  $(function() {

    // 表单JSON无分区无分组提交事件
    $("#savebtn1").click(function() {
      $("#form1").jsonSubmit({
        debug : true,
        callback : function(d) {
          alert(d);
        }
      });
    });
    $("#savebtn3").click(function() {
      $("#form3").jsonSubmit({
        domains : [ "domain31", "domain32" ],
        debug : true
      });
    });
    $("#savebtn4").click(function() {
      $("#form4").jsonSubmit({
        debug : true
      });
    });
    $("#savebtn5").click(function() {
      $("#form5").jsonSubmit({
        domains : [ "domain51", "domain52" ],
        debug : true
      });
    });
    $("#testBtn").click(function() {
      alert($.toJSON($("#pid").formobj({
        matchClass : true,
        isGrid : true,
        domains : [ 'pid', 'projectList' ]
      })));
    });
  });
</script>
</head>
<body leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
    <input type="button" id="testBtn" value="测试">
    <div id="pid" class="pid">
        <input id="eventSource">
        <div id="projectList">
            <input id="projectname">
        </div>
        <div id="projectList">
            <input id="projectname">
        </div>
    </div>
    <table>
        <tr>
            <td>
                <form id="form1" name="form1" method="post" action="test.do?method=testJsonSubmit2">
                    <table border="1">
                        <tbody>
                            <tr>
                                <td colspan="2"><label>表单<font color="red">无分区无分组</font>提交
                                </label></td>
                            </tr>
                            <tr>
                                <td><label>用户名</label></td>
                                <td><input type="text" name="username"
                                    validate="{type:'string',name:'姓名',notNull:true,minLength:4,maxLength:20}" /></td>
                            </tr>
                            <tr>
                                <td><label>密码</label></td>
                                <td><input type="password" name="passwork"
                                    validate="{type:'string',name:'密码',notNull:true,minLength:4,maxLength:20}" /></td>
                            </tr>
                            <tr>
                                <td><label>爱好</label></td>
                                <td><input type="radio" name="爱好" value="划水" />划水<br /> <input type="radio"
                                    name="爱好" value="划船" />划船<br /> <input type="radio" name="爱好" value="划山" />划山</td>
                            </tr>
                            <tr>
                                <td><label>爱好</label></td>
                                <td><input type="checkbox" name="爱好11" value="划水" />划水<br /> <input
                                    type="checkbox" name="爱好12" value="划山" />划船<br /> <input type="checkbox"
                                    name="爱好13" value="划船" />划山</td>
                            </tr>
                            <tr>
                                <td><label>性别</label></td>
                                <td><select name="sex" multiple="true">
                                        <option value="男">男</option>
                                        <option value="女">女</option>
                                        <option value="人妖">人妖</option>
                                        <option value="妖人">妖人</option>
                                </select></td>
                            </tr>
                            <tr>
                                <td><input id="savebtn1" type="button" value="提交param" /></td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                </form>
            </td>
            <td>
                <form id="form3" name="form3" method="post" action="test.do?method=testJsonSubmit3">
                    <table id="domain31" border="1">
                        <tbody>
                            <tr>
                                <td colspan="2"><label>表单<font color="red">分区无分组</font>提交
                                </label></td>
                            </tr>
                            <tr>
                                <td><label>用户名</label></td>
                                <td><input type="text" name="username" /></td>
                            </tr>
                            <tr>
                                <td><label>密码</label></td>
                                <td><input type="password" name="passwork" /></td>
                            </tr>
                            <tr>
                                <td><label>爱好</label></td>
                                <td><input type="radio" name="爱好" value="划水" />划水<br /> <input type="radio"
                                    name="爱好" value="划船" />划船<br /> <input type="radio" name="爱好" value="划山" />划山</td>
                            </tr>
                            <tr>
                                <td><label>爱好</label></td>
                                <td><input type="checkbox" name="爱好11" value="划水" />划水<br /> <input
                                    type="checkbox" name="爱好12" value="划山" />划船<br /> <input type="checkbox"
                                    name="爱好13" value="划船" />划山</td>
                            </tr>
                            <tr>
                                <td><label>性别</label></td>
                                <td><select name="sex" multiple="true">
                                        <option value="男">男</option>
                                        <option value="女">女</option>
                                        <option value="人妖">人妖</option>
                                        <option value="妖人">妖人</option>
                                </select></td>
                            </tr>
                        </tbody>
                    </table>
                    <table id="domain32" border="1">
                        <tbody>
                            <tr>
                                <td colspan="2"><label>表单<font color="red">分区无分组</font>提交
                                </label></td>
                            </tr>
                            <tr>
                                <td><label>用户名</label></td>
                                <td><input type="text" name="username" /></td>
                            </tr>
                            <tr>
                                <td><label>密码</label></td>
                                <td><input type="password" name="passwork" /></td>
                            </tr>
                            <tr>
                                <td><label>爱好</label></td>
                                <td><input type="radio" name="爱好" value="划水" />划水<br /> <input type="radio"
                                    name="爱好" value="划船" />划船<br /> <input type="radio" name="爱好" value="划山" />划山</td>
                            </tr>
                            <tr>
                                <td><label>爱好</label></td>
                                <td><input type="checkbox" name="爱好11" value="划水" />划水<br /> <input
                                    type="checkbox" name="爱好12" value="划山" />划船<br /> <input type="checkbox"
                                    name="爱好13" value="划船" />划山</td>
                            </tr>
                            <tr>
                                <td><label>性别</label></td>
                                <td><select name="sex" multiple="true">
                                        <option value="男">男</option>
                                        <option value="女">女</option>
                                        <option value="人妖">人妖</option>
                                        <option value="妖人">妖人</option>
                                </select></td>
                            </tr>
                            <tr>
                                <td><input id="savebtn3" type="button" value="提交domain" /></td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                </form>
            </td>
            <td>
                <form id="form4" name="form4" method="post" action="test.do?method=testJsonSubmit4">
                    <table border="1">
                        <tbody>
                            <tr>
                                <td colspan="2"><label>表单<font color="red">无分区分组</font>提交
                                </label></td>
                            </tr>
                            <tr>
                                <td><label>用户名</label></td>
                                <td><input type="text" name="username" /></td>
                            </tr>
                            <tr>
                                <td><label>密码</label></td>
                                <td><input type="password" name="passwork" /></td>
                            </tr>
                            <tr>
                                <td><label>爱好</label></td>
                                <td><input type="radio" name="爱好" value="划水" />划水<br /> <input type="radio"
                                    name="爱好" value="划船" />划船<br /> <input type="radio" name="爱好" value="划山" />划山</td>
                            </tr>
                            <tr>
                                <td><label>爱好</label></td>
                                <td><input type="checkbox" name="爱好11" value="划水" />划水<br /> <input
                                    type="checkbox" name="爱好12" value="划山" />划船<br /> <input type="checkbox"
                                    name="爱好13" value="划船" />划山</td>
                            </tr>
                            <tr>
                                <td><label>性别</label></td>
                                <td><select name="sex" multiple="true">
                                        <option value="男">男</option>
                                        <option value="女">女</option>
                                        <option value="人妖">人妖</option>
                                        <option value="妖人">妖人</option>
                                </select></td>
                            </tr>
                            <tr>
                                <td><label>用户名</label></td>
                                <td><input type="text" name="username" /></td>
                            </tr>
                            <tr>
                                <td><label>密码</label></td>
                                <td><input type="password" name="passwork" /></td>
                            </tr>
                            <tr>
                                <td><label>爱好</label></td>
                                <td><input type="radio" name="爱好" value="划水" />划水<br /> <input type="radio"
                                    name="爱好" value="划船" />划船<br /> <input type="radio" name="爱好" value="划山" />划山</td>
                            </tr>
                            <tr>
                                <td><label>爱好</label></td>
                                <td><input type="checkbox" name="爱好11" value="划水" />划水<br /> <input
                                    type="checkbox" name="爱好12" value="划山" />划船<br /> <input type="checkbox"
                                    name="爱好13" value="划船" />划山</td>
                            </tr>
                            <tr>
                                <td><label>性别</label></td>
                                <td><select name="sex" multiple="true">
                                        <option value="男">男</option>
                                        <option value="女">女</option>
                                        <option value="人妖">人妖</option>
                                        <option value="妖人">妖人</option>
                                </select></td>
                            </tr>
                            <tr>
                                <td><input id="savebtn4" type="button" value="提交paramGroup" /></td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                </form>
            </td>
            <td>
                <form id="form5" name="form5" method="post" action="test.do?method=testJsonSubmit5">
                    <table id="domain51" border="1">
                        <tbody>
                            <tr>
                                <td colspan="2"><label>表单<font color="red">分区分组</font>提交
                                </label></td>
                            </tr>
                            <tr>
                                <td><label>用户名</label></td>
                                <td><input type="text" name="username" /></td>
                            </tr>
                            <tr>
                                <td><label>密码</label></td>
                                <td><input type="password" name="passwork" /></td>
                            </tr>
                            <tr>
                                <td><label>用户名</label></td>
                                <td><input type="text" name="username" /></td>
                            </tr>
                            <tr>
                                <td><label>密码</label></td>
                                <td><input type="password" name="passwork" /></td>
                            </tr>

                            <tr>
                                <td><label>用户名</label></td>
                                <td><input type="text" name="username" /></td>
                            </tr>
                            <tr>
                                <td><label>密码</label></td>
                                <td><input type="password" name="passwork" /></td>
                            </tr>
                        </tbody>
                    </table>
                    <table id="domain52" border="1">
                        <tbody>
                            <tr>
                                <td><label>用户名</label></td>
                                <td><input type="text" name="username" /></td>
                            </tr>
                            <tr>
                                <td><label>密码</label></td>
                                <td><input type="password" name="passwork" /></td>
                            </tr>
                            <tr>
                                <td><label>爱好</label></td>
                                <td><input type="radio" name="爱好" value="划水" />划水<br /> <input type="radio"
                                    name="爱好" value="划船" />划船<br /> <input type="radio" name="爱好" value="划山" />划山</td>
                            </tr>
                            <tr>
                                <td><label>爱好</label></td>
                                <td><input type="checkbox" name="爱好11" value="划水" />划水<br /> <input
                                    type="checkbox" name="爱好12" value="划山" />划船<br /> <input type="checkbox"
                                    name="爱好13" value="划船" />划山</td>
                            </tr>
                            <tr>
                                <td><label>性别</label></td>
                                <td><select name="sex" multiple="true">
                                        <option value="男">男</option>
                                        <option value="女">女</option>
                                        <option value="人妖">人妖</option>
                                        <option value="妖人">妖人</option>
                                </select></td>
                            </tr>
                            <tr>
                                <td><input id="savebtn5" type="button" value="提交domainGroup2" /></td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                </form>
            </td>
        </tr>
    </table>
</body>
</html>
