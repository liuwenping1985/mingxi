<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="<c:url value='/apps_res/project/js/relateProject.js${v3x:resSuffix()}'/>"></script>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<script type="text/javascript">
	$(function(){
		var project=getA8Top().up.getProject();
		var dataType=project.dataType;
		if(dataType==""||dataType==undefined){
			//默认第一次访问弹出窗口
			initProject("showProjectListPage","all");
			//OA-70752选择管理项目窗口，ue问题，见截图
			$("#northSp_layout").hide();
			$("#center").css("top",$("#north1").css("height"));
		}else{
			//更多中选择了项目,回填操作
			callBackInit(dataType);
		}
	})
	
	function OK(){
		var retObj=new Object();
		var childBody=$("#projectFrame").contents();
		//获取选中项目的值
		var project=childBody.find("input[type='radio']:checked");
		if(project.length==0){
			return false;
		}
		var index=childBody.find("input[type='radio']").index(project);
		var projectName=childBody.find("input[name='proName']").eq(index).val();
		var dataType=childBody.find("input[name='proName']").eq(index).attr("dataType");
		var projectId=project.val();
		retObj.projectId=projectId;
		retObj.projectName=projectName;
		retObj.dataType=dataType;
		return retObj;
	}
</script>
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:31,maxHeight:31,minHeight:31,border:false">
             <div id="tabs2_head" class="common_tabs clearfix" style="background: none; margin:0 15px; ">
                    <ul class=left>
						<li class=current><a class=no_b_border id='allProject' name='allProject' onclick="watchAllProject()" href="javascript:void(0)"  tgt="tab1_div"><span>${ctp:i18n('project.grid.select.all.project')}</span></a></li>
						<li><a class=no_b_border id='starProject' name='starProject' onclick="watchStarProject()" href="javascript:void(0)" tgt="tab2_div" ><span>${ctp:i18n('project.grid.select.mark.project')}</span></a></li>
					</ul>
              </div>
        </div>
     	<div id="center" class="layout_center page_color over_hidden" layout="border:false" style="overflow-y: hidden;">
             	<iframe id="projectFrame" src='' width="100%" height="100%" frameborder="0"  style="overflow-y:hidden"></iframe>
     	</div>
    </div>
</body>
</html>