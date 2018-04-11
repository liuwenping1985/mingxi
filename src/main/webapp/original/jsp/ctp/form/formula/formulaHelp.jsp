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
            <div style="width: 140px;text-align: right;">[<font color="red">${ctp:i18n('form.formula.engin.function.help.arithmetic.operator')}</font>]：</div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">[+]：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.arithmetic.operator.plus')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">[-]：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.arithmetic.operator.minus')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">[ * / ]：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.arithmetic.operator.multipyordivide')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">[<font color="red">${ctp:i18n('form.formula.engin.function.help.relational.operator')}</font>]：</div>
                <div  class="left" style="width: 420px;text-align: left;">> < \=\= <> >\= <\= , ${ctp:i18n('form.formula.engin.function.help.relational.operator.desc')}<br/>
                </div>
            </div>
            <div style="width: 140px;text-align: right;">[<font color="red">${ctp:i18n('form.formula.engin.function.help.logical.operator')}</font>]：</div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">and：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.logical.operator.and')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">or：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.logical.operator.or')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">not：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.logical.operator.not')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">[<font color="red">${ctp:i18n('form.formula.engin.function.help.function')}</font>]：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.desc')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.like')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.like.desc')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.notlike')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.notlike.desc')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">in：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.in')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">len：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.len')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">extend：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.extend')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.differDate')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.differDate.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.differDateTime')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.differDateTime.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.year')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.year.desc')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.month')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.month.desc')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.day')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.day.desc')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.weekday')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.weekday.desc')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.date')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.date.desc')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.time')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.time.desc')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.getInt')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.getInt.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.getMod')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.getMod.desc')}  </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.toUpperForLong')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.toUpperForLong.desc')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.toUpperForShort')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.toUpperForShort.desc')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.toUpper')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.toUpper.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">[<font color="red">${ctp:i18n('form.formula.engin.function.help.function.subTable')}</font>]：</div>
                <div  class="left" style="width: 420px;text-align: left;">&nbsp;</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.subTable.sum')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.subTable.sum.desc')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.subTable.aver')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.subTable.aver.desc')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.subTable.exist')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.subTable.exist.desc')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.subTable.all')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.subTable.all.desc')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.subTable.unique')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.subTable.unique.desc')}</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.subTable.max')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.subTable.max.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.subTable.min')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.subTable.min.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.subTable.sumif')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.subTable.sumif.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.subTable.averif')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.subTable.averif.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.subTable.maxif')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.subTable.maxif.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.subTable.minif')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.subTable.minif.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.subTable.earliest')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.subTable.earliest.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.subTable.latest')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.subTable.latest.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.preRow')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.preRow.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">[<font color="red">${ctp:i18n('form.formula.engin.function.help.function.getSubValue')}</font>]：</div>
                <div  class="left" style="width: 420px;text-align: left;">&nbsp;</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.getSubValue.fisrt')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.getSubValue.fisrt.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.getSubValue.last')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.getSubValue.last.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.getSubValue.max')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.getSubValue.max.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.getSubValue.min')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.getSubValue.min.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.getSubValue.earliest')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.getSubValue.earliest.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.getSubValue.latest')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.getSubValue.latest.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">[<font color="red">${ctp:i18n('form.formula.engin.function.help.function.summarize.label')}</font>]：</div>
                <div  class="left" style="width: 420px;text-align: left;">&nbsp;</div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.summarize.sum')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.summarize.sum.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.summarize.aver')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.summarize.aver.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.summarize.max')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.summarize.max.desc')} </div>
            </div>
            <div class="clearfix margin_t_5">
                <div  class="left" style="width: 140px;text-align: right;">${ctp:i18n('form.formula.engin.function.help.function.summarize.min')}：</div>
                <div  class="left" style="width: 420px;text-align: left;">${ctp:i18n('form.formula.engin.function.help.function.summarize.min.desc')} </div>
            </div>
        </div>
    </form>
</body>
</html>
