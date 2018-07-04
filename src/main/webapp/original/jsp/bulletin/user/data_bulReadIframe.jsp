<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<html style='overflow:hidden;'>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<style>
	#normal2{
		width:110px;
		width:114px\9;
		max-width:120px;
		text-align:center;
		text-overflow:clip;
	}
	#normal2>a{display: inline-block;}
	#borrow2{
		width:110px;
		width:114px\9;
		max-width:120px;
		text-align:center;
		text-overflow:clip;
	}
	#borrow2>a{display: inline-block;}
	.tab-tag{background: #fafafa;border-bottom:none;}
	.non-a{font-size:12px;color:#666;}
	select{
		border:1px solid #dae3ea;
		border-radius:3px;
		width:190px;
		height:24px;
		color:#666;
		margin-left:8px;
		float:right;
		margin-right:20px;
	}
	#deptSwitch{color:#666;line-height:24px;overflow:hidden;}
	#remind{
	 	min-width:0;
	 	height:25px;
	 	line-height:25px;
	 	line-height:16px\9;
	 	font-size:12px;
	 	color:#666;
	 	margin:6px 0 6px 20px;
	 	border:1px solid #e0e0e0;
	 	background:#fff;
	 	border-radius: 5px;
	 	-webkit-border-radius: 5px;
	 	-o-border-radius: 5px;
	 }
	 .tab-body-bg-bull{background:#fafafa;}
</style>
</head>
<script type="text/javascript">
	function changeType(deptId){
 		var _url = '${bulDataURL}?method=bulReadIframe&beanId=${beanId}&deptId='+deptId;
 		parent.myframe.window.location.href = _url;
 	}
	function doChangeMenu(sign){
		if(sign=="normal"){
			docPropertyIframe.window.location.href = "${bulDataURL}?method=bulReadProperty&deptId=${deptId}&beanId=${beanId}&mode=normal";
			document.getElementById("remind").style.display = "none";
			document.getElementById('docPropertyIframe').style.height = '315px';
			document.getElementById('docPropertyIframe').contentWindow.document.getElementById('scrollList1').style.height = '318px';

		}else if(sign == "borrow"){
			docPropertyIframe.window.location.href = "${bulDataURL}?method=bulReadProperty&deptId=${deptId}&beanId=${beanId}&mode=borrow";
			document.getElementById("remind").style.display = "block";
			document.getElementById('docPropertyIframe').style.height = '280px';
		}
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

		}
//		for(var i=0;i<array.length;i++){
//			var o=docPropertyIframe.document.getElementById(array[i]+"TR");
//			if(o!=null&&o!="undefined"){
//				if(array[i] == sign){
//					if( o.style.display == "none"){
//						 o.style.display = "";
//					}else{
//						continue;
//					}
//				}else{
//					o.style.display="none";
//				}
//			}
//		}
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
		<td id='td_setWidth' valign="bottom" height="26" class="tab-tag" width="300" style='padding-left:20px;'>
			<div class="div-float">
				<div class="tab-separator"></div>
				<div class="tab-tag-left-sel" id="normal1"></div>
				<div class="tab-tag-middel-sel" id="normal2">
					<a  class="non-a" onclick="doChangeMenu('normal');">
						<fmt:message key="bul.datareadIframe.endReadName" />
						(<span id="endRead" title="${brc.endReadCount}">${brc.endReadCount}</span>)
					</a>
				</div>
				<div class="tab-tag-right-sel" id="normal3" ></div>				
				
				<div class="tab-separator"></div>
				<div class="tab-tag-left" id="borrow1" style="width:130px;"></div>
				<div class="tab-tag-middel" id="borrow2">
					<a class="non-a" onclick="doChangeMenu('borrow');">
					<fmt:message key="bul.datareadIframe.notReadName" />
					(<span id="notRead" title="${brc.notReadCount}">${brc.notReadCount}</span>)
					</a>
				</div>
				<div class="tab-separator"></div>
				<div class="tab-tag-left" id="borrow3"></div>
				<div class="tab-tag-middel" id="borrow4" style='min-width: 0px;display:none;'>
                </div>	
			</div>
		</td>
		
		<td align="right" class="tab-tag" style="text-align:left;">
			<div id="deptSwitch" style="white-space:nowrap;">
				<select onchange="changeType(this.value)">
					<c:forEach items="${bulreadcountAll}" var="bulType">
						<option value="${bulType.deptId}" title="${v3x:toHTML(v3x:showOrgEntitiesOfIds(bulType.deptId, 'Department', pageContext))}"  ${v3x:outConditionExpression(bulType.deptId==param.deptId, 'selected', '')}>
							${v3x:toHTML(v3x:getLimitLengthString(v3x:showOrgEntitiesOfIds(bulType.deptId, 'Department', pageContext),30,"..."))}
						</option>
					</c:forEach>
				</select>
				<span style="float:right;"><fmt:message key="bul.deptSwitch" /><fmt:message key="label.colon" /></span><!-- 部门切换 -->
			</div>
		</td>
	</tr>
	
	<tr>
		<td class="tab-body-bg-bull" colspan="2">
			<span id='line' style='display:block;height:1px;border-top:1px solid #7dc1fd;margin:0 20px;background:#fafafa;'></span>
			<c:if test="${param.fromPigeonhole==true }">
                	<input id="remind" name="remind" class="button-default-2 button-default-2-long" style="display: none;" onclick="fnRemind()" disabled = "disabled" type="button" value="<fmt:message key='bul.remind.lable'/>"/>
                </c:if>
                <c:if test="${param.fromPigeonhole!=true }">
                    <input id="remind" name="remind" class="button-default-2 button-default-2-long" style="display: none;" onclick="fnRemind()" type="button" value="<fmt:message key='bul.remind.lable'/>"/>
                </c:if>
			<iframe  name="docPropertyIframe" id="docPropertyIframe" frameborder="0"height="315px" width="100%" scrolling="no" marginheight="0" marginwidth="0"></iframe>
			<script type="text/javascript">
				docPropertyIframe.window.location.href = "${bulDataURL}?method=bulReadProperty&deptId=${deptId}&beanId=${beanId}&mode=normal";
			</script>
		</td>
	</tr>
	
	<tr>
		<td height="42" align="right" class="bg-advance-bottom" colspan="2">
			<input	type="button" value="<fmt:message key='common.button.close.label' bundle="${v3xCommonI18N}" />" class="button-default-2" onclick="getA8Top().articleDetailWin.close();">
		</td>
	</tr>
</table>
<script type="text/javascript">
	var iframe = document.getElementById('docPropertyIframe');
	iframe.width = '577px';
	iframe.style.padding = '0 20px 0 20px';
	iframe.style.background = '#fafafa';

	var userAgent = navigator.userAgent;
	if(userAgent.indexOf('MSIE 8.0')>-1){
		var iframe = document.getElementById('docPropertyIframe');
		iframe.style.padding = '0';
		iframe.style.marginLeft = '20px';
		document.getElementById('td_setWidth').style.widht = '340px';
		document.getElementById('line').style.display = 'none';
	}
</script>
</body>
</html>