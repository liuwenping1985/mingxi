/**
 * @Author Lion Shooray 2007-7-24 iTruschina Co., Ltd.
 * @Modified 2010-12-24 ShiningWang
 * @Version 2.7
 */
// global const
var iePtaObject = "<object id='iTrusPTA' codebase='apps_res/ca/itruscertctl.cab#version=2,5,4,0' classid='clsid:1E0DFFCF-27FF-4574-849B-55007349FEDA'></object>";
var ffPtaObject = "<object id='iTrusPTA' type='application/PTA.iTrusPTA' style='display:none'></object>";





if(navigator.userAgent.indexOf("MSIE") > 0) {
	document.write(iePtaObject);
} else {
	var length = navigator.plugins.length
	var check_install_cenroll = 0;
	for(var i=0;i<length;i++){
		//alert(navigator.plugins[i].name);
		var index = (navigator.plugins[i].name).indexOf("iTrusPTA");
		if(index>-1){
			check_install_cenroll++;
			break;
		}
	}
	if(check_install_cenroll>0){
		 document.write(ffPtaObject);
	}else{
		 //window.location.href = "./showDownPTA.html";
	}

}

//for SignMessage method
var INPUT_BASE64		= 0x01
var INPUT_HEX			= 0x02
var OUTPUT_BASE64		= 0x04
var OUTPUT_HEX			= 0x08

var INNER_CONTENT 	= 0x10;
var PLAINTEXT_UTF8  = 0x20;
var MIN_CERTSTORE 	= 0x40;

//for VerifySignature method
var MSG_BASE64 	=  0x4;
var MSG_HEX 	=  0x8;

//for ExportPKCS12 method
var EXPORT_CHAIN	= 0x01; //TODO: 未实现
var EXPORT_DISABLE	= 0x02;
var EXPORT_DELETE	= 0x04;
//在IE浏览器中导出或删除时需要用户确认

//密钥用法
var KEY_USAGE_UNDEFINED			= 0x00
var KEY_USAGE_CRL_SIGN			= 0x02
var KEY_USAGE_CERT_SIGN			= 0x04
var KEY_USAGE_KEY_AGREEMENT		= 0x08
var KEY_USAGE_DATA_ENCIPHERMENT	=0x10
var KEY_USAGE_KEY_ENCIPHERMENT	= 0x20
var KEY_USAGE_NON_REPUDIATION	= 0x40
var KEY_USAGE_DIGITAL_SIGNATURE	=0x80




/**
 * class Names
 * @method getItem(name) return names' first value
 * @method getItems(name) return names' value sting array object
 */
function Names(distinguishName) {
	this.names = init(distinguishName);

	this.getItem = function(name) {
		var values = this.names.get(name);
		if (null == values) {
			return null;
		} else {
			return values[0];
		}
	}

	this.getItems = function(name) {
		return this.names.get(name);
	}

	function init(dn) {
		var _names = new Hashtable();
		var partition = ", ";

		var Items = dn.split(partition);
		var itemString = "";
		for (var i = Items.length - 1; i >= 0; i--) {
			if (itemString != "") {
				itemString = Items[i] + itemString;
			} else {
				itemString = Items[i];
			}

			var pos = itemString.indexOf("=");
			if (-1 == pos) {
				itemString = partition + itemString;
				continue;
			} else {
				var name = itemString.substring(0, pos);
				var value = itemString.substring(pos + 1, itemString.length);
				// wipe off the limitrophe quotation marks
				if (value.indexOf("\"") == 0 && (value.length - 1) == value.lastIndexOf("\"")) {
					value = value.substring(1, value.length);
					value = value.substring(0, value.length - 1);
				}

				if (_names.containsKey(name)) {
					var array = _names.get(name);

					array.push(value);
					_names.remove(name);
					_names.put(name, array);
				} else {
					var array = new Array();
					array.push(value);
					_names.put(name, array);
				}
				itemString = "";
			}
		}
		return _names;
	}
}

/**
 * JSDateAdd Javascript 计算给定日期+天数
 * @param theDate:
 *            给定日期，Date类型
 * @param days:
 *            整型
 * @return 计算结果，Date类型
 */
function JSDateAdd(theDate, days) {
	var dateValue = theDate.valueOf()
	dateValue += days * 1000 * 60 * 60 * 24;
	var newDate = new Date(dateValue);
	return newDate;
}
/**
 * JSDateDiffByDays Javascript 计算两个日期之间的间隔天数
 *
 * @param date1:
 *            给定日期1，Date类型
 * @param date2:
 *            给定日期2，Date类型
 * @return 天数，整型
 */
function JSDateDiffByDays(date1, date2) {
	var mill = date1.valueOf() - date2.valueOf();
	var millStr = new String(mill / 1000 / 60 / 60 / 24)
	return parseInt(millStr);
}

/**
 * exportPKCS12 导出软证书
 *
 * @param cert Certificate对象
 * @param password 导出证书文件的备份密码
 * @param opt 导出参数
 * opt = opt | EXPORT_DISABLE; //是否允许再导出？
 * opt = opt | EXPORT_DELETE; //导出成功后是否从系统删除原证书？
 * @return fileName 导出文件名，""或忽略，则会自动弹出文件选择对话框
 */
function exportPKCS12(cert, password, opt, fileName) {
	try {
		opt = typeof(opt) == "number" ? opt : 0; //缺省允许再导出，也不删除
		if (typeof(fileName) == "undefined")
			fileName = "";
		cert.ExportPKCS12(password, opt, fileName);
		return true;
	} catch(e) {
		if ((e.number == -2147483135) // cancel
		) {
			// User canceled
		} else if(e.number == -2146893813) {
			alert("证书“" + cert.CommonName + "”的安全策略限制导出私钥。");
		} else
			alert("PTA模块发生错误\r\n错误号: " + e.number + "\r\n错误描述: " + e.description);
		return false;
	}
}

/**
 * filterCerts 根据所设置条件过滤证书
 *
 * @param arrayIssuerDN(optional)
 *            Array() or string，缺省为""，证书的颁发者字符串和字符串数组，支持多个CA时使用字符串数组
 * @param dateFlag(optional)
 *            缺省为0，0表示所有证书，1表示处于有效期内的证书，2表示待更新证书，3表示未生效或已过期证书
 * @param serialNumber(optional)
 *            缺省为""，证书序列号（微软格式）
 * @return Array(), PTALib.Certificate
 */
function filterCerts(arrayIssuerDN, dateFlag, serialNumber) {
	var m_certs = new Array();
	var i = 0;
	if (typeof(arrayIssuerDN) == "undefined") {
		arrayIssuerDN = new Array("");
	} else if (typeof(arrayIssuerDN) == "string") {
		arrayIssuerDN = new Array(arrayIssuerDN);
	}
	if (typeof(serialNumber) == "undefined")
		serialNumber = "";
	for (i = 0; i < arrayIssuerDN.length; i++) {
		var CertFilter = iTrusPTA.Filter;
		CertFilter.Clear();
		CertFilter.Issuer = arrayIssuerDN[i];
		CertFilter.SerialNumber = serialNumber;
		var t_Certs = iTrusPTA.MyCertificates; // 临时变量
		var now = new Date();
		if (parseInt(t_Certs.Count) > 0) { // 找到了证书
			for (var j = 1; j <= parseInt(t_Certs.Count); j++) {
				var validFrom = new Date(t_Certs(j).validTo);
				var validTo = new Date(t_Certs(j).validTo);
				switch (dateFlag) {
					case 0 :// 所有证书
						m_certs.push(t_Certs(j));
						break;
					case 1 :// 处于有效期内的证书
						// validFrom validTo
						// now
						if (validFrom < now && now < validTo)
							m_certs.push(t_Certs(j));
						break;
					case 2 :// 待更新证书
						// validFrom validTo-30 validTo
						// now
						if (JSDateAdd(validTo, -30) < now && now < validTo)
							m_certs.push(t_Certs(j));
						break;
					case 3 :// 未生效或已过期证书
						// validFrom validTo
						// now now
						if (now < validFrom || validTo < now)
							m_certs.push(t_Certs(j));
						break;
					default :// 缺省当作所有证书处理
						m_certs.push(t_Certs(j));
						break;
				}
			}
		}
	}

	return m_certs;
}

/**
 * signLogonData 登陆签名
 *
 * @param certList
 *            证书列表<select>对象
 * @param inputToSign:
 *            用于签名登陆的被签名<input>对象
 * @return 成功返回签名值，失败返回""
 */
function signLogonData(signer, inputToSign) {
	try {
		var signedData;
		var ptaVersion = iTrusPTA.Version;
		if (ptaVersion == null) {
			// PTA Version = 1.0.0.3
			signedData = signer.SignMessage(inputToSign.value, OUTPUT_BASE64);
		} else {
			// PTA Version > 2
			if (inputToSign.value.indexOf("LOGONDATA:") == -1)
				inputToSign.value = "LOGONDATA:" + inputToSign.value;
			signedData = signer.SignLogonData(inputToSign.value, OUTPUT_BASE64);
		}
		return signedData;
	} catch (e) {
		if (-2147483135 == e.number) {
			// 用户取消签名
		} else if (e.number == -2146885621) {
			alert("您不拥有证书“" + CurCert.CommonName + "”的私钥，签名失败。");
			return "";
		} else {
			alert("PTA签名时发生错误\n错误号: " + e.number + "\n错误描述: " + e.description);
			return "";
		}
	}
}

/**
 * verifySignature 验证签名
 *
 * @param strToSign:
 *            原文
 * @param base64StrSignature:
 *            签名值
 * @return 成功: 返回签名证书对象，失败: 返回null
 */
function verifySignature(strToSign, base64StrSignature, opt) {
	if (strToSign == "" || base64StrSignature == "")
		return;
	try {
		opt = typeof(opt) == "number" ? opt | INPUT_BASE64 : INPUT_BASE64; //签名值强制采用Base64编码
		var signCert = iTrusPTA.VerifySignature(strToSign, base64StrSignature, opt);
		alert("签名验证成功。签名者为“" + signCert.CommonName + "”。");
		return true;
	} catch (e) {
		if (e.number == -2146893818)
			alert("签名验证失败。\r\n签名值与原文不匹配，内容已遭篡改。");
		else
			alert("PTA模块发生错误\r\n错误号: " + e.number + "\r\n错误描述: " + e.description);
		return false;
	}
}

/**
 * signMessage 数字签名
 *
 * @param plainText:
 *            原文
 * @param signCert
 *            用于签名的证书对象，可以使用GetSingleCertificate函数获得证书对象
 *            ，或者使用SelectSingleCertificate函数选择<select>中列出的证书
 * @param opt:
 *            签名参数
 * @return 成功: 返回签名值，失败: 返回""
 */
function signMessage(plainText, signCert, opt) {
	var signedStr;
	var signCert;
	try {
		opt = typeof(opt) == "number" ? opt | OUTPUT_BASE64 : OUTPUT_BASE64;
		signedStr = signCert.SignMessage(plainText, opt);
	} catch (e) {
		if ((e.number == -2147483135) || e.number == -2146881278 // cancel
				|| e.number == -2146434962 // FT2001 PIN Login canceled
		) {
			return "";// User canceled
		} else if (e.number == -2146885621)
			alert("您不拥有证书“" + signCert.CommonName + "”的私钥，签名失败。");
		else
			alert("PTA模块发生错误\r\n错误号: " + e.number + "\r\n错误描述: "
					+ e.description);
		return "";
	}
	return signedStr;
}

/**
 * signFile 数字签名
 *
 * @param fileName:
 *            待签名文件路径
 * @param signCert
 *            用于签名的证书对象，可以使用GetSingleCertificate函数获得证书对象
 *            ，或者使用SelectSingleCertificate函数选择<select>中列出的证书
 * @param opt:
 *            签名参数
 * @return 成功: 返回签名值，失败: 返回""
 */
function signFile(fileName, signCert, opt) {
	if (fileName == "")
		return;
	var signedStr;
	try {
		opt = typeof(opt) == "number" ? opt | OUTPUT_BASE64 : OUTPUT_BASE64;
		signedStr = signCert.SignFile(fileName, opt);
	} catch (e) {
		if ((e.number == -2147483135) || e.number == -2146881278 // cancel
				|| e.number == -2146434962 // FT2001 PIN Login canceled
		) {
			return "";// User canceled
		} else if (e.number == -2147483134)
			alert("文件[" + srcFileName + "]不存在。");
		else if (e.number == -2146885621)
			alert("您不拥有证书“" + signCert.CommonName + "”的私钥，签名失败。");
		else
			alert("PTA模块发生错误\r\n错误号: " + e.number + "\r\n错误描述: " + e.description);
		return "";
	}
	return signedStr;
}

/**
 * signFileEx 文件签名Ex
 *
 * @param srcfileName:
 *            待签名文件路径
 * @param destFileName:
 *            签名值文件路径
 * @param signCert
 *            用于签名的证书对象，可以使用GetSingleCertificate函数获得证书对象
 *            ，或者使用SelectSingleCertificate函数选择<select>中列出的证书
 * @param opt:
 *            签名参数
 * @return 成功: true，失败: false
 */
function signFileEx(srcFileName, destFileName, signCert, opt) {
	if (srcFileName == "" || destFileName == "")
		return;
	var bRet;
	try {
		// opt = typeof(opt) == "number"?opt|OUTPUT_BASE64:OUTPUT_BASE64;
		bRet = signCert.SignFileEx(srcFileName, destFileName, opt);
	} catch (e) {
		if ((e.number == -2147483135) || e.number == -2146881278 // canceled
				|| e.number == -2146434962 // FT2001 PIN Login canceled
		) {
			return false;// User canceled
		} else if (e.number == -2147483134)
			alert("文件[" + srcFileName + "]不存在。");
		else if (e.number == -2146885621)
			alert("您不拥有证书“" + signCert.CommonName + "”的私钥，签名失败。");
		else
			alert("PTA模块发生错误\r\n错误号: " + e.number + "\r\n错误描述: "
					+ e.description);
		return false;
	}
	return bRet;
}

/**
 * signCSR 更新证书时需要调用，对更新证书的CSR
 *
 * @param objOldCert(mandatory)
 *            要更新的证书对象（PTALib.Certificate）
 * @param csr(mandatory)
 *            证书签名请求
 * @return 成功: 返回签名值，失败: 返回""
 */
function signCSR(objOldCert, csr) {
	try {
		var signedData = "";
		var ptaVersion = iTrusPTA.Version;
		if (ptaVersion == null) {
			// PTA Version = 1.0.0.3
			signedData = objOldCert.SignMessage("LOGONDATA:" + csr,	OUTPUT_BASE64);
		} else {
			// PTA Version >= 2
			signedData = objOldCert.SignLogonData("LOGONDATA:" + csr, OUTPUT_BASE64);
		}
		return signedData;
	} catch (e) {
		if (-2147483135 == e.number) {
			// 用户取消签名
			return "";
		} else if (e.number == -2146885621) {
			alert("您不拥有证书“" + objOldCert.CommonName + "”的私钥，签名失败。");
			return "";
		} else {
			alert("PTA签名时发生错误\r\n错误号: " + e.number + "\r\n错误描述: " + e.description);
			return "";
		}
	}
}

/**
 * encryptMessage 加密消息
 *
 * @param message
 *            待加密消息原文
 * @param certificates
 *            PTA.Certificates集合对象
 *
 * @return 成功: 返回Base64编码加密值
 */
function encryptMessage(message, certificates) {
	if (message == "")
		return "";

	var encryptStr;
	try {
		encryptStr = certificates.EncryptMessage(message, 4);
	} catch (e) {
		alert("PTA模块发生错误\r\n错误号: " + e.number + "\r\n错误描述: " + e.description);
		return "";
	}
	return encryptStr;
}

/**
 * encryptMessage 解密消息
 *
 * @param message
 *            待解密消息原文
 *
 * @return 成功: 返回解密后的消息原文
 */
function decryptMessage(encryptedStr) {
	if (encryptedStr == "")
		return "";

	var base64Str;
	try {
		base64Str = iTrusPTA.DecryptMessage(encryptedStr, 1);
	} catch (e) {
		if (e.number == -2146885620)
			alert("找不到解密证书或解密证书没有私钥。");
		else
			alert("PTA模块发生错误\r\n错误号: " + e.number + "\r\n错误描述: "
					+ e.description);
		return "";
	}

	return base64Str;
}

/**
 * encryptFile 加密文件
 *
 * @param srcFileName
 *            待加密文件路径
 * @param destFileName
 *            已加密文件路径
 * @param certificates
 *            PTA.Certificates集合对象
 * @return 成功: 返回true，失败：返回false
 */
function encryptFileEx(srcFileName, destFileName, certificates) {
	if (srcFileName == "" || destFileName == "")
		return "";

	var bRet;
	try {
		bRet = certificates.EncryptFileEx(srcFileName, destFileName, 0);
	} catch (e) {
		if (e.number == -2147483134)
			alert("文件[" + srcFileName + "]不存在。");
		else
			alert("PTA模块发生错误\r\n错误号: " + e.number + "\r\n错误描述: "
					+ e.description);
		return false;
	}
	return bRet;
}

/**
 * decryptFileEx 解密文件
 *
 * @param srcFileName
 *            已加密文件路径
 * @param destFileName
 *            解密后文件路径
 * @return 成功: 返回true，失败：返回false
 */
function decryptFileEx(srcFileName, destFileName) {
	if (srcFileName == "" || destFileName == "")
		return "";

	var bRet;
	try {
		bRet = iTrusPTA.DecryptFileEx(srcFileName, destFileName, 0);
	} catch (e) {
		if (e.number == -2147483134)
			alert("文件[" + srcFileName + "]不存在。");
		else if (e.number == -2146881269)
			alert("文件[" + srcFileName + "]格式不正确，ASN解码失败。");
		else if (e.number == -2146881276)
			alert("文件太大，解密失败，请尝试在服务端解密。");
		else if (e.number == -2146885620)
			alert("找不到解密证书或解密证书没有私钥。");
		else
			alert("PTA模块发生错误\r\n错误号: " + e.number + "\r\n错误描述: "
					+ e.description);
		return false;
	}
	return bRet;
}


/*******************************************************************************
 * 该功能是去掉通过控件获取到的证书主题字符串结束符。
 * 参数为当前证书对象
 * 返回值为证书主题subject
 ******************************************************************************/
function GetCertSubject(cert){
		var dn=cert.Subject;
		dn=dn.replace(/\x00/g,"");
		return dn;
		}
		
/*******************************************************************************
 * 该功能是去掉通过控件获取到的证书颁发者主题字符串结束符。
 * 参数为当前证书对象
 * 返回值为证书颁发者主题Issuer
 ******************************************************************************/
function GetCertIssuer(cert){
		var issuer=curCert.Issuer;
		issuer=issuer.replace(/\x00/g,"");
		return issuer;
		}


/*******************************************************************************
 * Object: Hashtable Description: Implementation of hashtable Author: Uzi
 * Refaeli
 ******************************************************************************/

// ======================================= Properties
// ========================================
Hashtable.prototype.hash = null;
Hashtable.prototype.keys = null;
Hashtable.prototype.location = null;

/**
 * Hashtable - Constructor Create a new Hashtable object.
 */
function Hashtable() {
	this.hash = new Array();
	this.keys = new Array();

	this.location = 0;
}

Hashtable.prototype.containsKey = function(key) {
	if (this.hash[key] == null)
		return false;
	else
		return true;
}

/**
 * put Add new key param: key - String, key name param: value - Object, the
 * object to insert
 */
Hashtable.prototype.put = function(key, value) {
	if (value == null)
		return;

	if (this.hash[key] == null)
		this.keys[this.keys.length] = key;

	this.hash[key] = value;
}

/**
 * get Return an element param: key - String, key name Return: object - The
 * requested object
 */
Hashtable.prototype.get = function(key) {
	return this.hash[key];
}

/**
 * remove Remove an element param: key - String, key name
 */
Hashtable.prototype.remove = function(key) {
	for (var i = 0; i < this.keys.length; i++) {
		// did we found our key?
		if (key == this.keys[i]) {
			// remove it from the hash
			this.hash[this.keys[i]] = null;
			// and throw away the key...
			this.keys.splice(i, 1);
			return;
		}
	}
}

/**
 * size Return: Number of elements in the hashtable
 */
Hashtable.prototype.size = function() {
	return this.keys.length;
}

/**
 * populateItems Deprecated
 */
Hashtable.prototype.populateItems = function() {
}

/**
 * next Return: true if theres more items
 */
Hashtable.prototype.next = function() {
	if (++this.location < this.keys.length)
		return true;
	else
		return false;
}

/**
 * moveFirst Move to the first item.
 */
Hashtable.prototype.moveFirst = function() {
	try {
		this.location = -1;
	} catch (e) {/* //do nothing here :-) */
	}
}

/**
 * moveLast Move to the last item.
 */
Hashtable.prototype.moveLast = function() {
	try {
		this.location = this.keys.length - 1;
	} catch (e) {/* //do nothing here :-) */
	}
}

/**
 * getKey Return: The value of item in the hash
 */
Hashtable.prototype.getKey = function() {
	try {
		return this.keys[this.location];
	} catch (e) {
		return null;
	}
}

/**
 * getValue Return: The value of item in the hash
 */
Hashtable.prototype.getValue = function() {
	try {
		return this.hash[this.keys[this.location]];
	} catch (e) {
		return null;
	}
}

/**
 * getKey Return: The first key contains the given value, or null if not found
 */
Hashtable.prototype.getKeyOfValue = function(value) {
	for (var i = 0; i < this.keys.length; i++)
		if (this.hash[this.keys[i]] == value)
			return this.keys[i]
	return null;
}

/**
 * toString Returns a string representation of this Hashtable object in the form
 * of a set of entries, enclosed in braces and separated by the ASCII characters ", "
 * (comma and space). Each entry is rendered as the key, an equals sign =, and
 * the associated element, where the toString method is used to convert the key
 * and element to strings. Return: a string representation of this hashtable.
 */
Hashtable.prototype.toString = function() {

	try {
		var s = new Array(this.keys.length);
		s[s.length] = "{";

		for (var i = 0; i < this.keys.length; i++) {
			s[s.length] = this.keys[i];
			s[s.length] = "=";
			var v = this.hash[this.keys[i]];
			if (v)
				s[s.length] = v.toString();
			else
				s[s.length] = "null";

			if (i != this.keys.length - 1)
				s[s.length] = ", ";
		}
	} catch (e) {
		// do nothing here :-)
	} finally {
		s[s.length] = "}";
	}

	return s.join("");
}

/**
 * add Concatanates hashtable to another hashtable.
 */
Hashtable.prototype.add = function(ht) {
	try {
		ht.moveFirst();
		while (ht.next()) {
			var key = ht.getKey();
			// put the new value in both cases (exists or not).
			this.hash[key] = ht.getValue();
			// but if it is a new key also increase the key set
			if (this.get(key) != null) {
				this.keys[this.keys.length] = key;
			}
		}
	} catch (e) {
		// do nothing here :-)
	} finally {
		return this;
	}
};