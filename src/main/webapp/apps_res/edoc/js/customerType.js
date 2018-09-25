

	


	$(document).ready(function() {
		//点击单选按钮 切换显示 自定义分类时
		$("#topRadio input[@type=radio]").click(function(){
			var id = this.id;
			var div = id.substring(2);
			$("#"+div).show();
			
			
			$("#topRadio input[@type=radio]").each(function(){
				//如果没有选中的，就先隐藏
				if(!$(this).attr("checked")){
					var id = this.id;
					var div = id.substring(2);
					//隐藏其余的 类别列表
					$("#"+div).hide();
				}
			});	

			//在切换 类别单选按钮时，也需要调用
			//viewUserCustomerType();
			
			/*
			$("#doc_data input[@type=checkbox]").each(function(){
				if(this.checked){
					selectone('generalType',this);
				}
			});
			
			$(".ct input").each(function(){
				if(this.checked){
					selectone('ct',this);
				}
			});*/
			
		});		

		//页面第一次加载时 调用
		viewUserCustomerType();
	});

	
			
	function save(){
		//保存时，只取当前 单选按钮 对应的 选中复选框
		$("input[@type=radio]").each(function(){
			if(!$(this).attr("checked")){
				var id = this.id;
				var div = id.substring(2);

				//其余的 类别旁的 复选框 不勾选，因为只能保存一个大类别下的 
				$("#"+div+" input[@type=checkbox]").attr("checked","");
			}
		});	
		document.myForm.target="operFrame";
		document.myForm.submit();
	}