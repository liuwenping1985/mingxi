<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums.*"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>函数自定义帮助界面</title>
</head>
<body scroll="no">
    <form name="formulaHelp" method="post">
        <div class="form_area" style="height:400px;overflow:auto;">
        <br>
           <b>函数定义规则</b>：<br/><br/> 
           <p>
           &nbsp;&nbsp;1.函数定义示例<br/><br/>
           	&nbsp;&nbsp;&nbsp;&nbsp;def <font color="red">a函数名称</font>(<font color="red">b参数</font>){ ----函数头<br/><br/>
           		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="red">c函数代码</font>                 ----函数内容<br/><br/>
           	&nbsp;&nbsp;&nbsp;&nbsp;}					----函数结尾<br/><br/>
           </p>
           <p>
           &nbsp;&nbsp;2.函数示例中标注了 a,b,c三个位置。<br/><br/>
           	&nbsp;&nbsp;&nbsp;&nbsp;a位置为<b><font color="red">函数名称</font></b>，由客户自定义的函数名称。<br/><br/>
           	&nbsp;&nbsp;&nbsp;&nbsp;b位置为<b><font color="red">函数参数</font></b>，由客户参数设置中设置，以固定参数名称为"param"传入。<br/><br/>
           	&nbsp;&nbsp;&nbsp;&nbsp;c位置为<b><font color="red">函数代码</font></b>，由客户自己写的函数代码内容。<br/><br/>
           </p>
           <p>
           &nbsp;&nbsp;3.函数参数使用 <br/><br/>
           	&nbsp;&nbsp;&nbsp;&nbsp;客户代码中使用参数param示例。param是以数组的形式传入。<br/><br/>
           	&nbsp;&nbsp;&nbsp;&nbsp;客户通过param[0],param[1]...的方式使用参数。参数顺序由参数设置中定义。<br/><br/>
           </p>
           <p>
           &nbsp;&nbsp;<font color="red">4.注意事项<br/><br/>
           	&nbsp;&nbsp;&nbsp;&nbsp;a.客户只需要提供函数代码内容，函数头和函数结尾系统自动添加。<br/><br/>
           	&nbsp;&nbsp;&nbsp;&nbsp;其中函数头的函数名称由客户定义，参数是固定param.<br/><br/>
           	&nbsp;&nbsp;&nbsp;&nbsp;b.函数必须要有返回值，返回数字类型的函数必须返回数字类型，否则返回值默认为0.<br/><br/>
           	&nbsp;&nbsp;&nbsp;&nbsp;返回文本类型的必须返回文本类型，否则返回类型为空字符串。<br/><br/>
           	&nbsp;&nbsp;&nbsp;&nbsp;c.客户无须填写函数头及函数结尾，只需要填写函数内容。<br/><br/>
            &nbsp;&nbsp;&nbsp;&nbsp;d.校验规则处使用函数自定义时，只能单独使用，不能和其他表达式一起使用。<br/><br/>
            &nbsp;&nbsp;&nbsp;&nbsp;e.校验规则处使用函数自定义时，需要保证函数返回的值为boolean值(true or false)，否则默认返回false。<br/><br/></font>
           </p>
        </div>
    </form>
</body>
</html>
