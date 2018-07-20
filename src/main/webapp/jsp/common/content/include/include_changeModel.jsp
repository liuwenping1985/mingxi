<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
	<c:if test="${contentList[0].moduleType==36||contentList[0].moduleType==37||contentList[0].moduleType==1}">
	<div id="common_view" <c:if test="${style==4}">style="display:none"</c:if>>
	<style>
	.view_model_pc{ z-index:2; position:fixed; top:20px; right:0; font-family:"Microsoft YaHei",SimSun,Arial,Helvetica,sans-serif;}
	.view_model_pc label.fieldName{ display:none;}
	.view_model_pc span.outspan{ font-family: inherit; font-size: 12px; margin-top:10px; border:1px solid #1f1f74; width:10px; height:80px; line-height:16px; background-color:#2929A6; border-radius:5px 0 0 5px; cursor:pointer; display:block; padding:10px 5px; text-align:center; color:#fff;}
	.view_model_pc span.outspan span input{ cursor:pointer; vertical-align:middle; margin-bottom:5px; width:12px; height:12px;}
	</style>
	<!--view_model_pc begin-->
	<div class="view_model_pc" id="view_model_pc" style="display:none">
	<label class="fieldName">${ctp:i18n("form.view.mode")}</label>
	<span class="outspan">
	    <c:if test="${style==3||style==4}"><span><span onclick="changeModel(1)">${ctp:i18n("form.view.mode.original")}</span></span></c:if>
	    <c:if test="${style==1}"><span><input type="checkbox" data-role="none" name="changeModelButton" value="3" id="changeModelButton2" onclick="remember(this)" <c:if test="${rememberStyle==true}">checked</c:if>><span onclick="changeModel(3)">${ctp:i18n("form.view.mode.speed")}</span></span></c:if>
	    <c:if test="${style==4}"><span><input type="checkbox" data-role="none" name="changeModelButton" value="4" id="changeModelButton3" onclick="remember(this)"><span onclick="changeModel(4)">${ctp:i18n("form.view.mode.mobile")}</span></span></c:if>
	</span>
	</div>
	</div>
	</c:if>
	<script>
	//记住模式选项
	function remember(who){
		var url = "/seeyon/form/formList.do?method=remember&formId="+form.id+($(who).attr("checked")==null?"":("&style="+$(who).val()));
		//alert(url);
		$.confirm({
      	    'msg' : '是否以后默认以该模式查看该表单?',//确定删除所选的表单?删除后数据将不可恢复
      	    ok_fn : function() {
      	    	AjaxDataLoader.load(url,null,
      	    	function(ret){
      	    		$.infor("设置成功!");
      	    	});
      	    },
			cancel_fn:function(){
				$(who).attr("checked",false);
			}
	    });
	}
	function getModel(){
		return ${style};
	}
	function disableChangeModel(){
		$("#view_model_pc").css("display","none");
	}
	//切换显示模式
	function changeModel(style){//$.alert('此功能尚未开放!');return;
		if(style==getModel()){return;}//切换的模式，与当前模式一样就不执行
        var viewState = "${viewState}";
        doChange(style);
	}
	function doChange(style){
		var url = window.location.href;
		url = setParam(url,"style",style);
		url = setParam(url,"contentDataId",$("#contentDataId",$("#mainbodyDataDiv_0")).val());
		var viewState = "${viewState}";
        if(viewState==1){//可编辑状态清表单和infopath样式表单切换的时候数据需要先预提交一次
            preSubmitData(function(){
                window.location.href = url;
            },function(){
                
            },false,false);
        }else{
            window.location.href = url;
        }	
	}
	//设置URL参数
	function setParam(url,paramName,paramValue){
		if(url.indexOf(paramName)>=0){
			url = url.replace(new RegExp(paramName+"=[-.0-9a-zA-Z_]*","g"),paramName+"="+paramValue);
		}else{
			url = url+"&"+paramName+"="+paramValue;
		}
		return url;
	}
	</script>