
function openNewTimecard(subject, _url) {
    _url = detailURL + _url;
    var rv = v3x.openWindow({
        url: _url,
        workSpace: 'yes'
    });

    if (rv == "true") {
    	getA8Top().reFlesh();
    }
}