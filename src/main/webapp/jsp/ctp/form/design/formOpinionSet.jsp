<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>意见元素设置</title>
    <%@ include file="/WEB-INF/jsp/edoc/edocHeader.jsp" %>
    <script type="text/javascript">
	    var	formOpinionSetStr = ${formConfigJSON};
		var listStr = "${listStr}";
	    function OK(){
			var form = document.getElementById("opinionSetFrom");
			form.action = "/seeyon/form/fieldDesign.do?method=saveOpinionSet&listStr="+encodeURI(listStr);
	    	$("#opinionSetFrom").ajaxSubmit();
	    }
		function _initPage(){
			_initOpinionSet();
		}
	    /**
	     *初始化页面选中设置
	     */
	    function _initOpinionSet(){
	    	/***设置文单配置项选中  start ***/
	        if(window.formOpinionSetStr){
	            //设置意见显示方式
	            var optionTypeValue = formOpinionSetStr["opinionType"];
	            _checkInput("optionType" + optionTypeValue);
	            
	            //系统落款
	            if(formOpinionSetStr["showUnit"]){//单位名称
	                _checkInput("radio3");
	            }
	            
	            if(formOpinionSetStr["showDept"]){//部门名称
	                _checkInput("radio4");
	            }
	            
	            if(formOpinionSetStr["showName"]){//人员名称
	                _checkInput("radio5");
	            }
	            
	            var showNameType = formOpinionSetStr["showNameType"];
	            _checkInput("nameShowTypeItem" + showNameType);//名称显示方式
	            
	            if(formOpinionSetStr["hideInscriber"]){//落款选项
	                _checkInput("radio6");
	            }
	            
	            if(formOpinionSetStr["inscriberNewLine"]){//落款换行显示
	                _checkInput("inscribedNewLineSet");
	            }
	            
	            //处理时间显示格式
	            var showNameType = formOpinionSetStr["showDateType"];
	            _checkInput("radio" + showNameType);//名称显示方式
	            
	            //处理时间样式 dy 2015-08-19
	            var showNameType = formOpinionSetStr["showDateModel"];
	            if (showNameType){
	          	_checkInput("dealTimeModel" + showNameType);}
	           	else{
	           	var showNameType = "1";
	           	_checkInput("dealTimeModel" + showNameType);}//名称显示样式, 判断是否录入 否则默认为简写
	            	
	        }
	        /***设置文单配置项选中  end ***/
	    }
	    /**
         * 设置Radio 或 Checkbox选中
         * @param inputId : input的ID字符串
         **/
        function _checkInput(inputId){
            var optionTypeRedio = document.getElementById(inputId);
            if(optionTypeRedio){
                optionTypeRedio.checked = true;
            }
        }
    </script>
</head>
<body onload="_initPage()">
	<form id="opinionSetFrom" name="opinionSetFrom" method="post" >
	<div id="fieldTwo" name="fieldTwo">
		<table>
			<tr>
				<td>
					<fieldset style="padding: 20px;">
						<legend>
							<b><fmt:message key="edoc.form.flowperm.process.sortType.set" /></b>
						</legend>
						<br>
						<table>
							<tr>
								<td>
									<table>
										<tr>
											<td valign="top" style="vertical-align: top;">
												<!-- lijl添加(意见保留设置 ) --> <fmt:message
													key="edoc.form.flowperm.setup" />:
											</td>
											<td>
												<div class="common_radio_box clearfix">
													<!-- lijl添加(全流程保留所有意见) -->
													<!-- OA-34152 应用检查：文单定义---意见元素设置，默认的处理意见保留设置应该是全程保留所有意见 -->
													<LABEL for="optionType2" class="hand display_block">
														<input type="radio" id="optionType2" name="optionType"
														value="2"/>
														<fmt:message key="edoc.form.flowperm.all" />
													</LABEL>

													<!-- lijl添加(全流程保留最后一次意见 )-->
													<LABEL for="optionType1"
														class="margin_t_5 hand display_block"> <input
														type="radio" id="optionType1" name="optionType" value="1" />
														<fmt:message key="edoc.form.flowperm.showLastOptionOnly" />
													</LABEL>

													<%-- 
				                                                <!--  工作项暂时屏蔽：退回时办理人选择覆盖方式，其他情况保留最后意见-->
				                                                <LABEL for="optionType3" class="margin_t_5 hand display_block">
				                                                    <input type="radio" id="optionType3" name="optionType" value="3" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
				                                                    <fmt:message key="edoc.form.flowperm.client" />
				                                                </LABEL> 
				                                                --%>

													<!-- lijl添加(退回时办理人选择覆盖方式，其他情况保留所有意见) -->
													<LABEL for="optionType4"
														class="margin_t_5 hand display_block"> <input
														type="radio" id="optionType4" name="optionType" value="4"/>
														<fmt:message key="edoc.form.flowperm.client1" />
													</LABEL>
												</div>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<table>
										<tr>
											<td valign="top" style="vertical-align: top;"><fmt:message
													key="edoc.form.flowperm.showOpinionSignDploy" /></td>
											<td>
												<fieldset style="border: 2px solid #aaa">
													<legend class="margin_l_5">
														<b><fmt:message
																key="edoc.label.form.set.inscribedContent" /> <%-- 落款内容 --%></b>
													</legend>
													<div class="margin_l_10">
														<!-- 处理人姓名 -->
														<LABEL class="display_block margin_t_5" for="radio5">
															<input type="checkbox" id="radio5" disabled
															name="showOrgnDept" value="2" checked="checked"/>
															<fmt:message key="edoc.form.flowperm.showPerson" />
														</LABEL>
														<%-- 处理人姓名选项 --%>
														<label class="margin_l_5 display_block"> <input
															type="radio" value="0" id="nameShowTypeItem0"
															name="nameShowTypeItem" />
															<fmt:message
																key="edoc.label.form.set.name.showtype.common" />
														</label> <label class="margin_l_5 display_block margin_t_5">
															<input type="radio" value="1" id="nameShowTypeItem1"
															name="nameShowTypeItem" />
															<fmt:message key="edoc.label.form.set.name.showtype.sign" />
														</label> <LABEL for="radio4" class="margin_t_5 display_block">
															<!-- 处理人所属部门 --> <input type="checkbox" id="radio4"
															name="showOrgnDept" value="1" />
															<fmt:message key="edoc.form.flowperm.showDept" />
														</LABEL> <LABEL class="margin_t_5 display_block" for="radio3">
															<!-- 处理人所在单位 --> <input type="checkbox" id="radio3"
															name="showOrgnDept" value="0" />
															<fmt:message key="edoc.form.flowperm.showOrgan" />
														</LABEL>
													</div>
												</fieldset>
											</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td><LABEL class="margin_t_5 display_block"
												for="inscribedNewLineSet"> <%-- 意见与落款换行显示  --%> <input
													type="checkbox" id="inscribedNewLineSet"
													name="showOrgnDept" value="4" />
													<fmt:message key="edoc.label.form.set.inscribedShowType" />
											</LABEL> <LABEL class="margin_t_5 display_block" for="radio6">
													<!-- 文单签批后不显示系统落款 --> <input type="checkbox" id="radio6"
													name="showOrgnDept" value="3" />
													<fmt:message key="edoc.form.flowperm.isNotShowSignInfo" />
											</LABEL></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<table>
										<tr>
											<td valign="top" style="vertical-align: top;"><fmt:message
													key="edoc.form.flowperm.showDateTimeFormat" /></td>
											<td>
												<div class="common_radio_box clearfix">

													<!-- 日期时间 -->
													<label class="hand display_block" for="radio0"> <input
														type="radio" id="radio0" name="dealTimeFormt" value="0"
														onclick="getRadioValue()" />
														<fmt:message key="edoc.form.flowperm.dealDateTimeFormt" />
													</label>

													<!-- 日期 -->
													<label class="margin_t_5 hand display_block" for="radio1">
														<input type="radio" id="radio1" name="dealTimeFormt"
														value="1" onclick="getRadioValue()" />
														<fmt:message key="edoc.form.flowperm.dealDateFormt" />
													</label>

													<!-- 无 -->
													<LABEL class="margin_t_5 hand display_block" for="radio2">
														<input type="radio" id="radio2" name="dealTimeFormt"
														value="2" onclick="getRadioValue()" />
														<fmt:message key="edoc.form.flowperm.dealNullFormt" />
													</LABEL>
												</div>
											</td>
										</tr>
									</table>
								</td>
							</tr>

							<tr>
								<td>
									<table>
										<tr>
											<td valign="top" style="vertical-align: top;"><fmt:message
													key="edoc.form.flowperm.showDateTimeModel" /> <!-- dy添加(处理时间显示样式 ) -->
											</td>
											<td>
												<div class="common_radio_box clearfix">

													<!-- 全称 -->
													<label class="hand display_block" for="dealTimeModel0">
														<input type="radio" id="dealTimeModel0"
														name="dealTimeModel" value="0" onclick="getRadioValue()" />
														<fmt:message key="edoc.form.flowperm.format1" />
														<label>	示例：2016年05月06日 13时46分</label>
													</label>


													<!-- 简称 -->
													<label class="margin_t_5 hand display_block"
														for="dealTimeModel1"> <input type="radio"
														id="dealTimeModel1" name="dealTimeModel" value="1"
														onclick="getRadioValue()" />
														<fmt:message key="edoc.form.flowperm.format2" />
														<label> 示例：2016-05-06 13:46</label>
													</label>


													<shijian> <SCRIPT LANGUAGE="JavaScript">
														function getRadioValue() {
															Date.prototype.format = function(
																	format) {
																if (format == null)
																	format = "yyyy/MM/dd HH:mm:ss.SSS";
																var year = this
																		.getFullYear();
																var month = this
																		.getMonth();
																var sMonth = [
																		"January",
																		"February",
																		"March",
																		"April",
																		"May",
																		"June",
																		"July",
																		"August",
																		"September",
																		"October",
																		"November",
																		"December" ][month];
																var date = this
																		.getDate();
																var day = this
																		.getDay();
																var hr = this
																		.getHours();
																var min = this
																		.getMinutes();
																var sec = this
																		.getSeconds();
																var daysInYear = Math
																		.ceil((this - new Date(
																				year,
																				0,
																				0)) / 86400000);
																var weekInYear = Math
																		.ceil((daysInYear + new Date(
																				year,
																				0,
																				1)
																				.getDay()) / 7);
																var weekInMonth = Math
																		.ceil((date + new Date(
																				year,
																				month,
																				1)
																				.getDay()) / 7);
																return format
																		.replace(
																				"yyyy",
																				year)
																		.replace(
																				"yy",
																				year
																						.toString()
																						.substr(
																								2))
																		.replace(
																				"dd",
																				(date < 10 ? "0"
																						: "")
																						+ date)
																		.replace(
																				"HH",
																				(hr < 10 ? "0"
																						: "")
																						+ hr)
																		.replace(
																				"KK",
																				(hr % 12 < 10 ? "0"
																						: "")
																						+ hr
																						% 12)
																		.replace(
																				"kk",
																				(hr > 0
																						&& hr < 10 ? "0"
																						: "")
																						+ (((hr + 23) % 24) + 1))
																		.replace(
																				"hh",
																				(hr > 0
																						&& hr<10||hr>12
																						&& hr < 22 ? "0"
																						: "")
																						+ (((hr + 11) % 12) + 1))
																		.replace(
																				"mm",
																				(min < 10 ? "0"
																						: "")
																						+ min)
																		.replace(
																				"ss",
																				(sec < 10 ? "0"
																						: "")
																						+ sec)
																		.replace(
																				"SSS",
																				this % 1000)
																		.replace(
																				"a",
																				(hr < 12 ? "AM"
																						: "PM"))
																		.replace(
																				"W",
																				weekInMonth)
																		.replace(
																				"F",
																				Math
																						.ceil(date / 7))
																		.replace(
																				/E/g,
																				[
																						"Sunday",
																						"Monday",
																						"Tuesday",
																						"Wednesday",
																						"Thursday",
																						"Friday",
																						"Saturday" ][day])
																		.replace(
																				"D",
																				daysInYear)
																		.replace(
																				"w",
																				weekInYear)
																		.replace(
																				/MMMM+/,
																				sMonth)
																		.replace(
																				"MMM",
																				sMonth
																						.substring(
																								0,
																								3))
																		.replace(
																				"MM",
																				(month < 9 ? "0"
																						: "")
																						+ (month + 1));
															}
															var d = new Date();
															var aa = document
																	.getElementsByName("dealTimeFormt");
															var a = "";
															for (var i = 0; i < aa.length; i++) {
																var aaa = aa[i];
																if (aaa.checked) {
																	a = aaa.value;
																}
															}
															var bb = document
																	.getElementsByName("dealTimeModel");
															var b = "";
															for (var i = 0; i < bb.length; i++) {
																var bbb = bb[i];
																if (bbb.checked) {
																	b = bbb.value;
																}
															}
															/* if (a == "0") {
																if (b == "1") {
																	document
																			.getElementById("TimeExample").innerHTML = d
																			.format("示例：yyyy-MM-dd HH:mm");
																} else {
																	document
																			.getElementById("TimeExample").innerHTML = d
																			.format("示例：yyyy年MM月dd日 HH时mm分");
																}
															} else if (a == "1") {
																if (b == "1") {
																	document
																			.getElementById("TimeExample").innerHTML = d
																			.format("示例：yyyy-MM-dd");
																} else {
																	document
																			.getElementById("TimeExample").innerHTML = d
																			.format("示例：yyyy年MM月dd日");
																}

															}

															else {
																document
																		.getElementById("TimeExample").innerHTML = d
																		.format("无时间显示");
															}
															; */
														};
													</SCRIPT> </shijian>

												</div>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
			<tr>
				<td>
					<div class="categorySet-body-edocform">
						<table width="70%" border="1" cellspacing="0" cellpadding="5"
							align="center">
							<tr style="background-color: #D3D3D3">
								<th align="left"><fmt:message
										key="edoc.form.flowperm.process.label" /></th>
								<th align="left"><fmt:message
										key="edoc.form.flowperm.process.sortType" /></th>
							</tr>
							<c:forEach items="${processList}" var="bean">
								<tr>
									<td width="30%">${bean.permName}</td>
									<td><select id="sortType_${bean.permItem}"
										name="sortType_${bean.permItem}"
										<c:if test="${param.flag == 'readonly' || bean.permItem == 'feedback'|| bean.permItem == 'report'}"> disabled="disabled"</c:if>>
											<c:choose>
												<c:when test="${bean.sortType == '0'}">
													<option value="0" selected="selected"><fmt:message
															key="edoc.form.flowperm.process.sortType.dealtime.asc" /></option>
												</c:when>
												<c:otherwise>
													<option value="0"><fmt:message
															key="edoc.form.flowperm.process.sortType.dealtime.asc" /></option>
												</c:otherwise>
											</c:choose>
											<c:choose>
												<c:when test="${bean.sortType == '1'}">
													<option value="1" selected="selected"><fmt:message
															key="edoc.form.flowperm.process.sortType.dealtime.desc" /></option>
												</c:when>
												<c:otherwise>
													<option value="1"><fmt:message
															key="edoc.form.flowperm.process.sortType.dealtime.desc" /></option>
												</c:otherwise>
											</c:choose>


											<%--puyc --%>
											<c:choose>
												<c:when test="${bean.sortType == '4'}">
													<option value="4" selected="selected"><fmt:message
															key="edoc.form.flowperm.process.sortTypeAsc.orgLevel" /></option>
												</c:when>
												<c:otherwise>
													<option value="4"><fmt:message
															key="edoc.form.flowperm.process.sortTypeAsc.orgLevel" /></option>
												</c:otherwise>
											</c:choose>

											<%--//puyc --%>

											<c:choose>
												<c:when test="${bean.sortType == '2'}">
													<option value="2" selected="selected"><fmt:message
															key="edoc.form.flowperm.process.sortTypeDesc.orgLevel" /></option>
												</c:when>
												<c:otherwise>
													<option value="2"><fmt:message
															key="edoc.form.flowperm.process.sortTypeDesc.orgLevel" /></option>
												</c:otherwise>
											</c:choose>

											<c:choose>
												<c:when test="${bean.sortType == '3'}">
													<option value="3" selected="selected"><fmt:message
															key="edoc.form.flowperm.process.sortType.deptSortId" /></option>
												</c:when>
												<c:otherwise>
													<option value="3"><fmt:message
															key="edoc.form.flowperm.process.sortType.deptSortId" /></option>
												</c:otherwise>
											</c:choose>

											<%--wangw 增加按人员排序号排序,默认显示最后一位 START --%>
											<c:choose>
												<c:when test="${bean.sortType == '5'}">
													<option value="5" selected="selected"><fmt:message
															key="edoc.form.flowperm.process.sortType.memberSortId" /></option>
												</c:when>
												<c:otherwise>
													<option value="5"><fmt:message
															key="edoc.form.flowperm.process.sortType.memberSortId" /></option>
												</c:otherwise>
											</c:choose>
											<%--wangw 增加按人员排序号排序 End --%>
									</select></td>
								</tr>
							</c:forEach>
						</table>
						<table width="70%" border="0" cellspacing="0" cellpadding="5"
							align="center">
							<tr>
								<td colspan="3"><font color="green">*<fmt:message
											key="edoc.form.otheropinion.notice" /></font><BR> <font
									color="green">*<fmt:message
											key="edoc.form.otheropinion.sortAsc" /></font></td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	</form>
</body>
</html>
