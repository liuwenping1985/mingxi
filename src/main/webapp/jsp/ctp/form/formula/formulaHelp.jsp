<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums.*"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>帮助界面</title>
</head>
<body scroll="no">
    <form name="formulaHelp" method="post">
        <div class="form_area" style="height: 500px;overflow: auto;">
            <div style="width: 100px;text-align: right;">[<font color="red">算术运算符</font>]：</div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">[+]：</div>
                <div  class="left" style="width: 470px;text-align: left;">支持数字类型字段的算术运算和字符串组合，如果先选择日期，日期时间类字段，会弹出日期计算设置框</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">[-]：</div>
                <div  class="left" style="width: 470px;text-align: left;">支持数字类型字段的算术运算，如果先选择日期，日期时间类字段，会弹出日期计算设置框</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">[ * / ]：</div>
                <div  class="left" style="width: 470px;text-align: left;">只支持数字类型字段的算术运算</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">[<font color="red">关系运算符</font>]：</div>
                <div  class="left" style="width: 470px;text-align: left;">> < == 〈〉 >= <= ，其中 = 〈〉支持字符串类型字段运算，格式：{表单数据域} = ‘字符串’<br/>
                </div>
            </div>
            <div style="width: 100px;text-align: right;">[<font color="red">逻辑运算符</font>]：</div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">and：</div>
                <div  class="left" style="width: 470px;text-align: left;">逻辑与，条件表达式1 and 条件表达式2</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">or：</div>
                <div  class="left" style="width: 470px;text-align: left;">逻辑或，条件表达式1 or 条件表达式2</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">not：</div>
                <div  class="left" style="width: 470px;text-align: left;">逻辑非，not（条件表达式）</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">[<font color="red">函数类</font>]：</div>
                <div  class="left" style="width: 470px;text-align: left;">所有函数设置方式为：先选中字段，然后点击对应函数按钮，在弹出的界面按需设置，都不建议手动录入</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">包含：</div>
                <div  class="left" style="width: 470px;text-align: left;">like({表单数据域},‘字符串’)，返回boolean型</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">不包含：</div>
                <div  class="left" style="width: 470px;text-align: left;">not_like({表单数据域},‘字符串’)，返回boolean型</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">in：</div>
                <div  class="left" style="width: 470px;text-align: left;">单组织机构控件值存在于选择的值中，返回boolean型，in({选人},‘人员1,人员2’)</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">extend：</div>
                <div  class="left" style="width: 470px;text-align: left;">扩展控件值比较设置按钮，适用于控件类型或者外部写入字段的显示格式为复选框、单选按钮、下拉框、日期控件、日期时间控件、选择关联表单、数据关联、选择关联项目、选择人员、选择多人、选择单位、选择多单位、选择部门、选择多部门、选择岗位、选择多岗位、选择职务级别、选择多职务级别，具体设置效果应字段不同而不同</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">日期差：</div>
                <div  class="left" style="width: 470px;text-align: left;">日期差，计算两个日期，日期时间类型字段的差值，differDate({日期1},{日期2}) </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">取年：</div>
                <div  class="left" style="width: 470px;text-align: left;">获取日期，日期时间字段表示年份的部分，返回数字型，year({表单数据域})</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">取月：</div>
                <div  class="left" style="width: 470px;text-align: left;">获取日期，日期时间字段的表示月度的部分，返回数字型，month({表单数据域})</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">取日：</div>
                <div  class="left" style="width: 470px;text-align: left;">获取日期，日期时间字段的表示天的部分，返回数字型，day({表单数据域})</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">取星期几：</div>
                <div  class="left" style="width: 470px;text-align: left;">获取日期，日期时间字段对应的星期几，返回数字型：weekday({表单数据域})</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">取日期：</div>
                <div  class="left" style="width: 470px;text-align: left;">获取日期时间字段表示日期的部分，返回日期类型：date({表单数据域})</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">取时间：</div>
                <div  class="left" style="width: 470px;text-align: left;">获取日期时间字段表示时间的部分，返回文本型：time({表单数据域})</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">取整：</div>
                <div  class="left" style="width: 470px;text-align: left;">获取数字类型的整数部分，返回数字型：getInt({表单数据域}) </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">取余：</div>
                <div  class="left" style="width: 470px;text-align: left;">获取两个数字类型的相除的余数，返回数字型：getMod({表单数据域1},{表单数据域2})  </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">大写长格式：</div>
                <div  class="left" style="width: 470px;text-align: left;">转换数字字段为中文货币大写长格式，返回文本型，toUpperForLong({表单数据域})</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">大写短格式：</div>
                <div  class="left" style="width: 470px;text-align: left;">转换数字字段为中文货币大写短格式，返回文本型，toUpperForShort({表单数据域})</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">中文小写：</div>
                <div  class="left" style="width: 470px;text-align: left;">转换数字字段为中文小写，返回文本型，toUpper({表单数据域}) </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">[<font color="red">重复表函数</font>]：</div>
                <div  class="left" style="width: 470px;text-align: left;">&nbsp;</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">重复表合计：</div>
                <div  class="left" style="width: 470px;text-align: left;">对重复表数字字段求和，返回数字型，sum({表单数据域})</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">重复表平均：</div>
                <div  class="left" style="width: 470px;text-align: left;">对重复表数字字段平均，返回数字型，aver({表单数据域})</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">重复表任一行：</div>
                <div  class="left" style="width: 470px;text-align: left;">只需要重复表某一条记录满足条件，仅适用于校验规则设置，返回boolean型，exist(条件表达式)</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">重复表所有行：</div>
                <div  class="left" style="width: 470px;text-align: left;">需要重复表所有行记录满足条件，仅适用于校验规则设置，返回boolean型，all(条件表达式)</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">重复表最大：</div>
                <div  class="left" style="width: 470px;text-align: left;">返回表单数据域所在重复记录中的最大值，返回数字型，max({表单数据域}) </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">重复表最小：</div>
                <div  class="left" style="width: 470px;text-align: left;">返回表单数据域所在重复记录中的最小值，返回数字型，min({表单数据域}) </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">重复表分类合计：</div>
                <div  class="left" style="width: 470px;text-align: left;">对所有满足条件的重复项记录做求和，返回数字型，sumif({表单数据域}，条件表达式) </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">重复表分类平均：</div>
                <div  class="left" style="width: 470px;text-align: left;">对所有满足条件的重复项记录做平均，返回数字型，averif({表单数据域}，条件表达式) </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">重复表分类最大：</div>
                <div  class="left" style="width: 470px;text-align: left;">求所有满足条件的重复项记录的最大值，返回数字型，maxif({表单数据域}，条件表达式) </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 100px;text-align: right;">重复表分类最小：</div>
                <div  class="left" style="width: 470px;text-align: left;">求所有满足条件的重复项记录的最小值，返回数字型，minif({表单数据域}，条件表达式) </div>
            </div>
        </div>
    </form>
</body>
</html>
