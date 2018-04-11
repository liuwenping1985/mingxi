<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div>
	<div class="h3 fs16 scoreRankTitle">
		<span class="back_to_pre" id="back" onclick="behaviorScoreRank.back()" title="返回上一级"><img alt=""  src="${path }/apps_res/behavioranalysis/image/btn_bak.png"></span>
		<span id="scoreRankTitle">${wfParam.rptYear}年${wfParam.rptMonth}月行为绩效报告——${wfParam.orgName}</span>
	</div>
	<div class="report_show overflow">
		<!-- 雷达图 -->
		<div class="left report_show_left p_relative">
			<%-- 排名部分 --%>
			<div class="p_absolute p_rander_c">
				<div class="help_ico"><span>行为绩效分<span title="点我查看规则" id="showHelp" onclick="behaviorScoreRank.showHelp()" class="ico16 help_16 help_16_red hand"></span></span></div>
				<div class="rank_area" id="rank_div"></div>
			</div>
			<%--OA-91150组织行为绩效：图表：tips太长 --%>
			<div id="echart1" style="height:340px;color:#fff" class="left align_center report_show_left"></div>
		</div>
		<!-- 个人积分柱状图 -->
		<div id="memberScoreChart" class="hidden right report_show_right" style="margin-left: 10px;">
			<div class="p_relative">
				<span class="report_show_right_span p_absolute">人员在 <span id="departmentName"></span> 中的排名</span>
				<span class="score_no_data">暂无数据</span>
			</div>
			<div id="echart2" style="height:340px" class="report_show_right"></div>
		</div>
		<!-- 部门积分排、部门人员积分排名 -->
		<div id="fivePScpre" class="right report_show_right">
			<div class="right report_show_right comp" id="tabs2" comp="type:'tab',height:290">
				<div id="tabs2_head" class="score_tabs clearfix" style="background-color: #0f3e8b;">
					<ul class="overflow" style="margin:0 20px;border-bottom:solid 1px #7DC1FD;">
						<li id="departmentTotalLi"  class="left current" style="min-width: 0px; "><a href="javascript:void(0)" style="min-width: 0px; max-width:180px;" tgt="department_div"><span id="departments"></span></a></li>
						<li id="middleLi" class="left"><span style="width:2px;color: rgba(255,255,255,0.5); float: left; line-height: 31px; padding: 10px 20px 0 20px;">|</span></li>
	            		<li id="memberTotalLi" class="left" style="min-width: 0px;"><a href="javascript:void(0)" class="clearfix" style="min-width: 0px; max-width:180px;" tgt="member_div"><span id="members"></span></a></li>
					</ul>
				</div>
				<div id="tabs2_body" >
					<div id="department_div" class="overflow padding_l_20" style="margin-top:16px;">
					</div>
					<div id="member_div" class="hidden padding_l_20" style="margin-top:16px;">
					</div>
				</div>
			</div>
		</div>
		
		<div id="dialogDepData" class="dialog_main absolute easyTable dialog_more_data hidden">
			<div class="dialog_main_head">
				<span class="dialog_title left" style="color: #999;"></span>
				<span class="member_search" id="depSearch" onclick="behaviorScoreRank.depSearch()"><span class="ico16 search_16 margin_l_10"></span><label>请选择部门</label></span>
				<span class="dialog_close right" onclick="behaviorScoreRank.moreDialog(this)" title="关闭" dialogId="dialogDepData"></span>
			</div>
			<div class="dialog_main_body left">
				<div id="depMenu" class="partition_menu">
					<ul class="overflow">
						<li class="left pointer current_this" moduletype="0"  onclick="behaviorScoreRank.depTabChange(0)"><span>-<p>(个部门)</p></span></li>
						<li class="left pointer" moduletype="1" onclick="behaviorScoreRank.depTabChange(1)"><span>-<p>(个部门)</p></span></li>
						<li class="left pointer" moduletype="2" onclick="behaviorScoreRank.depTabChange(2)"><span>-<p>(个部门)</p></span></li>
						<li class="left pointer" moduletype="3" onclick="behaviorScoreRank.depTabChange(3)"><span>-<p>(个部门)</p></span></li>
						<li class="left pointer" moduletype="4" onclick="behaviorScoreRank.depTabChange(4)"><span>-<p>(个部门)</p></span></li>
					</ul>
				</div>
				<div id="partitionDepData" class="more_data left">
					<div moduletype="0"></div>
					<div moduletype="1"></div>
					<div moduletype="2"></div>
					<div moduletype="3"></div>
					<div moduletype="4"></div>
				</div>
			</div>
		</div>
		<div id="dialogMemData" class="dialog_main absolute easyTable dialog_more_data hidden">
			<div class="dialog_main_head">
				<span class="dialog_title left" style="color: #999;"></span>
				<span class="member_search" id="memberSearch" onclick="behaviorScoreRank.memberSearch()"><span class="ico16 search_16"></span><label>请选择人员</label></span>
				<span class="dialog_close right" onclick="behaviorScoreRank.moreDialog(this)" title="关闭" dialogId="dialogMemData"></span>
			</div>
			<div class="dialog_main_body left">
				<div id="memberMenu" class="partition_menu">
					<ul class="overflow">
						<li class="left pointer current_this" moduletype="0" onclick="behaviorScoreRank.memTabChange(0)"><span>-<p>(个人)</p></span></li>
						<li class="left pointer" moduletype="1" onclick="behaviorScoreRank.memTabChange(1)"><span>-<p>(个人)</p></span></li>
						<li class="left pointer" moduletype="2" onclick="behaviorScoreRank.memTabChange(2)"><span>-<p>(个人)</p></span></li>
						<li class="left pointer" moduletype="3" onclick="behaviorScoreRank.memTabChange(3)"><span>-<p>(个人)</p></span></li>
						<li class="left pointer" moduletype="4" onclick="behaviorScoreRank.memTabChange(4)"><span>-<p>(个人)</p></span></li>
					</ul>
				</div>
				<div id="partitionMemData" class="more_data left">
					<div moduletype="0"></div>
					<div moduletype="1"></div>
					<div moduletype="2"></div>
					<div moduletype="3"></div>
					<div moduletype="4"></div>
				</div>
			</div>
		</div>
		<div id="tispDiv" class="member_details hidden">
			<dl class="left member_details">
				<dd><span id="memberTitle"></span></dd>
				<dt><table width="100%" border="0" cellspacing="0" cellpadding="0">
					    <tbody>
					        <tr class="erow"><td class="tisp_td_title">分数：</td><td class="member_score"><span id="memberScore"></span>分</td></tr>
					        <tr class="erow"><td class="tisp_td_title">部门：</td><td class="tisp_td_v"><span id="memberDepName"></td></tr>
					        <tr class="erow"><td class="tisp_td_title">岗位：</td><td class="tisp_td_v"><span id="memberPostName"></span></td></tr>
					        <tr class="erow"><td class="tisp_td_title">职务级别：</td ><td class="tisp_td_v"><span id="memberLevelName"></span></td></tr>
					    </tbody>
					</table>
				</dt>
			</dl>
		</div>
		<div id="help_common" class="dialog_main help_common hidden">
			<div class="dialog_main_head">
				<span class="dialog_title left">行为绩效分解读</span>
				<span class="dialog_close right" id="hideHelp" onclick="behaviorScoreRank.hideHelp()" title="关闭"></span>
			</div>
			<div class="conmon_txt">
				<div class="div_txt">
					<span>什么是行为绩效分？</span>
					<p>是在指定时间内，您使用协同软件进行工作所获得的行为积分。从工作数量、效率、结果3个方面综合评估，最高分960分，最低分160分。行为绩效分数越高，说明您的整体工作绩效越好。</p>
				</div>
				<div class="div_txt">
					<span >行为绩效分如何计算得来的？</span>
					<p>行为绩效分根据工作维度、考核指标及权重计算得来。管理员可根据自身情况设置工作维度，考核指标及权重，形成最符合自身管理需求的考核模型。</p>
					<p>行为绩效从工作数量、效率、结果3个方面出发，形成考核指标及权重，例如：已发已办数量、处理时长、超期情况、获赞数量、完成比例等等，从而计算出个人行为绩效分  。部门行为绩效分根据部门成员平均分得来，单位行为绩效分根据单位成员平均分得来。</p>
				</div>
				<div class="div_txt">
					<span>行为绩效分是每月计算？</span>
					<p>每月末、季度末，半年末，全年末都会计算。</p>
				</div>
				<div class="div_txt">
					<span>如何提升行为绩效分？</span>
					<p>顾名思义，提高工作绩效，养成良好的工作习惯，苦有所得、劳有所获。主要包括：收到协同及时处理，不要拖延，超期处理或者长时间不处理会大幅度降低绩效分；发出的协同被同事认可，获赞越多，得分越高；收到会议及时给出反馈，置之不理会拉低分数；单位新闻或公告及时查看、工作文档及时存档、讨论/分享积极参与，都能提升绩效得分。</p>
				</div>
			</div>
		</div>
	</div>
	<script src="${path}/common/js/echarts-all.js${ctp:resSuffix()}"></script>
</div>