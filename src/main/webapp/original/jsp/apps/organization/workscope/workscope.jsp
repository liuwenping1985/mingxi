<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../common/common.jsp"%>
<style>
    .stadic_head_height{
        height:150px;
    }
    .stadic_body_top_bottom{
        bottom: 30px;
        top: 150px;
    }
    .stadic_footer_height{
        height:30px;
    }
</style>
<script type="text/javascript">
var accountId = "${accountId}";
$().ready(function() {
    var pManager = new workscopeManager();
    var levelscope = pManager.editScope(accountId);
    $("#button").hide();
    $("#levelScope").val(levelscope);
   
    if($("#levelScope").val()==null){
    	$("#levelScope").val("-1");
    }
    $("#postform").disable();
    $("#toolbar").toolbar({
        toolbar: [
        {
            id: "modify",
            name: "${ctp:i18n('common.button.modify.label')}",
            className: "ico16 editor_16",
            click: function() {
            	$("#postform").enable();
                $("#button").show();
            }
        }]
    });

    var mytable = $("#mytable").ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'id',
            width: '1%',
            sortable: false,
            align: 'center',
            type: 'checkbox',
            hide:true
        },
        {
            display: "${ctp:i18n('work.area.level')}",
            sortable: true,
            name: 'name',
            width: '15%'
        },
        {
            display: "${ctp:i18n('work.area.number')}",
            sortable: true,
            sortType:'number',
            name: 'levelId',
            width: '20%'
        },
        {
            display: "${ctp:i18n('work.area.visit')}",
            sortable: true,
            name: 'visit',
            width: '64%'
        }],
        managerName: "workscopeManager",
        managerMethod: "showWorkscopeList",
        resizable: false,
        slideToggleBtn: false,
        showTableToggleBtn: false,
        resizable: false,
        height: 230,
        striped:true,
        usepager: false,
        width: "auto"
    });
    var o = new Object();
    o.accountId = accountId;
    o.levelscope = $("#levelScope").val();
    $("#mytable").ajaxgridLoad(o);

    $('#levelScope').change(function(){ 
    	o.levelscope = $("#levelScope").val();
    	$("#mytable").ajaxgridLoad(o);
    });

    $("#btnok").click(function() {
        if(!($("#postform").validate())){
            return;
        }
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        pManager.saveScope(accountId, $("#levelScope").val(), {
            success: function(depBean) {
            	levelscope = $("#levelScope").val();
            	$("#postform").disable();
            	$("#button").hide();
                try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
            }
        });

    });
    $("#btncancel").click(function() {
    	$("#levelScope").val(levelscope);
    	o.levelscope = $("#levelScope").val();
    	$("#mytable").ajaxgridLoad(o);
    	$("#postform").disable();
    	$("#button").hide();
    });
});
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="stadic_layout">
        <div class="comp" comp="type:'breadcrumb',code:'T02_showWorkscopeframe'"></div>
        <div class="stadic_layout_head stadic_head_height">
            <div id="toolbar"></div>
            <br>
            <fieldset class="fieldset_box">
                <legend>${ctp:i18n('org.external.member.form.work.scope.choose')}</legend>
                <div id="postform" class="form_area">
                    <form name="addForm" id="addForm" method="post"
                        target="addDeptFrame">
                        <div class="one_row">
                            <table border="0" cellspacing="0" cellpadding="0">
                                <tbody>
                                    <input type="hidden" name="orgAccountId" id="orgAccountId" value="" />
                                    <input type="hidden" name="id" id="id" value="" />
                                    <tr>
                                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.external.member.form.work.scope.upward')}</label></th>
                                        <td>
                                        <div>
                                            <select id="levelScope" name="levelScope" class="codecfg"
                                            codecfg="codeType:'java',codeId:'com.seeyon.ctp.organization.enums.LevelScopeEnum',accountId:'${accountId}'" >
                                            <option value="-1">${ctp:i18n('org.external.member.form.work.scope.unlimited')}</option>
                                            </select>
                                        </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </form>
                </div>
            </fieldset>
            <br/>
            <label class="margin_r_8 font_size12 margin_lr_10" for="text">
                ${ctp:i18n('org.external.member.form.work.scope.setting')}
            </label>
        </div>
        <div class="stadic_layout_body stadic_body_top_bottom border_t">
            <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0"></table>
            <div id="welcome">
                <div class="color_hexagon margin_l_20 font_size12 margin_t_10">
                    <div class="clearfix font_bold">
                        <font color="green">${ctp:i18n('import.description')}:</font>
                    </div>
                    <div class="line_height160">
                        <font color="green">${ctp:i18n('organization.detail_info_workscope')}</font>
                    </div>
                </div>
            </div>
        </div>
        <div class="stadic_layout_footer stadic_footer_height">
            <div id="button" align="center" class="page_color button_container">
                <a id="btnok" href="javascript:void(0)"
                    class="common_button common_button_emphasize margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
                <a id="btncancel" href="javascript:void(0)"
                    class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>