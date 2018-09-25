/*----------------------------------------------------------------------------\
|                               XLoadTree 1.11                                |
|-----------------------------------------------------------------------------|
|                         Created by Erik Arvidsson                           |
|                  (http://webfx.eae.net/contact.html#erik)                   |
|                      For WebFX (http://webfx.eae.net/)                      |
|-----------------------------------------------------------------------------|
| An extension to xTree that allows sub trees to be loaded at runtime by      |
| reading XML files from the server. Works with IE5+ and Mozilla 1.0+         |
|-----------------------------------------------------------------------------|
|             Copyright (c) 2001, 2002, 2003, 2006 Erik Arvidsson             |
|-----------------------------------------------------------------------------|
| Licensed under the Apache License, Version 2.0 (the "License"); you may not |
| use this file except in compliance with the License.  You may obtain a copy |
| of the License at http://www.apache.org/licenses/LICENSE-2.0                |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| Unless  required  by  applicable law or  agreed  to  in  writing,  software |
| distributed under the License is distributed on an  "AS IS" BASIS,  WITHOUT |
| WARRANTIES OR  CONDITIONS OF ANY KIND,  either express or implied.  See the |
| License  for the  specific language  governing permissions  and limitations |
| under the License.                                                          |
|-----------------------------------------------------------------------------|
| Dependencies: xtree.js     - original xtree library                         |
|               xtree.css    - simple css styling of xtree                    |
|               xmlextras.js - provides xml http objects and xml document     |
|                              objects                                        |
|-----------------------------------------------------------------------------|
| 2001-09-27 | Original Version Posted.                                       |
| 2002-01-19 | Added some simple error handling and string templates for      |
|            | reporting the errors.                                          |
| 2002-01-28 | Fixed loading issues in IE50 and IE55 that made the tree load  |
|            | twice.                                                         |
| 2002-10-10 | (1.1) Added reload method that reloads the XML file from the   |
|            | server.                                                        |
| 2003-05-06 | Added support for target attribute                             |
| 2006-05-28 | Changed license to Apache Software License 2.0.                |
|-----------------------------------------------------------------------------|
| Created 2001-09-27 | All changes are in the log above. | Updated 2006-05-28 |
\----------------------------------------------------------------------------*/

/** // XP Look
webFXTreeConfig.rootIcon = "<c:url value='/apps_res/doc/images/docIcon/achive.gif'/>";
webFXTreeConfig.openRootIcon = "<c:url value='/apps_res/doc/images/docIcon/achive.gif'/>";
webFXTreeConfig.folderIcon = "<c:url value='/apps_res/doc/images/xp/folder.png'/>";
webFXTreeConfig.openFolderIcon = "<c:url value='/apps_res/doc/images/xp/openfolder.png'/>";
webFXTreeConfig.fileIcon = "<c:url value='/apps_res/doc/images/xp/openfolder.png'/>";
webFXTreeConfig.lMinusIcon = "<c:url value='/apps_res/doc/images/xp/Lminus.png'/>";
webFXTreeConfig.lPlusIcon = "<c:url value='/apps_res/doc/images/xp/Lplus.png'/>";
webFXTreeConfig.tMinusIcon = "<c:url value='/apps_res/doc/images/xp/Tminus.png'/>";
webFXTreeConfig.tPlusIcon = "<c:url value='/apps_res/doc/images/xp/Tplus.png'/>";
webFXTreeConfig.iIcon = "<c:url value='/apps_res/doc/images/xp/I.png'/>";
webFXTreeConfig.lIcon = "<c:url value='/apps_res/doc/images/xp/L.png'/>";
webFXTreeConfig.tIcon = "<c:url value='/apps_res/doc/images/xp/T.png'/>";
webFXTreeConfig.blankIcon = "<c:url value='/apps_res/doc/images/blank.png'/>";
*/
//var tree = new WebFXLoadTree("WebFXLoadTree", "tree1.xml");
//tree.setBehavior("classic");

webFXTreeConfig.loadingText = "Loading...";
webFXTreeConfig.loadErrorTextTemplate = "";//"Error loading \"%1%\"";
webFXTreeConfig.emptyErrorTextTemplate = "";//"Error \"%1%\" does not contain any tree items";

/**
 * update by xuegw
 * 
 */
 
var bUseRefreshArgument = true;	

function showSrcAndAction(resId,frType,docLibId,docLibType,isShareAndBorrowRoot,all,edit,add,readonly,browse,list,v,projectTypeId) {
	if(docLibType == 1){
			var exUrl = "&resId=" + resId + "&frType=" + frType + "&docLibId=" + docLibId 
						+ "&docLibType=" + docLibType + "&isShareAndBorrowRoot=" + isShareAndBorrowRoot
						+ "&all=" + all + "&edit=" + edit + "&add=" + add + "&readonly=" + readonly 
						+ "&browse=" + browse + "&list=" + list;
	}else{		
	    var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocAclManager","getAclStringAndV", false);
		requestCaller.addParameter(1, "Long",resId);
		requestCaller.addParameter(2, "Long",frType);
		requestCaller.addParameter(3, "String",docLibId);
		requestCaller.addParameter(4, "String",docLibType);
		requestCaller.addParameter(5, "String",isShareAndBorrowRoot);
		var result = requestCaller.serviceRequest();
		var _start = result.indexOf('&v=');
		var _length = result.length;
		flag = result.substring(0,_start);
		v = result.substring(_start+3,_length);
		if(frType=="40"){	
			isShareAndBorrowRoot = false;
			flag ="all=true&edit=true&add=true&readonly=false&browse=false&list=true"
		}
		
   	    if(frType=="110"||frType=="111"){
			isShareAndBorrowRoot = false;
		}
   	    
   	    var exUrl = "&resId=" + resId + "&frType=" + frType + "&docLibId=" + docLibId 
					+ "&docLibType=" + docLibType + "&isShareAndBorrowRoot=" + isShareAndBorrowRoot+ "&" + flag;
	}
	
	if(typeof(projectTypeId)=='undefined'){
		projectTypeId = '';
	}
	
	var url = jsURL + "?method=rightNew" + exUrl+ "&v=" + v+"&projectTypeId="+projectTypeId;
	//var cols = parent.document.getElementById("layout").cols;
	parent.rightFrame.location.href = url;
	//parent.document.getElementById("layout").cols = cols;
}


function showSrcAndAction4Quote(resId, frType, docLibId, docLibType,
		isShareAndBorrowRoot, all, edit, add, readonly, browse, projectId,list,referenceId) {
	if(typeof(referenceId) == "undefined"){
		referenceId = "";
	}
	if (parent.listFrame) {
		var exUrl = "&resId=" + resId + "&frType=" + frType + "&docLibId="
				+ docLibId + "&docLibType=" + docLibType
				+ "&isShareAndBorrowRoot=" + isShareAndBorrowRoot + "&all="
				+ all + "&edit=" + edit + "&add=" + add + "&readonly="
				+ readonly + "&browse=" + browse + "&list=" + list + "&referenceId="
				+referenceId+"&projectTypeId="+projectId;

		//分保  关联文档时需要传递涉密信息密级---Start
		var secretLevel = document.getElementById("secretLevel");
		if(secretLevel){
			exUrl = exUrl+"&secretLevel="+secretLevel.value;
		}
		//分保  关联文档时需要传递涉密信息密级---End
		var url = jsURL + "?method=listDocs4Quote" + exUrl + "&isQuote=true" + (paramFrom ? "&from=" + paramFrom : "");
		parent.listFrame.location.href = url;
	}
}

/*
 * WebFXLoadTree class
 */
function WebFXLoadTree(sBusinessId, sText, sXmlSrc, sAction, sBehavior, sIcon, sOpenIcon) {
	// call super
	this.WebFXTree = WebFXTree;
	this.WebFXTree(sBusinessId, sText, sAction, sBehavior, sIcon, sOpenIcon);

	// setup default property values
	this.src = sXmlSrc;
	this.loading = false;
	this.loaded = false;
	this.errorText = "";
	
	// check start state and load if open
	if (this.open)
		_startLoadXmlTree(this.src, this);
	else {
		// and create loading item if not
		this._loadingItem = new WebFXTreeItem("", webFXTreeConfig.loadingText);
		this.add(this._loadingItem);
	}
}

WebFXLoadTree.prototype = new WebFXTree;

// override the expand method to load the xml file
WebFXLoadTree.prototype._webfxtree_expand = WebFXTree.prototype.expand;
WebFXLoadTree.prototype.expand = function() {
	if (!this.loaded && !this.loading) {
		// load
		_startLoadXmlTree(this.src, this);
	}
	this._webfxtree_expand();
};

/*
 * WebFXLoadTreeItem class
 */

function WebFXLoadTreeItem(sBusinessId, sText, sXmlSrc, sAction, sDblClick, eParent, sIcon, sOpenIcon) {
	// call super
	this.WebFXTreeItem = WebFXTreeItem;
	this.WebFXTreeItem(sBusinessId, sText, sAction, sDblClick, eParent, sIcon, sOpenIcon);

	// setup default property values
	this.src = sXmlSrc;
	this.loading = false;
	this.loaded = false;
	this.errorText = "";
	this.showName = sText;
	
	// check start state and load if open
	
	if (this.open)
			_startLoadXmlTree(this.src, this);
	else {
		// and create loading item if not
		this._loadingItem = new WebFXTreeItem("", webFXTreeConfig.loadingText);
		this.add(this._loadingItem);
	}
}


WebFXTreeAbstractNode.prototype.addWebFXTreeItem = function(sBusinessId, sText, sXmlSrc, sAction, sDBlClick, eParent, sIcon, sOpenIcon){
	var item = new WebFXLoadTreeItem(sBusinessId, sText, sXmlSrc, sAction, sDBlClick, eParent, sIcon, sOpenIcon);
	this.add(item);
	this.doExpand();
	
	return item;
}

WebFXLoadTreeItem.prototype = new WebFXTreeItem;

// override the expand method to load the xml file
WebFXLoadTreeItem.prototype._webfxtreeitem_expand = WebFXTreeItem.prototype.expand;
WebFXLoadTreeItem.prototype.expand = function() {
	
	if (!this.loaded && !this.loading) {
		// load
		
		_startLoadXmlTree(this.src, this);
	}
	
	this._webfxtreeitem_expand();
};

// reloads the src file if already loaded
WebFXLoadTree.prototype.reload =
WebFXLoadTreeItem.prototype.reload = function () {
	// if loading do nothing
	if (this.loaded) {
		var open = this.open;
		// remove
		while (this.childNodes.length > 0)
			this.childNodes[this.childNodes.length - 1].remove();

		this.loaded = false;

		this._loadingItem = new WebFXTreeItem("", webFXTreeConfig.loadingText);
		this.add(this._loadingItem);

		if (open)
			this.expand();
	}
	else if (this.open && !this.loading)
		_startLoadXmlTree(this.src, this);
};

/*
 * Helper functions
 */

// creates the xmlhttp object and starts the load of the xml document
function _startLoadXmlTree(sSrc, jsNode) {
	if (jsNode.loading || jsNode.loaded)
		return;
	jsNode.loading = true;
	var xmlHttp = XmlHttp.create();
	
//	var startsrc = srcURL + sSrc;
	xmlHttp.open("GET", sSrc + (bUseRefreshArgument==true?((sSrc.indexOf("?")>=0?"&":"?") + "ajaxRefreshTime=" + (new Date()).toTimeString()):""), true);	// async
	xmlHttp.onreadystatechange = function () {
		if (xmlHttp.readyState == 4) {
			
			_xmlFileLoaded(xmlHttp.responseXML, jsNode);
		}
	};
	// call in new thread to allow ui to update
	window.setTimeout(function () {
		xmlHttp.send(null);
		}, 10);
}


// Converts an xml tree to a js tree. See article about xml tree format
function _xmlTreeToJsTree(oNode) {
	
	// retreive attributes
	var businessId = oNode.getAttribute("businessId");
	var text = oNode.getAttribute("text");
	var action = oNode.getAttribute("action");
	
	var parent = null;
	var icon = treeImgURL + oNode.getAttribute("icon");
	var openIcon = treeImgURL + oNode.getAttribute("openIcon");
	
	var src = oNode.getAttribute("src");
	
	var target = oNode.getAttribute("target");
	// create jsNode
	var jsNode;
	if (src != null && src != "")
		jsNode = new WebFXLoadTreeItem(businessId, text, src, action, null, parent, icon, openIcon);
	else
		jsNode = new WebFXTreeItem(businessId, text, action, null, parent, icon, openIcon);

	if (target != "")
		jsNode.target = target;

	// go through childNOdes
	var cs = oNode.childNodes;
	var l = cs.length;
	for (var i = 0; i < l; i++) {
		if (cs[i].tagName == "tree")
			jsNode.add( _xmlTreeToJsTree(cs[i]), true );
	}
	
	return jsNode;
}

// Inserts an xml document as a subtree to the provided node
function _xmlFileLoaded(oXmlDoc, jsParentNode) {
	if (jsParentNode.loaded)
		return;

	var bIndent = false;
	var bAnyChildren = false;
	jsParentNode.loaded = true;
	jsParentNode.loading = false;
	objXMLHttp=getHTTPObject();
	// check that the load of the xml file went well
	
	
	if( oXmlDoc == null || oXmlDoc.documentElement == null) {
		//alert(oXmlDoc.xml);
		jsParentNode.errorText = parseTemplateString(webFXTreeConfig.loadErrorTextTemplate,
							jsParentNode.src);
	}
	else {
		// there is one extra level of tree elements
		var root = oXmlDoc.documentElement;
		
		// loop through all tree children
		var cs = root.childNodes;
		
		var l = cs.length;
		for (var i = 0; i < l; i++) {
			if(cs[i].nodeType==1){
				if(cs[i].tagName == undefined){
					alert(v3x.getMessage('DocLang.doc_alert_source_deleted_folder'));
//					alert("loc:" + window.dialogArguments)
					if(window.dialogArguments){
						window.location.href = window.location.href;
					}else{
						window.parent.location.reload(true);
					}
				}
				if (cs[i].tagName == "tree") {
					bAnyChildren = true;
					bIndent = true;
					jsParentNode.add( _xmlTreeToJsTree(cs[i]), true);
				}
			}
		}

		// if no children we got an error
		if (!bAnyChildren)
			jsParentNode.errorText = parseTemplateString(webFXTreeConfig.emptyErrorTextTemplate,
										jsParentNode.src);
	}

	// remove dummy
	if (jsParentNode._loadingItem != null) {
		jsParentNode._loadingItem.remove();
		bIndent = true;
	}

	if (bIndent) {
		// indent now that all items are added
		jsParentNode.indent();
	}

	// show error in status bar
	if (jsParentNode.errorText != "")
		window.status = jsParentNode.errorText;
}

// parses a string and replaces %n% with argument nr n
function parseTemplateString(sTemplate) {
	var args = arguments;
	var s = sTemplate;

	s = s.replace(/\%\%/g, "%");

	for (var i = 1; i < args.length; i++)
		s = s.replace( new RegExp("\%" + i + "\%", "g"), args[i] )

	return s;
}