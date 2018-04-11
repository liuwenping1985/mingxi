
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>${ctp:i18n('form.forminputchoose.rename')}</title>
<style>
</style>
<script type="text/javascript" src="${path}/common/form/component/forminputchooserename.js${ctp:resSuffix()}"></script>
</head>
<body>
<form method="post">
	<input type="hidden" id="inputType" value="${inputType}">
	<input type="hidden" id="fieldType" value="${fieldType}">
	<input type="hidden" id="fieldName" >
	<input type="hidden" id="pageFrom" value="${pageFrom}">
    <div style="width: 400px;height: 100%;font-size: 12px;margin:15px" class="clearfix">
	    <div class="clearfix" style="text-align: right;line-height: 25px;margin-top: 5px;">
	    	<div class="common_radio_box left" style="margin: 5px 15px; width: 60px; line-height: 25px; white-space: nowrap;">
		        <label>${ctp:i18n('form.forminputchoose.original.name')}：</label>
		    </div>
		    <div class="left" style="width: 305px;text-align: left;line-height: 25px;">
		  		<div class="common_txtbox clearfix">
				    <div class="common_txtbox_wrap">
			           <label id="rowheader" name="statRowHeader"></label>
			    	</div>
				</div>
		   	</div>
	    </div>
	    <div class="clearfix" style="text-align: right;line-height: 25px;margin-top: 5px;">
	    	<!-- 标题 -->
	    	<div class="common_radio_box left" style="margin: 5px 15px; width: 60px; line-height: 25px; white-space: nowrap;">
		        <label>${ctp:i18n('form.forminputchoose.rename')}：</label>
		    </div>
	        <div class="left" style="width: 305px;text-align: left;line-height: 25px;">
		  		<div class="common_txtbox clearfix">
				    <div class="common_txtbox_wrap">
			           <input type="text" id="title"/>
			    	</div>
				</div>
		   	</div>
	    </div>
	    <c:if test="${pageFrom ne 'bindDesign' }">
		    <div style="margin: 5px;line-height: 25px;">
		        <font color='red'>${ctp:i18n('form.forminputchoose.titleerror')}</font>
		    </div>
	    </c:if>
	    <c:if test="${pageFrom eq 'bindDesign' }">
	    <c:choose>
	    	<%--复选框 类型--%>
	    	<c:when test="${inputType eq 'checkbox'}">
	    		<div class="clearfix" style="text-align: right;line-height: 25px;margin-top: 5px;" id="default_checkbox">
	    			<%-- 前置标签 --%>
				    <div class="common_radio_box left" style="margin: 5px 15px; width: 60px; line-height: 25px; white-space: nowrap;">
				        <label>${ctp:i18n('form.forminputchoose.front.label')}：</label>
				    </div>
					<div class="left" style="width: 305px;text-align: left;line-height: 25px;">
				  		<div class="common_txtbox clearfix">
						    <div class="common_txtbox_wrap">
					           <input id="default_checkbox_front" class="validate" validate="type:'string',avoidChar:'&quot;&lt;&gt;'"/> 
					    	</div>
						</div>
				   	</div>
			   	</div>
			   	<div class="clearfix" style="text-align: right;line-height: 25px;margin-top: 5px;" id="default_checkbox">
	    			<%-- 缺省设置 --%>
				    <div class="common_radio_box left" style="margin: 5px 15px; width: 60px; line-height: 25px; white-space: nowrap;">
				        <label>${ctp:i18n('form.forminputchoose.default.setting.label')}：</label>
				    </div>
					<div class="left" style="width: 305px;text-align: left;line-height: 25px;">
				  		<select id="default_checkbox_select" style="width: 305px;">
				  			<%-- 未选中 --%>
							<option value="0" selected="selected"></option>
							<%-- 选中 --%>
							<option value="1">${ctp:i18n('form.forminputchoose.select.selected.label')}</option>
			       		</select>
				   	</div>
			   	</div>
	    	</c:when>
	    	<%--下拉枚举 类型--%>
	    	<c:when test="${inputType eq 'select' or inputType eq 'radio'}">
	    		<div class="clearfix" style="text-align: right;line-height: 25px;margin-top: 5px;" >
	    			<%-- 树形显示 --%>
				    <div class="common_radio_box left" style="margin: 5px 15px; width: 60px; line-height: 25px; white-space: nowrap;">
				        <label>${ctp:i18n('form.forminputchoose.tree.show.label')}：</label>
				    </div>
					<div class="common_radio_box clearfix left" style="margin: 5px 15px 5px 0px;text-align: left;line-height: 25px;" id="treeCheckRadio">
				  		<label class="margin_r_10  hand " for="treeYes"> 
	    					<input type="radio" class="radio_com" name="treeDefaultValue" id="treeYes"  value="1">${ctp:i18n('form.forminputchoose.tree.yes.label')} 
	    				</label>
	    				<label class="margin_r_10  hand " for="treeNo"> 
							<input class="radio_com" type="radio" name="treeDefaultValue" id="treeNo" checked="checked" value="0">${ctp:i18n('form.forminputchoose.tree.no.label')} 
						</label>
				   	</div>
			   	</div>
	    	</c:when>
	    	<c:when test="${inputType eq 'member' or inputType eq 'multimember' or inputType eq 'department' or inputType eq 'multidepartment' or  inputType eq 'account' or inputType eq 'multiaccount'}">
	    		<%-- 选择人员控件类型 --%>
	     		<div class="clearfix" style="text-align: right;line-height: 25px;margin-top: 5px;" id="default_text">	
		    		<!-- 缺省值： -->
				    <div class="common_radio_box left" style="margin: 5px 15px; width: 60px; line-height: 25px; white-space: nowrap;">
				        <span>${ctp:i18n('form.query.defaultvalue.label')}：</span>
				    </div>
		    		<div class="right" style="width: 310px;text-align: left;line-height: 25px;" id="defaultSetId">
		    			<!-- 手工 -->
		    			<div class="clearfix" style="text-align: left;line-height: 25px;margin-top: 5px;">
						    <div class="common_radio_box left" style="margin: 5px 15px 5px 0px; width: 60px; line-height: 25px; white-space: nowrap;">
						        <label class="margin_t_5 hand " for="handTo"> 
			    					<input type="radio" class="radio_com" name="defaultvalue" id="handTo"  checked="checked" value="text">${ctp:i18n('form.operhigh.handwork.label')} 
			    				</label>
						    </div>
						   	<div class="left" style="width: 230px;text-align: left;line-height: 25px;">
						  		<div class="common_txtbox clearfix">
								    <div class="common_txtbox_wrap">
							           <input type="text" name="handValue" id="handValue" class="input-100 validate" validate="type:'string',avoidChar:'&&quot;&lt;&gt;'" value="${ctp:i18n('form.select.handwork.default.label')}">
							           <input type="hidden" name="orgIds" id="handOrgIds">
							    	</div>
								</div>
						   	</div>
					   	</div>
			    		<!-- 系统变量 -->
				  		<div class="clearfix" style="text-align: left;line-height: 25px;margin-top: 5px;">
						    <div class="common_radio_box left" style="margin: 5px 15px 5px 0px;width: 60px; line-height: 25px; white-space: nowrap;">
						        <label class="margin_t_5 hand " for="systemTo"> 
									<input class="radio_com" type="radio" name="defaultvalue" id="systemTo"  value="extend">${ctp:i18n('form.operhigh.systemvar.label')} 
								</label>
						    </div>
							<div class="left" style="width: 220px;text-align: left;line-height: 25px;margin: 5px 15px 5px 0px;">
					       		<select name="systemValue" class="input-disabled" id="systemValue" style="width:230px;" <c:if test="${inputType eq 'department' or inputType eq 'multidepartment'}">onchange="systemVarChange4Dept()" </c:if>>
									<option value=""></option>
									<c:forEach var="it" items="${systemVarList }">
										<%--  <option value="${it.key }">${it.text }</option>--%>
										<option value="${it[0] }">${it[1] }</option> 
									</c:forEach>
								</select>
						   	</div>
					   	</div>
				   	</div>
			    </div>
			    <c:if test="${inputType eq 'department' or inputType eq 'multidepartment'}">
			    	<input type="hidden" id="isIncludeSubDept">
			   		<%-- 树形显示 --%>
				    <div class="common_radio_box left" style="margin: 5px 15px; width: 60px; line-height: 25px; white-space: nowrap;">
				        <label>${ctp:i18n('form.forminputchoose.tree.show.label')}：</label>
				    </div>
					<div class="common_radio_box clearfix left" style="margin: 5px 15px 5px 0px;text-align: left;line-height: 25px;" id="treeCheckRadio">
				  		<label class="margin_r_10  hand " for="treeYes"> 
	    					<input type="radio" class="radio_com" name="treeDefaultValue" id="treeYes"  value="1">${ctp:i18n('form.forminputchoose.tree.yes.label')} 
	    				</label>
	    				<label class="margin_r_10  hand " for="treeNo"> 
							<input class="radio_com" type="radio" name="treeDefaultValue" id="treeNo" checked="checked" value="0">${ctp:i18n('form.forminputchoose.tree.no.label')} 
						</label>
				   	</div>
			   	</c:if>
	    	</c:when>
	    	<c:when test="${inputType eq 'text' or inputType eq 'lable' or inputType eq 'textarea'}">
	    		<%-- 文本框类型 --%>
	     		<div class="clearfix" style="text-align: right;line-height: 25px;margin-top: 5px;" id="default_text">	
		    		<!-- 缺省值： -->
				    <div class="common_radio_box left" style="margin: 5px 15px; width: 60px; line-height: 25px; white-space: nowrap;">
				        <span>${ctp:i18n('form.query.defaultvalue.label')}：</span>
				    </div>
		    		<div class="right" style="width: 310px;text-align: left;line-height: 25px;" id="defaultSetId">
		    			<!-- 手工 -->
		    			<div class="clearfix" style="text-align: left;line-height: 25px;margin-top: 5px;">
						    <div class="common_radio_box left" style="margin: 5px 15px 5px 0px; width: 60px; line-height: 25px; white-space: nowrap;">
						        <label class="margin_t_5 hand " for="handTo"> 
			    					<input type="radio" class="radio_com" name="defaultvalue" id="handTo"  checked="checked" value="text">${ctp:i18n('form.operhigh.handwork.label')} 
			    				</label>
						    </div>
						   	<div class="left" style="width: 230px;text-align: left;line-height: 25px;">
						  		<div class="common_txtbox clearfix">
								    <div class="common_txtbox_wrap">
							           <input type="text" name="handValue" id="handValue" class="input-100 validate" validate="type:'string',avoidChar:'&&quot;&lt;&gt;'" value="${ctp:i18n('form.select.handwork.default.label')}">
							    	</div>
								</div>
						   	</div>
					   	</div>
			    		<!-- 系统变量 -->
				  		<div class="clearfix" style="text-align: left;line-height: 25px;margin-top: 5px;">
						    <div class="common_radio_box left" style="margin: 5px 15px 5px 0px;width: 60px; line-height: 25px; white-space: nowrap;">
						        <label class="margin_t_5 hand " for="systemTo"> 
									<input class="radio_com" type="radio" name="defaultvalue" id="systemTo"  value="extend">${ctp:i18n('form.operhigh.systemvar.label')} 
								</label>
						    </div>
							<div class="left" style="width: 220px;text-align: left;line-height: 25px;margin: 5px 15px 5px 0px;">
					       		<select name="systemValue" class="input-disabled" id="systemValue" style="width:230px;">
									<option value=""></option>
									<c:forEach var="it" items="${systemVarList }">
										<%--  <option value="${it.key }">${it.text }</option>--%>
										<option value="${it[0] }">${it[1] }</option> 
									</c:forEach>
								</select>
						   	</div>
					   	</div>
				   	</div>
			    </div>
	    	</c:when>
	    	<c:when test="${inputType eq 'date' or inputType eq 'datetime'}">
	    		<%-- 日期时间类型 --%>
	    		<div class="clearfix" style="text-align: right;line-height: 25px;margin-top: 5px;" id="default_checkbox">
	    			<%-- 预制选项 --%>
				    <div class="common_radio_box left" style="margin: 5px 15px; width: 60px; line-height: 25px; white-space: nowrap;">
				        <label>${ctp:i18n('form.forminputchoose.dateType.yz.label')}：</label>
				    </div>
					<div class="left" style="width: 305px;text-align: left;line-height: 25px;">
				  		<div class="common_txtbox clearfix">
						    <div class="common_txtbox_wrap left" style="width:260px;">
					           <input id="dateTimeYzxxName" type="text" onfocus="dateTimeYzxxFocus(this)" value="${ctp:i18n('form.forminputchoose.default.choose.label')}"/> 
					           <input id="dateTimeYzxxValue" type="hidden"/> 
					    	</div>
					    	<div class="right">
								<span class="ico16 help_16" id="helpMessage"></span>
							</div>
						</div>
						<div class="common_txtbox clearfix margin_t_5" style="margin-left: 0px;">
						    <%-- 缺省选中第一项 --%>
				           	<label for="defaultCheckFirst" class="margin_r_10 hand">
       							<input type="checkbox" value="1" id="defaultCheckFirst" name="defaultCheckFirst" class="radio_com">${ctp:i18n('form.forminputchoose.default.selected.first.label')} 
       						</label>
						</div>
				   	</div>
			   	</div>
			   	
	    	</c:when>
	     	<c:otherwise>
	     		
	     	</c:otherwise>
	    </c:choose>
	    </c:if>
	
    </div>
</form>
<%@ include file="rename.js.jsp"%>
</body>
</html>
