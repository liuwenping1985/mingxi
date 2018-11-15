<%@ include file="../header.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.InetAddress,com.seeyon.ctp.common.taglibs.functions.Functions"%>

<%
//OA-26762 修复参数脚本注入漏洞
String type = request.getParameter("type");
// type = type==null?"":type.replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\"","\\\"");
type = Functions.toHTML(type);
String extensions = request.getParameter("extensions");
extensions = extensions==null?"":extensions.replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\"","\\\"");
String applicationCategory = request.getParameter("applicationCategory");
//applicationCategory = applicationCategory==null?"":applicationCategory.replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\"","\\\"");
applicationCategory = Functions.toHTML(applicationCategory);
String destDirectory = request.getParameter("destDirectory");
destDirectory = destDirectory==null?"":destDirectory.replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\"","\\\"");
String destFilename = request.getParameter("destFilename");
destFilename = destFilename==null?"":destFilename.replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\"","\\\"");
String maxSize = request.getParameter("maxSize");
maxSize = maxSize==null?"":maxSize.replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\"","\\\"");
String isEncrypt = request.getParameter("isEncrypt");
isEncrypt = isEncrypt==null?"":isEncrypt.replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\"","\\\"");

String pMaxSize = request.getParameter("maxSize");
if(!com.seeyon.ctp.util.Strings.isBlank(pMaxSize)){                         
   %>
   <c:set var="maxSize" value="<%=com.seeyon.ctp.util.Strings.formatFileSize(Long.parseLong(pMaxSize), false) %>"/>
   <%          
}
%>
<html style="height: 100%">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n("fileupload.page.title")}</title>
<link rel="stylesheet" href="${path}/common/all-min.css">
<link rel="stylesheet" href="${path}/skin/default/skin.css">
<c:if test="${e ne null}">
    <script type="text/javascript">
    var _parent = typeof(transParams)!="undefined" ? transParams.parentWin : null;
    if( typeof(_parent)=='undefined' || _parent == null){
        _parent = window.parent;
    }
    if(typeof(_parent)=='undefined' || _parent == null){
        _parent = window.dialogArguments;
    }
    alert("${v3x:showException(e, pageContext)}");
    //parent.again();
      if((_parent!=undefined)&& (_parent.again!=undefined))
	{
		_parent.again();
	}
    else
	{
    	window.close();
	}
    </script>
</c:if>

<script type="text/javascript">//Attachment(id, reference, subReference, category, type, filename, mimeType, createDate, size, fileUrl, description){

<%
    Object msg = request.getAttribute("upload.event.message");
%>
<%if(msg!=null){%>
    alert('<%=msg%>');
<%}%>
//判断是否安装了精灵
var isA8geniusAdded = false;

<c:if test="${isA8geniusAdded}">
    isA8geniusAdded = true;
</c:if>

<c:if test="${atts != null}">
    try {
      getA8Top().endProc();
    } catch(e) {
    } 
	
    var callback = null;
    <c:if test="${not empty param.callback}" >
        if(parent.${param.callback}) callback = parent.${param.callback};
    </c:if>      
    var reAtts= new ArrayList();
    var fileurls="";
    <c:forEach items="${atts}" var="att">
        fileurls=fileurls+","+'${att.fileUrl}';
        reAtts .add(new Attachment("${att.id}",  "${att.reference}", "${ att.subReference}", "${ att.category}", "${ att.type}",
            "${ att.filename}", "${ att.mimeType}", "<fmt:formatDate value='${ att.createdate}' pattern='yyyy-MM-dd'/>", "${ att.size}", "${ att.fileUrl}", '', 
            null, "${ att.extension}", "${ att.icon}",  true,  'true',"${att.v}"));
       
    </c:forEach>
    <c:if test="${(empty param.targetAction and empty param.callMethod )  or (not empty param.callMethod and 'false' eq param.takeOver)}" >
        <c:forEach items="${atts}" var="f">
            <fmt:formatDate value="${f.createdate}" pattern="yyyy-MM-dd HH:mm:ss" var="createDate" />
            <c:if test="${empty param.attachmentTrId}" >
            if(callback){
              callback('${f.type}', '<v3x:out value="${f.filename}" escapeJavaScript="true" />', '${f.mimeType}', '${createDate}', '${f.size}', '${f.fileUrl}',null,null,'${f.extension}','${f.icon}',"${f.v}");
            }else{
              parent.addAttachment('${f.type}', '<v3x:out value="${f.filename}" escapeJavaScript="true" />', '${f.mimeType}', '${createDate}', '${f.size}', '${f.fileUrl}',null,null,'${f.extension}','${f.icon}',"${f.v}");
            }
            </c:if>
            <c:if test="${not empty param.attachmentTrId}" >
            parent.addAttachmentPoi('${f.type}', '<v3x:out value="${f.filename}" escapeJavaScript="true" />', '${f.mimeType}', '${createDate}', '${f.size}', '${f.fileUrl}',null,null,'${f.extension}','${f.icon}', '${param.attachmentTrId}', null,'<%=applicationCategory%>',null,null,'${param.embedInput}',null,null,"${f.v}",null,'${ param.isShowImg}');
            </c:if>         
         </c:forEach>
    </c:if>
   
    <c:if test="${not empty param.targetAction or not empty param.callMethod}" >
        <c:if test="${'true' ne param.firstSave}">
        parent.callforward(fileurls.substring(1),"${param.repeat}");
        </c:if>
        <c:if test="${'true' eq param.firstSave}">
        parent.callforward(reAtts,"${param.repeat}");
        </c:if>
    </c:if>
    <c:if test="${param.closeWindow != 'false'}">
    if(!isA8geniusAdded){     
         //parent.window.close();
		 windowClose();
      }   
    </c:if>
</c:if>

var number = 0;
function checks(){
    if(number == 0 || files.isEmpty()){
        //return false;
         alert("${ctp:i18n_1('fileupload.selectfile.label',maxSize)}");
        return ;
    }
    
    //$("#b1").disable();
    document.getElementById("b1").disabled = true;
    show();
    
    for(var i = 1; i <= index; i++){
        var o = document.getElementById("file" + i);
        if(!o){
            continue;
        }

        if(!o.value){
            document.getElementById("fileInputDiv" + i).parentNode.removeChild(document.getElementById("fileInputDiv" + i));
        }
    }
    if($("#importExplain").size()>0)
    	{
    	   $("#importExplain").removeAttr("onclick");//OA-121629防护处理，防止由于提交过程中点击“导入说明”，造成窗口无法关闭
    	}
    document.getElementById('form_upload').submit();
    //return true;

}

function checkExtensions(obj){
    var filepath = obj.value;
    if (!filepath) {
        return false;
    }
    
    var extensionstr = document.getElementById("extensions").value;
    if(!extensionstr){
        return true;
    }

    var lastSeparator = filepath.lastIndexOf(".");
    if (lastSeparator == -1) {
        return true;
    }
    else{
        if(extensionstr){
            var extension = filepath.substring(lastSeparator + 1).toLowerCase();
            var extensions = extensionstr.split(",");
            
            for(var i=0; i<extensions.length; i++) {
                if(extensions[i] == extension){
                    return true;
                }
            }
        }
    }

    alert("${ctp:i18n_1('fileupload.exception.UnallowedExtension',ctp:toHTML(param.extensions))}");
    
    return false;
}

function show(){
    //document.getElementById("b1").disabled = true;

    document.getElementById("upload1").style.display = "none";
    document.getElementById("uploadprocee").style.display = "";
/*     if(isA8geniusAdded){
        document.getElementById("selectFile").style.display = "none";     
        document.getElementById("fileProcee").style.display = "";  
    } */
}

function addAttachment(type, filename, mimeType, createDate, size, fileUrl, canDelete, needClone,extension,icon,v){
    //var _parent = window.opener;
	  var _parent = typeof(transParams)!="undefined" ? transParams.parentWin : null;
    if(_parent == null){
        _parent = window.dialogArguments;
    }
    var callback = null;
    <c:if test="${not empty param.callback}" >
        if(_parent.${param.callback}) callback = _parent.${param.callback};
    </c:if>      

    if(callback){
        callback(type, filename, mimeType, createDate, size, fileUrl, canDelete, needClone,'',extension,icon,null,null,false,v);
    }else{
        _parent.addAttachment(type, filename, mimeType, createDate, size, fileUrl, canDelete, needClone,'',extension,icon,null,'<%=applicationCategory%>',false,null,false,false,v); 
    }
     
    //根据这个变量来判断是否选择了附件。
    if(typeof(_parent.hasUploadAtt)!= 'undefined') _parent.hasUploadAtt=true;
        
}
function windowClose(){
	if(getCtpTop().addattachDialog){
		getCtpTop().addattachDialog.close();
	}else if(getA8Top().addattachDialog){
	    getA8Top().addattachDialog.close();
	}else if(parent.addattachDialog){
		parent.addattachDialog.close();
	}else if(parent.parent.addattachDialog){
		parent.parent.addattachDialog.close();
	}else{
		parent.window.close();
	}
}
function addAttachmentPoi(type, filename, mimeType, createDate, size, fileUrl, canDelete, needClone,extension,icon,poi, reference, category, onlineView, width, embedInput,hasSaved,isCanTransform,v,canFavourite, isShowImg){
  //var _parent = window.opener;
  var _parent = typeof(transParams)!="undefined" ? transParams.parentWin : null;
  if( typeof(_parent)=='undefined' || _parent == null){
      _parent = window.dialogArguments;
  }
  if( typeof(_parent)=='undefined' || _parent == null){
      _parent = window.parent;
  }
  _parent.addAttachmentPoi(type, filename, mimeType, createDate, size, fileUrl, canDelete, needClone,'',extension,icon,poi, reference, category, onlineView, width, embedInput,hasSaved,isCanTransform,v,canFavourite, isShowImg); 


//if(_parent.autoSet_LayoutNorth_Height)_parent.autoSet_LayoutNorth_Height()
  //根据这个变量来判断是否选择了附件。
  if(typeof(_parent.hasUploadAtt)!= 'undefined') _parent.hasUploadAtt=true;
/*  if(!isA8geniusAdded){
      window.close();
  }        */   
}

function callforward(fileurls,repeat){
	       // var _parent = window.opener;
  var _parent = typeof(transParams)!="undefined" ? transParams.parentWin : null;
  <c:if test="${not empty param.targetAction}" >

        if(_parent == null){
            _parent = window.dialogArguments;
        }
        if( typeof(_parent)=='undefined' || _parent == null){
            _parent = window.parent;
        }
        _parent.${ param.targetAction}(fileurls,repeat);
         //window.close();
     </c:if>
     <c:if test="${not empty param.callMethod}" >
     //var _parent = window.opener;
     if(_parent == null){
         _parent = window.dialogArguments;
     }
     if( typeof(_parent)=='undefined' || _parent == null){
         _parent = window.parent;
     }
     _parent.${ param.callMethod}(fileurls,repeat);
      //window.close();
  </c:if>
}
function listenerKeyPress(){
    if(event.keyCode == 27){
        //window.close();
    }
}

function again(){
    document.getElementById("b1").disabled = false;
    //$("#b1").enable(); 
    document.getElementById("upload1").style.display = "";
    document.getElementById("uploadprocee").style.display = "none";
    if(isA8geniusAdded){
        document.getElementById("selectFile").style.display = "none";     
        document.getElementById("fileProcee").style.display = "";  
    }
    
    number = 0;
    files.clear();
    
    document.getElementById("fileNameDiv").innerHTML = " <li><a>&nbsp;</a></li>";
    document.getElementById("fileInputDiv").innerHTML = "";
    
    addInput(index);
}
var quantity = 9999;
// 参数限制文件数小于5时，安装了精灵也受控，否则不受参数限制
var paramQuantity = <c:out value="${param.quantity}" default="5" />;
if(isA8geniusAdded){
    quantity = (paramQuantity<5)?paramQuantity:quantity;
}else{
    quantity = paramQuantity;
}
var index = 1;

var files = new Properties();
var geniusNum = 0;

var isExtensions=0;
function addNextInput(obj){
	isExtensions=0;
    if(files.values().contains(obj.value)){
        removeInput(index);
        addInput(index);

        alert('${ctp:i18n("fileupload.uploading.upload_alert_exist")}');
        return false;
    }
    try{
		var fileSelected=obj.files[0];
	    var maxSize = "${(not empty param.maxSize) ? param.maxSize : v3x:getSystemProperty('fileUpload.maxSize')}";
        var maxSizeInt=parseInt(maxSize);
		if(fileSelected.size>maxSizeInt)
			{
				removeInput(index);
                addInput(index);
				alert(fileSelected.name+",${ctp:i18n_1('fileupload.exception.MaxSize',maxSize)}");
				//document.getElementById("fileInputDiv" + i).parentNode.removeChild(document.getElementById("fileInputDiv" + i));
				return false;
			}
       }
   catch(error)
      {
	
      }
    if(!checkExtensions(obj)){
        isExtensions=1;
        removeInput(index);
        addInput(index);
        return false;
    }

    if( number >= quantity){
        removeInput(index);
        addInput(index);
        
        alert($.i18n("fileupload.uploading.upload_alert_limit").format(number));
        //alert('${ctp:i18n("fileupload.uploading.upload_alert_limit")}');
        return false;
    }

    number++;
    document.getElementById("fileInputDiv" + index).style.display = 'none';
    var s = obj.value.lastIndexOf("\\");
    if(s < 0){
        s = obj.value.lastIndexOf("/");
    }
    var filename = obj.value.substring(s + 1);
    var nameHTML = "";
    //<li><span title="图片上传的附件.jpg">图片上传的附件.jpg</span><em class="ico16 revoked_process_16"></em></li>
    nameHTML += "<li id='fileNameDiv" + index + "' class='margin_r_10'>"
    nameHTML += "<span title='"+escapeStringToHTML(filename)+"'>"
    nameHTML += filename.getLimitLength(16).escapeHTML();
    nameHTML += "</span>"
    nameHTML += "<em  onclick='deleteOne(" + index + ")' class='ico16 affix_del_16' title='${ctp:i18n("fileupload.uploading.attachment_delete")}'></em>";      
    nameHTML += "</li>";

    document.getElementById("fileNameDiv").innerHTML += nameHTML;
    files.put(index, obj.value);
    index++;
    addInput(index);
    return true;
}

function deleteOne(i){
    var pos = getIndex(i);
    removeInput(i); 
    if(!isA8geniusAdded){
      number-- ;  
    }
    files.remove(i);
    
}

function removeInput(i){

    var errorNode = false;
    var pos = getIndex(i);
    try{
        document.getElementById("fileInputDiv" + i).parentNode.removeChild(document.getElementById("fileInputDiv" + i));
    }
    catch(e){
        errorNode = true;
    }
        
    try{
        document.getElementById("fileNameDiv" + i).parentNode.removeChild(document.getElementById("fileNameDiv" + i));
    }
    catch(e){
       errorNode = true;
    }

    if(isA8geniusAdded&&!errorNode){
        var UFIDA_Upload1 = document.getElementById("UFIDA_Upload1");
        UFIDA_Upload1.DeleteItemFromList(i-1);     
        number--; 
    }
   
}

function addInput(i){
    //var html =  "<div id=\"fileInputDiv" + i + "\" class=\"file_unload clearfix\" style=\"\">" + "</div>";
    var e = document.createElement("div");
    e.setAttribute("id","fileInputDiv" + i);
    e.className = "file_unload clearfix";
    var fileNameIndexFlag = i;
    if(quantity==1)fileNameIndexFlag = 1;
    if(isA8geniusAdded){        
        var inputHTML1 = "";  
        inputHTML1+="<a class=\"common_button common_button_icon file_click\" href=\"###\"><em class=\"ico16 affix_16\"></em>${ctp:i18n('fileupload.addfile.label')}";
        inputHTML1+="<INPUT type=\"text\" name=\"file1\" id=\"file1\" onkeydown=\"return false\" onkeypress=\"return false\" style=\"width: 73%\">" + "<INPUT type=\"button\" name=\"button1\" id=\"button1\" onclick=\"OpenBrowser()\" value=\"<fmt:message key='file.upload.browse' bundle='${v3xCommonI18N}' />......\" >";
        inputHTML1+="</a>";
        e.innerHTML=inputHTML1;
    }else{
        //var eInput;
/*         if(navigator.userAgent.indexOf("MSIE")>0){
             var inputHTML = "<INPUT type=\"file\" name=\"file" + fileNameIndexFlag + "\" id=\"file" + i + "\" onchange=\"addNextInput(this)\" onkeydown=\"return false\" onkeypress=\"return false\" style=\"width: 100%\">";
             eInput = document.createElement(inputHTML);     
        } else { */
          
        var inputHTML1 = "";  
        inputHTML1+="<a class=\"common_button common_button_icon file_click\" href=\"###\"><em class=\"ico16 affix_16\"></em>${ctp:i18n('fileupload.addfile.label')}";
        inputHTML1+= "<INPUT type=\"file\" name=\"file" + fileNameIndexFlag + "\" id=\"file" + i + "\" onchange=\"addNextInput(this)\" onkeydown=\"return false\" onkeypress=\"return false\" style=\"width: 100%\"/>";
        inputHTML1+="</a>";
        e.innerHTML=inputHTML1;
          
        /*
            eInput = document.createElement("input");
            eInput.setAttribute("type","file");
            eInput.setAttribute("name","file" + fileNameIndexFlag);
            eInput.setAttribute("id","file" + i);
            eInput.setAttribute("onchange","addNextInput(this)");
            eInput.setAttribute("onkeydown","return false");
            eInput.setAttribute("onkeypress","return false");
            eInput.setAttribute("style","width:100%");
            */
            
/*         } */
        //e.appendChild(eInput);
    }
    document.getElementById("fileInputDiv").appendChild(e);
}

function OpenBrowser()
{
    try{
    /*
    for(i=index-1;i>0;i--){
        deleteOne(i);
    }
    files = new Properties();
*/    
    var UFIDA_Upload1 = document.getElementById("UFIDA_Upload1");
    var maxSize = "${(not empty param.maxSize) ? param.maxSize : v3x:getSystemProperty('fileUpload.maxSize')}";
    if(maxSize){
        UFIDA_Upload1.SetLimitFileSize(parseInt(maxSize));
    }
    var ret = UFIDA_Upload1.openBrowser();
    if(ret==''){
	//接口修改导致确定和返回区分不开，需要常用组件内部进行判断
  //  	alert('${ctp:i18n("fileupload.uploading.upload_alert_exist")}');
    	return;
    }
    var tempTimer=false;
    document.getElementById("file1").value = ret;       
    var fStrs = ret.split("\n");
    var i = 0;
    for(;i<fStrs.length;i++){
        document.getElementById("fileStr").value = fStrs[i];
        if(!addNextInput(document.getElementById("fileStr"))){
        	tempTimer=true;
        	break;
        }
        	
        	
    }
    // 共m+n个，成功m个，要把m后面的删除
    var j=fStrs.length;
    if(tempTimer){
	    if(i==0&&isExtensions==0){
	    	i=1;
	    }
	    for(;j>=i;j--){
	        UFIDA_Upload1.DeleteItemFromList(j);  
	    }  
    }
   
}catch(e){
    alert("请到辅助程序安装中更新常用插件。");
}
}
// 根据fileInputDiv的后缀数字获取它在数组中的位置
function getIndex(index)
{
    var name = 'fileNameDiv' + index;
    var container = document.getElementById("fileNameDiv");
    var children = container.getElementsByTagName('div');
    var len = children.length;
    var result = 0;
    for(i = 0;i<len;i++)
    {
        var element = children[i];      
        result ++;
        if(name == element.id ) 
        {
            return result;
        }

    }
    return -1;
}
function SetServerName_OnClick(){
    var _parent = typeof(transParams)!="undefined" ? transParams.parentWin : null;
    if( typeof(_parent)=='undefined' || _parent == null){
        _parent = window.dialogArguments;
    }
    if( typeof(_parent)=='undefined' || _parent == null){
        _parent = window.parent;
    }
    try{
        var form_action= document.getElementById("form_action");        
        var extensions = document.getElementById("extensions").value;
        var applicationCategory = document.getElementById("applicationCategory").value;
        var destDirectory = document.getElementById("destDirectory").value;
        var destFilename = document.getElementById("destFilename").value;
        var typeStr = document.getElementById("type").value;
        var maxSizeStr = document.getElementById("maxSize").value;

        var repeat = "0";
        try{
            var repeats = document.getElementsByName("repeat");
            for(var i = 0; i < repeats.length; i ++){
                if(repeats[i].checked){
                    repeat = repeats[i].value;
                    break;
                }else{
                    continue;
                }
            }
        }catch(e){}
        
        var serverName  = '<%=request.getScheme()%>://<%=request.getServerName()%>';
        var fieldname= "id=&method=processUpload&extensions="+extensions
                       +"&applicationCategory="+applicationCategory
                       +"&destDirectory="+destDirectory
                       +"&type="+typeStr
                       +"&maxSize="+maxSizeStr
                       +"&from=a8genius&repeat=" + repeat
                       +"&destFilename="+destFilename.replace(/\\/g,"/");
        <c:if test="${not empty param.firstSave }">
        fieldname += "&firstSave=${ctp:toHTML(param.firstSave)}"
         </c:if>
    
        var UFIDA_Upload1 = document.getElementById("UFIDA_Upload1");
        UFIDA_Upload1.CallBackUploadCompletedType(1);
        var serverPort = '<%=request.getServerPort()%>';
        UFIDA_Upload1.SetServerName(serverName);
        UFIDA_Upload1.SetFormAction(form_action.value);
        UFIDA_Upload1.SetFileFieldName("file1");
        UFIDA_Upload1.SetFieldName(fieldname);
        UFIDA_Upload1.SetCallbackUploadCompleted(cbmthod);
        UFIDA_Upload1.SetServerPort(serverPort);
        UFIDA_Upload1.SetProcessBarColor(250206135);
        UFIDA_Upload1.SetProcessBarBkColor(parseInt('0xFFFFFF'));
    }catch(e){
        alert(e);
    }
}

    var reAtts= new ArrayList();
    var fileurls="";
    var callback = null;
    <c:if test="${not empty param.callback}" >
       // if(parent.${param.callback}) callback = parent.${param.callback};
         if((typeof(_parent)!='undefined') && (_parent != null) && _parent.${param.callback}) callback = _parent.${param.callback};        
    </c:if> 

function cbmthod(type,str){   
    	 if(type==0){
		var att= $.parseJSON(str)[0];
		reAtts.add(att);
		fileurls=fileurls+","+att.fileUrl;
    <c:if test="${(empty param.targetAction and empty param.callMethod )  or (not empty param.callMethod and 'false' eq param.takeOver)}" >
            <c:if test="${empty param.attachmentTrId}" >
            if(callback){
              callback(att.type, att.filename, att.mimeType, att.createdate, att.size, att.fileUrl,null,null,att.extension,att.icon,att.v);
            }else{
              //parent.addAttachment(att.type,  att.filename, att.mimeType,att.createdate, att.size, att.fileUrl,null,null,att.extension,att.icon,att.v);
              addAttachment(att.type,  att.filename, att.mimeType,att.createdate, att.size, att.fileUrl,null,null,att.extension,att.icon,att.v);
            }
            </c:if>
            <c:if test="${not empty param.attachmentTrId}" >
             //parent.addAttachmentPoi(att.type,  att.filename,  att.mimeType, att.createdate,  att.size, att.fileUrl,null,null,att.extension,att.icon, '${param.attachmentTrId}',null,null,null,null,'${param.embedInput}',null,null,att.v,null,'${ param.isShowImg}');
             addAttachmentPoi(att.type,  att.filename,  att.mimeType, att.createdate,  att.size, att.fileUrl,null,null,att.extension,att.icon, '${param.attachmentTrId}',null,null,null,null,'${param.embedInput}',null,null,att.v,null,'${ param.isShowImg}');
            </c:if>         
    </c:if>

	 }

    var i=str.indexOf('{');
    if(i==0){
        geniusNum++;
        var str1 = str.split('}');
        var str2 = str.substr(0,str.lastIndexOf('}')+1);//str1[0] + '}'; 
        var str2 = str2.substr(0,str2.lastIndexOf('}')+1);
        var strJsion = '('+str2+')';
        var f = eval(strJsion);
        //parent.addAttachment(f.type, f.filename, f.mimeType, f.createDate, f.size, f.fileUrl,null,null,f.extension,f.icon);
		addAttachment(f.type, f.filename, f.mimeType, f.createDate, f.size, f.fileUrl,null,null,f.extension,f.icon);
        if(geniusNum == number){
            //parent.close();
            windowClose();
        }

        str = str1[1];

    }
    
    if ( type == 1)
    {
        var percent= document.getElementById("file_percent");
        var fileName=str.substr(str.lastIndexOf("\\")+1);  
        var genNum = geniusNum+1;
        percent.innerText = "共"+number+"个文件，正在上传第"+genNum+"个文件 "+getLimitLength(fileName, 50);
    } 
    else if ( type == -1)
      {
               alert($.i18n('fileupload.uploading.error')); //'由于网络不稳定或网络已断开，上传失败！请检查网络，点【确定】重新上传'
               document.getElementById("b1").disabled = false;
      }
    else if ( type == 2){
        var percent= document.getElementById("percent");
        var pcent = str.split('/');
        percent.innerText = $.i18n('fileupload.uploading',pcent[0],pcent[1]);//"已上传 "+pcent[0]+"KB , 总文件大小 "+pcent[1]+"KB";
    }else if ( type == 100){
        <c:if test="${not empty param.targetAction or not empty param.callMethod}" >
		var repeat = "0";
		try{
        var repeats = document.getElementsByName("repeat");
        for(var i = 0; i < repeats.length; i ++){
            if(repeats[i].checked){
                repeat = repeats[i].value;
                break;
            }else{
                continue;
            }
        }
    }catch(e){}
    <c:if test="${'true' ne param.firstSave}">			
           callforward(fileurls.substring(1),repeat);
    </c:if>
    <c:if test="${'true' eq param.firstSave}">
            callforward(reAtts,repeat);
    </c:if>
</c:if>

	  //parent.window.close();
	  windowClose();
	}
    return "true";
}

function onUpload(){
  try{
	//OA-99062	处理协同上传附件：上传没有进度条--添加按钮可以点击--多点击几次IE停止运行  
  	if($('.file_click')){
        $('.file_click').css('display','none');
    }
    //如果用户没有选择文件，什么都不做
    if(number != 0){
	//document.getElementById("b1").disabled = false;
	    $("#b1").disable();
        SetServerName_OnClick();
        show();
        var percent= document.getElementById("result");
        percent.innerText = "";
        var UFIDA_Upload1 = document.getElementById("UFIDA_Upload1");
        UFIDA_Upload1.height = '20';
        var ret = UFIDA_Upload1.StartUpload();   
        if(ret=='-100')
        {
            window.close();
        }
    }else{//v5.1要求有提示
    	$('.file_click').css('display','block');
        alert("${ctp:i18n_1('fileupload.selectfile.label',maxSize)}");
        return ;
    }
  }catch(e){
    alert(e);
  }
}
/**
 * 显示表单导入规则说明
 */
function importExplain(){
    var current_dialog = $.dialog({
        url: _ctxPath+"/form/formula.do?method=formulaHelp&formType=2",
        title : $.i18n('form.formulahelp.label'),
        width:600,
        height:450,
        targetWindow:getCtpTop(),
        buttons : [{
            text : $.i18n('form.trigger.triggerSet.confirm.label'),id:"sure",
            handler : function() {
                current_dialog.close();
            }
        }]
    });
}

</script>
</head>

<body  onkeydown="listenerKeyPress()" style="height: 100%;overflow: hidden" class="page_color">
    <form style="height: 100%;display: block;" enctype="multipart/form-data" name="uploadForm" method="post" id="form_upload" action="${pageContext.request.contextPath}/fileUpload.do?method=processUpload&maxSize=<%=maxSize%>"   target="uploadIframe">
        <input type="hidden"  id="type" name="type" value="<%=type%>">
         <input type="hidden" name="extensions"id="extensions" value="<%=extensions%>"> 
         <input type="hidden" name="applicationCategory"id="applicationCategory" value="<%=applicationCategory%>"> 
         <input type="hidden" name="destDirectory" id="destDirectory" value="<%=destDirectory%>"> 
         <input type="hidden" name="destFilename" id="destFilename" value="<%=destFilename%>"> 
         <input type="hidden" name="maxSize" id="maxSize" value="<%=maxSize%>"> 
         <input type="hidden" name="isEncrypt" id="isEncrypt" value="<%=isEncrypt%>"> 
         <input type="hidden" id="form_action" value="/seeyon/fileUpload.do"> 
         <input type="hidden" id="fileStr" value="">
        <c:if test="${not empty param.targetAction }">
            <input type="hidden" name="targetAction" id="targetAction" value="${ctp:toHTML(param.targetAction)}">
        </c:if>
         <c:if test="${not empty param.callMethod }">
            <input type="hidden" name="callMethod" id="callMethod" value="${ctp:toHTML(param.callMethod)}">
        </c:if>
        <c:if test="${not empty param.attachmentTrId }">
            <input type="hidden" name="attachmentTrId" id="attachmentTrId" value="${ctp:toHTML(param.attachmentTrId)}">
        </c:if>
         <c:if test="${not empty param.firstSave }">
            <input type="hidden" name="firstSave" id="firstSave" value="${ctp:toHTML(param.firstSave)}">
        </c:if>
        <c:if test="${not empty param.takeOver }">
            <input type="hidden" name="takeOver" id="takeOver" value="${ctp:toHTML(param.takeOver)}">
        </c:if>
         <c:if test="${not empty param.embedInput }">
            <input type="hidden" name="embedInput" id="takeOver" value="${ctp:toHTML(param.embedInput)}">
        </c:if>
        <c:if test="${not empty param.callback }">
            <input type="hidden" name="callback" id="callback" value="${ctp:toHTML(param.callback)}">
        </c:if>      
         <c:if test="${not empty param.isShowImg }">
            <input type="hidden" name="isShowImg" id="isShowImg" value="${ctp:toHTML(param.isShowImg)}">
        </c:if>    
        <c:if test="isA8geniusAdded">
        	<input type="hidden" name="isA8geniusAdded" id="isA8geniusAdded" value="${ctp:toHTML(param.isA8geniusAdded)}">
        </c:if>
        <c:choose>
            <c:when test="${isA8geniusAdded}">
                <%@include file="geniuesUpload.jsp" %>
            </c:when>
            <c:otherwise>
                <%@include file="a8Upload.jsp"%>
            </c:otherwise>
        </c:choose>
    </form>
    <iframe name="uploadIframe" frameborder="0" height="0" width="0" class="hidden" style="display:none" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>