<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/template/collaborationTemplate_pub.js.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>归档设置</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var transParams = window.dialogArguments;
var clickSelect = "<"+$.i18n('collaboration.attachment.autoval.js')+">";
  $(function() {
	  if(transParams.archiveCollPathName != ""){
		  $("#archiveCollPathName").val(transParams.archiveCollPathName);
	  }else{
		  $("#archiveCollPathName").val(clickSelect);
	  }
	  $("#archiveCollPathId").val(transParams.archiveCollPathId); 
	  if(transParams.attachmentArchiveName != ""){
		  $("#attachmentArchiveName").val(transParams.attachmentArchiveName);
	  }else{
		  $("#attachmentArchiveName").val(clickSelect);
	  }
	  $("#attachmentArchiveId").val(transParams.attachmentArchiveId);
	  
	  $("#archiveCollPathName").click(function () {
		  doPigeonhole_pre('new', transParams.collKey, 'templete','coll');
      });
	  $("#attachmentArchiveName").click(function () {
		  doPigeonhole_pre('new', transParams.collKey, 'templete','attachment');
      });
		//清除附件归档目录
      $("#clearAttTextName").click(function (){
    	  $("#attachmentArchiveName").val(clickSelect);
          $("#attachmentArchiveId").val("");
      });
       //清除协同归档目录
      $("#clearCollTextName").click(function (){
    	  $("#archiveCollPathName").val(clickSelect);
          $("#archiveCollPathId").val("");
      });
  });
  
  function OK(){
	  var archiveCollPathName= $("#archiveCollPathName").val();
	  var archiveCollPathId= $("#archiveCollPathId").val();
	  var attachmentArchiveName= $("#attachmentArchiveName").val();
	  var attachmentArchiveId= $("#attachmentArchiveId").val();
	  
	  var obj = {};
	  
	  if(archiveCollPathName == clickSelect){
		  obj.archiveCollPathName = "";
	  }else{
		  obj.archiveCollPathName = archiveCollPathName;
	  }
	  if(archiveCollPathId=="" || archiveCollPathId==null){
      	obj.archiveCollPathId = "";
      }else{ 
      	obj.archiveCollPathId = archiveCollPathId;
      } 
	  if(attachmentArchiveName == clickSelect){
		  obj.attachmentArchiveName = "";
	  }else{
		  obj.attachmentArchiveName = attachmentArchiveName;
	  }
	  if(attachmentArchiveName=="" || attachmentArchiveName==null){
      	obj.attachmentArchiveId = "";
      }else{ 
      	obj.attachmentArchiveId = attachmentArchiveId;
      } 
	  
	  return obj;
  }
  
</script>
</head>
<body>
  <div id="maindiv">
  		 <table cellspacing="2" cellpadding="2" width="95%" border="0">
                <tr height="35">
                    <td colspan="4">&nbsp;</td>
                </tr>
                <tr id="archiveCollPath">
                    <td width="10" class="padding_t_10">&nbsp;</td>
                    <td align="right" width="100"
                        class="padding_t_10"><font size="2.5">${ctp:i18n('collaboration.archive.pathname')}：</font>
                    </td>
                    <td width="150" class="padding_t_10" nowrap="nowrap">
                        <div class=" common_txtbox_wrap">
                            <input id="archiveCollPathName" name="archiveCollPathName" type="text" readonly="readonly" class="hand">
                       		<input type="hidden" id="archiveCollPathId" name="archiveCollPathId" value=""/>
                        </div>
                    </td>
                    <td width="50" class="padding_t_10">
                        <a class="common_button margin_l_5"
                           href="javascript:void(0)"
                           id="clearCollTextName">${ctp:i18n('collaboration.attachment.clear.js')}</a>
                    </td>
                </tr>
                <tr height="10"></tr>
                <tr id="archiveFilePath">
                    <td width="10" class="padding_t_10">&nbsp;</td>
                    <td align="right" width="100"
                        class="padding_t_10"><font size="2.5">${ctp:i18n('collaboration.attachment.archiveName')}：</font>
                    </td>
                    <td width="150" class="padding_t_10" nowrap="nowrap">
                        <div class=" common_txtbox_wrap">
                            <input id="attachmentArchiveName" name="attachmentArchiveName" value="<点击选择>" readonly="readonly" type="text" class="hand">
                       		<input type="hidden" id="attachmentArchiveId" name="attachmentArchiveId" value=""/>
                        </div>
                    </td>
                    <td width="50" class="padding_t_10">
                        <a class="common_button margin_l_5"
                           href="javascript:void(0)"
                           id="clearAttTextName">${ctp:i18n('collaboration.attachment.clear.js')}</a>
                    </td>
                </tr>
            </table>
  </div>
</body>
</html>