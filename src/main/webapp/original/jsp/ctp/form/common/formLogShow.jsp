<%--
 $Author: dengcg $
 $Rev: 509 $
 $Date:: 2012-07-21 00:08:40#$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>${ctp:i18n('form.formlogshow.viewlog')}</title>
<style type="text/css">
.label1{
display: inline-block;
width: 60px;
text-align: right;
}
.area1{
display: inline-block;
width: 150px;
}
.label2{
display: inline-block;
width: 80px;
text-align: right;
}
.area2{
display: inline-block;
width: 330px;
}
</style>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'" >
        <div class="layout_north" layout="height:${single ? 35 :155 },maxHeight:${single ? 35 :155 },minHeight:${single ? 35 :155 }" id="north">
        <div id="toolbar"></div>
        <div class="hr_heng"></div>
           <c:if test="${single == 'false'}">
			<form method="post" id="queryCondition" name="queryCondition" class="form_area set_search padding_b_10  margin_5" >
				<span class="searchSectionTitle">${ctp:i18n('form.formlogshow.searchcondition')}</span>:
				<div class="clearfix">
				    <div class="left" style="width: 100px;height: 150px;"></div>
				    <div class="left font_size12" style="width: 650px;height: 150px;">
				        <div class="margin_5 clearfix" style="margin-top: 0px;line-height: 25px;">
				            <span class="label1 left">${ctp:i18n('form.formlogshow.oprater')}：</span>
				            <span class="area1 left">
								<input type="text" id="operator" name="operator" class="comp w100b" comp="panels:'Department,Team,Post,Level,Outworker,JoinOrganization',type:'selectPeople',mode:'open',selectType:'Member',returnValueNeedType:true,minSize:0"/>
				            </span>
				            <span class="label2 left">${ctp:i18n('form.formlogshow.opratetime')}：</span>
				            <span class="area2 left">
								<span style="display: inline-block;"><input id="beginoperatime" type="text" style="width: 100px;" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false"></span>
								<span style="display: inline-block;">-</span>
								<span style="display: inline-block;"><input id="endoperatime" type="text" style="width: 100px;" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false"></span>
				            </span>
				        </div>
				        <div class="margin_5 clearfix"  style="line-height: 25px;">
				            <span class="label1 left">${ctp:i18n('form.formlogshow.opratetype')}：</span>
				            <span class="area1 left" style="text-align: right;">
								<select id="operationType" name="operationType" class="w100b">
									<option value=""></option>
										<option value=90 title="">${ctp:i18n('form.formlogshow.add')}</option><!-- 新增 -->
										<option value=92 title="">${ctp:i18n('phrase.title.edit.label')}</option><!-- 修改 -->
										<option value=94 title="">${ctp:i18n('guestbook.leaveword.delete')}</option><!-- 删除 -->
										<c:if test="${formType==2}">
											<option value=91 title="">${ctp:i18n('application.91.label')}</option><!-- 加锁 -->
											<option value=93 title="">${ctp:i18n('application.93.label')}</option><!-- 解锁 -->
										</c:if>
									    <option value=97 title="">${ctp:i18n('form.trigger.triggerSet.triggerPro.label')}</option><!-- 触发流程 -->
									    <c:if test="${formType==2}">
											<option value=100 title="">${ctp:i18n('form.trigger.triggerSet.linkage.distribution.log.label')}</option><!-- 分发联动 -->
											<option value=101 title="">${ctp:i18n('form.trigger.triggerSet.linkage.gather.log.label')}</option><!-- 汇总联动 -->
											<option value=102 title="">${ctp:i18n('form.trigger.triggerSet.bilateral.log.label')}</option><!-- 双向联动 -->
											<option value=108 title="">${ctp:i18n('form.trigger.operate.linkage.system')}</option><!-- 系统联动 -->
										</c:if>
			                            <c:if test="${formType==2 or formType==3}">
											<option value=104 title="">${ctp:i18n('form.trigger.automatic.billinnerupdate.label')}</option><!-- 更新当前单据 -->
											<option value=105 title="">${ctp:i18n('form.trigger.automatic.billamongupdate.label')}</option><!-- 更新其他单据 -->
											<option value=106 title="">${ctp:i18n('form.trigger.automatic.billnew.label')}</option><!-- 新增单据 -->
										</c:if>
										<option value=103 title="">${ctp:i18n('form.relation.refresh.log.label')}</option><!-- 关联刷新 -->
										<option value=98 title="">${ctp:i18n('form.bind.bath.refresh.label')}</option><!-- 批量刷新 -->
										<option value=99 title="">${ctp:i18n('form.bind.bath.update.label')}</option><!-- 批量修改 -->
										<option value=95 title="">${ctp:i18n('org.button.imp.label')}EXCEL</option><!-- 导入EXCEL -->
										<option value=96 title="">${ctp:i18n('org.button.exp.label')}EXCEL</option><!-- 导出EXCEL -->
										<c:if test="${formType==2 or formType==3}">
											<option value=107 title="">${ctp:i18n('form.trigger.operate.fail.label')}</option>
										</c:if>
								</select>
				            </span>
				            <span class="label2 left">${ctp:i18n('form.formlog.createDate.label')}：</span>
				            <span class="area2 left">
								<span style="display: inline-block;"><input id="begincreatetime" style="width: 100px;" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false"></span>
								<span style="display: inline-block;">-</span>
								<span style="display: inline-block;"><input id="endcreatetime" style="width: 100px;" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false"></span>
				            </span>
				        </div>
				        <div class="margin_5 clearfix"  style="line-height: 25px;">
				           <span class="label1 left">${ctp:i18n('common.creater.label')}：</span>
				            <span class="area1 left">
								<input type="text" id="creator" name="creator" class="comp w100b" comp="panels:'Department,Team,Post,Level,Outworker,JoinOrganization',type:'selectPeople',mode:'open',selectType:'Member',returnValueNeedType:true,minSize:0"/>
				            </span>
				            <span class="label2 left" style="text-align: center;">
				                <a id="search" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('common.button.condition.search.label')}</a>
				            </span>
				        </div>
				    </div>
				</div>
			</form>
        </c:if>
        </div>

         <div id ="logcenter" style="overflow:hidden;" class="layout_center" layout="border:false">
         <table class="flexme3" style="display: none" id="mytable"></table>
         </div>
        </div>
        <%@ include file="formLogShow.js.jsp" %>
        <iframe id="exportExcel" style="display: none"></iframe>
</body>

</html>
