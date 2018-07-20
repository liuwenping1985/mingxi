<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>版式模板列表说明</title>
</head>
<body class="color_gray">
    <div class="clearfix">
        <h2 class="left">${ctp:i18n('infosend.dataBase.index.infoScoreCriteria')}<!-- 信息评分标准设置 --></h2>
        <div class="font_size12 left margin_t_20 margin_l_10">
            <div class="margin_t_10 font_size14">${ctp:i18n('collaboration.stat.all')}<%--总计 --%> 
                <span class="font_bold color_black">${ctp:toHTML(size)}</span> ${ctp:i18n('collaboration.stat.records')}<%--条 --%>
            </div>
        </div>
    </div>
    <div class="line_height160 font_size12 margin_l_10">
              <p><span class="font_size12">●</span>${ctp:i18n('infosend.score.label.help.0')}<!-- 单击“新建”菜单，新建信息评分标准。 --></p>
              <p><span class="font_size12">●</span>${ctp:i18n('infosend.score.label.help.1')}<!-- 勾选一条信息评分标准记录后单击“修改”菜单或双击列表中的信息评分标准记录，修改信息评分标准相关信息。 --></p>
              <p><span class="font_size12">●</span>${ctp:i18n('infosend.score.label.help.2')}<!-- 勾选列表中的信息评分标准，单击“启用”或“停用”菜单，对选中的信息评分标准进行启用或停用。 --></p>
    </div>
</body>
</html>
