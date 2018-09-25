/**
 * 手动评分页面
 */

var _selectMembers;// 已选中的用户信息
var _totalScores = 0;//当前选中分数
var _selectScoreIds = [];//选中的ID

function upDateScoreTime(date) {
	alert(date);
}

$(function() {

//	_selectMembers = "Member|" + _scoreUserId;
//	new inputChange($("#scoreUserName"), $
//			.i18n('infosend.label.stat.clickSelect'));// 请点击选择
//	$('#scoreUserName').click(
//			function() {
//				$.selectPeople({
//					type : 'selectPeople',
//					panels : 'Department',
//					selectType : 'Member',
//					text : $.i18n('common.default.selectPeople.value'),
//					hiddenPostOfDepartment : true,
//					hiddenRoleOfDepartment : true,
//					showFlowTypeRadio : false,
//					returnValueNeedType : true,
//					maxSize : 1,
//					minSize : 1,
//					hiddenSaveAsTeam : true,
//					params : {
//						value : _selectMembers
//					},
//					targetWindow : window.top,
//					callback : function(res) {
//						if (res && res.obj && res.obj.length > 0) {
//							var selPeopleId = "";
//							var selPeopleName = "";
//							var selPeopleType = "";
//							for ( var i = 0; i < res.obj.length; i++) {
//								if (i == res.obj.length - 1) {
////									selPeopleId += res.obj[i].type + "|"
////											+ res.obj[i].id + "|0";
//									selPeopleName += res.obj[i].name;
//									selPeopleId = res.obj[i].id;
//								} else {
////									selPeopleId += res.obj[i].type + "|"
////											+ res.obj[i].id + "|0" + ",";
//									selPeopleId = res.obj[i].id;
//									selPeopleName += res.obj[i].name + ",";
//								}
//							}
//							_selectMembers = res.value;
//
//							$("#scoreUserName").val(selPeopleName);
//							$("#scoreUserId").val(selPeopleId);
//						} else {
//
//						}
//					}
//				});
//			});
});

/**
 * 子页面点击回调函数
 * 
 * @param obj checkBox 对象
 * @param id  发布评分标准ID
 * @param score  发布评分标准分数
 */
function quoteDocumentSelected(obj, id, score) {
	if (!obj) {
		return;
	}
	var selectScore = parseInt(score);
	if (!obj.checked) {//取消选中
		selectScore = 0 - selectScore;
		for(var i = 0; i < _selectScoreIds.length; i++){
			if(_selectScoreIds[i] == id){
				_selectScoreIds.splice(i,1);
				break;
			}
		}
	}else{
		_selectScoreIds.push(id);
	}
	_totalScores += selectScore;
	$('#selectedSumScore').html(_totalScores)
}

/**
 * dialog回调函数
 * @returns
 */
function OK() {
	var o = new Object();
	o.currentScore = _totalScores;
	o.scoreTime = $('#scoreTime').val();
//	o.scoreUserId = $('#scoreUserId').val();
	o.scoreUserName = $('#scoreUserName').val();
	o.scoreDesc = $('#comment').val();
	var tempScoreTypeIds = "";
	for(var i = 0; i < _selectScoreIds.length; i++){
		if(tempScoreTypeIds == ""){
			tempScoreTypeIds += _selectScoreIds[i];
		}else{
			tempScoreTypeIds += "," + _selectScoreIds[i];
		}
	}
	o.scoreTypeIds = tempScoreTypeIds;
	return o;
}