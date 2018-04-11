
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>日期自定义</title>
<style>
	.common_txtbox_wrap{
		margin:0px;
		width: 258px;
		float: left;
	}

</style>
<script type="text/javascript" src="${path}/common/form/component/userDef4DateTime.js${ctp:resSuffix()}"></script>
</head>
<body>
<form method="post" id="userDefDateFormId" class="form_area align_center">
    <div style="width: 400px;height: 100%;font-size: 12px;margin:15px" class="clearfix">
	   
	    <div class="clearfix" style="text-align: right;line-height: 25px;margin-top: 5px;height: 41px">
	    	<!-- 选项命名 -->
	    	<div class="common_radio_box left" style="margin: 5px 5px 5px 15px; width: 70px; line-height: 25px; white-space: nowrap;" title="${ctp:i18n('form.forminputchoose.option.naming.label')}">
		        <label>${ctp:getLimitLengthString(ctp:i18n('form.forminputchoose.option.naming.label'), 10, ' ...')}：</label>
		    </div>
	        <div class="left" style="width: 305px;text-align: left;line-height: 25px;">
		  		<div class="common_txtbox clearfix" style="width: 305px;">
				    <div class="common_txtbox_wrap">
			           <input type="text" id="optionNaming" class="validate" validate="notNull:true,notNullWithoutTrim:true,type:'string',character:'\&#39;&quot;&lt;&gt;',maxLength:30,name:'${ctp:i18n('form.forminputchoose.option.naming.label')}'"/>
			    	</div>
				</div>
		   	</div>
	    </div>
		<div class="clearfix" style="text-align: right;line-height: 25px;margin-top: 5px;">
	    	<!-- 开始时间 -->
	    	<div class="common_radio_box left" style="margin: 5px 5px 5px 15px; width: 70px; line-height: 25px; white-space: nowrap;">
		        <label>${ctp:i18n('form.forminputchoose.option.startdate.label')}：</label>
		    </div>
	        <div class="left" style="width: 305px;text-align: left;line-height: 25px;">
		  		<div class="common_txtbox clearfix">
				    <div class="common_txtbox_wrap">
						<%-- 日期 --%>
						<c:if test="${inputType eq 'date'}">
			            <input type="text" id="startDate"  class="comp validate" readonly="readonly" style="width:242px"  validate="notNull:true,name:'${ctp:i18n('form.forminputchoose.option.startdate.label')}'" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,cache:false,isOutShow:true"/>
						</c:if>
						<%-- 日期时间 --%>
						<c:if test="${inputType eq 'datetime'}">
							<input type="text" id="startDate"  class="comp validate" readonly="readonly" style="width:242px"  validate="notNull:true,name:'${ctp:i18n('form.forminputchoose.option.startdate.label')}'" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,cache:false,isOutShow:true, minuteStep:1"/>
						</c:if>
					</div>
				</div>
		   	</div>
	    </div>
	    <div class="clearfix" style="text-align: right;line-height: 25px;margin-top: 5px;">
	    	<!-- 结束时间 -->
	    	<div class="common_radio_box left" style="margin: 5px 5px 5px 15px; width: 70px; line-height: 25px; white-space: nowrap;">
		        <label>${ctp:i18n('form.forminputchoose.option.enddate.label')}：</label>
		    </div>
	        <div class="left" style="width: 305px;text-align: left;line-height: 25px;">
		  		<div class="common_txtbox clearfix">
				    <div class="common_txtbox_wrap">
					<%-- 日期 --%>
					<c:if test="${inputType eq 'date'}">
			           <input type="text" id="endDate"  class="comp validate" readonly="readonly" style="width:242px" validate="notNull:true,name:'${ctp:i18n('form.forminputchoose.option.enddate.label')}'"  comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,cache:false,isOutShow:true"/>
					</c:if>
					<%-- 日期时间 --%>
					<c:if test="${inputType eq 'datetime'}">
						<input type="text" id="endDate"  class="comp validate" readonly="readonly" style="width:242px" validate="notNull:true,name:'${ctp:i18n('form.forminputchoose.option.enddate.label')}'"  comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,cache:false,isOutShow:true,minuteStep:1"/>
					</c:if>
					</div>
				</div>
		   	</div>
	    </div>
    </div>
</form>
</body>
</html>
