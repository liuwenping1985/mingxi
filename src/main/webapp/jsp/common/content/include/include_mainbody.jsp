<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
	<script type="text/javascript">
	var isSetHeight = false;
	</script>
	<c:if test="${indexParam==null }">
		<c:set var="indexParam" value="${0}"/>
	</c:if>
    <%-- PC端多视图页签输出 --%>
    <c:if test="${(viewState==4 or fn:length(contentList) > 1)}">
            <div class="common_tabs clearfix border_b" style="z-index:10;position:fixed;width:100%;height:25px;background-color:white;<c:if test="${style=='4'}">display:none</c:if>">
            	<iframe id='iframebar' src="about:blank" frameBorder=0  marginHeight=0 marginWidth=0 style="position:absolute;visibility:inherit; top:0px;left:0px;height:27px;width:100%;z-index:-1;filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)'"></iframe>  
                <ul class="left" id="viewsTab">
                    <c:forEach items="${contentList}" var="content" varStatus="status">
                        <li index="${status.index}" <c:if test="${status.index==indexParam}">class="current"</c:if>><a
                            href="#" onclick="_viewContentSwitch(${status.index}<c:if test='${(content.moduleType==1) and ((viewState==1) or (openFrom ne null and openFrom eq "listPending"))}'>,parent.parent.changeViewCallBack</c:if>);"
                            style="max-width:1000px" class='no_b_border last_tab' 
                            title='${content.extraMap["viewTitle"]==null?content.title:content.extraMap["viewTitle"]}'> ${content.extraMap["viewTitle"]==null?content.title:content.extraMap["viewTitle"]}</a></li>
                    </c:forEach>
                </ul>
            </div>
    </c:if>
    <%-- 签章坐标,因为基准坐标要放在正文的左上角，所以必须放在这个位置 --%>
		<div style="height:0px;width:0px" id="inputPosition"></div>
		 <c:if test="${contentList[indexParam].contentType!=20}">
        	<div style="height:0px;width:0px" id="newInputPosition"></div>
		</c:if>	
    <%-- 正文内容 --%>
   	<input type="hidden" id="_currentDiv" value="${indexParam}">
   	<c:forEach items="${contentList}" var="content" varStatus="status">
  		<c:if test="${content.contentHtml!=null }">
  			<c:if test="${status.index==indexParam }">
     			<div id="mainbodyHtmlDiv_${status.index}" class="content_text" style="padding-bottom:0px; height:98%; word-break:break-all;${content.contentType!=20?"margin-left:16px;":""}">               
          		${content.contentHtml}
      		</div>
     			</c:if>
     			<c:if test="${status.index!=indexParam }">
    			<div id="mainbodyHtmlDiv_${status.index}" class="content_text hidden" style="padding-bottom:0px; height:98%; word-break:break-all;${content.contentType!=20?"margin-left:16px;":""}">               
          		${content.contentHtml}
      		</div>
     			</c:if>
    		</c:if>
   	</c:forEach>
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
            					if(typeof fixdContentIframeHeight ==='function'){
            						fixdContentIframeHeight();
            					}
            				},280);
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
	                  initFormContent(false,false,"${style}");
					  if(typeof fixdContentIframeHeight ==='function'){
						fixdContentIframeHeight();
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
               	<script type="text/javascript" src="${ctp_contextPath}/ajax.do?managerName=formQueryResultManager,ctpMainbodyManager,colManager"></script>
				<script type="text/javascript" src="${ctp_contextPath}/ajax.do?managerName=formRelationManager"></script>
				<script type="text/javascript" src="${ctp_contextPath}/ajax.do?managerName=formManager"></script>  
				<script type="text/javascript" src="${ctp_contextPath}/common/content/formCommon.js${ctp:resSuffix()}"></script>
            </c:if>




<c:if test="${style!=4&&style!=3}">
<!--表单相关样式-->
	<style>
		input[type="text"]{
			line-height:normal;
		}
		.browse_class span {
		<% if(request.getAttribute("isGovdocForm")!=null){%>
			color: windowtext;
		<%}else{%>
			color: blue;
		<%}%>
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
		}
		.xdRichTextBox {
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
		<c:if test="${(viewState==1)}">
		/*可编辑态下浏览权限字段背景默认背景颜色灰色 #EDEDED*/
		span.browse_class>span{
			BACKGROUND-COLOR: #F8F8F8;
			min-height:14px;
			overflow-y:hidden;
			white-space:pre-wrap;
		}
		span.browse_class>span{
			BACKGROUND-COLOR: #F8F8F8;
		}
		span.browse_class>label{
			BACKGROUND-COLOR: #F8F8F8;
		}
		span.browse_class>input{
			BACKGROUND-COLOR: #F8F8F8;
		}
		span.browse_class>div.left{
			BACKGROUND-COLOR: #F8F8F8;
		}
		span.browse_class>div.right{
			BACKGROUND-COLOR: #F8F8F8;
		}
		span.browse_class>div.left{
			overflow:hidden!important;
		}
		</c:if>
		<c:if test="${(viewState==2)}">
		span.browse_class>div.left{
			overflow:hidden!important;
		}
		</c:if>
	</style>
</c:if>
<script  type="text/javascript">
$(document).ready(function() {
    $(".content_text a").each(
        function(){
        	var tempThis = $(this);
            if(tempThis.attr("href")&&tempThis.attr("href")!=undefined&&(tempThis.attr("href").indexOf(location.hostname) == -1) && !(tempThis.attr("href").indexOf('javascript') == 0) ) {
                if(this.target == ''){
                    $(this).attr('target', '_blank');
                }
            }
    })
});
</script>