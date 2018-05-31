var portalManager=RemoteJsonService.extend({
     jsonGateway: "/seeyon/ajax.do?method=ajaxAction&managerName=portalManager",
     getCustomizeMenusOfMember: function(){
                  return this.ajaxCall(arguments,"getCustomizeMenusOfMember");
     },
     getCustomizeShortcutsOfMember: function(){
                  return this.ajaxCall(arguments,"getCustomizeShortcutsOfMember");
     },
     getPageTitle: function(){
                  return this.ajaxCall(arguments,"getPageTitle");
     },
     getGroupShortName: function(){
       return this.ajaxCall(arguments,"getGroupShortName");
     },
     getGroupSecondName: function(){
       return this.ajaxCall(arguments,"getGroupSecondName");
     },
     getAccountName: function(){
       return this.ajaxCall(arguments,"getAccountName");
     },
     getAccountSecondName: function(){
       return this.ajaxCall(arguments,"getAccountSecondName");
     },
     getProductId: function(){
       return this.ajaxCall(arguments,"getProductId");
     },
     getSpaceMenus: function(){
                  return this.ajaxCall(arguments,"getSpaceMenus");
     },
     getSpaceOwnerMenus: function(){
                  return this.ajaxCall(arguments,"getSpaceOwnerMenus");
     },
     getSpaceSort: function(){
                  return this.ajaxCall(arguments,"getSpaceSort");
     },
     getSpaceMenusForPortal: function(){
                  return this.ajaxCall(arguments,"getSpaceMenusForPortal");
     },
     getMenusOfMember: function(){
         return this.ajaxCall(arguments,"getMenusOfMember");
	 },
	 isExceedMaxLoginNumberServerInAccount: function(){
         return this.ajaxCall(arguments,"isExceedMaxLoginNumberServerInAccount");
	 },
	 setCurrentUserCustomize: function(){
         return this.ajaxCall(arguments,"setCurrentUserCustomize");
	 },
	 getGroupAndAccountNameInfo: function(){
         return this.ajaxCall(arguments,"getGroupAndAccountNameInfo");
   }
});
var selectPeopleManager=RemoteJsonService.extend({
     jsonGateway: "/seeyon/ajax.do?method=ajaxAction&managerName=selectPeopleManager",
     getOrgModel: function(){
                  return this.ajaxCall(arguments,"getOrgModel");
     },
     getQueryOrgModel: function(){
                  return this.ajaxCall(arguments,"getQueryOrgModel");
     },
     saveAsTeam: function(){
                  return this.ajaxCall(arguments,"saveAsTeam");
     }
});
var calEventManager=RemoteJsonService.extend({
     jsonGateway: "/seeyon/ajax.do?method=ajaxAction&managerName=calEventManager",
     getCalEventById: function(){
                  return this.ajaxCall(arguments,"getCalEventById");
     },
     isOnePerson:function(){
    	 return this.ajaxCall(arguments,"isOnePerson");
     },isHasDeleteByType:function(){
       return this.ajaxCall(arguments,"isHasDeleteByType");
     },isReceiveMember:function(){
       return this.ajaxCall(arguments,"isReceiveMember");
     }
});

var upgradeManager=RemoteJsonService.extend({
    jsonGateway: "/seeyon/ajax.do?method=ajaxAction&managerName=upgradeManager",
    upgrade:function(){
      return this.ajaxCall(arguments,"upgrade");
    }
});

var timeLineManager=RemoteJsonService.extend({
  jsonGateway: "/seeyon/ajax.do?method=ajaxAction&managerName=timeLineManager",
  getTimeLineResetDate: function(){
    return this.ajaxCall(arguments,"getTimeLineResetDate");
  }
});
var onlineManager = RemoteJsonService.extend({
	jsonGateway: "/seeyon/ajax.do?method=ajaxAction&managerName=onlineManager",
	updateOnlineSubState: function() {
		return this.ajaxCall(arguments, "updateOnlineSubState");
	}
});
var portalTemplateManager = RemoteJsonService.extend({
  jsonGateway: "/seeyon/ajax.do?method=ajaxAction&managerName=portalTemplateManager",
  transReSetToDefault : function(){
               return this.ajaxCall(arguments,"transReSetToDefault");
  },
  transSaveHotSpots : function(){
    return this.ajaxCall(arguments,"transSaveHotSpots");
  },
  transAllowHotSpotChoose : function(){
    return this.ajaxCall(arguments,"transAllowHotSpotChoose");
  },
  transAllowHotSpotCustomize : function(){
    return this.ajaxCall(arguments,"transAllowHotSpotCustomize");
  },
  getSkinDatas : function(){
    return this.ajaxCall(arguments,"getSkinDatas");
  },
  getAllowSkinStyleChoose : function(){
    return this.ajaxCall(arguments,"getAllowSkinStyleChoose");
  },
  getAllowHotSpotCustomize : function(){
    return this.ajaxCall(arguments,"getAllowHotSpotCustomize");
  },
  transSwitchSkinStyle : function(){
    return this.ajaxCall(arguments,"transSwitchSkinStyle");
  },
  getCurrentPortalTemplateAndHotSpots : function(){
	return this.ajaxCall(arguments,"getCurrentPortalTemplateAndHotSpots");
  },
  transSwitchPortalTemplate : function(){
	return this.ajaxCall(arguments,"transSwitchPortalTemplate");
  },
  getAllowPortalTemplateChoose : function(){
	return this.ajaxCall(arguments,"getAllowPortalTemplateChoose");
  },
  getHotSpotsByTemplateId : function(){
	return this.ajaxCall(arguments,"getHotSpotsByTemplateId");
  }
});
var portalTemplateManagerObject = new portalTemplateManager();