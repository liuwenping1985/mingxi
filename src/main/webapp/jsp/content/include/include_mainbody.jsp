<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
    <c:if test="${indexParam==null }">
        <c:set var="indexParam" value="${0}"/>
    </c:if>
    <%-- PC端多视图页签输出 --%>
    <c:if test="${(viewState==4 or fn:length(contentList) > 1)}">
        <div id="viewsTabs">
            <div id="viewsTabs_head" class="common_tabs clearfix border_b" style="position:fixed;width:100%;height:30px;background-color:white;<c:if test="${style=='4'}">display:none</c:if>">
                <ul class="left" id="viewsTab">
                    <c:forEach items="${contentList}" var="content" varStatus="status">
                        <li index="${status.index}" <c:if test="${status.index==indexParam}">class="current"</c:if>><a <c:if test='${(content.extraMap["isOffice"]==null?false:true)}'>officeParm="${content.content}"</c:if>
                            href="javascript:void(0);" onclick="_viewContentSwitch(this,${status.index}<c:if test='${(content.moduleType==1) and ((viewState==1) or (openFrom ne null and openFrom eq "listPending") or (content.extraMap["isOffice"]==null?false:true))}'>,parent.parent.changeViewCallBack</c:if>);"
                            style="max-width:1000px" class='no_b_border last_tab'
                            title='${content.extraMap["viewTitle"]==null?content.title:content.extraMap["viewTitle"]}'> ${content.extraMap["viewTitle"]==null?content.title:content.extraMap["viewTitle"]}</a></li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </c:if>
    <%-- 签章坐标,因为基准坐标要放在正文的左上角，所以必须放在这个位置 --%>
    <%-- HTML增加新的签章定位id为newInputPosition。为了兼容老的签章数据保留inputPosition --%>
    <div style="height:0px;width:0px;position:absolute;" id="inputPosition"></div>
    <c:if test="${contentList[indexParam].contentType!=20}">
            <div style="height:0px;width:0px;position:absolute;" id="newInputPosition"></div>
    </c:if>
    <%-- 正文内容 --%>
    <input type="hidden" id="_currentDiv" value="${indexParam}">
    <c:set value="${contentList[indexParam]['contentType']}" var="contentType0" />

    <c:forEach items="${contentList}" var="content" varStatus="status">
        <c:if test="${content.contentHtml!=null }">
            <c:if test="${status.index==indexParam }">
                <c:choose>
                    <c:when test="${contentList[indexParam]['contentType'] != 10 && contentList[indexParam]['contentType'] != 20}">
                        <div id="mainbodyHtmlDiv_${status.index}" class="content_text content_text_${contentType0}" style="padding-bottom:0px; height:100%; word-break:break-all;${content.contentType!=20?"margin-left:16px;":""}">
                        ${content.contentHtml}
                    </c:when>
                    <c:otherwise>
                        <div id="mainbodyHtmlDiv_${status.index}" class="content_text content_text_${contentType0}" style="padding-bottom:0px; word-break:normal; ">
                        ${content.contentHtml}
                    </c:otherwise>
                </c:choose>
                        </div>
            </c:if>
            <c:if test="${status.index!=indexParam }">
                <c:choose>
                    <c:when test="${contentList[indexParam]['contentType'] != 10 && contentList[indexParam]['contentType'] != 20}">
                        <div id="mainbodyHtmlDiv_${status.index}" class="content_text hidden" style="padding-bottom:0px; height:100%; word-break:break-all;${content.contentType!=20?"margin-left:16px;":""}">
                        ${content.contentHtml}
                    </c:when>
                    <c:otherwise>
                        <div id="mainbodyHtmlDiv_${status.index}" class="content_text hidden" style="padding-bottom:0px; word-break:break-all;${content.contentType!=20?"margin-left:16px;":""}">
                        ${content.contentHtml}
                    </c:otherwise>
                </c:choose>
                        </div>
            </c:if>
        </c:if>
    </c:forEach>
    <c:if test="${contentList[0].contentType==20}">
    <ctp:webBarCode readerId="PDF417Reader" decodeParamFunction="decodeParam" decodeType="form" readerCallBack="readerCallBack"/>
    </c:if>
    <%-- 数据区域--%>
    <div id="mainbodyDataDiv_${indexParam}" style="display: none">
          <input type="hidden" id="id" name="id" value='${contentList[indexParam]["id"] }' />
          <input type="hidden" id="createId" name="createId" value='${contentList[indexParam]["createId"] }' />
          <input type="hidden" id="createDate" name="createDate" value='${contentList[indexParam]["createDate"] }' />
          <input type="hidden" id="modifyId" name="modifyId" value='${contentList[indexParam]["modifyId"] }' />
          <input type="hidden" id="modifyDate" name="modifyDate" value='${contentList[indexParam]["modifyDate"] }' />
          <input type="hidden" id="moduleType" name="moduleType" value='${contentList[indexParam]["moduleType"] }' />
          <input type="hidden" id="moduleId" name="moduleId" value='${contentList[indexParam]["moduleId"] }' />
          <input type="hidden" id="contentType" name="contentType" value='${contentList[indexParam]["contentType"] }' />
          <input type="hidden" id="moduleTemplateId" name="moduleTemplateId" value='${contentList[indexParam]["moduleTemplateId"] }' />
          <input type="hidden" id="contentTemplateId" name="contentTemplateId" value='${contentList[indexParam]["contentTemplateId"] }' />
          <input type="hidden" id="sort" name="sort" value='${contentList[indexParam]["sort"] }' />
          <input type="hidden" id="title" name="title" value="${ctp:toHTMLWithoutSpace(contentList[indexParam]['title'])}" />
          <textarea style="display:none" id="content" name="content">${ctp:toHTML(contentList[indexParam]['content'])}</textarea>
          <input type="hidden" id="rightId" name="rightId" value='${ctp:toHTML(contentList[indexParam]["rightId"]) }' />
          <input type="hidden" id="status" name="status" value='${contentList[indexParam]["status"] }' />
          <input type="hidden" id="viewState" name="viewState" value='${contentList[indexParam]["viewState"] }' />
          <input type="hidden" id="contentDataId" name="contentDataId" value='${contentList[indexParam]["contentDataId"] }' />
      </div>




            <c:if test="${contentList[0].contentType!=20}">
                <style type="text/css">
                  .xdRichTextBox span{
                    overflow:auto;
                }
                </style>
            </c:if>
            <c:if test="${contentList[indexParam].contentType==10}">
                <%-- 转发的表单正文需要引入form.css用以保持样式不变 --%>
                <c:if test='${fn:indexOf(contentList[indexParam].contentHtml,"formmain_")!=-1 or fn:indexOf(contentList[indexParam].contentHtml,"allowtransmit")!=-1}'>
                    <script type="text/javascript" src="${ctp_contextPath}/common/content/form.js${ctp:resSuffix()}"></script>
                    <script type="text/javascript">
                        try{
                            setTimeout(function(){
                                initFormContent(false,true);
                                var newHeight = $("#mainbodyDiv").height();
                                if(typeof(oldHeight)!="undefined"){
                                    if(newHeight != oldHeight){
                                        fnResizeContentIframeHeight();
                                    }
                                }
                            },280);
                            var viewState = $("#viewState").val();
                            var _isFowardForm = '${fn:indexOf(contentList[indexParam].contentHtml,"formmain_")!=-1 or fn:indexOf(contentList[indexParam].contentHtml,"allowtransmit")!=-1}';
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
            </c:if>
            <c:if test="${contentList[indexParam].contentType==20}">
                <script type="text/javascript" src="${ctp_contextPath}/common/content/form.js${ctp:resSuffix()}"></script>
                <script type="text/javascript">
                var advanceAuthType = "${contentList[indexParam].extraMap['advanceAuthType']}";
                var form =${contentList[indexParam].extraMap['formJson']};//一次就行,多视图也是相同的表单
                var form_display = ${contentList[indexParam].extraMap['form_display']};//一次就行,多视图也是相同的表单
                <c:if test="${contentList[indexParam].extraMap['formDataLocker']!=null}">
                    var formDataLocker = "${contentList[indexParam].extraMap['formDataLocker'].name}";
                </c:if>
                //onload事件还在单元格还没全部显示出来之前就开始执行了，所以需要延时  By：zhangc
                    setTimeout(function(){
                      <c:if test='${(openFrom ne null and openFrom eq "dataRelation")}'>
                        if($("a[officeparm]").length>0&&window.location.href.indexOf("formRecordid")>0){//有office页签
                            $("#viewsTab>li").eq(0).find("a").trigger("click");
                        }
                      </c:if>
                      initFormContent(false,false,"${style}");
                      var newHeight = $("#mainbodyDiv").height();
                      if(typeof(oldHeight)!="undefined"){
                          if(newHeight != oldHeight){
                            fnResizeContentIframeHeight();
                          }
                      }
                    },280);
                <c:if test="${style==1}">
                    //ie7下新建表单协同页面，横向滚动条看不见，将height调成96%
                    if(document.all&&"${contentList[0].viewState}"=="1"&&"${contentList[0].moduleType}"=="1"){
                        var browser=navigator.appName;
                        var b_version=navigator.appVersion;
                        var version=b_version.split(";");
                        var trim_Version=version[1].replace(/[ ]/g,"");
                        if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE7.0"){
                            $("#mainbodyDiv").css("height","96%");
                        }
                    }
                    $("#attachmentArea",$(".content_text")).addClass("hidden");
                    //老数据中html正文的mainbodyHtmlDiv_中有隐藏的mainbodyDataDiv_ 导致报js错不能正常保存正文
                    $("div[id^='mainbodyHtmlDiv_']").each(function(){
                        $(this).find("div[id^='mainbodyDataDiv_']").remove();
                    })
                </c:if>
                </script>
                <script type="text/javascript" src="${ctp_contextPath}/common/content/formCommon.js${ctp:resSuffix()}"></script>
            </c:if>




<c:if test="${style!=4&&style!=3}">
<!--表单相关样式-->
    <style>
        input[type="text"]{
            line-height:normal;
        }
        .browse_class span {
            color: blue;
        }
        .xdTableHeader TD {
            min-height: 10px;
        }
        .radio_com {
            margin-right: 0px;
        }
        .xdTextBox {
            BORDER-BOTTOM: #dcdcdc 1pt solid;
            min-height: 12px;
            TEXT-ALIGN: left;
            BORDER-LEFT: #dcdcdc 1pt solid;
            BACKGROUND-COLOR: window;
            DISPLAY: inline-block;
            WHITE-SPACE: nowrap;
            COLOR: windowtext;
            OVERFLOW: hidden;
            BORDER-TOP: #dcdcdc 1pt solid;
            BORDER-RIGHT: #dcdcdc 1pt solid;
            padding-right:1px!important;
        }
        .xdRichTextBox {
            font-size: 12px;
            BORDER-BOTTOM: #dcdcdc 1pt solid;
            TEXT-ALIGN: left;
            BORDER-LEFT: #dcdcdc 1pt solid;
            BACKGROUND-COLOR: window;
            FONT-STYLE: normal;
            min-height: 12px;
            display: inline-block;
            WORD-WRAP: break-word;
            COLOR: windowtext;
            BORDER-TOP: #dcdcdc 1pt solid;
            BORDER-RIGHT: #dcdcdc 1pt solid;
            TEXT-DECORATION: none;
        }

        span.xdRichTextBox{
            VERTICAL-ALIGN: bottom !important;
        }
        span.design_class{
            vertical-align: bottom;
        }
        span.edit_class{
            vertical-align: bottom;
        }
        .mainbodyDiv div,.mainbodyDiv input,.mainbodyDiv textarea,.mainbodyDiv p,.mainbodyDiv th,.mainbodyDiv td,.mainbodyDiv ul,.mainbodyDiv li{
            font-family: inherit;
            layout-grid-mode : none;
        }
        span.biggerThanMax{
            background-color:yellow;
        }
        .insert_pic_16{
            margin-top:2px;
        }
        span.browse_class>span{
            min-height:14px;
            overflow-y:hidden;
            white-space:pre-wrap;
        }
        <c:if test="${(viewState==1)}">
        /*可编辑态下浏览权限字段背景默认背景颜色灰色 #EDEDED*/
        span.browse_class>span{
            BACKGROUND-COLOR: #EDEDED;
        }
        span.browse_class>label{
            BACKGROUND-COLOR: #EDEDED;
        }
        span.browse_class>input{
            BACKGROUND-COLOR: #EDEDED;
        }
        span.browse_class>div.left{
            BACKGROUND-COLOR: #EDEDED;
        }
        span.browse_class>div.right{
            BACKGROUND-COLOR: #EDEDED;
        }
        span.browse_class>div.clearfix{
            BACKGROUND-COLOR: #EDEDED;
        }
        </c:if>
        .font_size12{
            font-size:12px;
        }
        .padding_0{
            padding:0;
        }
        div.content_text{
            padding-top:15px;
        }
        #resultTableShow td{
            border: 1px solid #e3e3e3;
        }

        @media screen and (-webkit-min-device-pixel-ratio:0){.content_text>ol{padding-left:34px;} .content_text>ol>li{padding-left: 6px;}}




    </style>
    <!--[if IE 8]>
    <style>
            input[type="text"]{
                line-height:24px;
            }
    </style>
    <![endif]-->
</c:if>
<script  type="text/javascript">
function resetzwIframeHeight(){
    //当正文是表单的时候，并且是回退到待发列表的才做处理
    if(parent.fix_zwIframeHeight && (parent.bodyType == '20' || parent.contentViewState == "2") && parent.waitsendflagnew){
        parent.fix_zwIframeHeight();
    }
}
function setViewsTabs(){
    if(typeof(MxtTab)=="function"){
        var _viewTab = new MxtTab({
            id:"viewsTabs",
            width: $("body").width(),
            triggerCurrent: false,
            needPage: true
        });
    }
}
$(document).ready(function() {
    $(".content_text a").each(
        function(){
            if((this.href.indexOf(location.hostname) == -1) && !(this.href.indexOf('javascript') == 0) ) {
                if(this.target == '' || this.target == '_self' || this.target == '_parent'){
                    $(this).attr('target', '_blank');
                }
            }
    });
    resetzwIframeHeight();
    var _tabAreaWidth = $("#viewsTabs").width();
    if(_tabAreaWidth == 0){
        setTimeout("setViewsTabs()",1000);
    }else{
        setViewsTabs();
    }
    
    $(window).resize(function(){
        resetzwIframeHeight();
    });
});
</script>