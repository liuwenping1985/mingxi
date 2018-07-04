<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

var inInSpecialSB = '${inInSpecialSB}';

$.content.getContentDealDomains = function(domains) {
	if (!domains)
      domains = [];
	var commentVal = $("#contentOP").val();
    if($.trim(commentVal) != "" && commentVal.length > 4000) {
        $.alert("${ctp:i18n('infosend.alert.maxOptionLength')}");
        enableOperation();
        setButtonCanUseReady();
        return false;
    }
    $("#comment_deal #content").val(commentVal);
    <c:if test="${contentCfg.useWorkflow}">
    	$("#comment_deal #attitude").val($("input[name='attitude']:checked").val());
    </c:if>
    $("#comment_deal #isHidden").val($("#isHidden").attr('checked')=="checked");
    $("#comment_deal #showToId").val($("#showToIdInput").val());
    $("#content_deal_attach").html("");
    $("#comment_deal #relateInfo").val($.toJSON($("#content_deal_attach").formobj()));
    domains.push("comment_deal");
    return domains;
};

</script>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
    <tr>
        <td>
        	<!-- 基础操作 -->
            <div>
            <span style="float: left;">
            	<!-- 提交 -->
            	<a id="_dealSubmit" href="javascript:void(0)" class="common_button common_button_emphasize margin_r_5">${ctp:i18n('common.button.submit.label')}</a>

            	<!-- 暂存待办 -->
            	<c:if test="${ctp:containInCollection(totalActionList, 'Comment')}">
            		<a id="_dealSaveWait" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('processLog.action.18')}<!-- 暂存待办 --></a>
            	</c:if>

            	<span class="toolbar_l">
	            	<!-- 退回 -->
	            	<c:if test="${ctp:containInCollection(totalActionList, 'InfoReturn')}">
		               	<a class="margin_r_5" href="javascript:void(0)" id="_commonStepBack_a">
		                 	<em class="ico16 toback_16"></em>
		                 	<span class="menu_span">${ctp:i18n('infosend.nodePerm.stepBack.label')}</span>
		               	</a>
		            </c:if>

	             	<!-- 终止 -->
	              	<c:if test="${ctp:containInCollection(totalActionList, 'InfoTerminate')}">
		               	<a class="margin_r_5" href="javascript:void(0)" id="_commonStepStop_a">
		                 	<em class="ico16 termination_16"></em>
		                 	<span class="menu_span">${ctp:i18n('infosend.label.stop')}<!-- 终止 --></span>
		               	</a>
	        		</c:if>
	            </span><!-- 基础操作 -->

	            <!-- 更多操作 -->
	            <span class="toolbar_l">
	              	<a id="_moreLabel" href="javascript:void(0)">
	                	<em id="arrow_2_b" class="ico16 arrow_2_b" style="display: inline-block; margin-top: -3px;" oldblock="inline-block"></em>
	                	<em id="arrow_2_t" class="ico16 arrow_2_t" style="display: none; margin-top: -3px;" oldblock="inline-block"></em>
	                	<span  style="margin-left: -5px;" >${ctp:i18n('infosend.label.moreAction')}<!-- 更多操作 --></span>
	              	</a>
	            </span>
	           </span>
	             <span style="align:right; float:right;" class="toolbar_r padding_r_10">
	             	${ctp:i18n('common.workflow.policy')}<!-- 节点权限 -->：${summaryVO.permission.label }
	             </span>
	             <span style="clear: both;"></span>
             </div>
		</td>
	</tr>
    <tr>
        <td>
	        <div id='trackDiv_detail' class="common_radio_box common_checkbox_box clearfix margin_t_10">
				<c:set value="1" var="countBtn" />

	          	<div id="detail_more_operation" class="toolbar_l">

	            	<div class="hr_heng margin_t_5"></div>

	            	<!-- 消息推送 -->
	              	<a id="pushMessageButton" href="javascript:void(0)">
	                	<em class="ico16 system_messages_16"></em>
	                	<span class="menu_span">${ctp:i18n('common.msg.push')}<!-- 消息推送 --></span>
	              	</a>
	              	
					<%-- 消息推送弹出窗口区 add by libing --%>
					<jsp:include page="/WEB-INF/jsp/apps/info/info_comment_property.jsp" />
	          		<%-- 消息推送结束 --%>

	          		<c:set value="false" var="show_JointSign" />
	          		<c:set value="false" var="show_MoreSign" />
	          		<c:set value="false" var="show_InfoContent" />
	          		<c:set value="false" var="show_UpdateAtt" />
	          		<c:set value="false" var="show_SpecifiesReturnBack" />

	          		<%-- 归档 --%>
	  				<c:if test="${ctp:containInCollection(totalActionList, 'InfoDepartPigeonhole')}">
	  			    	<c:set value="${countBtn+1}" var="countBtn" />
			            <span id="pigeonholeSpan">
			              	<span><input id="isArchive" type="checkbox" />${ctp:i18n('infosend.label.signAfterPipeonhole')}<!-- 处理后归档 --></span>
			              	<span id="archiveTo">${ctp:i18n('infosend.label.pigeonhole.to')}<!-- 归档到 -->:
			                	<select id="pigeonhole">
			                  	<option id="defaultOption" value="1">${ctp:i18n('infosend.label.no')}<!-- 无 --></option>
			                  	<option id="modifyOption"  value="2">&lt;${ctp:i18n('infosend.label.pleaseSelect')}<!-- 请选择 -->&gt;</option>
			                	</select>
			          		</span>
			            </span>
	            	</c:if>

					<%--跟踪设置开始 --%>
		            <c:if test="${ctp:containInCollection(totalActionList, 'Track')}">
		            	<c:set value="${countBtn+1}" var="countBtn" />
						<label class="margin_r_10 hand" for="isTrack" id="isTrackLable"> <input
							id="isTrack" class="radio_com" name="isTrack" value="0"
							type="checkbox">${ctp:i18n('collaboration.forward.page.label4')}<!-- 跟踪 -->
						</label> <label class="margin_r_10 disabled_color hand" for="trackRange_all"
							id="label_all"> <input id="trackRange_all" class="radio_com"
							name="trackRange" value="1" type="radio" disabled="disabled">${ctp:i18n('collaboration.listDone.all')}<!-- 全部 -->
						</label> <label class="margin_r_10 disabled_color hand"
							for="trackRange_members" id="label_members"> <input
							id="trackRange_members" class="radio_com" name="trackRange" value="0"
							type="radio" disabled="disabled">${ctp:i18n('collaboration.listDone.designee')}<!-- 指定人 -->
						</label> <input type="hidden" id="zdgzry" name="zdgzry" value="${zdgzry}"></input>
					</c:if>
					<%--跟踪设置结束--%>

					<!-- 加签 -->
		            <c:if test="${ctp:containInCollection(totalActionList, 'AddNode')}">
		              <c:set value="${countBtn+1}" var="countBtn" />
	              		<a id="_commonAddNode" href="javascript:void(0)">
	              			<em class="ico16 signature_16"></em>
	              			<span class="menu_span">${ctp:i18n('collaboration.nodePerm.insertPeople.label')}</span>
	              		</a>
		            </c:if>

					<!-- 减签 -->
		            <c:if test="${ctp:containInCollection(totalActionList, 'RemoveNode')}">
		            <c:set value="${countBtn+1}" var="countBtn"/>
		              <a href="javascript:void(0)" id="_dealDeleteNode">
		                  <em class="ico16 margin_r_5 signafalse_16"></em>
		                  <span class="menu_span">${ctp:i18n('collaboration.nodePerm.deletePeople.label')}</span>
		              </a>
		            </c:if>

					<!-- 当前会签 -->
					<c:if test="${ctp:containInCollection(totalActionList, 'JointSign')}">
						<c:set value="${countBtn+1}" var="countBtn" />
						<c:set value="true" var="show_JointSign" />
		              	<a href="javascript:void(0)" id="_dealAssign">
		              	    <em class="ico16 current_countersigned_16"></em>
		              	    <span class="menu_span">${ctp:i18n('collaboration.nodePerm.Assign.label')}</span>
		              	</a>
		            </c:if>

					<!-- 多级加签 -->
					<c:if test="${countBtn<=5 && ctp:containInCollection(totalActionList, 'moreSign')}">
						<c:set value="${countBtn+1}" var="countBtn" />
						<c:set value="true" var="show_MoreSign" />
		              	<a href="javascript:void(0)" id="_moreAssign">
		              	  <em class="ico16 margin_r_5 signafalse_16"></em>
		              	  <span class="menu_span">${ctp:i18n('infosend.nodePerm.moreAssign.label')}</span>
		              	</a>
		            </c:if>

	            	<!-- 修改正文 -->
	            	<%-- v3x:getBrowserFlagByRequest('HideBrowsers', pageContext.request)为多浏览器控制 --%>
					<c:if test="${countBtn<=5 && ctp:containInCollection(totalActionList, 'Edit')}">
						<c:set value="${countBtn+1}" var="countBtn" />
						<c:set value="true" var="show_InfoContent" />
		              	<a href="javascript:void(0)" id="_dealEditContent">
		              	  <em class="ico16 modify_text_16"></em>
		              	  <span class="menu_span">${ctp:i18n('collaboration.nodePerm.editContent.label') }</span>
		              	</a>
		            </c:if>

		            <!-- 修改附件 -->
					<c:if test="${countBtn<=5 && ctp:containInCollection(totalActionList, 'allowUpdateAttachment')}">
						<c:set value="${countBtn+1}" var="countBtn" />
						<c:set value="true" var="show_UpdateAtt" />
		              	<a href="javascript:void(0)" id="_dealUpdateAttachment">
		              	    <em class="ico16 margin_r_5 signafalse_16"></em>
		              	    <span class="menu_span">${ctp:i18n('collaboration.nodePerm.allowUpdateAttachment') }</span>
		              	</a>
		            </c:if>

		            <!-- 指定回退 -->
					<c:if test="${countBtn<=5 && ctp:containInCollection(totalActionList, 'SpecifiesReturn')}">
						<c:set value="true" var="show_SpecifiesReturnBack" />
			              	<a href="javascript:void(0)" id="_dealSpecifiesReturn">
			              	    <em class="ico16 specify_fallback_16"></em>
			              	    <span class="menu_span">${ctp:i18n('collaboration.default.stepBack') }</span>
			              	</a>
		            </c:if>

					<!-- 更多 -->
					<c:if test="${countBtn>5}">
			            <span>
			              	<a href="javascript:void(0)" id="_moreOperation">
			              	    <em id="_moreOperation_em" class="ico16 arrow_2_b"></em>
			              	    <span id="_moreOperation_span" class="menu_span">${ctp:i18n('common.more.label')}<!-- 更多 --></span>
			              	 </a>
			            </span>
		            </c:if>

    				<script>
	    				show_MoreSign = "${show_MoreSign}";
	    				show_InfoContent = "${show_InfoContent}";
	    				show_UpdateAtt = "${show_UpdateAtt}";
	    				show_SpecifiesReturnBack = "${show_SpecifiesReturnBack}";
    				</script>

	          	</div>
	        </div>
        </td>
    </tr>
</table>


		<c:set value="false" var="canShowAttitude" />
		<c:set value="${v3x:containInCollection(totalActionList, 'Opinion')}" var="canShowOpinion" />
		<c:set value="${v3x:containInCollection(totalActionList, 'UploadRelDoc')}" var="canUploadRel" />
		<c:set value="${v3x:containInCollection(totalActionList, 'UploadAttachment')}" var="canUploadAttachment" />
		<c:set value="${v3x:containInCollection(totalActionList, 'CommonPhrase')}" var="canShowCommonPhrase" />
		<c:set value="5" var="contentTop" />
        <div id="currentComment">
        <div id="notPrint">
        	<c:if test="${canShowCommonPhrase }">
        		<div id="divPhrase" oncontextmenu="return false" style="position:absolute; right:350px; top:120px; width:450px; height:150px; z-index:2; background-color: #ffffff;display:none;overflow:no;border:1px solid #000000;" >
        			<IFRAME width="100%" id="phraseFrame" onmouseout="hiddenPhrase()" name="phraseFrame" height="100%" frameborder="0" align="middle" scrolling="no" marginheight="0" marginwidth="0"></IFRAME>
        		</div>
        	</c:if>

	        <table width='100%' border='0' cellspacing='0' cellpadding='0' >
	        	<c:if test='${canShowAttitude=="true" || canShowCommonPhrase=="true" || canUploadAttachment=="true" || canUploadRel=="true" }'>
	        		<c:set value="0" var="contentTop" />
	        		<tr>
	        			<td height='30' class='edoc_deal' style='padding: 0px 5px;'>
		        			<div class='edoc_deal_div'>
		        				<c:if test="${canShowAttitude }"><!-- 是否显示态度 -->
		        					<div style='margin-top:-2px;display:none;'>
		        							<c:set var="enclude" value="${attitudes==2?'1':'' }"/>
									       	<c:set var="select" value="${attitudes==2?'2':'1' }"/>
									        <v3x:metadataItem metadata="${colMetadata['collaboration_attitude']}" showType="radio" name="attitude" selected="${draftOpinion == null ? select : summaryVO.infoOpinion.attribute}"  enclude="${enclude }"/>
		        					</div>
		        				</c:if>
		        				<if test="${canShowCommonPhrase }"><!-- 是否显示常语 -->
		        					<a id='cphrase' onclick='showPhraseDiv()' style='float:left;font-size:12px;display:inline-block;'>
		        						<span class='ico16 common_language_16 margin_r_5'></span>${ctp:i18n('infosend.nodePerm.commonLanguage.label') }
		        					</a>
		        				</if>
		        				<c:if test="${canUploadAttachment }"><!-- 是否显示上传附件 -->
		        					<a  onclick='insertAttachmentPoi("${commentId }");'  style='float:left;font-size:12px;display:inline-block;'>
		        						<span class='ico16 affix_16 margin_r_5'></span>${ctp:i18n('infosend.label.uploadAttchment') }
		        					</a>
		        				</c:if>
		        				<c:if test="${canUploadRel }"><!-- 是否显示关联文档 -->
		        					<a  onclick='quoteDocument("${commentId }");'  style='float:left;font-size:12px;display:inline-block;'>
		        						<span class='ico16 affix_16 margin_r_5'></span>${ctp:i18n('infosend.label.relationDoc') }
		        					</a>
		        				</c:if>
		        			</div>
	        			</td>
	        		</tr>
	        	</c:if>
	        	<c:if test="${canShowOpinion }">
	        		<tr>
	        			<td height='30' style='padding: ${contentTop}px 5px;width:98%;'>
	        				<textarea id='contentOP' name='contentOP' rows='10'  style='width:100%' maxSize='1000' validate='maxLength'> </textarea>
	        			</td>
	        		</tr>
	        	</c:if>
	        	<tr>
	        	<td>
		        	<div id="attachmentTR${commentId }" style="display:none;">
			             <table border="0" cellspacing="0" cellpadding="0" width="100%" class="line_height180">
			                 <tr id="attList">
			                     <td width="3%">&nbsp;</td>
			                     <td class="align_right" width="88" nowrap="nowrap"><div class="div-float" style="font-size:12px;font-color:blue;">${ctp:i18n('common.attachment.label')}<!-- 附件 -->：(<span id="attachmentNumberDiv${commentId }"></span>) </div></td>
			                     <td class="align_left">
			                         <div id="attFileDomain1"  class="comp" comp="type:'fileupload',attachmentTrId:'${commentId }',canFavourite:${canFavorite},applicationCategory:'32',referenceId:'${summaryVO.summary.id}',subReferenceId:'${commentId }',canDeleteOriginalAtts:'${canDeleteOriginalAtts}'" attsdata='${opinionJSON }'></div>
			                     </td>
			                 </tr>
			             </table>
			         </div><!-- attachmentTRAtt -->

		        	<div id="attachment2TR${commentId }" style="display:none;">
			             <table border="0" cellspacing="0" cellpadding="0" width="100%" class="line_height180">
			                 <tr id="docList">
			                     <td width="3%">&nbsp;</td>
			                     <td class="align_right" width="88" nowrap="nowrap"><div class="div-float" style="font-size:12px;font-color:blue;">${ctp:i18n('common.mydocument.label')}<!-- 关联文档 -->：(<span id="attachment2NumberDiv${commentId }"></span>) </div></td>
			                     <td class="align_left">
			                         <div class="comp" id="assDocDomain1" comp="type:'assdoc',attachmentTrId:'${commentId }',applicationCategory:'32',referenceId:'${summaryVO.summary.id}',subReferenceId:'${commentId }',canDeleteOriginalAtts:'${canDeleteOriginalAtts}'" attsdata='${opinionJSON }'></div>
			                     </td>
			                 </tr>
			             </table>
			         </div><!-- attachment2TRDoc1 -->

	        		</td>
	        	</tr>
	        </table>
       </div>
       </div>




