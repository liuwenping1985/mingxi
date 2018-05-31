/**
 * @author macj
 */
var skinSaveData = {};
function CtpSkinChange(options) {
  if (options == undefined) options = {};
  this.p = $.extend(
          {
            id : Math.floor(Math.random() * 100000000),
            render : null,// 渲染目标
            skinId : 'harmony',// 当前选中的模式
            topBgImg : 'main/skin/frame/harmony/images/header1.png',// 自定义banner图片
            topBgColor : {// banner区域背景颜色 + 颜色选择器色系索引 + 颜色选择器色系颜色索引
              color : '#45a6d0',
              colorList : '12',
              colorIndex : '4'
            },
            lBgColor : {// 左侧区域背景颜色 + 颜色选择器色系索引 + 颜色选择器色系颜色索引
              color : '#022c55',
              colorList : '13',
              colorIndex : '14'
            },
            cBgColor : {// 栏目区域背景颜色 + 颜色选择器色系索引 + 颜色选择器色系颜色索引
              color : '#15a4fa',
              colorList : '12',
              colorIndex : '5'
            },
            mainBgImg:'http://mat1.gtimg.com/www/images/qq2012/qqlogo_2x.png',//换肤－首页－大背景图
            mainBgColor:{  //换肤－首页－颜色
              color : '#53718b',
              colorList : '12',
              colorIndex : '15'
            },
            skin_template_type: 0,
            /**
            skinId : 'peaceful',// 当前选中的模式
            topBgImg : 'peaceful_head.png',// 自定义banner图片
            topBgColor : {// banner区域背景颜色 + 颜色选择器色系索引 + 颜色选择器色系颜色索引
	            color : '#266a6d',
	            colorList : '10',
	            colorIndex : '10'
            },
            lBgColor : {// 左侧区域背景颜色 + 颜色选择器色系索引 + 颜色选择器色系颜色索引
                color : '#0c404c',
                colorList : '11',
                colorIndex : '1'
            },
            cBgColor : {// 栏目区域背景颜色 + 颜色选择器色系索引 + 颜色选择器色系颜色索引
                color : '#18a110',
                colorList : '9',
                colorIndex : '4'
            },
            
            
              skinId : 'wisdom',// 当前选中的模式
              topBgImg : 'wisdom_head.png',// 自定义banner图片
              topBgColor : {// banner区域背景颜色 + 颜色选择器色系索引 + 颜色选择器色系颜色索引
                  color : '#412845',
                  colorList : '15',
                  colorIndex : '15'
              },
              lBgColor : {// 左侧区域背景颜色 + 颜色选择器色系索引 + 颜色选择器色系颜色索引
                  color : '#432847',
                  colorList : '15',
                  colorIndex : '13'
              },
              cBgColor : {// 栏目区域背景颜色 + 颜色选择器色系索引 + 颜色选择器色系颜色索引
                  color : '#b76a8b',
                  colorList : '15',
                  colorIndex : '17'
              },
            **/
            
            changeSkin : true,// 推荐风格是否可用
            changeBg : true,// 个性化设置是否可用
            onClose : function() {
            },// 关闭事件
            onChange:null,//点击调用事件
            onChooseSkinStyle:null,//选择风格调用事件
            onSuccess : function() {  
            },//换肤组件加载完成后追加执行事件
            data : [ {
              id : 'harmony',
              name : '和谐之美',
              image : 'recommend1.png',
              color : {
                color : '#45a6d0',
                colorList : '12',
                colorIndex : '4',
                border_bottom:'#3368ad'	
              },
              navBg : {
                color : '#022c55',
                colorList : '13',
                colorIndex : '14'
              },
              column : {
                color : '#15a4fa',
                colorList : '12',
                colorIndex : '5'
              },
              banner : 'main/skin/frame/harmony/images/header1.png'
            }, {
              id : 'peaceful',
              name : '宁静之韵',
              image : 'recommend2.png',
              color : {
                color : '#266a6d',
                colorList : '10',
                colorIndex : '10',
                border_bottom:'#234a39'	
              },
              navBg : {
                color : '#0c404c',
                colorList : '11',
                colorIndex : '1'
              },
              column : {
                color : '#18a110',
                colorList : '9',
                colorIndex : '4'
              },
              banner : 'main/skin/frame/peaceful/images/peaceful_head.png'
            }, {
              id : 'wisdom',
              name : '智慧之美',
              image : 'recommend3.png',
              color : {
                color : '#412845',
                colorList : '15',
                colorIndex : '15',
                border_bottom:'#0d0a0f'		
              },
              navBg : {
                color : '#432847',
                colorList : '15',
                colorIndex : '13'
              },
              column : {
                color : '#b76a8b',
                colorList : '15',
                colorIndex : '17'
              },
              banner : 'main/skin/frame/wisdom/images/wisdom_head.png'
            } ],
            colorList : [
                {
                  'model' : '#303030',
                  'list' : [ "#071111", "#1f2627", "#353c3d", "#4b5354",
                      "#636b6c", "#7c8485", "#0a1011", "#1e2223", "#323637",
                      "#454b4c", "#5c6162", "#727878", "#000000", "#1d1d1d",
                      "#252525", "#3c3c3c", "#525252", "#6b6b6b" ]
                },
                {
                  'model' : '#d7dae0',
                  'list' : ["#ffffff","#f2e5fc","#cbe6dd","#c7e9fb","#e3e0ca","#f8e5e1","#dbe2ec","#d3e1ff","#9fd6c4","#95cce8","#c8c49e","#dac4bf","#d7dae0","#d0c4da","#79bba6","#68b8e1","#aaa579","#cea69d" ]
                },
                {
                  'model' : '#da0025',
                  'list' : [ "#6e0012", "#8d0017", "#ad001d", "#cf0023",
                      "#f10025", "#ff2c37", "#54001d", "#710025", "#8e0032",
                      "#ad2a3f", "#cd484a", "#eb6360", "#43001c", "#5e1129",
                      "#792a38", "#964449", "#b45d59", "#d17670" ]
                },
                {
                  'model' : '#f01800',
                  'list' : [ "#4f0006", "#6d0004", "#8c0001", "#ac0000",
                      "#cd0000", "#ef0000", "#380003", "#510000", "#6e0000",
                      "#8b1202", "#a9331a", "#c84e31", "#290002", "#3f0200",
                      "#591b0b", "#733220", "#8f4a37", "#ac634e" ]
                },
                {
                  'model' : '#ff4300',
                  'list' : [ "#660003", "#850000", "#a40000", "#c50000",
                      "#e61f00", "#ff4608", "#500000", "#6c0000", "#891700",
                      "#a73511", "#c65129", "#e56b41", "#3c0600", "#561e0a",
                      "#703420", "#8c4c36", "#a8654d", "#c57f65" ]
                },
                {
                  'model' : '#fd6c05',
                  'list' : [ "#82000a", "#920000", "#b22600", "#d34500",
                      "#f26000", "#ff7c1c", "#5f1300", "#872003", "#984512",
                      "#bd4625", "#d37742", "#f7a16c", "#4f2307", "#69391e",
                      "#845134", "#a06a4c", "#bc8363", "#d99e7d" ]
                },
                {
                  'model' : '#feab07',
                  'list' : [ "#6c2c13", "#8f4c00", "#ad6500", "#cb7e00",
                      "#eb9900", "#ffb317", "#4d2600", "#683b00", "#835300",
                      "#a06c13", "#bc852f", "#da9f49", "#472900", "#5f3f0b",
                      "#7a5723", "#96703b", "#b18952", "#cea36c" ]
                },
                {
                  'model' : '#ffc91e',
                  'list' : [ "#653d00", "#825400", "#a06d00", "#bd8600",
                      "#dca000", "#ffbf00", "#452a00", "#5f4000", "#7a5800",
                      "#977008", "#b38928", "#d0a444", "#412c00", "#5a4206",
                      "#745a20", "#8f7338", "#aa8c50", "#c7a669" ]
                },
                {
                  'model' : '#93c900',
                  'list' : [ "#002800", "#003c00", "#005500", "#1f6e00",
                      "#418700", "#5ea200", "#002300", "#173800", "#304f00",
                      "#496700", "#638118", "#7d9b34", "#122000", "#273503",
                      "#3d4b1b", "#556332", "#6f7d49", "#889661" ]
                },
                {
                  'model' : '#54c300',
                  'list' : [ "#003f00", "#005700", "#007200", "#008c00",
                      "#18a110", "#54c300", "#003a00", "#1d5100", "#386a00",
                      "#52841b", "#6c9e36", "#87ba51", "#1f3605", "#354d1c",
                      "#4d6533", "#667f4b", "#7f9863", "#9ab47c" ]
                },
                {
                  'model' : '#00ab62',
                  'list' : [ "#002900", "#004117", "#00592c", "#007443",
                      "#00905b", "#00ab60", "#00270e", "#003c23", "#005338",
                      "#006d4f", "#266a6d", "#44a177", "#002215", "#0a3829",
                      "#234e3f", "#3b6756", "#54816f", "#6d9b83" ]
                },
                {
                  'model' : '#00c3c4',
                  'list' : [ "#002a2f", "#0c404c", "#00585c", "#007275",
                      "#008d8f", "#00a8a9", "#002526", "#003a3c", "#005252",
                      "#006b6b", "#258584", "#449f9e", "#002122", "#0a3736",
                      "#244d4d", "#3c6665", "#557f7e", "#6e9998" ]
                },
                {
                  'model' : '#009bf0',
                  'list' : [ "#002568", "#003981", "#00509b", "#105dbd",
                      "#4abdf0", "#15a4fa", "#002149", "#003661", "#004c7a",
                      "#095ba0", "#407eaf", "#45a5ce", "#001f36", "#12334d",
                      "#2b4964", "#53718b", "#5e7b98", "#1389b9" ]
                },
                {
                  'model' : '#006afe',
                  'list' : [ "#000079", "#001b95", "#002db0", "#0041cb",
                      "#0058e9", "#02b2f8", "#00004a", "#001963", "#002d7c",
                      "#234296", "#435ab2", "#596cc7", "#02162a", "#091a45",
                      "#022c55", "#3b4475", "#555b8f", "#686ea3" ]
                },
                {
                  'model' : '#3f00dd',
                  'list' : [ "#00006f", "#000084", "#1e0098", "#3b0dad",
                      "#5424c3", "#6c39d9", "#0f003e", "#180052", "#2f1763",
                      "#422776", "#56398a", "#6b4b9f", "#100025", "#1d1035",
                      "#2e1f47", "#3f2f59", "#52416c", "#655380" ]
                },
                {
                  'model' : '#9025ff',
                  'list' : [ "#2a0075", "#490090", "#6700ab", "#8500c7",
                      "#a400e4", "#bf00ff", "#260048", "#3d0060", "#57007a",
                      "#711993", "#8d37af", "#a74fc8", "#20002d", "#432847",
                      "#491d5b", "#412845", "#7c4c8e", "#9462a6" ]
                },
                {
                  'model' : '#ff3ec2',
                  'list' : [ "#7f0023", "#9e0038", "#bd004d", "#dd0065",
                      "#ff007f", "#ff3e98", "#5f0023", "#7c0039", "#98204f",
                      "#b53e67", "#d45b81", "#f1759a", "#4a0c24", "#64263a",
                      "#7e3d50", "#995668", "#b76a8b", "#d1899b" ]
                },
                {
                  'model' : '#fe0b6b',
                  'list' : [ "#6f0036", "#8d004d", "#ab0064", "#ca007e",
                      "#ea0098", "#ff21b3", "#55002d", "#700043", "#8c005a",
                      "#a92673", "#c6468d", "#e461a7", "#430027", "#5d0d3d",
                      "#762953", "#92426c", "#ae5c86", "#ca75a0" ]
                } ]
          }, options);
  if (this.p.render == null)
    return;
  this.initDefault();
  this.setPersonalData();
  this.p.onSuccess(this);
}
CtpSkinChange.prototype.initDefault = function(){
	var _skinSetHtmlString = "";
		_skinSetHtmlString+='<div class="skin_set_title"><span class="skin_set_text left">' + $.i18n('portal.skin.frontset') + '</span><span id="skin_set_close" class="skin_set_close"></span></div>';

    //tab
    _skinSetHtmlString+='<div class="skin_content_tabs">';
    _skinSetHtmlString+='<ul class="clearfix">';
    _skinSetHtmlString+='<li><a templateId="141322537970846464" class="current"><span class="layout_pat_2"></span>' + $.i18n('portal.skin.layout.left') + '</a></li><li><a templateId="8950558293947007546"><span class="layout_pat_1"></span>' + $.i18n('portal.skin.layout.up') + '</a></li>';
    _skinSetHtmlString+='</ul>';
    _skinSetHtmlString+='</div>';

    _skinSetHtmlString+='<div class="description clearFix" style="height:47px;font-size:14px;background:#ebebeb;color:#525252;line-height:47px;vertical-align: middle;padding:0px 30px;"><span class="left">' + $.i18n('portal.skin.recommendcolor') + '</span><a id="reDefaultBtn" class="common_button common_button_gray right hand" style="margin-top:12px;" >' + $.i18n('portal.skin.recover') + '</a></div>';
    
    
		_skinSetHtmlString+='<div class="skin_content">';

			_skinSetHtmlString+='<div class="recommend_skin">';
			_skinSetHtmlString+='<div class="content" style="margin-top:19px;">';
				_skinSetHtmlString+='<ul class="list clearFix" id="recommend_list" style="height:auto;">';
				
					
				_skinSetHtmlString+='</ul>';
			_skinSetHtmlString+='</div>';
		_skinSetHtmlString+='</div>';
		_skinSetHtmlString+='<div style="clear:both; border-bottom:1px #e5e5e5 solid;text-align:right;padding-bottom:5px;color:#414141;cursor:pointer;"><span id="more_edite">' + $.i18n('portal.skin.moremodify') + '...</span><span id="clappes_edite" class="hidden">' + $.i18n('portal.skin.collapsemodify') + '...</span></div>';
    

    //左右布局
    _skinSetHtmlString+='<table class="skin_template hidden" width="100%" height="200" border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">';
    _skinSetHtmlString+='<tr>';
    _skinSetHtmlString+='<td height="30" colspan="2" align="center" style="background:#86d6fa; color:#004669;"><span></span><span><span class="hand skin_head_img">' + $.i18n('portal.skin.head') + $.i18n('portal.skin.bgImg') + '</span><span style="margin-top:-2px;margin-left:3px;" class="ico16 close_16 skin_head_img_remove" templateId="141322537970846464"></span></span><!--' + $.i18n('portal.skin.and') + '-->&nbsp;<span class="hand skin_head_color">' + $.i18n('portal.skin.color') + $.i18n('portal.skin.modify') + '</span></td>';
    _skinSetHtmlString+='</tr>';
    _skinSetHtmlString+='<tr>';
    _skinSetHtmlString+='<td align="center" width="40" style="background:#00466A; color:#fff"><span>' + $.i18n('portal.skin.menu') + '</span><br><span style="color:#fff" class="hand skin_nav_color">' + $.i18n('portal.skin.color') + "<br/>" + $.i18n('portal.skin.modify') + '</span></td>'; 
    _skinSetHtmlString+='<td align="left" style="background:#1877AD;padding:5px 0 10px 10px; vertical-align:top;">';
    	_skinSetHtmlString+='<div class="font_12" style="background:url(/seeyon/main/skin/frame/harmony/menuIcon/personal_16.png) left center no-repeat; background-size:16px 16px; padding-left: 20px; color: #fff;  height: 28px;line-height: 28px;"><span style="color:#fff" class="hand bread_font_color">' + $.i18n('portal.skin.breadFontColor') + $.i18n('portal.skin.modify') + '</span></div>';
      _skinSetHtmlString+='<div style="float:left; width:115px; display:inline-block; margin:5px 0 0 0; text-align:center"><div style="width:115px; padding: 5px 0px; background-color:#fff; "><span class="hand skin_column_color" style="color:#0c76ae">' + $.i18n('portal.skin.sectionHeadingColor') + $.i18n('portal.skin.modify') + '</span></div>';
      _skinSetHtmlString+='<div style="width:115px; padding: 20px 0px; background-color:#B9D6E6;"><span class="hand color_blue skin_sectionContent_color" style="display: inline-block; color:#00466a">' + $.i18n('portal.skin.sectionContentColor') + $.i18n('portal.skin.modify') + '</span></div></div>';
    	_skinSetHtmlString+='<div style="float:left; width:110px; padding-left:5px; display:inline-block; margin:25px 0 0 0;"><div style="width:110px;"><span><span class="hand color_blue skin_mainBody_img" style="color:#fff">' + $.i18n('portal.skin.pageBgImg') + $.i18n('portal.skin.modify') + '</span><span style="margin-top:-2px;margin-left:3px;" class="ico16 close_16 skin_mainBody_img_remove" templateId="141322537970846464"></span></span></div>';
    	_skinSetHtmlString+='<div style="width:110px;" class="margin_t_10"><span class="hand color_blue skin_mainBody_color " style="color:#fff">' + $.i18n('portal.skin.bgColor') + $.i18n('portal.skin.modify') + '</span></div></div>';
    	
    	_skinSetHtmlString+='</td>';
    _skinSetHtmlString+='</tr>';
    _skinSetHtmlString+='</table>';

    //上下布局
    _skinSetHtmlString+='<table class="skin_template hidden" width="100%" height="200" border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">';
    _skinSetHtmlString+='<tr>';
    _skinSetHtmlString+='<td height="30" align="center" style="background:#86d6fa; color:#004767"><span></span><span><span class="hand skin_head_img">' + $.i18n('portal.skin.head') + $.i18n('portal.skin.bgImg') + '</span><span style="margin-top:-2px;margin-left:3px;" class="ico16 close_16 skin_head_img_remove" templateId="8950558293947007546"></span></span><span><!--' + $.i18n('portal.skin.and') + '-->&nbsp;</span><span class="hand skin_head_color">' + $.i18n('portal.skin.color') + $.i18n('portal.skin.modify') + '</span></td>';
    _skinSetHtmlString+='</tr>';
    _skinSetHtmlString+='<tr>';
    _skinSetHtmlString+='<td height="30" align="center" style="background:#00466A; color:#fff;"><span class="hand skin_nav_color">' +$.i18n('portal.skin.menu') + $.i18n('portal.skin.color') + $.i18n('portal.skin.modify') + '</span></td>';
    _skinSetHtmlString+='</tr>';
    _skinSetHtmlString+='<tr>';
    _skinSetHtmlString+='<td align="left" style="background:#1877AD;padding:5px 0 10px 10px; vertical-align:top;">';
    	_skinSetHtmlString+='<div class="font_12" style="background:url(/seeyon/main/skin/frame/harmony/menuIcon/personal_16.png) left center no-repeat; background-size:16px 16px; padding-left: 20px; color: #fff;  height: 28px;line-height: 28px;"><span class="hand bread_font_color ">' + $.i18n('portal.skin.breadFontColor') + $.i18n('portal.skin.modify') + '</span></div>';
      _skinSetHtmlString+='<div style="float:left; width:115px; text-align:center; display:inline-block; margin:5px 0 0 5px;"><div style="width:115px; padding: 5px 0px; background-color:#fff; "><span class="hand skin_column_color"  style="color:#0c76ae">' + $.i18n('portal.skin.sectionHeadingColor') + $.i18n('portal.skin.modify') + '</span></div>';
      _skinSetHtmlString+='<div style="width:115px; padding: 20px 0px; background-color:#B9D6E6;"><span class="hand color_blue skin_sectionContent_color" style="display: inline-block;color:#00466a">' + $.i18n('portal.skin.sectionContentColor') + $.i18n('portal.skin.modify') + '</span></div></div>';
    	_skinSetHtmlString+='<div style="float:left; width:110px; padding-left:5px; display:inline-block; margin:25px 0 0 5px;"><div style="width:110px;"><span style="color:#fff;"><span class="hand skin_mainBody_img">' + $.i18n('portal.skin.pageBgImg') + $.i18n('portal.skin.modify') + '</span><span style="margin-top:-2px;margin-left:3px;" class="ico16 close_16 skin_mainBody_img_remove" templateId="8950558293947007546"></span></span></div>';
    	_skinSetHtmlString+='<div style="width:110px;" class="margin_t_10"><span style="color:#fff;" class="hand  skin_mainBody_color">' + $.i18n('portal.skin.bgColor') + $.i18n('portal.skin.modify') + '</span></div></div> ';
    	
    _skinSetHtmlString+='</td>';
    _skinSetHtmlString+='</tr>';
    _skinSetHtmlString+='</table>';
    _skinSetHtmlString+='<div style="color:#7d7d7d;padding-top:10px;">' + $.i18n('portal.skin.allowuser.instruction') + '</div>';
    _skinSetHtmlString+='<input id="hiddenTopBgImg" type="hidden" />';
    _skinSetHtmlString+='<input id="hiddenMainBgImg" type="hidden" />';
			//颜色选择面板
			_skinSetHtmlString+='<div class="bg_color_skin">';
				_skinSetHtmlString+='<div class="content clearfix">';
					_skinSetHtmlString+='<ul id="bgColorContainer" class="list clearFix"></ul>';
					_skinSetHtmlString+='<ul id="modelListContainer" class="model_list clearFix"></ul>';
					_skinSetHtmlString+='<div id="skin_column_op_div" class="clearfix" style="height:30px;line-height:30px;"><a id="clearColor" class="common_button  common_button_gray margin_t_5">' + $.i18n('portal.skin.clear') + '</a> <span id="colorOpacitySpan" style="float:right; display:none">' + $.i18n('portal.skin.opacity') + ':<input id="skin_column_op_input" value="100" style="width:25px;" type="text" maxlength="3" /><span id="skin_column_op_span">%</span></span></div>';
				_skinSetHtmlString+='</div>';
			_skinSetHtmlString+='</div>';
			
		_skinSetHtmlString+='</div">';
		
		$('#'+this.p.render).append(_skinSetHtmlString);
		$(".skin_content_tabs li a").removeClass("current");
		$(".skin_content_tabs li a").removeClass("skinSwitchDisabled");
		$(".skin_content_tabs li a[templateId='" + this.p.templateId + "']").addClass("current");
		if(this.p.allowTemplateSwitch == "0"){
			$(".skin_content_tabs li a[templateId!='" + this.p.templateId + "']").addClass("skinSwitchDisabled");
		}
		if(this.p.topBgImg != ""){
			$(".skin_head_img_remove[templateId='" + this.p.templateId + "']").parents("span").css({"padding":"2px","background-color":"#fff"});
			$(".skin_head_img_remove[templateId='" + this.p.templateId + "']").show();
		} else {
			$(".skin_head_img_remove[templateId='" + this.p.templateId + "']").parents("span").removeAttr("style");
			$(".skin_head_img_remove[templateId='" + this.p.templateId + "']").hide();
		}
		if(this.p.mainBgImg != ""){
			$(".skin_mainBody_img_remove[templateId='" + this.p.templateId + "']").parents("span").css("background-color", "#fff");
			$(".skin_mainBody_img").css("color", "#004669");
			$(".skin_mainBody_img_remove[templateId='" + this.p.templateId + "']").show();
		} else {
			$(".skin_mainBody_img_remove[templateId='" + this.p.templateId + "']").parents("span").removeAttr("style");
			$(".skin_mainBody_img").css("color", "#ffffff");
			$(".skin_mainBody_img_remove[templateId='" + this.p.templateId + "']").hide();
		}
		
		$('#more_edite').click(function(){
			$(this).hide();
			$('#clappes_edite').show();
      changeTemplateSkinMore();



   //    $('.mainBody_skin').show();
			// $('.header_skin').show();
			// $('.modify_skin').show();
			$('#skin_set_iframe').height($('#skin_set').height());
		});
		$('#clappes_edite').click(function(){
			$(this).hide();
			$('#more_edite').show();
      // changeTemplateSkinMore();
      $(".skin_template").hide();

   //    $('.mainBody_skin').hide();
			// $('.header_skin').hide();
			// $('.modify_skin').hide();
			$('#skin_set_iframe').height($('#skin_set').height());
		});
		//tab 切换换肤模版数据
    $(".skin_content_tabs li a").click(function(){
      //$(".skin_content_tabs li a").removeClass("current");
      //$(this).addClass("current");
      //changeTemplateSkinMore();
    })
    //根据模版不同，展示不同换肤更多
    function changeTemplateSkinMore() {
      var tabCurrentIndex = $(".skin_content_tabs a.current").parents("li").index();
      $(".skin_template").hide();
      $(".skin_template").eq(tabCurrentIndex).show();

      $('#clappes_edite').show();
      $('#more_edite').hide();
      return tabCurrentIndex;
    }
		
		var _self = this;
		var _nameArray = [];
		var _idArray = [];
		for(var i =0;i<this.p.data.length;i++){
			var _temp = this.p.data[i];
			var _id	 = _temp.id;
			if(this.p.skinId == _id){
				this._recommend = i;
			}
			_nameArray[i] = _temp.name;
			_idArray[i] = _temp._id;
			var _image = _temp.image;
			var _color = _temp.color;
			var _navBg = _temp.navBg;
			var _column = _temp.column;//last
			var _banner = _temp.banner;
			var _last = '';
			if(i == this.p.data.length-1 || i == 2){
				_last = 'last';
			}
			$('#recommend_list').append('<li id="'+_id+'" class="item '+_last+'  hoverFlag" style="background:url(' + _ctxPath +'/main/skin/frame/' + this.p.skinId + '/images/'+_image+');'+(this.p.data.length==2?'margin-right:50px;':'')+'"></li>');
    	(function(obj) {
        $('#' + obj.id).unbind('click').click(
          function() {
            if (!_self.p.changeSkin) return;
            //风格选择
            if (obj.id != _self.p.skinId) {
              $('#' + _self.p.skinId).removeAttr('currentRecommond');
              $('#' + _self.p.skinId).find(".opacity_border").remove();
              _self.opBorder($(this));
            } else {
              return;
            }
            $(this).attr('currentRecommond', 'true');
            _self.p.skinId = obj.id;
            _self.p.templateId = obj.templateId;
            _self.p.topBgImg = obj.banner;
            //_self.p.logoImg = obj.logo;
            _self.p.lBgColor = obj.navBg;
            _self.p.cBgColor = obj.column;
            _self.p.topBgColor = obj.color;
            _self.p.mainBgColor = obj.mainBgColor;
            _self.p.mainBgImg = obj.mainBgImg;
            _self.p.breadFontColor = obj.breadFontColor;
            _self.p.sectionContentColor = obj.sectionContentColor;
            if(_self.p.onChooseSkinStyle!=null)_self.p.onChooseSkinStyle();
          });
      })(_temp);
		}
		var _nameStr1="";
		var _nameStr2 = "";	
		for(var j =0;j<_nameArray.length;j++){
			var _last = '';
			if(j == _nameArray.length-1 || j==2){
				_last = 'last';
			}
			if(j<3){
				_nameStr1+='<li class="item name '+_last+'" style="'+(this.p.data.length==2?'margin-right:50px;':'')+'">'+_nameArray[j]+'</li>';
			}else{
				_nameStr2+='<li class="item name '+_last+'" style="'+(this.p.data.length==2?'margin-right:50px;':'')+'">'+_nameArray[j]+'</li>';
			}
		}
		$('#recommend_list .item').eq(2).after(_nameStr1);
		$('#recommend_list').append(_nameStr2);

		//hover 添加边框
		$('.hoverFlag').mouseenter(function(){
			if($(this).attr('currentRecommond') == 'true')return;
			//_self.opBorder($(this));
		}).mouseleave(function(){
			if($(this).attr('currentRecommond') == 'true')return;
			$(this).find(".opacity_border").remove();
		});
		
		//关闭方法
		$('#skin_set_close').click(function(){
      //获取当前设置的背景图
      var backgroundImageUrl = $('#bgimg').css('background-image');
      if(backgroundImageUrl){
        backgroundImageUrl = backgroundImageUrl.substring(backgroundImageUrl.lastIndexOf(_ctxPath)+_ctxPath.length,backgroundImageUrl.length);
        _self.p.topBgImg = backgroundImageUrl;
      }
			skinSaveData = _self.p;
		}).click(this.p.onClose);
		
		if(this.p.render!=null){
			//透明度
			$("#skin_column_op_input").unbind("blur").blur(function(){
				var colorOpacity = $("#skin_column_op_input").val();
				var oldColorOpacity = $('#skin_column_op_input').attr("oldColorOpacity");
				if(/^(100|\d\d|\d)$/.test(colorOpacity) == false){
					$('#skin_column_op_input').val(oldColorOpacity);
					return;
				}
				$("#skin_column_op_input").attr("oldColorOpacity", colorOpacity);
				var _tar = $('.bg_color_skin').attr('target');
				if(_tar == ".skin_nav_color"){
					portalskinChange.p.lBgColor.colorOpacity = colorOpacity;
				} else if(_tar == ".skin_head_color"){
					portalskinChange.p.topBgColor.colorOpacity = colorOpacity;
				} else if(_tar == ".skin_column_color"){
					portalskinChange.p.cBgColor.colorOpacity = colorOpacity;
				} else if(_tar == ".skin_sectionContent_color"){
					portalskinChange.p.sectionContentColor.colorOpacity = colorOpacity;
				} else if(_tar == ".skin_mainBody_color"){
					portalskinChange.p.mainBgColor.colorOpacity = colorOpacity;
				}
				updateSkinSwitchDatas(portalskinChange.p);
				if(portalskinChange.p.onChange!=null) portalskinChange.p.onChange();
			});
			$('#'+this.p.render).unbind("click").click(function(e){
				var _objOnClick = $(e.target);
				var _id = e.target.id;
				var _cn = e.target.className;
				if(_objOnClick.hasClass("bread_font_color")){
					//面包屑导航字体颜色
		        	if(!_self.p.changeBg)return;
		        	$("#colorOpacitySpan").hide();
		            var _colorListIndex = parseInt(_self.p.breadFontColor.colorList);
		            var _colorIndex = parseInt(_self.p.breadFontColor.colorIndex);
		            _self.createColorPanel(_colorListIndex, _colorIndex);
		            $('.bg_color_skin').attr('target','.bread_font_color');
		            $('.bg_color_skin').hide('fast');
		            $('.bg_color_skin').css({
		              'top':100,
		              'left':0
		            }).show('fast',function(){
		              $('.ok').remove();
		              $('.colorItem').eq(_colorIndex).append("<div class='ok'></div>");
		            });
					$("#skin_column_op_input").val("100");
					$("#skin_column_op_input").attr("oldColorOpacity", "100");
					if($.browser.msie && ($.browser.version == '8.0' || $.browser.version == '7.0' || $.browser.version == '6.0')){
						$("#colorOpacitySpan").hide();
					} else {
						$("#colorOpacitySpan").show();
						$("#skin_column_op_input").attr("disabled", true);
					}
		            e.stopPropagation();
				}else if(_objOnClick.hasClass("skin_head_img_remove")){
					//删除头部背景图
					if(!_self.p.changeBg)return;
					_objOnClick.parents("span").removeAttr("style");
					getCtpTop().$(".area").css("background-image", "none");
					portalskinChange.p.topBgImg = "";
					updateSkinSwitchDatas(portalskinChange.p);
					if(portalskinChange.p.onChange!=null) portalskinChange.p.onChange();
					_objOnClick.hide();
                } else if(_objOnClick.hasClass("skin_mainBody_img_remove")){
                	//删除大背景图
                	if(!_self.p.changeBg)return;
                	_objOnClick.parents("span").removeAttr("style");
                	$(".skin_mainBody_img").css("color", "#ffffff");
                	getCtpTop().$(".warp").css("background-image", "none");
                	portalskinChange.p.mainBgImg = "";
                	updateSkinSwitchDatas(portalskinChange.p);
                	if(portalskinChange.p.onChange!=null) portalskinChange.p.onChange();
                	_objOnClick.hide();
                }else if(_objOnClick.hasClass("skin_mainBody_color")) {
		          //大背景－颜色
		          if(!_self.p.changeBg)return;
		          $("#colorOpacitySpan").hide();
		          var _colorListIndex = parseInt(_self.p.mainBgColor.colorList);
		          var _colorIndex = parseInt(_self.p.mainBgColor.colorIndex);
		          _self.createColorPanel(_colorListIndex, _colorIndex);
		          $('.bg_color_skin').attr('target','.skin_mainBody_color');
		          $('.bg_color_skin').hide('fast');
		          $('.bg_color_skin').css({
		            'top':10,
		            'left':14
		          }).show('fast',function(){
		            $('.ok').remove();
		            $('.colorItem').eq(_colorIndex).append("<div class='ok'></div>");
		          });
		          $("#skin_column_op_input").val(_self.p.mainBgColor.colorOpacity);
		          $("#skin_column_op_input").attr("oldColorOpacity", _self.p.mainBgColor.colorOpacity);
		          if($.browser.msie && ($.browser.version == '8.0' || $.browser.version == '7.0' || $.browser.version == '6.0')){
		        	  $("#colorOpacitySpan").hide();
		          } else {
		        	  $("#colorOpacitySpan").show();
		        	  $("#skin_column_op_input").attr("disabled", false);
		          }
		          e.stopPropagation();
                } else if (_objOnClick.hasClass("skin_mainBody_img")) {
                	//大背景－图片
                	if(!_self.p.changeBg)return;
                	$('.bg_color_skin').hide();
                	//alert("首页大背景图上传")

                } else if(_objOnClick.hasClass("skin_head_color")){
        			//头部背景－颜色
					if(!_self.p.changeBg)return;
					$("#colorOpacitySpan").hide();
					var _colorListIndex = parseInt(_self.p.topBgColor.colorList);
					var _colorIndex = parseInt(_self.p.topBgColor.colorIndex);
					_self.createColorPanel(_colorListIndex, _colorIndex);
					$('.bg_color_skin').attr('target','.skin_head_color');
					$('.bg_color_skin').hide('fast');
					$('.bg_color_skin').css({
						'top':10,
						'left':14
					}).show('fast',function(){
					  $('.ok').remove();
					  if (_self.p.topBgColor.color != "transparent") {
						$('.colorItem').eq(_colorIndex).append("<div class='ok'></div>");
					  }
					});
					$("#skin_column_op_input").val(_self.p.topBgColor.colorOpacity);
					$("#skin_column_op_input").attr("oldColorOpacity", _self.p.topBgColor.colorOpacity);
					if($.browser.msie && ($.browser.version == '8.0' || $.browser.version == '7.0' || $.browser.version == '6.0')){
						$("#colorOpacitySpan").hide();
					} else {
						$("#colorOpacitySpan").show();
						$("#skin_column_op_input").attr("disabled", false);
					}
					e.stopPropagation();
				}else if(_objOnClick.hasClass("skin_nav_color")){
					//导航菜单背景－颜色
					if(!_self.p.changeBg)return;
					var _colorListIndex = parseInt(_self.p.lBgColor.colorList);
					var _colorIndex = parseInt(_self.p.lBgColor.colorIndex);
					_self.createColorPanel(_colorListIndex, _colorIndex);
					$('.bg_color_skin').attr('target','.skin_nav_color');
					$('.bg_color_skin').hide('fast');
					$('.bg_color_skin').css({
						'top':98,
						'left':14
					}).show('fast',function(){
					  $('.ok').remove();
					  $('.colorItem').eq(_colorIndex).append("<div class='ok'></div>");
					});
					$("#skin_column_op_input").val(_self.p.lBgColor.colorOpacity);
					$("#skin_column_op_input").attr("oldColorOpacity", _self.p.lBgColor.colorOpacity);
					if($.browser.msie && ($.browser.version == '8.0' || $.browser.version == '7.0' || $.browser.version == '6.0')){
						$("#colorOpacitySpan").hide();
					} else {
						$("#colorOpacitySpan").show();
						$("#skin_column_op_input").attr("disabled", false);
					}
					e.stopPropagation();
				}else if(_objOnClick.hasClass("skin_column_color")){
					//栏目页签背景－颜色
					if(!_self.p.changeBg)return;
					var _colorListIndex = parseInt(_self.p.cBgColor.colorList);
					var _colorIndex = parseInt(_self.p.cBgColor.colorIndex);
					_self.createColorPanel(_colorListIndex, _colorIndex);
					$('.bg_color_skin').attr('target','.skin_column_color');
					$('.bg_color_skin').hide('fast');
					$('.bg_color_skin').css({
						'top':98,
						'left':14
					}).show('fast',function(){
					  $('.ok').remove();
					  $('.colorItem').eq(_colorIndex).append("<div class='ok'></div>");
					});
					$("#skin_column_op_input").val(_self.p.cBgColor.colorOpacity);
					$("#skin_column_op_input").attr("oldColorOpacity", _self.p.cBgColor.colorOpacity);
					if($.browser.msie && ($.browser.version == '8.0' || $.browser.version == '7.0' || $.browser.version == '6.0')){
						$("#colorOpacitySpan").hide();
					} else {
						$("#colorOpacitySpan").show();
						$("#skin_column_op_input").attr("disabled", false);
					}
					e.stopPropagation();
				}else if(_objOnClick.hasClass("skin_sectionContent_color")){
					//栏目内容区颜色、透明度
					if(!_self.p.changeBg)return;
					var _colorListIndex = parseInt(_self.p.sectionContentColor.colorList);
					var _colorIndex = parseInt(_self.p.sectionContentColor.colorIndex);
					_self.createColorPanel(_colorListIndex, _colorIndex);
					$('.bg_color_skin').attr('target','.skin_sectionContent_color');
					$('.bg_color_skin').hide('fast');
					$('.bg_color_skin').css({
						'top':98,
						'left':14
					}).show('fast',function(){
					  $('.ok').remove();
					  $('.colorItem').eq(_colorIndex).append("<div class='ok'></div>");
					});
					$("#skin_column_op_input").val(_self.p.sectionContentColor.colorOpacity);
					$("#skin_column_op_input").attr("oldColorOpacity", _self.p.sectionContentColor.colorOpacity);
					if($.browser.msie && ($.browser.version == '8.0' || $.browser.version == '7.0' || $.browser.version == '6.0')){
						$("#colorOpacitySpan").hide();
					} else {
						$("#colorOpacitySpan").show();
						$("#skin_column_op_input").attr("disabled", false);
					}
					e.stopPropagation();
				}else if(_cn=='modelItem' || _cn=='modelItem currentMap' || _cn=='colorItem'){
					$('.bg_color_skin').show('fast');
					e.stopPropagation();
				}else if(_id == 'bgimg'){
					if(!_self.p.changeBg)return;
					$('.bg_color_skin').hide();
				}else if(_id == 'clearColor' || _id == 'skin_column_op_input' || _id == "skin_column_op_div"){
					e.stopPropagation();
				}else{
					$('.bg_color_skin').hide();
				}
			});
		}
		
};
CtpSkinChange.prototype.setPersonalData = function(){
	this.opBorder($('#'+this.p.skinId));
	$('#'+this.p.skinId).attr('currentRecommond',true);
	$('#bgimg').css('background-image','url(' + _ctxPath + '/' + this.p.topBgImg +')');//banner默认图片
	$('#bgcolor').css('background',this.p.topBgColor.color);
	$('#l_bg').css('background',this.p.lBgColor.color);
	$('#c_bg').css('background',this.p.cBgColor.color);
};
/**
 * 恢复默认方法
 * @param op 与skinSaveData 对象等同，参考 p的options
 */
CtpSkinChange.prototype.resetData = function(op){
	this.p = $.extend({
        id: Math.floor(Math.random() * 100000000),
        render:null,//渲染目标
        skinId:'harmony',//当前选中的模式
        topBgImg:'header1.png',//自定义banner图片
        topBgColor:{color:'#45a5ce',colorList:'2',colorIndex:'10'},//banner区域背景颜色 + 颜色选择器色系索引 + 颜色选择器色系颜色索引
		lBgColor:{color:'#022c55',colorList:'2',colorIndex:'10'},//左侧区域背景颜色 + 颜色选择器色系索引 + 颜色选择器色系颜色索引
		cBgColor:{color:'#15a4fa',colorList:'7',colorIndex:'15'},//栏目区域背景颜色 + 颜色选择器色系索引 + 颜色选择器色系颜色索引
        changeSkin:true,
        changeBg:true,
        onClose:function(){},//关闭事件
        onChange:null,
        onChooseSkinStyle:null,
        onSuccess:function(){},//加载完执行事件
        data:[{
				id:'harmony',
				name:'和谐之美',
				image:'recommend1.png',
				color:{color:'#f6ec79',colorList:'2',colorIndex:'10'},
				navBg:{color:'#009dd9',colorList:'2',colorIndex:'10'},
				column:{color:'#bae6e7',colorList:'7',colorIndex:'15'},
				banner:'header1.png'
			},{
				id:'peaceful',
				name:'宁静之韵',
				image:'recommend2.png',
				color:{color:'#f6ec79',colorList:'2',colorIndex:'10'},
				navBg:{color:'#009dd9',colorList:'2',colorIndex:'10'},
				column:{color:'#bae6e7',colorList:'7',colorIndex:'15'},
				banner:'header2.png'
			},{
				id:'wisdom',
				name:'智慧之美',
				image:'recommend3.png',
				color:{color:'#f6ec79',colorList:'2',colorIndex:'10'},
				navBg:{color:'#009dd9',colorList:'2',colorIndex:'10'},
				column:{color:'#bae6e7',colorList:'7',colorIndex:'15'},
				banner:'header3.png'
			}],
			colorList:[{
				'model':'#303030',
				'list':["#071111","#1f2627","#353c3d","#4b5354","#636b6c","#7c8485","#0a1011","#1e2223","#323637","#454b4c","#5c6162","#727878","#000000","#1d1d1d","#252525","#3c3c3c","#525252","#6b6b6b"]
			},{
				'model':'#777777',
				'list':["#1b1918","#363432","#474342","#575451","#696663","#7b7875","#0e0e0c","#1e1e1d","#312f2e","#434241","#565554","#6b6b6b","#000000","#1d1d1d","#252525","#3c3c3c","#525252","#6a6968"]
			},{
				'model':'#da0025',
				'list':["#6e0012","#8d0017","#ad001d","#cf0023","#f10025","#ff2c37","#54001d","#710025","#8e0032","#ad2a3f","#cd484a","#eb6360","#43001c","#5e1129","#792a38","#964449","#b45d59","#d17670"]
			},{
				'model':'#f01800',
				'list':["#4f0006","#6d0004","#8c0001","#ac0000","#cd0000","#ef0000","#380003","#510000","#6e0000","#8b1202","#a9331a","#c84e31","#290002","#3f0200","#591b0b","#733220","#8f4a37","#ac634e"]
			},{
				'model':'#ff4300',
				'list':["#660003","#850000","#a40000","#c50000","#e61f00","#ff4608","#500000","#6c0000","#891700","#a73511","#c65129","#e56b41","#3c0600","#561e0a","#703420","#8c4c36","#a8654d","#c57f65"]
			},{
				'model':'#fd6c05',
				'list':["#740000","#920000","#b22600","#d34500","#f26000","#ff7c1c","#5f1300","#7b2c00","#984512","#b65e2b","#d37742","#f2925c","#4f2307","#69391e","#845134","#a06a4c","#bc8363","#d99e7d"]
			},{
				'model':'#feab07',
				'list':["#713400","#8f4c00","#ad6500","#cb7e00","#eb9900","#ffb317","#4d2600","#683b00","#835300","#a06c13","#bc852f","#da9f49","#472900","#5f3f0b","#7a5723","#96703b","#b18952","#cea36c"]
			},{
				'model':'#ffc91e',
				'list':["#653d00","#825400","#a06d00","#bd8600","#dca000","#ffbf00","#452a00","#5f4000","#7a5800","#977008","#b38928","#d0a444","#412c00","#5a4206","#745a20","#8f7338","#aa8c50","#c7a669"]
			},{
				'model':'#93c900',
				'list':["#002800","#003c00","#005500","#1f6e00","#418700","#5ea200","#002300","#173800","#304f00","#496700","#638118","#7d9b34","#122000","#273503","#3d4b1b","#556332","#6f7d49","#889661"]
			},{
				'model':'#54c300',
				'list':["#003f00","#005700","#007200","#008c00","#30a700","#54c300","#003a00","#1d5100","#386a00","#52841b","#6c9e36","#87ba51","#1f3605","#354d1c","#4d6533","#667f4b","#7f9863","#9ab47c"]
			},{
				'model':'#00ab62',
				'list':["#002900","#004117","#00592c","#007443","#00905b","#00ab60","#00270e","#003c23","#005338","#006d4f","#248768","#44a177","#002215","#0a3829","#234e3f","#3b6756","#54816f","#6d9b83"]
			},{
				'model':'#00c3c4',
				'list':["#002a2f","#003f45","#00585c","#007275","#008d8f","#00a8a9","#002526","#003a3c","#005252","#006b6b","#258584","#449f9e","#002122","#0a3736","#244d4d","#3c6665","#557f7e","#6e9998"]
			},{
				'model':'#009bf0',
				'list':["#002568","#003981","#00509b","#105dbd","#0082d4","#009bf0","#002149","#003661","#004c7a","#1e6494","#407eaf","#5c97ca","#001f36","#12334d","#2b4964","#53718b","#5e7b98","#1389b9"]
			},{
				'model':'#006afe',
				'list':["#000079","#001b95","#002db0","#0041cb","#0058e9","#006aff","#00004a","#001963","#002d7c","#234296","#435ab2","#596cc7","#00002e","#091a45","#232e5c","#3b4475","#555b8f","#686ea3"]
			},{
				'model':'#3f00dd',
				'list':["#00006f","#000084","#1e0098","#3b0dad","#5424c3","#6c39d9","#0f003e","#180052","#2f1763","#422776","#56398a","#6b4b9f","#100025","#1d1035","#2e1f47","#3f2f59","#52416c","#655380"]
			},{
				'model':'#9025ff',
				'list':["#2a0075","#490090","#6700ab","#8500c7","#a400e4","#bf00ff","#260048","#3d0060","#57007a","#711993","#8d37af","#a74fc8","#20002d","#320543","#491d5b","#623373","#7c4c8e","#9462a6"]
			},{
				'model':'#ff3ec2',
				'list':["#7f0023","#9e0038","#bd004d","#dd0065","#ff007f","#ff3e98","#5f0023","#7c0039","#98204f","#b53e67","#d45b81","#f1759a","#4a0c24","#64263a","#7e3d50","#995668","#b77083","#d1899b"]
			},{
				'model':'#fe0b6b',
				'list':["#6f0036","#8d004d","#ab0064","#ca007e","#ea0098","#ff21b3","#55002d","#700043","#8c005a","#a92673","#c6468d","#e461a7","#430027","#5d0d3d","#762953","#92426c","#ae5c86","#ca75a0"]
			}]
    }, op);
	this.setPersonalData();
	this.p.onSuccess(this);
};
CtpSkinChange.prototype.opBorder = function(obj){
	//var _w = obj.width();
	//if(_w < 77){_w = 77}
	_w = 77;
	//var _h = obj.height();
	//if(_h<18){_h = 18}
	_h = 40;
	$("<div class='opacity_border'></div>").css({
		'width':_w,
		'height':3,
		'top':0,
		'left':0
	}).appendTo(obj);
	$("<div class='opacity_border'></div>").css({
		'width':_w,
		'height':3,
		'bottom':0,
		'left':0
	}).appendTo(obj);
	$("<div class='opacity_border'></div>").css({
		'height':_h-6,
		'width':3,
		'top':3,
		'left':0
	}).appendTo(obj);
	$("<div class='opacity_border'></div>").css({
		'height':_h-6,
		'width':3,
		'top':3,
		'right':0
	}).appendTo(obj);
};
//颜色面板－声明大类
CtpSkinChange.prototype.createColorPanel = function(_currentList){
	$('#modelListContainer').html('');
	var _self = this;
	//var _currentList = 0;
	//var _currentColor = 0;
	var _currentMap;
	var _modelListContainerString = "";
	var _modelListContainer = $('#modelListContainer');
	$(this.p.colorList).each(function(index){
		var _temp = _self.p.colorList[index];
		var _tempModel = _temp.model;
		_modelListContainerString+="<li index='"+index+"' style='border:1px solid "+(_currentList==index?'#fff;border-top:0px;':_tempModel)+";background:"+_tempModel+"' class='modelItem "+(_currentList==index?'currentMap':'')+"'></li>";
		if(index == _currentList){
			_currentMap = _temp;
		}
	});
	_modelListContainer.append(_modelListContainerString);
	this.createBgColorSkin(_currentMap);
	$('.modelItem').mouseenter(function(){
		if($(this).hasClass('currentMap'))return;
		$(this).css('border-color',"#ffffff");
		//$(this).css('border-top',"0px");
	}).mouseleave(function(){
		if($(this).hasClass('currentMap'))return;
		var _bgc = $(this).css('background-color');
		$(this).css('border-color',_bgc);
	}).click(function(){
		var _index= parseInt($(this).attr('index'));
		_currentMap = _self.p.colorList[_index];
		_self.createBgColorSkin(_currentMap);
		var _ss = this;
		$('.modelItem').each(function(){
			if(this!=_ss){
				var _bgc = $(this).css('background-color');
				$(this).css('border-color',_bgc);
			}
		});
		$('.modelItem').removeClass("currentMap");
		$(this).addClass("currentMap");
	});
	
};
//颜色面板－声明大类下，颜色
CtpSkinChange.prototype.createBgColorSkin = function(_currentMap){
	var _self = this;
	var _bgColorContainer = $('#bgColorContainer');
	var _bgColorContainerString = "";
	_bgColorContainer.empty();
	var _tempList = _currentMap.list;
	$(_tempList).each(function(i){
		_bgColorContainerString+="<li index='"+i+"' style='background:"+_tempList[i]+"' class='colorItem'></li>";
	});
	_bgColorContainer.append(_bgColorContainerString);
	$('.colorItem,#clearColor').unbind("click").click(function(){
		$('.ok').remove();
		$(this).append("<div class='ok'></div>");
		var _tar = $('.bg_color_skin').attr('target');
		var _bgc = $(this).css('background-color');
		
		if($(this).attr("id") == "clearColor"){
			_bgc = "transparent";
		}
		//$(_tar).css('background-color',_bgc);
		switch(_tar){
		  case '.skin_mainBody_color':
			//工作区背景色
			getCtpTop().setMainBgColor(_bgc, _self.p.mainBgColor.colorOpacity);
            _self.p.mainBgColor.color = _bgc;
            _self.p.mainBgColor.colorIndex = $(this).attr('index');
            _self.p.mainBgColor.colorList = $('.currentMap').attr('index');
            updateSkinSwitchDatas(_self.p);
            if(_self.p.onChange!=null)_self.p.onChange();
            break;
		  case '.bread_font_color':
			  //面包屑导航字体颜色
			  getCtpTop().$('.nowLocation_content, .nowLocation_content a').css('color',_bgc);
			  _self.p.breadFontColor.color = _bgc;
			  _self.p.breadFontColor.colorIndex = $(this).attr('index');
			  _self.p.breadFontColor.colorList = $('.currentMap').attr('index');
			  updateSkinSwitchDatas(_self.p);
			  if(_self.p.onChange!=null)_self.p.onChange();
			  break;
		  case '.skin_nav_color':
		    //导航菜单－背景色
			getCtpTop().setNavMenuColor(_bgc, _self.p.lBgColor.colorOpacity);
		    _self.p.lBgColor.color = _bgc;
		    _self.p.lBgColor.colorIndex = $(this).attr('index');
		    _self.p.lBgColor.colorList = $('.currentMap').attr('index');
		    updateSkinSwitchDatas(_self.p);
		    if(_self.p.onChange!=null)_self.p.onChange();
		    break;
		  case '.skin_column_color':
		    //栏目头部－颜色
		    getCtpTop().resetSectionTabColor(_bgc, _self.p.cBgColor.colorOpacity / 100);
		    _self.p.cBgColor.color = _bgc;
		    _self.p.cBgColor.colorIndex = $(this).attr('index');
		    _self.p.cBgColor.colorList = $('.currentMap').attr('index');
		    updateSkinSwitchDatas(_self.p);
		    if(_self.p.onChange!=null)_self.p.onChange();
		    break;
		  case '.skin_sectionContent_color':
			  //栏目内容区颜色
			  getCtpTop().setContentAreabgc(_bgc, _self.p.sectionContentColor.colorOpacity);
			  _self.p.sectionContentColor.color = _bgc;
			  _self.p.sectionContentColor.colorIndex = $(this).attr('index');
			  _self.p.sectionContentColor.colorList = $('.currentMap').attr('index');
			  updateSkinSwitchDatas(_self.p);
			  if(_self.p.onChange!=null)_self.p.onChange();
			  break;
		  case '.skin_head_color':
		    //头部背景－颜色
			getCtpTop().setTopBgColor(_bgc, _self.p.topBgColor.colorOpacity);
			getCtpTop().$(".layout_header").find(".area").css("background-image","none");
		    _self.p.topBgColor.color = _bgc;
		    _self.p.topBgColor.colorIndex = $(this).attr('index');
		    _self.p.topBgColor.colorList = $('.currentMap').attr('index');
		    updateSkinSwitchDatas(_self.p);
		    if(_self.p.onChange!=null)//_self.p.onChange();
		    break;
		  default:
		}
	});
};
function converColorToNum(_color){
	if($.browser.msie && ($.browser.version == '6.0' || $.browser.version == '7.0' || $.browser.version == '8.0')){
		return _color;
	}
	if(_color.indexOf("#") == 0){
		_color = _color.replace(/#/g,"");
		if(_color.length != 6){
			return;
		}
		var r = _color.substr(0,2).toNum();
	    var g = _color.substr(2,2).toNum();
	    var b = _color.substr(4,2).toNum();
	    _color = "rgb("+ r +","+ g +","+ b +")";
	}
	_color = _color.replace("rgb","rgba").replace(")",",0.8)");
	return _color;
}
String.prototype.toHex = function() {
    var number = this;
    var sw = Math.floor(number/16);
    var gw = number - sw * 16;
    function numtochar(n) {
        var n = n;
        switch(n*1){
            case 10: return "a";  break;
            case 11: return "b";  break;
            case 12: return "c";  break;
            case 13: return "d";  break;
            case 14: return "e";  break;
            case 15: return "f";  break;
        }
        return n;
    }
    return numtochar(sw).toString() + numtochar(gw).toString();
};
String.prototype.toNum = function() {
    var hex = {
        a:10,
        b:11,
        c:12,
        d:13,
        e:14,
        f:15
    };
    var str = this.toLowerCase();
    var sw = hex[str.substr(0,1)];
    if (sw == undefined) {
        sw = str.substr(0,1) * 16;
    } else {
        sw = hex[str.substr(0,1)] * 16;
    };
    var gw = hex[str.substr(1,1)];
    if (gw == undefined) {
        gw = str.substr(1,1) * 1;
    } else {
        gw = hex[str.substr(1,1)] * 1;
    };
    return sw + gw;
};
function updateSkinSwitchDatas(p){
  if(p.data.length > 0){
    for(var i = 0; i < p.data.length; i++){
      if(p.skinId == p.data[i].id){
        p.data[i].color.color = p.topBgColor.color;
        p.data[i].color.colorIndex = p.topBgColor.colorIndex;
        p.data[i].color.colorOpacity = p.topBgColor.colorOpacity;
        p.data[i].color.colorList = p.topBgColor.colorList;
        p.data[i].navBg.color = p.lBgColor.color;
        p.data[i].navBg.colorIndex = p.lBgColor.colorIndex;
        p.data[i].navBg.colorOpacity = p.lBgColor.colorOpacity;
        p.data[i].navBg.colorList = p.lBgColor.colorList;
        p.data[i].column.color = p.cBgColor.color;
        p.data[i].column.colorIndex = p.cBgColor.colorIndex;
        p.data[i].column.colorOpacity = p.cBgColor.colorOpacity;
        p.data[i].column.colorList = p.cBgColor.colorList;
        p.data[i].banner = p.topBgImg;
        p.data[i].mainBgColor.color = p.mainBgColor.color;
        p.data[i].mainBgColor.colorIndex = p.mainBgColor.colorIndex;
        p.data[i].mainBgColor.colorOpacity = p.mainBgColor.colorOpacity;
        p.data[i].mainBgColor.colorList = p.mainBgColor.colorList;
        p.data[i].mainBgImg = p.mainBgImg;
        p.data[i].breadFontColor.color = p.breadFontColor.color;
        p.data[i].breadFontColor.colorIndex = p.breadFontColor.colorIndex;
        p.data[i].breadFontColor.colorOpacity = p.breadFontColor.colorOpacity;
        p.data[i].breadFontColor.colorList = p.breadFontColor.colorList;
        p.data[i].sectionContentColor.color = p.sectionContentColor.color;
        p.data[i].sectionContentColor.colorIndex = p.sectionContentColor.colorIndex;
        p.data[i].sectionContentColor.colorOpacity = p.sectionContentColor.colorOpacity;
        p.data[i].sectionContentColor.colorList = p.sectionContentColor.colorList;
        return;
      }
    }
  }
}

//首页头部背景图上传回调动作
function topBgImgUploadCallBack(attachment){
  getCtpTop().$(".area").css("background-image", "url(\'" + _ctxPath + "/fileUpload.do?method=showRTE&fileId=" + attachment.instance[0].fileUrl + "&type=image" + "\')");
  portalskinChange.p.topBgImg = "fileUpload.do?method=showRTE&fileId=" + attachment.instance[0].fileUrl + "&type=image";
  updateSkinSwitchDatas(portalskinChange.p);
  if(portalskinChange.p.onChange!=null) portalskinChange.p.onChange();
  $(".skin_head_img_remove[templateId='" + portalskinChange.p.templateId + "']").parents("span").css({"padding":"2px","background-color":"#fff"});
  $(".skin_head_img_remove[templateId='" + portalskinChange.p.templateId + "']").show();
}

//大背景图上传回调动作
function mainBgImgUploadCallBack(attachment){
  getCtpTop().$(".warp").css("background-image", "url(\'" + _ctxPath + "/fileUpload.do?method=showRTE&fileId=" + attachment.instance[0].fileUrl + "&type=image" + "\')");
  portalskinChange.p.mainBgImg = "fileUpload.do?method=showRTE&fileId=" + attachment.instance[0].fileUrl + "&type=image";
  updateSkinSwitchDatas(portalskinChange.p);
  if(portalskinChange.p.onChange!=null) portalskinChange.p.onChange();
  $(".skin_mainBody_img_remove[templateId='" + portalskinChange.p.templateId + "']").parents("span").css("background-color", "#fff");
  $(".skin_mainBody_img").css("color", "#004669");
  $(".skin_mainBody_img_remove[templateId='" + portalskinChange.p.templateId + "']").show();
}

function getOpacityRgb(color1,Alpha1,color2,Alpha2){
	var R1,R2,G1,G2,B1,B2,Alpha;
	if(color2 == undefined){
		color2 = "rgb(255,255,255)";
		Alpha2 = 1;
		R2 = 255;
		G2 = 255;
		B2 = 255;
	}else{
		color2 = color2+"";
		if(color2.indexOf("#")!=-1){
			color2 = roRgbString(color2); 
		}
		color2 = color2.toLowerCase();
		if(color2.indexOf("rgb(")!=-1){
			var regexp =  /[0-9]{0,3}/g;
		    var fff = color2.match(regexp);
		    for(var i=0;i<fff.length;i++){
			    if(fff[i]==""){
			    	fff.splice(i,1);
			    	i--;
			    }
		    }
			R2 = fff[0];
			G2 = fff[1];
			B2 = fff[2];
		}
	}
	color1 = color1+"";
	if(color1.indexOf("#")!=-1){
		color1 = roRgbString(color1); 
	}
	color1 = color1.toLowerCase();
	if(color1.indexOf("rgb(")!=-1){
		var regexp =  /[0-9]{0,3}/g;
	    var fff = color1.match(regexp);
	    for(var i=0;i<fff.length;i++){
		    if(fff[i]==""){
		    	fff.splice(i,1);
		    	i--;
		    }
	    }
		   
		R1 = fff[0];
		G1 = fff[1];
		B1 = fff[2];
	}
//debugger;
  R   =   R1   *   Alpha1   +   R2   *   Alpha2   *   (1-Alpha1) ;   
  G   =   G1   *   Alpha1   +   G2   *   Alpha2   *   (1-Alpha1) ;    
  B   =   B1   *   Alpha1   +   B2   *   Alpha2   *   (1-Alpha1) ;   
  Alpha   =   1   -   (1   -   Alpha1)   *   (   1   -   Alpha2) ;   
  R   =   R   /   Alpha;    
  G   =   G   /   Alpha;    
  B   =   B   /   Alpha;
  R = isNaN(R)?0:R;
  G = isNaN(G)?0:G;
  B = isNaN(B)?0:B;
  return "rgb("+parseInt(R)+","+parseInt(G)+","+parseInt(B)+")";
  //return "rgb("+R+","+G+","+B+")";
}
function roRgbString(rgb){
	var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
	var sColor = rgb.toLowerCase();
	if(sColor && reg.test(sColor)){
		if(sColor.length === 4){
			var sColorNew = "#";
			for(var i=1; i<4; i+=1){
				sColorNew += sColor.slice(i,i+1).concat(sColor.slice(i,i+1));	
			}
			sColor = sColorNew;
		}
		//处理六位的颜色值
		var sColorChange = [];
		for(var i=1; i<7; i+=2){
			sColorChange.push(parseInt("0x"+sColor.slice(i,i+2)));	
		}
		//alert("RGB(" + sColorChange.join(",") + ")")
		return "RGB(" + sColorChange.join(",") + ")";
	}else{
		return sColor;	
	}
}