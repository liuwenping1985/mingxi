  var parentWindowData = window.dialogArguments;
  function selectPerson(curText) {
    $.selectPeople({
      type : 'selectPeople',
      showMe : false,
      panels : 'Department,Team,Post,Outworker,RelatePeople',
      selectType : 'Member',
      isNeedCheckLevelScope : false,
      text : $.i18n('common.default.selectPeople.value'),
      params : {
        text : $("#receiveMemberName").val(),
        value : $("#receiveMemberId").val()
      },
      targetWindow : getCtpTop(),
      callback : function(res) {
        $("#receiveMemberName").val(res.text);
        $("#receiveMemberId").val(res.value);
      }
    });
  }
  function OK() {
    var receiveMemberName = $("#receiveMemberName").val();
    if (receiveMemberName == $.i18n('calendar.event.create.person')) {
      $.alert($.i18n('calendar.event.list.cancel.event.authorized.select'));
      return false;
    } else {
      var states = $("input[name='states']");
      for ( var i = 0; i < states.length; i++) {
        if (states[i].value == 4) {
          $.alert($.i18n('calendar.event.list.cancel.event.authorized.end'));
          return false;
        }
      }
      var createUserIds = $("input[name='createUserId']");
      for ( var i = 0; i < createUserIds.length; i++) {
        if (createUserIds[i].value != $("#curUserID").val()) {
          $.alert($.i18n('calendar.event.list.cancel.event.authorized.other'));
          return false;
        }
      }
      $("#entrustSaveCalEvent").jsonSubmit({
        callback : function(res) {
          parentWindowData.searchFunc(null);
          parentWindowData.diaClose("entrust");
        }
      });
    }
  }