/**
* a Map like Java HashMap
*/
function SimpleMap() {
	this.length = 0;
	this.entrys = new Object();
}
SimpleMap.prototype = {
	containsKey: function(k) {
		return (k in this.entrys);
	},
	put: function(k, v) {
		if (!this.containsKey(k))
			this.length++;
		this.entrys[k] = v;
	},
	get: function(k) {
		return this.containsKey(k) ? this.entrys[k] : null;
	},
	remove: function(k) {
		if (this.containsKey(k) && (delete this.entrys[k]))
			this.length--;
	},
	size: function() {
		return this.length;
	},
	clear: function() {
		this.length = 0;
		this.entrys = new Object();
	}
};

