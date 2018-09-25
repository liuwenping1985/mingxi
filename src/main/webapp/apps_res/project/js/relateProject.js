/**
*所有项目点击事件
*/
function watchAllProject(){
	updateClass("allProject","starProject");
	initProject("showProjectListPage","all");
}
/**
*标星项目点击事件
*/	
function watchStarProject(){
	updateClass("starProject","allProject");
	initProject("showProjectListPage","star");
}
/**
*更新页签样式
*/
function updateClass(adClass,rmClass){
	$("#"+adClass+"").parent().addClass("current");
	$("#"+rmClass+"").parent().removeClass("current");
}
/**
*页面跳转
*/
function initProject(initMethod,dataType){
	$("#projectFrame").attr("src",window._ctxServer+"/project/project.do?method="+initMethod+"&dataType="+dataType);
}
/**
*回调初始化
*/
function callBackInit(dataType){
	if("all"==dataType){
		watchAllProject();
	}else{
		watchStarProject();
	}
}
/**
*加载初始页面
*/
function loadHtml(ptList,dataType){
	loadSearch(dataType,ptList);
 	loadGrid(dataType);
 	//OA-70752选择管理项目窗口，ue问题，见截图
	$("#northSp_layout").hide();
}
/**
*加载条件搜索框
*/
function loadSearch(dataType,ptList){
	var searchobj = $.searchCondition({
			top:2,
			right:10,
            searchHandler: function(){
				returnValue = searchobj.g.getReturnValue();
				if(returnValue!=null){
					var obj=new Object();
					if("star"===dataType){
       	 				//标星(true为标星)
	        			obj["isMark"]=true;
        			}
					obj["memberId"]=$.ctx.CurrentUser.id;
					//除了相关人员角色
        			obj["projectRole"]="0,1,2,4,5";
					//表示已开始项目
					obj["projectState"]=0;
					var condition=returnValue.condition;
					obj[returnValue.condition]=returnValue.value;
					$("#listStatistic").ajaxgridLoad(obj);
				}
            },
            conditions: getConditionCol(ptList)
        });
}

function getConditionCol(ptList){
	var searchList=new Array();
	searchList.push(appendCondition("projectName","input",$.i18n('project.body.projectName.label'),""));
	searchList.push(appendCondition("projectNumber","input",$.i18n('project.body.projectNum.label'),""));
	searchList.push(appendCondition("projectType","select",$.i18n('project.body.type.label'),ptList));
	searchList.push(appendCondition("projectManager","input",$.i18n('project.body.responsible.label'),""));
	searchList.push(appendCondition("projectRole","select",$.i18n('project.body.role.label'),[{name:$.i18n('project.body.responsible.label'),id:"0"},{name:$.i18n('project.body.assistant.label'),id:"5"},{name:$.i18n('project.body.member.label'),id:"2"},{name:$.i18n('project.body.leader.label'),id:"1"}]));
	return searchList;
}

function appendCondition(projectId,eletype,display,items){
	var chObj=new Object();
	chObj.id=projectId;
	chObj.name=projectId;
	chObj.type=eletype;
	chObj.text=display;
	chObj.value=projectId;
	if(items!=""){
		chObj.items=getSelectList(items);
	}
	return chObj;
}
/**
*获取下拉列表数据
*/
function getSelectList(ptList){
	var objArr=new Array();
	var selectList=eval(ptList);
	if(selectList.length>0){
		for(var i=0;i<selectList.length;i++){
			var obj=new Object();
			obj.text=escapeStringToHTML(selectList[i].name);
			obj.value=selectList[i].id;
			objArr.push(obj);
		}
	}
	return objArr;
}
//保存数据类型
var datype1;
/**
*加载初始数据
*/
function loadGrid(dataType){
	datype1=dataType;
	var	grid = $('#listStatistic').ajaxgrid({
            colModel: [{
                    name: 'id',
                    width: '5%',
                    align: 'center',
                    type: 'radio',
                    isToggleHideShow:true
                }, {
                    display: $.i18n('project.body.projectName.label'),//项目名称
                    name: 'projectName',
                    sortable:true,
                    width: '30%'
                },{
                    display: $.i18n('project.body.projectNum.label'),//项目编号
                    name: 'projectNumber',
                    sortable:true,
                    width: '10%'
                },{
                    display: $.i18n('project.body.type.label'),//项目类型
                    name: 'projectTypeName',
                    sortable:true,
                    width: '10%'
                },{
                    display: $.i18n('project.body.responsible.label'),//项目负责人
                    name: 'mananger',
                    sortable:true,
                    width: '30%'
                },{
                    display: $.i18n('project.body.state.label'),//项目状态
                    name: 'projectState',
                    sortable:true,
                    width: '13%'
                }],
            resizable:false,
            render:rend,
            showTableToggleBtn: true,
            parentId: $('.layout_center').eq(0).attr('id'),
            callBackTotle:callBackRelate,
            resizeable:false,
            managerName : "projectQueryManager",
            managerMethod : "findProjectSummaryList"
        });
        var o=new Object();
        if("star"===dataType){
       	 	//标星(true为标星)
	        o.isMark=true;
        }
        //表示已开始项目
        o.projectState=0;
        //除了相关人员角色
        o.projectRole="0,1,2,4,5";
        o.memberId=$.ctx.CurrentUser.id;
    	$("#listStatistic").ajaxgridLoad(o);
}
function rend(txt, data, r, c){
	if(c==1){
		return "<input type='hidden' name='proName' value='"+data.projectName.escapeHTML()+"'>"+
		"<span class='grid_black'>"+txt+"</span>";
	}else{
		return txt;
	}
}

function callBackRelate(){
	var project=getA8Top().up.getProject();
	$("input[type='radio'][value='"+project.projectId+"']").attr("checked","true");
	return "";
}