// 截取字符串 包含中文处理
// (串,长度,增加...)
function cutString(str, len, hasDot) {
  var newLength = 0;
  var newStr = "";
  var chineseRegex = /[^\x00-\xff]/g;
  var singleChar = "";
  var strLength = str.replace(chineseRegex, "**").length;
  for (var i = 0; i < strLength; i++) {
    singleChar = str.charAt(i).toString();
    if (singleChar.match(chineseRegex) != null) {
      newLength += 2;
    } else {
      newLength++;
    }
    if (newLength > len) {
      break;
    }
    newStr += singleChar;
  }

  if (hasDot && strLength > len) {
    newStr += "...";
  }
  return newStr;
}

/**
 * 获得字符串实际长度，中文2，英文1
 * @param str 要获得长度的字符串
 * @returns {Number}
 */
function getStrLeng(str) {
  var realLength = 0;
  var len = str.length;
  var charCode = -1;
  for (var i = 0; i < len; i++) {
    charCode = str.charCodeAt(i);
    if (charCode >= 0 && charCode <= 128) {
      realLength += 1;
    } else {
      // 如果是中文则长度加2
      realLength += 2;
    }
  }
  return realLength;
}

/**
 * 限制输入字数
 * @param inputObj 输入对象
 * @param num 输入长度
 */
function restrictionInputNumber(inputObj, num) {
  $("#" + inputObj).keypress(function(event) {
    if (getStrLeng($("#" + inputObj).val()) >= num) {
      event.preventDefault();
    }
  });
  $("#" + inputObj).blur(function() {
      if(getStrLeng($("#" + inputObj).val()) >= num){
        $("#" + inputObj).val(cutString($("#" + inputObj).val(), num));
      }
  });
}