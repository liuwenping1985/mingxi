<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>信息报送列表说明</title>
</head>
<body class="color_gray">
    <div class="clearfix">
        <h2 class="left">${ctp:i18n('govform.help.summary.info.1')}<!-- 报送单定义 --></h2>
        <div class="font_size12 left margin_t_20 margin_l_10">
            <div class="margin_t_10 font_size14">${ctp:i18n('collaboration.stat.all')}<%--总计 --%> 
                <span class="font_bold color_black">${ctp:toHTML(size)}</span> ${ctp:i18n('collaboration.stat.records')}<%--条 --%>
            </div>
        </div>
    </div>
    <div class="line_height160 font_size12 margin_l_10">
        <!-- 待办事项是指存储发给我的还没有处理流程事项。 -->
        <p><span class="font_size12">●</span>${ctp:i18n('govform.help.summary.info.2')}<!-- 单击“新建”菜单，上传报送单设计文件后，新建对应类型的报送单。 --></p>
        <!-- 单击列表标题可以进行快速排序。 -->
        <p><span class="font_size12">●</span>${ctp:i18n('govform.help.summary.info.3')}<!-- 勾选一条报送单记录后单击“修改”菜单或双击列表中的报送单记录，修改报送单相关信息。 --></p>
        <!-- 单击列表中的信息条目可以查看信息详细内容。 -->
        <p><span class="font_size12">●</span>${ctp:i18n('govform.help.summary.info.4')}<!-- 勾选列表中的报送单记录，单击“删除”菜单，删除选中的报送单。其中，系统报送单不允许删除。 --></p>
    </div>
</body>
</html>
