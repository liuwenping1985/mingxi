var taskAjax = new taskAjaxManager();
   /**
    * 判断操作的类型(新建，修改，查看)
    * @param operaType 操作类型
    * @param data 数据信息
    */
   function checkOperaType(operaType,data){
       if (data){
            
       }
       //点击新建
       if(arg=="new") {
           $("#status").val("未开始"); 
           $("#finishrate_text").val("0");
           $("#select_risk").val("无");
           $("#elapsed_time_text").val(""); 
           $("#content").val("");
       } else if(arg=="view") {
           //点击列表行
           //查看列表时input框 disable状态
           $("#status").attr({"disabled":"disabled","readonly":"readonly"}).val("");
           $("#finishrate_text").attr({"disabled":"disabled","readonly":"readonly"}).val("");
           $("#select_risk").attr({"disabled":"disabled","readonly":"readonly"}).val("");
           $("#elapsed_time_text").attr({"disabled":"disabled","readonly":"readonly"}).val("");
           $("#content").attr({"disabled":"disabled","readonly":"readonly"}).val("");
       } else {
           //点击修改
           $("#status").removeAttr("disabled").removeAttr("readonly");
           $("#finishrate_text").removeAttr("disabled").removeAttr("readonly");
           $("#select_risk").removeAttr("disabled").removeAttr("readonly");
           $("#elapsed_time_text").removeAttr("disabled").removeAttr("readonly");   
           $("#content").removeAttr("disabled").removeAttr("readonly");   
       }
   }
   
   /**
    * 初始化保存数据路径
    */
   function initSubmitUrl() {
       $("#task_feedback_form").attr("action", _ctxPath + "/taskmanage/taskfeedback.do?method=addTaskFeedback");
   }
   
   /**
    * 初始化页面按钮事件
    */
   function initBtnEvent(){
       $("#btn_ok").bind("click", saveTaskFeedback);
       $("#content").blur(function() {
           var isEidt = $("#isEidt").val();
           if(isEidt != 0) {
               checkTaskContetnNum(500);
           }
           doFeebackDesc(1);
       });
       $("#status").change(setFinishRate);
       $("#finishrate_text").keyup(setStatus);
   }
   
   /**
    * 初始化页面UI
    */
   function initPageUI(){
       var taskId = $("#task_id").val();
       var isPortal = $("#isPortal").val();
	   var isDialog = $("#isDialog").val();
       if($("#finishrate_text").val() == 0 && $("#status").val() == 1){
           $("#finishrate_text").attr({"disabled":"disabled"});
       }
       if(taskAjax.checkIfChildExist(taskId)) {
           $("#canhandwrite").val(1);
       }
       $("#old_status").val($("#status").val());
       if(isPortal == "1" || isDialog == "1") {
         $("#btn_area").addClass("display_none");
       }
	   if($("#canhandwrite").val()=="1"){
		$("#canwrite").prop("checked", true);
		yesido();
	   }
   }
   
   /**
    * 判断页面元素是否可以操作
    */
   function checkPage(){
   		initPageUI();
   }
   
   /**
    * 判断汇报内容不超过多少个字
    * @param maxNum 最大字符数
    */
    function checkTaskContetnNum(maxNum) {
        var total;
        var bool = true;
        total = $("#content").val().length;
        if (total > maxNum) {
            bool = false;
            $.alert($.i18n('taskmanage.alert.feedback_content_more_than_maxnum',maxNum,total));
        }
        return bool;
    }

   /**
    * 验证完成率是否合格
    * @param input 输入的完成率内容
    */
   function validateFinishrate(input) {
       var finishrate = $(input).val();
       var rangeBool = false;
       var decimalBool = false;
       if(finishrate >=0 && finishrate <= 100) {
           rangeBool = true;
       }
       var pattern = /^[0-9]+(.[0-9]{1,2})?$/;
       if (pattern.test(finishrate)) {
           decimalBool = true;
       }
       if(rangeBool == true && decimalBool == true) {
           return true;
       } else {
           return false;
       }
   }
   
   /**
    * 验证当前耗时是否合格
    * @param input 输入当前耗时的内容
    */
   function validateCurrentTime(input) {
       var currentTime = $(input).val();
       var rangeBool = false;
       var decimalBool = false;
       if(currentTime >=0 && currentTime <= 100000) {
           rangeBool = true;
       }
       var pattern = /^[0-9]+(.[0-9]{1})?$/;
       if (pattern.test(currentTime)) {
           decimalBool = true;
       }
       if(rangeBool == true && decimalBool == true) {
           return true;
       } else {
           return false;
       }
   }
   var finishrate_text = "";
   var elapsed_time_text = "";
   function yesido(){
   		if($("#canwrite").attr("checked")=="checked"){
   		   $("#autoActualTaskTime").removeClass("hidden");
           $("#autofinishrate").removeClass("hidden");
           $("#finishrate_text").removeAttr("disabled");
           $("#elapsed_time_text").removeAttr("disabled"); 
           $("#autofinishrate").html("<font color='grey' style='font-size:12px'>"+$.i18n('taskmanage.auto_completion_rate')+ $("#taskInfoAutoFinishRate").val()+"%</font>");
		   var autoActualTaskTimeTips=$.i18n('taskmanage.auto_time_consuming') + $("#taskInfoAutoActualTaskTime").val() + $.i18n('common.time.hour');
		   $("#autoActualTaskTime").html("<font color='grey' style='font-size:12px' title='"+autoActualTaskTimeTips+"'>"+autoActualTaskTimeTips+"</font>");
		   $("#canhandwrite").val("1");
		   finishrate_text = $("#finishrate_text").val();
   	       elapsed_time_text = $("#elapsed_time_text").val();
   		}else{
   		   $("#autoActualTaskTime").addClass("hidden");
           $("#autofinishrate").addClass("hidden");
           $("#finishrate_text").attr({"disabled":"disabled"});
           $("#elapsed_time_text").attr({"disabled":"disabled"});
	       $("#finishrate_text").val(finishrate_text);
   	       $("#elapsed_time_text").val(elapsed_time_text);
		   $("#canhandwrite").val("0");
   		}
   }