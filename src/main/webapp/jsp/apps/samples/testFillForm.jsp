<%--
 $Author: wuym $
 $Rev: 2829 $
 $Date:: 2012-12-14 10:54:53#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>表单回填测试</title>
</head>
<body leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
    <form action="">
        <div id="area1">
            用户名：<input type="text" id="username"/><br/>
            密码：<input type="text" id="userage"/><br/>
            爱好：<input type="checkbox" id="aihao1" value="1"/>(1)<input type="checkbox" id="aihao2" value="2"/>(2)<input type="checkbox" id="aihao3" value="3"/>(3)<br/>
            性别：<input type="radio" id="sex" name="sex" value="1"/>(男)<input type="radio" id="sex" name="sex" value="2"/>(女)<br/>
            球级：<select id="qiuji">
                <option value="1">地球</option>
                <option value="2">月球</option>
                <option value="3">火星</option>
            </select><br/>
            实力：<select id="shili" multiple="true">
                <option value="1">天</option>
                <option value="2">地</option>
                <option value="3">人</option>
            </select>
        </div>
        <div id="area22">
            用户名：<textarea id="username" name="username"></textarea><br/>
            密码：<input type="text" id="userage"/><br/>
            爱好：<input type="checkbox" id="aihao1" value="1"/>(1)<input type="checkbox" id="aihao2" value="2"/>(2)<input type="checkbox" id="aihao3" value="3"/>(3)<br/>
            性别：<input type="radio" id="sex" name="sex2" value="1"/>(男)<input type="radio" id="sex" name="sex2" value="2"/>(女)<br/>
            球级：<select id="qiuji">
                <option value="1">地球</option>
                <option value="2">月球</option>
                <option value="3">火星</option>
            </select><br/>
            实力：<select id="shili" multiple="true">
                <option value="1">天</option>
                <option value="2">地</option>
                <option value="3">人</option>
            </select>
        </div>
    </form>
</body>
</html>
