var adminCommonOpera = {
	getProfession : function(data,defaultValue) {
		var selectProfession = $("#selectProfession");
		var selectClass = $("#selectClass");
		selectProfession.empty();
		selectClass.empty();
		$("<option value=\"-1\">--选择--</option>").appendTo(selectClass);
		$.ajax({
			type : "GET",
			dataType : "json",
			url : "api/classinfo/getProfession.html",
			data : {
				departmentcode : data
			},
			success : function(data) {
				// alert(data.departmentList[0].department_name);
				$("<option value=\"-1\">--选择--</option>").appendTo(
						selectProfession);
				$.each(data.profession, function(i, n) {
					$(
							"<option value=" + n.profession_code + ">"
									+ n.profession_name + "</option>")
							.appendTo(selectProfession);
				});
				if(!(defaultValue == "" || defaultValue == undefined || defaultValue == null)) {
					$("#selectProfession").find("option[value=" + defaultValue + "]").attr("selected", true);
				}
			}
		});
	},
	selectall : function() {
		var checkboxes = document.getElementsByName("task");
		for ( var i = 0; i < checkboxes.length; i++) {
			checkboxes[i].checked = event.srcElement.checked;
		}
	},
	getSelectChecked:function(){
		all = "";
		$('input[name="task"]:checked').each(function(){ 
		    all+=$(this).val()+','; 
		});
		all=all.substring(0,all.length-1);
		all=all.replace("on,","");
		return all;
	},
	getClassInfo : function(data,defaultValue) {
		var selectClass = $("#selectClass");
		selectClass.empty();
		$
				.ajax({
					type : "GET",
					dataType : "json",
					url : "api/classinfo/getClassInfo.html",
					data : {
						professioncode : data
					},
					success : function(data) {
						// alert(data.departmentList[0].department_name);
						$("<option value=\"-1\">--选择--</option>").appendTo(
								selectClass);
						$.each(data.profession, function(i, n) {
							$(
									"<option value=" + n.class_id + ">"
											+ n.class_name + "</option>")
									.appendTo(selectClass);
						});
						if(!(defaultValue == "" || defaultValue == undefined || defaultValue == null)) {
							$("#selectClass").find("option[value=" + defaultValue + "]").attr("selected", true);
						}
					}
				});
	}
}

//弹出窗口  
function showWindow(options) {
	jQuery("#MyPopWindow").window(options);
}
//关闭弹出窗口  
function closeWindow() {
	$("#MyPopWindow").window('close');
}  
//弹出窗口  
function showWindow(options,name) {
	jQuery("#"+name).window(options);
}
//关闭弹出窗口  
function closeWindow(name) {
	$("#"+name).window('close');
}
