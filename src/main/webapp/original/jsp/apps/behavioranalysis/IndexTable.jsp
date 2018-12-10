<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/html" id="table-tpl">
<table class="dateList" width="100%">
	<thead>
		<tr class="tableHeader">
			{{# for(var i = 0, len = d.headRow1.length; i < len; i++){ }}
				{{# if(i == 0 && d.headRow1[i].columnNum == 1){ }}
					<td class="td_{{d.orgType}}_{{d.moduleType}}_{{d.viewType}}_{{i}} border_right" colspan="{{d.headRow1[i].columnNum}}" title="{{d.headRow1[i].display}}">{{d.headRow1[i].display}}&ensp;</td>
				{{# }else{ }}
					<td class="td_{{d.orgType}}_{{d.moduleType}}_{{d.viewType}}_{{i}} border_right" colspan="{{d.headRow1[i].columnNum}}" title="{{d.headRow1[i].display}}">{{d.headRow1[i].display}}</td>
				{{# } }}
		{{# } }}
		</tr>
		<tr class="table_thead">
			{{# for(var i = 0, len = d.headRow2.length; i < len; i++){ }}
				{{# var headCell = d.headRow2[i]; }}
				<td class="td_{{d.orgType}}_{{d.moduleType}}_{{d.viewType}}_{{i}} border_right {{# if(headCell.isOrder){ }} hand{{# } }}" {{# if(headCell.isOrder){ }} name='headerColumn' {{# } }}>
					<span id="head{{ i }}" title="{{headCell.display}}">{{headCell.display}}</span>
				{{# if(headCell.orderBy == "desc"){ }}
					<span class="ico16 arrow_4_b" ></span>
				{{# }else if(headCell.orderBy == "asc"){ }}
					<span class="ico16 arrow_4_t"></span>
				{{# } }}
				</td>
			{{# } }}
		</tr>
	</thead>
	<tbody>
		{{# for(var i = 0, len = d.rowList.length; i < len; i++){ }}
			{{# var row = d.rowList[i]; }}
				<tr class="table_tr" {{# if(i==0){ }} style='background:#f0f0f0' {{# } }}>
				{{# for(var j = 0, l = row.length; j < l; j++){ }}
					{{# var cell = row[j]; }}
					<td {{# 	if(cell.displayColor == "blue"&&j!==0){ 	}} 
							class="td_{{d.orgType}}_{{d.moduleType}}_{{d.viewType}}_{{j}} hand color_blue"  
						{{#  	}else if(cell.displayColor == "red"){  	}} 
							class="td_{{d.orgType}}_{{d.moduleType}}_{{d.viewType}}_{{j}} hand color_red nowarp_{{j}} li_td_{{d.orgType}}_{{d.moduleType}}_{{d.viewType}}_{{j}}"  
						{{# 	}else{  }} 
							class="td_{{d.orgType}}_{{d.moduleType}}_{{d.viewType}}_{{j}}"
						{{# 	}  }} 
						
						{{# 	if(j!=0&&cell.conditions){ 	}} 
								data-click='{{cell.conditions }}' onclick="openThis(this,{{ j}})" 
						{{#  }  }}>
						<span {{# if(i!=0&&j==0&&cell.isClick&&cell.conditions){ }} 
								class="  nowarp_{{j}} hand color_blue nowarp span_{{d.orgType}}_{{d.moduleType}}_{{d.viewType}}_{{j}}"  name="cellColumn"  row="{{i}}" col="{{j}}"
							  {{# }else{ }} 
								class=" nowarp_{{j}} span_{{d.orgType}}_{{d.moduleType}}_{{d.viewType}}_{{j}}"
							  {{# } }} title="{{= cell.display}}">{{= cell.display}}</span>
					</td>
				{{# } }}
			</tr>
		{{# } }}
	</tbody>
</table>
</script>
<script type="text/html" id="behavior0_ul">
		<ul class="overflow nav_hd_ul">
			{{# if(d.zyxt ){ }}
				<li class="left ${wfParam.moduleType == '1' ? 'current_hdLi pointer' : 'pointer'}" id="collaboration" moduleType="1" onclick="behaviorIndexTable.moduleMemClick(this)"><span>自由协同</span></li>
			{{# } }}			
			{{# if(d.mblc ){ }}
				<li class="left ${wfParam.moduleType == '2' ? 'current_hdLi pointer' : 'pointer'}" id="template" moduleType="2" onclick="behaviorIndexTable.moduleMemClick(this)" ><span>模板流程</span></li>
			{{# } }}
			{{# if(d.rcgz ){ }}
				<li class="left ${wfParam.moduleType == '3,10,5,4' ? 'current_hdLi pointer' : 'pointer'}" id="workDaily" moduleType="3,10,5,4" onclick="behaviorIndexTable.moduleMemClick(this)" ><span>日常工作</span></li>
			{{# } }}
			{{# if(d.zsjl ){ }}
				<li class="left ${wfParam.moduleType == '6' ? 'current_hdLi pointer' : 'pointer'}" id="knowledge" moduleType="6" onclick="behaviorIndexTable.moduleMemClick(this)" ><span>知识积累</span></li>
			{{# } }}			
			{{# if(d.qywh ){ }}
				<li class="left ${wfParam.moduleType == '8,9,7' ? 'current_hdLi pointer' : 'pointer'}" id="curture" moduleType="8,9,7" onclick="behaviorIndexTable.moduleMemClick(this)" ><span>企业文化</span></li>
			{{# } }}
		</ul>
</script>
<script type="text/html" id="behavior0">
<%--个人行为效率 --%>
<div class="h3 fs16 color66 p10">行为数据</div>
<div class="behavior_show" style="position: relative;" id="behavior_data">
	<div class="h_ico member_ico">
		<span class="ico16 help_16 help_16_red"></span>
		<span class="h_bg common"></span>
		<span class="h_txt common table_ico_txt"></span>
	</div>
	<div id="behavior0_div" class="nav_hd">
	</div>
	<div class="nav_body">
		<!-- 自由协同 -->
		<div class="communication_div overflow hide" id="collaboration" moduleType="1">
			<div class="DIV_box bgBlue left  ">
				<div class="br_right h100b">
					<div class="DIV_box_top"><span class="color66"></span></div>
					<ul class="DIV_box_ul">
						<li><span class="fs14 color66 margin_r_5">发起协同</span><span class="fs14 color33">{{d.freeColl.sendNum}}个</span></li>
					</ul>
				</div>
			</div>
			<div class="DIV_box bgWhite left ">
				<div class="br_right h100b">
					<div class="DIV_box_top"><span class="color66"></span></div>
					<ul class="DIV_box_ul ">
						<li><span class="fs14 color66 margin_r_5">处理协同</span><span class="fs14 color33">{{d.freeColl.handleNum}}个</span></li>
						<li><span class="fs14 color66 margin_r_5">超期处理比例</span><span class="fs14 color_red">{{d.freeColl.overHandleRatio}}</span></li>
					</ul>
				</div>
			</div>
			<div class="DIV_box bgBlue left ">
				<div class="br_right h100b">
					<div class="DIV_box_top"><span class="color66"></span></div>
					<ul class="DIV_box_ul ">
						<li><span class="fs14 color66 margin_r_5">平均处理时长</span><span class="fs14 color33">{{d.freeColl.avgHandleTime}}</span></li>
						<li><span class="fs14 color66 margin_r_5">平均超期时长</span><span class="fs14 color_red">{{d.freeColl.avgOverHandleTime}}</span></li>
					</ul>
				</div>
			</div>
			<div class="DIV_box bgWhite left ">
				<div class="br_right h100b">
					<div class="DIV_box_top"><span class="color66"></span></div>
					<ul class="DIV_box_ul ">
						<li><span class="fs14 color66 margin_r_5">获赞数</span><span class="fs14 color33">{{d.freeColl.receivePraiseNum}}个</span></li>
					</ul>
				</div>
			</div>
			<div class="DIV_box bgBlue left ">
				<div class="w100b">
					<div class="DIV_box_top"><span class="fs14 color66 margin_r_5 end_date_span">截至{{d.freeColl._endDate}}</span></div>
					<ul class="DIV_box_ul ">
						<li><span class="fs14 color66 margin_r_5">未处理协同</span><span class="fs14 color_red">{{d.freeColl.unHandleNum}}个</span></li>
						<li><span class="fs14 color66 margin_r_5">超期未处理比例</span><span class="fs14 color_red">{{d.freeColl.overunHandleRatio}}</span></li>
					</ul>
				</div>
			</div>
		</div>

		<!-- 模板流程 -->
		<div class="communication_div overflow hide" id="template" moduleType="2">
			<div class="DIV_box bgBlue left  ">
				<div class="br_right h100b">
					<div class="DIV_box_top"><span class="color66"></span></div>
					<ul class="DIV_box_ul">
						<li><span class="fs14 color66 margin_r_5">发起模板流程</span><span class="fs14 color33">{{d.templete.sendNum}}个</span></li>
					</ul>
				</div>
			</div>
			<div class="DIV_box bgWhite left ">
				<div class="br_right h100b">
					<div class="DIV_box_top"><span class="color66"></span></div>
					<ul class="DIV_box_ul ">
						<li><span class="fs14 color66 margin_r_5">处理模板流程</span><span class="fs14 color33">{{d.templete.handleNum}}个</span></li>
						<li><span class="fs14 color66 margin_r_5">超期处理比例</span><span class="fs14 color_red">{{d.templete.overHandleRatio}}</span></li>
					</ul>
				</div>
			</div>
			<div class="DIV_box bgBlue left ">
				<div class="br_right h100b">
					<div class="DIV_box_top"><span class="color66"></span></div>
					<ul class="DIV_box_ul ">
						<li><span class="fs14 color66 margin_r_5">平均处理时长</span><span class="fs14 color33">{{d.templete.avgHandleTime}}</span></li>
						<li><span class="fs14 color66 margin_r_5">平均超期时长</span><span class="fs14 color_red">{{d.templete.avgOverHandleTime}}</span></li>
					</ul>
				</div>
			</div>
			<div class="DIV_box bgWhite left ">
				<div class="br_right h100b">
					<div class="DIV_box_top"><span class="color66"></span></div>
					<ul class="DIV_box_ul ">
						<li><span class="fs14 color66 margin_r_5">获赞数</span><span class="fs14 color33">{{d.templete.receivePraiseNum}}个</span></li>
					</ul>
				</div>
			</div>
			<div class="DIV_box bgBlue left ">
				<div class="h100b">
					<div class="DIV_box_top  "><span class="fs14 color66 margin_r_5 end_date_span">截至{{d.templete._endDate}}</span></div>
					<ul class="DIV_box_ul ">
						<li><span class="fs14 color66 margin_r_5">未处理模板流程</span><span class="fs14 color_red">{{d.templete.unHandleNum}}个</span></li>
						<li><span class="fs14 color66 margin_r_5">超期未处理比例</span><span class="fs14 color_red">{{d.templete.overunHandleRatio}}</span></li>
					</ul>
				</div>
			</div>
		</div>

		<!-- 日常工作 -->
		<div class="daily_work overflow hide" id="workDaily" moduleType="3,10,5,4">
			<div class="daily_work_div mr_bottom left">
				<div class="daily_work_padding daily_work_mrgr">
					<div class="daily_work_head">
						<span class="bold_span">计划</span><span class="color99">{{d.plan.rptMonth}}，发起计划{{d.plan.sendNum}}个，总结计划{{d.plan.summaryNum}}个</span>
					</div>
					<div class="daily_work_contain left">
						<div class="daily_work_top">
							<div class="daily_work_mr">
								<div class="fs14">主送回复计划比例</div>
								<div><span class="fs14">{{d.plan.mainReplyRatio}}</span></div>
							</div>
						</div>
						<div class="daily_work_bottom">
							<div class="daily_work_mr">
								<div>平均回复时长</div>
								<div><span class="fs14">{{d.plan.mainAvgReplyTime}}</span></div>
							</div>
						</div>
					</div>
					<div class="daily_work_contain left">
						<div class="daily_work_top">
							<div class="daily_work_mr">
								<div class="fs14">抄送回复计划比例</div>
								<div><span class="fs14">{{d.plan.copyReplyRatio}}</span></div>
							</div>
						</div>
						<div class="daily_work_bottom">
							<div class="daily_work_mr">
								<div>平均回复时长</div>
								<div><span class="fs14">{{d.plan.copyAvgReplyTime}}</span></div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="daily_work_div mr_bottom left">
				<div class="daily_work_padding">
					<div class="daily_work_head">
						<span class="bold_span">会议</span><span class="color99">{{d.meeting.rptMonth}}，发起会议{{d.meeting.sendNum}}个，收到会议{{d.meeting.receivenum}}个</span>
					</div>
					<div class="daily_work_contain left">
						<div class="daily_work_top">
							<div class="daily_work_mr">
								<div class="fs14">参加会议比例</div>
								<div><span class="fs14">{{d.meeting.replyPartRatio}}</span></div>
							</div>
						</div>
						<div class="daily_work_bottom">
							<div class="daily_work_mr">
								<div></div>
								<div><span></span></div>
							</div>
						</div>
					</div>
					<div class="daily_work_contain left">
						<div class="daily_work_top">
							<div class="daily_work_mr">
								<div class="fs14">回执会议比例</div>
								<div><span class="fs14">{{d.meeting.replyRatio}}</span></div>
							</div>
						</div>
						<div class="daily_work_bottom">
							<div class="daily_work_mr">
								<div>平均回执时长</div>
								<div><span class="fs14">{{d.meeting.avgReplyTime}}</span></div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="daily_work_div mr_bottom left">
				<div class="daily_work_padding daily_work_mrgr">
					<div class="daily_work_head">
						<span class="bold_span">任务</span><span class="color99">{{d.com.seeyon.apps.task.rptMonth}}，计划要做任务{{d.com.seeyon.apps.task.executedsum}}个</span>
					</div>
					<div class="daily_work_contain left">
						<div class="daily_work_top">
							<div class="daily_work_mr">
								<div class="fs14">完成任务</div>
								<div><span class="fs14">{{d.com.seeyon.apps.task.finishNum}}个</span></div>
							</div>
						</div>
						<div class="daily_work_bottom">
							<div class="daily_work_mr">
								<div>超期完成任务比例</div>
								<div><span class="fs14">{{d.com.seeyon.apps.task.overfinishRate}}</span></div>
							</div>
						</div>
					</div>
					<div class="daily_work_contain left">
						<div class="daily_work_top">
							<div class="daily_work_mr">
								<div class="fs14">截至{{d.com.seeyon.apps.task._endDate}}未完成任务</div>
								<div><span class="fs14">{{d.com.seeyon.apps.task.unfinishNum}}个</span></div>
							</div>
						</div>
						<div class="daily_work_bottom">
							<div class="daily_work_mr">
								<div>超期未完成任务比例</div>
								<div><span class="fs14">{{d.com.seeyon.apps.task.overUnfinishRate}}</span></div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="daily_work_div mr_bottom left">
				<div class="daily_work_padding">
					<div class="daily_work_head">
						<span class="bold_span">项目</span><span class="color99">{{d.project.rptMonth}}，计划要进行项目{{d.project.executedsum}}个</span>
					</div>
					<div class="daily_work_contain left">
						<div class="daily_work_top">
							<div class="daily_work_mr">
								<div class="fs14">结束项目</div>
								<div><span class="fs14">{{d.project.endsum}}个</span></div>
							</div>
						</div>
						<div class="daily_work_bottom">
							<div class="daily_work_mr">
								<div>超期结束项目比例</div>
								<div><span class="fs14">{{d.project.overendRate}}</span></div>
							</div>
						</div>
					</div>
					<div class="daily_work_contain left">
						<div class="daily_work_top">
							<div class="daily_work_mr">
								<div class="fs14">截至{{d.project._endDate}}未结束项目</div>
								<div><span class="fs14">{{d.project.startunendsum}}个</span></div>
							</div>
						</div>
						<div class="daily_work_bottom">
							<div class="daily_work_mr">
								<div>超期未结束项目比例</div>
								<div><span class="fs14">{{d.project.overunendRate}}</span></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!--知识积累-->
		<div class="knowleg_account hide" id="knowledge" moduleType="6">
			<div class="knowleg_account_div overflow" >
				<div class="account_point left ">
					<div class="account_point_center ">
						<div class="account_point_mr">
							<div class="fs14">新增文档</div>
							<div><span class="fs14" style="color:#77fa0e">{{d.doc.addNum}}个</span></div>
						</div>
					</div>
				</div>
				<div class="account_point left ">
					<div class="account_point_center">
						<div class="account_point_mr">
							<div class="fs14">阅读文档</div>
							<div><span class="fs14" style="color:#77fa0e">{{d.doc.readNum}}次</span></div>
						</div>
					</div>
				</div>
				<div class="account_point left ">
					<div class="account_point_center">
						<div class="account_point_mr">
							<div class="fs14">收藏文档</div>
							<div><span class="fs14" style="color:#77fa0e">{{d.doc.collectnum}}次</span></div>
						</div>
					</div>
				</div>
				<div class="account_point left">
					<div class="account_point_center">
						<div class="account_point_mr">
							<div class="fs14">下载文档</div>
							<div><span class="fs14" style="color:#77fa0e">{{d.doc.downloadNum}}次</span></div>
						</div>
					</div>
				</div>
				<div class="account_point left ">
					<div class="account_point_center">
						<div class="account_point_mr">
							<div class="fs14">评论/评分文档</div>
							<div><span class="fs14" style="color:#77fa0e">{{d.doc.commentNum}}次</span></div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- 企业文化 -->
		<div class="daily_work overflow hide" id="curture" moduleType="8,9,7">
			<div class="daily_work_div mr_bottom left">
				<div class="daily_work_padding daily_work_mrgr">
					<div class="daily_work_head">
						<span class="bold_span">新闻/公告</span><span class="color99">{{d.newsAndbul.rptMonth}}，收到新闻{{d.newsAndbul.newsReceivenum}}个，阅读新闻{{d.newsAndbul.newsReadnum}}个，收到公告{{d.newsAndbul.bulReceivenum}}个，阅读公告{{d.newsAndbul.bulReadnum}}个</span>
					</div>
					<div class="daily_work_contain left">
						<div class="daily_work_top">
							<div class="daily_work_mr">
								<div class="fs14">新闻阅读比例</div>
								<div><span class="fs14">{{d.newsAndbul.newsReadRatio}}</span></div>
							</div>
						</div>
						<div class="daily_work_bottom">
							<div class="daily_work_mr">
								<div>平均阅读效率</div>
								<div><span class="fs14">{{d.newsAndbul.newsAvgReadTime}}</span></div>
							</div>
						</div>
					</div>
					<div class="daily_work_contain left">
						<div class="daily_work_top">
							<div class="daily_work_mr">
								<div class="fs14">公告阅读比例</div>
								<div><span class="fs14">{{d.newsAndbul.bulReadRatio}}</span></div>
							</div>
						</div>
						<div class="daily_work_bottom">
							<div class="daily_work_mr">
								<div>平均阅读效率</div>
								<div><span class="fs14">{{d.newsAndbul.bulAvgReadTime}}</span></div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="daily_work_div mr_bottom left">
				<div class="daily_work_padding">
					<div class="daily_work_head">
						<span class="bold_span">调查</span><span class="color99">{{d.inquiry.rptMonth}}，收到调查{{d.inquiry.receiveNum}}个，回复调查{{d.inquiry.voteNum}}个</span>
					</div>
					<div class="daily_work_contain left">
						<div class="daily_work_top">
							<div class="daily_work_mr">
								<div class="fs14">调查回复比例</div>
								<div><span class="fs14">{{d.inquiry.replyRatio}}</span></div>
							</div>
						</div>
						<div class="daily_work_bottom">
							<div class="daily_work_mr">
								<div>平均回复时长</div>
								<div><span class="fs14">{{d.inquiry.avgReplyTime}}</span></div>
							</div>
						</div>
					</div>
					<div class="daily_work_contain left">
						<div class="daily_work_top">
							<div class="daily_work_mr">
								<div class="fs14">截至{{d.inquiry._endDate}}未回复调查</div>
								<div><span class="fs14">{{d.inquiry.unReplyNum}}个</span></div>
							</div>
						</div>
						<div class="daily_work_bottom">
							<div class="daily_work_mr">
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="daily_work_div mr_bottom left">
				<div class="daily_work_padding daily_work_mrgr">
					<div class="daily_work_head">
						<span class="bold_span">讨论</span><span class="color99">{{d.bbsAndshow.rptMonth}}，发起讨论{{d.bbsAndshow.sendNum}}个</span>
					</div>
					<div class="daily_work_contain left">
						<div class="daily_work_top">
							<div class="daily_work_mr">
								<div>评论</div>
								<div><span class="fs14">{{d.bbsAndshow.commentNum}}次</span></div>
							</div>
						</div>
						<div class="daily_work_bottom">
							<div class="daily_work_mr">
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="daily_work_div mr_bottom left">
				<div class="daily_work_padding">
					<div class="daily_work_head">
						<span class="bold_span">享空间</span><span class="color99">{{d.bbsAndshow.rptMonth}}，发起主题{{d.bbsAndshow.showbarsendNum}}个，发起分享{{d.bbsAndshow.showpostsendNum}}个</span>
					</div>
					<div class="daily_work_contain left">
						<div class="daily_work_top">
							<div class="daily_work_mr">
								<div class="fs14">评论</div>
								<div><span class="fs14">{{d.bbsAndshow.showcommentNum}}次</span></div>
							</div>
						</div>
						<div class="daily_work_bottom">
							<div class="daily_work_mr">
							</div>
						</div>
					</div>
					<div class="daily_work_contain left">
						<div class="daily_work_top">
							<div class="daily_work_mr">
								<div class="fs14">获赞数</div>
								<div><span class="fs14">{{d.bbsAndshow.showReceivePraiseNum}}个</span></div>
							</div>
						</div>
						<div class="daily_work_bottom">
							<div class="daily_work_mr">
								<div>点赞数</div>
								<div><span class="fs14">{{d.bbsAndshow.showpraiseNum}}个</span></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="loading_div" id="loading_div" style="text-align: center;">
			<img  src="${path}/skin/default/images/loading.gif">
		</div>

	</div>
	<div class="behavior_footer hide" id="behavior_footer">
		<span>{{d.templete.rptMonth}}，发起最多的模板流程是：{{=d.templete.usemoretempletename}},处理最多的模板流程为：{{=d.templete.handmoretempletename}}
		</span>
	</div>

</div>
</script>
<script type="text/html" id="behavior1_ul">
		<ul class="overflow id="pageTabs">
			{{# if(d.zyxt ){ }}
				<li class="left current_hdLi pointer" id="collaboration" moduleType="1" onclick="behaviorIndexTable.moduleClick(this)" ><span>自由协同</span></li>
			{{# } }}
			{{# if(d.mblc ){ }}
				<li class="left pointer" id="template" moduleType="2" onclick="behaviorIndexTable.moduleClick(this)" ><span>模板流程</span></li>
			{{# } }}
			{{# if(d.rcgz ){ }}
				<li class="left pointer" id="workDaily" moduleType="3,10,5,4" onclick="behaviorIndexTable.moduleClick(this)" ><span>日常工作</span></li>
			{{# } }}
			{{# if(d.zsjl ){ }}
				<li class="left pointer" id="knowledge" moduleType="6" onclick="behaviorIndexTable.moduleClick(this)" ><span>知识积累</span></li>
			{{# } }}
			{{# if(d.qywh ){ }}
				<li class="left pointer" id="curture" moduleType="8,9,7" onclick="behaviorIndexTable.moduleClick(this)" ><span>企业文化</span></li>
			{{# } }}
		</ul>
</script>
<script type="text/html" id="behavior1">
<%-- 部门行为效率 --%>
<div class="h3 fs16 color66 p10">行为数据</div>
<div class="behavior_Date_nav">
	<ul class="overflow" id="dptTab">
		<li class="left li_01 current_li hand" value="1" onclick="behaviorIndexTable.tabClick(this)"><span>按部门查看</span></li>
		<li class="left li_02 hand" value="2" onclick="behaviorIndexTable.tabClick(this)"><span>按人员查看</span></li>
	</ul>
</div>
<div class="behavior_show" id="behavior_data">
	<div id="behavior1_div" class="nav_hd">
	</div>
	<!--  加载效果 -->
	<div class="loading_div">
			<img  src="${path}/skin/default/images/loading.gif"></br>
			加载中...
	</div>
	<div class="behavior_show_date hide" id="behavior_wrap">
		<div moduleType="3,10,5,4" class="left common_selectbox_wrap hide" style="margin-bottom:5px">
					<select id="selectModule" onchange="behaviorIndexTable.onChange(this)">
						<option value="3" selected>计划</option>
						<option value="10">会议</option>
						<option value="5">任务</option>
						<option value="4">项目</option>
					</select>
		</div>
		<div moduleType="8,9,7" class="left common_selectbox_wrap hide" style="margin-bottom:5px">
					<select id="curtureModule" onchange="behaviorIndexTable.onChange(this)">
						<option value="8" selected>新闻公告</option>
						<option value="9">调查</option>
						<option value="7">讨论与分享</option>
					</select>
		</div>
		<div class="overflow ">
			<div class="right" style="margin-bottom:5px;">
				<span class="hand" id="exportExcel" onclick="behaviorIndexTable.exportExcel()" title="导出excel">
					<span class="ico16 xls_16" style="margin-top:-3px;"></span><a style="line-height: 16px;vertical-align: top;" id="exportExcel" onclick="behaviorIndexTable.exportExcel()">导出excel</a>
				</span>
				<from id="excelCon">
					<input type="hidden" id="queryInfo" name="queryInfo"/>
					<input type="hidden" id="qOrgName" name="qOrgName"/>
					<input type="hidden" id="qModuleType" name="qModuleType"/>
				</from>
			</div>
			<div class="h_ico department_ico">
				<span class="ico16 help_16 help_16_red"></span>
				<span class="h_bg common"></span>
				<span class="h_txt common table_ico_txt"></span>
			</div>
		</div>
		<div id="indexTable">
		</div>
	</div>
	<div class="common_over_page align_right padding_b_10 hide" id="pageContent">
			${ctp:i18n('performanceReport.queryMain.page.eachPage')}<input class="common_over_page_txtbox" type="text" value="20" id="pageSize">
			<span id="totleItem">${ctp:i18n_1('performanceReport.queryMain_js.unitTotal',0) }</span>
			<a title="${ctp:i18n('performanceReport.queryMain.page.firstPage')}" class="common_over_page_btn" href="#" id="firstPage"><em class="pageFirst"></em></a>
			<a title="${ctp:i18n('performanceReport.queryMain.page.up')}" class="common_over_page_btn" href="#" id="prevPage"><em class="pagePrev"></em></a>
			<span>${ctp:i18n('performanceReport.queryMain.page.the')}</span>
			<input class="common_over_page_txtbox" type="text" value="1" id="pageNo"><span id="totlePage">${ctp:i18n_1('performanceReport.queryMain_js.pageTotal',1)}</span>
			<a title="${ctp:i18n('performanceReport.queryMain.page.down')}" class="common_over_page_btn" href="#" id="nextPage"><em class="pageNext"></em></a>
			<a title="${ctp:i18n('performanceReport.queryMain.page.lastPage')}" class="common_over_page_btn" href="#" id="lastPage"><em class="pageLast"></em></a>
			<a id="grid_go" class="common_button common_button_gray margin_r_10" href="javascript:void(0)">go</a>
	</div>
</div>
</script>
<script type="text/html" id="behavior2_ul">
		<ul class="overflow id="pageTabs">
			{{# if(d.zyxt ){ }}
				<li class="left current_hdLi pointer" id="collaboration" moduleType="1" onclick="behaviorIndexTable.moduleClick(this)" ><span>自由协同</span></li>
			{{# } }}
			{{# if(d.mblc ){ }}
				<li class="left pointer" id="template" moduleType="2" onclick="behaviorIndexTable.moduleClick(this)" ><span>模板流程</span></li>
			{{# } }}
			{{# if(d.rcgz ){ }}
				<li class="left pointer" id="workDaily" moduleType="3,10,5,4" onclick="behaviorIndexTable.moduleClick(this)" ><span>日常工作</span></li>
			{{# } }}
			{{# if(d.zsjl ){ }}
				<li class="left pointer" id="knowledge" moduleType="6" onclick="behaviorIndexTable.moduleClick(this)" ><span>知识积累</span></li>
			{{# } }}
			{{# if(d.qywh ){ }}
				<li class="left pointer" id="curture" moduleType="8,9,7" onclick="behaviorIndexTable.moduleClick(this)" ><span>企业文化</span></li>
			{{# } }}
		</ul>
</script>
<script type="text/html" id="behavior2">
<%-- 单位行为效率 --%>
<div class="h3 fs16 color66 p10">行为数据</div>
<div class="behavior_Date_nav">
	<ul class="overflow" id="dptTab">
		<li class="left li_01 current_li hand" value="1" onclick="behaviorIndexTable.tabClick(this)" ><span>按部门查看</span></li>
		<li class="left li_02 hand" value="2" onclick="behaviorIndexTable.tabClick(this)"><span>按人员查看</span></li>
	</ul>
</div>
<div class="behavior_show" id="behavior_data">
	<div id="behavior2_div" class="nav_hd">
	</div>
	<!--  加载效果 -->
	<div class="loading_div">
			<img  src="${path}/skin/default/images/loading.gif"></br>
			加载中...
	</div>
	<div class="behavior_show_date hide" id="behavior_wrap">
		<div moduleType="3,10,5,4" class="left common_selectbox_wrap hide" style="margin-bottom:5px">
					<select id="selectModule" onchange="behaviorIndexTable.onChange(this)">
						<option value="3" selected>计划</option>
						<option value="10">会议</option>
						<option value="5">任务</option>
						<option value="4">项目</option>
					</select>
		</div>
		<div moduleType="8,9,7" class="left common_selectbox_wrap hide" style="margin-bottom:5px">
					<select id="curtureModule" onchange="behaviorIndexTable.onChange(this)">
						<option value="8" selected>新闻公告</option>
						<option value="9">调查</option>
						<option value="7">讨论与分享</option>
					</select>
		</div>
		<div class="overflow" style="height:31px;">
			<div class="right" style="margin-top:10px;">
				<span class="hand" id="exportExcel" onclick="behaviorIndexTable.exportExcel()" title="导出excel">
					<span class="ico16 xls_16" style="margin-top:-3px;"></span><a style="line-height: 16px;vertical-align: top;" id="exportExcel">导出excel</a>
				</span>
				<from id="excelCon">
					<input type="hidden" id="queryInfo" name="queryInfo"/>
					<input type="hidden" id="qOrgName" name="qOrgName"/>
					<input type="hidden" id="qModuleType" name="qModuleType"/>
				</from>
			</div>
			<div class="h_ico">
				<span class="ico16 help_16 help_16_red"></span>
				<span class="h_bg common"></span>
				<span class="h_txt common table_ico_txt"></span>
			</div>
		</div>
		<div id="indexTable">
		</div>
	</div>
	<div class="common_over_page align_right padding_b_10 hide" id="pageContent">
			${ctp:i18n('performanceReport.queryMain.page.eachPage')}<input class="common_over_page_txtbox" type="text" value="20" id="pageSize">
			<span id="totleItem">${ctp:i18n_1('performanceReport.queryMain_js.unitTotal',0) }</span>
			<a title="${ctp:i18n('performanceReport.queryMain.page.firstPage')}" class="common_over_page_btn" href="#" id="firstPage"><em class="pageFirst"></em></a>
			<a title="${ctp:i18n('performanceReport.queryMain.page.up')}" class="common_over_page_btn" href="#" id="prevPage"><em class="pagePrev"></em></a>
			<span>${ctp:i18n('performanceReport.queryMain.page.the')}</span>
			<input class="common_over_page_txtbox" type="text" value="1" id="pageNo"><span id="totlePage">${ctp:i18n_1('performanceReport.queryMain_js.pageTotal',1)}</span>
			<a title="${ctp:i18n('performanceReport.queryMain.page.down')}" class="common_over_page_btn" href="#" id="nextPage"><em class="pageNext"></em></a>
			<a title="${ctp:i18n('performanceReport.queryMain.page.lastPage')}" class="common_over_page_btn" href="#" id="lastPage"><em class="pageLast"></em></a>
			<a id="grid_go" class="common_button common_button_gray margin_r_10" href="javascript:void(0)">go</a>
	</div>
</div>
</script>

