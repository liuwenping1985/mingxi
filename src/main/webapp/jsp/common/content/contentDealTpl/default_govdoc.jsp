<%--
 $Author: muj $
 $Rev: 5599 $
 $Date:: 2013-03-28 18:46:48#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<c:set value="${summaryVO.affair.state eq 3 and param.openFrom eq 'listPending'}" var ="hasDealArea" />
<script type="text/javascript" src="${path}/ajax.do?managerName=colManager,govdocExchangeManager,edocManager,govdocTemplateDepAuthManager,wpsTransManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/deal_govdoc.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/office/js/hw.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var _praisedealCa ="${ctp:i18n('collaboration.summary.label.praisecancel')}";
var _praisedeal ="${ctp:i18n('collaboration.summary.label.praise')}";
var distributePage;
var canEditOpinion = "${ctp:containInCollection(basicActionList, 'Opinion')}";
function showRelatedFile(){
	$("#relatedFileView").css("overflow","visible");
	$("#relatedFileView").height($("#commentIframe").height()-2);
	$("#commentIframe").hide();
	$("#relatedFileView").show();
	$("#circulation_view_li").removeClass("current");
	$("#relatedFile_view_li").addClass("current");
}
function showCirculationRecord(){
	$("#relatedFileView").hide();
	$("#commentIframe").show();
	$("#relatedFile_view_li").removeClass("current");
	$("#circulation_view_li").addClass("current");
}
function showDistributeState(summaryId,status){
	var url1 = "/seeyon/collaboration/collaboration.do?method=showDistributeState&summaryId=" + summaryId;
	if(status){
		url1="/seeyon/collaboration/collaboration.do?method=showDistributeState&exchangeStatus="+status+"&summaryId=" + summaryId;
	}
	var dialog = $.dialog({
        url : url1,
        width : 1000,
        height : 400,
        title : '分送状态',
        targetWindow:getCtpTop(),
        buttons : [{
            text : $.i18n('collaboration.button.close.label'),
            handler : function() {
              dialog.close();
            }
        }]
    });
}
function insertAtt_callBack(a,b){
	showRelatedFile();
}

</script>

<style>
.common_drop_list .common_drop_list_content a.nodePerm,.nodePerm {
	display: none;
}
.back_disable_color{
	cursor: default; 
  	color: #000; 
    opacity: 0.2; 
  	-moz-opacity: 0.2; 
  	-khtml-opacity: 0.2; 
  	filter: alpha(opacity=20); 
}
.common_toolbar_box { background:#F0F6F8;}
.toolbar_l a { border:solid 1px #F0F6F8;}
.seperate {
	width:1px;
	display:inline-block;
	background:#c0c5c6;
	height:12px;
	vertical-align:middle;
	
}
.newgovdoc_att_td{
	padding:4px;
	width:60px;
	text-align:right;
	vertical-align:top;
}
.newgovdoc_table tr td{
}
</style>
<!--xl 7-1 如果是新公文页面 -->
<c:if test="${newGovdocView ==1}">
	<style>
		.xl_padding_t_5{
			padding-top:5px;
		}
		#_dealDiv div{
			margin-top:2px;
		}
		.hr_heng{
			margin-top:5px;
		}
		/*xl 7-5*/
		.opinions{
			padding-top:5px;
			/*margin-bottom:20px;*/
		}
		.xl_p_b_45{
			margin-bottom:40px;
		}
		/*xl 7-6解决 ie10下相关文件页面问题样式*/
		.xl_w100{
			width:100%;
		}
	</style>
</c:if>
<!-- xl 7-5设置下内边距为40px     隱藏div的橫向滾動條 -->
<div id="dealAreaThisRihgt" class="deal_area padding_lr_10 padding_b_10 clearfix form_area" 
<c:if test="${newGovdocView==1 }"> style="height:100%;padding-bottom:0px;overflow-x:hidden;overflow-y:auto;<c:if test="${hasDealArea!='true' }">height:95%;</c:if>" </c:if>

>
 <c:if test="${newGovdocView==1}">
 <div class="common_tabs common_tabs_big clearfix margin_t_5 padding_l_5">
	<ul class="left margin_l_4">
    	<!-- 流转记录 -->
    	<li id="circulation_view_li" class="current" ><a onclick="showCirculationRecord()">${ctp:i18n('govdoc.form.circulationRecord')}</a></li>
		<!-- 相关文件 -->
		<li id="relatedFile_view_li" ><a onclick="showRelatedFile()">${ctp:i18n('govdoc.form.relatedFile')}</a></li>
	</ul>
 </div>
<iframe id="commentIframe" name="commentIframe" width="100%"  <c:choose><c:when test="${hasDealArea!='true' }"> height="100%" </c:when><c:otherwise> height="235px"</c:otherwise>   </c:choose> frameborder="0" 
  src='${path }/collaboration/collaboration.do?method=newCommentPage&templateId=${summaryVO.summary.templeteId}&affairId=${summaryVO.affairId}&formAppid=${summaryVO.summary.formAppid }&rightId=${rightId}&canFavorite=${canFavorite}&isHasPraise=${isHasPraise}&readonly=${summaryVO.readOnly}&openFrom=${summaryVO.openFrom}&isHistoryFlag=${isHistoryFlag}&isGovArchive=${param.isGovArchive}&trackType=${param.trackTypeRecord}${securityCheckParam}&contentContext=${contentContext }&r=<%=Math.random()%>'></iframe>
 <!-- xl 7-6 取消默认滚动条的出现 --><!-- xl 7-6 解决 ie10下相关文件页面问题-->
 <div id="relatedFileView" class="clearfix xl_w100" style="height:0px;overflow-y:auto;padding-top:5px">
 	<table  border="0" cellspacing="0" cellpadding="0" width="100%" class="newgovdoc_table">
 		
 		<c:if test="${canEditAtt}">
	 		<tr>
	 			<td style="line-height:2" colspan="2">
	 				<span id="uploadAttachmentTR">
					<a onclick="updateAtt('sender')">${ctp:i18n('collaboration.summary.updateAtt')}</a></span>
	 			</td>
	 		</tr>
			
		</c:if>
 		<tr>
 			<td class="newgovdoc_att_td">正式附件：</td>
			<td>
				<!-- 附件 -->
	            <div id="attachmentTRshowAttFile" style="display: none;">
	            	<div style="float:left;padding-top:5px;margin-left:0px;"><span class="ico16 affix_16"></span>(<span id="attachmentNumberDivshowAttFile"></span>)</div>
	            	<div id="attFileDomain" isGrid="true" class="comp" comp="type:'fileupload',newGovdocView:1,attachmentTrId:'showAttFile',canFavourite:${canFavorite},applicationCategory:'1',canDeleteOriginalAtts:false" attsdata='${attListJSON }'> </div>
	        	</div>
	        	<!-- 关联文档 -->
	        	<div id="attachment2TRDoc1" style="display: none;">
                     <div style="float:left;padding-top:5px;margin-left:0px;"><span class="ico16 associated_document_16"></span>(<span id="attachment2NumberDivDoc1"></span>)</div>
                    <div style="float: right;" id="assDocDomain" isCrid="true" class="comp" comp="type:'assdoc',newGovdocView:1,attachmentTrId:'Doc1',applicationCategory:'1',displayMode:'auto',modids:1,canDeleteOriginalAtts:false" attsdata='${attListJSON }'></div>
                </div>
	        </td>
 			
 		</tr>
 		</table>
 		<div class="hr_heng margin_t_10 margin_b_5">&nbsp;</div>
 		<table  border="0" cellspacing="0" cellpadding="0" width="100%" class="newgovdoc_table">
 		<tr>
 			<td class="newgovdoc_att_td">流转附件：</td>
 			<td>
 				<div id="attachmentTRATT" style="display: none;">
	 				<div style="float:left;padding-top:5px;margin-left:0px;"><span class="ico16 affix_16"></span>(<span id="attachmentNumberDivATT"></span>)</div>
		            <div  isGrid="true" class="comp" comp="type:'fileupload',newGovdocView:1,attachmentTrId:'ATT',canFavourite:${canFavorite},applicationCategory:'4',canDeleteOriginalAtts:false,autoHeight:true" attsdata='${commentShowAttrstr}'> </div>
		        </div>
		        <!-- 关联文档 -->
	        	<div id="attachment2TRATT" style="display: none;">
                     <div style="float:left;padding-top:5px;margin-left:0px;"><span class="ico16 associated_document_16"></span>(<span id="attachment2NumberDivATT"></span>)</div>
                    <div  style="float: right;" isCrid="true" class="comp" comp="type:'assdoc',newGovdocView:1,attachmentTrId:'ATT',applicationCategory:'4',displayMode:'auto',modids:1,canDeleteOriginalAtts:false" attsdata='${commentShowAttrstr }'></div>
                </div>
                <div id="uploadLiuzhuanFile">
	 			<div id="attachmentTR${commentId }" style="display: none;">
	 				<div style="float:left;padding-top:5px;margin-left:0px;"><span class="ico16 affix_16"></span>(<span id="attachmentNumberDiv${commentId }"></span>)</div>
		            <div id="content_deal_attach" isGrid="true" class="comp" comp="type:'fileupload',callMethod:'insertAtt_callBack',takeOver:'false',newGovdocView:1,attachmentTrId:'${commentId }',canFavourite:${canFavorite},applicationCategory:'4',canDeleteOriginalAtts:true,autoHeight:true" attsdata='${handleAttachJSON }' > </div>
		        </div>
		        <!-- 关联文档 -->
	        	<div id="attachment2TR${commentId }" style="display: none;">
                     <div style="float:left;padding-top:5px;margin-left:0px;"><span class="ico16 associated_document_16"></span>(<span id="attachment2NumberDiv${commentId }"></span>)</div>
                    <div  style="float: right;" id="content_deal_assdoc" isCrid="true" class="comp" comp="type:'assdoc',callMethod:'insertAtt_callBack',takeOver:'false',displayMode:'auto',newGovdocView:1,attachmentTrId:'${commentId }',applicationCategory:'4',modids:'1,3',canDeleteOriginalAtts:true" attsdata='${handleAttachJSON }'></div>
                </div>
                </div>
	        </td>
 		</tr>
 		</table>
 		<c:if test = "${summaryVO.summary.govdocType==1 }">
 		<c:if test="${govdocview_delivery!=0 }">
 		<div class="hr_heng margin_t_10 margin_b_5">&nbsp;</div>
 		<table  border="0" cellspacing="0" cellpadding="0" width="100%" class="newgovdoc_table">
 		<tr>
 			<td class="newgovdoc_att_td" style="vertical-align:top;">分送状态：</td>
 			<td style="line-height:2">
						<div>已分送
		 					<a <c:if test="${govdocview_delivery==0||isSender!=1}">disabled="true"</c:if> onclick="showDistributeState('${summaryVO.summary.id}')">${govdocview_delivery }</a>
		 				家</div>
		 				<div>待签收
		 					<a <c:if test="${govdocview_waitSign==0||isSender!=1}">disabled="true"</c:if> onclick="showDistributeState('${summaryVO.summary.id}',1)">${govdocview_waitSign }</a>
		 				家</div>
		 				<div>已回退
		 					<a <c:if test="${govdocview_hasBack==0||isSender!=1}">disabled="true"</c:if> onclick="showDistributeState('${summaryVO.summary.id}',10)">${govdocview_hasBack }</a>
		 				家</div>
 			</td>
 		</tr>
 		</table>
 		</c:if>
 		</c:if>
 		<c:if test='${sendRelation != null}'>
 		<div class="hr_heng margin_t_10 margin_b_5">&nbsp;</div>
 		<table  border="0" cellspacing="0" cellpadding="0" width="100%" class="newgovdoc_table">
 		<tr>
 			<td class="newgovdoc_att_td" style="vertical-align:top;">来文信息：</td>
 			<td><span class="hand left"  id="haveTurnSendEdoc1" onclick="showDetail('${sendRelation}');"><span class="ico16 view_log_16 margin_lr_5" ></span>${ctp:getLimitLengthString(exchangeRelationSubject,34,'...' )}</span>
 			</td>
 		</tr>
 		</table>
 		</c:if>
 		<c:if test='${exchangeRelationId != null}'>
 		<div class="hr_heng margin_t_10 margin_b_5">&nbsp;</div>
 		<table  border="0" cellspacing="0" cellpadding="0" width="100%" class="newgovdoc_table">
        <tr>
        	<td class="newgovdoc_att_td" style="vertical-align:top;">签收流程：</td>
 			<td>
        		<span class="hand" id="haveTurnSendEdoc1" onclick="showDetail('${exchangeRelationId}');"><span class="ico16 view_log_16 margin_lr_5" ></span>${ctp:getLimitLengthString(exchangeRelationSubject,34,'...' )}</span>
        	</td>
        </tr>
        </table>
       </c:if>
       <c:if test="${edocInnerMarkJB eq 'yes'}">
       <div class="hr_heng margin_t_10 margin_b_5">&nbsp;</div>
 		<table  border="0" cellspacing="0" cellpadding="0" width="100%" class="newgovdoc_table">
 		<tr>
 			<td class="newgovdoc_att_td" style="vertical-align:top;">见办流程：</td>
 			<td><input type="button" onclick="showGetSeriList('${curSeriNo}','${summaryVO.summary.id}')" value="见办文列表"/></td>
 		</tr>
 		</table>
 		</c:if>
 		<c:if test='${exchangeSendId != null && isFromSendPro!="1"}'>
 		<div class="hr_heng margin_t_10 margin_b_5">&nbsp;</div>
 		<table  border="0" cellspacing="0" cellpadding="0" width="100%" class="newgovdoc_table">
 			<tr>
	        	<td class="newgovdoc_att_td" style="vertical-align:top;">来文信息：</td>
	 			<td><span class="hand left" id="haveTurnSendEdoc1" onclick="showDetail('${exchangeSendId}');"><span class="ico16 view_log_16 margin_lr_5" ></span>${ctp:getLimitLengthString(exchangeSendSubject,34,'...' )}</span>
	 			</td>
	        </tr>
	    </table>
        </c:if>
            
 		<c:if test='${haveTurnSendEdoc1 != null}'><!-- 原收文流程 -->
 		<tr>
 			<td  style="line-height:2" colspan="2"><span class="hand left" id="haveTurnSendEdoc1" onclick="showDetail('${haveTurnSendEdoc1}');"><span class="ico16 view_log_16 margin_lr_5" ></span>${ctp:i18n('collaboration.sendGrid.oldRecEdoc')}</span></td>
 		</tr>
 		</c:if>
        <c:if test='${recRelation != null}'>
	        <tr>
	 			<td  style="line-height:2" colspan="2">
	 				<span class="hand left" id="haveTurnSendEdoc1" onclick="showExchangeSendEdocInfo()"><span class="ico16 view_log_16 margin_lr_5" ></span>${ctp:i18n('collaboration.sendGrid.recRelation')}</span>
				</td>
	 		</tr>
        </c:if>
        <c:if test='${exchangeRecId != null}'>
        <div class="hr_heng margin_t_10 margin_b_5">&nbsp;</div>
 		<table  border="0" cellspacing="0" cellpadding="0" width="100%" class="newgovdoc_table">
	        <tr>
	        	<td class="newgovdoc_att_td" style="vertical-align:top;">收文流程：</td>
	 			<td><span class="hand" id="haveTurnSendEdoc1" onclick="showDetail('${exchangeRecId}');"><span class="ico16 view_log_16 margin_lr_5" ></span>${ctp:getLimitLengthString(exchangeSendSubject,34,'...' )}</span>	
	 			</td>
	 		</tr>
	 	</table>
        </c:if>
 		
 		<c:if test='${haveTurnSendEdoc2 != null}'><!-- 转发文流程 -->
 		<tr>
 			<td style="line-height:2" colspan="2">
                <span class="hand left" onclick="showTurnSendEdocInfo()"><span class="ico16 view_log_16 margin_lr_5" ></span>${ctp:i18n('collaboration.sendGrid.turnSendEdoc')}</span>
            </td>
 		</tr>
 		</c:if>
 		<c:if test='${haveTurnRecEdoc != null}'> <!-- 转收文信息 -->
 		<tr>
 			<td style="line-height:2" colspan="2" >
        		<span class="hand left" id="details" onclick="showTurnRecEdocInfo('${haveTurnRecEdoc}')"><span class="ico16 view_log_16 margin_lr_5"></span>${ctp:i18n('collaboration.sendGrid.turnRecEdoc')}</span>
        	</td>
        </tr>
        </c:if>
        <c:if test='${haveTurnRecEdoc2 != null}'> <!-- 转收文信息 -->
        <tr>
 			<td style="line-height:2" colspan="2">
        	<span class="hand left" id="details2" onclick="showTurnRecEdocInfo2('${haveTurnRecEdoc2}')"><span class="ico16 view_log_16 margin_lr_5" ></span>${ctp:i18n('collaboration.sendGrid.turnRecEdoc')}</span>
        	</td>
        </tr>
        </c:if>
 	</table>
 </div>
  <div class="hr_heng margin_t_10">&nbsp;</div>
 </c:if>  
 <!-- xl 7-5 添加一个类名 -->               
<div class="xl_p_b_45" <c:if test="${newGovdocView==1&&hasDealArea!='true'}"> style="display:none"</c:if>>
	<div class="clearfix padding_t_15 xl_padding_t_5"><span class="left"><em
	id="hidden_side" class="ico16 arrow_2_r margin_r_5 left"></em><strong>${permissionName}</strong></span>
<c:if
	test="${summaryVO.summary.templeteId!=null and summaryVO.summary.templeteId!='' }">
	<%--添加调用模版时候的处理说明 --%>
	<!-- <a class="right" onclick="colShowNodeExplain()"><span
		class="ico16 handling_of_16"></span></a> -->
	<div id="nodeExplainDiv"
		style="display: none;background-color: #ffffff; height: 100px; width: 260px; z-index: 2; position: absolute; right: 30px; border: 1px solid #c7c7c7; text-align: left;"
		onMouseOut="">
        <div style="vertical-align: bottom;height:20px" align="right">
            <span  style="padding-right: 4px;"><a
                onClick="hiddenNodeIntroduction()">${ctp:i18n('permission.close')}<!-- 关闭 --></a></span>
        </div>
        <div style="overflow: auto;height: 80px">
        	<table onMouseOut="" style="width: 100%;">
        		<tr height="100%" style="vertical-align: top; line-height: 18px;">
        			<td id="nodeExplainTd" style='word-break:break-all'></td>
        		</tr>
        	</table>
        </div>   
	</div>
</c:if></div>
<div class="clearfix font_size12">
<div id="toolb" class="margin_t_10 left" style="width: 280px;"></div>
<c:if
	test="${contentCfg.useWorkflow and nodePerm_commonActionList ne '[]'}">
	<c:set var="commonActionNodeCount" value="0" />
	<c:forEach items="${commonActionList}" var="operation">
		<c:set var="commonActionNodeCount" value="${commonActionNodeCount+1}" />
		<c:if test="${(canModifyWorkFlow || (!canModifyWorkFlow && summaryVO.summary.startMemberId == summaryVO.affair.memberId)) && superNodestatus==0}">
			<c:if test="${'AddNode' eq operation}">
				<input type="hidden" id="tool_${commonActionNodeCount}"
					value="_commonAddNode" />
				<%--加签 --%>
			</c:if>
			<c:if test="${'FaDistribute' eq operation}">
				<input type="hidden" id="tool_${commonActionNodeCount}"
					value="_commonFaDistribute" />
				<%--分发 --%>
			</c:if>
			<c:if test="${'JointSign' eq operation}">
				<input type="hidden" id="tool_${commonActionNodeCount}"
					value="_commonAssign" />
				<%--当前会签 --%>
			</c:if>
			<c:if test="${'RemoveNode' eq operation}">
				<input type="hidden" value="_commonDeleteNode"
					id="tool_${commonActionNodeCount}" />
				<%--减签 --%>
			</c:if>
			<c:if test="${'Infom' eq operation}">
				<input type="hidden" value="_commonAddInform"
					id="tool_${commonActionNodeCount}" />
				<%--知会 --%>
			</c:if>
			<c:if test="${'moreSign' eq operation }">
				<%--多级会签 --%>
				<input type="hidden" value="_commonMoreSign" id="tool_${commonActionNodeCount }"/>
			</c:if>
		</c:if>

		<c:if test="${ ('Return' eq operation) && superNodestatus==0}">
			<input type="hidden" value="_commonStepBack"
				id="tool_${commonActionNodeCount}" />
			<%--回退 --%>
		</c:if>
<%-- 新公文不需要修改文单		<c:if
			test="${('Edit' eq operation && summaryVO.summary.bodyType ne '20' && summaryVO.summary.bodyType ne '45') && superNodestatus==0}">
			<input type="hidden" value="_commonEditContent"
				id="tool_${commonActionNodeCount}" />
			修改正文
		</c:if> --%>
		<c:if test="${(canEditAttachment || (!canEditAttachment && summaryVO.summary.startMemberId == summaryVO.affair.memberId))}">
			<c:if test="${('allowUpdateAttachment' eq operation)  && superNodestatus==0 }">
				<input type="hidden" value="_commonUpdateAtt"
					id="tool_${commonActionNodeCount}" />
				<%--修改附件 --%>
			</c:if>
		</c:if>
		<c:if test="${('Distribute' eq operation) && superNodestatus==0}">
			<input type="hidden" value="_distribute"
				id="tool_${commonActionNodeCount}" />
			<%--分办 --%>
		</c:if>
		<c:if test="${('JointlyIssued' eq operation) && superNodestatus==0}">
			<input type="hidden" value="_jointlyIssued"
				id="tool_${commonActionNodeCount}" />
			<%--联合发文 --%>
		</c:if>
		<c:if test="${('Terminate' eq operation) && superNodestatus==0}">
			<input type="hidden" value="_commonStepStop"
				id="tool_${commonActionNodeCount}" />
			<%--终止 --%>
		</c:if>
		<c:if test="${ ('Cancel' eq operation  && !summaryVO.isNewflow) && superNodestatus==0 }">
			<input type="hidden" value="_commonCancel"
				id="tool_${commonActionNodeCount}" />
			<%--撤销--%>
		</c:if>
		<c:if test="${ ('Forward' eq operation)  && superNodestatus==0}">
			<input type="hidden" value="_commonForward"
				id="tool_${commonActionNodeCount}" />
			<%--转发--%>
		</c:if>
 		<c:if test="${ ('Sign' eq operation && summaryVO.summary.bodyType ne '45')  && superNodestatus==0}">
			<input type="hidden" value="_commonSign"
				id="tool_${commonActionNodeCount}" />
				<%--文单签章 --%>
		</c:if> 
		<c:if test="${ ('Transform' eq operation)  && superNodestatus==0 }">
			<input type="hidden" value="_commonTransform"
				id="tool_${commonActionNodeCount}" />
			<%--转事件 --%>
		</c:if>
		<c:if test="${('SuperviseSet' eq operation)  && superNodestatus==0}">
			<input type="hidden" value="_commonSuperviseSet"
				id="tool_${commonActionNodeCount}" />
			<%--督办设置--%>
		</c:if>
		<c:if test="${ ('SpecifiesReturn' eq operation )  && superNodestatus==0}">
			<input type="hidden" value="_dealSpecifiesReturn"
				id="tool_${commonActionNodeCount}" />
			<%--指定回退--%>
		</c:if>
		
		<c:if test="${('Edit' eq operation)}">
			<input type="hidden" value="_commonEdit"
				id="tool_${commonActionNodeCount}" />
			<%--修改正文  Edit --%>
		</c:if>
		<c:if test="${('EdocTemplate' eq operation) }">
			<input type="hidden" value="_commonEdocTemplate"
				id="tool_${commonActionNodeCount}" />
			<%--正文套红  EdocTemplate --%>
		</c:if>
		<c:if test="${('ScriptTemplate' eq operation)}">
			<input type="hidden" value="_commonScriptTemplate"
				id="tool_${commonActionNodeCount}" />
			<%--文单套红  ScriptTemplate--%>
		</c:if>
		<c:if test="${('TanstoPDF' eq operation)}">
			<input type="hidden" value="_commonTanstoPDF"
				id="tool_${commonActionNodeCount}" />
			<%--WORD转PDF  TanstoPDF --%>
		</c:if>
		<c:if test="${('TransToOfd' eq operation)}">
			<input type="hidden" value="_commonTransToOfd"
				id="tool_${commonActionNodeCount}" />
			<%--正文转OFD  TransToOfd --%>
		</c:if>
		<c:if test="${('ContentSign' eq operation)}">
			<input type="hidden" value="_commonContentSign"
				id="tool_${commonActionNodeCount}" />
			<%--正文盖章 ContentSign --%>
		</c:if>
		
		<c:if test="${('HtmlSign' eq operation)}">
			<input type="hidden" value="_commonHtmlSign"
				id="tool_${commonActionNodeCount}" />
			<%--文单签批  HtmlSign --%>
		</c:if>
		<c:if test="${('PDFSign' eq operation)}">
			<input type="hidden" value="_commonPDFSign"
				id="tool_${commonActionNodeCount}" />
			<%--全文签批 PDFSign --%>
		</c:if>
		<c:if test="${('SignChange' eq operation)}">
			<input type="hidden" value="_commonSignChange"
				id="tool_${commonActionNodeCount}" />
			<%-- 签批缩放  SignChange --%>
		</c:if>
		<c:if test="${('TransmitBulletin' eq operation)}">
			<input type="hidden" value="_commonTransmitBulletin"
				id="tool_${commonActionNodeCount}" />
			<%--转公告 TransmitBulletin --%>
		</c:if>
		<c:if test="${('PassRead' eq operation)}">
			<input type="hidden" value="_commonPassRead"
				id="tool_${commonActionNodeCount}" />
			<%--传阅 PassRead --%>
		</c:if>
		<c:if test="${('TurnRecEdoc' eq operation)}">
			<input type="hidden" value="_commonTurnRecEdoc"
				id="tool_${commonActionNodeCount}" />
			<%--转收文 TurnRecEdoc --%>
		</c:if>
		<c:if test="${('TranstoSupervise' eq operation)}">
			<input type="hidden" value="_commonTranstoSupervise"
				id="tool_${commonActionNodeCount}" />
			<%--转督办 TranstoSupervise --%>
		</c:if>
	</c:forEach>
</c:if> <c:if test="${(nodePerm_advanceActionList ne '[]')  && superNodestatus==0 }">
	<a id="moreLabel" class="right margin_t_15">${ctp:i18n('common.more.label')}</a>
</c:if></div>
<div class="hr_heng margin_t_10">&nbsp;</div>

<!--处理意见区域-->
<div class="opinions padding_t_10">
<div class="common_radio_box clearfix" id="optionShowDiv" style="display:none;">
<div class="left" id="processAttitude"><c:if test="${nodeattitude!=3}">
	<c:if test="${nodeattitude==1}">
		<label class="margin_r_10 hand" for="afterRead"> <input
			id="afterRead" class="radio_com" name="attitude"
			value="collaboration.dealAttitude.haveRead" type="radio"
			<c:if test="${commentDraft.extAtt1 eq null || commentDraft.extAtt1 eq 'collaboration.dealAttitude.haveRead'}">checked="checked"</c:if>>${ctp:i18n('collaboration.dealAttitude.haveRead')}<!-- 已阅 -->
		</label>
	</c:if>
	<label class="margin_r_10 hand" for="agree"> <input id="agree"
		class="radio_com" name="attitude"
		value="collaboration.dealAttitude.agree" type="radio"
		<c:if test="${nodeattitude == 2 || commentDraft.extAtt1 eq 'collaboration.dealAttitude.agree'}">checked="checked"</c:if>>${ctp:i18n('collaboration.dealAttitude.agree')}<!-- 同意 -->
	</label>
	<c:if test="${superNodestatus==0 || superNodestatus==3}">
	<label class="margin_r_10 hand" for="notagree"> <input
		id="notagree" class="radio_com" name="attitude"
		value="collaboration.dealAttitude.disagree" type="radio"
		<c:if test="${commentDraft.extAtt1 eq 'collaboration.dealAttitude.disagree'}">checked="checked"</c:if>>${ctp:i18n('collaboration.dealAttitude.disagree')}<!-- 不同意 -->
	</label>
	</c:if>
</c:if></div>
<c:if test="${ctp:containInCollection(basicActionList, 'CommonPhrase')}">
	<div class="right"  id="commonuse"><a id="cphrase" curUser="${CurrentUser.id}">${ctp:i18n('collaboration.common.commonLanguage')}<!-- 常用语 --></a></div>
</c:if>
   <%-- G6-v5.7 屏蔽点赞 <div class="right">
	<span id="praiseToObj" 
	title="<c:if test='${commentDraft.praiseToSummary}'>${ctp:i18n('collaboration.summary.label.praisecancel')}</c:if><c:if test='${!(commentDraft.praiseToSummary)}'>${ctp:i18n('collaboration.summary.label.praise')}</c:if>" class="ico16 ${commentDraft.praiseToSummary ? 'like_16' : 'no_like_16' }" style="width:16px;" onclick='praiseToSummary()'></span>
	&nbsp;&nbsp;<em class="seperate"></em>&nbsp;&nbsp;
	</div>--%>
</div>
<!-- xl 7-1新布局  修改輸入框的高度 -->
<c:if test="${ctp:containInCollection(basicActionList, 'Opinion')}">
	<textarea id="content_deal_comment" name="content_deal_comment"
		class="padding_5 margin_t_5" errorIcon="false" style="width: 95%;font-size:14px;display:none;<c:choose><c:when test="${newGovdocView==1 }">height:60px</c:when><c:otherwise>height:200px</c:otherwise></c:choose>">${ctp:toHTMLAlt(commentDraft.content)}</textarea>
</c:if>
<div class="clearfix margin_t_10" id="attachmentAndDoc">
    <c:if test="${(ctp:containInCollection(basicActionList, 'UploadRelDoc') or  ctp:containInCollection(basicActionList, 'UploadAttachment'))  && superNodestatus==0 }">
    	<span class="left" id="attachmentShowTempDiv" style="display:none;"> 
            <c:if
    		test="${ctp:containInCollection(basicActionList, 'UploadAttachment') }">
    		<!-- 附件 -->
    		插入：
    		<div class="nodePerm" baseAction="UploadAttachment"
    			style="display: inline;"><a id="uploadAttachmentID" title="${ctp:i18n('collaboration.summary.label.att')}"
    			class="margin_r_5"><span class="ico16 affix_16"></span></a><c:if test="${newGovdocView!=1 }">(<span
    			id="attachmentNumberDiv${commentId}">0</span>)</c:if></div>
    	   </c:if> 
           <c:if test="${ctp:containInCollection(basicActionList, 'UploadRelDoc')}">
    		  <!-- 关联 -->
    		  <div class="nodePerm" baseAction="UploadRelDoc"
    			style="display: inline;"><a id="uploadRelDocID" title="${ctp:i18n('collaboration.summary.label.ass')}"
    			class="margin_l_10 margin_r_5"><span
    			class="ico16 associated_document_16"></span></a><c:if test="${newGovdocView!=1 }">(<span
    			id="attachment2NumberDiv${commentId}">0</span>)</c:if></div>
    	   </c:if> 
        </span>
    </c:if> 
    <span class="right"><%-- 消息推送 --%>
        <a id="pushMessageButton">
            <em class="ico16 system_messages_16"></em>
            <span id="pushMessageButtonSpan" class="menu_span">${ctp:i18n('collaboration.sender.postscript.pushMessage')}</span>
        </a>
    </span>
    <input type="hidden" id="dealMsgPush" name="dealMsgPush" />
</div>
<div class="newinfo_area margin_t_5"  id="attTempContentDiv" style="display: none;">
<c:if test="${newGovdocView!=1 }">
<div id="attachmentTR${commentId}" style="display: none;">
<div id="content_deal_attach" isGrid="true" class="comp"
	comp="type:'fileupload',applicationCategory:'4',attachmentTrId:'${commentId}',canFavourite:false,canDeleteOriginalAtts:true"
	attsdata='${handleAttachJSON }'></div>
</div>
<div id="attachment2TR${commentId}" style="display: none;">
<div id="content_deal_assdoc" isGrid="true" class="comp"
	comp="type:'assdoc',applicationCategory:'4',attachmentTrId:'${commentId}',modids:'1,3',canFavourite:false,canDeleteOriginalAtts:true"
	attsdata='${handleAttachJSON }'></div>
</div>
</c:if>

</div>
<div class="hr_heng margin_t_10">&nbsp;</div>
<div class="newinfo_area margin_t_5 validate"  id="fenfadanwei" style="display:none" >
<input type="hidden" value="" id="isNotEdit" name = "isNotEdit"/>
<input class="w80b cursor-hand" value="<--${ctp:i18n('collaboration.msg.chooseCompany') }-->" type = "hidden"  id="fenfa_input" name="fenfa_input"/></div>
<c:if test="${ctp:containInCollection(basicActionList, 'Opinion')}">
	<div class="clearfix margin_t_10">
	<div class="common_checkbox_box clearfix left margin_t_5" style="display:none;"><label
		class="margin_r_10 hand" for="isHidden" id="isHiddenLable"> <input id="isHidden"
		class="radio_com" name="isHidden" type="checkbox">${ctp:i18n('collaboration.common.default.commentHidden')}<!-- 意见隐藏 -->
	</label></div>
	<div id="showToIdSpan" class="common_txtbox common_txtbox_dis clearfix">
	<label class="margin_r_10 left title">${ctp:i18n('collaboration.common.default.doesNotInclude')}:</label><!-- 不包括 -->
	<div class="common_txtbox_wrap"><input type="text"
		id="showToIdInput" name="showToIdInput" class="comp"
		comp='type:"selectPeople",showBtn:false,panels:"Department,Team,Post,Outworker,RelatePeople",minSize:0,selectType:"Member",showFlowTypeRadio: false'
		value="${ctp:i18n('collaboration.common.default.clickOpenPeople')}"><!-- 点击选择公开人 -->
	</div>
	</div>
	</div>
</c:if>
<input type="hidden" id="duanxintixing" name="duanxintixing" value="no">
<c:if test="${configValue =='yes'}">
	<div id='sms_alerts'>
		<input type="checkbox" id="sms" name="sms"/>
		<span>${ctp:i18n('collaboration.govdoc.default.duanXinTiXing')}</span>
	</div>
</c:if>

<c:if test="${ctp:containInCollection(basicActionList, 'Track')}">
	<div id='trackDiv_detail'
		class="common_radio_box common_checkbox_box clearfix margin_t_10">
	<label class="margin_r_10 hand" for="isTrack" id="isTrackLable"> 
		<input id="isTrack" class="radio_com" name="isTrack" value="1" type="checkbox">${ctp:i18n('collaboration.forward.page.label4')}<!-- 跟踪 -->
	</label>
	<label class="margin_r_10 disabled_color hand" for="trackRange_all" id="label_all"> 
		<input id="trackRange_all" class="radio_com" name="trackRange" value="1" type="radio" disabled="disabled">${ctp:i18n('collaboration.listDone.all')}<!-- 全部 -->
	</label> 
	<label class="margin_r_10 disabled_color hand"
		for="trackRange_members" id="label_members"> <input
		id="trackRange_members" class="radio_com" name="trackRange" value="0"
		type="radio" disabled="disabled">${ctp:i18n('collaboration.listDone.designee')}<!-- 指定人 -->
	</label> <input type="hidden" id="zdgzry" name="zdgzry" value="${zdgzry}"></input><input id="trackRange_members_textbox" readonly onclick="javascript:toggleTrackRange_members()" type="text" class="hidden" value="${trackNames}" />
	</div>
</c:if> <%-- 归档--%> <c:if test="${summaryVO.summary.canArchive  && superNodestatus==0 }">
	<div class="clearfix margin_t_10 nodePerm" baseAction="Archive">
	<div class="common_checkbox_box clearfix"><label
		class="margin_r_10 hand" for="pigeonhole" id="pigeonholeLable"> <input
		id="pigeonhole" class="radio_com" name="pigeonhole" value="0"
		type="checkbox">${ctp:i18n('collaboration.common.default.archiveAfterProcessing')}<!-- 处理后归档 -->
	<input id="pigeonholeValue" name="pigeonholeValue" type="hidden">
	</label></div>
	</div>
</c:if>
<c:if test="${'true' eq showCustomDealWith }">
<div class="clearfix common_checkbox_box margin_t_5">
	<input type="hidden" id="customDealWithActivitys" name="customDealWithActivitys">
	<c:if test="${nextMember != null }">
	<input type="hidden" id="nextMember" userId="${nextMember.id }" userName="${nextMember.name }" accountId="${nextMember.orgAccountId }" policyId="${currentPolicyId}" policyName="${currentPolicyName }">
	</c:if>
	<table  border="0" cellspacing="0" cellpadding="0" style="table-layout: fixed;"><tr><td class="align_left">
		<label class="margin_r_10 hand"><input id="customDealWith" type="checkbox" class="radio_com" <c:if test="${'true' eq customDealWith }">checked='checked'</c:if> >续办人员:</label></td>
		<td class="padding_5"><select id="permissionRange" onchange="permissionChange(this);" style="width: 100%">
		<c:forEach items="${permissions }" var="permission">
			<option <c:if test="${customDealWithPermission eq permission.name }">selected='selected'</c:if> value="${permission.name }" title="${permission.label}">${permission.label }</option>
		</c:forEach>
		</select></td>
		<td class="padding_5"><select id="memberRange" style="width: 100%" onchange="memberRangeChange(this);">
		<c:if test="${empty members }">
			<option value="0" selected="selected">请选择人员</option>
		</c:if>
		<c:forEach items="${members }" var="member">
			<option <c:if test="${customDealWithMemberId eq member.id }">selected='selected'</c:if> userId="${member.id }" userName="${member.name }" accountId="${member.orgAccountId }" value="${member.id }">${member.name }</option>
		</c:forEach>
		<option value="-1">更多......</option>
		</select></td></tr>
	</table>
</div>
</c:if>

</div>
<%--客开  作者:mly 项目名称:自流程 start --%>

<%--客开  作者:mly 项目名称:自流程 end --%><!-- xl 7-1修改按钮样式 -->
<div <c:if test="${newGovdocView==1 }">style="position:fixed;bottom:0;left:0;width:100%;height:45px;background-color:rgb(209, 212, 214);opacity:0.9;filter: alpha(opacity=90);"</c:if>>
<div class="clearfix right" id="_dealDiv" 
<c:if test="${newGovdocView==1 }">style="margin-top:8px;margin-right:10px;"</c:if>
 >
<div align="right"><%--存为草稿 --%> <c:if
	test="${(isIssus ne 'true' and isAudit ne 'true' and isVouch ne 'true') && (superNodestatus==0 || superNodestatus==1)}">
	<div class="left margin_t_20">
	<c:choose>
		<c:when test="${showButton=='sign'}">
			<!-- 签收 -->
			<a id="_dealSubmit"
			class="common_button common_button_emphasize margin_r_5">${ctp:i18n('collaboration.affair.reSign')}</a>
			<input type="hidden" id="reSign" name="reSign" value="1"/>
		</c:when>
		<c:when test="${showButton=='distribute'}">
			<!-- 分办 -->
			<a id="_distribute"
			class="common_button common_button_emphasize margin_r_5">${ctp:i18n('collaboration.default.distribute')}</a>
			<input type="hidden" id="_dealSubmit"/>
		</c:when>
		<c:when test="${showButton=='distributeAndFinish'}">
			<!-- 分办或提交 -->
			<a id="_dealSubmit"
			class="common_button common_button_emphasize margin_r_5">${ctp:i18n('common.button.submit.label')}</a>
			<a id="_distribute"
			class="common_button common_button_emphasize margin_r_5">${ctp:i18n('collaboration.default.distribute')}</a>
		</c:when>
		<c:when test="${ctp:containInCollection(basicActionList, 'FaDistribute') }">
			<!-- 发行 -->
			<a id="_dealSubmit"
			class="common_button common_button_emphasize margin_r_5">${ctp:i18n('govdoc.distribute')}</a>
		</c:when>
		<c:otherwise>
			<a id="_dealSubmit"
			class="common_button common_button_emphasize margin_r_5">${ctp:i18n('common.button.submit.label')}</a>
		</c:otherwise>
	</c:choose>
	</div>
</c:if>
	
 <c:if test="${(isAudit eq 'true') && (superNodestatus==0 || superNodestatus==1) }">
	<div class="left margin_t_20"><a id="_auditPass"
		class="common_button common_button_gray margin_r_5">${ctp:i18n('collaboration.common.default.auditBy')}</a><!-- 审核通过 -->
	<c:if test="${superNodestatus==0}">
	<a id="_auditNotPass"
		class="common_button common_button_gray margin_r_5">${ctp:i18n('collaboration.common.default.anAuditNotPassed')}</a><!-- 审核不通过 -->
	</c:if>
	</div>
</c:if> <c:if test="${ (isVouch eq 'true') && (superNodestatus==0 || superNodestatus==1) }">
	<div class="left margin_t_20"><a id="_vouchPass"
		class="common_button common_button_gray margin_r_5">${ctp:i18n('collaboration.common.default.approvedBy')}</a><!-- 核定通过 -->
	<c:if test="${superNodestatus==0}">
	<a id="_vouchNotPass"
		class="common_button common_button_gray margin_r_5">${ctp:i18n('collaboration.common.default.approvedNotBy')}</a><!-- 核定不通过 -->
	</c:if>
	</div>
</c:if> <c:if test="${ (isIssus eq 'true') && (superNodestatus==0 || superNodestatus==1) }">
	<div class="left margin_t_20"><a id="_dealPass1"
		class="common_button common_button_emphasize margin_r_5">${ctp:i18n('collaboration.common.default.adoptedAndPublished')}</a><!-- 通过并发布 -->
	<c:if test="${superNodestatus==0}">
	<a id="_dealNotPass"
		class="common_button common_button_emphasize margin_r_5">${ctp:i18n('collaboration.common.default.notPass')}</a><!-- 不通过 -->
	</c:if>
	</div>
</c:if> <c:if
	test="${(isAudit ne 'true' and isVouch ne 'true' and ctp:containInCollection(basicActionList, 'Opinion') and ctp:containInCollection(basicActionList, 'Comment')) && (superNodestatus==0 || superNodestatus==1)}">
	<div class="left margin_t_20"><a id="_dealSaveDraft"
		class="common_button common_button_gray margin_r_5">${ctp:i18n('collaboration.newcoll.saveDraft')}</a></div>
</c:if> <c:if test="${(ctp:containInCollection(basicActionList, 'Comment')) && (superNodestatus==0 || superNodestatus==2)}">
	<div class="left margin_t_20"><a id="_dealSaveWait"
		class="common_button common_button_gray">${ctp:i18n("collaboration.dealAttitude.temporaryAbeyance")}</a></div>
	<!-- 暂存待办 -->
</c:if></div>
</div>
</div>
</div>
</div>
<div id="comment_deal" class="display_none">
	<input  type = "hidden"  id="fenfa_input_value" name = "fenfa_input_value"/>
	<input type="hidden" id="chooseOpinionType" name="chooseOpinionType"/>
	<input type="hidden" id="rightId" name="rightId" value="${rightId }"/>
	<input type="hidden" id="policy" name="policy" value="${nodePermissionPolicy }"/>
    <input type="hidden" id="disPosition" value="${disPosition}"/>
	<input type="hidden" id="id" value="${commentDraft.id}"> 
	<input type="hidden" id="draftCommentId" value="${commentDraft.id}"> 
	<input type="hidden" id="pid" value="0"> 
	<input type="hidden" id="isDistribute" name="isDistribute"/>
	<input type="hidden" id="signAndDistribute" name="signAndDistribut"/>
	<input type="hidden" id="clevel" value="1">
	<input type="hidden" id="path" value="pc">
	<input type="hidden" id="moduleType" value="1"> 
	<input type="hidden" id="moduleId" value="${summaryVO.summary.id}"> 
	<input type="hidden" id="extAtt1"> 
	<input type="hidden" id="ctype" value="0"> 
	<input type="hidden" id="content"> 
	<input type="hidden" id="hidden"> 
	<input type="hidden" id="showToId"> 
	<input type="hidden" id="affairId" value="${summaryVO.affairId}">
	<input type="hidden" id="relateInfo"> 
	<input type="hidden" id="pushMessage" value="false"> 
	<input type="hidden" id="pushMessageToMembers">
	<input type="hidden" id="praiseInput" value="0"></input>
	<input type="hidden" id="_jointlyIssued_value1" value="${jointlyIssyed_value }"/>
	<input type="hidden" id="_jointlyIssued_text1" value="${jointlyIssyed_text }"></input>
	<input type="hidden" id="_jointlyIssued_value2"  value="${jointlyIssyed_value }"/><!-- 1 是原来的，   2 是修改后的， 空 是最终提交的 -->
	<input type="hidden" id="_jointlyIssued_text2" value="${jointlyIssyed_text }"></input>
	<input type="hidden" id="_jointlyIssued_value"/>
	<input type="hidden" id="_jointlyIssued_text"></input>
	<textarea id="dealInForm" name="dealInForm" style="display:none">${ctp:escapeJavascript(commentDraft.content)}</textarea>
</div>

<script type="text/javascript">
  var nodePerm_baseActionList = <c:out value="${nodePerm_baseActionList}" default="null" escapeXml="false"/>;
  var nodePerm_commonActionList = <c:out value="${nodePerm_commonActionList}" default="null" escapeXml="false"/>;
  var nodePerm_advanceActionList = <c:out value="${nodePerm_advanceActionList}" default="null" escapeXml="false"/>;
  var subState = "${summaryVO.affair.subState}";
  var state = '${summaryVO.affair.state}';
  var inInSpecialSB = '${inInSpecialSB}';
  var affairId = "${summaryVO.affairId}";
  var templeteId = "${summaryVO.summary.templeteId}";
  var processId = "${summaryVO.summary.processId}";
  var summaryId= '${summaryVO.summary.id}';
  var bodyType = '${summaryVO.summary.bodyType}';

  var wfItemId = '${contentContext.wfItemId}';
  var wfProcessId = '${contentContext.wfProcessId}';
  var wfActivityId = '${contentContext.wfActivityId}';
  var currUserId = '${CurrentUser.id}';
  var wfCaseId = '${contentContext.wfCaseId}';
  var moduleTypeName = '${subAppName}';
  var defaultPolicyId = '${defaultPolicyId}';
  var flowPermAccountId = '${summaryVO.flowPermAccountId}';
  //var affairId = '${summaryVO.affairId}';
  var nodePolicy = '${ctp:escapeJavascript(nodePolicy)}';
  var currLoginAccount= '${CurrentUser.loginAccount}';
  //var processId = '${summaryVO.summary.processId}';
  var collEnumKey = "${collEnumKey}";
  var forwardEventSubject = "${ctp:escapeJavascript(forwardEventSubject)}";
  var commonActionNodeCount = '${commonActionNodeCount}';
  var startCfg = "${contentCfg.useWorkflow and  nodePerm_advanceActionList ne '[]'}";
  var canModifyWorkFlow = '${canModifyWorkFlow }';
  var canEditAttachment = '${canEditAttachment }';
  var startMemberId = '${summaryVO.summary.startMemberId}';
  var affairMemberId = '${summaryVO.affair.memberId}';
  var isNewfolw = '${summaryVO.isNewflow}';
  var workItemId = '${summaryVO.workitemId}';
  var trackMember="${trackIds}";
  var commentId = '${commentId }';
  var isTemplete = '${isTemplete}'=='true'? true : false;
  var displayIds = '${displayIds }';
  var displayNames = '${displayNames }';
  var departmentId = '${CurrentUser.departmentId}';
  var fenbanStatus = '${fenbanStatus}';
  $("#sms").click(function() {
		var sms = $("#duanxintixing").val();
		if(sms=="no"){
			$("#duanxintixing").val("yes");
		}else if(sms=="yes"){
			$("#duanxintixing").val("no");
		}
	})
  $.content.getContentDealDomains = function(domains) {
    if (!domains)
      domains = [];
    var commentVal = $("#content_deal_comment").val();
    if($("#content_deal_comment").is(":hidden")){
    	try{
    	commentVal = componentDiv.zwIframe.$("#contentOP").val();
    	}catch(e){}
    }
    if($.trim(commentVal) != "" && commentVal.length > 2000) {
        $.alert("${ctp:i18n('collaboration.common.deafult.dealCommentMaxSize')}");
        enableOperation();
        setButtonCanUseReady();
        return false;
    }
    $("#comment_deal #content").val(commentVal);
    <c:if test="${contentCfg.useWorkflow}">
    $("#comment_deal #extAtt1").val($("input[name='attitude']:checked").val());
    </c:if>
    $("#comment_deal #hidden").val($("#isHidden").attr('checked')=="checked");
    $("#comment_deal #showToId").val($("#showToIdInput").val());
    $("#content_deal_attach").html("");
    //如果是在文单中填写意见，附件在文单中提交
    if($("#content_deal_comment").is(":hidden")){//意见隐藏了，附件也不显示
    	try{
    	componentDiv.zwIframe.saveAttachmentPart("deal_attach1");
        $("#comment_deal #relateInfo").val($.toJSON(componentDiv.zwIframe.$("#deal_attach1").formobj()));
    	}catch(e){}
    }else{
    	saveAttachmentPart("content_deal_attach");
        $("#comment_deal #relateInfo").val($.toJSON($("#content_deal_attach").formobj()));
    }
    domains.push("comment_deal");
    return domains;
  };
//客开 作者:mly 项目名称:自流程 start
  function memberRangeChange(obj){
	  var mManager = new memberManager();
	  var selectObj = $(obj);
	  var value  =$("option:selected",selectObj).val();
	  if(value == -1){
		  $.selectPeople({
				params : {
					value : $("#memberRange").val()
				},
				panels:"Department,Team,Post,Level",
				selectType:"Member",
				maxSize:1,
				returnValueNeedType:false,
				callback : function(ret) {
					//ret.text ret.value
					var opt = $("option[value='"+ret.value+"']",selectObj).get(0);
					if(opt != null){
						$(selectObj).val(ret.value);
					}else{
						var member = mManager.viewOne(ret.value);
						var optStr = "<option userId='"+member.id+"' userName='"+member.name+"' accountId='"+member.orgAccountId+"' value='"+ret.value+"' selected='selected' >"+ret.text+"</option>"
						$("option[value='-1']",selectObj).before(optStr);
						$(selectObj).val(ret.value);
					}
				}
			});
	  }
  }
  
  //防止json为空 报错
  var json = '${memberJson}';
  if(json == ""){
	  json = "{}";
  }
  var memberJson = $.parseJSON(json);
  function permissionChange(obj){
	  var value  =$("option:selected",obj).val();
	  var memberArr = memberJson[value];
	  var selectStr =""; 
	  if(memberArr == null || memberArr.length == 0){
		  selectStr ="<option selected='selected' value='0'>请选择人员</option>"; 
	  }
	  for(var i = 0 ;i < memberArr.length; i++){
		  var member = memberArr[i];
		  selectStr = selectStr + "<option userId='"+member.id+"' userName='"+member.name+"' accountId='"+member.orgAccountId+"' value='"+member.id+"'  >"+member.name+"</option>";
	  }
	  selectStr = selectStr +  "<option value=\"-1\">更多......</option>";
	  $("#memberRange").html(selectStr);
  }
  //客开 作者:mly 项目名称:自流程 end  
  
  $(function(){
	//xl 7-10為點擊更多后的彈出框添加滾動條
	if(newGovdocView==1){
		$(".menu_simple_box").css({
			"max-height":"240px",
			"overflow-y":"auto",
			"overflow-x":"hidden"
		});
		$(".menu_simple_box").next("iframe").css({
			"max-height":"240px"
		});
	}
})
  
  
</script>
