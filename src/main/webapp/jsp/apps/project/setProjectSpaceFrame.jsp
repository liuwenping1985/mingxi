<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title>${ctp:i18n('space.default.project.label')}</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=spaceManager,spaceSecurityManager,pageManager"></script>
<script>
  var isToDefault = false;
  $(document).ready(function() {
    $("#submitbtn").unbind("click").bind("click",function(){
		saveSpace();
    });
    $("#todefaultbtn").unbind("click").bind("click",function(){
      toDefault();
    });
    $("#cancelbtn").unbind("click").bind("click",function(){
      window.location.href = _ctxPath + "/project/project.do?method=projectSpace&projectId=${projectId}";
    });
    
    function saveSpace(){
    	isToDefault = false;
    	showMask();
    	var spaceId = $("#id").val();
    	if(frames['projectSpaceFrame'].addLayoutDataToForm){
        	var checkResult = frames['projectSpaceFrame'].sectionHandler.checkEditSection();
            if(checkResult == false){
          	  return;
            }
            
	        frames['projectSpaceFrame'].addLayoutDataToForm();
	        var formobjNew = $("#grid_detail").formobj();
	        new spaceManager().transSaveSpace(formobjNew,{
	          success : function(){
	            hideMask();
	            $.messageBox({
	              'title': "${ctp:i18n('common.prompt')}",
	              'type': 0,
	              'msg': "<span class='msgbox_img_0 left' ></span><span class='margin_l_5'>${ctp:i18n('common.successfully.saved.label')}</span>",
	              ok_fn: function() {
	                getCtpTop().showMenu("${projectSpaceURL}");
	              },
	              close_fn:function() {
	                getCtpTop().showMenu("${projectSpaceURL}");
	              }
	            });
	          }
	        });
        }//end of if(frames['projectSpaceFrame'].addLayoutDataToForm){
    }
    
    /*
    *空间恢复默认
    */
    function toDefault(){
    var editKeyId = frames['projectSpaceFrame'].document.getElementById("editKeyId").value;
    var path = $("#path").val();
    var params = new Object();
    params['editKeyId']=editKeyId;
    params['pagePath']=path;
    new pageManager().transToDefaultSpace(params,{
      success : function(result){
        if(result != null){
          $("#projectSpaceFrame").attr("src",path+"?showState=edit&decorationId="+result+"&editKeyId="+editKeyId);
        }
      }
    });
    isToDefault = true;
  }
  
  });
</script>
<style>
    .stadic_head_height{
        height:0px;
    }
    .stadic_body_top_bottom{
        bottom: 30px;
        top: 0px;
    }
    .stadic_footer_height{
        height:30px;
    }
</style>

</head>
<body class="h100b over_hidden bg_color">
    <div class="stadic_layout">
        <div class="stadic_layout_head stadic_head_height">
            <%--面包屑--%>
            <div class="comp" comp="type:'breadcrumb',code:'T3_spaceEditMenu_label'"></div>
        </div>
        
        <div id="grid_detail" class="stadic_layout_body stadic_body_top_bottom">
            <input type="hidden" id="id" value="${spaceAndPage.id}"/>
            <input type="hidden" id="defaultspace" value="0"/>
            <input type="hidden" id="decoration" value=""/>
            <input type="hidden" id="showState" value=""/>
            <input type="hidden" id="editKeyId" value=""/>
            <input type="hidden" id="toDefault" value=""/>
            <input type="hidden" id="canusemenu" value=""/>
            <input type="hidden" id="sysMenuTree" value="">
            <%--事实证明accountType和accountId永远为空，从portal那边照抄过来的，或许以后有用--%>
            <input type="hidden" id="accountType" value="${accountType}">
            <input type="hidden" id="accountId" value="${accountId}">
            <%--项目空间地址--%>
            <input type="hidden" id="path" value="${setProjectURL}" />
            <%--项目空间状态,默认启用--%>
            <input type="hidden" id="state" name="state" value="0"/>
            <%--特殊标识：空间设置不保存授权--%>
            <input type="hidden" id="exitSecuritySave" name="exitSecuritySave" value="true"/>
        <div id="projectSpace" class="comp h100b border_lr over_hidden" comp="type:'tab',parentId:'grid_detail'" style="border: none">
        <div id="projectSpace_head" class="common_tabs clearfix margin_l_5 margin_t_5">
            <ul class="left">
            	<li class="current" id="tab"><a href="javascript:void(0);" tgt="tab_div" title="${ctp:i18n('space.default.project.label')}">${ctp:i18n('space.default.project.label')}</a></li>
            </ul>
        </div>
        <div id="projectSpace_body" class="common_tabs_body border_t bg_color_white padding_l_5 padding_r_5" style="height: 100%" >
            <iframe width="100%" height="100%" id="projectSpaceFrame" name="projectSpaceFrame" src="${setProjectURL}?showState=edit" frameborder="0"></iframe>
        </div>
    	</div><%--end of div id="personalSet"--%>
        </div><%--end of div id="grid_detail"--%>
        <div class="stadic_layout_footer stadic_footer_height">
            <div class="common_center align_center">
                <span id="submitbtn" class="common_button common_button_emphasize" style="cursor:pointer" >${ctp:i18n("common.button.ok.label")}</span>
                <span id="todefaultbtn"  class="common_button common_button_gray" style="cursor:pointer" >${ctp:i18n("space.button.toDefault")}</span>
                <span id="cancelbtn" class="common_button common_button_gray" style="cursor:pointer" >${ctp:i18n("common.button.cancel.label")}</span>
            </div>
        </div>
    </div>  
<script>
var RTEEditorDivWidth = document.documentElement.clientWidth - 20;
document.getElementById('grid_detail').style.width= RTEEditorDivWidth +'px';
</script>
</body>
</html>