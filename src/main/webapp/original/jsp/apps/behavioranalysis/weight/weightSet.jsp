<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden page_color">
<head>
	<title></title>
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<style>
	    .stadic_head_height{height:60px;background: #fbfbfb;}
	    .stadic_body_top_bottom{top: 60px;bottom: 50px;background: #fff;}
	    .stadic_footer_height{height:50px;}
	    .new-action-bottom{ height: 50px;background: #4d4d4d;border-bottom:none;vertical-align:middle;text-align:right; line-height: 50px;}
	    .new-action-bottom .common_button { height: 28px; line-height: 28px; text-align: center; font-size:12px; cursor: pointer;}
	    .someInfo{ font-size: 14px; line-height: 23px;  color: #777; padding:7px 0 0 20px; height: 52px; border-bottom: 1px solid #e2e2e2;}
		.module{ width:355px; margin:12px 0 10px 20px; float:left; background:#FBFBFB;}
		.module .moduleTable{ border-collapse: collapse; border-bottom: 1px solid #E3E3E3; border-right: 1px solid #E3E3E3; font-size: 14px;}
		.module .moduleTable .inputfield{ width:60px; height: 18px; line-height: 18px; font-size: 12px; text-align: center; margin:0 5px; font-size: 13px;}
		.module .moduleTable .disable_input{cursor: not-allowed;background:gray;}
		.module .moduleTable th{ height: 30px; }
		.module .moduleTable th .inputfield{ border:1px solid transparent;}
		.module .moduleTable th{ background: #80AAD4; color: #fff; }
		.module .moduleTable td{ height: 34px; }
		.module .moduleTable td .inputfield{ border:1px solid #DEE4EF;}
		.secondTitle td{border-bottom: 1px solid #E3E3E3;}
		.fieldTotal td{ height: 50px; padding-top:10px; padding-bottom:10px;}
		.error-info{ background: #FCD6D6; color: #E46666; }
		.padding_l_40{padding-left: 40px;}
		.clearboth{ clear: both; }
	
		.previewDiv{width:490px; margin:0 auto; padding: 0 20px;}
		.previewDiv h4{ text-align: center; font-size: 14px; line-height: 30px;  padding: 10px 0;}
		.previewDiv p{ font-size: 14px; line-height: 20px; }
		.previewDiv .previewDivTable td{border-bottom: 1px solid #E3E3E3; height: 30px;}
		.hasIcon{ padding-left: 80px; }
	</style>
</head>
<body class="h100b over_hidden page_color">

	<div class="stadic_layout">
        <%-- 上方说明文字 --%>
        <div class="stadic_layout_head stadic_head_height">
            <div class="someInfo">
				<p>${ctp:i18n("behavioranalysis.weightSet.desc1") }<!-- 说明：行为绩效分根据工作维度，考核指标及权重进行加权计算得来。 --></p>
				<p>${ctp:i18n("behavioranalysis.weightSet.desc2") }<!-- 您可以根据实际情况调整各级指标的权重，对不参与考核的指标，建议您将权重设置为0%。设置保存后，调整结果会在当月底统计生效。 --></p>
            </div>
        </div>
        
        <%--  中间的表格  --%>
        <div class="stadic_layout_body stadic_body_top_bottom">
        	<c:forEach items="${datas }" var="mMap">
            <div class="module">
            	<table class="moduleTable" width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <th align="left" class="padding_l_20">${ctp:i18n("behavioranalysis.weightSet.main.".concat(mMap.key)) }</th>
                    <th align="center" width="140">${ctp:i18n("behavioranalysis.weightSet.accounting") } <!-- 占比 --><input tid="${mMap.value.id }" class="main_index socre_index inputfield" key="${mMap.key }" label="${ctp:i18n("behavioranalysis.weightSet.main.".concat(mMap.key)) }" type="text" value="${mMap.value.weightInt }"/>%</th>
                  </tr>
                  <tr class="secondTitle">
                    <td class="padding_l_40">${ctp:i18n("behavioranalysis.weightSet.index") }<!-- 指标 --></td>
                    <td class="padding_l_20">${ctp:i18n("behavioranalysis.weightSet.accounting") } <!-- 占比 --></td>
                  </tr>
                  <c:forEach items="${mMap.value.children  }" var="subMap">
	                  <tr>
	                    <td class="padding_l_40">${ctp:i18n("behavioranalysis.weightSet.sub.".concat(subMap.key)) }${ subMap.value.hasStoped ? "[功能停用]":""}</td>
	                    <td class="padding_l_20"><input class="sub_index  ${mMap.key } socre_index inputfield" key="${subMap.key }" tid="${subMap.value.id }" parentIndex="${mMap.key }" type="text" value="${subMap.value.weightInt }"/>%</td>
	                  </tr>
                  </c:forEach>
                  <tr class="fieldTotal ${mMap.key }_total_tr">
                    <td class="padding_l_40">${ctp:i18n("behavioranalysis.weightSet.sub.total") }</td>
                    <td class="padding_l_40 ${mMap.key }_total" parentIndex="${mMap.key }">100%</td>
                  </tr>
                </table>
            </div>
            </c:forEach>
        </div>
        
        <%--  下边的按钮  --%>	
        <div class="stadic_layout_footer stadic_footer_height">
        	<div class="new-action-bottom">
        		<a href="javascript:;" class="common_button common_button_gray resetDefault">${ctp:i18n("behavioranalysis.weightSet.default") }<!-- 恢复系统默认 --></a>
        		<a href="javascript:;" class="common_button common_button_emphasize margin_l_10 previewScore">${ctp:i18n("behavioranalysis.weightSet.preview") }<!-- 结果预览 --></a>
        		<a href="javascript:;" class="common_button common_button_emphasize margin_l_10 margin_r_20 save">${ctp:i18n("behavioranalysis.weightSet.save") }<!-- 保存 --></a>
        		<a href="javascript:;" class="common_button common_button_emphasize margin_l_10 margin_r_20 reset" style="display: none;">重置</a>
        	</div>
        </div>
        
    </div>
    
	<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<script type="text/javascript">
		
		var weightSet = function(){};
	   /**
		*二级指标发生变化，事件处理
		*@param $this 当前改变的DOM对象
		*/
		weightSet.onChangeSubIndex = function($this){
			//不能输入非数字的
			weightSet.numOnly($this);
			return weightSet.validateSubIndex($this.attr("parentIndex"));
		}
	   /**
		*一级指标发生变化，事件处理
		*@param $this 当前改变的DOM对象
		*/
		weightSet.onChangeMainIndex = function($this){
			//不能输入非数字的
			weightSet.numOnly($this);
			var v = $this.val();
			var keyIndex = $this.attr("key");
			if( v == "0"){
				$("." + keyIndex).val(0).addClass("disable_input").disable();
				$("." + keyIndex + "_total").text("0%");
				$("." + keyIndex + "_total_tr").removeClass("error-info");
			}else{
				$("." + keyIndex).removeClass("disable_input").enable();
				//验证二级指标
				weightSet.validateSubIndex(keyIndex);
			}
		}
		/**
		 *不能输入非数字的
		 *@param $this 当前改变的DOM对象
		 */
		 weightSet.numOnly = function($this){
			//不能输入非数字的
			var v = $this.val().replace(/\D/g,'');
			if(v != "" && !isNaN(v) ){
				$this.val(parseInt(v));
			}else if(v == ""){
				$this.val("");
			}
		}
		/** 
		 *验证二级指标 
		 *@param parentIndexClass 父指标的可以，通过key查找全部的二指标
		 */
		 weightSet.validateSubIndex = function(parentIndexClass){
			var success = true;
			var $subIndexs = $("." + parentIndexClass);
			var total = 0;
			for(var i = 0 ; i < $subIndexs.length ; i ++){
				var v = $subIndexs.eq(i).val();
				if(v != "" && !isNaN(v)){
					total += parseInt(v);
				}
			}
			var $total = $("." + parentIndexClass + "_total");
			if(total != 100 ){
				success = false;
				//标红全部
				$("." + parentIndexClass + "_total_tr").addClass("error-info");
			}else{
				//取消标红全部
				$("." + parentIndexClass + "_total_tr").removeClass("error-info");
			}
			$total.text(total + "%");
			return success;
		}
		/**
		 *验证指标的正确性
		 */
		weightSet.validateIndex = function(){
			var success = true;
			var msg = "";
			var $main_index = $(".main_index");
			var total = 0;
			var fistLevelIsZero = 0;
			for(var i = 0; i < $main_index.length ; i++ ){
				var $m = $main_index.eq(i);
				var tv = $m.val();
				if( tv == "" || tv == "0"){
					//1、0% 占比小于3 判断
					fistLevelIsZero += 1;
					if(fistLevelIsZero > 2){
						success = false;
						msg =  "${ctp:i18n("behavioranalysis.weightSet.validate.msg1")}";//请至少设置3个一级指标，请修改！";
						break;
					}
				}else if(weightSet.validateSubIndex($m.attr("key"))){
					//2、验证二级指标通过
					if(tv != "" && !isNaN(tv)){
						total += parseInt(tv);
					}
				}else{
					//3、二级指标不通过
					success = false;
					msg =  '${ctp:i18n("behavioranalysis.weightSet.validate.msg3")}' + $m.attr("label") + '${ctp:i18n("behavioranalysis.weightSet.validate.msg4")}';
					//"您设置的" + $m.attr("label") + "二级指标权重之和不等于100%，请修改！";
					break;
				}
			}
			if(success && total != 100){
				msg = '${ctp:i18n("behavioranalysis.weightSet.validate.msg2")}';//您设置的一级指标权重之和不等于100% ，请修改！";
				success = false;
			}
			return {"success" : success , "msg" : msg };
		}
		/**
		 *保存设置
		 */
		weightSet.doSave = function(){
			//单独调用
			var proce = $.progressBar({
				txt : "${ctp:i18n("behavioranalysis.weightSet.save.ing")}",
				targetWindow : getA8Top()
			});
			//向后台提交数据
			var manager = new indexScoreSetManager();
			manager.save(weightSet.getSubmitData(),{
				success : function(ret){
					if(ret.success){
						proce.close();
						$.infor({
							 msg : "${ctp:i18n("behavioranalysis.weightSet.save.success")}",
							 ok_fn: function () {
								 window.location.href  = _ctxPath + "/behavioranalysis.do?method=weightSet";
							 }
						});
					}else{
						proce.close();
						$.error(ret.msg);
					}
				},
				error : function(){
					proce.close();
					$.error("${ctp:i18n("behavioranalysis.weightSet.save.fail")}");
				}
			})
		}
		/**
		 *保存设置
		 */
		weightSet.doPreviewScore = function(){
			 var dialog = $.dialog({
		            id: 'previewScore',
		            height : 450,
		            width : 550,
		            targetWindow : getA8Top(),
		            title : '${ctp:i18n("behavioranalysis.weightSet.previewScore.title")}',
		            url : _ctxPath + "/behavioranalysis.do?method=previewScore",
		            transParams:weightSet.getSubmitData()
		        });
		}
		/**
		 *获取要提交的数据
		 */
		weightSet.getSubmitData = function(){
			//生成后台需要的数据格式
			var subparams = new Object();
			var $indexs = $(".socre_index");
			for(var i = 0; i < $indexs.length ; i++){
				var $tIndex = $indexs.eq(i);
				var v = $tIndex.val();
				if(v == ""){
					v = 0;
				}
				subparams[$tIndex.attr("key")] = {
						"id" : $tIndex.attr("tid"),
						"indexWeight" : v,
						"parentIndexType" : $tIndex.attr("parentIndex")
				}
			}
			return subparams;
		}
		/**
		 *获取要提交的数据
		 */
		weightSet.resizeWindow = function(){
			//生成后台需要的数据格式
			$(".clearboth").removeClass("clearboth");
			var winWidth = $(window).width() - 40;
			var sepNum = parseInt(winWidth/367);
			//对换行的加一个class
			for(var i = 1 ; i * sepNum < weightSet.$module.length ; i++ ){
				weightSet.$module.eq(i * sepNum).addClass("clearboth");
			}
		}
		/**
		 *页面事件初始化
		 */
		weightSet.initEvents = function(){
			//二级指标验证
			$(".sub_index").off("keyup").on("keyup",function(e){
				weightSet.onChangeSubIndex($(this));
			}).off("blur").on("blur",function(){
				var v = $(this).val();
				if(v == ""){
					$(this).val("0")
					weightSet.onChangeSubIndex($(this));
				}
			});
			//一级指标只输入数字
			$(".main_index").off("keyup").on("keyup",function(e){
				weightSet.onChangeMainIndex($(this));
			}).off("blur").on("blur",function(){
				var v = $(this).val();
				if(v == ""){
					$(this).val("0")
					weightSet.onChangeMainIndex($(this));
				}
			});
			//保存按钮事件
			$(".save").off("click").on("click",function(){
				var result = weightSet.validateIndex();
				if(result.success){
					weightSet.doSave();
				}else{
					$.error(result.msg);
				}
			});
			//预览
			$(".previewScore").off("click").on("click",function(){
				var result = weightSet.validateIndex();
				//判断是否存在上月的流程绩效
				var m = new behavioranalysisAjaxManager();
				if(m.checkHasIndexScore()){
					if(result.success){
						weightSet.doPreviewScore();
					}else{
						$.error(result.msg);
					}
				}else{
					$.alert("${ctp:i18n("behavioranalysis.weightSet.previewScore")}");
				}
			});
			//重置
			$(".reset").off("click").on("click",function(){
				$.confirm({
			        'msg': '${ctp:i18n("behavioranalysis.weightSet.reset")}',//你确定要重置的指标权重吗?',
			        ok_fn: function () { 
			        	window.location.href  = _ctxPath + "/behavioranalysis.do?method=weightSet";
			        }
			    });
			});
			//恢复系统默认
			$(".resetDefault").off("click").on("click",function(){
				$.confirm({
			        'msg': '${ctp:i18n("behavioranalysis.weightSet.resetDefault")}',
			        ok_fn: function () { 
			        	window.location.href  = _ctxPath + "/behavioranalysis.do?method=weightSet&resetDefault=resetDefault";
			        }
			    });
			});
			 $(window).resize(function(){
				 weightSet.resizeWindow();
			 });
		}
		$(function(){
			//初始化事件
			weightSet.initEvents();
			//回填重新验证一级指标
			weightSet.$module = $(".module");
			weightSet.$module.each(function(i,t){
				weightSet.onChangeMainIndex($(t).find(".main_index"));
			})
			//修改float的样式，让排序对齐
			weightSet.resizeWindow();
		})
	</script>
</body>
</html>