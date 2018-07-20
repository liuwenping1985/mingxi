<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<fmt:setBundle basename="com.seeyon.v3x.isearch.resources.i18n.ISearchResources" var="isearchI18N"/>
<script type="text/javascript">
	<%-- 记录在当前页面存储已添加的查询属性以及查询总数，以便进行添加 --%>
	var selectedConditionMap = new Properties();
	var conditionTotal = ${fn:length(searchConditions)};
	<%-- 区分关联查询界面和文档中心列表界面 --%>
	var isQuote = "${param.isQuote}" == "true";
	<%-- 查询高级选项设置中，将选中的备选项添加至查询组合中去 --%>
	function addCondtion4Search() {
		var allCondtions = document.getElementById("addCondition");
		var selectedCondition = allCondtions.value;
		if(selectedCondition == '-1') {
			return false;
		}
		if(selectedConditionMap.get(selectedCondition) == "true") {
			alert(v3x.getMessage('DocLang.search_already_selected'));
			return false;
		}
		
		var selectedOp, selectedIndex;
		for(var k=0; k<allCondtions.options.length; k++) {
	        if(allCondtions.options[k].selected){
	            selectedOp = allCondtions.options[k];
	            selectedIndex = k;
	            break;
	        }
	    }
		<%-- 如果各行均已填充满，则添加新查询属性时需添加新的行，列。关联查询页面较小，2列，文档中心页面较大，3列  --%>
		var total = isQuote ? 2 : 3;
		var needCreateTr = conditionTotal % total ==0;
		var tableC = document.getElementById("showConditionTable");
		var oTr, oTd1, oTd2;
		if(needCreateTr) {
			oTr = document.createElement('tr');
			
			oTd1 = document.createElement('td');
			oTd1.setAttribute('width', isQuote ? '20%' : '11%');
			oTd1.setAttribute('align', 'right');
			
			oTd2 = document.createElement('td');
			oTd2.setAttribute('width', isQuote ? '30%' : '22%');
			oTd2.setAttribute('align', 'left');

			oTr.appendChild(oTd1);
			oTr.appendChild(oTd2);

			for(var i=0; i<(total - 1); i++) {
				add2Columns(oTr);
			}
			
			tableC.appendChild(oTr);
		}else {
		    var nowTr =null;
			for(var i=tableC.childNodes.length-1; i>-1; i--){
		      if(tableC.childNodes[i].nodeType == 1){
			      nowTr = tableC.childNodes[i];
			      break;
			  }
			}
			var indexNum = (conditionTotal % total);
			if(indexNum == 1) {
				oTd1 = tsnode(3,nowTr);
				oTd2 = tsnode(4,nowTr);
	        }else {
				oTd1 = tsnode(5,nowTr);
				oTd2 = tsnode(6,nowTr);
	        }
		}
		var oText1 = document.createTextNode(selectedOp.innerText + ":");
		oTd1.appendChild(oText1);
			
		var values = selectedCondition.split('|');
		var propName = values[0];
		var propType = values[1];
		var propDefault = values[2];
		var propId = values[3];

		var hiddenObj1 = document.createElement('input');
		hiddenObj1.setAttribute('type', 'hidden');
		hiddenObj1.setAttribute('name', 'propertyNameAndType');
		hiddenObj1.setAttribute('id', 'propertyNameAndType');
		hiddenObj1.setAttribute('value', propName + "|" + propType);

		var hiddenObj2 = document.createElement('input');
		hiddenObj2.setAttribute('type', 'hidden');
		hiddenObj2.setAttribute('name', propName + "IsDefault");
		hiddenObj2.setAttribute('id', propName + "IsDefault");
		hiddenObj2.setAttribute('value', propDefault);

		oTd2.appendChild(hiddenObj1);
		oTd2.appendChild(hiddenObj2);
		
		<%-- 日期(时间) --%>
		if(propType == '4' || propType == '5') {
			var obj1 = document.createElement('input');
			obj1.setAttribute('type', 'text');
			obj1.setAttribute('name', propName + "beginTime");
			obj1.setAttribute('id', propName + "beginTime2");
			obj1.className= 'input-date';
			obj1.readOnly = true;
			
			obj1.onpropertychange = function() {
				setDate('startdate', propName + 'beginTime2', propName + 'endTime2');
			};
	
			obj1.onclick = function() {
				whenstart('${pageContext.request.contextPath}', this, 575, 140);
			};
			
			var obj2 = document.createElement('input');
			obj2.setAttribute('type', 'text');
			obj2.setAttribute('name', propName + "endTime");
			obj2.setAttribute('id', propName + "endTime2");
			obj2.className = 'input-date';
			obj2.readOnly = true;
			
			obj2.onpropertychange = function() {
				setDate('enddate', propName + 'beginTime2', propName + 'endTime2');
			};
			
			obj2.onclick = function() {
				whenstart('${pageContext.request.contextPath}', this, 675, 140);
			};

			var oSep = document.createTextNode(" ");
			oTd2.appendChild(obj1);
			oTd2.appendChild(oSep);
			oTd2.appendChild(obj2);
		}
		<%-- 文档类型  --%>
		else if(propType == '10') {
			var obj = document.createElement('select');
			obj.setAttribute('name', propName + 'Value');
			obj.setAttribute('id', propName);
			obj.style.width = '120px';

			obj.options.add(new Option("<fmt:message key='doc.please.select' />", ""));
			<c:forEach items="${types}" var="t">
				obj.options.add(new Option("${v3x:toHTML(v3x:_(pageContext, t.name))}", "${t.id}"));
			</c:forEach>
			
			oTd2.appendChild(obj);
		}
		<%-- 部门  --%>
		else if(propType == '9'){
			var obj1 = document.createElement('input');
			obj1.setAttribute('type', 'text');
			obj1.setAttribute('name', propName + "ASName");
			obj1.setAttribute('id', propName + "ASName");
			obj1.className = 'textfield';
			obj1.setAttribute('maxlength', '100');
			obj1.readOnly = true;

			obj1.onclick = function() {
				eval("selectPeopleFun_" + propName + "AS('" + propName + "', '" + propName + "ASName');");
			};
			
			var obj2 = document.createElement('input');
			obj2.setAttribute('type', 'hidden');
			obj2.setAttribute('name', propName);
			obj2.setAttribute('id', propName);
			
			oTd2.appendChild(obj1);
			oTd2.appendChild(obj2);
		}
		<%-- 枚举(公文种类129、行文类型130、文件密级133、紧急程度134其实也应当是枚举类型，但之前是作为文本类型保存，兼容老数据处理) --%>
		else if(propType == '13' || propId == '129' || propId == '130' || propId == '133' || propId == '134') {
			var obj = document.createElement('span');
			var requestCaller = new XMLHttpRequestCaller(this, "metadataDefManager", "getEnumOptionHtml", false);
			requestCaller.addParameter(1, "Long", propId);
			var ret = requestCaller.serviceRequest();
			
			obj.innerHTML = "<select name='" + propName + "' id='" + propName + "' style='width:120px;'><option value=''><fmt:message key='doc.please.select' /></option>" + ret + "</select>";
			oTd2.appendChild(obj);
		}
		<%-- 布尔类型  --%>
		else if(propType == '7') {
			var obj = document.createElement('select');
			obj.setAttribute('name', propName);
			obj.setAttribute('id', propName);
			obj.style.width = '80px';
			obj.options.add(new Option("<fmt:message key='doc.please.select' />", ""));
			obj.options.add(new Option("<fmt:message key='common.yes' bundle='${v3xCommonI18N}'/>", "true"));
			obj.options.add(new Option("<fmt:message key='common.no' bundle='${v3xCommonI18N}'/>", "false"));
			
			oTd2.appendChild(obj);
		}
		<%-- 文本 (其他类型) --%>
		else {
			var obj = document.createElement('input');
			obj.setAttribute('type', 'text');
			obj.setAttribute('name', propName);
			obj.setAttribute('id', propName);
			obj.className = 'textfield';
			obj.onkeydown = function() {
				docAdvancedSearchEnter();
			};
			
			oTd2.appendChild(obj);
		}

		selectedConditionMap.put(selectedCondition, "true");
		conditionTotal += 1;
		allCondtions.options.remove(selectedIndex);
	}
	<%-- 为新的行增加两列，一列用于展现属性名称，一列用于展现输入框或下拉列表框等 --%>
	function add2Columns(trElem) {
		var oTdi1 = document.createElement('td');
		oTdi1.setAttribute('width', isQuote ? '20%' : '11%');
		oTdi1.setAttribute('align', 'right');
		
		var oTdi2 = document.createElement('td');
		oTdi2.setAttribute('width', isQuote ? '30%' : '22%');
		oTdi2.setAttribute('align', 'left');
		
		trElem.appendChild(oTdi1);
		trElem.appendChild(oTdi2);
	}
	<%-- 取childenode兼容性修改 --%>
	function tsnode(nws,nowTr){
		var nw=0;
		for(var i=0; i<nowTr.childNodes.length; i++){
          if(nowTr.childNodes[i].nodeType == 1){
            nw++;
          }
          if(nw==nws){
            return nowTr.childNodes[i];
          }
       }
   }
</script>
<div id="advancedSearch" style="width:100%;display:none;">
<form name="advancedSearchForm" id="advancedSearchForm" method="post" target="dataIFrame" onsubmit="return false" style="margin: 0px" target="_self">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td  width="100%" valign="top" height="60">
	    <table width="100%" height="60" border="0" cellpadding="0" cellspacing="0" >
		  <tr>
		  	<td align="center" valign="top" style="padding: 5px;">
				<div class="portal-layout-cell ">		  	
					<div class="portal-layout-cell_head">
						<div class="portal-layout-cell_head_l"></div>
						<div class="portal-layout-cell_head_r"></div>
					</div>
				
					<table border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right">
						<tr>
							<td class="sectionTitleLine sectionTitleLineBackground">
								<div class="sectionSingleTitleLine">
									<div class="sectionTitleLeft"></div>
									<div class="sectionTitleMiddel">
										<div class="sectionTitleDiv">
											<span class="sectionTitle" style="padding-left:10;padding-right:10;"><fmt:message key='common.search.condition.label' bundle="${v3xCommonI18N}"/></span>
											<select name="addCondition" id="addCondition" onchange="addCondtion4Search()" style="width:240px;height:22px;" >
												<option value="-1"><fmt:message key="doc.search.add.condition" /></option>
												<c:forEach items="${miscConditions}" var="sc">
													<c:if test="${sc.type == 8 || sc.type == 9}">
														<c:set var="selectTypeO" value="${sc.type == 8 ? 'Member' : 'Department'}" />
														<c:set var="panelsO" value="${sc.type == 8 ? 'Department,Team' : 'Department'}" />
														<v3x:selectPeople id="${sc.physicalName}AS" panels="${panelsO}" selectType="${selectTypeO}" departmentId="${currentUser.departmentId}" 
														jsFunction="setDocSearchPeopleFields('${sc.physicalName}', elements)" minSize="0" maxSize="1" showAllAccount="${param.docLibType == 5}"  />
														<script type="text/javascript">
															onlyLoginAccount_${sc.physicalName}AS = "${param.docLibType != 5}";
														</script>
													</c:if>
													<option value="${sc.physicalName}|${sc.type}|${sc.isDefault}|${sc.id}" title="${v3x:toHTML(sc.showName)}">
														${sc.showName}
													</option>
												</c:forEach>
											</select>
										</div>
									</div>
								</div>
							</td>
							</tr>
							<tr>
								<td class="sectionBodyBorder" align="center">
								<table width="100%">
									<tr>
										<td height="80px">
											<div class="scrollList">
												<table width="100%">
													<tbody id="showConditionTable" name="showConditionTable">
														<tr>
														<c:set value="0" var="loop"/>
														<c:set value="${param.isQuote eq 'true' ? 2 : 3}" var="total" />
														<c:forEach items="${searchConditions}" var="sc" varStatus="status">
															<td width="11%" align="right">${sc.showName} :</td>
															<td width="22%" align="left">
																<input type="hidden" name="propertyNameAndType" id="propertyNameAndType" value="${sc.physicalName}|${sc.type}" />
																<input type="hidden" name="${sc.physicalName}IsDefault" id="${sc.physicalName}IsDefault" value="${sc.isDefault}" />
																<c:choose>
																<%-- 日期(时间) --%>
																<c:when test="${sc.type == 4 || sc.type == 5}">
																	<input type="text" name="${sc.physicalName}beginTime" id="${sc.physicalName}beginTime2" class="input-date" onpropertychange="setDate('startdate', '${sc.physicalName}beginTime2', '${sc.physicalName}endTime2')" onclick="whenstart('${pageContext.request.contextPath}', this,575,140);" readonly >
																	<input type="text" name="${sc.physicalName}endTime" id="${sc.physicalName}endTime2" class="input-date" onpropertychange="setDate('enddate', '${sc.physicalName}beginTime2', '${sc.physicalName}endTime2')" onclick="whenstart('${pageContext.request.contextPath}', this, 675, 140);" readonly >
																</c:when>
																<%-- 文件类型 --%>
																<c:when test="${sc.type == 10}">
																	<select name="${sc.physicalName}" id="${sc.physicalName}" style="width:120px;height:22px;" >
																		<option value=""><fmt:message key="doc.please.select" /></option>
																		<c:forEach items="${types}" var="t">
																			<option value="${t.id}" title="${v3x:toHTML(v3x:_(pageContext, t.name))}">
																				<c:set var="tempV" value="${v3x:getLimitLengthString(v3x:_(pageContext, t.name), 15,'...')}" />
																				${v3x:toHTML(tempV)}
																			</option>
																		</c:forEach>
																	</select>
																</c:when>
																<%-- 用户类型 --%>
																<c:when test="${sc.type == 9}">
																	<c:set var="selectType" value="${sc.type == 8 ? 'Member' : 'Department'}" />
																	<c:set var="panels" value="${sc.type == 8 ? 'Department,Team' : 'Department'}" />
																	<%-- 注意将此处选人界面ID参数与单个处区分，否则简单查询时选人值无法显示在输入框内，加上标识AS(Advanced Search) --%>
																	<v3x:selectPeople id="${sc.physicalName}AS" panels="${panels}" selectType="${selectType}" departmentId="${currentUser.departmentId}" 
																			jsFunction="setDocSearchPeopleFields('${sc.physicalName}', elements, true)" minSize="0" maxSize="1" showAllAccount="${param.docLibType == 5}"  />
																	<script type="text/javascript">
																		onlyLoginAccount_${sc.physicalName}AS = "${param.docLibType != 5}";
																	</script>
																	<input type="text" name="${sc.physicalName}ASName" id="${sc.physicalName}ASName" onclick="selectPeopleFun_${sc.physicalName}AS('${sc.physicalName}', '${sc.physicalName}ASName')" 
																		class="textfield" maxlength="100" readonly>
																	<input type="hidden" name="${sc.physicalName}" id="${sc.physicalName}">
																</c:when>
																<%-- 枚举类型 --%>
																<c:when test="${sc.type == 13}">
																	<select name="${sc.physicalName}" id="${sc.physicalName}" style="width:120px;" >
																		<%-- 老数据的对应字段为空，此处加上一个空值作为此栏目出现前的兼容 --%>
																		<option value=""><fmt:message key="doc.please.select" /></option>
																		<c:forEach items="${sc.metadataOption}" var="op">
																			<option value="${op.id}" title="${v3x:toHTML(op.optionItem)}">${v3x:toHTML(op.optionItem)}</option>
																		</c:forEach>
																	</select>
																</c:when>
                                                                <%-- 公文枚举 --%>
                                                                <c:when test="${sc.type == 14}">
                                                                    <c:set var="valueEl" value="${sc.physicalName}" />
                                                                    <select name="${sc.physicalName}" id="${sc.physicalName}" style="width:120px;height:22px;" >
                                                                      <c:forEach items="${sc.metadataOption}" var="op">
                                                                        <option value="${op.id}" ${op.id eq param[valueEl]?selectedEl:''} title="${v3x:toHTML(op.optionItem)}">${v3x:toHTML(op.optionItem)}</option>
                                                                      </c:forEach>
                                                                    </select>
                                                                </c:when>
																<%-- 布尔类型 --%>
																<c:when test="${sc.type == 7}">
																	<select name="${sc.physicalName}" id="${sc.physicalName}" style="width:80px;height:22px;" >
																		<%-- 老数据的对应字段为空，此处加上一个空值作为此栏目出现前的兼容 --%>
																		<option value=""><fmt:message key="doc.please.select" /></option>
																		<option value="true"><fmt:message key='common.yes' bundle="${v3xCommonI18N}"/></option>
																		<option value="false"><fmt:message key='common.no' bundle="${v3xCommonI18N}"/></option>
																	</select>
																</c:when>
																<%-- 文本类型 --%>
																<c:otherwise>
																	<c:choose>
																		<%-- 公文种类129、行文类型130、文件密级133、紧急程度134 --%>
																		<c:when test="${sc.id == 129 || sc.id == 130 || sc.id == 133 || sc.id == 134}">
																			<select name="${sc.physicalName}" id="${sc.physicalName}" style="width:120px;height:22px;" >
																				<option value=""><fmt:message key="doc.please.select" /></option>
																				<v3x:metadataItem metadata="${sc.metadata}" showType="option" name="${sc.physicalName}Meta" />
																			</select>
																		</c:when>
																		<c:otherwise>
																			<input type="text" name="${sc.physicalName}" id="${sc.physicalName}" onkeydown="docAdvancedSearchEnter()" class="textfield" maxLength='20' />
																		</c:otherwise>
																	</c:choose>
																</c:otherwise>
																</c:choose>
															</td>
															<c:set value="${loop + 1}" var="loop"/>
    														<c:if test="${loop % total == 0}">
        														</tr>
        														<tr>
    														</c:if>
														</c:forEach>
                                                    <!-- 补齐空格的样式 -->
													<c:if test="${loop % total != 0}">
														<c:forEach begin="1" end="${total - loop%total}">
															<td width="11%" align="right"></td>
															<td width="22%" align="left"></td>
														</c:forEach>
                                                        </tr>
													</c:if>
													</tbody>
												</table>
											</div>
										</td>
									</tr>
								</table>
								<table width="100%">
									<tr>
										<td align="center">
										</td>
									</tr>
									<tr>
										<td nowrap="nowrap" align="center">
											<c:set value="${param.isQuote eq 'true' ? 'docQuoteAdvancedSearch()' : 'docAdvancedSearch()'}" var="action" />
											<input type="button" class="button-default_emphasize" onclick="${action}" name="advancedSearchButton" id="advancedSearchButton" value="<fmt:message key='common.button.condition.search.label' bundle="${v3xCommonI18N}" />">&nbsp;
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<div class="portal-layout-cell_footer">
						<div class="portal-layout-cell_footer_l"></div>
						<div class="portal-layout-cell_footer_r"></div>
					</div>
				</div>  	
			</td>
		  </tr>
	    </table>
    </td>
  </tr>
</table>
</form>
</div>