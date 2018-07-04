<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="renderer" content="webkit">
<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<link rel="stylesheet" type="text/css" href="${path}/apps_res/wfanalysis/css/common.css${ctp:resSuffix()}"/>
<link rel="stylesheet" type="text/css" href="${path}/apps_res/wfanalysis/css/index.css${ctp:resSuffix()}"/>
<title>${ctp:i18n("wfanalysis.common.name") }</title>
</head>
<body  style="background:#e9eaec;" >
<div class="containe overflow " >
	<%-- 左菜单start --%>
	<div class="leftBar left ">
		<%@ include file="/WEB-INF/jsp/apps/wfanalysis/common/menu.jsp"%>
	</div>
	<%-- 左菜单end --%>
	
	<%-- 右正文start --%>
	<div class="rightBar right" >
		<%-- 右正文-顶部条件区start --%>
		<%@ include file="/WEB-INF/jsp/apps/wfanalysis/common/condition.jsp"%>
		<%-- 右正文-顶部条件区end --%>
		
		<div class="dataContain " >
			<div class="nodata hidden">
				<div class="have_a_rest_area"><span class="msg" style="color: #999999"></span></div>
			</div>
			<div class="dataBase marLeftRight hidden" style="overflow-y:auto">
				<div class="dataSumary">
					<%-- 右正文-TOP4 start --%>
					<div class="sumary_title">
						<span class="sumary_title_h2">${wfaParam.rptTimeDisplay}${ctp:i18n("wfanalysis.process.performance.report") }</span>
						<span class="titleSpan_title">
							<em class="ico16 help_16 help_16_red"></em>
							<em class="em_title em_title_bg"></em>
							<em class="em_title em_title_content">
								${ctp:i18n("wfanalysis.overview.explain.text1") }
							</em>
						</span>
						<c:set var="templateId2ListLong" value="${fn:length(wfaParam.templateId2ListLong)}" />
						<c:set var="outerAccountTemplate" value="${wfaParam.outerAccountTemplate}" />
						<span class="sumary_title_h5">${ctp:i18n_1("wfanalysis.overview.explain.text2",templateId2ListLong) }
							<c:if test = "${wfaParam.outerAccountTemplate > 0}">${ctp:i18n_1("wfanalysis.overview.explain.text3",outerAccountTemplate) }</c:if>
						</span>
					</div>
					<div class="sumary_list">
						<ul class="overflow">
							<li class="left">
								<em class="em_bg em_bg01"></em>
								<div>
									<span class="sumary_span01">${ctp:i18n("wfanalysis.overview.initiating.process") }</span>
									<span class="sumary_span02" style="cursor:pointer;" onclick="more('process')">${vo.createCaseCount}</span>
									<span class="sumary_span03">${ctp:i18n("wfanalysis.common.times") }</span>
								</div>
							</li>
							<li class="left">
								<em class="em_bg em_bg02"></em>
								<div>
									<span class="sumary_span01">${ctp:i18n("wfanalysis.workflowDetail.wf.endNumexcel") }</span>
									<span class="sumary_span02" style="cursor:pointer;" onclick="more('process')">${vo.finishCaseCount}</span>
									<span class="sumary_span03">${ctp:i18n("wfanalysis.common.times") }</span>
								</div>
							</li>
							<li class="left">
								<em class="em_bg em_bg03"></em>
								<div>
									<span class="sumary_span01">${ctp:i18n("wfanalysis.workflowDetail.wf.overEndNumexcel") }</span>
									<span class="sumary_span03">${ctp:i18n("wfanalysis.overview.occupy") } </span>
									<span class="sumary_span02" style="cursor:pointer;" onclick="more('process','','','overScatter')">${vo.finishOverCaseRatioDisplay}</span>
								</div>
							</li>
							<li class="left" >
								<em class="em_bg em_bg04"></em>
								<div>
									<span class="sumary_span01">${ctp:i18n("wfanalysis.process.average.run.time") }</span>
									<c:choose>
   									<c:when test="${vo.avgRunTimeDay > 0}">  
          								<span class="sumary_span02">${vo.avgRunTimeDay}</span>
          								<span class="sumary_span03">${ctp:i18n("wfanalysis.common.day") }</span>
          								<c:if test="${vo.avgRunTimeHour > 0}">
          									<span class="sumary_span02">${vo.avgRunTimeHour}</span>
          									<span class="sumary_span03">${ctp:i18n("wfanalysis.common.hour") }</span>
          								</c:if>
  								 	</c:when>
  								 	<c:when test="${vo.avgRunTimeHour > 0}">  
          								<span class="sumary_span02">${vo.avgRunTimeHour}</span>
          								<span class="sumary_span03">${ctp:i18n("wfanalysis.common.hour") }</span>
          								<c:if test="${vo.avgRunTimeMinute > 0}">
          									<span class="sumary_span02">${vo.avgRunTimeMinute}</span>
          									<span class="sumary_span03">${ctp:i18n("wfanalysis.common.minute") }</span>
          								</c:if>
  								 	</c:when>
   									<c:otherwise> 
     									<span class="sumary_span02">${vo.avgRunTimeMinute}</span>
          								<span class="sumary_span03">${ctp:i18n("wfanalysis.common.minute") }</span>
   									</c:otherwise>
									</c:choose>
								</div>
							</li>
						</ul>
					</div>
					<%-- 右正文-TOP4 end --%>
					
					<div class="rangking overflow">
						<!-- 右正文-超期处理比例TOP3 start -->
						<div class="left">
							<div class=" beyond_timeLimet ">
								<h3 class="limet_name">${ctp:i18n("wfanalysis.overview.processing.ratio.Top3") }
								<span class="titleSpan_title">
									<em class="ico16 help_16 help_16_red"></em>
									<em class="em_title em_title_bg"></em>
									<em class="em_title em_title_content">
										${ctp:i18n("wfanalysis.overview.explain.text4") }
									</em>
								</span>
								</h3>
								
								<div class="rangking_list left ">
									<%-- 节点start --%>
									<dl>
										<dd class="overflow">
											<div class="left"><em></em><span class="fs14">${ctp:i18n("wfanalysis.node.name") }</span></div> 
											<div class="right fs12" onclick="more('node','overHandleRate','desc', 'overBarEfRank');">${ctp:i18n("wfanalysis.process.more") }</div>
										</dd>
										<c:forEach var="node" items="${vo.nodeRatio}">
										<dt class="detail_list overflow" <c:if test="${!empty node.nodeOrgName}"> style="cursor:pointer;" onclick="openThisByName('${node.subject}','${node.nodeOrgId}', '${node.nodeModuleType }', '${node.nodePolicyId}', '${node.nodeOrgType}','${node.includeChild}','finishOverRate', 'desc','overScatter');"</c:if> >
											<c:if test="${!empty node.nodeOrgName}">
											<span class="detail_name" title="${ctp:toHTML(node.subject)}">${ctp:toHTML(node.subject)}</span>
											<span class="detail_numIm">
												<em class="num_all"></em>
												<em class="num_real" style="width:${node.overDoneRatio}"></em>
											</span>
											<span class="detail_num">${node.overDoneRatio}</span>
											</c:if>
										</dt>
										</c:forEach>
									</dl>
									<%-- 节点end --%>
									<%-- 单位start --%>
									<dl>
										<dd class="overflow">
											<div class="left"><em></em><span class="fs14">${ctp:i18n("wfanalysis.process.unit") }</span></div> 
											<div class="right" onclick="more('account','finishOverRate','desc', 'overBarEfRank');">${ctp:i18n("wfanalysis.process.more") }</div>
										</dd>
										<c:forEach var="account" items="${vo.accountRatio}">
										<dt class="detail_list hand" <c:if test="${!empty account.accountName}"> style="cursor:pointer;" onclick="openAccountThisByName('${account.accountId }', '${account.accountName }','finishOverRate', 'desc','overScatter');"</c:if>>
										<c:if test="${!empty account.accountName}">
											<span class="detail_name" title="${ctp:toHTML(account.accountName)}">${ctp:toHTML(account.accountName)}</span>
											<span class="detail_numIm">
												<em class="num_all"></em>
												<em class="num_real" style="width:${account.overDoneRatio}"></em>
											</span>
											<span class="detail_num">${account.overDoneRatio}</span>
										</c:if>
										</dt>
										</c:forEach>
									</dl>
									<%-- 单位end --%>
									<%-- 部门start --%>
									<dl>
										<dd class="overflow">
											<div class="left"><em></em><span class="fs14">${ctp:i18n("wfanalysis.process.department") }</span></div> 
											<div class="right" onclick="more('department','finishOverRate','desc', 'overBarEfRank');">${ctp:i18n("wfanalysis.process.more") }</div>
										</dd>
										<c:forEach var="dept" items="${vo.deptRatio}">
										<dt class="detail_list hand" <c:if test="${!empty dept.nodeDepartmentName}"> style="cursor:pointer;" onclick="openDepartmentThisByName('${dept.nodeDepartmentId }', '${dept.subject }', 'finishOverRate', 'desc','overScatter');"</c:if>>
										<c:if test="${!empty dept.nodeDepartmentName}">
											<span class="detail_name" title="${ctp:toHTML(dept.subject)}">${ctp:toHTML(dept.subject)}</span>
											<span class="detail_numIm">
												<em class="num_all"></em>
												<em class="num_real" style="width:${dept.overDoneRatio}"></em>
											</span>
											<span class="detail_num">${dept.overDoneRatio}</span>
										</c:if>
										</dt>
										</c:forEach>
									</dl>
									<%-- 部门end --%>
									<%-- 人员start --%>
									<dl>
										<dd class="overflow">
											<div class="left"><em></em><span class="fs14">${ctp:i18n("wfanalysis.process.member") }</span></div> 
											<div class="right" onclick="more('member','finishOverRate','desc', 'overBarEfRank');">${ctp:i18n("wfanalysis.process.more") }</div>
										</dd>
										<c:forEach var="member" items="${vo.memberRatio}">
										<dt class="detail_list hand" <c:if test="${!empty member.nodeMemberName}"> style="cursor:pointer;" onclick="openMemberThisByName('${member.nodeMemberId }', '${member.nodeMemberName }','${member.nodeDepartmentName }', 'finishOverCaseCount');"</c:if>>
										<c:if test="${!empty member.nodeMemberName}">
											<span class="detail_name" title="${ctp:toHTML(member.subject)}">${ctp:toHTML(member.subject)}</span>
											<span class="detail_numIm">
												<em class="num_all"></em>
												<em class="num_real" style="width:${member.overDoneRatio}"></em>
											</span>
											<span class="detail_num">${member.overDoneRatio}</span>
										</c:if>
										</dt>
										</c:forEach>
									</dl>
									<%-- 人员end --%>
								</div>
							</div>
						</div>
						<%-- 右正文-超期处理比例TOP3 end --%>
						
						<%-- 右正文-处理时长TOP3 start --%>
						<div class="left">
							<div class=" haddle_timeLimet">
								<h3 class="limet_name">${ctp:i18n("wfanalysis.overview.processing.time.Top3") } 
								<span class="titleSpan_title">
									<em class="ico16 help_16 help_16_red"></em>
									<em class="em_title em_title_bg"></em>
									<em class="em_title em_title_content">${ctp:i18n("wfanalysis.overview.explain.text5") }</em>
								</span>
								</h3>
								
								<div class="rangking_list left">
									<%-- 节点start --%>
									<dl>
										<dd class="overflow ">
											<div class="left"><em ></em><span class="fs14">${ctp:i18n("wfanalysis.node.name") }</span></div> 
											<div class="right" onclick="more('node','avgHandleTime','desc', 'barEfRank');">${ctp:i18n("wfanalysis.process.more") }</div>
										</dd>
										<c:forEach var="node" items="${vo.nodeRuntime}">
										<dt class="detail_list" <c:if test="${!empty node.nodeOrgName}"> style="cursor:pointer;" onclick="openThisByName('${node.subject}','${node.nodeOrgId}', '${node.nodeModuleType}', '${node.nodePolicyId}','${node.nodeOrgType}','${node.includeChild}', 'avgRunTime', 'desc','');"</c:if> >
										<c:if test="${!empty node.nodeOrgName}">
											<span class="detail_name" title="${ctp:toHTML(node.subject)}">${ctp:toHTML(node.subject)}</span>
											<span class="detail_numIm ">
												<em class="num_all"></em>
												<em class="num_real" style="width:${node.avgRunTime/vo.baseRuntimeNum}%"></em>
											</span>
											<span class="detail_num ">${v3x:showDateByWork(node.avgRunTime)}</span>
										</c:if>
										</dt>
										</c:forEach>
									</dl>
									<%-- 节点end --%>
									<%-- 单位start --%>
									<dl>
										<dd class="overflow">
											<div class="left"><em></em><span class="fs14">${ctp:i18n("wfanalysis.process.unit") }</span></div> 
											<div class="right" onclick="more('account','avgRunTime','desc', 'barEfRank');">${ctp:i18n("wfanalysis.process.more") }</div>
										</dd>
										<c:forEach var="account" items="${vo.accountRuntime}">
										<dt class="detail_list hand" <c:if test="${!empty account.accountName}"> style="cursor:pointer;" onclick="openAccountThisByName('${account.accountId }', '${account.accountName }','avgRunTime', 'desc','');"</c:if>>
										<c:if test="${!empty account.accountName}">
											<span class="detail_name" title="${ctp:toHTML(account.accountName)}">${ctp:toHTML(account.accountName)}</span>
											<span class="detail_numIm">
												<em class="num_all"></em>
												<em class="num_real" style="width:${account.avgRunTime/vo.baseRuntimeNum}%"></em>
											</span>
											<span class="detail_num">${v3x:showDateByWork(account.avgRunTime)}</span>
										</c:if>
										</dt>
										</c:forEach>
									</dl>
									<%-- 人员end --%>
									<%-- 部门start --%>
									<dl>
										<dd class="overflow">
											<div class="left"><em></em><span class="fs14">${ctp:i18n("wfanalysis.process.department") }</span></div> 
											<div class="right" onclick="more('department','avgRunTime','desc', 'barEfRank');">${ctp:i18n("wfanalysis.process.more") }</div>
										</dd>
										<c:forEach var="dept" items="${vo.deptRuntime}">
										<dt class="detail_list hand" <c:if test="${!empty dept.nodeDepartmentName}"> style="cursor:pointer;" onclick="openDepartmentThisByName('${dept.nodeDepartmentId }', '${dept.subject }', 'avgRunTime', 'desc','');"</c:if>>
										<c:if test="${!empty dept.nodeDepartmentName}">
											<span class="detail_name" title="${ctp:toHTML(dept.subject)}">${ctp:toHTML(dept.subject)}</span>
											<span class="detail_numIm">
												<em class="num_all"></em>
												<em class="num_real" style="width:${dept.avgRunTime/vo.baseRuntimeNum}%"></em>
											</span>
											<span class="detail_num">${v3x:showDateByWork(dept.avgRunTime)}</span>
										</c:if>
										</dt>
										</c:forEach>
									</dl>
									<%-- 部门end --%>
									<%-- 人员start --%>
									<dl>
										<dd class="overflow">
											<div class="left"><em></em><span class="fs14">${ctp:i18n("wfanalysis.process.member") }</span></div> 
											<div class="right" onclick="more('member','avgRunTime','desc', 'barEfRank');">${ctp:i18n("wfanalysis.process.more") }</div>
										</dd>
										<c:forEach var="member" items="${vo.memberRuntime}">
										<dt class="detail_list hand" <c:if test="${!empty member.nodeMemberName}"> style="cursor:pointer;" onclick="openMemberThisByName('${member.nodeMemberId }', '${member.nodeMemberName }','${member.nodeDepartmentName }', 'finishCaseCount');"</c:if>>
										<c:if test="${!empty member.nodeMemberName}">
											<span class="detail_name" title="${ctp:toHTML(member.subject)}">${ctp:toHTML(member.subject)}</span>
											<span class="detail_numIm">
												<em class="num_all"></em>
												<em class="num_real" style="width:${member.avgRunTime/vo.baseRuntimeNum}%"></em>
											</span>
											<span class="detail_num">${v3x:showDateByWork(member.avgRunTime)}</span>
										</c:if>
										</dt>
										</c:forEach>
									</dl>
									<%-- 人员end --%>
								</div>
							</div>
						</div>
						<%-- 右正文-处理时长TOP3 end --%>
					</div>
				</div>
			</div>
			
		</div>
	</div>
</div>
	<script type="text/javascript" src="${path}/apps_res/wfanalysis/js/jquery.htdate-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path}/apps_res/wfanalysis/js/wfa-common-debug.js${ctp:resSuffix()}"></script>
	<!--[if lt IE 9]>
		<script type="text/javascript" src="${path}/common/respond/respond.min.js${ctp:resSuffix()}"></script>
	<![endif]-->
	<!-- 右正文end -->
	<script type="text/javascript">
		$(function(){
			resizeProcess();
			initPageTitle();
		});
		$(window).resize(function(){
			resizeProcess();
		})
		/**
		* 基础数据新增title
		*/
		function initPageTitle(){
			$(".dataContain .dataSumary .sumary_list ul li div").each(function(i){
				var span = $(this).find("span");
				var title = "";
				span.each(function(j){
					title += $(this).html()+" ";
				})
				$(this).attr("title",title);
			})
		}
		function resizeProcess(){
			//进度条
			var $dl = $(".rangking_list dl");
			var dlWitdh = $dl.width();
			var numWidth = dlWitdh - 395;
			$dl.find(".detail_numIm").css("width", ( numWidth < 100 ? 100 : numWidth )+ "px");
		}
	
		function more(type,orderKey,orderBy, chart){
			var url_=_ctxPath+"/wfanalysis.do?method="+type;
			if (type == 'department' || type == 'member') {
				$("#permissionOption").val(''); //清空查询条件
			}
			if(orderKey){
				url_ = url_ + "&orderKey=" + orderKey;
			}
			if(orderBy){
				url_ = url_ + "&orderBy=" + orderBy;
			}
			if (chart) {
				url_ = url_ + "&chart=" + chart;
			}
			query(url_);
		}
		
		/**
		 * 节点名称穿透
		 */
		function openThisByName(nodeName,nodeOrgId, nodeModuleType, nodePolicyId,nodeOrgType,includeChild, orderKey, orderBy,chart){
			var tempIds = $("#templateIds").val();
			var rptYear = $("#rptYear").val();
			var rptMonth = $("#rptMonth").val();
			var url = _ctxPath +"/wfanalysis.do?method=departmentThrough&templateIds=" + tempIds 
					+ "&rptYear=" + rptYear 
					+ "&rptMonth=" + rptMonth
					+ "&crumbName=" + encodeURIComponent(encodeURIComponent(nodeName))
					+ "&nodeModuleType=" + nodeModuleType 
					+ "&nodePolicyId=" + encodeURIComponent(encodeURIComponent(nodePolicyId)) 
					+ "&nodeOrgId=" + encodeURIComponent(encodeURIComponent(nodeOrgId))
					+ "&nodeOrgType=" + nodeOrgType
					+ "&includeChildDepartment=" + includeChild
					+ "&orderKey=" + orderKey
					+ "&chart="+chart
					+ "&searchRange=" +$("#templateRange").val()
					+ "&orderBy=" + orderBy;
			if("Department" == nodeOrgType && "0" == includeChild && "finishOverRate" == orderKey){//相当于只有超期才有图的定位
				url += "&chart=overScatter";
			}
			getA8Top().newDialog = openDialog(url, '${ctp:i18n("wfanalysis.node.performance.penetration.page") }');
		}

		/**
		 * 部门名称穿透
		 */
		function openDepartmentThisByName(departmentId, departmentName, orderKey, orderBy,chart) {
			var tempIds = $("#templateIds").val();
			var rptYear = $("#rptYear").val();
			var rptMonth = $("#rptMonth").val();
			var searchRange = $("#templateRange").val();
			var url = _ctxPath +"/wfanalysis.do?method=memberThrough&templateIds=" + tempIds
					+ "&rptYear=" + rptYear 
					+ "&rptMonth=" + rptMonth
					+ "&departmentId=" + departmentId 
					+ "&crumbName=" + encodeURIComponent(encodeURIComponent(departmentName))
					+ "&orderKey=" + orderKey
					+ "&orderBy=" + orderBy
					+ "&chart="+chart
					+ "&searchRange=" +searchRange;
			getA8Top().newDialog = openDialog(url, '${ctp:i18n("wfanalysis.department.performance.penetration.page") }');
		}
		
		/**
		* 单位名称穿透
		*/
		function openAccountThisByName(accountId, accountName, orderKey, orderBy,chart){
			var tempIds = $("#templateIds").val();
			var rptYear = $("#rptYear").val();
			var rptMonth = $("#rptMonth").val();
			var searchRange = $("#templateRange").val();
			var url = _ctxPath +"/wfanalysis.do?method=departmentThrough&templateIds=" + tempIds
					+ "&rptYear=" + rptYear 
					+ "&rptMonth=" + rptMonth
					+ "&accountId=" + accountId 
					+ "&crumbName=" + encodeURIComponent(encodeURIComponent(accountName))
					+ "&orderKey=" + orderKey
					+ "&orderBy=" + orderBy
					+ "&nodeOrgType=accountProcess"
					+ "&chart="+chart
					+ "&searchRange=" +searchRange;
			getA8Top().newDialog = openDialog(url, '${ctp:i18n("wfanalysis.department.performance.penetration.page") }');
		}
		
		function openDialog(url, title){
			dialog = $.dialog({
				       id: 'nodeflowDetail',
				       url: url,
				       width: 1024,
				       height: 800,
					   targetWindow:getA8Top(),
				       title: $.i18n("wfanalysis.workflowDetail.detailAnalysis.title"),
				       checkMax:true,
					   closeParam:{
					       'show':true,
					       autoClose:true,
						   handler: function() {
							   getA8Top().newDialog = null;
						   }
					   },
					maxParam:{
						'show':true
					}
			});
			return dialog;
		}
		//人员穿透
		function openMemberThisByName(memberId, memberName,departmentName, processEffType) {
			var url = _ctxPath +"/wfanalysis.do?method=workflowDetail&detailType=memberflowDetail";
			var templateIds = $("#templateIds").val();
			var rptYear = $("#rptYear").val();
			var rptMonth = $("#rptMonth").val();
			dialog = $.dialog({
		       id: 'workflowDetail',
			   targetWindow:getA8Top(),
			   transParams : {
				   templateIds: templateIds,
				   memberId: memberId,
				   processEffType: processEffType,
				   rptYear: rptYear,
				   rptMonth: rptMonth,
				   memberName:memberName+"-"+departmentName
			   },
		       url: url,
		       width: 1024,
		       height: 800,
		       title: $.i18n("wfanalysis.workflowDetail.detailData.title"),
		       checkMax:true,
			   closeParam:{
			       'show':true,
			        autoClose:true
			   }
			});
		
		}
	</script>
</body>
</html>