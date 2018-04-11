if(window.dialogArguments){
    var desc = window.dialogArguments;
    if(desc!=null && ""!=desc && "null"!=desc){
	    desc = desc.replace(/<br>/gi, "\r\n").replace(/&nbsp;/g, "\\s");
	    $("#content").val(desc);
    }
}