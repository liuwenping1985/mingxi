<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../edocHeader.jsp" %>
<html>
	<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/src/StringBuffer.js${v3x:resSuffix()}" />"></script>
	<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}" />"></script>
	<link rel="stylesheet" type="text/css" href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />" >
	<link rel="stylesheet" type="text/css" href="<c:url value="/common/SelectPeople/css/css.css${v3x:resSuffix()}" />" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/common/SelectPeople/tree/xtree.css${v3x:resSuffix()}" />" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/common/jquery/themes/default/easyui.css${v3x:resSuffix()}" />" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/common/jquery/themes/icon.css${v3x:resSuffix()}" />" />
	<head>
		<title><fmt:message key="selectPeople.page.title"  bundle="${v3xMainI18N}"/></title>
		<script type="text/javascript">
		    // 主题词树
			var tree;
			
			// 主题词列表框是否是最大化
			var area1Status = false;

			/**
			 * 初始化主题词树结构
			 */
		  	function initTree(){
			  	tree = new WebFXTree("root", "<fmt:message key = 'menu.edoc.keyword.label' />","javascript:clearList2()");
				tree.setBehavior('classic');
				tree.icon = "<c:url value='/common/images/left/icon/5101.gif'/>";
				tree.openIcon = "<c:url value='/common/images/left/icon/5101.gif'/>";
				
				<c:forEach items="${treeList}" var="keyword">
					<c:choose>
						<%-- 后台排序上一定要先一级再二级 --%>
						<c:when test="${keyword.parentId == null || keyword.parentId == 0}">
							var node${fn:replace(keyword.id,'-','_')} = new WebFXTreeItem("${keyword.id}","${v3x:toHTML(keyword.name)}","javascript:showListByType('${keyword.id}');");
							node${fn:replace(keyword.id,'-','_')}.icon = "<c:url value='/common/images/left/icon/1201.gif'/>";
							node${fn:replace(keyword.id,'-','_')}.openIcon = "<c:url value='/common/images/left/icon/1201.gif'/>";
							
							tree.add(node${fn:replace(keyword.id,'-','_')});
						</c:when>
						<c:when test="${keyword.levelNum == 2}">
							try{
								var node${fn:replace(keyword.id,'-','_')} = new WebFXTreeItem("${keyword.id}","${v3x:toHTML(keyword.name)}","javascript:showListByType('${keyword.id}');");
								node${fn:replace(keyword.id,'-','_')}.icon = "<c:url value='/common/images/left/icon/5104.gif'/>";
								node${fn:replace(keyword.id,'-','_')}.openIcon = "<c:url value='/common/images/left/icon/5104.gif'/>";
								
								if(typeof(node${fn:replace(keyword.parentId,'-','_')}) != "undefined") {
									node${fn:replace(keyword.parentId,'-','_')}.add(node${fn:replace(keyword.id,'-','_')});
								}
							}catch(e){}
						</c:when>
						<c:otherwise>
						</c:otherwise>
					</c:choose>
				</c:forEach>

			  	document.getElementById("Area1").innerHTML = "<div id='List1' style='width:251px; height:160px; overflow:auto;'>" + tree + "</div>";
			  	webFXTreeHandler.select(tree);
			}

			function clearList2(){
				document.getElementById("List2").innerHTML="";
			}

			/**
			 * 点击树的节点后，显示该节点下面的主题词列表
			 */
			function showListByType(parentId){
				var selectHTML = new StringBuffer();
				selectHTML.append("<select id='List2' ondblclick='selectOne()' multiple='multiple' style='width: 251px;height: 195px;' size='17'>");

				<c:forEach items="${subList}" var="keyword">
					var aa = ${keyword.parentId};
					if(aa == parentId){
						selectHTML.append("<option title=\"${v3x:toHTML(keyword.name)}\" value=\"${keyword.id}\">${v3x:toHTML(keyword.name)}</option>");
					}
				</c:forEach>
				selectHTML.append("</select>");
				document.getElementById("Area2").innerHTML = selectHTML.toString();
			}

			/**
			 * 点击右键头选择主题词
			 */
			function selectOne(){
				var s2  = document.getElementById("List2");
				var s3  = document.getElementById("List3");

				for(var i = 0; i < s2.length; i++) {
					var item2 = s2.item(i);
					if(item2.selected){
						var isExist = false;
						for(var j = 0; j < s3.length; j++) {
							var item3 = s3.item(j);
							if(item2.value == item3.value){
								isExist = true;
								break;
							}
						}
						if(!isExist){
							var o = new Option(item2.text, item2.value);
							s3.options.add(o);
						}
					}
				}
			}

			/**
			 * 点击左键头删除已选择的主题词
			 */
			function removeOne(){
				var s1  = document.getElementById("List3");
				for(var i = 0; i < s1.length; i++) {
					var item = s1.item(i);
					if(item.selected){
						s1.removeChild(s1.options[i]);
						i--;
					}
				}
			}

			/**
			 * 上移或下移已经选择了的数据
			 */
			function moveItem(direction){
				var list3Object = document.getElementById("List3");
				var list3Items = list3Object.options;
				var nowIndex = list3Object.selectedIndex;
				if(direction == "up"){
					if(nowIndex > 0){
						var nowOption = list3Items[nowIndex];
						var nextOption = list3Items[nowIndex - 1];
						
						var textTemp = nextOption.text;
						var valueTemp = nextOption.value;
						
						nextOption.text = nowOption.text;
						nextOption.value = nowOption.value;
						
						nowOption.text = textTemp;
						nowOption.value = valueTemp;

						list3Items[nowIndex-1].selected = true;
						list3Items[nowIndex].selected = false;

					}
				}else if(direction == "down"){
					if(nowIndex > -1 && nowIndex < list3Items.length - 1){
						var nowOption = list3Items[nowIndex];
						var nextOption = list3Items[nowIndex + 1];
						
						var textTemp = nextOption.text;
						var valueTemp = nextOption.value;
						
						nextOption.text = nowOption.text;
						nextOption.value = nowOption.value;
						
						nowOption.text = textTemp;
						nowOption.value = valueTemp;

						list3Items[nowIndex + 1].selected = true;
						list3Items[nowIndex].selected = false;
					}
				} else{
					log.warn('The direction ' + direction + ' is not defined.');
				}
			}

			/**
			 * 搜索主题词
			 */
			function searchItems(){
				var searchValue = document.getElementById("q").value;
				var selectHTML = new StringBuffer();
				selectHTML.append("<select id='List2' ondblclick='selectOne()' multiple='multiple' style='width: 251px;' size='17'>");
				<c:forEach items="${subList}" var="keyword">
					var name = "${v3x:toHTML(keyword.name)}";
					var parentId = "${keyword.parentId}";
					if(name.indexOf(searchValue) != -1 && parentId != 0){
						selectHTML.append("<option title=\"${v3x:toHTML(keyword.name)}\" value=\"${keyword.id}\">${v3x:toHTML(keyword.name)}</option>");
					}
				</c:forEach>
				selectHTML.append("</select>");
				document.getElementById("Area2").innerHTML = selectHTML.toString();
			}

			/**
			 * 点击确定后，选回已选择的主题词字符串
			 */
			function selected(){
				var result = new StringBuffer();
				var s3  = document.getElementById("List3");
				if(s3.length!=0){
					for(var i = 0; i < s3.length; i++) {
						if(i == 0){
							result.append(s3.item(i).text);
						}else{
							result.append(" ").append(s3.item(i).text);
						}
					}
				}else{
					result.append("");
				}
				
				transParams.parentWin.openSelectKeywordWinCallback(result.toString());
				transParams.parentWin.openSelectKeywordDialog.close()
			}

			/**
			 * 最大化主题词显示列表
			 */
			function hiddenArea1(){
				if(area1Status){
					document.getElementById("Separator1").style.display = "";
					document.getElementById("Area1").style.display = "";
					document.getElementById("Area1").style.height = 160;
					document.getElementById("Area2").style.height = 174;
					document.getElementById("List2").size = 17;
					area1Status = false;
				} else{
					document.getElementById("Separator1").style.display = "none";
					document.getElementById("Area1").style.display = "none";
					document.getElementById("Area1").style.height = 0;
					document.getElementById("Area2").style.height = 390;
					document.getElementById("List2").size = 33;
					area1Status = true;
				}
			}

			/**
			 * 显示上级树结构
			 */
			function showParentTree(){
				if(area1Status){
					hiddenArea1();
				}
				
				if(tree == null){
					return;
				}
					
				var nowExpandNode = tree.getSelected();
				
				var parentNode = nowExpandNode.parentNode;
				
				if(nowExpandNode == null ||  parentNode== null){
					return;
				}
				if(parentNode.businessId != "root"){
					webFXTreeHandler.toggle(document.getElementById(parentNode.id));
					showListByType(parentNode.businessId);
				}else{
					clearList2();
				}
				parentNode.select();
			}
		</script>
	</head>
	<body scroll="no" style="overflow: hidden" onload="initTree()">
		<table id="selectPeopleTable" width="100%" height="100%" border="0" class="bg-body" align="center" cellpadding="0" cellspacing="0">
			<tr valign="top">
				<td align="center" class="padding6">
					<table width="595" border="0" style="height: 100%" cellpadding="0" cellspacing="0">
						<tr>
							<td class="border-BDC3C3">
								<div class="scrollList h100b">
									<table width="100%" border="0" height="100%" cellspacing="0" cellpadding="0" class="bg-panel gov_nobackground">
										<tr valign="top">
											<td class="padding7-10">
												<table class="h100b" border="0" cellspacing="0" width="100%" cellpadding="0">
													<tr>
														<td valign="top" height="22px">
															<table border="0" cellspacing="0" cellpadding="0">
																<tr>
																	<!--显示上级 -->
																	<td class="td-left-5">
																		<table border="0" cellspacing="0" cellpadding="0">
																			<tr>
																				<td class="cursor-hand" id="button1" onclick="showParentTree()" title="<fmt:message key='selectPeople.showparent.title' bundle="${v3xMainI18N}"/>"><img height=14 src="<c:url value="/common/SelectPeople/images/xs.gif"/>" width=15 align=absMiddle></td>
																			</tr>
																		</table>
																	</td>
																	<!--最大化显示 -->
																	<td class="td-left-5">
																		<table border="0" cellspacing="0" cellpadding="0">
																			<tr>
																				<td class="cursor-hand" id="button2" onclick="hiddenArea1()" title="<fmt:message key='selectKeyword.hidden.tree' bundle="${v3xMainI18N}"/>"><img src="<c:url value="/common/SelectPeople/images/hb.gif"/>" width="16" height="16" align="absmiddle"></td>
																			</tr>
																		</table>
																	</td>
																	<!--搜索关键字 -->
																	<td align="right" class="td-left-5" nowrap="nowrap">
																		<span id="searchArea">
																			<input onkeypress="if(event.keyCode == 13) searchItems()" id="q" type="text" value="" maxlength="10" /><img src="<c:url value="/common/SelectPeople/images/search_button_rest.gif"/>" border="0" align="absmiddle" class="cursor-hand" height="18" onclick="searchItems()" />
																		</span>
																	</td>
																</tr>
															</table>
														</td>
														<td width="30" colspan="3">&nbsp;</td>
													</tr>
													<tr>
														<td width="251" valign="top">
															<table width="100%" border="0" cellspacing="0" cellpadding="0">
																<!--树型结构 -->
																<tr onselectstart="return false" valign="top">
																	<td id="Area1" class="iframe"></td>
																</tr>
																<!--中间说明 -->
																<tr>
																	<td height="26" id="Separator1" valign="middle">
																	</td>
																</tr>
																<tr onselectstart="return false">
																	<!-- 关键字列表 -->
																	<td id="Area2" valign="top">
																		<select id="List2" multiple="multiple" style="width: 251px;height: 195px;" size="17"></select>
																	</td>
																</tr>
															</table>
														</td>
														<td width="35" align="center">
														 	<!-- 右移图标 -->
															<p><img src="<c:url value="/common/SelectPeople/images/arrow_a.gif"/>" alt='<fmt:message key="selectPeople.alt.select" bundle="${v3xMainI18N}"/>' width="24" height="24" class="cursor-hand" onclick="selectOne()"></p>
															<br />
															 <!-- 左移图标 -->
															<p><img src="<c:url value="/common/SelectPeople/images/arrow_del.gif"/>" alt='<fmt:message key="selectPeople.alt.unselect" bundle="${v3xMainI18N}"/>' width="24" height=24 class="cursor-hand" onclick="removeOne()"></p>
														</td>
														<td width="251" valign="top" id="Area3">
														    <!-- 已选框 -->
															<select id="List3" onclick="" ondblclick="removeOne()" multiple="multiple" style="width: 251px;height:381px" size="40"></select>
														</td>
														<td width="30" align="center">
															<!-- 上移图标 -->
															<p><img src="<c:url value="/common/SelectPeople/images/arrow_u.gif"/>" alt='<fmt:message key="selectPeople.alt.up" bundle="${v3xMainI18N}"/>' width="24" height="24" class="cursor-hand" onclick="moveItem('up')"></p>
															<br />
															<!-- 下移图标 -->
															<p><img src="<c:url value="/common/SelectPeople/images/arrow_d.gif"/>" alt='<fmt:message key="selectPeople.alt.down" bundle="${v3xMainI18N}"/>' width="24" height="24" class="cursor-hand" onclick="moveItem('down')"></p>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td height="30" class="bg-button-select">
					<input name="Submit" type="button" onClick="selected()" class="button-default_emphasize" value='<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}" />'>
					<input name="close" type="button" onclick="transParams.parentWin.openSelectKeywordDialog.close()" class="button-default-2" value='<fmt:message key="common.button.cancel.label" bundle="${v3xCommonI18N}" />'>
				</td>
			</tr>
		</table>
	</body>
</html>