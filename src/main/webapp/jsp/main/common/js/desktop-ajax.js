var deskManager=RemoteJsonService.extend({
jsonGateway:"/seeyon/ajax.do?method=ajaxAction&managerName=deskManager",
     addPortletToLayout: function(){
                  return this.ajaxCall(arguments,"addPortletToLayout");
},
     deleteDeskCate: function(){
                  return this.ajaxCall(arguments,"deleteDeskCate");
},
     deletePortlet: function(){
                  return this.ajaxCall(arguments,"deletePortlet");
},
     getAllPortlets: function(){
                  return this.ajaxCall(arguments,"getAllPortlets");
},
     getCategoryList: function(){
                  return this.ajaxCall(arguments,"getCategoryList");
},
     getCategoryPortlets: function(){
                  return this.ajaxCall(arguments,"getCategoryPortlets");
},
     getDeskCate: function(){
                  return this.ajaxCall(arguments,"getDeskCate");
},
     getDeskCateLayoutPortlets: function(){
                  return this.ajaxCall(arguments,"getDeskCateLayoutPortlets");
},
     getDeskCateLayouts: function(){
                  return this.ajaxCall(arguments,"getDeskCateLayouts");
},
     getDeskData: function(){
                  return this.ajaxCall(arguments,"getDeskData");
},
     getTargetClass: function(){
                  return this.ajaxCall(arguments,"getTargetClass");
},
     isPreFiltered: function(){
                  return this.ajaxCall(arguments,"isPreFiltered");
},
     saveDeskCate: function(){
                  return this.ajaxCall(arguments,"saveDeskCate");
},
     saveDeskLayout: function(){
                  return this.ajaxCall(arguments,"saveDeskLayout");
},
     savePortletSort: function(){
                  return this.ajaxCall(arguments,"savePortletSort");
},
     setPreFiltered: function(){
                  return this.ajaxCall(arguments,"setPreFiltered");
}
});
var portletManager=RemoteJsonService.extend({
jsonGateway:"/seeyon/ajax.do?method=ajaxAction&managerName=portletManager",
     getData: function(){
                  return this.ajaxCall(arguments,"getData");
},
     getDataCount: function(){
                  return this.ajaxCall(arguments,"getDataCount");
},
     getPendingData: function(){
                  return this.ajaxCall(arguments,"getPendingData");
},
     getCollaboration: function(){
                  return this.ajaxCall(arguments,"getCollaboration");
},
     finishWorkitemQuick: function(){
                  return this.ajaxCall(arguments,"finishWorkitemQuick");
},
     getTargetClass: function(){
                  return this.ajaxCall(arguments,"getTargetClass");
},
     isPreFiltered: function(){
                  return this.ajaxCall(arguments,"isPreFiltered");
},
     setPreFiltered: function(){
                  return this.ajaxCall(arguments,"setPreFiltered");
}
});
var deskCollaborationManager=RemoteJsonService.extend({
	jsonGateway:"/seeyon/ajax.do?method=ajaxAction&managerName=deskCollaborationManager",
	     finishWorkitemQuick: function(){
	                  return this.ajaxCall(arguments,"finishWorkitemQuick");
	},
	     getCollaborationList: function(){
	                  return this.ajaxCall(arguments,"getCollaborationList");
	},
	     getTargetClass: function(){
	                  return this.ajaxCall(arguments,"getTargetClass");
	},
	     isPreFiltered: function(){
	                  return this.ajaxCall(arguments,"isPreFiltered");
	},
	     setPreFiltered: function(){
	                  return this.ajaxCall(arguments,"setPreFiltered");
	}
});
var colManager=RemoteJsonService.extend({
  jsonGateway:"/seeyon/ajax.do?method=ajaxAction&managerName=colManager",
       checkAffairValid: function(){
                    return this.ajaxCall(arguments,"checkAffairValid");
  },
       getTargetClass: function(){
                    return this.ajaxCall(arguments,"getTargetClass");
  },
       isPreFiltered: function(){
                    return this.ajaxCall(arguments,"isPreFiltered");
  },
       setPreFiltered: function(){
                    return this.ajaxCall(arguments,"setPreFiltered");
  }
});

