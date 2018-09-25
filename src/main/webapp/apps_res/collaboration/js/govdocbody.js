//处理过程中的正文套红
var tempTaohongIsUniteSend = "";
var tempTaohongTemplateType = "";
function mygovdocContentTaohong(bodyType,templateType,orgAccountId) {

    if (bodyType == "HTML" && templateType == "edoc") {
        alert($.i18n("govdoc.htmlnofuntion.text"));
        return;
    }
    if (bodyType == "OfficeExcel" && templateType == "edoc")// excel不能进行正文套红。
    {
        alert($.i18n("govdoc.excelnofuntion.text"));
        return;
    }
    if (bodyType == "WpsExcel" && templateType == "edoc")// excel不能进行正文套红。
    {
        alert($.i18n("govdoc.wpsetnofuntion.text"));
        return;
    }
    if (bodyType == "Pdf" && templateType == "edoc") {
        alert($.i18n("govdoc.pdfnofuntion.text"));
        return;
    }
    if (bodyType == "Ofd" && templateType == "edoc") {
    	alert($.i18n("govdoc.ofdnofuntion.text"));
        return;
    }
    if (bodyType == "gd" && templateType == "edoc") {
        alert($.i18n("govdoc.gdnofuntion.text"));
        return;
    }
    if (bodyType == "-1" && templateType == "edoc") {
        alert($.i18n("govdoc.noContentfuntion.text"));
        return;
    }
    // Ajax判断是否存在套红模板
    if (templateType == "script") {
        bodyType = "";
    }
    if (!hasEdocDocTemplate2(orgAccountId, templateType, bodyType)) {
        if (templateType == 'edoc') {
          $.alert($.i18n('govdoc.docTemplate.record.content.notFound.text',
                    bodyType));
        } else {
            $.alert($.i18n('govdoc.docTemplate.record.notFound'));
        }
        return;
    }

    if (bodyType.toLowerCase() == "officeword"
            || bodyType.toLowerCase() == "wpsword" || templateType == "script") {
        if (templateType == "edoc") {
      
            // 正文套紅將會自動清稿，你確定要這麼做嗎?
            if (confirm($.i18n("govdoc.alertAutoRevisions"))) {
                // 清除正文痕迹并且保存
                if (!removeTrailAndSaveWhenTemplate())
                    return;
            } else {
                return;
            }
        }
		//设置原始正文的ID
       //保存的时候后台生成的ID才是正文真正的ID，JSP页面生成的ID不起作用。
       if(templateType=="script"){bodyType="";}
       window.taohongWhenTemplateWin = getA8Top().$.dialog({
           title:'选择套红模版',
           transParams:{'parentWin':window},
           url: "/seeyon/edocDocTemplate.do?method=taoHongEntry&isAdmin=true&templateType="+templateType+"&bodyType="+bodyType+"&isUniteSend=false&orgAccountId="+orgAccountId,
           targetWindow:getA8Top(),
           width:"350",
           height:"250"
       });
        tempTaohongTemplateType = templateType;
    }
}
var extendArray = new Array();
function taohongShowValue2(res){
	if(parent.document.getElementById("contentRed")){
		var redDocument =  parent.document.getElementById("contentRed").options;
		for(var i=0;i<redDocument.length;i++){
			if(redDocument[i].innerHTML == res){
				redDocument[i].selected = true;
				var taohongTemplete = parent.document.getElementById("taohongTemplete");
				taohongTemplete.value = redDocument[i].value;
				break;
			}	
		}
	}
	
}
/**
 * 模版进行正文套红回调
 * 
 * @param receivedObj
 */
function taohongWhenTemplateCallback2(receivedObj) {
var tempTemplateType = "edoc";
    if (!receivedObj) {
        return;
    }
    var tempIsUniteSend = false;
    var taohongTemplateContentType = "";
    if (tempIsUniteSend == "true" && tempTemplateType == "edoc") {
        var ts = receivedObj[0].split("&");
        taohongTemplateContentType = ts[1];
        receivedObj[0] = ts[0];
    } else {
        var ts = receivedObj.split("&");
        taohongTemplateContentType = ts[1];
        receivedObj = ts[0];
    }
    if (taohongTemplateContentType == "officeword") {
        taohongTemplateContentType = "OfficeWord";
    } else if (taohongTemplateContentType == "wpsword") {
        taohongTemplateContentType = "WpsWord";
    }
	var editframe2 = parent.document.getElementById("editFrame");
	setOfficeOcxRecordID(fileId);
	
	
	officetaohong(editframe2.contentWindow.document.getElementById("sendForm"),
			receivedObj, tempTemplateType, extendArray);
	contentUpdate = true;
	hasTaohong = true;
}

 //ajax判断是否存在套红模板
function hasEdocDocTemplate2(orgAccountId,templateType,bodyType){
  var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocDocTemplateController", "hasEdocDocTemplate4Admin",false);
  requestCaller.addParameter(1, "Long", orgAccountId); 
    requestCaller.addParameter(2, "String", templateType);  
    requestCaller.addParameter(3, "String", bodyType);
    var ds = requestCaller.serviceRequest();  
    //"0":没有，“1”：有  
    if(ds=="1"){return true;}
    else {return false;} 
}




function updateAtt(isSender){
	//修改附件加锁
    var lockWorkflowRe = lockWorkflow(_summaryProcessId, _currentUserId, 16);
    if(lockWorkflowRe[0] == "false"){
        $.alert(lockWorkflowRe[1]);
        return;
    }
    // 取得要修改的附件
    var attachmentList = new ArrayList();
    var keys = fileUploadAttachments.keys();
    // 过滤非正文区域的附件
    var keyIds=new ArrayList();
    for(var i = 0; i < keys.size(); i++) {
    	var att = fileUploadAttachments.get(keys.get(i));
    	if(att.showArea=="showAttFile"||att.showArea=="Doc1"){
    		attachmentList.add(att);
    		keyIds.add(keys.get(i));
    	}
    }
    editAttachments(attachmentList,summaryId,summaryId,'1',keyIds,isSender);
}
//弹出修改附件页面
function editAttachments(atts, reference, subReference, category, keyIds, isSender) {
	if (attActionLog == null) {
		attActionLog = new AttActionLog(reference, subReference, null, atts);
	}
	reference = reference || "";
	subReference = subReference || "";
	var dialog = $.dialog({
		id : "showForwardDialog",
		url : _ctxPath
				+ "/genericController.do?ViewPage=apps/collaboration/fileUpload/attEdit&category="
				+ category + "&reference=" + reference
				+ "&subReference=" + subReference
				+ "&secretLevel="+$("#secretLevel").val()+"&isSender="+isSender,
		title : $.i18n("collaboration.nodePerm.allowUpdateAttachment"),
		targetWindow : getCtpTop(),
		transParams : {
			attActionLog : attActionLog
		},
		closeParam:{
	        'show':true,
	        autoClose:true,
	        handler:function(){
	        	releaseWorkflowByAction(_summaryProcessId, _currentUserId, 16);
	        }
		 },
		width : 550,
		height : 430,
		buttons : [
			{
				id : "okButton",
				text : $.i18n("common.button.ok.label"),
				handler : function() {
					var retValue = dialog.getReturnValue();
					if (retValue) {
						var attachmentList = new ArrayList();
						var inst = retValue[0].instance;
						for (var i = 0; i < inst.length; i++) {
							var att = copyAttachment(inst[i]);
							att.onlineView = false;
							attachmentList.add(att);
						}
						var logList = new ArrayList();
						inst = retValue[1].instance;
						if (inst.length == 0) {
							dialog.close();// 关闭窗口
							return false;
						}
						for (var i = 0; i < inst.length; i++) {
							var att = copyActionLog(inst[i]);
							logList.add(att);
						}
						var save = saveEditAttachments(logList,
								attachmentList);
						if (!save) {
							dialog.close();// 关闭窗口
							return null;
						}
					
						var result = attActionLog.editAtt;
						if (result) {
							// 标记协同内容有变化，关闭页面时需进行判断
							summaryChange();
							// 将修改后的附件，与本地更新。
							var toShowAttTemp = new ArrayList();
							for (var i = 0; i < theToShowAttachments
									.size(); i++) {
								var att = theToShowAttachments
										.get(i);
								toShowAttTemp.add(att);
							}
							for (var i = 0; i < toShowAttTemp
									.size(); i++) {
								var att = toShowAttTemp.get(i);
								if (att.showArea != "showAttFile"
										&& att.showArea != "Doc1") {
									theToShowAttachments
											.remove(att);
								}
							}
							theToShowAttachments = new ArrayList();
							updateAttachmentMemory(result,
									summaryId, summaryId, '');
						} else {
							theToShowAttachments = attachmentList;
							dialog.close();// 关闭窗口
							return;// 沒有修改附件直接返回
						}
						try {
							clearAttOrDocShowArea("attachmentNumberDivshowAttFile");
							clearAttOrDocShowArea("attachmentAreashowAttFile");
							clearAttOrDocShowArea("attachment2NumberDivDoc1");
							clearAttOrDocShowArea("attachment2AreaDoc1");
							hideTr("attachmentTRshowAttFile");
							hideTr("attachment2TRDoc1");
						} catch (e) {

						}
						for (var k = 0; k < keyIds.size(); k++) {
							fileUploadAttachments.remove(keyIds
									.get(k));
						}
						for (var i = 0; i < theToShowAttachments
								.size(); i++) {
							var att = theToShowAttachments.get(i);
							var poi;
							if (att.type == 0) {
								poi = 'showAttFile';
							} else if (att.type == 2) {
								poi = 'Doc1';
							}
							addAttachmentPoiDomain(att.type,
									att.filename, att.mimeType,
									att.createDate ? att.createDate
											.toString() : null,
									att.size, att.fileUrl, false,
									false, att.description,
									att.extension, att.icon, poi,
									att.reference, att.category,
									true, att.isCanTransform, att.v);
						}
                        summaryHeadHeight();
                        if(isSender == 'sender'){//发起人修改附件，立即生效
                        	saveAttachments();
                        }
					}
					if(isSender == 'sender'){//发起人关闭修改附件 框后 立即取消附件锁
						//取消修改附件解锁
						releaseWorkflowByAction(_summaryProcessId, _currentUserId, 16);
					}
					dialog.close();// 关闭窗口
				},
				OKFN : function() {
					if(isSender == 'sender'){//发起人关闭修改附件 框后 立即取消附件锁
						//取消修改附件解锁
						releaseWorkflowByAction(_summaryProcessId, _currentUserId, 16);
					}
					dialog.close();
				}
			}, {
				id : "cancelButton",
				text : $.i18n("common.button.cancel.label"),
				handler : function() {
					if(isSender == 'sender'){//发起人关闭修改附件 框后 立即取消附件锁
						//取消修改附件解锁
						releaseWorkflowByAction(_summaryProcessId, _currentUserId, 16);
					}
					dialog.close();
				}
			} ]
	});
}
  /**
   *  正文类型（具体参考com.seeyon.ctp.common.content.ContentType）：
html(10,"标准格式正文HTML"),
form(20,"表单格式正文"),
txt(30,"text正文"),
officeWord(41,"officeWord正文"),
officeExcel(42,"officeExcel正文"),
wpsWord(43,"wpsWord正文"),
wpsExcel(44,"wpsExcel正文"); 
   */
var contentOfficeId=new Properties();
contentOfficeId.put('0',document.getElementById("currentContentId") == null ? null:document.getElementById("currentContentId").value);
/**
 * 显示编辑器--需要引用office.js，handwrite.js
 */
function _showEditor(flag, isRevertContent) {
	//是否还原正文，默认为true
	isRevertContent = (isRevertContent == null) ? true : false;
		
    if (flag == 'HTML') {
        removeOfficeDiv(isRevertContent);

        oFCKeditor.ReplaceTextarea();
    }
    else if (flag == 'OfficeWord') {
        oFCKeditor.remove();

        showOfficeDiv("doc");
    }
    else if (flag == 'OfficeExcel') {
        oFCKeditor.remove();

        showOfficeDiv("xls");
    }
    else if (flag == 'WpsWord') {
        oFCKeditor.remove();

        showOfficeDiv("wps");
    }
    else if (flag == 'WpsExcel') {
        oFCKeditor.remove();

        showOfficeDiv("et");
    }
    else if(flag == 'Pdf'){
        oFCKeditor.remove();
        showPdfDiv("pdf");
    }
    var bodyTypeObj = document.getElementById("govdocBodyType");
    if (bodyTypeObj) {
    	setContentTypeState(bodyTypeObj.value,flag);
        bodyTypeObj.value = flag;
    }
    //公告新闻预览屏蔽（如果是WORD或者EXCEL）
    try{
	    var bulBottPre = document.getElementById("bulBottPre").value;
	    if (bulBottPre && bulBottPre=='1' ) {
	    	if(flag == 'HTML'){
	    		myBar.enabled('preview');
	    	}else{
	    		myBar.disabled('preview');
	    	}
	    }
    }catch (e) {
	}
}

function showEditor(flag, isRevertContent) {
    //是否还原正文，默认为true
    if(isRevertContent == null||isRevertContent == undefined)
        isRevertContent =  true;

      // 使用CkEditor要先清除，否则新建实例会报错
      function destroyCKEditor(){
      if(CKEDITOR.instances['content']){
        CKEDITOR.instances['content'].destroy();
        document.getElementById('content').style.height = '0px';
        document.getElementById("RTEEditorDiv").style.display="none";
      }
      }
    if (!v3x.useFckEditor) {
      destroyCKEditor(); 
      // 新建公告切换公告格式为Word时需要调整
      if(flag != 'HTML'){
        document.getElementById('content').style.height = '0px';
        document.getElementById("RTEEditorDiv").style.display="none";
      }
    }       
    if (flag == 'HTML') {
        removeOfficeDiv(isRevertContent);
            if(v3x.useFckEditor){
                oFCKeditor.ReplaceTextarea();
            }else{

                initCkEditor();
            }
    }
    else if (flag == 'OfficeWord') {
      if(v3x.useFckEditor) oFCKeditor.remove();

        showOfficeDiv("doc");
    }
    else if (flag == 'OfficeExcel') {
      if(v3x.useFckEditor) oFCKeditor.remove();

        showOfficeDiv("xls");
    }
    else if (flag == 'WpsWord') {
      if(v3x.useFckEditor) oFCKeditor.remove();

        showOfficeDiv("wps");
    }
    else if (flag == 'WpsExcel') {
      if(v3x.useFckEditor) oFCKeditor.remove();

        showOfficeDiv("et");
    }
    else if(flag == 'Pdf'){
      if(v3x.useFckEditor) oFCKeditor.remove();
        showPdfDiv("pdf");
   }
   else if(flag == 'Ofd') {//添加版式组件
        if(v3x.useFckEditor) oFCKeditor.remove();
  	officeParams.fileType = "ofd";
  	showOfficeDiv("ofd");
   }else if(flag == 'gd'){//书生GD正文修改
      if(v3x.useFckEditor) oFCKeditor.remove();
        showSursenDiv("gd");
    }
    var bodyTypeObj = document.getElementById("govdocBodyType");
    if (bodyTypeObj) {
        //setContentTypeState(bodyTypeObj.value,flag);
        bodyTypeObj.value = flag;
    }
    //公告新闻预览屏蔽（如果是WORD或者EXCEL）
    try{
        var bulBottPre = document.getElementById("bulBottPre").value;
        if (bulBottPre && bulBottPre=='1' ) {
            if(flag == 'HTML'){
                myBar.enabled('preview');
            }else{
                myBar.disabled('preview');
            }
            //如果是WpsWord屏蔽转pdf按钮
            var changePdf = document.getElementById("changePdf");
            var bodytype = document.getElementById("govdocBodyType");
            if(changePdf && bodytype && bodytype.value == 'WpsWord'){
                changePdf.style.display = "none";
            }
        }
    }catch (e) {
    }
}


function initCkEditor(){
    var t = null;
    if(document.readyState != "complete"){
        t = setTimeout("initCkEditor()",5);
        return;
    }
    if(t!=null){
        clearTimeout(t);
    }
    // for 公文，向上查两层，确定当前div是否被隐藏
    var p = document.getElementById('content').parentElement;
    var isHide = p.style.display == 'none';
    isHide = isHide ? isHide :  p.parentElement.style.display == 'none';
    // 页面定义了editorStartupFocus变量，则以之控制编辑器是否设置焦点
    var f = (typeof(editorStartupFocus) == 'undefined') ? false : editorStartupFocus;
    var r = (typeof(editorDontResize) == 'undefined') ? false : editorDontResize;
    CKEDITOR.replace('content',{
      toolbar:oFCKeditor.ToolbarSet,
      height : '100%',
      startupFocus : !isHide && f,
      on : {
          instanceReady : function( ev ) { 
              var input = document.getElementById('content');
              function getTop(e){
                var offset=e.offsetTop;
                if(e.offsetParent!=null)offset += getTop(e.offsetParent);
                return offset;
              }
              function resizeEditor(){
                  var editor = CKEDITOR.instances['content'];
                  if(!editor) return;
                  var space = editor.ui.space( 'contents' );
                  if(space==null) return;
                  var height = document.documentElement.clientHeight - getTop(space.$) - 5;
                  height = height<0 ? 0 : height;
                  space.setStyle( 'height', height +'px' );
                  document.getElementById("RTEEditorDiv").style.display="block";
                  // 解决chrome resize时正文区域变宽问题
                  var iframe = editor.window.getFrame();
                  if(iframe.$.style.width != '786px'){
                    iframe.$.style.width = '786px';
                  }                  
              }
              resizeEditor();
              window.onresize = function(event) {
                  if(r) return;
                  resizeEditor();
              }
            // 为了避免onbeforeunload弹出提示，必须对a作特殊处理
            if(v3x && v3x.isMSIE){
                ev.editor.on('dialogShow', 
                        function(dialogShowEvent){
                            var allHref = dialogShowEvent.data._.element.$.getElementsByTagName('a');
                            for (var i = 0; i < allHref.length; i++) {
                                var href = allHref[i].getAttribute('href');
                                if(href && href.indexOf('void(0)')>-1){
                                    allHref[i].removeAttribute('href');
                                }
                            };

                });      
            }                
          }
      }
    });         
}
/****************************************/
/************** 正文类型切换 **************/
/****************************************/
/**
 * 选择类型事件
 */
function _changeBodyType(bodyType,callbackFunc) {
	if(bodyType==10){
		bodyType="HTML";
	}else if(bodyType==41){
		bodyType="OfficeWord";
	}else if(bodyType==42){
		bodyType="OfficeExcel";
	}else if(bodyType==43){
		bodyType="WpsWord";
	}else if(bodyType==44){
		bodyType="WpsExcel";
	}else if(bodyType==45){
		bodyType="Pdf";
	}
    var bodyTypeObj = document.getElementById("govdocBodyType");
    if (bodyTypeObj && bodyTypeObj.value == bodyType) {
        return true;
    }
        //【公文】清空office的id.先保存Office,然后切换到HTML，content这个Div中会保存OFFICE 正文的ID
    //var appName=document.getElementById("appName");
    if(bodyType=='HTML'){
		var contentObj=document.getElementById("content");
		if(contentObj)
		{
			contentObj.value="";
		}
    }
    
    //if (confirm(v3x.getMessage("V3XLang.common_confirmChangBodyType"))) {
    if (confirm($.i18n('content.switchtype.message'))) {
    	//var changePdf = document.getElementById("changePdf");
    	//if(changePdf){
	    //	if(bodyType == "OfficeWord" || bodyType == "WpsWord"){
	    //		changePdf.style.display = "";
	    //	}else{
	   /// 		changePdf.style.display = "none";
	   // 	}
    	//}
        showEditor(bodyType, true);
        
        if (callbackFunc)
        	callbackFunc();
        
        return true;
    }

    return false;
}


function changeBodyType(bodyType, changeBodyTypeCallBack) {
 if (confirm($.i18n('content.switchtype.message'))) {
    bodyType = convertContentType_valueToString(bodyType);
    var bodyTypeObj = document.getElementById("govdocBodyType");
    if (bodyTypeObj && bodyTypeObj.value == bodyType) {
        return true;
    }else{
		bodyTypeObj.value = bodyType
	}
    
    //if (myBar) {
        if (bodyType == "HTML") {
        	if(clearOfficeFlag)clearOfficeFlag();
            //myBar.enabled("preview");
        } else {
            //myBar.disabled("preview");
        }
    //}
    
    //【公文】清空office的id.先保存Office,然后切换到HTML，content这个Div中会保存OFFICE 正文的ID
    //var appName=document.getElementById("appName");
    if(bodyType=='HTML'){
        var contentObj=document.getElementById("content");
        if(contentObj)
        {
            contentObj.value="";
        }
    }
    
	    //Word转PDF正文显示
        var changePdf = document.getElementById("changePdf");
        if(changePdf){
            if(bodyType == "OfficeWord" || bodyType == "WpsWord"){
                changePdf.style.display = "";
            }else{
                changePdf.style.display = "none";
            }
        }
        var share_weixin1 = document.getElementById("share_weixin_1");
        var share_weixin2 = document.getElementById("share_weixin_2");
        if(share_weixin1 && share_weixin2){
            if(bodyType == "HTML"){
                share_weixin1.style.display = "";
                share_weixin2.style.display = "";
            }else{
                share_weixin1.style.display = "none";
                share_weixin2.style.display = "none";
            }
        }
        if("Ofd"!=bodyType){
        	showEditor(bodyType, true);
        }
       // if(appName && appName.value=='4'){
            if(bodyType == "OfficeWord" || bodyType == "WpsWord"){
                //BDGW-1450 快速发文正文类型切换后，正文套红变灰
                // 拷过来的代码有问题，resetTaohongList resetTaohongList()两个都未定义
                //if(typeof(resetTaohongList)!='undefined'){
                //    resetTaohongList();
                    var taohongselectObj = document.getElementById("fileUrl");
                    if(taohongselectObj){
                        taohongselectObj.disabled = false;
                    }
                //}
            }else{
                var taohongselectObj = document.getElementById("fileUrl");
                if(taohongselectObj){
                    taohongselectObj.disabled = true;
                }
            }
        //}
        
        if(typeof(changeBodyTypeCallBack)!='undefined'){
        	changeBodyTypeCallBack();
        }
        return true;
    }
    return false;
}

//模板打开正文
function openNewEditWin()
{
  if(canUpdateContent){contentUpdate=true;}
  var isFormTemplete = "isFromTemplete";
  //来自公文模板打开正文
  popupContentWin(isFormTemplete);
}

/**
*
* @param isNew 是否新建正文入口
* @param isSign 是否签章
*/
function dealPopupContentWin(isNew, isSign) {
 //try{
 //if(window.document.readyState!="complete") {return false;}
	var bodyType = document.getElementById("govdocBodyType").value;

	var edocType = document.getElementById("edocType");//收文的时候不能刷新
	var templeteBodyTypeObj = document.getElementById("templeteBodyTyep");
  	var templeteBodyType;
  	if(templeteBodyTypeObj){
    	templeteBodyType=templeteBodyTypeObj.value;
  	}
	var isSystemTemplate;
  	var isSystemTemplateObj = document.getElementById("isSystemTemplate");
  	if(isSystemTemplateObj){
    	isSystemTemplate=isSystemTemplateObj.value;
 	}
	//var commOjb=document.getElementById("comm");
    if(bodyType == "OfficeWord" || bodyType == "OfficeExcel" || bodyType == "WpsWord" || bodyType == "WpsExcel") {
      var contentNum = 0;
      //var forwordtosend=document.getElementById("forwordtosend");//办文转起草标识
      
      //var forwordtosend=document.getElementById("forwordtosend").value;
      var newOfficeId=contentOfficeId==null ? null : contentOfficeId.get(contentNum,null);
      //if(newOfficeId && forwordtosend && (forwordtosend.value != '1')){
        if(newOfficeId && newOfficeId!=null && newOfficeId!=getOfficeOcxCurVerRecordID())
        {
          //askUserSave(true);
          setOfficeOcxRecordID(newOfficeId);
          //为保证印章有效，控件FileName参数属性必须和改章的时候的参数一样，所以复制一份后要想保证原来印章有效，这个参数不能变化
          //document.getElementById("contentNameId").value=contentOfficeId.get("0",null);
          //theform.currContentNum.value=contentNum;
          contentUpdate=false;
        }
      //}
    }
    try{
    	popupContentWin(isNew,officecanPrint);
    }catch(e){
    	popupContentWin(isNew,isSign);
    }
 // }catch(e){}
}


/**
 * 弹出正文窗口
 */
function popupContentWin(isNew,isSign) {
    //if (window.document.readyState != "complete") {
    //    return false;
    //}
    var bodyType = document.getElementById("govdocBodyType").value;
    if (bodyType == "HTML") {
        var isFromTemplete = false;
        for (var i = 0; i < arguments.length; i++) {
            var tempArg = arguments[i];
            if (tempArg == 'isFromTemplete') {
                isFromTemplete = true;
                break;
            }
        }
        var tempUrl = fullEditorURL;
      //  if (typeof (sendEdocId) != "undefined") {
       //     tempUrl = tempUrl + "&sendEdocId=" + sendEdocId;
       // }
      //  var summaryIdObj = document.getElementById("summaryId");
      //  if (summaryIdObj) {
      //      tempUrl += "&summaryId=" + summaryIdObj.value;
      //  }
        if (isFromTemplete) {
            // 来自公文模板，不检查正文是否被并发修改；
            if (contentUpdate == false) {
                tempUrl += "&canEdit=false";
            } else {
                tempUrl += "&canEdit=true";
            }
            tempUrl += "&isFromTemplete=true";
        } else {
            // 非公文模板，检查正文是否被并发修改；
          //  if ((contentUpdate &&contentUpdate == false)
           //         || (checkConcurrentModifyForHtmlContent(summaryId) && (summaryId != -1 && summaryId != 0))) {
           //     tempUrl += "&canEdit=false";
           // } else {
                tempUrl += "&canEdit=true";
          //  }
        }

        if (typeof (officecanPrint) != "undefined" && officecanPrint != null) {
            tempUrl += "&canPrint=" + officecanPrint;
        } else {
            tempUrl += "&canPrint=true";
        }
        window.popupContentEditWin = getA8Top().$.dialog({
            title:'致远政务协同管理软件',
            transParams:{'parentWin':window},
            url: tempUrl,
            targetWindow:getA8Top(),
            width: getA8Top().screen.availWidth,
            height: getA8Top().screen.availHeight
        });

    } else if (bodyType == "Pdf") {
        pdfFullSize();
    } else if (bodyType == "Ofd") {
    	var canEditContent = false;
    	//新增和编辑公文时可编辑
    	if((isNew && ((typeof(isFenban)!="undefined"&&isFenban!="true")||typeof(isFenban)=="undefined"))
    			||("undefined"!= typeof(curSummaryID)&&""!=curSummaryID)) {
    		canEditContent = true;
    	}
    	window.ofdobject = getA8Top().$.dialog({
    		title : '版式文档',
    		closeParam:{'show':false},
    		transParams : {
    			'parentWin' : window,
    			"fileId" : officeParams.fileId,
    			"originalFileId":officeParams.originalFileId,
    			"filename" : officeParams.fileId + ".ofd",
    			"webRoot" : officeParams.webRoot,
    			"canEditContent" :canEditContent,
    			"paras" : officeParams,
    			"popWinName" : "ofdobject",
    			"isSign":isSign,
    			"popCallbackFn" : function() {
    				alert('FShowOFD.html');
    			}
    		},
    		url : officeParams.webRoot + "/common/ofd/ofd.html",
    		targetWindow : this.parent.getA8Top(),
    		width : this.parent.getA8Top().screen.availWidth,
    		height : this.parent.getA8Top().screen.availHeight
    	});
    } else if(bodyType == "gd"){
    	SursenFullSize();
    }else {
        fullSize();
    }
}

function GovdocPdfFullSize(){
	pdfFullSize();
}

function saveOcx(isTemplate,isSavaDraft){
  var govdocBodyType = document.getElementById("govdocBodyType").value;
  if(govdocBodyType == 'Pdf'){
      //验证控件是否有效
      if(!officeEditorFrame.isHandWriteRef()){
        return;
      }
      return savePdf_govdoc(null,isTemplate,isSavaDraft);
  //}else if(govdocBodyType=='gd'){
	//   return saveSursen();  
  }else{
	  if(typeof(govDocFormType)!="undefined" && govDocFormType == 6){
		  return true;
	  }else{
		  return _saveOffice();
	  }
  }
}
function WebClose(){
	try{
		officeEditorFrame.WebClose();
	}catch(e){}
}


function _saveOffice()
{
  try{
  //var comm=document.getElementById("comm").value;
    var govdocBodyType = document.getElementById("govdocBodyType").value;
    //if(bodyType!="HTML" && comm=="register" && canUpdateContent==false)
    //登记正文编辑由开发控制，分发正文暂不做控制--唐桂林
   // if(govdocBodyType!="HTML" && typeof(currentPage)!="undefined" && currentPage=="newEdoc")
   // {//登记时office正文不可以修改，保存前修改为可编辑模式，否则不保存
   //   updateOfficeState("1,0");
   // }
  }catch(e)
  {
    alert(e.description);
  }
  return saveOffice_govdoc();
}


function savePdf_govdoc(type,isTemplate,isSavaDraft){
    var bodyType = document.getElementById("govdocBodyType");
    if(bodyType && bodyType.value != 'Pdf' ){
         return true;
    }
    try{
      document.getElementById("content").value = fileId;
    }catch(e){}
    
    return officeEditorFrame.savePdf(type,isTemplate,isSavaDraft);
}

function saveOffice_govdoc(stdOffice){
  //兼容迁移应用，如果没有bodyType，就不判断
  var govdocBodyType = document.getElementById("govdocBodyType");
  if(govdocBodyType){
    govdocBodyType = govdocBodyType.value;
    if(govdocBodyType != 'OfficeWord' && govdocBodyType != 'OfficeExcel' && govdocBodyType != 'WpsWord' && govdocBodyType != 'WpsExcel'){
      return true;
    }
  }
	
	try{
	  document.getElementById("content").value = fileId;
	}catch(e)
	{
	}
	try{
		var flag = officeEditorFrame.saveOffice(stdOffice);
		return flag;
	}catch(e){
		return false;
	}
}


function convertContentType_valueToString(bodyType){
	var sv;
	if(bodyType==10){
		sv="HTML";
	}else if(bodyType==41){
		sv="OfficeWord";
	}else if(bodyType==42){
		sv="OfficeExcel";
	}else if(bodyType==43){
		sv="WpsWord";
	}else if(bodyType==44){
		sv="WpsExcel";
	}else if(bodyType==45){
		sv="Pdf";
	}else if(bodyType==46){
		sv="Ofd";
	}
	return sv;
}

function convertContentType_StringToValue(bodyType){
	var sv;
	if(bodyType=="HTML"){
		sv=10;
	}else if(bodyType=="OfficeWord"){
		sv=41;
	}else if(bodyType=="OfficeExcel"){
		sv=42;
	}else if(bodyType=="WpsWord"){
		sv=43;
	}else if(bodyType=="WpsExcel"){
		sv=44;
	}else if(bodyType=="Pdf"){
		sv=45;
	}else if(bodyType=="Ofd"){
		sv=46;
	}
	return sv;
}

function getHtmlContent()
{
	var content,fckEditor,ckeditor,edocContentText;
	if(typeof(htmlContentIframe) != "undefined"){
		content = htmlContentIframe.document.getElementById("content");
		if(typeof(htmlContentIframe.oFCKeditor) != "undefined"){
			fckEditor = htmlContentIframe.oFCKeditor;
			ckeditor = htmlContentIframe.CKEDITOR.instances['content'];
		}	
		edocContentText = htmlContentIframe.document.getElementById("edoc-contentText");
	}else{
		content = document.getElementById("content");
		if(typeof(oFCKeditor) != "undefined"){
			fckEditor = oFCKeditor;
			ckeditor = CKEDITOR.instances['content'];
		}
		edocContentText = document.getElementById("edoc-contentText");
	}
  var str="";
  if(content!=null && (typeof(fckEditor) != "undefined"))
  {
	if((typeof(fckEditor) != "undefined")){
      str = fckEditor.GetContent();
    }else{
      str = ckeditor.getData()
    }
  }
  else
  {//浏览状态,正文放到Div里面了
    str = edocContentText.innerHTML;
  }
  return str;
}

/**
 * 修改HTML正文回调函数
 * 
 * @param rv
 */
function popupContentWinCallback(rv) {
	if(rv == null) return;
	if (document.getElementById("content") != null
            && (typeof (oFCKeditor) != "undefined")) {
        oFCKeditor.SetContent(rv);
        oFCKeditor.remove();// 鎻愪氦鐨勬椂鍊欎笉鍦ㄦ嫹璐濈紪杈戝尯鍩熷埌杈撳叆text;
        //CKEDITOR.instances['content'].setData(rv);
		try{
			document.getElementById('showGovdocHtmlContent').contentWindow.document.getElementById("edoc-contentText").innerHTML = rv;
		}catch(e){}
    } else {
        if (typeof (htmlContentIframe) != "undefined") {
            htmlContentIframe.document.getElementById("edoc-contentText").innerHTML = rv;
        } else {
        	document.getElementById('showGovdocHtmlContent').contentWindow.document.getElementById("edoc-contentText").innerHTML = rv;
        }
    }
}

function canStopFlow(workitemId){
	  var requestCaller = new XMLHttpRequestCaller(this, "edocManager", "canStopFlow",false);
	  requestCaller.addParameter(1, "String", workitemId);  
	  var rs = requestCaller.serviceRequest();
	  return rs;
}

//修改公文正文
function ModifyContent(){
	return officeEditorFrame.ModifyGovdocContent();
}

//打开正文盖章
function openGovdocSignature()
{
    if(!isShowContent() || "false" == showContentByGovdocNodePropertyConfig){
  	  $.alert($.i18n("govdoc.can.not.do.operation"));
  	  return;
    }
	var bodyType = document.getElementById("bodyType").value;
	 if (bodyType == "HTML") {
        alert($.i18n("govdoc.htmlnofuntion.text"));
        return;
     }
	 if(bodyType == "Ofd"){
		 alert("OFD不支持盖章操作!");
	        return;
	 }
	//永中office不支持wps正文修改
	var isYozoWps = checkYozo();
	if(isYozoWps){
		return;
	}
	//签章枷锁
	  var re = lockWorkflow(_summaryProcessId, _currentUserId, 18);
	  if(re[0] == "false"){
	    parent.parent.$.alert(re[1]);
	    return;
	  }
	summaryChange();
	if(bodyType=="gd"){
		 alert(_("edocLang.edoc_gdnofuntion"));
	      return;
	}
/*	var puobj = getProcessAndUserId();
	var re = EdocLock.lockWorkflow(puobj.summaryId, puobj.currentUser,EdocLock.UPDATE_CONTENT);
	if(re[0] == "false"){
	    parent.parent.$.alert(re[1]);
	    return;
	}*/
  //签章加锁
  isCheckContentEdit=false;
  if(bodyType=="HTML")
  {
	  showGovdocContent(summaryId);
	  showGovdocHtmlContent.doSignature("",false);
  }else if(bodyType=="Pdf"){
     popupContentWin();
     contentUpdate=true;
  }else if(bodyType=="Ofd"){
	     popupContentWin(false,true);
  }else
  {
    //联合发文套多次正文后，是否进行了保存
    var isUniteSend=document.getElementById("isUniteSend").value;
    if(isUniteSend=="true")
    {
      //GOV-4589 公文复核节点权限点击签章报网页错误（修改引起，跑第一轮用例时没有此问题）
      var curContentNum= theform.currContentNum.value;
      var curRecordId=contentOfficeId.get(curContentNum,null);
      if(curRecordId==null)
      {//刚刚进行了正文套红，正文还没有保存
        if(window.confirm(_("edocLang.edoc_contentNoSave"))==false){return;}
        var newRecordId=checkExistBody();
          askUserSave(false);
        contentOfficeId.put(curContentNum,newRecordId);
      }
    }
/* 签章前一定要检查文号嘛？先屏蔽    if(!checkDocMarkBeforeSignature()){
    	return false;
    }*/
    
    WebOpenSignature();
    //盖章的时候要设置为可编辑状态，否则专业签章的按钮显示不对
    var ocxObj;
    if(officeEditorFrame){
      ocxObj=officeEditorFrame.document.getElementById("WebOffice");
      if(ocxObj){
        ocxObj.EditType="1,0";
      }
    }
    contentUpdate=true;
  }  
  //OFD不计算数字
  if(bodyType!="Ofd" && officeEditorFrame&&typeof(officeEditorFrame.getSignatureCountCount)!='undefined'){
	  SignatureCount = getSignatureCountCount();
  }
  
  changeSignature = true ;
}
//读取文件名称,默认跟id一致
function getOcxFileName(){
	if(typeof(myContentNameId)!='undefined'&&myContentNameId!=''){
		return myContentNameId;
	}
	var cObj=document.getElementById("myContentNameId");
	if(cObj!=null && cObj.value!="")
	{
		return cObj.value;
	}
	else
	{
		return fileId;
	}
}
/**
 *
 * @param id
 */
function showGovdocOfdConent(id){
	if (typeof(id) =="undefined" || id == null){
		//id = getOcxFileName();
		if(typeof(myContentNameId)!='undefined'&&myContentNameId!=''){
			id=myContentNameId;
		}
		var cObj=document.getElementById("myContentNameId");
		if(cObj!=null && cObj.value!=""){
			id = cObj.value;
		}
	}
	var paras = officeParams;
	window.ofdobject = getA8Top().$.dialog({
		title : '版式文档',
		closeParam:{'show':false},
		transParams : {
			'parentWin' : window,
			"fileId" : id,
			"filename" : id + ".ofd",
			"webRoot" : paras.webRoot,
			"sessionparas" : paras,
			"popWinName" : "ofdobject",
			"popCallbackFn" : function() {
				alert('FShowOFD.html');
			}
		},
		url : paras.webRoot + "/common/ofd/ofd.html",
		targetWindow : this.parent.getA8Top(),
		width : this.parent.getA8Top().screen.availWidth,
		height : this.parent.getA8Top().screen.availHeight
	});
}
