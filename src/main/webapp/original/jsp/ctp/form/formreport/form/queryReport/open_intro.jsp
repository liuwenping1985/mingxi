<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>${ctp:i18n('report.queryReport.open_intro.title')}</title>
</head>
<body class="page_color" id='layout'>
<div class="color_gray margin_l_20">
    <div class="clearfix">
        <h2 class="left">${ctp:i18n('report.queryReport.open_intro.title')}</h2><!-- 统计穿透列表查看 -->
        <div class="font_size12 left margin_t_20 margin_l_10">
            <div class="margin_t_10 font_size14">${ctp:i18n('report.queryReport.open_intro.totoal')} <span class="font_bold color_black"><!-- 总计 -->
              <script type="text/javascript">
                  var countSize=window.parent.document.getElementById("countSize").value;//数量
                  document.write(countSize);
              </script>
            </span> ${ctp:i18n('report.queryReport.open_intro.unit')}</div><!-- 条 -->
        </div>
    </div>
    <div class="line_height160 font_size14">
        <p><span class="font_size12">●</span>${ctp:i18n('report.queryReport.open_intro.intro1')}</p><!-- 单击列表中的信息条目以上下视图方式查看详细内容. -->
    </div>
</div>
</body>
</html>
