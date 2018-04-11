<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <div class="container bulentin" id="container1">
            <div class="container_top">
                <div class="bulentinLOG">
                    <span class="index_Logo" <c:if test="${(bean.spaceType == 2 || bean.spaceType == 3)&&bean.state == 30 &&param.from != 'pigeonhole'}">title="${ctp:i18n('bulletin.backToIndex')}"</c:if> onclick="toIndex();" style="cursor: pointer;">
                        <img src="${path}/skin/default/images/cultural/bulletin/notice_log1.png">
                        <span class="bulentinLOG_Text">${ctp:i18n('bulletin.bulletin')}</span>
                    </span>
                </div>

            </div>
            <div class="content_container">
                <div class="container_auto" id="page_height1" style="${bean.ext4=='form' ? 'width:100%;' : ''}">
                    <div class="all_content" style="${bean.ext4=='form' ? 'width:100%;' : ''}" id = "page_height2">
                    <div class="container_discuss detail content_discuss bulView0" id="page_height" style="${bean.ext4=='form' ? 'width:100%;' : ''};">
                        <div class="discuss_left" style="${bean.ext4=='form' ? 'width:100%;' : ''};">
                            <div class="left_list">
                                <div class="mainText_head" id="head_height">
                                    <div class="mainText_head_title">
                                        <div class="totle_h2" style="word-break: break-all;white-space: pre-wrap;">${ctp:toHTML(bean.title)}</div>
                                    </div>
                                    <div class="mainText_head_msg"><!-- 公告信息 -->
                                        <span class="left Wopacity mainText_head_msgSpan ">
                                            <span  class="pubMsg">
                                                <em class="pubMsg_bar">${ctp:i18n('bulletin.bulTypeView')} :</em>
                                                <span class="pubMsg_span" title="${v3x:toHTML(bean.type.typeName)}">${v3x:getLimitLengthString(ctp:toHTML(bean.type.typeName),24,"...")}</span>
                                            </span>
                                            <span  class="pubMsg">
                                                <em class="pubMsg_bar">${ctp:i18n('bulletin.publishDep')} :</em>
                                                <span class="pubMsg_span" title="${v3x:toHTML(bean.publishDeptName)}">${v3x:getLimitLengthString(ctp:toHTML(bean.publishDeptName),24,"...")}</span>
                                            </span>
                                            <span  class="pubMsg">
                                                <em class="pubMsg_bar">${ctp:i18n('bulletin.readCountView')} :</em>
                                                <span class="pubMsg_span">${ctp:toHTML(bean.readCount)}</span>
                                            </span>
                                            <c:if test="${bean.showPublishUserFlag}">
                                                <span class="pubMsg">
                                                    <em class="pubMsg_bar">${ctp:i18n('bulletin.publishMember')} :</em>
                                                    <span class="pubMsg_span" title="${v3x:toHTML(bean.publishMemberName)}">${v3x:getLimitLengthString(ctp:toHTML(bean.publishMemberName),24,"...")}</span>
                                                </span>
                                            </c:if>
                                            <span  class="pubMsg">
                                                <em class="pubMsg_bar">${ctp:i18n('bulletin.publishDate')} :</em>
                                                <span class="pubMsg_span">${ctp:formatDateTime(bean.publishDate)}</span>
                                            </span>
                                            <span  class="pubMsg">
                                                <c:set value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" var="publishScopeStr" />
                                                <em class="pubMsg_bar">${ctp:i18n('bulletin.publishScope')} :</em>
                                                <span class="pubMsg_span" title="${v3x:toHTML(publishScopeStr)}">${v3x:getLimitLengthString(ctp:toHTML(publishScopeStr),24,"...")}</span>
                                            </span>
                                            <c:if test="${bean.auditUserId !=null && bean.auditUserId != 0 && bean.auditUserId != -1}">
                                                <span  class="pubMsg">
                                                    <em class="pubMsg_bar">${ctp:i18n('bulletin.auditDate')} :</em>
                                                    <span class="pubMsg_span">${ctp:formatDateTime(bean.auditDate)}</span>
                                                </span>
                                                <span  class="pubMsg">
                                                    <em class="pubMsg_bar">${ctp:i18n('bulletin.auditMember')} :</em>
                                                    <span class="pubMsg_span" title="${ctp:showMemberName(bean.auditUserId)}">${v3x:getLimitLengthString(ctp:showMemberName(bean.auditUserId),24,"...")}</span>
                                                </span>
                                            </c:if>
                                        </span>
                                        <!-- <span class="right  mainText_head_msgIcon">
                                            <span>
                                                <em class="icon16 discuss_click_16"></em>
                                                <span class="Wopacity">${bean.readCount}</span>
                                            </span>

                                        </span> -->
                                    </div>
                                    <div class="mainText_head_attrs" id="foot_height" style="width:100%">
                                        <div class="padding30" style="display:none;padding: 5px 0px 5px 0px" id="attachmentTRAttFile">
                                            <div class="atts-label" >
                                            <span class="left label_num">
                                                <em class="icon16 file_attachment_16"></em>&nbsp;(<span id="attachmentNumberDivAttFile"></span>)
                                            </span>
                                                <div id="attFileDomain" isGrid="true" class="comp" comp="type:'fileupload',attachmentTrId:'AttFile',canFavourite:false,applicationCategory:'8',canDeleteOriginalAtts:false" attsdata='${attListJSON }'></div>
                                            </div>
                                        </div>
                                        <div class="padding30" style="display:none;padding: 5px 0px 5px 0px" id="attachment2TRDoc1">
                                            <div class="atts-label">
                                            <span class="left label_num">
                                                <em class="icon16 relation_file_16"></em>&nbsp;(<span id="attachment2NumberDivDoc1"></span>)
                                            </span>
                                                <div id="assDocDomain" isCrid="true" class="comp" comp="type:'assdoc',attachmentTrId:'Doc1',applicationCategory:'8',modids:8,canDeleteOriginalAtts:false" attsdata='${attListJSON }'></div>
                                            </div>
                                        </div>
                                    </div>
                                    <c:if test="${bean.state!='100'}">
                                        <div class="setBtn" id="noprint">
                                            <span class="left">
                                                <%--打印 --%>
                                                <c:if test="${bean.type.printFlag && bean.ext2=='1'}">
                                                    <span class="head_title_print hand" onclick="printResult('${bean.dataFormat}', '${empty bean.ext5}', ${not empty bean.ext4 && bean.ext4 == 'form' })"><!-- param.openFrom ne 'glwd' -->
                                                        <em class="icon16 print_16 " ></em>
                                                        <span class="Wopacity">${ctp:i18n('bulletin.print')}</span>
                                                    </span>
                                                </c:if>
                                                <span class="head_title_collect hand">
                                                    <c:if test="${param.from ne 'pigeonhole' && docCollectFlag eq 'true'}">
                                                    <c:choose>
                                                        <c:when test="${isCollect}">
                                                            <span id="article_fav_more" onclick="javaScript:cancelFavorite_bul('${bean.id}')">
                                                                <em id = "article_fav" class="ico16 stored_16 " ></em>
                                                                <span class="Wopacity collect" >${ctp:i18n('bulletin.cancleCollect')}</span><%--取消收藏 --%>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span id="article_fav_more" onclick="javaScript:favorite_bul('${bean.id}')">
                                                                <em id = "article_fav" class="ico16 unstore_16 hand" ></em>
                                                                <span class="Wopacity collect">${ctp:i18n('bulletin.collect')}</span><%--收藏 --%>
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    </c:if>
                                                </span>
                                                <c:if test="${isManager}">
                                                    <span class="head_title_print hand" onclick="showReadList1('${param.bulId}','${ctp:i18n('bulletin.readMessage')}' ,'${'pigeonhole' eq param.from}' )"><!-- param.openFrom ne 'glwd' -->
                                                        <em class="icon16 discuss_click_current_16"></em>
                                                        <span class="Wopacity">${ctp:i18n('bulletin.readMessage')}</span>
                                                    </span>
                                                </c:if>
                                            </span>
                                        </div>
                                    </c:if>
                                    <div class="title_line"></div>
                                </div>
                                <div class="mainText_body">
                                    <div>
                                        <div id="contentTD" style="width:100%;height:${bean.dataFormat!='HTML' ? '768px' : '100%'};padding-bottom: 6px;text-align: left;" valign="top" colspan="6">
                                            <div id="mainbodyDiv" style="height:100%">
                                            <c:choose>
                                                <c:when test="${bean.ext4=='form'}">
                                                    <v3x:showContent content="${empty bean.ext5 ? bean.content : bean.ext5}" type="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}" createDate="${bean.createDate}" htmlId="content"  contentName="${bean.contentName}" viewMode="edit" transForm="true"/>
                                                    <script type="text/javascript">
                                                        $("span[id^='field']").eq(0).parent().prepend("<div id='newInputPosition' style='width: 0px;height: 0px;position: relative;display:inline-block;'></div>");
                                                    </script>
                                                </c:when>
                                                <c:otherwise>
                                                    <v3x:showContent content="${empty bean.ext5 ? bean.content : bean.ext5}" type="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}" createDate="${bean.createDate}" htmlId="content"  contentName="${bean.contentName}" viewMode="edit"/>
                                                </c:otherwise>
                                            </c:choose>
                                            </div>
                                            <c:if test="${not empty bean.ext4 && bean.ext4 == 'form'}">
	                                            <script type="text/javascript" src="${path}/common/content/form.js${ctp:resSuffix()}"></script>
	                                            <script type="text/javascript">
													try{
														setTimeout(function(){
															$("#mainbodyDiv").css("height","");
															$("#contentTD").css("height","");
															
															initFormContent(false,true);
															var newHeight = $("#mainbodyDiv").height();
															if(typeof(oldHeight)!="undefined"){
																if(newHeight != oldHeight){
																	fnResizeContentIframeHeight();
																}
															}
														},280);
														var viewState = $("#viewState").val();
														//转发的表单正文中有<span><pre></pre><span>这种格式的，如果css都有height会导致里面的内容显示超出标签，解决方法是设置height为auto
														$("pre.prestyle").each(function(){
															if($(this).parent("span").hasClass("xdRichTextBox")){
																$(this).css("height","auto");
																$(this).parent("span").css("height","auto");
															}
														});
														//老数据中html正文的mainbodyHtmlDiv_中有隐藏的mainbodyDataDiv_ 导致报js错不能正常保存正文
														$("div[id^='mainbodyHtmlDiv_']").each(function(){
															$(this).find("div[id^='mainbodyDataDiv_']").remove();
														})
													}catch(e){}
												</script>
                                            </c:if>
                                            <c:if test="${!bean.type.printFlag || bean.ext2!='1'}">
                                              <script type="text/javascript">
                                              editType = "0,0";
                                              if(typeof(officeParams)!="undefined"){
                                                officeParams.officecanPrint  = "false";
                                                officeParams.officecanSaveLocal = "false";
                                              }
                                              </script>
                                            </c:if>
                                            <style>
                                                .contentText p{
                                                    font-size:16px;
                                                    line-height: 1.6;
                                                    word-break: normal;
                                                }
                                                .contentText ul,.contentText ol {
                                                    padding-left: 40px;
                                                }
                                                .contentText ul li {
                                                  list-style: disc;
                                                  font-size: 16px;
                                                }
                                                .contentText ol li {
                                                  list-style: decimal;
                                                  font-size: 16px;
                                                }
                                                .mainText_body table{
                                                    width:100%;
                                                }
                                            </style>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="to_top" id="back_to_top">
            <span class="scroll_bg">
                <em class="icon24 to_top_24 margin_t_5"></em>
                <span class="back_top_msg hidden">${ctp:i18n('bulletin.backToTop')}</span>
            </span>
        </div>