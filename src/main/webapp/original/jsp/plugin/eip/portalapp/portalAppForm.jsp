<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<link rel="stylesheet" href="${path}/apps_res/plugin/eip/home/css/owl.carousel.css">
<link rel="stylesheet" href="${path}/apps_res/plugin/eip/home/css/zy-style.css">
<style type="text/css">
/* 门户首页特殊修改 start */

input[type="checkbox"],input[type="radio"]{
    margin:0;
    opacity:1;
    filter: alpha(opacity=0);
}
/* 门户首页特殊修改 end */
</style>
</head>
<body>

	<form name="addForm" id="addForm" method="post" target="addDeptFrame">
	<div class="form_area" >
	
		<div class="one_row" >
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<br>
			<br>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>					
					<input type="hidden" name="id" id="id" value="" />
					<input type="hidden" id="portalId" name="portalId" value="">
					<input type="hidden" id="columnCode" name="columnCode" value="">
					<input type="hidden" id="columnDetailId" name="columnDetailId" value="">
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>门户编号:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="portalCode" style="width:100%;cursor: pointer;" readonly="readonly" class="validate word_break_all" name="portalCode"  placeholder="点击选择门户编号"
									validate="name:'门户编号',notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>栏目编号:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="columnName" style="width:100%;cursor: pointer;" readonly="readonly" class="validate word_break_all" name="columnName"  placeholder="点击选择栏目名称"
									validate="name:'栏目名称',notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>应用名称:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="appSystemName" style="width:100%;" class="validate word_break_all" name="appSystemName"
									validate="name:'应用名称',notNull:true,minLength:1,maxLength:25">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>内容或参数:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="columnDetailName" style="width:100%;cursor: pointer;" readonly="readonly" class="validate word_break_all" name="columnDetailName"  placeholder="点击输入或选择内容"
									validate="name:'内容',notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>序号:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="appSystemCode" style="width:100%;" class="validate word_break_all" name="appSystemCode"
									validate="name:'序号',notNull:true,minLength:1,maxLength:6,regExp:/^[0-9]*$/,errorMsg:'请输入大于0小于999999数值！'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>系统标识:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="systemToken" style="width:100%;" class="validate word_break_all" name="systemToken"
									validate="name:'系统标识',notNull:true,minLength:1,maxLength:255,regExp:/^[a-zA-Z0-9_-]*$/,errorMsg:'只允许填写大小写字母、_、-的自由组合！'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>状态:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<select id="isEnable" name="isEnable" class="codecfg" style="width: 100%; border: 0px;" 
    							codecfg="codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EnableColumnTypeEnum'">
    								<!-- <option value="">请选择</option> -->
								</select>
							</div>
						</td>
					</tr>
					<tr id="_appIcon">
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>图标:</label></th>
						<!-- <td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="appIcon" style="width:100%;" class="validate word_break_all" name="appIcon"
									validate="name:'图标',notNull:true,minLength:1,maxLength:255">
							</div>
						</td> -->
						<td id="iconmouse_00"  ><!-- onmouseleave="eventMI(this,false)" -->
	                <%-- <div class="common_txtbox_wrap">
	                    <input  type="text" name="appIcon" class="validate" validate="type:'string',name:'图标',notNull:false,minLength:1,maxLength:20,avoidChar:'\'\\/|><:*?&quot&%$'" />
	                </div> --%>
	                
	                <!-- 中对齐 -->
				    <div name="_pl_affairICO" class="common_radio_box clearfix align_center" style="margin-top: 5px;">
		                <div ><label for="radio14" class="margin_r_10 hand">我的待办/我的发起/我的查询</label></div>
				    	<label for="radio14" class="margin_r_10 hand">
				            <div style="height: 100%"><input type="radio" value="db1"  name="appIcon" checked="checked" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"></div><span class="n-q db1" style="zoom:0.55;"><a href="#"></a></span></label>
				        <label for="radio15" class="margin_r_10 hand">
				            <input type="radio" value="db2"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><span class="n-q db2" style="zoom:0.55;"><a href="#"></a></span></label>
				        <label for="radio16" class="margin_r_10 hand">
				            <input type="radio" value="db3"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><span class="n-q db3" style="zoom:0.55;"><a href="#"></a></span></label>
				        <label for="radio17" class="margin_r_10 hand">
				            <input type="radio" value="db4"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><span class="n-q db4" style="zoom:0.55;"><a href="#"></a></span></label>
				        <label for="radio18" class="margin_r_10 hand">
				            <input type="radio" value="db5"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><span class="n-q db5" style="zoom:0.55;"><a href="#"></a></span></label>
				        <!-- <label for="radio18" class="margin_r_10 hand">
				        	<a id="moreIcons"href="javascript:void(0)" onclick="eventMI(this)" class="common_button common_button_emphasize" style="float: right; width: 24px">更多</a></label> -->
				    </div>
					<div name="_pl_affairICO" class="common_radio_box clearfix align_center" style="margin-top: 5px;/* display: none; */ float: left;height: 35px;""  name="iconmouse_01">
				        <label for="radio14" class="margin_r_10 hand">
				            <input type="radio" value="fq1"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><span class="n-q fq1 " style="zoom:0.55;"><a href="#"></a></span></label>
				        <label for="radio15" class="margin_r_10 hand">
				            <input type="radio" value="fq2"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><span class="n-q fq2 " style="zoom:0.55;"><a href="#"></a></span></label>
				        <label for="radio16" class="margin_r_10 hand">
				            <input type="radio" value="fq3"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><span class="n-q fq3 " style="zoom:0.55;"><a href="#"></a></span></label>
				        <label for="radio17" class="margin_r_10 hand">
				            <input type="radio" value="fq4"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><span class="n-q fq4 " style="zoom:0.55;"><a href="#"></a></span></label>
				        <label for="radio18" class="margin_r_10 hand">
				            <input type="radio" value="fq5"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><span class="n-q fq5 " style="zoom:0.55;"><a href="#"></a></span></label>
				        
				    </div>
				    
				    <div name="_pl_affairICO" class="common_radio_box clearfix align_center" style="margin-top: 5px; /* display: none; */ float: left;height: 35px;" name="iconmouse_01">
				        <label for="radio14" class="margin_r_10 hand">
				            <input type="radio" value="cx1"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><span class="n-q cx1 " style="zoom:0.55;"><a href="#"></a></span></label>
				        <label for="radio15" class="margin_r_10 hand">
				            <input type="radio" value="cx2"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><span class="n-q cx2 " style="zoom:0.55;"><a href="#"></a></span></label>
				        <label for="radio16" class="margin_r_10 hand">
				            <input type="radio" value="cx3"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><span class="n-q cx3 " style="zoom:0.55;"><a href="#"></a></span></label>
				        <label for="radio17" class="margin_r_10 hand">
				            <input type="radio" value="cx4"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><span class="n-q cx4 " style="zoom:0.55;"><a href="#"></a></span></label>
				        <!-- <label for="radio18" class="margin_r_10 hand">
				            <input type="radio" value="cx5"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><span class="n-q cx5 " style="zoom:0.55;"><a href="#"></a></span></label> -->
				        
				    </div>
				    <div name="_pl_boardICO" class="common_radio_box clearfix align_center" style="margin-top: 5px;/*  display: none; */ float: left;height: 50px;" name="iconmouse_01">
				    	<div ><label for="radio14" class="margin_r_10 hand">数据看板</label></div>
				        <label for="radio14" class="margin_r_10 hand">
				            <input type="radio" value="skb1"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="skb-img skb1 " style="zoom:0.36; float: left;"><a href="#"></a></div></label>
				        <label for="radio15" class="margin_r_10 hand">
				            <input type="radio" value="skb2"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="skb-img skb2 " style="zoom:0.36; float: left;"><a href="#"></a></div></label>
				        <label for="radio16" class="margin_r_10 hand">
				            <input type="radio" value="skb3"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="skb-img skb3 " style="zoom:0.36; float: left;"><a href="#"></a></div></label>
				        <label for="radio17" class="margin_r_10 hand">
				            <input type="radio" value="skb4"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="skb-img skb4 " style="zoom:0.36; float: left;"><a href="#"></a></div></label>
				        <label for="radio18" class="margin_r_10 hand" style="float: left;display: block;width: 32px;height: 32px" >
				           </label>
				        
				    </div>
				    
				    <div name="_pl_boardICO" class="common_radio_box clearfix align_center" style="margin-top: 5px; /* display: none; */ float: left;height: 35px;" name="iconmouse_01">
				        <label for="radio14" class="margin_r_10 hand">
				            <input type="radio" value="skb6"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="skb-img skb6 " style="zoom:0.36; float: left;"><a href="#"></a></div></label>
				        <label for="radio15" class="margin_r_10 hand">
				            <input type="radio" value="skb7"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="skb-img skb7 " style="zoom:0.36; float: left;"><a href="#"></a></div></label>
				        <label for="radio16" class="margin_r_10 hand" >
				            <input type="radio" value="skb8"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="skb-img skb8 " style="zoom:0.36; float: left;"><a href="#"></a></div></label>
				       	<label for="radio18" class="margin_r_10 hand">
				            <input type="radio" value="skb5"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="skb-img skb5 " style="zoom:0.36; float: left;"><a href="#"></a></div></label>
				       	<label for="radio18" class="margin_r_10 hand" style="float: left;display: block;width: 32px;height: 32px" >
				           </label>
				       	
				       	
				    </div>
				    <div name="_pl_toolICO" class="common_radio_box clearfix align_center" style="margin-top: 5px; /* display: none; */ float: left;height: 50px;" name="iconmouse_01">
				    	<div><label for="radio14" class="margin_r_10 hand">综合管理</label></div>
				        <label for="radio14" class="margin_r_10 hand">
				            <input type="radio" value="zg1"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="szg-img zg1 " style="zoom:0.37; float: left;"><a href="#"></a></div></label>
				        <label for="radio15" class="margin_r_10 hand">
				            <input type="radio" value="zg2"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="szg-img zg2 " style="zoom:0.37; float: left;"><a href="#"></a></div></label>
				        <label for="radio16" class="margin_r_10 hand">
				            <input type="radio" value="zg3"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="szg-img zg3 " style="zoom:0.37; float: left;"><a href="#"></a></div></label>
				        <label for="radio17" class="margin_r_10 hand">
				            <input type="radio" value="zg4"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="szg-img zg4 " style="zoom:0.37; float: left;"><a href="#"></a></div></label>
				        <label for="radio18" class="margin_r_10 hand" >
				            <input type="radio" value="zg5"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="szg-img zg5 " style="zoom:0.37; float: left;"><a href="#"></a></div></label>
				        <label for="radio18" class="margin_r_10 hand" >
				            </label>
				        
				    </div>
				    <div name="_pl_toolICO" class="common_radio_box clearfix align_center" style="margin-top: 5px; /* display: none; */ float: left; height: 35px;" name="iconmouse_01">
				        <label for="radio14" class="margin_r_10 hand" >
				            <input type="radio" value="zg6"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="szg-img zg6 " style="zoom:0.37; float: left;"><a href="#"></a></div></label>
				        <label for="radio15" class="margin_r_10 hand" >
				            <input type="radio" value="zg7"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="szg-img zg7 " style="zoom:0.37; float: left;"><a href="#"></a></div></label>
				        <label for="radio16" class="margin_r_10 hand" >
				            <input type="radio" value="zg8"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="szg-img zg8 " style="zoom:0.37; float: left;"><a href="#"></a></div></label>
				        <label for="radio17" class="margin_r_10 hand" >
				            <input type="radio" value="zg9"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="szg-img zg9 " style="zoom:0.37; float: left;"><a href="#"></a></div></label>
				        <label for="radio18" class="margin_r_10 hand" >
				            <input type="radio" value="zg10"  name="appIcon" class="radio_com" style="float: left;margin-top: 10px;margin-left: 5px"><div class="szg-img zg10 " style="zoom:0.37; float: left;"><a href="#"></a></div></label>
				        <label for="radio18" class="margin_r_10 hand" >
				            </label>
				        
				    </div>
				 </td>
				 <script type="text/javascript">
						var m = true;
						function eventMI(obj){
							if(m){
								if($("div[name=iconmouse_01]").css("display")=="none"){
								 	$("div[name=iconmouse_01]").fadeIn("slow");
								}
								$("#moreIcons").text("收起");
							}else{
								if($("div[name=iconmouse_01]").css("display")!="none"){
								 	$("div[name=iconmouse_01]").fadeOut("slow");
								}
								$("#moreIcons").text("更多");
							}
							m = !m;
						}
						function iconUploadCallback(obj) {
							var attList = obj.instance;
							var len = attList.length;
							for(var i = 0; i < len; i++) {
								var att = attList[i];
								var fileID = att.fileUrl;
								var myDate = new Date();
								var result=myDate.getFullYear()+'-'+(myDate.getMonth()+1)+'-'+myDate.getDate();
								var createdate = (att.createDate && att.createDate != undefined) ? att.createDate : result;
					
								var iconDownloadUrl = "${path}/fileUpload.do?method=showRTE&fileId="+fileID+"&createDate="+createdate+"&type=image";
								var imageAreaStr = 	"<img name='imgIcon' id = 'imgIcon' src='" + iconDownloadUrl + "' width='140' height='75'>";
					
								var iconValue = "/fileUpload.do?method=showRTE&fileId="+fileID+"&createDate="+createdate+"&type=image";
								$("#systemImg").val(iconValue);
								$("#iconDiv1").html(imageAreaStr);
							}
						}
						function createImage(url){
							return  "<img name='imgIcon' id = 'imgIcon' src='"+_ctxPath + url + "' width='140' height='75'>";
						}
				    </script>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>图片:</label></th>
						<td width="100%" >
							<!-- <div class="common_txtbox_wrap">
								<input type="text" id="systemImg" style="width:100%;" class="validate word_break_all" name="systemImg"
									validate="name:'图片',notNull:true,minLength:1,maxLength:255">
								
							</div> -->
							<input type="hidden" id="systemImg" name="systemImg"> <input id="iconInput" type="hidden" class="comp"
								comp="type:'fileupload', applicationCategory:'39',  extensions:'png,jpg', isEncrypt:false,quantity:1,maxSize: 1048576,
								 canDeleteOriginalAtts:true, originalAttsNeedClone:false, firstSave:true,callMethod:'iconUploadCallback'">
								<table>
									<tr>
										<td>
											<div id="iconDiv1" class="iconArea" style="width:140px;height: 75px; border:dotted #666 3px"></div>
										</td>
									</tr>
								</table>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">图片规格:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="systemImgSpec" style="width:100%;" readonly="readonly" class="validate word_break_all" name="systemImgSpec"
									validate="name:'图片规格',notNull:false,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>授权:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="empowerIds" name="empowerIds" readonly="readonly" class="comp" style="width:100%;cursor: pointer;" placeholder="点击授权"
     						comp="name:'授权',type:'selectPeople',notNull:true,mode:'open',panels: 'Account,Department,Team,Post,Level,Outworker',selectType: 'Account,Team,Post,Level,Outworker,Department,Member',
     						value:'',text:''"/>
							</div>
						</td>
					</tr>
					<!-- <tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">备用值:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="backUpValue" style="width:100%;" class="validate word_break_all" name="backUpValue"
									validate="name:'备用值',notNull:false,minLength:1,maxLength:255">
							</div>
						</td>
					</tr> -->
				</tbody>
			</table>
		</div>
		</div>
	</form>


</body>
</html>