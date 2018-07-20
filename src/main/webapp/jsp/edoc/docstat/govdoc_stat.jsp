<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=edocStatNewManager,edocStatSetManager"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/docstat/govdoc_stat.js${v3x:resSuffix()}" />"></script>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/common/template/template.js.jsp" %>
<title></title>
<style type="text/css">
    .stadic_body_top_bottom{
        bottom: 0px;
    }
    .stadic_body_footer_bottom{
        bottom: 35px;
    }
    .set_search input[type="text"]{ width:237px; height:26px}
    .statistics{
     text-align: center;
     padding:10px 0;
     margin-bottom:10px;
     border-bottom:1px solid #ddd;
    }
	.statistics>label{
	    margin-right:20px;
	}
</style>
<script>
	var _ctxPath ='${path}';
	var edocStatUrl = _ctxPath+"/edocStatNew.do";
	var curYear = '${curYear}';
</script>
</head>
<body scroll="">

<div id="layout" class="comp bg_color" comp="type:'layout'">

<div class="layout_north" id="layout_north" layout="height:140,maxHeight:140,minHeight:100,spiretBar:{show:true,handlerT:function(){layout.setNorth(0);},handlerB:function(){layout.setNorth(140);}}">

<div id="tabs" class="margin_t_5 margin_r_5 ">

<div class="border_alls">
	
<div class="form_area"  id="queryCondition" >

<form id="statConditionForm" name="statConditionForm" method="post">
<input type="hidden" id="statId" name="statId" value="${statSetList[0].id }" />
<input type="hidden" id="statType" name="statType" value="${statSetList[0].statType }" />

<input type="hidden" id="statTitle" name="statTitle" value=""/>

<div class="form_area set_search">		  
	<%-- 展示被授权的统计设置名称 --%>
	<p class="statistics">
		<c:forEach items="${statSetList}" var="statSet" varStatus="status">
			<label>
            	<input type="radio" value="${statSet.id}"  name="stat" id="stat" <c:if test="${status.index ==0 }"> checked </c:if> class="radio_com m_enable">${statSet.name}
          	</label>
		</c:forEach>
   	</p>
          	
	<table border="0" cellpadding="0" cellspacing="0" class="common_center w90b">
	<tbody>
       	<tr class="margin_b_10" align="center">
       		<td nowrap="nowrap" class="padding_tb_5">
				<label>公文文号：</label>
				<select name="docMark" id="docMark" class="comp" comp="type:'autocomplete',valueChange:docMarkChange" style="width:100px;">
		        	<option value="-1" selected>全部</option>	
		        	<c:forEach items="${docMarkModelList }" var="bean">
		        		<option value="${bean.markDefinitionId }">${bean.wordNo }</option>	
		        	</c:forEach>
				</select>
   			</td>
		    <td nowrap="nowrap" class="padding_tb_5">
		    	<label>内部文号：</label>
		    	<select name="serialNo" id="serialNo" class="comp" comp="type:'autocomplete',valueChange:docMarkChange" style="width:100px;">
		        	<option value="-1" selected>全部</option>
		        	<c:forEach items="${serialNoModelList }" var="bean">
		        		<option value="${bean.markDefinitionId }">${bean.wordNo }</option>
		        	</c:forEach>
				</select>
			</td>
		    <td nowrap="nowrap" class="padding_tb_5">
		    	<label>统计范围：</label>
				<select name="statRangeId" id="statRangeId" style="width:80px">
					<option value="-1" selected>全部</option>											 
				</select>
 			</td>
			<td nowrap="nowrap" class="padding_tb_5">
			            统计时间:
				<label for="year">
					<input type="radio" id="year" name="timeType" value="1" checked onclick="timeTypeChange(this);"/>${ctp:i18n("edoc.stat.condition.statTo.Time.year") }&nbsp;&nbsp; 
				</label>
				<label for="quarter">
					<input type="radio" id="quarter" name="timeType" value="2" onclick="timeTypeChange(this);"/>${ctp:i18n("edoc.stat.condition.statTo.Time.quarter") }&nbsp;&nbsp; 
				</label>
				<label for="month">
					<input type="radio" id="month" name="timeType" value="3" onclick="timeTypeChange(this);"/>${ctp:i18n("edoc.stat.condition.statTo.Time.month") }&nbsp;&nbsp; 
				</label>
				<label for="day">
					<input type="radio" id="day" name="timeType" value="4" onclick="timeTypeChange(this);"/>${ctp:i18n("edoc.stat.condition.statTo.Time.date") }&nbsp;&nbsp; 
				</label>
			</td>
							
    		<td nowrap="nowrap" class="align_left" width="400px">
				<div id="yearselect">
					<select name="yeartype-startyear" id="yeartype-startyear" style="width:80px">
						<%for(int i=1990;i<2051;i++){%>
					     <c:set var="year" value="<%=i%>"/>
					     <option value="<%=i%>" <c:if test="${curYear==year}">selected</c:if>><%=i %></option>
					   <%}%>
					</select>
					<span id="yearselect-right">
						--
						<select name="yeartype-endyear" id="yeartype-endyear" style="width:80px">
							<%for(int i=1990;i<2051;i++){%>
						     <c:set var="year" value="<%=i%>"/>
						     <option value="<%=i%>" <c:if test="${curYear==year}">selected</c:if>><%=i %></option>
						   <%}%>
						</select>
					</span>
				</div><!-- yearselect -->
										
				<div id="seasonselect" style="display:none;">
					<select name="seasontype-startyear" id="seasontype-startyear" style="width:50px">
						<%for(int i=1990;i<2051;i++){%>
					     <c:set var="year" value="<%=i%>"/>
					     <option value="<%=i%>" <c:if test="${curYear==year}">selected</c:if>><%=i %></option>
					   <%}%>
					</select>
					<select name="seasontype-startseason" id="seasontype-startseason" style="width:60px;">
						<option value="1">1${ctp:i18n("performanceReport.workFlowAnalysis.quarter") }</option>
						<option value="2">2${ctp:i18n("performanceReport.workFlowAnalysis.quarter") }</option>
						<option value="3">3${ctp:i18n("performanceReport.workFlowAnalysis.quarter") }</option>
						<option value="4">4${ctp:i18n("performanceReport.workFlowAnalysis.quarter") }</option>
					</select> 
					<span id="seasonselect-right">
						--
						<select name="seasontype-endyear" id="seasontype-endyear" style="width:50px">
							<%for(int i=1990;i<2051;i++){%>
						     <c:set var="year" value="<%=i%>"/>
						     <option value="<%=i%>" <c:if test="${curYear==year}">selected</c:if>><%=i %></option>
						   <%}%>
						</select>
						<select name="seasontype-endseason" id="seasontype-endseason" style="width:60px;">
							<option value="1" <c:if test="${curSeason==1}">selected</c:if>>1${ctp:i18n("performanceReport.workFlowAnalysis.quarter") }</option>
							<option value="2" <c:if test="${curSeason==2}">selected</c:if>>2${ctp:i18n("performanceReport.workFlowAnalysis.quarter") }</option>
							<option value="3" <c:if test="${curSeason==3}">selected</c:if>>3${ctp:i18n("performanceReport.workFlowAnalysis.quarter") }</option>
							<option value="4" <c:if test="${curSeason==4}">selected</c:if>>4${ctp:i18n("performanceReport.workFlowAnalysis.quarter") }</option>
						</select>
					</span>
				</div><!-- seasonselect -->
										
				<div id="monthselect" style="display:none;">
					<select name="monthtype-startyear" id="monthtype-startyear" style="width:50px">
						<%for(int i=1990;i<2051;i++){%>
					     <c:set var="year" value="<%=i%>"/>
					     <option value="<%=i%>" <c:if test="${curYear==year}">selected</c:if>><%=i %></option>
					   <%}%>
					</select>
					<select name="monthtype-startmonth" id="monthtype-startmonth" style="width:50px;">
						<option value="1">1${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
						<option value="2">2${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
						<option value="3">3${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
						<option value="4">4${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
						<option value="5">5${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
						<option value="6">6${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
						<option value="7">7${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
						<option value="8">8${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
						<option value="9">9${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
						<option value="10">10${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
						<option value="11">11${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
						<option value="12">12${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
					</select>
					<span id="monthselect-right">															
						--
						<select name="monthtype-endyear" id="monthtype-endyear" style="width:50px">
							<%for(int i=1990;i<2051;i++){%>
						     <c:set var="year" value="<%=i%>"/>
						     <option value="<%=i%>" <c:if test="${curYear==year}">selected</c:if>><%=i %></option>
						   <%}%>
						</select>
						<select name="monthtype-endmonth" id="monthtype-endmonth" style="width:50px;">
							<option value="1"  <c:if test="${curMonth==1}">selected</c:if>>1${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
							<option value="2" <c:if test="${curMonth==2}">selected</c:if>>2${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
							<option value="3" <c:if test="${curMonth==3}">selected</c:if>>3${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
							<option value="4" <c:if test="${curMonth==4}">selected</c:if>>4${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
							<option value="5" <c:if test="${curMonth==5}">selected</c:if>>5${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
							<option value="6" <c:if test="${curMonth==6}">selected</c:if>>6${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
							<option value="7" <c:if test="${curMonth==7}">selected</c:if>>7${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
							<option value="8" <c:if test="${curMonth==8}">selected</c:if>>8${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
							<option value="9" <c:if test="${curMonth==9}">selected</c:if>>9${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
							<option value="10" <c:if test="${curMonth==10}">selected</c:if>>10${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
							<option value="11" <c:if test="${curMonth==11}">selected</c:if>>11${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
							<option value="12" <c:if test="${curMonth==12}">selected</c:if>>12${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
						</select>
					</span>			
				</div><!-- monthselect -->
										
				<div id="dayselect" style="display:none;">
				 	<input id="daytype-startday" name="daytype-startday" lastTime="${curDay }"
						value="${curDay }" readonly="readonly" style="width:92px;"
                        class="comp validate" validate="name:'开始日期'"
                        comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" />
					<span id="dayselect-right">								
                    	--
						<input id="daytype-endday" name="daytype-endday" lastTime="${curDay }"
                        	value="${curDay }" readonly="readonly" style="width:92px;"
                            class="comp validate" validate="name:'结束日期'"
                            comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" /> 
					</span>
				</div><!-- dayselect -->
			</td>						
		</tr>	
		<tr align="center">
			<td class="align_center" colspan="5">
				<div style="padding-top:15px;" class="align_center clear padding_lr_5 padding_b_10" id="button_div"> 
					<a href="javascript:void(0)" class="common_button common_button_emphasize margin_r_5" id="querySave" onclick="doStat(1)">${ctp:i18n("edoc.stat.execute.statistics") }</a><%-- 统计 --%>
					<a id="queryReset" class="common_button common_button_gray margin_r_10" href="javascript:void(0)" onclick="">
						${ctp:i18n("edoc.stat.execute.reset") }
                   	</a><%-- 重置 --%>
				</div>
			</td>
		</tr>
   	</tbody>
   	</table>
</div>
<input type="hidden" id="statTitle" name="statTitle" />

</form>
</div>
       		
<form action="#" id="resolveExecel">
    <div id="execelCondition"></div>
</form>

</div><!-- border_alls -->
</div><!-- tabs -->
</div><!-- layout_north -->

<div class="layout_center stadic_layout" layout="border:true">

<div class="set_search align_left" id="oper">
<table class="w100b">
	<tr>
		<td colspan="2">
			<span class="left">
	            <a class="img-button" href="javascript:void(0)" id="reportToExcel" onclick="doStat(2);"><em class="ico16 export_excel_16"></em>${ctp:i18n("edoc.tbar.export.js")}</a> 
	            <a class="img-button" href="javascript:void(0)" id="showInstruction" onclick="showInstruction();"><em class="ico16"></em>说明</a> 
			</span>
		</td>
	</tr>
</table> 
</div>

<div class="stadic_layout_body stadic_body_top_bottom" id="reportResult" >
<div id="tabs" class="w100b h100b">
	<div id="tabBody" class="border_tb common_tabs_body stadic_layout_body stadic_body_top_bottom" style="top:0px;bottom:30px;overflow:hidden;">
	    <div style="position: absolute;height: 100%;left: 5px;top: 0px;right: 5px;">
	        <iframe id="statResultIframe" name="statResultIframe" width="100%" height="100%" src="" frameborder="0"/>
	    </div>
	</div>
</div><!-- tabs -->
</div><!-- reportResult -->

</div>
</div><!-- layout -->

<div class="hidden">
	<iframe name="export_iframe" id="export_iframe">&nbsp;</iframe>
</div>

</body>
</html>