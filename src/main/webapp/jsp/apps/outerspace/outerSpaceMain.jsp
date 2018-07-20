<%--
 $Author: wangchw $
 $Rev: 51000 $
 $Date:: 2015-08-03 10:16:29#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>门户空间</title>
<style type="text/css">
#systemMenuTree {height:300px;overflow-y:auto;overflow-x:auto;}
</style>
<script type="text/javascript" src="${path}/ajax.do?managerName=outerspaceManager"></script>
<script>
  $(document).ready(function() {

	  getA8Top().showLocation("<span class=\"nowLocation_ico\"><img src=\"/seeyon/main/skin/frame/GOV_red3/menuIcon/personal.png\"></span><span class=\"nowLocation_content\" style=\"color: rgb(65, 65, 65);\"><a style=\"color: rgb(65, 65, 65); cursor: default;\">应用管理</a> &gt; <a class=\"hand\" style=\"color: rgb(65, 65, 65);\" onclick=\"showMenu('/seeyon/outerspace/outerspaceController.do?method=outerSpaceMain')\" href=\"javascript:void(0)\">门户空间管理</a></span>");
	  
      var msg = '${ctp:i18n("info.totally")}';

      $("input,textarea,select,a", $("#grid_detail")).attr("disabled", true);
	  
	  var mytable = $("#mytable").ajaxgrid({
      colModel : [ {
        display : 'id',
        name : 'id',
        width : '4%',
        sortable : false,
        align : 'center',
        type : 'checkbox'
      }, {
        display : '栏目名称',
        name : 'sectionLabel',
        sortable : true,
        width : '48%'
      }, {
        display : '状态',
        name : 'state',
        width : '48%',
        sortable : true
      }],
      click : tclk,
      dblclick : dblclk,
      managerName : "outerspaceManager",
      managerMethod : "getSections",
      render : rend,
      parentId:"center",
      slideToggleBtn : true,
      vChange: true,
      vChangeParam: {
          autoResize:true
      }
    });
	  
    $("#manual").show();
    $("#count").html(msg.format(mytable.p.total));
    
    function rend(txt, data, r, c) {
      if (c == 2) {
        if(data.state == "1"){
          return "${ctp:i18n('common.state.normal.label')}";
        } else if(data.state == "0"){
          return "${ctp:i18n('common.state.invalidation.label')}";
        } 
      } else {
        return txt;
      }
    }
	var myToolbar = $("#toolbar2").toolbar({
      	searchHtml: 'sss',
      	toolbar: [
		{
	      id: "modifyAttribute",
	      name: "${ctp:i18n('link.jsp.modify.attribute')}",
	      className: "ico16 modify_text_16",
		  click:function(){
			  var checkedIds = $("input:checked", $("#mytable"));
			  if (checkedIds.size() == 0) {
			    $.alert("${ctp:i18n('outerspace.select.prompt')}");
			  } else if (checkedIds.size() > 1) {
			    $.alert("${ctp:i18n('outerspace.select.selectone.prompt')}");
			  } else {
			    var checkedId = $(checkedIds[0]).attr("value");//选中行数据的ID号
			    $("#grid_detail").show();
			    $("input,select,a", $("#grid_detail")).attr("disabled", false);
			    $.post("${path}/outerspace/outerspaceController.do?method=modifyAttributeViwe&id="+checkedId, function(data){
			    	var obj = eval("("+data+")");
			    	var sectionLabel =  obj["sectionLabel"];
			    	var state = obj["state"];
			    	var columnSource = obj["columnSource"];
			    	var id = obj["id"];
			    	$("#sectionLabel").val(sectionLabel);
			    	$("#columnSource").val(columnSource);
			    	if(state=="1"){
			    		$("input[type=radio][name=state][value=1]").attr("checked",'checked')
			    		$("input[type=radio][name=state][value=0]").removeAttr("checked");
				    }else if(state=="0"){
				    	$("input[type=radio][name=state][value=0]").attr("checked",'checked')
			    		$("input[type=radio][name=state][value=1]").removeAttr("checked");
					}
			    	$("#id").val(id);
			    	var picture = obj["picture"];
			    	$("#logoFileId").val(picture);
			    	if(picture!=null && picture!="" && picture!=undefined){
			    		$("#image2").attr("src","/seeyon/fileUpload.do?method=showRTE&fileId="+picture+"&createDate=&type=image");
			    	}else{
			    		$("#image2").attr("src","/seeyon/apps_res/outerspace/images/NoPicture.jpg");
				    }
			    	$("#image2").attr("onClick","doOnclick();");
			    	$("#imageUpload").show();

			    	var imageFlag = obj["imageFlag"];
			    	if(imageFlag=="1"){
			    		$("#imageTr").hide();
			    	}else{
			    		$("#imageTr").show();
			    	}

			    	if(id=="26"){
			    		$("#sectionLabel").attr("disabled", true);
					}
			    });
			    
			    mytable.grid.resizeGridUpDown('middle');
			  }
		   }
		},{
		      id: "editData",
		      name: "${ctp:i18n('link.jsp.edit.data')}",
		      className: "ico16 editor_16",
			  click:function(){
				  var checkedIds = $("input:checked", $("#mytable"));
				  if (checkedIds.size() == 0) {
				    $.alert("${ctp:i18n('outerspace.select.prompt')}");
				  } else if (checkedIds.size() > 1) {
				    $.alert("${ctp:i18n('outerspace.select.selectone.prompt')}");
				  } else {
				    var checkedId = $(checkedIds[0]).attr("value");//选中行数据的ID号
				    var windowWidth =  screen.width-155;
					var windowHeight =  screen.height-160;
				    v3x.openWindow({
						url:"${path}/outerspace/outerspaceController.do?method=editDataMain&id="+checkedId,
						width : windowWidth,
						height : windowHeight,
						top : 50,
						left : 50,
						resizable: "yes",
						dialogType: "open"
					});
				    
				  }
			   }
			}
		]
	  });  
	  
	//双击列表中一行
    function dblclk(data, r, c) {
		$("#grid_detail").resetValidate();
        
        myToolbar.disabledAll();
        
        var checkedId = data.id;//选中行数据的ID号
	    $("#grid_detail").show();
        $("input,select,a", $("#grid_detail")).attr("disabled", false);
	    $.post("${path}/outerspace/outerspaceController.do?method=modifyAttributeViwe&id="+checkedId, function(data){
	    	var obj = eval("("+data+")");
	    	var sectionLabel =  obj["sectionLabel"];
	    	var state = obj["state"];
	    	var columnSource = obj["columnSource"];
	    	var id = obj["id"];
	    	$("#sectionLabel").val(sectionLabel);
	    	$("#columnSource").val(columnSource);
	    	if(state=="1"){
	    		$("input[type=radio][name=state][value=1]").attr("checked",'checked')
	    		$("input[type=radio][name=state][value=0]").removeAttr("checked");
		    }else if(state=="0"){
		    	$("input[type=radio][name=state][value=0]").attr("checked",'checked')
	    		$("input[type=radio][name=state][value=1]").removeAttr("checked");
			}
	    	$("#id").val(id);
	    	var picture = obj["picture"];
	    	$("#logoFileId").val(picture);
	    	if(picture!=null && picture!="" && picture!=undefined){
	    		$("#image2").attr("src","/seeyon/fileUpload.do?method=showRTE&fileId="+picture+"&createDate=&type=image");
	    	}else{
	    		$("#image2").attr("src","/seeyon/apps_res/outerspace/images/NoPicture.jpg");
		    }
	    	$("#image2").attr("onClick","doOnclick();");
	    	$("#imageUpload").show();

	    	var imageFlag = obj["imageFlag"];
	    	if(imageFlag=="1"){
	    		$("#imageTr").hide();
	    	}else{
	    		$("#imageTr").show();
	    	}
			if(id=="26"){
	    		$("#sectionLabel").attr("disabled", true);
			}
	    });
	    myToolbar.enabledAll();
	    mytable.grid.resizeGridUpDown('middle');
	}

	//记录单击事件触发的次数
	var clkCount = 0;
	//单击列表中一行，下面form显示详细信息
  	function tclk(data, r, c) {
  		$("#grid_detail").resetValidate();
        
        myToolbar.disabledAll();
        
        $("input,textarea,select,a", $("#grid_detail")).attr("disabled", true);
        
        var checkedId = data.id;//选中行数据的ID号
	    $("#grid_detail").show();
	    $.post("${path}/outerspace/outerspaceController.do?method=modifyAttributeViwe&id="+checkedId, function(data){
	    	var obj = eval("("+data+")");
	    	var sectionLabel =  obj["sectionLabel"];
	    	var state = obj["state"];
	    	var columnSource = obj["columnSource"];
	    	var id = obj["id"];
	    	$("#sectionLabel").val(sectionLabel);
	    	$("#columnSource").val(columnSource);
	    	if(state=="1"){
	    		$("input[type=radio][name=state][value=1]").attr("checked",'checked')
	    		$("input[type=radio][name=state][value=0]").removeAttr("checked");
		    }else if(state=="0"){
		    	$("input[type=radio][name=state][value=0]").attr("checked",'checked')
	    		$("input[type=radio][name=state][value=1]").removeAttr("checked");
			}
	    	$("#id").val(id);
	    	var picture = obj["picture"];
	    	$("#logoFileId").val(picture);
	    	if(picture!=null && picture!="" && picture!=undefined){
	    		$("#image2").attr("src","/seeyon/fileUpload.do?method=showRTE&fileId="+picture+"&createDate=&type=image");
	    	}else{
	    		$("#image2").attr("src","/seeyon/apps_res/outerspace/images/NoPicture.jpg");
		    }
	    	$("#image2").attr("onClick","");
	    	$("#imageUpload").hide();

	    	var imageFlag = obj["imageFlag"];
	    	if(imageFlag=="1"){
	    		$("#imageTr").hide();
	    	}else{
	    		$("#imageTr").show();
	    	}
	    });
	    myToolbar.enabledAll();
	    mytable.grid.resizeGridUpDown('middle');
    }

    $("#submitbtn").click(function() {//确认方法
		var id = $("#id").val();
		var sectionLabel = $("#sectionLabel").val();
		if (typeof(sectionLabel)=="undefined" || sectionLabel==null || sectionLabel=="") { 
			$.alert("请输入栏目名称！");
			return;
		}  
		var state = $('#state_radio input[name="state"]:checked ').val();
		var logoFileId = $("#logoFileId").val();
		$.post("${path}/outerspace/outerspaceController.do?method=modifyAttribute",{id:id,sectionLabel:sectionLabel,state:state,logoFileId:logoFileId}, function(data){
			if(data == "true"){
				refreshTable();
			}else{
				$.alert("修改失败，请稍后重试！");
			}
		});
    });
    
  });
  
  //刷新列表
  function refreshTable(){
	  window.location.reload(true);
  }
  
  function doOnclick(){
		try{
	  		getA8Top().headImgCuttingWin = getA8Top().$.dialog({
			    id : "headImgCutDialog",
	            title : "上传图片",
	            transParams:{'parentWin':window},
	            url: "${path}/outerspace/outerspaceController.do?method=logoImgCutting",
	            width: 500,
	            height: 500,
	            isDrag:false
	  		 });
		 }catch(e){}	  
	}

	function headImgCuttingCallBack (retValue) {
		getA8Top().headImgCuttingWin.close();
		if(retValue != undefined){
	          $("#image2").attr("src", "${pageContext.request.contextPath}/fileUpload.do?method=showRTE&fileId=" + retValue + "&type=image");
	          $("#imageName").val("fileId=" + retValue);
	          $("#attachmentsFlag").val(true);
	    }
	}

	function setLogoFileIdInput (logoFileId) {
		$("#logoFileId").val(logoFileId);
	}
</script>
</head>
<body>
    <c:set var="noLocationCode" value="门户空间设置"></c:set>
    <div id='layout' class="comp" comp="type:'layout'">
		<div class="layout_north" id="north" layout="height:30,sprit:false,border:false">
            <div class="comp" comp="type:'breadcrumb',code:'${noLocationCode}'"></div>
        	<div id="toolbar2"></div>
        </div>
        <div class="layout_center over_hidden" id="center" layout="border:false">
            <table id="mytable" class="flexme3" style="display: none"></table>
            <div class="form_area" id="grid_detail" style="display: none; background: none;">
            <input type="hidden" id="id" name="id" value="0" />
                <div class="two_row">
                <fieldset class="padding_10 margin_t_10">
                <legend><b>栏目基本信息</b></legend>
                    <table border="0" cellspacing="0" cellpadding="0" width="80%">
                        <tr>
                            <th nowrap="nowrap" width="35%"><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>栏目名称:</label></th>
                            <td>
                            	<div class="common_txtbox_wrap">
                                    <input type="text" id="sectionLabel" class="validate"
                                        validate="type:'string',name:'栏目名称',notNull:true" maxLength="6"/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th nowrap="nowrap" width="35%"><label class="margin_r_10" for="text">栏目来源:</label></th>
                            <td>
                            	<div class="">
                                    <textarea id="columnSource" class="validate" name="columnSource" rows="5" cols="120" readonly="readonly"></textarea>
                                </div>
                            </td>
                        </tr>
                        <tr id="imageTr">
                            <th nowrap="nowrap" width="35%"><label class="margin_r_10" for="text">栏目图片:</label></th>
                            <td>
                            	<img id="imageUpload" src="/seeyon/apps_res/outerspace/images/logodefault.png" class="radius cursor-hand" onClick="doOnclick();" style="height: 30px;"/></br>
								<img id="image2" src="" class="radius cursor-hand" onClick="" height="100px"/>
								<input type="hidden" id="imageName" name="imageName" value="">
								<input type="hidden" id="logoFileId" name="logoFileId" value="">
                            </td>
                        </tr>
                        <tr id="trSpaceState">
                            <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>状态:</label></th>
                            <td>
                            	<div class="common_radio_box clearfix" id="state_radio">
								    <label for="state" class="margin_r_10 hand"><input type="radio" id="state" name="state" class="radio_com" value="1" />${ctp:i18n("common.state.normal.label")}</label>
								    <label for="state" class="hand"><input type="radio" value="0" id="state" name="state" class="radio_com"/>${ctp:i18n("common.state.invalidation.label")}</label>
								</div>
                            </td>
                        </tr>
                    </table>
                </fieldset>
                </div>
                <div class="align_center padding_t_10 padding_b_10">
                    <span id="submitbtn" class="common_button common_button_emphasize">${ctp:i18n("common.button.ok.label")}</span>
                    <span class="common_button common_button_gray" onclick="refreshTable();">${ctp:i18n("common.button.cancel.label")}</span>
                </div>
            </div>
            <div id="manual" class="color_gray margin_l_20 display_none">
              <div class="clearfix">
                <h2 class="left">门户空间设置</h2>
                <div class="font_size12 left margin_t_20 margin_l_10">
                    <div class="margin_t_10 font_size14">
                        <span id="count"></span>
                    </div>
                </div>
              </div>
            </div>
        </div>
    </div>
</body>
</html>