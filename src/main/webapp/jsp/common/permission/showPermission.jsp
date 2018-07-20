<%--
 $Author:  翟锋$
 $Rev: 1697 $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<!DOCTYPE html>
<html class="h100b over_hidden" id='permisEdit' style='display: block;'>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>节点范围选择</title>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=permissionManager"></script>
<script type="text/javascript">
	var selectedPeopleElements = new Properties();
	function OK() {
		var idArr = new Array();
		var nameArr = new Array();
		$("#List3 option").each(function(){
			idArr.push($(this).val());
			nameArr.push($(this).attr('title'));
		});
		return {"id":idArr.join(","),"name":nameArr.join(",")};
	}
	//上移或下移已经选择了的数据
	function exchangeList3Item(direction){
		var list3Object = document.getElementById("List3");
		var list3Items = list3Object.options;
		var nowIndex = list3Object.selectedIndex;
		//ipad div实现select
		if(!v3x.getBrowserFlag('selectPeopleShowType')){
	    	list3Items = list3Object.childNodes;
	    	for(var i = 0;i<list3Items.length;i++){
	    		var op = list3Items[i];
	    		var selected = op.getAttribute('seleted');
	    		if(selected == 'true'){
	    			nowIndex = i;
	    		}
	    	}
		}

		if(direction == "up"){
			if(nowIndex > 0){
				if(v3x.getBrowserFlag('selectPeopleShowType')){
					var nowOption = list3Items.item(nowIndex);
					var nextOption = list3Items.item(nowIndex - 1);
					
					//多浏览器处理
					var textTemp = nowOption.innerHTML;
					var valueTemp = nowOption.getAttribute('value');
					
					var textTemp2 = nextOption.innerHTML;
					var valueTemp2 = nextOption.getAttribute('value');
					
					nowOption.innerHTML = textTemp2;
					nowOption.setAttribute('value',valueTemp2);
					
					nextOption.innerHTML = textTemp;
					nextOption.setAttribute('value',valueTemp);
					list3Object.selectedIndex = nowIndex - 1;
					selectedPeopleElements.swap(nowOption.value, nextOption.value);
				}else{
					var nowOption = list3Items[nowIndex];
					var nextOption = list3Items[nowIndex - 1];
					
					var textTemp = nextOption.innerHTML;
					var valueTemp = nextOption.getAttribute('value');
					
					nextOption.innerHTML = nowOption.innerHTML;
					nextOption.setAttribute('value',nowOption.getAttribute('value'));
					
					nowOption.innerHTML = textTemp;
					nowOption.setAttribute('value',valueTemp);
					nowOption.setAttribute('seleted','false');
					nowOption.setAttribute('class','member-list-div');
					
					nextOption.setAttribute('seleted','true');
					nextOption.setAttribute('class','member-list-div-select');
					
					selectedPeopleElements.swap(nowOption.getAttribute('value'), nextOption.getAttribute('value'));
				}

			}
		}
		else if(direction == "down"){
			if(nowIndex > -1 && nowIndex < list3Items.length - 1){
				if(v3x.getBrowserFlag('selectPeopleShowType')){
					var nowOption = list3Items.item(nowIndex);
					var nextOption = list3Items.item(nowIndex + 1);
					//多浏览器处理
					var textTemp = nowOption.innerHTML;
					var valueTemp = nowOption.getAttribute('value');
					
					var textTemp2 = nextOption.innerHTML;
					var valueTemp2 = nextOption.getAttribute('value');
					
					nowOption.innerHTML = textTemp2;
					nowOption.setAttribute('value',valueTemp2);
					
					nextOption.innerHTML = textTemp;
					nextOption.setAttribute('value',valueTemp);
					list3Object.selectedIndex = nowIndex + 1;
					
					selectedPeopleElements.swap(nowOption.value, nextOption.value);
				}else{
					var nowOption = list3Items[nowIndex];
					var nextOption = list3Items[nowIndex + 1];
					
					var textTemp = nextOption.innerHTML;
					var valueTemp = nextOption.getAttribute('value');
					
					nextOption.innerHTML = nowOption.innerHTML;
					nextOption.setAttribute('value',nowOption.getAttribute('value'));
					
					nowOption.innerHTML = textTemp;
					nowOption.setAttribute('value',valueTemp);
					nowOption.setAttribute('seleted','false');
					nowOption.setAttribute('class','member-list-div');
					
					nextOption.setAttribute('seleted','true');
					nextOption.setAttribute('class','member-list-div-select');
					
					selectedPeopleElements.swap(nowOption.getAttribute('value'), nextOption.getAttribute('value'));
				}
			}
		}
		else{
			log.warn('The direction ' + direction + ' is not defined.');
		}
	}
	function selectOne(){
		$("#memberDataBodyOrginal option:selected").each(function(){
			$("#List3").append($(this));
		});
		
	}
	function removeOne(){
		$("#List3 option:selected").each(function(){
			$("#memberDataBodyOrginal").append($(this));
		});
	}
</script>
</head>
<body class="h100b over_hidden">
	<table border="0" width="100%" height="100%" cellspacing="0"
		cellpadding="0">
		<tr >
			<td height="20" colspan="4"></td>
		</tr>
		<tr>
			<td width="301" valign="top">
			<select id="memberDataBodyOrginal" ondblclick="selectOne()" multiple="multiple" style="width:301px;height: 426px;" size="28" >
				<c:forEach var="permission" items="${permissions }" >
					<option value="${permission.flowPermId }" title="${permission.label }">${permission.label }</option>
				</c:forEach>
			</select>
			</td>
			<td width="35" align="center">
				<p>
					<span class="select_selected"
						title='${ctp:i18n("selectPeople.alt.select")}'
						onclick="selectOne()"></span>
				</p> <br />
				<p>
					<span class="select_unselect"
						title='${ctp:i18n("selectPeople.alt.unselect")}'
						onclick="removeOne()"></span>
				</p>
			</td>
			<td width="301" style="height: 406px;" valign="top">
				<select id="List3" onclick=""
						ondblclick="removeOne(this.value, this)" multiple="multiple"
							style="padding-top: 1px; height: 426px; width: 301px;" size="28">
				<c:forEach var="permission" items="${selectPermissions }" >
					<option value="${permission.flowPermId }" title="${permission.label }">${permission.label }</option>
				</c:forEach>
				</select>
			</td>
			<td width="30" align="center">
				<p>
					<span class="sort_up" title='${ctp:i18n("selectPeople.alt.up")}'
						onclick="exchangeList3Item('up')"></span>
				</p> <br />
				<p>
					<span class="sort_down"
						title='${ctp:i18n("selectPeople.alt.down")}'
						onclick="exchangeList3Item('down')"></span>
				</p>
			</td>
		</tr>
	</table>
	</td>
	</tr>
	</table>
</body>
</html>
