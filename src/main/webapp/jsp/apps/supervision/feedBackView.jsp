<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma" contect="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<link rel="stylesheet" href="${path}/apps_res/supervision/css/feedBackView.css">
<script type="text/javascript" src="${path}/apps_res/supervision/js/supervisionPage.js"></script>
<title>查看反馈</title>
</head>
<body>
   <div class="xl_box" style="padding-left:10px;padding-bottom:0px;">
   		<table class="xl_table">
   		<colgroup>
   			<col width="20%"/>
   			<col width="80%"/>
   		</colgroup>
   			<tbody>
   				<tr>
   					<td align="right"><div>目标路线：</div></td>
   					<td>
   						<div>
   							<c:if test="${param.from=='plan'}">
   								<textarea class="xl_road" readonly="readonly">${feedback.field0139 }</textarea>
   							</c:if>
   							<c:if test="${param.from!='plan'}">
   								<textarea class="xl_road" readonly="readonly">${feedback.field0097 }</textarea>
   							</c:if>
   						</div>
   					</td>
   				</tr>
   				<tr>
   					<td align="right"><div>计划时间段：</div></td>
   					<td>
   						<c:if test="${param.from=='plan'}">
   							<c:if test="${feedback.field0138==''}">
								<c:set var="field0138" value="--"/>
							</c:if>
	   						<c:if test="${feedback.field0138!=''}">
	   							<c:set var="field0138" value="${feedback.field0138 }"/>
	   						</c:if>
	   						<c:if test="${feedback.field0142==''}">
								<c:set var="field0142" value="--"/>
							</c:if>
	   						<c:if test="${feedback.field0142!=''}">
	   							<c:set var="field0142" value="${feedback.field0142 }"/>
	   						</c:if>
	   						<c:if test="${feedback.field0142!=''||feedback.field0138!=''}">
	   							<input type="text" class="xl_period" readonly="readonly" style="font-size:14px;" value="${field0138 }至${field0142}">
	   						</c:if>
	   						<c:if test="${feedback.field0142==''&& feedback.field0138==''}">
	   							<input type="text" class="xl_period" readonly="readonly">
	   						</c:if>
   						</c:if>
   						<c:if test="${param.from!='plan'}">
	   						<c:if test="${feedback.field0092==''}">
								<c:set var="field0092" value="--"/>
							</c:if>
	   						<c:if test="${feedback.field0092!=''}">
	   							<c:set var="field0092" value="${feedback.field0092 }"/>
	   						</c:if>
	   						<c:if test="${feedback.field0130==''}">
								<c:set var="field0130" value="--"/>
							</c:if>
	   						<c:if test="${feedback.field0130!=''}">
	   							<c:set var="field0130" value="${feedback.field0130 }"/>
	   						</c:if>
	   						<c:if test="${feedback.field0092!=''||feedback.field0130!=''}">
	   							<input type="text" class="xl_period" readonly="readonly" style="font-size:14px;" value="${field0092 }至${field0130}">
	   						</c:if>
	   						<c:if test="${feedback.field0092==''&& feedback.field0130==''}">
	   							<input type="text" class="xl_period" readonly="readonly">
	   						</c:if>
   						</c:if>
   					</td>
   				</tr>
   				<tr>
   					<td align="right"><div>反馈单位：</div></td>
   					<td>
   						<div>
   							<c:if test="${param.from=='plan'}">
   								<textarea class="xl_unit" readonly="readonly">${feedback.field0140}</textarea>
   							</c:if>
   							<c:if test="${param.from!='plan'}">
   								<textarea class="xl_unit" readonly="readonly">${feedback.field0072}</textarea>
   							</c:if>
   						</div>
   					</td>
   				</tr>
   				<c:if test="${param.from!='plan'}">
   				<tr>
   					<td align="right"><div>完成率：</div></td>
   					<td>
   						<span class="progressbar_1">
   							<span class="bar" style="width:${feedback.field0074*100}%"></span>
   						</span>
   						&nbsp;
   						<span class="xl_num"><fmt:formatNumber type='number' maxFractionDigits="0" value='${feedback.field0074*100}'/>%</span>
   					</td>
   				</tr>
   				<tr>
   					<td align="right"><div>完成情况：</div></td>
   					<td>
   						<div>
   							<textarea class="xl_completion" readonly="readonly">${feedback.field0073 }</textarea>
   						</div>
   					</td>
   				</tr>
   				</c:if>
   				<tr>
   					<td align="right"><div>附件：</div></td>
   					<td>
   						<div class="xl_content">
   							<c:if test="${param.from!='plan'}">
								<c:forEach items="${feedback.attachmentAtts}" var="attachment">
									<span id="field0076_span" class="edit_class"
											fieldVal='{name:"field0076",isMasterFiled:"false",displayName:"DR4附件",fieldType:"VARCHAR",inputType:"attachment",formatType:"",value:"${attachment.subReference}"}'>
											<div class="comp"
												comp="type:'fileupload',hasSaved:false,canFavourite:false,callMethod:'fileValueChangeCallBack',delCallMethod:'fileDelCallBack',takeOver:false,isBR:true,canDeleteOriginalAtts:false,notNull:'false',displayMode:'visible',autoHeight:true,applicationCategory:'2',embedInput:'field0076',attachmentTrId:'${attachment.subReference}'"
												attsdata='[{"type":"${attachment.type}","size":"${attachment.size}","description":"${attachment.description}","icon":"${attachment.icon}","extension":"${attachment.extension }","reference":"${attachment.reference}","createdate":"${attachment.createdate}","mimeType":"${attachment.mimeType}","category":${attachment.category},"subReference":"${attachment.subReference}","filename":"${attachment.filename}","fileUrl":"${attachment.fileUrl}","sort":${attachment.sort},"v":"${attachment.v}","genesisId":"${attachment.genesisId}","officeTransformEnable":"${attachment.officeTransformEnable}","id":"${attachment.id}","new":false,"extraMap":{}}]'></div>
										</span>
								</c:forEach>
							</c:if>
							<c:if test="${param.from=='plan'}">
								<c:forEach items="${feedback.attachmentAtts}" var="attachment">
									<span id="field0144_span" class="edit_class"
											fieldVal='{name:"field0144",isMasterFiled:"false",displayName:"DR4附件",fieldType:"VARCHAR",inputType:"attachment",formatType:"",value:"${attachment.subReference}"}'>
											<div class="comp"
												comp="type:'fileupload',hasSaved:false,canFavourite:false,callMethod:'fileValueChangeCallBack',delCallMethod:'fileDelCallBack',takeOver:false,isBR:true,canDeleteOriginalAtts:false,notNull:'false',displayMode:'visible',autoHeight:true,applicationCategory:'2',embedInput:'field0144',attachmentTrId:'${attachment.subReference}'"
												attsdata='[{"type":"${attachment.type}","size":"${attachment.size}","description":"${attachment.description}","icon":"${attachment.icon}","extension":"${attachment.extension }","reference":"${attachment.reference}","createdate":"${attachment.createdate}","mimeType":"${attachment.mimeType}","category":${attachment.category},"subReference":"${attachment.subReference}","filename":"${attachment.filename}","fileUrl":"${attachment.fileUrl}","sort":${attachment.sort},"v":"${attachment.v}","genesisId":"${attachment.genesisId}","officeTransformEnable":"${attachment.officeTransformEnable}","id":"${attachment.id}","new":false,"extraMap":{}}]'></div>
										</span>
								</c:forEach>
							</c:if>
							</div>
   					</td>
   				</tr>
   				<tr>
   					<td align="right"><div>关联文档：</div></td>
   					<td>
   						<div class="xl_content">
   						<c:if test="${param.from!='plan'}">
   							<c:forEach items="${feedback.relateDocAtts}" var="relateDoc">
									<div id="field0077_span" class="edit_class"
									fieldVal='{name:"field0077",isMasterFiled:"false",displayName:"关联文档",fieldType:"VARCHAR",inputType:"document",formatType:"",value:"${relateDoc.subReference}"}'>
									<div class="comp clearfix"
										comp="type:'assdoc',isBR:true,callMethod:'assdocValueChangeCallBack',canDeleteOriginalAtts:false,delCallMethod:'assdocDelCallBack',notNull:'false',displayMode:'visible',attachmentTrId:'${relateDoc.subReference}', modids:'1,3',embedInput:'field0077'"
										attsdata='[{"type":${relateDoc.type},"size":"${relateDoc.size}","description":"${relateDoc.description}","icon":"${relateDoc.icon}","extension":"","reference":"${relateDoc.reference}","createdate":"${relateDoc.createdate}","mimeType":"${relateDoc.mimeType}","category":${relateDoc.category},"subReference":"${relateDoc.subReference}","filename":"${relateDoc.filename}","fileUrl":"${relateDoc.fileUrl}","sort":${relateDoc.sort},"v":"","genesisId":"${relateDoc.genesisId}","officeTransformEnable":"${relateDoc.officeTransformEnable}","id":"${relateDoc.id}","new":false,"extraMap":{}}]'></div>
								</div>
								</c:forEach>
						</c:if>
						<!-- xl 7-6修改 -->
						<c:if test="${param.from=='plan'}">
   							<c:forEach items="${feedback.relateDocAtts}" var="relateDoc">
									<div id="field0145_span" class="edit_class"
									fieldVal='{name:"field0145",isMasterFiled:"false",displayName:"关联文档",fieldType:"VARCHAR",inputType:"document",formatType:"",value:"${relateDoc.subReference}"}'>
									<div class="comp"
										comp="type:'assdoc',isBR:true,callMethod:'assdocValueChangeCallBack',canDeleteOriginalAtts:false,delCallMethod:'assdocDelCallBack',notNull:'false',displayMode:'visible',attachmentTrId:'${relateDoc.subReference}', modids:'1,3',embedInput:'field0145'"
										attsdata='[{"type":${relateDoc.type},"size":"${relateDoc.size}","description":"${relateDoc.description}","icon":"${relateDoc.icon}","extension":"","reference":"${relateDoc.reference}","createdate":"${relateDoc.createdate}","mimeType":"${relateDoc.mimeType}","category":${relateDoc.category},"subReference":"${relateDoc.subReference}","filename":"${relateDoc.filename}","fileUrl":"${relateDoc.fileUrl}","sort":${relateDoc.sort},"v":"","genesisId":"${relateDoc.genesisId}","officeTransformEnable":"${relateDoc.officeTransformEnable}","id":"${relateDoc.id}","new":false,"extraMap":{}}]'></div>
								</div>
							</c:forEach>
						</c:if>
   						</div>
   					</td>
   				</tr>
   				<tr>
   					<td colspan="2">
   						<input type="button" class="xl_btn" value="关闭" onclick="_closeWin()">
   					</td>
   				</tr>
   			</tbody>
   		</table>
   </div>
</body>
</html>