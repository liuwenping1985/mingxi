<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
    <title>${ctp:i18n('addressbook.watermark.setting.label')}</title>
    <script src="/seeyon/decorations/js/jquery.slide.js"></script>
    <style>
    .checkbox{ display: inline-block; width: 17px;height: 17px;border: 1px solid #dfdfdf;position: relative;top: 5px;margin-right: 5px;}
    .checked{border: 0;width: 19px;height: 19px;background: url(apps_res/personal/img/choosed.png); }
    .submit-btn{width:50px;height:25px;font-size:12px;color:#fff;background:#3aadfb;border:1px solid #999;border-radius:5px;}
    .cancel-btn{width:50px;height:25px;font-size:12px;color:#333;background:#fff;border:1px solid #999;border-radius:5px;}
    </style>
</head>
<body>
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'${_resourceCode}'"></div>
    <div style="width:600px;margin:auto;">
        <div style="margin-top:20px;">
            <div style="width:30%;float:left;text-align:right;font-size:12px;padding-top:4px;font-weight:bold;">
                <span>${ctp:i18n('addressbook.watermark.setting.label')}:</span>
            </div>
            <div style="width:70%;float:right;">
                <div style="width:50px;float:left;padding-left:10px;">
                    <input id="radio_yes" name="radio" type="radio" onclick="radio_click(this)"/>
                    <span style="font-size:12px;">${ctp:i18n('addressbook.watermark.yes.label')}</span>
                </div>
                <div style="width:50px;float:left;">
                    <input id="radio_no" name="radio" type="radio" onclick="radio_click(this);">
                    <span style="font-size:12px;">${ctp:i18n('addressbook.watermark.no.label')}</span>
                </div>
                <input id="enable" type="hidden" name="enable" value="true"/>
            </div>
            <div style="clear:both;"></div>
        </div>
        <div id="showdiv">
        <div style="margin-top:20px;">
            <div style="width:30%;float:left;text-align:right;font-size:12px;padding-top:4px;">
                <span>${ctp:i18n('addressbook.watermark.content.label')}:</span>
            </div>
            <div style="width:70%;float:right;">
                <div style="padding-left:10px;">
                    <em class="checkbox" onclick="checkbox_click(this)"></em>
                    <span style="font-size:12px;">${ctp:i18n('addressbook.watermark.fullname.label')}</span>
                    <input type="hidden" name="name" id="name" value="true"/>
                </div>
                <div style="padding-left:10px;">
                    <em class="checkbox" onclick="checkbox_click(this)"></em>
                    <span style="font-size:12px;">${ctp:i18n('addressbook.watermark.abbreviation.label')}</span>
                    <input type="hidden" name="deptname" id="deptname"  value="true"/>
                </div>
                <div style="padding-left:10px;">
                    <em class="checkbox" onclick="checkbox_click(this)"></em>
                    <span style="font-size:12px;">${ctp:i18n('addressbook.watermark.currenttime.label')}</span>
                    <input type="hidden" name="time" id="time"  value="true"/>
                </div>
            </div>
            <div style="clear:both;"></div>
        </div>
        <div style="width:100%;text-align:center;margin-top:20px;font-size:12px;margin-left:-5%;">
            <div><span>${ctp:i18n('addressbook.watermark.example.label')}</span></div>
            <div id="slide" class="slideBox" style="margin:0 auto;padding-top:5px;">
                <ul class="slideImgs" style="position:absolute;">
                	<li>
                        <img style="width:380px;" src='/seeyon/apps_res/sysMgr/img/personalInfo.png'/>
                    </li>
                    <li>
                        <img style="width:380px;" src='/seeyon/apps_res/sysMgr/img/bul.png'/>
                    </li>
                    <li>
                        <img style="width:380px;" src='/seeyon/apps_res/sysMgr/img/doc.png'/>
                    </li>
                    <li>
                        <img style="width:380px;" src='/seeyon/apps_res/sysMgr/img/news.png'/>
                    </li>
                </ul>
            </div>
        </div>
        <div style="width:100%;text-align:center;margin-top:20px;font-size:12px;margin-left:-5%;">
            <span>${ctp:i18n('addressbook.watermark.note.label')}</span>
        </div>
        </div>
        <div style="width:100%;text-align:center;margin-top:20px;margin-left:-5%;">
            <button class="submit-btn" onclick="saveWaterMarkSetting()">${ctp:i18n('addressbook.watermark.save.label')}</button>
        </div>
    </div>
<script type="text/javascript">
    $(function(){
    	var enable = '${watermark_enable}' || "true";
    	var name = '${watermark_name_enable}' || "true";
    	var deptname = '${watermark_deptname_enable}' || "true";
    	var time = '${watermark_time_enable}' || "true";
    	if(enable == "true"){
            $("#radio_yes").attr("checked","true");
            $("#enable").attr("value","true");
            $("#showdiv").show();
    	}else{
    		$("#radio_no").attr("checked","true");
            $("#enable").attr("value","false");
            $("#showdiv").hide();
    	}
    	setCheckbox([{"id":"name","value":name},{"id":"deptname","value":deptname},{"id":"time","value":time}]);
    })
    
    //图片轮播
    $('#slide').slide({
        width: 380,
        height: 670,
        speed: 3000,
        startingSlide: 0,
        slideRemove: true,
        slidePage: true,
        slideTitle: true,
        effect: 'horizontal',
        triggerType:'click',
        tabIndex:0
    });
    
    function setCheckbox(datas){
    	for(var i = 0; i < datas.length; i++){
    		$("#"+datas[i].id).val(datas[i].value);
        	if(datas[i].value == "true"){
        		$("#"+datas[i].id).parent().find("em").addClass("checked");
        	}else{
        		$("#"+datas[i].id).parent().find("em").removeClass("checked");
        	}
    	}
    }
    // 复选框事件
    function checkbox_click(_this){
        if($(_this).hasClass("checked")){
        	if(($(_this).next().next().attr("id") == "name" && $("#deptname").val() == "false") 
        			|| ($(_this).next().next().attr("id") == "deptname" && $("#name").val() == "false")){
        		alert($.i18n('addressbook.watermark.check.label.js'));
        		return;
        	}
            $(_this).removeClass("checked");
            $(_this).parent().find("input").attr("value","false");
        }else{
            $(_this).addClass("checked");
            $(_this).parent().find("input").attr("value","true");
        }
    }
    //单选按钮事件
    function radio_click(_this){
        if($(_this).attr("id") == "radio_yes"){
            $("#enable").attr("value","true");
            $("#showdiv").show();
        }else{
            $("#enable").attr("value","false");
            $("#showdiv").hide();
        }
    }
    
    //保存设置
    function saveWaterMarkSetting(){
        var ajax_waterMarkSettingManager = new waterMarkSettingManager();
        var data = {
        	watermark_enable : $("#enable").val(),
        	watermark_name_enable : $("#name").val(),
        	watermark_deptname_enable : $("#deptname").val(),
        	watermark_time_enable : $("#time").val()
        };
        ajax_waterMarkSettingManager.saveWaterMarkSetting(data, {
            success: function (rv) {
                if(rv == "1"){
                	getCtpTop().endProc();
                    $.messageBox({
                        'type': 100,
                        'imgType': 0,
                        'msg': "${ctp:i18n('addressbook.watermark.saveSuccess.label')}",
                        buttons: [{
                            id:'btn1',
                            text: "${ctp:i18n('addressbook.watermark.determine.label')}",
                            handler: function () { location.reload(); }
                        }]
                    });
                }
            },
            error: function (rv) {
                $.alert("${ctp:i18n('addressbook.watermark.saveFailed.label')}");
            }
        });
    }
</script>
</body>
</html>