<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
$().ready(function() {
    $("#ok").click(function(){
        $("#knowledgeSettingForm").jsonSubmit({
            debug : false
          });
    });
    
    var sUrl = _ctxPath + "/doc/knowledgeController.do?method=showKnowledgeIntegrationSetting&isDefaultProp=true";
    $("#btnreset").click(function(){
        $("#knowledgeSettingForm").jsonSubmit({
            action : sUrl,
            validate:false,
            debug : false
        });
    });
    
    $("#clearIntergral").click(function(){
        $.confirm({
            'msg': "${ctp:i18n('doc.operate.whether.clear')}",
            ok_fn: function () {
                var knowledgeManagerAjax = new knowledgeManager();
                knowledgeManagerAjax.deleteIntegral({
                    success: function(){
                        $.infor("${ctp:i18n('doc.operate.success')}");
                    }
                });
            }
        }); 
        });
    /* 
    $('#createEnabled').click(function(){
        if($(this).attr('checked')=='checked'){
            $('#create').removeAttr("disabled");
        }else{
            $('#create').attr("disabled", "disabled").val('');
        }
    });
     */

     if('${param.readOnly}'=='readonly'){
    	 $('input').attr("readonly",true);
    	 $("input").attr("disabled",true);
    	 $('#thecontrole').hide();//隐藏按钮
     }
});

</script>
</head>
<body class="">

<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F04_KnowledgeIntegrationSetting'"></div>
<div id='layout' class="comp " comp="type:'layout'">
     <div class="layout_north" layout="height:35,sprit:false,border:false">
     </div>
     <div class="layout_center  over_hidden" layout="border:false">
     <c:set value="${ctp:i18n('doc.daren.fenzhi')}" var="i18nFenZhi"/>
     <div class="form_area align_center">
     <form id="knowledgeSettingForm" class="align_center" action="knowledgeController.do?method=saveKnowledgeIntegrationSetting">
        <table border="0" cellSpacing="0" cellPadding="0" width="500" align="center">
            <tr>
                <td noWrap="nowrap" align="left"><label class="margin_r_10" for="createEnabled">
                <input id="createEnabled" class="radio_com" name="createCheckbox" value="1" type="checkbox">${ctp:i18n('doc.operate.new.upload.file')}</label></td>
                <td noWrap="nowrap" height="30">
                    <input id="create" class="validate" name="create" value="" type="text" size="5" validate='isWord:false,name:"${ctp:i18n('doc.daren.fenzhi')}",isNumber:true,dotNumber:2,minLength:1,maxLength:5'>${ctp:i18n('doc.daren.fenzhi')}
                </td>
                
                <td noWrap="nowrap" align="left"><label class="margin_r_5" for="gradeValueEnabled">
                <input id="gradeValueEnabled" class="radio_com" name="gradeValueCheckbox" value="1" type="checkbox">${ctp:i18n('doc.score.value')}</label></td>
                <td noWrap="nowrap" height="30">
                    <input id="gradeValue" class="validate" name="gradeValue" value="" size="5" type="text" validate='isWord:false,name:"${ctp:i18n('doc.daren.fenzhi')}",isNumber:true,dotNumber:2,minLength:1,maxLength:5'>${ctp:i18n('doc.daren.fenzhi')}
                </td>
            </tr>
            <tr>
                <td noWrap="nowrap" align="left"><label class="margin_r_5" for="recommendEnabled">
                <input id="recommendEnabled" class="radio_com" name="recommendCheckbox" value="1" type="checkbox">${ctp:i18n('doc.recommend.doc')}</label></td>
                <td noWrap="nowrap" height="30">
                    <input id="recommend" class="validate" name="recommend" value="" type="text" size="5" validate='isWord:false,name:"${ctp:i18n('doc.daren.fenzhi')}",isNumber:true,dotNumber:2,minLength:1,maxLength:5'>${ctp:i18n('doc.daren.fenzhi')}
                </td>
                
                <td noWrap="nowrap" align="left"><label class="margin_r_5" for="sendStudyEnabled">
                <input id="sendStudyEnabled" class="radio_com" name="sendStudyCheckbox" value="1" type="checkbox">${ctp:i18n('doc.send.learning')}</label></td>
                <td noWrap="nowrap" height="30">
                    <input id="sendStudy" class="validate" name="sendStudy" value="" size="5" type="text" validate='isWord:false,name:"${ctp:i18n('doc.daren.fenzhi')}",isNumber:true,dotNumber:2,minLength:1,maxLength:5'>${ctp:i18n('doc.daren.fenzhi')}
                </td>
            </tr>
            <tr>
                <td noWrap="nowrap" align="left"><label class="margin_r_5" for="commentEnabled">
                <input id="commentEnabled" class="radio_com" name="commentCheckbox" value="1" type="checkbox">${ctp:i18n('doc.setting.comment.doc')}</label></td>
                <td noWrap="nowrap" height="30">
                    <input id="comment" class="validate" name="comment" value="" size="5" type="text" validate='isWord:false,name:"${ctp:i18n('doc.daren.fenzhi')}",isNumber:true,dotNumber:2,minLength:1,maxLength:5'>${ctp:i18n('doc.daren.fenzhi')}
                </td>
                
                <td noWrap="nowrap" align="left"><label class="margin_r_5" for="isReadedEnabled">
                <input id="isReadedEnabled" class="radio_com" name="isReadedCheckbox" value="1" type="checkbox">${ctp:i18n('doc.setting.jifen.be.read')}</label></td>
                <td noWrap="nowrap" height="30">
                    <input id="isReaded" class="validate" name="isReaded" value="" size="5" type="text" validate='isWord:false,name:"${ctp:i18n('doc.daren.fenzhi')}",isNumber:true,dotNumber:2,minLength:1,maxLength:5'>${ctp:i18n('doc.daren.fenzhi')}
                </td>
            </tr>
            <tr>
                <td noWrap="nowrap" align="left"><label class="margin_r_5" for="collectEnabled">
                <input id="collectEnabled" class="radio_com" name="collectCheckbox" value="1" type="checkbox">${ctp:i18n('doc.setting.jifen.collect')}</label></td>
                <td noWrap="nowrap" height="30">
                    <input id="collect" class="validate" name="collect" value="" type="text" size="5" validate='isWord:false,name:"${ctp:i18n('doc.daren.fenzhi')}",isNumber:true,dotNumber:2,minLength:1,maxLength:5'>${ctp:i18n('doc.daren.fenzhi')}
                </td>
                
                <td noWrap="nowrap" align="left"><label class="margin_r_5" for="isRecommendedEnabled">
                <input id="isRecommendedEnabled" class="radio_com" name="isRecommendedCheckbox" value="1" type="checkbox">${ctp:i18n('doc.setting.jifen.recommend')}</label></td>
                <td noWrap="nowrap" height="30">
                    <input id="isRecommended" class="validate" name="isRecommended" value="" type="text" size="5" validate='isWord:false,name:"${ctp:i18n('doc.daren.fenzhi')}",isNumber:true,dotNumber:2,minLength:1,maxLength:5'>${ctp:i18n('doc.daren.fenzhi')}
                </td>
            </tr>
            <tr>
                <td noWrap="nowrap" align="left"><label class="margin_r_5" for="readEnabled">
                <input id="readEnabled" class="radio_com" name="readCheckbox" value="1" type="checkbox">${ctp:i18n('doc.setting.jifen.read')}</label></td>
                <td noWrap="nowrap" height="30">
                    <input id="read" class="validate" name="read" value="" type="text" size="5" validate='isWord:false,name:"${ctp:i18n('doc.daren.fenzhi')}",isNumber:true,dotNumber:2,minLength:1,maxLength:5'>${ctp:i18n('doc.daren.fenzhi')}
                </td>
                
                <td noWrap="nowrap" align="left"><label class="margin_r_5" for="isCommentedEnabled">
                <input id="isCommentedEnabled" class="radio_com" name="isCommentedCheckbox" value="1" type="checkbox">${ctp:i18n('doc.setting.jifen.comment')}</label></td>
                <td noWrap="nowrap" height="30">
                    <input id="isCommented" class="validate" name="isCommented" value="" type="text" size="5" validate='isWord:false,name:"${ctp:i18n('doc.daren.fenzhi')}",isNumber:true,dotNumber:2,minLength:1,maxLength:5'>${ctp:i18n('doc.daren.fenzhi')}
                </td>
            </tr>
            <tr>
                <td noWrap="nowrap" align="left"><label class="margin_r_5" for="issueBlogEnabled">
                <input id="issueBlogEnabled" class="radio_com" name="issueBlogCheckbox" value="1" type="checkbox">${ctp:i18n('doc.setting.jifen.publish.blog')}</label></td>
                <td noWrap="nowrap" height="30">
                    <input id="issueBlog" class="validate" name="issueBlog" value="" size="5" type="text" validate='isWord:false,name:"${ctp:i18n('doc.daren.fenzhi')}",isNumber:true,dotNumber:2,minLength:1,maxLength:5'>${ctp:i18n('doc.daren.fenzhi')}
                </td>
                
                <td noWrap="nowrap" align="left"><label class="margin_r_5" for="isDownloadEnabled">
                <input id="isDownloadEnabled" class="radio_com" name="isDownloadCheckbox" value="1" type="checkbox">${ctp:i18n('doc.setting.jifen.download')}</label></td>
                <td noWrap="nowrap" height="30">
                    <input id="isDownload" class="validate" name="isDownload" value="" size="5" type="text" validate='isWord:false,name:"${ctp:i18n('doc.daren.fenzhi')}",isNumber:true,dotNumber:2,minLength:1,maxLength:5'>${ctp:i18n('doc.daren.fenzhi')}
                </td>
            </tr>
            <tr>
                <td noWrap="nowrap" align="left"><label class="margin_r_5" for="gradeEnabled">
                <input id="gradeEnabled" class="radio_com" name="gradeCheckbox" value="1" type="checkbox">${ctp:i18n('doc.setting.mark.score')}</label></td>
                <td noWrap="nowrap" height="30">
                    <input id="grade" class="validate" name="grade" value="" size="5" type="text" validate='isWord:false,name:"${ctp:i18n('doc.daren.fenzhi')}",isNumber:true,dotNumber:2,minLength:1,maxLength:5'>${ctp:i18n('doc.daren.fenzhi')}
                </td>
                
                <td noWrap="nowrap" align="left"></td>
                <td noWrap="nowrap" height="30"></td>
            </tr>
            <tr>
                <td noWrap="nowrap" colspan="4"><hr align="center" width="100%"></td>
            </tr>
            <tr>
                <td noWrap="nowrap" align="right"><label class="margin_r_10" for="text">${ctp:i18n('doc.setting.jifen.exclude.person')}：</label></td>
                <td width="100%" colspan="3">
                    <input size="51" type="text" id="excludePeople" name="excludePeople" class="comp"
                        comp="minSize:'0',maxSize:'999',type:'selectPeople',mode:'open',panels:'Account,Department,Team,Post,Level,Role,RelatePeople',selectType:'Account,Department,Team,Post,Level,Role,Member',showMe:'false'" />
                </td>
            </tr>
        </table>
    </form>
    </div>
    <div class="align_center margin_t_10" id="thecontrole">
        <a id="clearIntergral" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('doc.setting.jifen.clear')}</a>
        <a id="ok" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('common.button.ok.label')}</a>
        <a id="btnreset" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('common.button.reset.label')}</a>
    </div>
    </div>
</div>
</body>
</html>