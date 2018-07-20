<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" var="v3xHRI18N"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	//谷歌浏览器手动拖动frame之后使用clos定位有问题，屏蔽谷歌拖动
	if (v3x.isChrome) {
		parent.document.getElementById("statisticTree").setAttribute('noresize','noresize');
	}
	function quantityDep(){
		parent.statisticFrame.statisticTable.location.href = hrStatisticURL+"?method=statisticOfQuantityByDepartment";
		parent.statisticFrame.detailFrame.location.href = '<c:url value="/common/detail.jsp" />';
	}
	function quantityPost(){
		parent.statisticFrame.statisticTable.location.href = hrStatisticURL+"?method=statisticOfQuantityByPost";
		parent.statisticFrame.detailFrame.location.href = '<c:url value="/common/detail.jsp" />';
	}
	function quantityLevel(){
		parent.statisticFrame.statisticTable.location.href = hrStatisticURL+"?method=statisticOfQuantityByLevel";
		parent.statisticFrame.detailFrame.location.href = '<c:url value="/common/detail.jsp" />';
	}
	function educationTotal(){
		parent.statisticFrame.statisticTable.location.href = hrStatisticURL+"?method=statisticOfEducationTotal";
		setTimeout(
       		function(){	
       			parent.statisticFrame.detailFrame.location.href = hrStatisticURL+"?method=eduDistributing&newOrChanged=noChanged";
       		},
       		100
        );
	}
	function educationDep(){
		parent.statisticFrame.statisticTable.location.href = hrStatisticURL+"?method=statisticOfEducationByDepartment";
		parent.statisticFrame.detailFrame.location.href = '<c:url value="/common/detail.jsp" />';
		
	}
	function quantityGender(){
		parent.statisticFrame.statisticTable.location.href = hrStatisticURL+"?method=statisticOfQuantityByGender";
		setTimeout(
       		function(){	
       			parent.statisticFrame.detailFrame.location.href = hrStatisticURL+"?method=genderDistributing&newOrChanged=noChanged";
       		},
       		100
        );
	}
	function quantityAge(){
		parent.statisticFrame.statisticTable.location.href = hrStatisticURL+"?method=statisticOfQuantityByAge";
		setTimeout(
       		function(){	
       			parent.statisticFrame.detailFrame.location.href = hrStatisticURL+"?method=ageDistributing&newOrChanged=noChanged";
       		},
       		100
        );
	}
	function educationLevel(){
		parent.statisticFrame.statisticTable.location.href = hrStatisticURL+"?method=statisticOfEducationByLevel";
		parent.statisticFrame.detailFrame.location.href = '<c:url value="/common/detail.jsp" />';
	}
	function politicalTotal(){
		parent.statisticFrame.statisticTable.location.href = hrStatisticURL+"?method=statisticOfPoliticalTotal";
		setTimeout(
       		function(){	
       			parent.statisticFrame.detailFrame.location.href = hrStatisticURL+"?method=ppDistributing&newOrChanged=noChanged";
       		},
       		100
        );
	}
	function politicalWorkAge(){
        parent.statisticFrame.statisticTable.location.href = hrStatisticURL+"?method=statisticOfPoliticalWorkAge";
        setTimeout(
       		function(){	
       	        parent.statisticFrame.detailFrame.location.href = hrStatisticURL+"?method=workTimeDistributing&newOrChanged=noChanged";
       		},
       		100
        );
    }
	function politicalDep(){
		parent.statisticFrame.statisticTable.location.href = hrStatisticURL+"?method=statisticOfPoliticalByDepartment";
		parent.statisticFrame.detailFrame.location.href = '<c:url value="/common/detail.jsp" />';
	}
	function politicalLevel(){
		parent.statisticFrame.statisticTable.location.href = hrStatisticURL+"?method=statisticOfPoliticalByLevel";
		parent.statisticFrame.detailFrame.location.href = '<c:url value="/common/detail.jsp" />';
	}
</script>
</head>
<body>
<div class="scrollList border-padding border_r border-top" style="width: 95%;">
<script type="text/javascript">
	var root = new WebFXTree("10000", "<fmt:message key='hr.statistic.frame.label' bundle='${v3xHRI18N}' />", "");
	root.setBehavior('classic');
	root.icon = "<c:url value='/apps_res/collaboration/images/templete.gif'/>";
	root.openIcon = "<c:url value='/apps_res/collaboration/images/templete.gif'/>";	
	var aa10001 = new WebFXTreeItem('10001','<fmt:message key='hr.statistic.age.label' bundle='${v3xHRI18N}' />','');
	var aa20001 = new WebFXTreeItem('20001','<fmt:message key='hr.statistic.quantity.label' bundle='${v3xHRI18N}' />','');
	var aa30001 = new WebFXTreeItem('30001','<fmt:message key='hr.statistic.edu.label' bundle='${v3xHRI18N}' />','');
	var aa40001 = new WebFXTreeItem('40001','<fmt:message key='hr.statistic.pp.label' bundle='${v3xHRI18N}' />','');
	var aa_10002 = new WebFXTreeItem('10002','<fmt:message key='hr.statistic.age.distributing.label' bundle='${v3xHRI18N}' />','javascript:quantityAge()');
	var aa_20002 = new WebFXTreeItem('20002','<fmt:message key='hr.statistic.quantity.department.label' bundle='${v3xHRI18N}' />','javascript:quantityDep()');
	var aa_20003 = new WebFXTreeItem('20003','<fmt:message key='hr.statistic.quantity.business.label' bundle='${v3xHRI18N}' />','javascript:quantityLevel()');
	var aa_20004 = new WebFXTreeItem('20004','<fmt:message key='hr.statistic.quantity.station.label' bundle='${v3xHRI18N}' />','javascript:quantityPost()');
	var aa_20005 = new WebFXTreeItem('20005','<fmt:message key='hr.statistic.quantity.gender.label' bundle='${v3xHRI18N}' />','javascript:quantityGender()');
	var aa_30002 = new WebFXTreeItem('30002','<fmt:message key='hr.statistic.edu.total.label' bundle='${v3xHRI18N}' />','javascript:educationTotal()');
	var aa_30003 = new WebFXTreeItem('30003','<fmt:message key='hr.statistic.edu.department.label' bundle='${v3xHRI18N}' />','javascript:educationDep()');
	var aa_30004 = new WebFXTreeItem('30004','<fmt:message key='hr.statistic.edu.business.label' bundle='${v3xHRI18N}' />','javascript:educationLevel()');
	var aa_40002 = new WebFXTreeItem('40002','<fmt:message key='hr.statistic.pp.total.label' bundle='${v3xHRI18N}' />','javascript:politicalTotal()');
	var aa_40003 = new WebFXTreeItem('40003','<fmt:message key='hr.statistic.pp.department.label' bundle='${v3xHRI18N}' />','javascript:politicalDep()');
	var aa_40004 = new WebFXTreeItem('40004','<fmt:message key='hr.statistic.pp.business.label' bundle='${v3xHRI18N}' />','javascript:politicalLevel()');
	var aa50001 = new WebFXTreeItem('50001','<fmt:message key='hr.statistic.workTime.label' bundle='${v3xHRI18N}' />','');
	var aa_50002 = new WebFXTreeItem('50002','<fmt:message key='hr.statistic.workTime.distributing.label' bundle='${v3xHRI18N}'/>','javascript:politicalWorkAge()');
	aa10001.add(aa_10002);
	root.add(aa10001);
	aa50001.add(aa_50002);
	root.add(aa50001);
	aa20001.add(aa_20002);
    aa20001.add(aa_20003);
    aa20001.add(aa_20004);
    aa20001.add(aa_20005);
    root.add(aa20001);
    aa30001.add(aa_30002);
    aa30001.add(aa_30003);
    aa30001.add(aa_30004);
    root.add(aa30001);
    aa40001.add(aa_40002);
    aa40001.add(aa_40003);
    aa40001.add(aa_40004);
    root.add(aa40001);
	document.write(root);
	
	//选中第一个子菜单
	aa10001.expand();
	aa_10002.select();

</script>
</div>