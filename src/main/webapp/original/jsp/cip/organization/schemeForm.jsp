<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=syncConfigManager"></script>
</head>

<script type="text/javascript">

	$().ready(function() {
		var syncM=new syncConfigManager();
		$("#select1").change(function(){
			var driver = $("#select1 option:selected").val()  ;
			$("#dburltr").resetValidate();
			if (driver == "oracle.jdbc.driver.OracleDriver") {
				$("#dbdriver").val(driver);
				$("#dburl").val("jdbc:oracle:thin:@[host]:[prot|1521]:[DB_Name]");
				$("#dbtype").val(1);
			} else if (driver == "com.mysql.jdbc.Driver") {
				$("#dbdriver").val(driver);
				$("#dburl").val("jdbc:mysql://[host]:[port|3306]/[DB_Name]?autoReconnection=true");
				$("#dbtype").val(2);
			} else if (driver == "net.sourceforge.jtds.jdbc.Driver") {
				$("#dbdriver").val(driver);
				$("#dburl").val("jdbc:jtds:sqlserver://[host]:[port|1433]/[DB_Name]");
				$("#dbtype").val(3);
			}
		
		});
		
		$("#go").click(function(){//生成xml格式
			goXmlString();
		});	
		
		$("#bk").click(function(){//读取xml格式信息，返回页面显示
			showView();
		});

	});
</script>
<body>
	<form name="addForm" id="addForm" method="post" target="delIframe">
	<div class="form_area" >
		<div class="one_row" style="width:45%;">
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<br>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<input type="hidden" name="id" id="id" value="" />			
					<input type="hidden" name="personnInforConfig" id="personnInforConfig" value="" />
					<input type="hidden" name="dbdriver" id="dbdriver" value="" />
					<input type="hidden" name="dbtype" id="dbtype" value="" />
					<input type="hidden" name="isCreateMidTab" id="isCreateMidTab" value="" />
					<input type="hidden" name="viewid" id="viewid" value="" />
					<input type="hidden" name="extAttr2" id="extAttr2" value="" />
					<input type="hidden" name="extAttr3" id="extAttr3" value="" />
					<input type="hidden" name="synMode" id="synMode" value="" />
					<input type="hidden" name="dbpwd" id="dbpwd" value="" />
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.scheme.param.config.name')}:</label></th>
						<td width="100%" colspan="3">
							<div class="common_txtbox_wrap">
								<input type="text" id="name" class="validate word_break_all" name="name"
									validate="notNull:true,minLength:1,name:'${ctp:i18n('cip.scheme.param.config.name')}',maxLength:85">
							</div>
						</td>
					</tr>					
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.scheme.param.config.sys')}:</label></th>
						<td width="100%" colspan="3">
							<div class="common_txtbox_wrap">
								<input type="hidden" id="extAttr1" value="">
								<input type="text" id="systemCode" readonly="readonly" class="validate word_break_all" validate="name:'${ctp:i18n('cip.scheme.param.config.sys')}',notNull:true">	
							</div>
						</td>
					</tr>
					<tr class="product">
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.scheme.param.config.code')}:</label></th>
						<td width="50%">
							<div class="common_txtbox_wrap">
								<input type="text" id="productCode" disabled="disabled" class="word_break_all">	
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.scheme.param.config.version')}:</label></th>
						<td width="50%">
							<div class="common_txtbox_wrap">
								<input type="text" id="productVersion" disabled="disabled" class="validate word_break_all"
									validate="type:'string',name:'${ctp:i18n('cip.scheme.param.config.version')}',notNull:false,minLength:1,maxLength:85">	
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.scheme.param.config.sync')}:</label></th>
						<td width="100%" colspan="3">
							<div class="common_selectbox_wrap">
                            <select id="direction">
                                <option value="1">${ctp:i18n('cip.scheme.param.config.third')}-->${ctp:i18n('cip.scheme.param.config.synergy')}</option>
                            </select>
                        	</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.scheme.param.config.drisys')}:</label></th>
						<td width="100%" colspan="3">
							<div class="common_selectbox_wrap">
                            <select id="driverMode">
                                <option value="1">${ctp:i18n('cip.scheme.param.config.dritype')}</option>
                            </select>
                        	</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.scheme.param.config.synctype')}:</label></th>
						<td width="100%" colspan="3">
							<div class="common_radio_box clearfix">
							    <label for="synMode1" class="margin_r_10 hand" id="sync">
							        <input type="radio" value="1" id="synMode1" name="option" class="radio_com synMode1" onclick="checkRadio(1)" >${ctp:i18n('cip.scheme.param.config.sync1')}</label>
							    <label for="synMode2" class="margin_r_10 hand">
							        <input type="radio" value="2" id="synMode2" name="option"  onclick="checkRadio(2)" class="radio_com">${ctp:i18n('cip.scheme.param.config.sync2')}</label>
							    <label for="synMode3" class="margin_r_10 hand">
							        <input type="radio" value="3" id="synMode3" onclick="checkRadio(3)"  name="option" class="radio_com interface" disabled="disabled">${ctp:i18n('cip.scheme.param.config.sync3')}</label>
							</div>
						</td>
					</tr>
					
					<tr id="interface_tr">
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.scheme.param.config.intef1')}:</label></th>
						<td width="50%">
							<div class="common_txtbox_wrap" style="border-top: 0px;border-left: 0px;border-right: 0px;border-bottom:  1px;">
								<input type="text" id="interfacetext"  name="interfacetext" readonly="readonly">
							</div>
						</td>
						<td colspan="2">
							<a href="javascript:void(0)" class="common_button common_button_emphasize">${ctp:i18n('cip.scheme.param.config.intef2')}</a>
						</td>
					</tr>
					<tr style="margin-top: 10px;">
						<th nowrap="nowrap" valign="top"><label class="margin_r_10" for="text">${ctp:i18n('cip.scheme.param.config.mid')}:</label></th>
						<td width="100%" colspan="3">
							<table border="0" cellspacing="0" cellpadding="0" class="only_table" style="margin-top: 10px;" width="100%">
								<tbody>
									<tr>
										<th nowrap="nowrap">
											<label class="margin_r_10" for="text">${ctp:i18n('cip.scheme.param.config.dbdri')}:</label></th>
										<td>
											<div class="common_selectbox_wrap">
												<select id="select1">
													<option id="o" value="" selected="selected"></option>
													<option id="o1" value="oracle.jdbc.driver.OracleDriver" >oracle.jdbc.driver.OracleDriver</option>
													<option id="o2" value="com.mysql.jdbc.Driver">com.mysql.jdbc.Driver</option>
													<option id="o3" value="net.sourceforge.jtds.jdbc.Driver"">net.sourceforge.jtds.jdbc.Driver</option>
												</select>
											</div>
										</td>
									</tr>
									<tr id="dburltr">
										<th nowrap="nowrap">
											<label class="margin_r_10" for="text">DBURL:</label></th>
										<td width="100%">
											<div class="common_txtbox_wrap">
												<input type="text" id="dburl"  class="validate word_break_all" value="" validate="type:'string',name:'DBURL',notNull:true,minLength:1,maxLength:200"  onchange="checkIsCreate()">
											</div>
										</td>
									</tr>
									<tr>
										<th nowrap="nowrap">
											<label class="margin_r_10" for="text">${ctp:i18n('cip.scheme.param.config.user')}:</label></th>
										<td>
											<div class="common_txtbox_wrap">
												<input type="text" id="dbuser"  class="validate word_break_all" validate="type:'string',name:'${ctp:i18n('cip.scheme.param.config.user')}',notNull:true,minLength:1,maxLength:20"  onchange="checkIsCreate()">
											</div>
										</td>
									</tr>
									<tr>
										<th nowrap="nowrap">
											<label class="margin_r_10" for="text">${ctp:i18n('cip.scheme.param.config.pass')}:</label></th>
										<td>
											<div class="common_txtbox_wrap">
												<input type="password" id="dbpwd1"  class="validate word_break_all"  validate="type:'string',name:'${ctp:i18n('cip.scheme.param.config.pass')}',minLength:0,maxLength:20" onchange="checkIsCreate()">
											</div>
										</td>
									</tr>
									<tr>
										<th nowrap="nowrap">
											<label class="margin_r_10" for="text">${ctp:i18n('cip.scheme.param.config.mid2')}:</label></th>
										<td>
											<div class="common_txtbox_wrap">
												<span id="tab1"></span>
												<div style="float:right;" id="d1">
													<a href="javascript:void(0)"  class="common_button common_button_disable" id="createTable" >${ctp:i18n('cip.scheme.param.config.create')}</a>
													<a href="javascript:void(0)" class="common_button common_button_disable"  id="loadTable">${ctp:i18n('cip.scheme.param.config.load')}</a>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th nowrap="nowrap" >
											<label class="margin_r_10" for="text">${ctp:i18n('cip.scheme.param.config.view')}:</label></th>
										<td>
											<div class="common_txtbox_wrap">
												<span id  ="tab2"></span>
													<div style="float:right;">
														<div class="comp" comp="type:'fileupload',applicationCategory:'39',quantity:1,maxSize:102400,firstSave:true,canDeleteOriginalAtts:false,originalAttsNeedClone:false,callMethod:'enumImageCallBk'"></div>
														<a  id ="d2" href="javascript:void(0)" class="common_button common_button_disable">${ctp:i18n('cip.scheme.param.config.upview')}</a>
													</div>
											</div>
										</td>
									</tr>	
									<tr>
										<th nowrap="nowrap" >
											<label class="margin_r_10" for="text">${ctp:i18n('cip.scheme.param.config.view2')}:</label></th>
										<td>
											<div class="common_txtbox_wrap">
												<span id  ="tab3"></span>
													<div style="float:right;">
														<a  id="d3" href="javascript:void(0)" class="common_button common_button_disable">${ctp:i18n('cip.scheme.param.config.ctview')}</a>
													</div>
											</div>
										</td>
									</tr>
									
								</tbody>
							</table>
						</td>
					</tr>
					
					<tr>
						<th nowrap="nowrap"  align="left"><label class="margin_r_10" for="text">${ctp:i18n('cip.scheme.param.config.hr')}:</label></th>
						<td colspan="3"></td>
					<tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"></label></th>
						<td width="100%" colspan="3">
							<table id="view"  border="0" cellspacing="0" cellpadding="0" class="only_table edit_table"  width="100%">
								<tbody>
									<tr>
										<th>${ctp:i18n('cip.scheme.param.config.hrinfo')}</th>
										<th>${ctp:i18n('cip.scheme.param.config.cn')}</th>
										<th>${ctp:i18n('cip.scheme.param.config.hr1')}</th>
										<th>${ctp:i18n('cip.scheme.param.config.hr2')}</th>
										<th>${ctp:i18n('cip.scheme.param.config.hr3')}</th>
									</tr>
									
									<c:forEach items="${listEnum}" var="dataItem" varStatus="rowStatus" > 
										<tr>
											<td>${dataItem.en}</td>
											<td>${dataItem.cn}</td>
											<td><input type="checkbox"  value="${dataItem.att1}" disabled="true"  /></td>
											<td>
												<div class="common_selectbox_wrap">
													<select id="selectd${rowStatus.count}"   onchange ="changeRp()" >
														<c:if test="${not empty listMeta }">
															<option id="s" value="" selected="selected"></option>
														</c:if>
														<c:if test="${empty listMeta }">
															<option id="s" value="" selected="selected"></option>
														</c:if>
														
														<c:forEach items="${listMeta}" var="data" varStatus="row2" >
															<option  value="${data.id}">${data.label}</option>
														</c:forEach>
													</select>
												</div>
											</td>
											<td><input type="checkbox" value="${dataItem.att3}"   /></td>
										</tr>
									</c:forEach>
									
								</tbody>
							</table>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		</div>
	</form>

	<form hidden="hidden" id="uploadFile" action="${path}/cip/org/synOrgController.do?method=loadFile" method="post">
		<input type="hidden" id="loadtype" name="loadtype" value="">
	</form>
</body>
<script type="text/javascript">
	function checkRadio(value){
		var createTable = $("#createTable") ;
		var loadTable = $("#loadTable");
		var d2 = $("#d2") ;
		var d3 = $("#d3");
		var synMode = $("#synMode");
		if(value == 1 ){
			createTable.removeAttr("onclick");
			createTable.removeAttr("class");
			createTable.attr("class","common_button common_button_gray");
			createTable.attr("onclick","checkOrCreate(1)");
	
			loadTable.removeAttr("onclick");
			loadTable.removeAttr("class");
			loadTable.attr("class","common_button common_button_gray");
			loadTable.attr("onclick","checkOrCreate(2)");
	
			d2.removeAttr("onclick");
			d2.removeAttr("class");
			d2.attr("class","common_button common_button_disable");
	
			d3.removeAttr("onclick");
			d3.removeAttr("class");
			d3.attr("class","common_button common_button_disable");
	
			synMode.val(1);
		}else if( value == 2 ){
			createTable.removeAttr("onclick");
			createTable.removeAttr("class");
			createTable.attr("class","common_button common_button_disable");
	
			loadTable.removeAttr("onclick");
			loadTable.removeAttr("class");
			loadTable.attr("class","common_button common_button_disable");
	
			d2.removeAttr("onclick");
			d2.removeAttr("class");
			d2.attr("class","common_button common_button_gray");
			d2.attr("onclick","insertAttachment()");
	
			d3.removeAttr("onclick");
			d3.removeAttr("class");
			d3.attr("class","common_button common_button_gray")
			d3.attr("onclick","checkOrCreate(3)");
	
			synMode.val(2);
		}else{//预览模式
			createTable.removeAttr("onclick");
			createTable.removeAttr("class");
			createTable.attr("class","common_button common_button_disable");
	
			loadTable.removeAttr("onclick");
			loadTable.removeAttr("class");
			loadTable.attr("class","common_button common_button_disable");
	
			d2.removeAttr("onclick");
			d2.removeAttr("class");
			d2.attr("class","common_button common_button_disable");
	
			d3.removeAttr("onclick");
			d3.removeAttr("class");
			d3.attr("class","common_button common_button_disable")
		}
	}

	function aftShowView(){
		//根据返回的配置xml信息 更新显示效果
		var syncM=new syncConfigManager();
		var data = $("#personnInforConfig").val() ;
		var hrbl = $("#hrbl").val() ;
		if(data.length > 0 && data != "" && data != "null"){
			data = eval("(" + data + ")");
			for(var i = 0; i < data.length ;i++){
				if(data[i].addr == "" || data[i].addr  == null){
				}else{
					 $("#selectd"+(i+1)+" option").each(function(){
						if($(this).val() == data[i].addr){
							$(this).attr("selected","selected");
						}
					}); 
				}
				if( hrbl == "true"){
					if(data[i].hr  == 0){
						$("#view tr:eq("+(i+1)+")").find("td:eq(4)").find("input[type=checkbox]").attr("checked",true) ;
					}
				}
			 }  
		}
	}
	
	function loadView(){
		//同步方式
		var synMode = $("#synMode").val();
		if(synMode == 1 || synMode == null || synMode == ""){
			$("#synMode").val("1");
			$("#synMode1").attr("checked","checked");
			checkRadio(1);
		}else if( synMode == 2 ){
			$("#synMode2").attr("checked","checked");
			
		}else if( synMode == 3 ){
			$("#synMode3").attr("checked","checked");
		}
		
		//显示驱动
		var driver = $("#dbdriver").val();
		 $("#select1 option").each(function(){
				if($(this).val() == driver){
					$(this).attr("selected","selected");
					$("#dbtype").val($(this).index());
				}
			}); 
		var passV = $("#dbpwd").val();
		$("#dbpwd1").val(passV);
		//判断是否创建中建表
		var tab =$("#isCreateMidTab").val();
		if(tab == "" ||tab == "0" || tab == null ||  tab == "false"){
			$("#tab1").html("${ctp:i18n('cip.scheme.param.create.false')}");
		}else{
			$("#tab1").html("${ctp:i18n('cip.scheme.param.create.true')}");
		}
		//视图显示效果
		var tab2 =$("#viewid").val();
		if(tab2 == "" || tab2 == null ||tab2 == "0"){
			$("#tab2").html("${ctp:i18n('cip.scheme.param.upload.false')}");
		}else{
			var fileName = $("#extAttr2").val() ;

			if(fileName.length >20){
				$("#tab2").html(""+fileName.substring(0,19)+"...<input type='hidden'  id="+tab2+" value="+fileName+">");
			}else{
				$("#tab2").html(""+fileName+"<input type='hidden'  id="+tab2+" value="+fileName+">");
			}
		}
		
		var tab3 =$("#extAttr3").val();
		if(tab3 == "" || tab3 == null ||tab3 == "0"){
			$("#tab3").html("${ctp:i18n('cip.scheme.param.create.false')}");
		}else{
			$("#tab3").html("${ctp:i18n('cip.scheme.param.create.true')}");
		}

		var trl = $("#view tr").length;
		//同步扩展信息列表显示
		for (var i = 1; i < trl ; i++)
		{	//第一同步列
			var t1 = $("#view tr:eq("+i+")").find("td:eq(2)").find("input[type=checkbox]").val();
			if(t1 == 0){
				$("#view tr:eq("+i+")").find("td:eq(2)").find("input[type=checkbox]").attr("checked","checked");
			}else if(t1 == 1){
				
			}else{
				$("#view tr:eq("+i+")").find("td:eq(2)").html("");
			}
			//第三同步列
			var t3 = $("#view tr:eq("+i+")").find("td:eq(4)").find("input[type=checkbox]").val();
			if(t3 == 0){
				$("#view tr:eq("+i+")").find("td:eq(4)").find("input[type=checkbox]").attr("checked","checked");
			}else if(t3 == 1){
				
			}else{
				$("#view tr:eq("+i+")").find("td:eq(4)").html("");
			}
		}
	}

	//判断数据库连接
	function checkDB(driver,url,name,pass){
		var syncM=new syncConfigManager();
		var bool = syncM.checkDB(driver,url,name,pass);
		if(bool == true){
			//$.alert("${ctp:i18n('cip.scheme.param.DB.conn.true')}");
		}else{
			//$.alert("${ctp:i18n('cip.scheme.param.DB.conn.false')}");
			return "false";
		}
	}
	//创建中间表
	function createDbTable(driver,url,name,pass,type){
		var syncM=new syncConfigManager();
		var bool = syncM.createTableOrView(driver,url,name,pass,type);
		if(bool == true){
			$.infor("${ctp:i18n('cip.scheme.param.createTable.true')}");
			$("#isCreateMidTab").val("1");
			$("#tab1").html("${ctp:i18n('cip.scheme.param.create.true')}");
		}else{
			$.error("${ctp:i18n('cip.scheme.param.createTable.false')}");
			$("#isCreateMidTab").val("0");
			$("#tab1").html("${ctp:i18n('cip.scheme.param.create.false')}");
			return;
		}	
	}

	function checkOrCreate(typ){
		var syncM=new syncConfigManager();
		//typ 1  创建中间库   2 下载中间库  3 创建视图  
		var driver = $("#select1 option:selected").val()  ;
		var url = $("#dburl").val() ;
		var name = $("#dbuser").val() ;
		var pass = $("#dbpwd1").val()  ;
		var type = $("#dbtype").val() ;//判断数据库类型 1 oracle  2 mysql 3 sqlserver
		if(typ == 1){
			//判断是否创建中建表
			var tab =$("#isCreateMidTab").val();
			if(tab == "" || tab == null || tab == "false" || tab == "0"){
				var bol = checkDB(driver,url,name,pass); 
				if(bol == "false"){
					$.error("${ctp:i18n('cip.scheme.param.DB.conn.false')}");
					return;
				}else{
					var bl = createDbTable(driver,url,name,pass,type);
				}
				
			}else{
				$.alert("${ctp:i18n('cip.scheme.param.createTable.istrue')}");
				return;
			}
			//视图显示效果
			var tab2 =$("#viewid").val();
			if(tab2 == "" || tab2 == null){
				$("#tab2").html("${ctp:i18n('cip.scheme.param.upload.false')}");			
			}
			
			var tab3 =$("#extAttr3").val();
			if(tab3 == "" || tab3 == null){
				$("#tab3").html("${ctp:i18n('cip.scheme.param.create.false')}");
			}else{
				$("#tab3").html("${ctp:i18n('cip.scheme.param.create.true')}");
			}
		}
		else if(typ == 2){
			if(type == "" || type == null || type == 0 ){
				$.alert("${ctp:i18n('cip.scheme.param.choose.driver')}");
			}else{
				$("#loadtype").val(type);
				$("#uploadFile").submit();
			}
		}
		else if(typ == 3){
			var v = $("#viewid").val();
			if(v == "" || v == null){
				$.alert("${ctp:i18n('cip.scheme.param.choose.view')}");
			}else{
				var bol = checkDB(driver,url,name,pass); 
				if(bol == "false"){
					$.error("${ctp:i18n('cip.scheme.param.DB.conn.false')}");
					return;
				}else{
					if($("#extAttr3").val() == 1){
						$.alert("${ctp:i18n('cip.scheme.param.createTable.istrue')}");
					}else{
						var bool = syncM.createTableOrView(driver,url,name,pass,v);
						if(bool == true){
							$.infor("${ctp:i18n('cip.scheme.param.create.istrue')}");
							$("#tab3").html("");
							$("#tab3").html("${ctp:i18n('cip.scheme.param.create.true')}");
							$("#extAttr3").val("1");
						}else{
							$.alert("${ctp:i18n('cip.scheme.param.upload.istrue')}");
							$("#tab3").html("${ctp:i18n('cip.scheme.param.create.false')}");
							return;
						}
					}
				}
			}
		}
	}

	function checkIsCreate(){
		var syncM=new syncConfigManager();
		var driver = $("#select1 option:selected").val()  ;
		var url = $("#dburl").val() ;
		var name = $("#dbuser").val() ;
		var pass = $("#dbpwd1").val()  ;
		var tp = $("#dbtype").val() ;//判断数据库类型 1 oracle  2 mysql 3 sqlserver
		var synMode = $("#synMode").val();//判断同步类型
		if(synMode == 1){
			$("#tab3").html("${ctp:i18n('cip.scheme.param.create.false')}");
			$("#extAttr3").val("");
			var bl  = syncM.checkIsCreate(driver,url,name,pass,synMode,tp);
			if(bl == false){
				$("#tab1").html("${ctp:i18n('cip.scheme.param.create.false')}");
				$("#isCreateMidTab").val("0");
			}else{
				$("#tab1").html("${ctp:i18n('cip.scheme.param.create.true')}");
				$("#isCreateMidTab").val("1");
			}
		}else{
			$("#tab1").html("${ctp:i18n('cip.scheme.param.create.false')}");
			$("#isCreateMidTab").val("0");
		}
		
	}

</script>

</html>