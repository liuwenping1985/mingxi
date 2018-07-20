<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html style="height: 100%;overflow: hidden;">
<head>
<title><fmt:message key="bul.userView.CallInfo" /></title>
<%@ include file="../include/header.jsp"%>
<style>
 .mxtgrid div.hDivBox{padding-right:0;}
</style>
<script type="text/javascript">

<%-- 点击阅读信息的部门弹出链接 --%>
function articleDetail(deptId,readedNum,notReadNum){
	getA8Top().articleDetailWin = v3x.openDialog({
        title:'<fmt:message key="bul.userView.CallInfo" />',
        transParams:{'parentWin':window},
        url: '${bulDataURL}?method=bulReadView&deptId='+deptId+'&beanId=${param.id}'+'&fromPigeonhole=${param.fromPigeonhole}',
        width: 600,
        height: 450,
        isDrag:false
    });
}

function exportBulReadInfo(id){
		var url = "${bulDataURL}?method=exportReadInfo&bulId="+id;
	    exportIFrame.location.href = url;
}
//父页面
var i18nRemindSuccess = '<fmt:message key="bul.remind.success"/>',i18nRemindSelect = '<fmt:message key="bul.remind.please.select.dept"/>';
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/bulletin/js/bulRemind.js${v3x:resSuffix()}" />"></script>
</head>
<body scroll="no" style="height: 100%;overflow: hidden;">
<table width="100%"  height="100%" align="center" border="0" cellspacing="0" cellpadding="0" id="listReadTable2">
	<tr>
		<td width="100%" class="body-bgcolor" valign="top" align="center">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="body-detail" align="center">
				<tr valign="top" >
					<td class="body-detail-border" width="100%">
						<div class="body-detail-su" style="padding:6px 12px 0px 12px;" >
							<fmt:message key="bul.read" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<fmt:message key="label.read" />${bulendread}<fmt:message key="bul.member" />
							<c:if test="${param.fromPigeonhole!=true}">
                                <input id="remind" name="remind" class="button-default-2 button-default-2-long" onclick="fnRemind('${param.id}')" type="button" value="<fmt:message key='bul.remind.lable'/>"/>
                            </c:if>
							<div style="width: 80px; height: 20px;border:1px solid #333;border-radius:5px;float:right;cursor:pointer;" onclick="exportBulReadInfo('${param.id}')" >
								<div style="float: left;margin-left:5px;padding-top:3px;">
									<img width="16" height="16" style="background-position: -112px -16px;background-image: url('/seeyon/common/skin/default/images/xmenu/toolbar.trip.png');"/>
								</div>
								<div style="float: right;margin-right:10px;padding-top:4px;">
									<span><fmt:message key="bulletin.export.readInfo.all" /></span>
								</div>
								<div style="clear:both;"></div>
							</div>
						</div>
						<div class="body-detail-su" style="padding:6px 12px 0px 12px;" >
							<v3x:table htmlId="listTable" data="bulreadcount" var="beanread" showPager="false" className="sort body-detail-table">
								<c:if test="${beanread.deptId!=null}">
									<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='fnSelectAll(this, \"id\",window)'/>">
										<input type='checkbox' name='id' value="${beanread.deptId}"/>
										<input type="hidden" name='type' value="Department"/>
									</v3x:column>			
									<v3x:column type="String" label="bul.type.spaceType.1" className="sort font-12px" width="30%">
										<a class="font-12px" onclick="articleDetail('${beanread.deptId}','${beanread.endReadCount}','${beanread.notReadCount}');">${v3x:toHTML(v3x:showOrgEntitiesOfIds(beanread.deptId, 'Department', pageContext))} </a>	
									</v3x:column>						
								</c:if>
								<c:if test="${beanread.accountId!=null}">
									<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='fnSelectAll(this, \"id\")'/>">
										<input type='checkbox' name='id' value="${beanread.accountId}"/>
										<input type='hidden' name='type' value="Account"/>
									</v3x:column>			
									<v3x:column type="String" label="bul.type.spaceType.2" className="sort font-12px" value="${v3x:toHTML(v3x:showOrgEntitiesOfIds(beanread.accountId, 'Account', pageContext))}" width="30%"/> 							
								</c:if>
								<v3x:column type="String" label="bul.dataview.alreadyCall" className="sort font-12px" value="${beanread.endReadCount}" width="30%"/> 
								<v3x:column type="String" label="bul.dataview.notCall" className="sort font-12px" value="${beanread.notReadCount}" width="26%"/> 
							</v3x:table>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class="body-bgcolor" valign="top" height="5">&nbsp;</td></tr>
</table>
 <iframe width="0" height="0" name="exportIFrame" id="exportIFrame"></iframe>
</body>
<script type="text/javascript">
	var oldHeight = parent.window.document.getElementById("showReadDiv").style.height;
	parent.window.document.getElementById("showReadDiv").style.height = "0px";
	parent.window.document.getElementById("showReadDiv").style.height = oldHeight;
</script>
</html>