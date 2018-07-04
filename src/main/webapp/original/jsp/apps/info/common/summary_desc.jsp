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
        <h2 class="left">${desc}</h2>
        <div class="font_size12 left margin_t_20 margin_l_10">
            <div class="margin_t_10 font_size14">${ctp:i18n('collaboration.stat.all')}<%--总计 --%> 
                <span class="font_bold color_black">${size}</span> ${ctp:i18n('collaboration.stat.records')}<%--条 --%>
            </div>
        </div>
    </div>
    <div class="line_height160 font_size12 margin_l_10">
        <c:if test="${type eq 'listInfoPending'}">
              <!-- 待办事项是指存储发给我的还没有处理流程事项。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable1')}</p>
              <!-- 单击列表标题可以进行快速排序。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable2')}</p>
              <!-- 单击列表中的信息条目可以查看信息详细内容。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable3')}</p>
              <!-- 单击列表中的信息条目，点击“处理”按钮，可以对该事项进行处理；点击“流程”按钮，可以查看该事项的流程；<br>&nbsp&nbsp点击“属性”按钮，可以查看该事项的属性。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable4')}<br>&nbsp;&nbsp;${ctp:i18n('collaboration.listDesc.lable5')}</p>
              <!-- 勾选列表中的事项，点击“归档”按钮，可以将该信息归入文档库。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable6')}</p>
              <!-- 勾选列表中的事项，再继续点击“转发”按钮， 可以对该信息进行转发操作。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable7')}</p>
        </c:if>
        <c:if test="${type eq 'listInfoDraft'}">
              <!-- 待发事项指存储没有发出的流程事项。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable8')}</p>
              <!-- 单击列表标题可以进行快速排序。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable2')}</p>
              <!-- 单击列表中的信息条目可以查看信息详细内容。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable3')}</p>
              <!-- 勾选列表中的事项，点击“发送”按钮，可以对该信息进行发送操作。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable9')}</p>
              <!-- 勾选列表中的事项，点击“转发”按钮，可以对该信息进行转发操作。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable10')}</p>
        </c:if>
        <c:if test="${type eq 'listInfoReported'}">
              <!-- 已发事项指存储我发出的流程事项。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable11')}</p>
              <!-- 单击列表标题可以进行快速排序。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable2')}</p>
              <!-- 单击列表中的信息条目可以查看信息详细内容。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable3')}</p>
              <!-- 勾选列表中的事项，点击“转发”按钮，可以对该信息进行转发操作。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable10')}</p>
              <!-- 勾选列表中的事项，点击“归档”按钮，可以将该信息归入文档库。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable6')}</p>
              <!-- 勾选列表中的事项，点击“撤销流程”按钮，可以终止该事项的流转。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable12')}</p>
        </c:if>
        <c:if test="${type eq 'listInfoDone'}">
              <!-- 已办事项是指存储发给我的并已经处理流程事项。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable13')}</p>
              <!-- 单击列表标题可以进行快速排序。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable2')}</p>
              <!-- 单击列表中的信息条目可以查看信息详细内容。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable3')}</p>
              <!-- 勾选列表中的事项，点击“取回”按钮，可以将已提交的事项撤销。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable14')}</p>
              <!-- 勾选列表中的事项，点击“归档”按钮，可以将该信息归入文档库。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable6')}</p>
              <!-- 勾选列表中的事项，点击“转发”按钮， 可以对该信息进行转发操作。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable10')}</p>
        </c:if>
        <c:if test="${type eq 'listSupervise'}">
              <!-- “未办结”: 流程未办理结束 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable15')}</p>
              <!-- “已办结”: 流程已办理结束(包含被终止但不能回退的流程，流程不能继续流转)。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable16')}</p>
              <!-- 单击蓝色的小喇叭，可以在查看该督办项的工作流程，并对流程中未办节点发送“催办”消息。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable17')}</p>
              <!-- 督办期限为红色的督办项表示：已超过督办期限但仍未办结（流程未结束）的事项。 -->
              <p><span class="font_size12">●</span>${ctp:i18n('collaboration.listDesc.lable18')}</p>
        </c:if>
    </div>
</body>
</html>
