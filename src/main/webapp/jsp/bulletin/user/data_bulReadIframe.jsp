<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<script type="text/javascript">
	function changeType(deptId){
 		var _url = '${bulDataURL}?method=bulReadIframe&beanId=${beanId}&deptId='+deptId;
 		parent.myframe.window.location.href = _url;
 	}
	function doChangeMenu(sign){
		var array=new Array("normal","borrow");
		for(var j=0;j<array.length;j++){
			if(array[j] == sign){
				document.getElementById(array[j]+1).className="tab-tag-left-sel";
				document.getElementById(array[j]+2).className="tab-tag-middel-sel";
				document.getElementById(array[j]+3).className="tab-tag-right-sel";
			}else{
				var theDocument=document.getElementById(array[j]+1);
				if(theDocument == null){
					continue;
				}else {					
					document.getElementById(array[j]+1).className="tab-tag-left";
					document.getElementById(array[j]+2).className="tab-tag-middel";
					document.getElementById(array[j]+3).className="tab-tag-right";
				}
		   }
			
			if(sign == "borrow"){
				document.getElementById("remind").style.display = "block";
			}else{
				document.getElementById("remind").style.display = "none";
			}
		}
		for(var i=0;i<array.length;i++){
			var o=docPropertyIframe.document.getElementById(array[i]+"TR");
			if(o!=null&&o!="undefined"){
				if(array[i] == sign){
					if( o.style.display == "none"){
						 o.style.display = "";
					}else{
						continue;
					}
				}else{
					o.style.display="none";
				}
			}
		}
	}
	
	//子页面弹出框架页
	function fnRemind(){
		docPropertyIframe.fnRemind('${param.beanId}');
	}
</script>
<body scroll="no" onkeydown="listenerKeyESC()" class="tab-body">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="overflow:hidden;">
<c:set var="isExtend" value="${extandexit}"/>
	<tr>
		<td valign="bottom" height="26" class="tab-tag" width="350px">
			<div class="div-float">
				<div class="tab-separator"></div>
				<div class="tab-tag-left-sel" id="normal1"></div>
				<div class="tab-tag-middel-sel" id="normal2" >
					<a  class="non-a" onclick="doChangeMenu('normal');">
						<fmt:message key="bul.datareadIframe.endReadName" />
						（<span id="endRead">${brc.endReadCount}</span>）
					</a>
				</div>
				<div class="tab-tag-right-sel" id="normal3" ></div>				
				
				<div class="tab-separator"></div>
				<div class="tab-tag-left" id="borrow1" style="width:130px;"></div>
				<div class="tab-tag-middel" id="borrow2" style="width:130px;" >
					<a class="non-a" onclick="doChangeMenu('borrow');">
					<fmt:message key="bul.datareadIframe.notReadName" />
					（<span id="notRead">${brc.notReadCount}</span>）
					</a>
				</div>
				<div class="tab-separator"></div>
				<div class="tab-tag-left" id="borrow3"></div>
				<div class="tab-tag-middel" id="borrow3" >
                <c:if test="${param.fromPigeonhole==true }">
                	<input id="remind" name="remind" class="button-default-2 button-default-2-long" style="display: none;" onclick="fnRemind()" disabled = "disabled" type="button" value="<fmt:message key='bul.remind.lable'/>"/>
                </c:if>
                <c:if test="${param.fromPigeonhole!=true }">
                    <input id="remind" name="remind" class="button-default-2 button-default-2-long" style="display: none;" onclick="fnRemind()" type="button" value="<fmt:message key='bul.remind.lable'/>"/>
                </c:if>
                </div>	
			</div>
		</td>
		
		<td align="right" class="tab-tag" style="text-align:left;">
			<c:if test="${spaceType!=2 }">
			<div id="deptSwitch" style="white-space:nowrap;">
				<span style="float:left;"><fmt:message key="bul.deptSwitch" /><fmt:message key="label.colon" /></span><!-- 部门切换 -->
					<select onchange="changeType(this.value)" style="width:170px;">
						<c:forEach items="${bulreadcount}" var="bulType">
							<option value="${bulType.deptId}" ${v3x:outConditionExpression(bulType.deptId==param.deptId, 'selected', '')}>
								${v3x:getLimitLengthString(v3x:toHTML(v3x:showOrgEntitiesOfIds(bulType.deptId, 'Department', pageContext)),30,"...")}
							</option>
						</c:forEach>
					</select>
			</div>
			</c:if>
		</td>
	</tr>
	
	<tr>
		<td class="tab-body-bg-bull" colspan="2">
			<iframe  name="docPropertyIframe" id="docPropertyIframe" frameborder="0"height="340px" width="100%" scrolling="no" marginheight="0" marginwidth="0"></iframe>
			<script type="text/javascript">
				docPropertyIframe.window.location.href = "${bulDataURL}?method=bulReadProperty&deptId=${deptId}&beanId=${beanId}";
			</script>
		</td>
	</tr>
	
	<tr>
		<td height="42" align="right" class="bg-advance-bottom" colspan="2">
			<input	type="button" value="<fmt:message key='common.button.close.label' bundle="${v3xCommonI18N}" />" class="button-default-2" onclick="getA8Top().articleDetailWin.close();">
		</td>
	</tr>
</table>
</body>
</html>