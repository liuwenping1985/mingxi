/*
    城市选择控件
   
    ************************
    * 
    * 城市筛选组件
    ************************
 */
(function($){
    var city_config = {
        layerclass: "_citylay",
        quitdata:null,
        specialdata:null,
        onshow:null,
        onhide:null
    }

    var runtime = {
        show: false,
        elem: null
    }

    function City( $root, conf ){
        $root.css("position","relative");

        $.extend($root,{
            getconfig: function(){  // 获取配置信息
                return conf;
            },
            cityshow: function(callback){
                if(callback){
                    conf.onshow = callback;
                }
                _initHtml();
                _showCitySelect(conf.onshow);
                return this;
            },
            cityhide: function(callback){
                if(callback){
                    conf.onhide = callback
                }
                _hideCitySelect(conf.onhide);
                return this;
            },
            settemp: function(temp){
                conf.template = temp;
                return this;
            },
            setdata: function( data ){
                conf.data = data;
                return this;
            },
            change: function( cityid, callback ){
                var currentdata = _getCityCar(cityid, conf);
                if(callback){
                    callback.call(window,currentdata);
                }
            }
        });

        $root.off("click").on("click",function(){
            if(!runtime.show){
                _initHtml();
                if(runtime.elem){
                    _showCitySelect(conf.onshow);
                }
            }else{
                _hideCitySelect(conf.onhide);
            }
        });


        /**
         * 初始化页面对象
         */
        function _initHtml(){
        	var currentSelCarLevel =getCurrentCarLevel();
        	var data;
            if(currentSelCarLevel.rule==301){
            	data=conf.quitdata;
            }else{
            	data=conf.specialdata;
            }
            var html = const_html(conf.template,data);
            runtime.elem = inner_html(html, conf.layerclass, $root);
            html = undefined;
        }

        function _getCityCar( cityid, data ){
            var re=null;
            $.each(data.quitdata,function(i,n){
            	$.each(n,function(_i,_n){
            		if(_n.area == cityid){
                        re = _n;
                        return false;
                    }
            	});
            });
            if(re==null){
            	$.each(data.specialdata,function(i,n){
            		$.each(n,function(_i,_n){
                		if(_n.area == cityid){
                            re = _n;
                            return false;
                        }
                	});
            	});
            	
            }
            
            return re;
        }


        /**
         * 显示城市选择层
         */
        function _showCitySelect(){
            if(runtime.show){ return false; }
            $root.parent(".info-input").addClass("onyellow");
            // 获取当前选中的城市
            var cityid = cityId,
                cityelem = runtime.elem.find("span[data-city-id='"+cityid+"']").addClass("current"),
                currentlayindex = cityelem.parent().index() - 1;
            
            runtime.elem.attr("data-city-box",true);
            runtime.elem.find("div._city_nav span").eq(currentlayindex).addClass("current");
            runtime.elem.find("div._city_content").hide().eq(currentlayindex).show();
            runtime.show = true;
            runtime.elem.slideDown(200,function(){
                bind_doc_hanler(function(){
                    _hideCitySelect();
                });
                if(conf.onshow){
                    conf.onshow.call(window,runtime.elem,$root);
                }
            });
        }

        /**
         * 删除城市选择层
         */
        function _hideCitySelect(){
            $root.parent(".info-input").removeClass("onyellow");
            runtime.show = false;
            runtime.elem.slideUp(200,function(){
                unbind_doc_hanler();
                runtime.elem.remove();
                runtime.elem = null;
                if(conf.onhide){
                    conf.onhide.call(window,$root);
                }
            })
        }

        return $root;
    }

    function const_html(temp, CarCity){
    	var h="";
    	  var obj = {
                  "ABCDE":[],
                  "FGHIJ":[],
                  "KLMNO":[],
                  "PQRST":[],
                  "UVWXYZ":[]
              }

    	  h+="<div><div class='_city_nav'>" ;
          $.each(obj,function(i,n){
        	  h+="<span>"+i+"</span>" ;
          });
    	  h+="</div>";
		for(var i=0;i<CarCity.length;i++){
			var citys=CarCity[i];
			h+="<div id=\"div_"+i+"\" class=\"_city_content clearfix\"";
			if(i==0){
				h+="style=\"display: block;\">";
			}else{
				h+="style=\"display: none;\">";
			}
			for(var j=0;j<citys.length;j++){
				h+="<span  data-city-id=\""+citys[j].area+"\" data-city-code=\""+citys[j].cityCode+"\" ";
				if(j==0){
					h+=" data-city-init=\""+citys[j].cityName+"\">";
				}else{
					h+="data-city-init=\"undefined\" >";
				}
				h+=citys[j].cityName+"</span>";
			}
			h+="</div>";
		}
        return h;
    }

    /**
     * 将HTML代码插入到指定的DOM节点内，该方法会删除原有节点内的所有HTML代码
     * @param  {string} html 需要插入的HTML
     * @param  {DOM jQuery} root 需要插入的DOM节点
     * @return {boolean}      插入成功或者失败
     */
    function inner_html(html, elemclass, root){
        var re = false;
        if(root.length){
            var offset = root.offset();
            html = $(html).addClass(elemclass).css({
                top:offset.top + root.outerHeight(),
                left:offset.left,
                position:'absolute',
                display:'none'
            });
            html.find("div._city_nav span").eq(0).addClass("first");
            $("body").append(html);
            re = html;
        }
        return re;
    }

    /**
     * 绑定空白处点击关闭弹出层
     */
    function bind_doc_hanler( callback ){
      $(document).off('click.city').on('click.city', function(e) {
        e = e || window.event;
        var target = e.target || e.srcElement,
            targetOut = is_child(target,'[data-city-box]');
        if(!targetOut){
            unbind_doc_hanler();
            if(callback){
                callback.call(window);
            }
        }
      });
    }

    /**
     * 解除空白处点击的事件绑定
     */
    function unbind_doc_hanler(){
        $(document).off('click.city');
    }

    /**
     * 源节点是否为目的节点的子节点
     * @param  {jQuery DOM}  target     源节点对应的jQuery对象
     * @param  {jQuery Selecter}  elemselect  目的节点的选择器
     * @return {Boolean}            源节点是否为目的节点的子节点 true/false
     */
    function is_child( target, elemselect ) {
        return $(target).closest( elemselect ).length > 0;
    }

    $.fn.city = function(conf){
        var $this = $(this);
        if($this.data("city")){
            return $this.data("city");
        }

        var api = new City($this,$.extend({},city_config,conf));
        $this.data("city",api);

        return api;
    }
})(jQuery);