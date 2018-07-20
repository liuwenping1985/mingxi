<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<script type="text/javascript">
<!--
	var indexFlag = 0;
	function change(){
			var obj = parent.document.getElementById("treeandlist");
			if(obj == null){
				return;
			}
			
			if(indexFlag==0){
				parent.document.getElementById("treeandlist").cols="0,*";
				indexFlag = 1;
			}else{
				parent.document.getElementById("treeandlist").cols="20%,*";
				indexFlag = 0;
			}
	}
	
	function printstatisticform() {
	try{
		//printIt(parent.statisticFrame.statisticTable.statisticform.innerHTML);
		   var aa= "";
		   var mm = parent.statisticFrame.statisticTable.statisticform.innerHTML;
		   var list1 = new PrintFragment(aa,mm);
		   var tlist = new ArrayList();
		   tlist.add(list1);
		   var cssList=new ArrayList();
		   printList(tlist,cssList);
		}catch(e){
			alert('<fmt:message key='hr.toolbar.print.label' bundle='${v3xHRI18N}' />');
		}
	}
//-->
</script>
</head>
<body>
<script type="text/javascript">
	//def toolbar
	var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	
	//add buttons
	//myBar1.add(new WebFXMenuButton("export", "<fmt:message key='hr.toolbar.salaryinfo.export.label' bundle='${v3xHRI18N}' />", "", [2,6]));
	myBar1.add(new WebFXMenuButton("print", "<fmt:message key='hr.toolbar.salaryinfo.print.label' bundle='${v3xHRI18N}' />", "printstatisticform()", [1,8], "", null));	
	myBar1.add(new WebFXMenuButton("change","<fmt:message key='label.view' bundle='${v3xCalI18N}' /><fmt:message key='hr.toolbar.change.label' bundle='${v3xHRI18N}' />","change()",[3,3], "", null));
	
	document.write(myBar1);
	document.close();
</script>

</body>
</html>