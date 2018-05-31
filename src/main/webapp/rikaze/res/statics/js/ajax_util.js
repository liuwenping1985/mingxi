var ___getJSONCache = {}
function getToken(){
    var access_token = $.getCookie('access_token');
    var mac_key = $.getCookie('mac_key');
    return {
        access_token:access_token,
        mac_key:mac_key
    }
}
$.extend($, {
  randomCode: function () {
    code = ''
    var codeLength = 8 // 验证码的长度
    var chars = new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z') // 所有候选组成验证码的字符，当然也可以用中文的

    for (var i = 0; i < codeLength; i++) {
      var charIndex = Math.floor(Math.random() * 36)
      code += chars[charIndex]
    }
    return code
  },
  getAuthHeader: function (host, url, method) {
    var access_token = getToken()['access_token']
    var mac_key = getToken()['mac_key'];

    if (!access_token || !mac_key) {
      return
    }

    var strAuth = 'MAC id="' + access_token + '",nonce="'
    var nonce = new Date().getTime() + ':' + $.randomCode()
    strAuth += nonce + '",mac="'
    var request_content = nonce + '\n' + method.toUpperCase() + '\n' + url + '\n' + host + '\n'
    // console.log(request_content);
    var hash = CryptoJS.HmacSHA256(request_content, mac_key)
    var mac = hash.toString(CryptoJS.enc.Base64)
    strAuth += mac + '"'
    return strAuth
  },
  getMac:function(url,method){
    var matched = url.match(/^(https?:\/\/)([^/]+)(.+)$/)
    if (!matched) {
      return ''
    }
    var getMac = function (nonce, method, url, host, key) {
      var sha = new jsSHA('SHA-256', 'TEXT')
      sha.setHMACKey(key, 'TEXT')
      sha.update([nonce, method, url, host, ''].join('\n'))
      return sha.getHMAC('B64')
    }
    function getNonce (diff) {
      function rnd (min, max) {
        const arr = [
          '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
          'a', 'b', 'c', 'd', 'e', 'f', 'g',
          'h', 'i', 'j', 'k', 'l', 'm', 'n',
          'o', 'p', 'q', 'r', 's', 't',
          'u', 'v', 'w', 'x', 'y', 'z',
          'A', 'B', 'C', 'D', 'E', 'F', 'G',
          'H', 'I', 'J', 'K', 'L', 'M', 'N',
          'O', 'P', 'Q', 'R', 'S', 'T',
          'U', 'V', 'W', 'X', 'Y', 'Z'
        ]

        var range = max ? max - min : min
        var str = ''
        var i
        var length = arr.length - 1

        for (i = 0; i < range; i++) {
          str += arr[Math.round(Math.random() * length)]
        }
        return str
      }
      return Date.now() + (diff || 0) + ':' + rnd(8)
    }
    var host = matched[2];
    var uri = matched[3];
    var nonce = getNonce();
    var auth =  ['MAC id="' + getToken()['access_token'] + '"',
      'nonce="' + nonce + '"',
      'mac="' + getMac(nonce, method, uri, host, getToken()['mac_key']) + '"'
    ].join(',');
    return auth;

  }
  ,
  ajaxJSON: function (method, url, data, success, failure, settings) {
    var dfd = $.Deferred()
    if (jQuery.isFunction(data)) {
      settings = failure
      failure = success
      success = data
      data = undefined
    }
    if (method != 'GET') {
      data = JSON.stringify(data)
    }
    // if(location.hostname == "localhost"){
    // }
    jQuery.ajax($.extend({
      type: method,
      url: url,
      data: data,
      dataType: 'json',
      beforeSend: function (request) {

          var matched = url.match(/^(https?:\/\/)([^/]+)(.+)$/)
          if (!matched) {
              return ''
          }
        if(settings&&settings.guest_api){
          return
        }
          var getMac = function (nonce, method, url, host, key) {

              var sha = new jsSHA('SHA-256', 'TEXT')
              sha.setHMACKey(key, 'TEXT')
              sha.update([nonce, method, url, host, ''].join('\n'))
              return sha.getHMAC('B64')
          }
           function getNonce (diff) {
              function rnd (min, max) {
                  const arr = [
                      '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                      'a', 'b', 'c', 'd', 'e', 'f', 'g',
                      'h', 'i', 'j', 'k', 'l', 'm', 'n',
                      'o', 'p', 'q', 'r', 's', 't',
                      'u', 'v', 'w', 'x', 'y', 'z',
                      'A', 'B', 'C', 'D', 'E', 'F', 'G',
                      'H', 'I', 'J', 'K', 'L', 'M', 'N',
                      'O', 'P', 'Q', 'R', 'S', 'T',
                      'U', 'V', 'W', 'X', 'Y', 'Z'
                  ]

                  var range = max ? max - min : min
                  var str = ''
                  var i
                  var length = arr.length - 1

                  for (i = 0; i < range; i++) {
                      str += arr[Math.round(Math.random() * length)]
                  }
                  return str
              }
              return Date.now() + (diff || 0) + ':' + rnd(8)
          }
          var host = matched[2];
          var uri = matched[3];
          var nonce = getNonce();

          var auth =  ['MAC id="' + getToken()['access_token'] + '"',
              'nonce="' + nonce + '"',
              'mac="' + getMac(nonce, method, uri, host, getToken()['mac_key']) + '"'
          ].join(',');

        if (auth) {
          request.setRequestHeader('Authorization', auth);
        }
      },
      contentType: 'application/json; charset=UTF-8',
      success: function (data) {
        success && success(data)
        dfd.resolve(data)
      },
      error: function (xhr) {
        var statusCode = xhr.status
        // 开启以下代码可自己跳转登录
        // if (statusCode === 401||statusCode === 403) {
        //	$.gotoLogin();
        //	return;
        // }
        var data = xhr.responseText
        try {
          data = $.parseJSON(data)
        } catch (e) {}
        failure
          ? failure(data, statusCode)
          : !data.message
            ? ''
            : $.messager
              ? $.messager.alert('', data.message)
              : alert(data.message)
        dfd.reject(data, statusCode)
      }
    }, settings || {}))
    return dfd.promise()
  },
  postJSON: function (url, data, success, failure, settings) {
    return $.ajaxJSON('POST', url, data, success, failure, settings)
  },
  getJSON: function (url, data, success, failure, settings) {
    return $.ajaxJSON('GET', url, data, success, failure, settings)
  },
  putJSON: function (url, data, success, failure, settings) {
    return $.ajaxJSON('PUT', url, data, success, failure, settings)
  },
  deleteJSON: function (url, data, success, failure, settings) {
    return $.ajaxJSON('DELETE', url, data, success, failure, settings)
  },
  initEvent: function (e) {
    // firefox 下 绑定 srcElement=target
    // 简写srcElement
    if (e.target) {
      e.srcElement = e.target
    }
    if (e.which) {
      e.keyCode = e.which
    }
    e.src = e.srcElement
  },
  stringFormat: function (str) {
    for (var i = 0; i < arguments.length - 1; i++) {
      str = str.replace('{' + i + '}', arguments[i + 1])
    }
    return str
  },
  getDateString: function (str) {
    if (str) {
      var date = new Date(parseInt(str.substr(6)))
      var str = date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate()
    } else {
      var date = new Date()
      var str = date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate()
    }
    return str
  },
  getDateObj: function (str) {
    return new Date(parseInt(str.substr(6)))
  },
  getFormValues: function ($form) {
    values = {}
    $folunchOrder.find(':input').each(function (index, elm) {
      if (elm.name && elm.name.indexOf('__') < 0) {
        values[elm.name] = $(elm).val()
      }
    })
    return values
  },
  getUrl: function () {
    return location.href.split('?')[0]
  },
  getUrlParams: function () {
    var vars = [],
      hash
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&')
    for (var i = 0; i < hashes.length; i++) {
      hash = hashes[i].split('=')
      vars.push(hash[0])
      vars[hash[0]] = hash[1]
    }
    return vars
  },
  getUrlParam: function (name) {
    return $.getUrlParams()[name]
  },
  getUrlAnchors: function () {
    var vars = [],
      hash
    var hashes = window.location.href.slice(window.location.href.indexOf('#') + 1).split('&')
    for (var i = 0; i < hashes.length; i++) {
      hash = hashes[i].split('=')
      vars.push(hash[0])
      vars[hash[0]] = hash[1]
    }
    return vars
  },
  getUrlAnchor: function (name) {
    return $.getUrlAnchors()[name]
  },
  removeFromArray: function (array, removeItem) {
    return jQuery.grep(array, function (value) {
      return value != removeItem
    })
  },
  uniqueArray: function (array) {
    var ret = [],
      done = {}
    try {
      for (var i = 0, length = array.length; i < length; i++) {
        var tmp = array[i] // jQuery native code : var id =
        // jQuery.data(array[i]);
        if (!done[tmp]) {
          done[tmp] = true
          ret.push(tmp)
        }
      }
    } catch (e) {
      ret = array
    }
    return ret
  },
  // 写入cookies
  setCookie: function (name, value, expiresDays) {
    var Days = expiresDays || 30
    var d = new Date()
    var exp = new Date(d.getFullYear(), d.getMonth(), d.getDate())
    exp.setTime(exp.getTime() + Days * 24 * 60 * 60 * 1000)
    document.cookie = name + '=' + escape(value) + ';path=/;expires=' + exp.toGMTString()
  },
  // 读取cookies
  getCookie: function (name) {
    var arr,
      reg = new RegExp('(^| )' + name + '=([^;]*)(;|$)')
    if (arr = document.cookie.match(reg)) {
      return unescape(arr[2])
    } else {
      return null
    }
  },
  // 删除cookies
  delCookie: function (name) {
    var exp = new Date()
    exp.setTime(exp.getTime() - 1)
    var cval = this.getCookie(name)
    if (cval != null) {
      document.cookie = name + '=' + cval + ';expires=' + exp.toGMTString()
    }
  },
  getUUID: function () {
    //		var str = new Date();
    //		str = str.getTime();
    //		return str;
    var d = new Date().getTime()
    var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
      var r = (d + Math.random() * 16) % 16 | 0
      d = Math.floor(d / 16)
      return (c == 'x'
        ? r
        : (r & 0x7 | 0x8)).toString(16)
    })
    return uuid
  },
  urlEncode: function (str) {
    var ret = ''
    var strSpecial = "!\"#$%&'()*+,/:;<=>?[]^`{|}~%"
    for (var i = 0; i < str.length; i++) {
      var chr = str.charAt(i)
      var c = str2asc(chr)
      if (parseInt('0x' + c) > 0x7f) {
        ret += '%' + c.slice(0, 2) + '%' + c.slice(-2)
      } else {
        if (chr == ' ') {
          ret += '+'
        } else if (strSpecial.indexOf(chr) != -1) {
          ret += '%' + c.toString(16)
        } else {
          ret += chr
        }
      }
    }
    return ret
  },
  urlDecode: function (zipStr) {
    var uzipStr = ''
    function _asciiToString (asccode) {
      return String.fromCharCode(asccode)
    }
    for (var i = 0; i < zipStr.length; i++) {
      var chr = zipStr.charAt(i)
      if (chr == '+') {
        uzipStr += ' '
      } else if (chr == '%') {
        var asc = zipStr.substring(i + 1, i + 3)
        if (parseInt('0x' + asc) > 0x7f) {
          uzipStr += decodeURI('%' + asc.toString() + zipStr.substring(i + 3, i + 9).toString())
          i += 8
        } else {
          uzipStr += _asciiToString(parseInt('0x' + asc))
          i += 2
        }
      } else {
        uzipStr += chr
      }
    }

    return uzipStr
  },
  returnBack: function (defaultUrl) {
    //		console.info(document.referrer);
    //		console.info($.urlDecode($.getUrlParam('returnUrl') || defaultUrl || document.referrer || '/'));
    location.href = $.urlDecode($.getUrlParam('returnUrl') || defaultUrl || document.referrer || '/')
  },
  gotoLogin: function () {
    window.top.location.href = '../user/login.html?returnUrl=' + $.urlDecode(window.top.location.href || document.referrer || '/')
  },
  debug: function (message) {
    var dev = (location.hostname == '127.0.0.1' || location.hostname == '0.0.0.0' || location.hostname == 'localhost' || location.port.length > 0)
    dev && typeof console !== 'undefined' && console.log(message)
  }

})

if (!Object.keys) {
  Object.keys = function (obj) {
    return $.map(obj, function (v, k) {
      return k
    })
  }
}

(function ($) {
  $.fn.findParent = function (expr) {
    var parents = this.parentsUntil(expr)
    return $(parents[parents.length - 1]).parent()
  }
  // var originalValFunc = $.fn.val;
  // $.fn.val = function(value){
  // if(!arguments.length){
  //	return originalValFunc.call(this);
  // }else{
  //	originalValFunc.call(this, value);
  //	this.trigger('valueBound');
  // }
  // };
})(jQuery)
