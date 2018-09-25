/**
 * Version 1.0
 * @author xiangq
 * 
 * 滚动加载数据组件（通过ajax请求获取后台数据）
 */
 (function( $ ){
 	$.fn.scrollPage = function(options) {
		var scrollObj = this[0];
		
		if (typeof scrollObj == "undefined") {
			return null;
		}
		if (scrollObj.scroll && typeof scrollObj.scroll == "object") {
			return scrollObj;
		}	
		/** 
         * page参数对象 
		 */  
        var config = {
			pageData: "",//页面数据
			params: {},//页面参数
			scrollContent: null,
			dataArea: null,
			dataLoding:false,//是否正在加载数据  
			canStartLoad:false,//是否可以开始加载数据  
			currentPage: 1,//页码  
			pageSize: 5,//每页显示的条数
			childSize: 0,//加载子内容的条数
			total: 0,//总条数
			pages: 0,//总页数
			time: null,//时间及时器  
			speed:10,//判断是否可加载的间隔  
			managerName: null,
            managerMethod: null,
			isImportAjax: true,
			isImportDataJs: true,
			changeParamFun: null,
			callbackFun: null,
			loadtext: "<div id=\"loading_text\" class=\"padding_10 font_size16 align_center color_gray hidden\">正在加载...</div>"
        };
		
		//初始化参数
		options = $.extend(config, options);
		
		if (options.isImportDataJs == true) {
			$("head").append("<script src='" + _ctxPath + "/apps_res/project/js/remoteDataService.js' type='text/javascript'></script>");
		}
		if (options.managerName && options.managerName != null && options.isImportAjax == true) {
            $("head").append("<script src='" + _ctxPath + "/ajax.do?managerName=" + options.managerName + "' type='text/javascript'></script>");	
        }
		
		var s = {
			/** 
			 * 判断获取滚动区域对象
			 */ 
			getSrollObject: function() {
				var scrObj = scrollObj;
				if (options.scrollContent != null) {
					if (typeof options.scrollContent == "string" && options.scrollContent.length > 0) {
						scrObj = options.scrollContent;
					}
				}
				return scrObj;
			},
			/** 
			 * 判断页面是否滚动到底部 
			 */  
			isPageBottom: function () {
				var scrObj = s.getSrollObject();
				var scrollHeight = $(scrObj)[0].scrollHeight * 1;
				var scrollTop = $(scrObj).scrollTop() * 1;
				var height = $(scrObj).height() * 1;
				if (scrollHeight == scrollTop + height) {
					return true;
				} else {
					return false;
				}
			},
			/** 
			 * 判断滚动条滚动的位置是否与上次一样
			 */
			isScrollSame: function () {
				var scrollH = 0;
				var bool = false;
				var scrObj = s.getSrollObject();
				var scrollTop = $(scrObj).scrollTop();
				if (scrollTop > scrollH) {
					scrollH = scrollTop;
					bool = true;
				}
				return bool;
			},
			isPageCount: function () {
				var bool = false;
				if (options.pages >= options.currentPage) {
					bool = true;
				}
				return bool;
			},
			canStartLoadData: function () {
				if (s.isPageBottom() && s.isPageCount() && s.isScrollSame()) {
					options.canStartLoad = true;
				} else {
					options.canStartLoad = false;
				}
			},
			loadData: function () {
				if (options.managerName && options.managerMethod) {
					var callerResponder = new CallerResponder();
					callerResponder.success = function (resultHtml) {
						s.addData(resultHtml);
						if (options.callbackFun != null && typeof options.callbackFun == "function") {
							options.callbackFun();
						}
						s.closeLoading();
					};
					var remoteDataSer = new RemoteDataService();
					if (options.changeParamFun != null) {
						options.changeParamFun();
					}
					remoteDataSer.remoteAjaxData(true, callerResponder, options.params, options.managerName, options.managerMethod);
				} else {
					if (options.callbackFun != null && typeof options.callbackFun == "function") {
						options.callbackFun();
					}
				}
			},
			/** 
			 * 添加数据内容
			 * @param data 数据内容
			 */
			addData: function (data) {
				if (typeof data == "string") {
					var curPage = options.params.page;
					if (curPage == 1) {
						$(scrollObj).html("");
					}
					if (data != null && data.length > 0) {
						if ($(scrollObj).html().length == 0) {
							$(scrollObj).html(data);
						} else {
							$(scrollObj).append(data);
						}
					} else {
						if (curPage == 1) {
							$(scrollObj).html("<div class=\"have_a_rest_area\">"+$.i18n("taskmanage.condition.no.content")+"</div>");
						}
					}
				}
			},
			getNextPage: function () {
				//页码加一
				options.currentPage = options.currentPage + 1;
			},
			/** 
			 * 获取分页数据
			 */  
			getPageData: function (){
				options.params.page = options.currentPage;
				options.params.size = options.pageSize;
				if (typeof options.params.total == "undefined") {
					options.params.total = options.total;
				}
				if (typeof options.params.childSize == "undefined") {
					if (options.childSize != 0) {
						options.params.childSize = options.childSize;
					}
				}
			}, 
			startLoading: function () {
				var loadTextId = $(options.loadtext).attr("id");
				var loading = $(scrollObj).find("#"+loadTextId);
				if (loading.size() == 0) {
					$(scrollObj).append(options.loadtext);
					loading.show();
				} else {
					loading.show();
				}
			},
			closeLoading: function () {
				var loadTextId = $(options.loadtext).attr("id");
				var loading = $(scrollObj).find("#"+loadTextId);
				if (loading.size() > 0) {
					loading.hide();
				}
			},
			startLoadData: function () {
				s.startLoading();
				s.getPageData();
				s.loadData();
			},
			listenerScroll: function (paras) {
				if (typeof paras != "undefined" && paras != null) {
					options.params = paras;
					if(typeof paras.currentPage != "undefined"){
						options.currentPage = paras.currentPage;
					}else{
						options.currentPage = 1;
					}
					if (paras.total) {
						options.total = paras.total;
					}
					if (paras.size) {
						options.pageSize = paras.size;
					}
					if (paras.childSize) {
						options.childSize = paras.childSize;
					}
					//计算数据的总页数
					options.pages =  options.total % options.pageSize == 0 ? parseInt(options.total / options.pageSize) : parseInt(options.total / options.pageSize) + 1;
				}
				if (options.pages == 0) {
					$(scrollObj).html("<div class=\"have_a_rest_area\">"+$.i18n("taskmanage.condition.no.content")+"</div>");
				} else {
					if(paras && paras.notClear == true){
						//不清除页面
					}else{
						$(scrollObj).html("");
					}
					/*setInterval(function(){
						s.canStartLoadData();
						if (options.canStartLoad) {
							s.startLoadData();
							s.getNextPage();
						}
					},700);*/
					if (options.currentPage == 1) {
						s.startLoadData();
						s.getNextPage();
					}
					var scrObj = s.getSrollObject();
					$(scrObj).unbind().bind("scroll", function(){
						s.canStartLoadData();
						if (options.canStartLoad) {
							s.startLoadData();
							s.getNextPage();
						}
					});
				}
			}
		}
		
		scrollObj.cfg = options;
		scrollObj.scroll = s;
		return scrollObj;
	};
	$.fn.ajaxSrollLoad = function (para) { 
        return this.each(function () {
            if (this.scroll) {
                this.scroll.listenerScroll(para);
            }
        });
    };
 })(jQuery);