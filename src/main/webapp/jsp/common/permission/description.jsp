<%--
 $Author: wuym $
 $Rev: 1697 $
 $Date:: #$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <!-- 节点权限操作说明 -->
    <title>${ctp:i18n('permission.node.description.lable')}</title>
</head>
<body class="page_color font_size12">
            <div class="padding_10 line_height160">
                <c:if test="${category!='info_send_permission_policy'}">
                    <div class="border_all padding_5">
                        <!-- 【加 签】:  -->
                        <p>${ctp:i18n('template.common.description.label1')}</p>
                        <!-- 在当前节点后面增加后续节点，并为其设定权限（如：审批等），提供“并发、串发、与下节点并发”三种流程模式可选。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label2')} </p>
                    </div>
                    <div class="border_all padding_5 margin_t_10">
                        <!-- 【处理后归档】:  -->
                        <p>${ctp:i18n('template.common.description.label3')}</p>
                        <!-- 勾选后，如果选择提交，则允许用户选择归档文档夹，提交处理结果的同时将该协同归档到指定文档夹。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label4')}</p>
                    </div>
                    <div class="border_all padding_5  margin_t_10">
                        <!-- 【回 退】: -->
                        <p>${ctp:i18n('template.common.description.label5')}</p>
                        <!-- 将协同回退给上一节点，如果上一节点是发起节点，则到发起者的待发事项中。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label6')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【指定回退】:  -->
                        <p>${ctp:i18n('element.help53.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.help53.1.label')}</p>
                    </div>
                    <div class="border_all padding_5  margin_t_10">
                        <!-- 【意 见】: -->
                        <p>${ctp:i18n('template.common.description.label7')}</p>
                        <!-- 操作者可以填写自己的意见。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label8')}</p>
                    </div>
<%--                     <div class="border_all padding_5  margin_t_10">
                        <!-- 【存为草稿】: -->
                        <p>${ctp:i18n('template.common.description.label9')}</p>
                        <!-- 操作者的操作意见被保存在意见框中；关闭窗口再次打开时，上次“存为草稿”的意见仍然存在，可以修改。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label10')}</p>
                    </div> --%>
                    <%-- <div class="border_all padding_5  margin_t_10">
                        <!-- 【转 发】: -->
                        <p>${ctp:i18n('template.common.description.label11')}</p>
                        <!-- 将当前协同变为新建流程发给他人，可增加附言，选择是否转发原附言，是否转发原意见，是否跟踪，可插入附件和关联文档；不影响当前协同的处理。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label12')}</p>
                    </div> --%>
                    <div class="border_all padding_5  margin_t_10">
                        <!-- 【跟 踪】: -->
                        <p>${ctp:i18n('template.common.description.label13')}</p>
                        <!-- 设为跟踪后，协同在首页我的跟踪事项中显示，并且他人对协同所做的操作都会发送当前节点提示信息。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label14')}</p>
                    </div>
                    <div class="border_all padding_5  margin_t_10">
                        <!--【提 交】: -->
                        <p>${ctp:i18n('template.common.description.label15')}</p>
                        <!-- 当前流程被处理，流程进入下一节点。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label16')}</p>
                    </div>
                    <div class="border_all padding_5  margin_t_10">
                        <!-- 【知 会】:  -->
                        <p>${ctp:i18n('template.common.description.label17')}</p>
                        <!--在当前节点与后续节点间插入节点，节点权限自动设置为知会，如果选择多个知会节点，节点并发。-->
                        <p class="text_indent">${ctp:i18n('template.common.description.label18')}</p>
                    </div>
                    <div class="border_all padding_5  margin_t_10">
                        <!-- 签 章】:  -->
                        <p>${ctp:i18n('template.common.description.label19')}</p>
                        <!-- 调用签章控件，对Office正文加签印章或印章校验。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label20')}</p>
                    </div>
                    <div class="border_all padding_5  margin_t_10">
                        <!-- 分送】:  -->
                        <p>${ctp:i18n('template.common.description.label79')}</p>
                        <!-- 对收文进行分送对应人员继续处理  -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label80')}</p>
                    </div>
                    <div class="border_all padding_5  margin_t_10">
                        <!-- 签收】:  -->
                        <p>${ctp:i18n('template.common.description.label81')}</p>
                        <!-- 对收文进行签收，签收记录并入收文登记簿。  -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label82')}</p>
                    </div> 
                   <c:if test ="${(v3x:getSysFlagByName('event_notShow')!='true')}">
	                    <div class="border_all padding_5   margin_t_10">
	                        <!-- 【转 事 件】: -->
	                        <p>${ctp:i18n('template.common.description.label21')}</p>
	                        <!-- 将当前协同自动转化为日程事件。 -->
	                        <p class="text_indent">${ctp:i18n('template.common.description.label22')}</p>
	                    </div>
                    </c:if>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【常 用 语】: -->
                        <p>${ctp:i18n('template.common.description.label23')}</p>
                        <!-- 处理人可选择进行快捷回复的处理意见。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label24')}</p>
                    </div>
                   <%--  <div class="border_all padding_5   margin_t_10">
                        <!-- 【意见隐藏】: -->
                        <p>${ctp:i18n('template.common.description.label25')}</p>
                        <!-- 处理人填写的意见对流程中其他人员进行隐藏，但是发起者可以看见其意见。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label26')}</p>
                    </div> --%>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【插入附件】: -->
                        <p>${ctp:i18n('template.common.description.label27')}</p>
                        <!-- 处理协同时，选择本地文件上传，并作为处理意见的一部分提交。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label28')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【暂存待办】: -->
                        <p>${ctp:i18n('template.common.description.label29')}</p>
                        <!-- 保存用户本次输入的意见和态度，流程将在当前用户处暂停，用户可以随时在自己的【待办事项】中继续处理该事项。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label30')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【减 签】: -->
                        <p>${ctp:i18n('template.common.description.label31')}</p>
                        <!-- 处理者可在当前节点之后减少一级节点，可进行连续减签操作。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label32')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【当前会签】: -->
                        <p>${ctp:i18n('template.common.description.label33')}</p>
                        <!-- 在流程中增加一个与当前节点并列的节点，节点权限与当前节点相同。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label34')}</p>
                    </div>
<%--                     <div class="border_all padding_5   margin_t_10">
                        <!-- 【流程节点处理明细】: -->
                        <p>${ctp:i18n('template.common.description.label35')}</p>
                        <!-- 可以查看从发起到现在的处理时间明细记录。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label36')}</p>
                    </div> --%>
<%--                     <div class="border_all padding_5   margin_t_10">
                        <!-- 【流程日志】: -->
                        <p>${ctp:i18n('template.common.description.label37')}</p>
                        <!-- 可以查看流程从发起到现在的处理操作记录。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label38')}</p>
                    </div> --%>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【打 印】: -->
                        <p>${ctp:i18n('template.common.description.label39')}</p>
                        <!-- 对该协同进行打印设置，预览和打印。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label40')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【终 止】: -->
                        <p>${ctp:i18n('template.common.description.label41')}</p>
                        <!-- 终止当前流程，后续节点不会接到该流程，待办节点的事项将被取消，进入已办事件备查。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label42')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【关联文档】: -->
                        <p>${ctp:i18n('template.common.description.label43')}</p>
                        <!-- 处理者可从协同和文档中心选择文档，作为处理意见的一部分提交。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label44')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【撤 销】: -->
                        <p>${ctp:i18n('template.common.description.label45')}</p>
                        <!-- 流程被撤销，已处理的节点将收到撤销通知，未处理的节点不会收到该流程，流程将撤回到发起者的待发栏中。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label46')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【修改正文】: -->
                        <p>${ctp:i18n('template.common.description.label47')}</p>
                        <!-- 处理人可以对Html、word、excel、wps、et正文进行修改。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label48')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【督办设置】: -->
                        <p>${ctp:i18n('template.common.description.label49')}</p>
                        <!-- 设置或修改协同流程的督办人员、督办期限、督办主题等 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label50')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【修改附件】: -->
                        <p>${ctp:i18n('template.common.description.label51')}</p>
                        <!-- 可以对列表的附件进行增加、删除;点击OFFICE附件，进行在线编辑。支持OFFICE附件（金格插件现在支持的文件格式）。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label52')}</p>
                    </div>
                </c:if>
                <c:if test="${category!='col_flow_perm_policy' && category!='info_send_permission_policy'}">
                    <%-- <div class="border_all padding_5   margin_t_10">
                        <!-- 【文号修改】: -->
                        <p>${ctp:i18n('template.common.description.label53')}</p>
                        <!-- 修改公文文号，可进行断号选择，在授权许可的情况下，可手工输入文号。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label54')}</p>
                    </div> --%>
                     <div class="border_all padding_5   margin_t_10">
                        <!-- 【多级会签】: -->
                        <p>${ctp:i18n('template.common.description.label55')}</p>
                        <!-- 将公文会签给他人，流程中增加处理节点，但与【当前会签】不同的是，待所有会签者处理完毕后，流程又流转到进行多级会签操作的处理者中，待其再次处理后流程才往下流转。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label56')}</p>
                    </div>
<%--                      <div class="border_all padding_5   margin_t_10">
                        <!-- 【修改文单】: -->
                        <p>${ctp:i18n('template.common.description.label57')}</p>
                        <!-- 修改公文单，只能修改当前节点有编辑权限的文单元素内容。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label58')}</p>
                    </div> --%>
                     <div class="border_all padding_5   margin_t_10">
                        <!-- 【传    阅】: -->
                        <p>${ctp:i18n('template.common.description.label59')}</p>
                        <!-- 将公文传阅给相关人员，被传阅人的节点权限自动设置为阅读。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label60')}</p>
                    </div>
                   <div class="border_all padding_5   margin_t_10">
                        <!-- 【转 公 告】: -->
                        <p>${ctp:i18n('template.common.description.label61')}</p>
                        <!-- 当前处理者具备集团公告、单位公告、部门公告发布权限时，可将公文正文及附件发布到集团、单位或部门公告中。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label62')}</p>
                    </div>
                   <div class="border_all padding_5   margin_t_10">
                        <!-- 【正文打印】: -->
                        <p>${ctp:i18n('template.common.description.label63')}</p>
                        <!-- 对正文的打印权限做控制，具备此权限才能打印公文正文。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label64')}</p>
                    </div>
                   <div class="border_all padding_5   margin_t_10">
                        <!-- 【正文套红】: -->
                        <p>${ctp:i18n('template.common.description.label65')}</p>
                        <!-- 选择正文套红模板，将公文正文、标题、主送单位等套入模版指定位置。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label66')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                       <!-- 【文单套红】: -->
                        <p>${ctp:i18n('template.common.description.label67')}</p>
                        <!-- 选择文单套红模版，将文单内容按模板格式套入指定位置，用于打印。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label68')}</p>
                    </div>
                    <%-- <div class="border_all padding_5   margin_t_10">
                        <!-- 【部门归档】: -->
                        <p>${ctp:i18n('template.common.description.label69')}</p>
                        <!-- 将公文归档一份到单位文档，当前用户必须具备单位文档的写入权限。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label70')}</p>
                    </div> --%>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【正文保存】: -->
                        <p>${ctp:i18n('template.common.description.label71')}</p>
                        <!-- 对正文的保存权限做控制，具备此权限才能把正文保存在本地。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label72')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【文单签批】: -->
                        <p>${ctp:i18n('template.common.description.label73')}</p>
                        <!-- 对文单进行手写签批及盖章，提交后会显示在文单的该节点意见框中。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label74')}</p>
                    </div>
                     <div class="border_all padding_5   margin_t_10">
                        <!-- 【上传附件】: -->
                        <p>${ctp:i18n('template.common.description.label75')}</p>
                        <!-- 处理公文时，选择本地文件上传，并作为处理意见的一部分提交。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label76')}</p>
                    </div>
                   <%--  <div class="border_all padding_5   margin_t_10">
                        <!-- 【交换类型】: -->
                        <p>${ctp:i18n('template.common.description.label77')}</p>
                        <!-- 提供“交部门收发员交换”和“交单位收发员交换”两种交换方式，选择交换类型后，公文进入相应收发员的交换中心中。 -->
                        <p class="text_indent">${ctp:i18n('template.common.description.label78')}</p>
                    </div> --%>
                </c:if>
                <c:if test="${category=='info_send_permission_policy'}">
                    <div class="border_all padding_5  ">
                        <!-- 【加 签】:  -->
                        <p>${ctp:i18n('element.help1.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.help.1.label')} </p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【回退】:  -->
                        <p>${ctp:i18n('element.help50.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.help3.1.1.label')}</p>
                    </div>
					<div class="border_all padding_5   margin_t_10">
                        <!-- 【指定回退】:  -->
                        <p>${ctp:i18n('element.help53.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.help53.1.label')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【减签】: -->
                        <p>${ctp:i18n('element.help18.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.help18.1.label')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【终止】: -->
                        <p>${ctp:i18n('element.help23.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.help23.1.label')}</p>
                    </div>

<%--                     <div class="border_all padding_5   margin_t_10">
                        <!-- 【修改报送单】: -->
                        <p>${ctp:i18n('element.help51.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.help52.1.label')}</p>
                    </div> --%>
                    <!-- 【部门归档】: -->
					<!--
                    <div class="border_all padding_5   margin_t_10">
                        <p>${ctp:i18n('element.info.help14.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.info.help14.1.label')}</p>
                    </div>
					-->
                    <div class="border_all padding_5   margin_t_10">
                        <!--【跟踪】: -->
                        <p>${ctp:i18n('element.info.help21.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.info.help21.1.label')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【暂存待办】:  -->
                        <p>${ctp:i18n('element.help17.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.help17.1.label')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【提交】:  -->
                        <p>${ctp:i18n('element.help9.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.help9.1.label')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【意见】: -->
                        <p>${ctp:i18n('element.info.help25.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.info.help25.1.label')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【常用语】: -->
                        <p>${ctp:i18n('element.info.help26.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.info.help26.1.label')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【上传附件】: -->
                        <p>${ctp:i18n('element.info.help27.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.info.help27.1.label')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【打印】: -->
                        <p>${ctp:i18n('element.info.help28.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.info.help28.1.label')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【关联文档】: -->
                        <p>${ctp:i18n('element.info.help29.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.info.help29.1.label')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【正文打印】: -->
                        <p>${ctp:i18n('element.info.help31.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.info.help31.1.label')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【正文保存】: -->
                        <p>${ctp:i18n('element.info.help32.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.info.help32.1.label')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【处理后归档】: -->
                        <p>${ctp:i18n('element.info.help33.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.info.help33.1.label')}</p>
                    </div>
                    <div class="border_all padding_5   margin_t_10">
                        <!-- 【修改正文】: -->
                        <p>${ctp:i18n('element.info.help34.label')}</p>
                        <!-- 可以查看流程从发起到现在的处理操作记录。 -->
                        <p class="text_indent">${ctp:i18n('element.info.help34.1.label')}</p>
                    </div>
					<!-- 【关联文档】: 
					<!-- 
                    <div class="border_all padding_5   margin_t_10">
                        
                        <p>${ctp:i18n('element.info.help36.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.info.help36.1.label')}</p>
                    </div>
					-->
                    <!-- 【WORD转PDF】: -->
					<!--
	                    <div class="border_all padding_5   margin_t_10">
	                        <p>${ctp:i18n('element.info.help37.label')}</p>
	                        <p class="text_indent">${ctp:i18n('element.info.help37.1.label')}</p>
	                    </div>
					-->
					<!--
                    <div class="border_all padding_5   margin_t_10">
                        【退回拟稿人】:
                        <p>${ctp:i18n('element.info.help38.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.info.help38.1.label')}</p>
                    </div>
					-->
                   <%--  <div class="border_all padding_5  margin_t_10">
                        <!-- 【消息推送】: -->
                        <p>${ctp:i18n('element.info.help39.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.info.help39.1.label')}</p>
                    </div> --%>
                    <div class="border_all padding_5  margin_t_10">
                        <!-- 【修改附件】: -->
                        <p>${ctp:i18n('element.help28.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.help28.1.label')}</p>
                    </div>
					<div class="border_all padding_5  margin_t_10">
                        <!-- 【当前会签】: -->
                        <p>${ctp:i18n('element.info.help40.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.info.help40.1.label')}</p>
                    </div>
                     <div class="border_all padding_5 margin_t_10">
                        <!-- 【多级会签】: -->
                        <p>${ctp:i18n('element.info.help41.label')}</p>
                        <p class="text_indent">${ctp:i18n('element.info.help41.1.label')}</p>
                    </div>
                </c:if>
    </div>
</body>
</html>
