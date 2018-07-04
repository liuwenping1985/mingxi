<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="docHeader.jsp"%>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
<%
    Locale locale = AppContext.getLocale();
    String ctxPath = request.getContextPath();
%>
<script type="text/javascript">
  var _ctxPath = "<%=ctxPath%>",_locale='<%=locale%>';
</script>
<script type="text/javascript" src="/seeyon/common/js/jquery-debug.js"></script>
<c:set var="isOfficeBodyType" value="${'OfficeWord' eq vo.bodyType or 'OfficeExcel' eq vo.bodyType}" />
<script>
<!--
    var officecanSave = "true";
    var all = "${param.all}";
    var edit = "${param.edit}";
    var readonly = "${param.readOnly}";
    var editType = "0,0";
    var curOpionion = '';
    var officecanSaveLocal = "true";
    var officecanPrint = "true";
    var t5ContentType = 10;
    var isSave = "${(param.all || param.edit || param.readOnly || (param.create && vo.docResource.createUserId == CurrentUser.id)) && (param.openFrom != 'glwd')}";
    var _baseApp = 3;
    var _baseObjectId = "${baseObjectId}";    
    function setMenuState() {
    	 //all == "false" && edit == "false" && readonly == "false" && !("${param.add}" == "true" && "${vo.docResource.createUserId}" == "${v3x:currentUser().id}")
        if (isSave == "false") {
            officecanSave = "false";
            <%-- 控制在线查看PDF的另存为(等同上方的"下载"菜单)、打印文档(等同上方的"打印"菜单) --%>
            officecanSaveLocal = "false";
            officecanPrint = "false";
        }
        var officeOpen = parseInt(document.getElementById('divScroll').style.height);
        if (!isNaN(officeOpen) && officeOpen > 0) {
            document.getElementById('docBody').style.overflow = "hidden";
        }
        if(typeof(officeParams)!="undefined"){
			officeParams.officecanSaveLocal = officecanSaveLocal;
			officeParams.officecanPrint= officecanPrint;
			officeParams.editType = editType;//office页面是否可以复制粘贴内容(0,0:不能复制;4,0:可以复制)
		}
    }
    function downThisLoadFile() {
        ajaxRecordOptionLog('${param.docResId}', "downLoadFile");
    }

    function deleteForum(id, flag, forumId) {
        var deleteUrl = jsURL
                + "?method=deleteDocForum&docResId=${param.docResId}&docLibType=${param.docLibType}&all=${param.all}&forumId="
                + id + "&flag=" + flag;
        var deleteForm = document
                .createElement("<form action='"+deleteUrl+"' target='emptyIframe' method='post'></form>");
        document.body.appendChild(deleteForm);
        deleteForm.submit();
        if (flag == 'true') {
            var requestCaller = new XMLHttpRequestCaller(this,
                    "ajaxDocHierarchyManager", "deleteForumOneTime", false);
            requestCaller.addParameter(1, "Long", '${param.docResId}');
            requestCaller.serviceRequest();
            if (document.getElementById("forums" + id)) {
                document.getElementById("signOpinion").removeChild(
                        document.getElementById("forums" + id));
            }
            var items = document.getElementById("items");

            items.innerText = parseInt(items.innerText, 10) == 0 ? 0
                    : (parseInt(items.innerText, 10) - 1);
            var commentCount = parent.parent.docOpenLabelFrame.document
                    .getElementById("commentCount");
            if (commentCount != null)
                commentCount.innerText = items.innerText;
        } else {
            if (document.getElementById('replyForum' + forumId)
                    && document.getElementById("forEachReply" + id)) {
                document.getElementById('replyForum' + forumId).removeChild(
                        document.getElementById("forEachReply" + id));
            }
        }
    }

    function editDocFromOpen() {
        if ('${dr.mimeTypeId}' != '101' && '${dr.mimeTypeId}' != '102'
                && '${dr.mimeTypeId}' != '120' && '${dr.mimeTypeId}' != '121') {
            var result = v3x
                    .openWindow({
                        url : jsURL
                                + "?method=editDoc&docResId=${param.docResId}&docLibType=${param.docLibType}&projectId=${param.projectId}"
                                + "&isUploadFileMimeType=true",
                        width : 500,
                        height : 450
                    });
            if (result == 'true') {
                parent.location.href = parent.location;
            }
        } else {
            parent.location.href = jsURL
                    + "?method=editDoc&docResId=${param.docResId}&docLibType=${param.docLibType}&projectId=${param.projectId}";
        }
    }

    function docDownLoad(fileId, fileName, theDate) {
        document.getElementById("emptyIframe").src = "/seeyon/fileUpload.do?method=download&fileId="
                + fileId
                + "&createDate="
                + theDate
                + "&filename="
                + encodeURI(fileName);
    }
    function converse(bodyType) {
        if (bodyType === 'OfficeWord') {
            t5ContentType = 41;
        } else if (bodyType === 'OfficeExcel') {
            t5ContentType = 42;
        } else if (bodyType === 'WpsWord') {
            t5ContentType = 43;
        } else if (bodyType === 'WpsExcel') {
            t5ContentType = 44;
        } else if (bodyType === 'Pdf') {
            t5ContentType = 45;
        }
    }
    window.onload = function() {
        //浏览权限html文件不能复制内容
        if (${vo.bodyType=='HTML' && !(param.all || param.edit || param.readOnly)}) {
			document.oncontextmenu = function(){
					return false;
			}
			document.onselectstart = function(){
				return false;
			}
		}
        converse('${vo.bodyType}');
        try {
            showProcDiv();
        } catch (e) {
        }
        setMenuState();
        <c:if test="${isOfficeBodyType}">
        	if (document.getElementById("divScroll")) {
            	document.getElementById("divScroll").className = "";
        	}
        </c:if>
        setTimeout("resizePage()", 500);
		_loadOfficeControll();
		<c:if test="${isImage}">
			showPircture();
		</c:if>
}

function showPircture(){
	var attaArray = new Array();
	var $show = $(".contentText").children();
	 $show.each(function() {
		var map = {};
        var t = $(this);
		var t_id = t.attr("showId");
        var t_date = t.attr("showDate");
        var t_type = t.attr("showType");
		var t_name = "${vo.name}";
		var _src = $(this)[0].src;
		map["dataId"] = t_id;
        map["src"] = _src;
        attaArray.push(map);
	 });

     if(attaArray.length>0){
        var dataTimestamp = new Date().getTime();
        //加时间戳，避免ID重复  OA-101976
        var id = "showImg" + dataTimestamp;
        parent.$($show).touch({
           id: id,//查看器ID，唯一
           datas: attaArray,  //图片数据
           onClick: {
               pre:function(){},
               after:function(){}
            }
         });
      }
		
    }
	function _loadOfficeControll(){
		
		if(typeof(loadOfficeControll)!="undefined"){
			loadOfficeControll();
            document.getElementById("officeFrameDiv").parentElement.parentElement.parentElement.parentElement.setAttribute("style","width:0px;height:0px;overflow:hidden; position: absolute;");
		}	
	}
    function resizePage() {
        var oHeight = parseInt(document.body.clientHeight);
        initFFScroll('docBody', oHeight);
        var oDocBody = document.getElementById('docBody');
        if (oDocBody) {
            var oHtmlContentDiv = document.getElementById('htmlContentDiv');
            if (oHtmlContentDiv) {
                oHtmlContentDiv.style.height = document.documentElement.clientHeight
                        + "px";
            }
        }
        var nHeight = parent.document.getElementById("docOpenBodyFrame").clientHeight;
        document.getElementById("docBody").style.height = nHeight;
        document.getElementById("divScroll").style.height = Math.abs(nHeight-25);
        //上传的图片IE8下渲染问题
        <c:if test="${isImage}">
            var browser=navigator.appName
            var b_version=navigator.appVersion
            var version=b_version.split(";");
            var trim_Version=version[1].replace(/[ ]/g,"");
            if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE8.0"){
                setTimeout(function(){
                    document.getElementById("divScroll").lastChild.firstChild.style.display = "none";
                    document.getElementById("divScroll").lastChild.firstChild.style.display = "block";
                },500);
            }
        </c:if>
    }
//-->
</script>
<style type="text/css">
.contentText {
    margin-left: 35px;
    margin-right: 35px;
    padding-top: 35px;
}

.padding355 {
    padding: 0px 0px 60px 0px;
}

.border_t {
    border-top: 1px solid #b6b6b6;
}
#iSignatureHtmlDiv,#inputPosition {
    font-size: 1px;
    line-height: 1px;
}
p{padding: 0;margin: 0;} 
</style>
</head>
<body scroll="no" class="body-bgcolor">
    <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center"
        style="table-layout: fixed;">
        <tr>
            <td><input class="hidden" value="${t5ContentType}" id="contentType" /> <input type="text"
                class="hidden" value="${vo.bodyType}" id="bodyTypeInput" />
				<input type="text" class="hidden" value="${vo.name}" id="fileNameInput" />
                <div id="docBody" align="center" class="scrollList border_t">
                    <div id="divScroll" style="height: ${(vo.bodyType == 'OfficeWord' || vo.bodyType == 'OfficeExcel' || vo.bodyType == 'WpsWord' || vo.bodyType == 'WpsExcel' || vo.bodyType == 'Pdf') ? '451px' : ''}">
                        <c:if test="${vo.isFile == false || vo.bodyType == 'Pdf'}">
                            <v3x:showContent content="${vo.body}" type="${vo.bodyType}" createDate="${vo.createDate}" htmlId="contentText" viewMode="view" />
                        </c:if>
                        <c:if test="${vo.isFile == true && vo.bodyType == 'HTML'}">
                            <div class="hidden" id="docBodyDIV">${vo.body}</div>
                            <div class="contentText">${vo.body}</div>
                        </c:if>
                        <c:if test="${requireTrans == true && transUrl != null}">
                            <script>
                                document.body.scroll = 'no';
                                trans2Html = true;
                            </script>
                            <iframe style="width:100%;height:100%;" src="${transUrl}"></iframe>
                        </c:if>
                        <c:if test="${vo.isFile == true && vo.bodyType != 'HTML' && vo.bodyType != 'Pdf' && !requireTrans}">
                            <c:if test="${vo.canEditOnline == true}">
                                <div class="hidden" id="docBodyDIV">${vo.body}</div>
                                <input type="text" class="hidden" value="${vo.bodyType}" id="bodyTypeInput" />
                                <v3x:showContent content="${vo.body}" type="${vo.bodyType}" 
                                    createDate="${vo.createDate}" htmlId="contentText" viewMode="view"
                                    officeFileRealSize="${vo.file.size}" />
                                <script type="text/javascript">
                                    if (all == 'true' || edit == 'true'|| readonly == 'true'){
                                        editType = "4,0";
                                    }else{
                                        editType = "0,0";
                                    }
                                </script>
                            </c:if>
                            <c:if test="${vo.canEditOnline == false}">
                                <div class="body-detail-HTML" align="left">
                                    <c:if test="${vo.body!=null && vo.body!=''}">
                                        <div class="contentText">${vo.body}</div>
                                    </c:if>
                                    <br> <br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <c:choose>
                                        <c:when test="${v3x:getBrowserFlagByRequest('HideMenu', pageContext.request)}">
                                                <c:if test="${txtEdit !='txtEdit'}">
                                                <img src="/seeyon/apps_res/doc/images/docIcon/${vo.value}" width="16"
                                                    height="16">&nbsp;
					    		<a target="emptyIframe" onclick="downThisLoadFile()"
                                                    href="/seeyon/fileUpload.do?method=download&fileId=${vo.file.id}&createDate=${vo.createDateString}&filename=${v3x:urlEncoder(vo.file.filename)}&v=${vo.vForDocDownload}"
                                                    class="font-12px"><c:out value="${vo.file.filename}"
                                                        escapeXml="true" /> &nbsp;&nbsp; (${vo.size})</a>
                                                        </c:if>
						&nbsp;
						<br>
                                            <br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					    	</c:when>
                                        <c:otherwise>
                                        	<img src="/seeyon/apps_res/doc/images/docIcon/${vo.value}" width="16"
                                                    height="16">&nbsp;
                                            <a target="emptyIframe" onclick = "javascript:void(0);"
                                                    class="font-12px"><c:out value="${vo.file.filename}"
                                                        escapeXml="true" /> &nbsp;&nbsp; (${vo.size})</a>
                                            <br>
                                            <br>
                                        </c:otherwise>
                                    </c:choose>
                                    <br> <br> <br> <br> <br>
                                </div>
                            </c:if>

                        </c:if>
                    </div>
                    <div id="procDiv1" style="display: none;"></div>
            </td>
        </tr>
    </table>
    </div>
    <iframe id="emptyIframe" name="emptyIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0"
        marginwidth="0" />
    <iframe name="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
        <iframe id="emptyIframeMenu" name="emptyIframeMenu" frameborder="0" height="0" width="0" scrolling="no"
            marginheight="0" marginwidth="0" />
</body>
</html>