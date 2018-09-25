function CorrelationProjects () {
	this.rowCanShowNum = 0;
	this.setRowCanShowNum = function(num){
		this.rowCanShowNum = num;
	}
	this.getRowCanShowNum = function(){
		return this.rowCanShowNum;
	}
	this.setStarFn = function (evt, projectId) {
		var htmlContentStr = "";
		$("li#pro_"+projectId).find(".project_star_24").show();
		$("li#pro_"+projectId).find(".project_star_24").attr("isDisplay", "1");
		$("li#pro_"+projectId).find(".project_no_star_24").hide();
		/*$("li#pro_"+projectId).find(".project_editor_24").hide();*/
		var params = new Object();
		params.projectState = getProjectStateParam($("#view_state").val());
		if (objParam.isSearch != "1") {
			if ($("#p_-10000").length == 0) {
				htmlContentStr = projectAjax.getMarkProjectTypeHtmlByParam(params);
				if (htmlContentStr.length > 0) {
					$("#projects_box").prepend(htmlContentStr);
				}
			}
			if ($("#p_-10000>.list_area").length > 0) {
				if ($(evt.target).parents(".list_item").size() > 0) {
					htmlContentStr = $(evt.target).parents(".list_item").clone();
				}
				//projectAjax.getProjectHtmlByProjectId(projectId, $.ctx.CurrentUser.id);
				$("#p_-10000>.list_area").prepend(htmlContentStr[0].outerHTML);
				if($("#p_-10000>.list_area>li").length>this.getRowCanShowNum()){
					//如果新添加数据后超过一行则移除最后一条 OA-70970
					$("#p_-10000>.list_area>li:eq("+this.getRowCanShowNum()+")").remove();
				}
				$("#p_-10000>.list_area>li#pro_"+projectId).find(".project_star_24").show();
				$("#p_-10000>.list_area>li#pro_"+projectId).find(".project_star_24").attr("isDisplay", "1");
				$("#p_-10000>.list_area>li#pro_"+projectId).find(".project_no_star_24").hide();
				$("#p_-10000>.list_area>li#pro_"+projectId).find(".project_editor_24").hide();
				//将没有数据提示隐藏       OA-74857
				$("#p_-10000>.list_area>.have_a_rest_area").hide();
				bindProjectMarkEventByObj($("#p_-10000>.list_area>li#pro_"+projectId));
				$("#p_-10000_count").html(parseInt($("#p_-10000_count").html())+1);
				initProjectMarkUI();
			}
		}
		var markProjectParam = new Object();
		markProjectParam.memberId = $.ctx.CurrentUser.id;
		markProjectParam.projectId = projectId;
		var bool = projectAjax.saveProjectMark(markProjectParam);
	}
	this.removeStarFn = function (argument) {
		if($("#p_-10000").find("li#pro_"+argument).length > 0) {
			$("#p_-10000").find("li#pro_"+argument).remove();
		}
		projectAjax.deleteMarkProjectById(argument);
		var rowCount = 4;
		if(correlationProjects!=null){
			rowCount = correlationProjects.getRowCanShowNum()
		}
		$("#p_-10000_count").html(parseInt($("#p_-10000_count").html())-1); 	 
		if($("#p_-10000").find("li.list_item").length == 0) {
			$("#p_-10000").remove();
		}else if($("#p_-10000").find("li.list_item").length!=parseInt($("#p_-10000_count").html())&&parseInt($("#p_-10000_count").html())>=rowCount){
			var currentProjectIds = "";
			$("#p_-10000").find("li.list_item").each(function(index, domEle){
				if(index!=0){
					currentProjectIds +=",";
				}
				currentProjectIds +=$(domEle).attr("projectId");
			});
			var starHtml = projectAjax.getProjectCardHtmlData({"rowCount":rowCount,"projectType":"-10000","projectState":getProjectStateParam($("#view_state").val()),"getOneCard":"true",currentProjectIds:currentProjectIds,viewType:"-1"});
			if(typeof starHtml != "object"){
				starHtml = eval("("+starHtml+")");
			}
			$("#p_-10000>.list_area").append(starHtml.html);
			bindProjectMarkEventByObj($("#p_-10000>.list_area>li#pro_"+starHtml.projectId));
			initProjectMarkUI();
		}
		$("li#pro_"+argument).find(".project_star_24").hide();
		$("li#pro_"+argument).find(".project_star_24").attr("isDisplay", "0");
		$("li#pro_"+argument).find(".project_no_star_24").show();
		$("li#pro_"+argument).find(".project_editor_24").show();
	}
	this.editorProjectFn = function (argument) {
		var url = _ctxPath + '/project/project.do?method=viewProject&type=update&projectId='+argument;
		var action = 'update';
		var title = $.i18n('project.modifyproject');
		var callBack = doReflashGrid;
		var dialog =$.dialog({
            id : 'editProjectWin',
            url : url,
            width : 556,
            height : getHeight(),
            title : title ,
            targetWindow : getCtpTop(),
            transParams:{ selectData:argument,
            			  action:action,
            			  callBack:callBack},
            buttons :  [ {
                text : $.i18n('common.button.ok.label'),
                id : 'ok',
	        	isEmphasize:true,
                handler : function() {
                	dialog.getReturnValue({'dialogObj' : dialog});
                }
            }, {
                text : $.i18n('common.button.cancel.label'),
                handler : function() {
                	dialog.close();
                }
            } ]
        });
	}
	function getHeight(){
		if($.browser.mozilla){
			return 470;
		}else{
			return 450;
		}
	}
	this.viewCloseProject = function(data){
		var title = $.i18n('project.set.label');
		var url = _ctxPath + '/project/project.do?method=viewProject&type=view&projectId='+data.id;
		var action = 'view';
		dialog = $.dialog({
            id : 'newProjectWin',
            url : url,
            width : 556,
            height : 450,
            title : title ,
            targetWindow : getCtpTop(),
            transParams:{ selectData:data,
            			  action:action,
            			  callBack:viewCloseProjectCallCack},
            buttons : [ {
                text : $.i18n('common.button.close.label'),
                handler : function() {
                    dialog.close();
                }
            } ]
        });
	}
}
/**
 * 查看已结束项目时的重启回调函数
 * @param data 	回调的值
 * @param dialog	回调的dialog对象
 */
function viewCloseProjectCallCack(data ,dialog){
	dialog.close();
	editorProject(data.id);
}
function CorrelationProjectsRun (correlationProjectsMgr) {
	var correlationProjectsRunObj = this;
	//根据窗体显示的分辨率，计算一行显示多少个项目
	this.getListRowNum = function () {
		correlationProjectsMgr.setRowCanShowNum(Math.floor($(window).width() / 290));
		$(window).resize(function () {
			correlationProjectsMgr.setRowCanShowNum(Math.floor($(window).width() / 290));
		});
	}
	this.scrollLoadingFn = function (argument) {
		$("#loading_text").removeClass("hidden");
		var htmlContentStr = "";
		if(objParam && objParam != null) {
			if (objParam.isSearch != "1") {
				htmlContentStr = getProjectCardHtml(objParam);
				if (viewType == 1) {
					$("#projects_box").append(htmlContentStr);
				} else {
					$("#projects_card").append(htmlContentStr);
				}
			} else {
				htmlContentStr = projectAjax.getProjectListHtml(objParam);
				if (viewType == 1) {
					$(".list_area").append(htmlContentStr);
				} else {
					$("#t_body").append(htmlContentStr);
				}
			}
		}
		bindProjectMarkEvent();
		initProjectMarkUI();
		initProjectListEvent();
		$("#loading_text").addClass("hidden");
	}
	//滚动底部加载
	this.scrollLoading = function () {
		setInterval(function(){
			var scrollHeight = $("#projects_card")[0].scrollHeight * 1;
			var scrollTop = $("#projects_card").scrollTop() * 1;
			var height = $("#projects_card").height() * 1;
			if (scrollHeight == scrollTop + height) {
				var end = parseInt($("#end_index").val());
				var total = parseInt($("#total").val());
				if (end < total){
					$("#start_index").val(end);
					var end = parseInt(end) + parseInt(pageSize);
					if (objParam.isSearch == "1") {
						end = parseInt(end) + parseInt(objParam.rowCount);
					}
					if (end > total) {
						$("#end_index").val(total);
					} else {
						$("#end_index").val(end);
					}
					objParam.currentPage = objParam.currentPage + 1;
					correlationProjectsRunObj.scrollLoadingFn();
				}
			};
		},500);
	}
	this.run = function() {
		this.getListRowNum();
		this.scrollLoading();
	}
}