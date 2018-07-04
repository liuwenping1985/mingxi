<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="bulHeader.jsp"%>
<html>
    <head>
        <meta charset="utf-8">
        <title>${ctp:toHTML(bean.title)}</title>
        <link rel="stylesheet" type="text/css" href="${path}/skin/default/bulletin.css${v3x:resSuffix()}" />
        <link rel="stylesheet" type="text/css" href="${path}/apps_res/bulletin/css/myPublish.css${v3x:resSuffix()}"/>
        <script type="text/javascript" src="${path}/apps_res/bulletin/js/common.js${v3x:resSuffix()}"></script>
        <script type="text/javascript" src="${path}/apps_res/bulletin/js/index.js${v3x:resSuffix()}"></script>
        <script type="text/javascript" src="${path}/apps_res/bulletin/js/bulView.js${v3x:resSuffix()}"></script>
        <v3x:attachmentDefine attachments="${attachments}" />
        <script type="text/javascript">
            var bulStyle = 0 ;
            var dataFormat_Type = "${bean.dataFormat}";
            var audit_Id = "${bean.id}";
            var bul_ext4;
            var _spaceType = '${param.spaceType}';
            var _spaceId = '${param.spaceId}';
            <c:if test="${lockAuditFlag!=null && lockAuditFlag}">;
                initLock();
                window.onbeforeunload = unlock;
                window.onunload = "";
                //进行加锁
                function initLock(){
                  try {
                      var action="news.lockaction.audit";
                      var requestCaller = new XMLHttpRequestCaller(this, "ajaxBulDataManager", "lock", false);
                      requestCaller.addParameter(1, "Long", ${bean.id});
                      requestCaller.addParameter(2, "String",action);
                      var ds= requestCaller.serviceRequest();
                  }
                  catch (ex1) {
                      alert("Exception : " + ex1);
                  }
                }
                //进行解锁
                function unlock(){
                    try {
                        var bulDatAjax = new bulDataManager();
                        bulDatAjax.unlock('${bean.id}');
                    }catch (ex1) {
                        alert("Exception : " + ex1);
                    }
                }
            </c:if>
        </script>
        <style>
        #content{border:none;}
        #content:hover{border:none;}
        </style>
    </head>
    <body>
        <div class="container bulentin" id="container1">
            <div class="container_top">
                <div class="bulentinLOG">
                    <span class="index_Logo">
                        <img src="${path}/skin/default/images/cultural/bulletin/notice_log1.png">
                        <span class="bulentinLOG_Text">${ctp:i18n('bulletin.bulletin')}</span>
                    </span>
                </div>

            </div>
            <div class="content_container" id="page_width">
                <c:if test="${already_create}"><!-- 审核处理 -->
                        <div class="container_check container_check_width">
                            <div class="container_check_center">
                                <div class="check_share">
                                    <c:if test="${bean.type.isAuditorModify}">
                                        <a class="check_button" onclick="editBul('${bean.id}','${param.spaceId}');"><span class="talk_button_msg" >${ctp:i18n('bulletin.modifyBul')}</span></a>
                                    </c:if>
                                </div>
                                <div class="check_suggest">
                                    <div class="left">
                                        <textarea class="Wopacity" id="audit_msg"
                                            style="color:#999;"
                                            onfocus="if(this.value == '${ctp:i18n('bulletin.auditAdvice.numLimit')}') {this.style.color = '#333';this.value = '';}"
                                            onblur="if(this.value =='') {this.style.color = '#999';this.value = '${ctp:i18n('bulletin.auditAdvice.numLimit')}';}"
                                            >${ctp:i18n('bulletin.auditAdvice.numLimit')}</textarea>
                                    </div>
                                    <div class="right">
                                        <a class="check_button green" onclick="auditOper('publish')"><span class="talk_button_msg" >${ctp:i18n('bulletin.passPublish')}</span></a>
                                        <a class="check_button green" onclick="auditOper('audit')"><span class="talk_button_msg" >${ctp:i18n('bulletin.pass')}</span></a>
                                        <a class="check_button red" onclick="auditOper('noaudit')"><span class="talk_button_msg" >${ctp:i18n('bulletin.noPass')}</span></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${already_audit_myCreate || already_audit ||noPass_audit}">
                        <div class="msg_check container_check_width2"><!-- 审核信息 -->
                            <div class="msg_check_noPass">
                                <p>
                                    <span class="no_pass_left">${v3x:getLimitLengthString(v3x:showMemberName(bean.auditUserId),10,"...")}${ctp:i18n('bulletin.auditOpinion')}:</span>
                                    <c:if test="${bean.state==20}">
                                        <span class="pass_state ready_pass">${ctp:i18n('bulletin.pass')}</span>
                                    </c:if>
                                    <c:if test="${bean.state==40}">
                                        <span class="pass_state no_pass">${ctp:i18n('bulletin.noPass')}</span>
                                    </c:if>
                                    <span class="pass_state check_auditDate">${ctp:formatDateTime(bean.auditDate)}</span>
                                </p>
                                <div class="no_pass_info">
                                    <span class="no_pass_left">${ctp:i18n('bulletin.postscript')}:</span>
                                    <div class="no_msg right"><div>${ctp:toHTML(bean.auditAdvice)}</div></div>
                                </div>
                                <c:if test="${already_audit_myCreate}">
                                    <a class="button exit_manage_button right" onclick="myCreate_publish('${bean.id}')"><span class="talk_button_msg" >${ctp:i18n('bulletin.publish')}</span></a>
                                </c:if>
                            </div>

                        </div>
                    </c:if>
                <div class="container_auto" id="page_height1" style="${bean.ext4=='form' ? 'width:100%;' : ''}">
                    <div class="all_content" style="${bean.ext4=='form' ? 'width:100%;' : ''}">
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
                                                <c:set value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" var="publishScopeStr" />
                                                <em class="pubMsg_bar">${ctp:i18n('bulletin.publishScope')} :</em>
                                                <span class="pubMsg_span" title="${v3x:toHTML(publishScopeStr)}">${v3x:getLimitLengthString(ctp:toHTML(publishScopeStr),24,"...")}</span>
                                            </span>
                                            <c:if test="${bean.showPublishUserFlag}">
                                                <span  class="pubMsg">
                                                    <em class="pubMsg_bar">${ctp:i18n('bulletin.createMember')} :</em>
                                                    <span class="pubMsg_span" title="${ctp:showMemberName(bean.createUser)}">${v3x:getLimitLengthString(ctp:showMemberName(bean.createUser),24,"...")}</span>
                                                </span>
                                            </c:if>
                                            <span  class="pubMsg">
                                                <em class="pubMsg_bar">${ctp:i18n('bulletin.readCountView')} :</em>
                                                <span class="pubMsg_span">${ctp:toHTML(bean.readCount)}</span>
                                            </span>
                                        </span>
                                    </div>
                                    <div class="title_line"></div>
                                </div>
                                <div class="mainText_body">
                                    <div>
                                        <div id="contentTD" style="width:100%;height:${bean.dataFormat!='HTML' ? '768px' : '100%'};padding-bottom: 6px;text-align: left;" valign="top" colspan="6">
                                            <div style="height:100%">
                                                <v3x:showContent content="${empty bean.ext5 ? bean.content : bean.ext5}" type="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}" createDate="${bean.createDate}" htmlId="content"  contentName="${bean.contentName}" viewMode="edit"/>
                                            </div>
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
                                <div class="mainText_foot" id="foot_height" style="width:100%">
                                    <div class="padding30" style="display: none;padding: 5px 0px 5px 0px" id="attachmentTRAttFile">
                                        <div class="atts-label" >
                                            <span class="left label_num">
                                                <em class="icon16 file_attachment_16"></em>&nbsp;(<span id="attachmentNumberDivAttFile"></span>)
                                            </span>
                                            <div id="attFileDomain" isGrid="true" class="comp" comp="type:'fileupload',attachmentTrId:'AttFile',canFavourite:false,applicationCategory:'8',canDeleteOriginalAtts:false" attsdata='${attListJSON }'></div>
                                        </div>
                                    </div>
                                    <div class="padding30" style="display: none; padding: 5px 0px 5px 0px" id="attachment2TRDoc1">
                                        <div class="atts-label">
                                            <span class="left label_num">
                                                <em class="icon16 relation_file_16"></em>&nbsp;(<span id="attachment2NumberDivDoc1"></span>)
                                            </span>
                                            <div id="assDocDomain" isCrid="true" class="comp" comp="type:'assdoc',attachmentTrId:'Doc1',applicationCategory:'8',modids:8,canDeleteOriginalAtts:false" attsdata='${attListJSON }'></div>
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
    </body>
</html>