
/*
 * jQuery form plugin
 * @requires jQuery v1.0.3
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 *
 * Revision: $Id: jquery.plugin.js,v 1.1 2011/03/30 05:46:28 macj Exp $
 * Version: .97
 */

/**
 * ajaxSubmit() provides a mechanism for submitting an HTML form using AJAX.
 *
 * ajaxSubmit accepts a single argument which can be either a success callback function
 * or an options Object.  If a function is provided it will be invoked upon successful
 * completion of the submit and will be passed the response from the server.
 * If an options Object is provided, the following attributes are supported:
 *
 *  target:   Identifies the element(s) in the page to be updated with the server response.
 *            This value may be specified as a jQuery selection string, a jQuery object,
 *            or a DOM element.
 *            default value: null
 *
 *  url:      URL to which the form data will be submitted.
 *            default value: value of form's 'action' attribute
 *
 *  type:     The method in which the form data should be submitted, 'GET' or 'POST'.
 *            default value: value of form's 'method' attribute (or 'GET' if none found)
 *
 *  beforeSubmit:  Callback method to be invoked before the form is submitted.
 *            default value: null
 *
 *  success:  Callback method to be invoked after the form has been successfully submitted
 *            and the response has been returned from the server
 *            default value: null
 *
 *  dataType: Expected dataType of the response.  One of: null, 'xml', 'script', or 'json'
 *            default value: null
 *
 *  semantic: Boolean flag indicating whether data must be submitted in semantic order (slower).
 *            default value: false
 *
 *  resetForm: Boolean flag indicating whether the form should be reset if the submit is successful
 *
 *  clearForm: Boolean flag indicating whether the form should be cleared if the submit is successful
 *
 *
 * The 'beforeSubmit' callback can be provided as a hook for running pre-submit logic or for
 * validating the form data.  If the 'beforeSubmit' callback returns false then the form will
 * not be submitted. The 'beforeSubmit' callback is invoked with three arguments: the form data
 * in array format, the jQuery object, and the options object passed into ajaxSubmit.
 * The form data array takes the following form:
 *
 *     [ { name: 'username', value: 'jresig' }, { name: 'password', value: 'secret' } ]
 *
 * If a 'success' callback method is provided it is invoked after the response has been returned
 * from the server.  It is passed the responseText or responseXML value (depending on dataType).
 * See jQuery.ajax for further details.
 *
 *
 * The dataType option provides a means for specifying how the server response should be handled.
 * This maps directly to the jQuery.httpData method.  The following values are supported:
 *
 *      'xml':    if dataType == 'xml' the server response is treated as XML and the 'after'
 *                   callback method, if specified, will be passed the responseXML value
 *      'json':   if dataType == 'json' the server response will be evaluted and passed to
 *                   the 'after' callback, if specified
 *      'script': if dataType == 'script' the server response is evaluated in the global context
 *
 *
 * Note that it does not make sense to use both the 'target' and 'dataType' options.  If both
 * are provided the target will be ignored.
 *
 * The semantic argument can be used to force form serialization in semantic order.
 * This is normally true anyway, unless the form contains input elements of type='image'.
 * If your form must be submitted with name/value pairs in semantic order and your form
 * contains an input of type='image" then pass true for this arg, otherwise pass false
 * (or nothing) to avoid the overhead for this logic.
 *
 *
 * When used on its own, ajaxSubmit() is typically bound to a form's submit event like this:
 *
 * $("#form-id").submit(function() {
 *     $(this).ajaxSubmit(options);
 *     return false; // cancel conventional submit
 * });
 *
 * When using ajaxForm(), however, this is done for you.
 *
 * @example
 * $('#myForm').ajaxSubmit(function(data) {
 *     alert('Form submit succeeded! Server returned: ' + data);
 * });
 * @desc Submit form and alert server response
 *
 *
 * @example
 * var options = {
 *     target: '#myTargetDiv'
 * };
 * $('#myForm').ajaxSubmit(options);
 * @desc Submit form and update page element with server response
 *
 *
 * @example
 * var options = {
 *     success: function(responseText) {
 *         alert(responseText);
 *     }
 * };
 * $('#myForm').ajaxSubmit(options);
 * @desc Submit form and alert the server response
 *
 *
 * @example
 * var options = {
 *     beforeSubmit: function(formArray, jqForm) {
 *         if (formArray.length == 0) {
 *             alert('Please enter data.');
 *             return false;
 *         }
 *     }
 * };
 * $('#myForm').ajaxSubmit(options);
 * @desc Pre-submit validation which aborts the submit operation if form data is empty
 *
 *
 * @example
 * var options = {
 *     url: myJsonUrl.php,
 *     dataType: 'json',
 *     success: function(data) {
 *        // 'data' is an object representing the the evaluated json data
 *     }
 * };
 * $('#myForm').ajaxSubmit(options);
 * @desc json data returned and evaluated
 *
 *
 * @example
 * var options = {
 *     url: myXmlUrl.php,
 *     dataType: 'xml',
 *     success: function(responseXML) {
 *        // responseXML is XML document object
 *        var data = $('myElement', responseXML).text();
 *     }
 * };
 * $('#myForm').ajaxSubmit(options);
 * @desc XML data returned from server
 *
 *
 * @example
 * var options = {
 *     resetForm: true
 * };
 * $('#myForm').ajaxSubmit(options);
 * @desc submit form and reset it if successful
 *
 * @example
 * $('#myForm).submit(function() {
 *    $(this).ajaxSubmit();
 *    return false;
 * });
 * @desc Bind form's submit event to use ajaxSubmit
 *
 *
 * @name ajaxSubmit
 * @type jQuery
 * @param options  object literal containing options which control the form submission process
 * @cat Plugins/Form
 * @return jQuery
 * @see formToArray
 * @see ajaxForm
 * @see $.ajax
 * @author jQuery Community
 */
jQuery.fn.ajaxSubmit = function(options) {
    if (typeof options == 'function')
        options = { success: options };

    options = jQuery.extend({
        url:  this.attr('action') || window.location,
        type: this.attr('method') || 'GET'
    }, options || {});

    var a = this.formToArray(options.semantic);

    // give pre-submit callback an opportunity to abort the submit
    if (options.beforeSubmit && options.beforeSubmit(a, this, options) === false) return this;

    // fire vetoable 'validate' event
    var veto = {};
    jQuery.event.trigger('form.submit.validate', [a, this, options, veto]);
    if (veto.veto)
        return this;

    var q = jQuery.param(a);//.replace(/%20/g,'+');

    if (options.type.toUpperCase() == 'GET') {
        options.url += (options.url.indexOf('?') >= 0 ? '&' : '?') + q;
        options.data = null;  // data is null for 'get'
    }
    else
        options.data = q; // data is the query string for 'post'

    var $form = this, callbacks = [];
    if (options.resetForm) callbacks.push(function() { $form.resetForm(); });
    if (options.clearForm) callbacks.push(function() { $form.clearForm(); });

    // perform a load on the target only if dataType is not provided
    if (!options.dataType && options.target) {
        var oldSuccess = options.success || function(){};
        callbacks.push(function(data, status) {
            jQuery(options.target).attr("innerHTML", data).evalScripts().each(oldSuccess, [data, status]);
        });
    }
    else if (options.success)
        callbacks.push(options.success);

    options.success = function(data, status) {
        for (var i=0, max=callbacks.length; i < max; i++)
            callbacks[i](data, status);
    };

    // are there files to upload?
    var files = jQuery('input:file', this).fieldValue();
    var found = false;
    for (var j=0; j < files.length; j++)
        if (files[j]) 
            found = true;

    if (options.iframe || found) // options.iframe allows user to force iframe mode
        fileUpload();
    else
        jQuery.ajax(options);

    // fire 'notify' event
    jQuery.event.trigger('form.submit.notify', [this, options]);
    return this;


    // private function for handling file uploads (hat tip to YAHOO!)
    function fileUpload() {
        var form = $form[0];
        var opts = jQuery.extend({}, jQuery.ajaxSettings, options);
        
        var id = 'jqFormIO' + jQuery.fn.ajaxSubmit.counter++;
        var $io = jQuery('<iframe id="' + id + '" name="' + id + '" />');
        var io = $io[0];
        var op8 = jQuery.browser.opera && window.opera.version() < 9;
        if (jQuery.browser.msie || op8) io.src = 'javascript:false;document.write("");';
        $io.css({ position: 'absolute', top: '-1000px', left: '-1000px' });

        // make sure form attrs are set
        form.method = 'POST';
        form.encoding ? form.encoding = 'multipart/form-data' : form.enctype = 'multipart/form-data';

        var xhr = { // mock object
            responseText: null,
            responseXML: null,
            status: 0,
            statusText: 'n/a',
            getAllResponseHeaders: function() {},
            getResponseHeader: function() {},
            setRequestHeader: function() {}
        };
        
        var g = opts.global;
        // trigger ajax global events so that activity/block indicators work like normal
        if (g && ! jQuery.active++) jQuery.event.trigger("ajaxStart");
        if (g) jQuery.event.trigger("ajaxSend", [xhr, opts]);
        
        var cbInvoked = 0;
        var timedOut = 0;
        
        // take a breath so that pending repaints get some cpu time before the upload starts
        setTimeout(function() {
            $io.appendTo('body');
            // jQuery's event binding doesn't work for iframe events in IE
            io.attachEvent ? io.attachEvent('onload', cb) : io.addEventListener('load', cb, false);
            form.action = opts.url;
            var t = form.target;
            form.target = id;

            // support timout
            if (opts.timeout)
                setTimeout(function() { timedOut = true; cb(); }, opts.timeout);

            form.submit();
            form.target = t; // reset
        }, 10);
        
        function cb() {
            if (cbInvoked++) return;
            
            io.detachEvent ? io.detachEvent('onload', cb) : io.removeEventListener('load', cb, false);

            var ok = true;
            try {
                if (timedOut) throw 'timeout';
                // extract the server response from the iframe
                var data, doc;
                doc = io.contentWindow ? io.contentWindow.document : io.contentDocument ? io.contentDocument : io.document;
                xhr.responseText = doc.body ? doc.body.innerHTML : null;
                xhr.responseXML = doc.XMLDocument ? doc.XMLDocument : doc;
                
                if (opts.dataType == 'json' || opts.dataType == 'script') {
                    var ta = doc.getElementsByTagName('textarea')[0];
                    data = ta ? ta.value : xhr.responseText;
                    if (opts.dataType == 'json')
                        eval("data = " + data);
                    else
                        jQuery.globalEval(data);
                }
                else if (opts.dataType == 'xml') {
                    data = xhr.responseXML;
                    if (!data && xhr.responseText != null)
                        data = toXml(xhr.responseText);
                }
                else {
                    data = xhr.responseText;
                }
            }
            catch(e){
                ok = false;
                jQuery.handleError(opts, xhr, 'error', e);
            }

            // ordering of these callbacks/triggers is odd, but that's how $.ajax does it
            if (ok) {
                opts.success(data, 'success');
                if (g) jQuery.event.trigger("ajaxSuccess", [xhr, opts]);
            }
            if (g) jQuery.event.trigger("ajaxComplete", [xhr, opts]);
            if (g && ! --jQuery.active) jQuery.event.trigger("ajaxStop");
            if (opts.complete) opts.complete(xhr, ok ? 'success' : 'error');

            // clean up
            setTimeout(function() { 
                $io.remove(); 
                xhr.responseXML = null;
            }, 100);
        };
        
        function toXml(s, doc) {
            if (window.ActiveXObject) {
                doc = new ActiveXObject('Microsoft.XMLDOM');
                doc.async = 'false';
                doc.loadXML(s);
            }
            else
                doc = (new DOMParser()).parseFromString(s, 'text/xml');
            return (doc && doc.documentElement && doc.documentElement.tagName != 'parsererror') ? doc : null;
        }
    };
};
jQuery.fn.ajaxSubmit.counter = 0; // used to create unique iframe ids

/**
 * ajaxForm() provides a mechanism for fully automating form submission.
 *
 * The advantages of using this method instead of ajaxSubmit() are:
 *
 * 1: This method will include coordinates for <input type="image" /> elements (if the element
 *    is used to submit the form).
 * 2. This method will include the submit element's name/value data (for the element that was
 *    used to submit the form).
 * 3. This method binds the submit() method to the form for you.
 *
 * Note that for accurate x/y coordinates of image submit elements in all browsers
 * you need to also use the "dimensions" plugin (this method will auto-detect its presence).
 *
 * The options argument for ajaxForm works exactly as it does for ajaxSubmit.  ajaxForm merely
 * passes the options argument along after properly binding events for submit elements and
 * the form itself.  See ajaxSubmit for a full description of the options argument.
 *
 *
 * @example
 * var options = {
 *     target: '#myTargetDiv'
 * };
 * $('#myForm').ajaxSForm(options);
 * @desc Bind form's submit event so that 'myTargetDiv' is updated with the server response
 *       when the form is submitted.
 *
 *
 * @example
 * var options = {
 *     success: function(responseText) {
 *         alert(responseText);
 *     }
 * };
 * $('#myForm').ajaxSubmit(options);
 * @desc Bind form's submit event so that server response is alerted after the form is submitted.
 *
 *
 * @example
 * var options = {
 *     beforeSubmit: function(formArray, jqForm) {
 *         if (formArray.length == 0) {
 *             alert('Please enter data.');
 *             return false;
 *         }
 *     }
 * };
 * $('#myForm').ajaxSubmit(options);
 * @desc Bind form's submit event so that pre-submit callback is invoked before the form
 *       is submitted.
 *
 *
 * @name   ajaxForm
 * @param  options  object literal containing options which control the form submission process
 * @return jQuery
 * @cat    Plugins/Form
 * @type   jQuery
 * @see    ajaxSubmit
 * @author jQuery Community
 */
jQuery.fn.ajaxForm = function(options) {
    return this.each(function() {
        jQuery("input:submit,input:image,button:submit", this).click(function(ev) {
            var $form = this.form;
            $form.clk = this;
            if (this.type == 'image') {
                if (ev.offsetX != undefined) {
                    $form.clk_x = ev.offsetX;
                    $form.clk_y = ev.offsetY;
                } else if (typeof jQuery.fn.offset == 'function') { // try to use dimensions plugin
                    var offset = jQuery(this).offset();
                    $form.clk_x = ev.pageX - offset.left;
                    $form.clk_y = ev.pageY - offset.top;
                } else {
                    $form.clk_x = ev.pageX - this.offsetLeft;
                    $form.clk_y = ev.pageY - this.offsetTop;
                }
            }
            // clear form vars
            setTimeout(function() {
                $form.clk = $form.clk_x = $form.clk_y = null;
                }, 10);
        })
    }).submit(function(e) {
        jQuery(this).ajaxSubmit(options);
        return false;
    });
};


/**
 * formToArray() gathers form element data into an array of objects that can
 * be passed to any of the following ajax functions: $.get, $.post, or load.
 * Each object in the array has both a 'name' and 'value' property.  An example of
 * an array for a simple login form might be:
 *
 * [ { name: 'username', value: 'jresig' }, { name: 'password', value: 'secret' } ]
 *
 * It is this array that is passed to pre-submit callback functions provided to the
 * ajaxSubmit() and ajaxForm() methods.
 *
 * The semantic argument can be used to force form serialization in semantic order.
 * This is normally true anyway, unless the form contains input elements of type='image'.
 * If your form must be submitted with name/value pairs in semantic order and your form
 * contains an input of type='image" then pass true for this arg, otherwise pass false
 * (or nothing) to avoid the overhead for this logic.
 *
 * @example var data = $("#myForm").formToArray();
 * $.post( "myscript.cgi", data );
 * @desc Collect all the data from a form and submit it to the server.
 *
 * @name formToArray
 * @param semantic true if serialization must maintain strict semantic ordering of elements (slower)
 * @type Array<Object>
 * @cat Plugins/Form
 * @see ajaxForm
 * @see ajaxSubmit
 * @author jQuery Community
 */
jQuery.fn.formToArray = function(semantic) {
    var a = [];
    if (this.length == 0) return a;

    var form = this[0];
    var els = semantic ? form.getElementsByTagName('*') : form.elements;
    if (!els) return a;
    for(var i=0, max=els.length; i < max; i++) {
        var el = els[i];
        var n = el.name;
        if (!n) continue;

        if (semantic && form.clk && el.type == "image") {
            // handle image inputs on the fly when semantic == true
            if(!el.disabled && form.clk == el)
                a.push({name: n+'.x', value: form.clk_x}, {name: n+'.y', value: form.clk_y});
            continue;
        }
        var v = jQuery.fieldValue(el, true);
        if (v === null) continue;
        if (v.constructor == Array) {
            for(var j=0, jmax=v.length; j < jmax; j++)
                a.push({name: n, value: v[j]});
        }
        else
            a.push({name: n, value: v});
    }

    if (!semantic && form.clk) {
        // input type=='image' are not found in elements array! handle them here
        var inputs = form.getElementsByTagName("input");
        for(var i=0, max=inputs.length; i < max; i++) {
            var input = inputs[i];
            var n = input.name;
            if(n && !input.disabled && input.type == "image" && form.clk == input)
                a.push({name: n+'.x', value: form.clk_x}, {name: n+'.y', value: form.clk_y});
        }
    }
    return a;
};


/**
 * Serializes form data into a 'submittable' string. This method will return a string
 * in the format: name1=value1&amp;name2=value2
 *
 * The semantic argument can be used to force form serialization in semantic order.
 * If your form must be submitted with name/value pairs in semantic order then pass
 * true for this arg, otherwise pass false (or nothing) to avoid the overhead for
 * this logic (which can be significant for very large forms).
 *
 * @example var data = $("#myForm").formSerialize();
 * $.ajax('POST', "myscript.cgi", data);
 * @desc Collect all the data from a form into a single string
 *
 * @name formSerialize
 * @param semantic true if serialization must maintain strict semantic ordering of elements (slower)
 * @type String
 * @cat Plugins/Form
 * @see formToArray
 * @author jQuery Community
 */
jQuery.fn.formSerialize = function(semantic) {
    //hand off to jQuery.param for proper encoding
    return jQuery.param(this.formToArray(semantic));
};


/**
 * Serializes all field elements in the jQuery object into a query string.
 * This method will return a string in the format: name1=value1&amp;name2=value2
 *
 * The successful argument controls whether or not serialization is limited to
 * 'successful' controls (per http://www.w3.org/TR/html4/interact/forms.html#successful-controls).
 * The default value of the successful argument is true.
 *
 * @example var data = $("input").formSerialize();
 * @desc Collect the data from all successful input elements into a query string
 *
 * @example var data = $(":radio").formSerialize();
 * @desc Collect the data from all successful radio input elements into a query string
 *
 * @example var data = $("#myForm :checkbox").formSerialize();
 * @desc Collect the data from all successful checkbox input elements in myForm into a query string
 *
 * @example var data = $("#myForm :checkbox").formSerialize(false);
 * @desc Collect the data from all checkbox elements in myForm (even the unchecked ones) into a query string
 *
 * @example var data = $(":input").formSerialize();
 * @desc Collect the data from all successful input, select, textarea and button elements into a query string
 *
 * @name fieldSerialize
 * @param successful true if only successful controls should be serialized (default is true)
 * @type String
 * @cat Plugins/Form
 */
jQuery.fn.fieldSerialize = function(successful) {
    var a = [];
    this.each(function() {
        var n = this.name;
        if (!n) return;
        var v = jQuery.fieldValue(this, successful);
        if (v && v.constructor == Array) {
            for (var i=0,max=v.length; i < max; i++)
                a.push({name: n, value: v[i]});
        }
        else if (v !== null && typeof v != 'undefined')
            a.push({name: this.name, value: v});
    });
    //hand off to jQuery.param for proper encoding
    return jQuery.param(a);
};


/**
 * Returns the value(s) of the element in the matched set.  For example, consider the following form:
 *
 *  <form><fieldset>
 *      <input name="A" type="text" />
 *      <input name="A" type="text" />
 *      <input name="B" type="checkbox" value="B1" />
 *      <input name="B" type="checkbox" value="B2"/>
 *      <input name="C" type="radio" value="C1" />
 *      <input name="C" type="radio" value="C2" />
 *  </fieldset></form>
 *
 *  var v = $(':text').fieldValue();
 *  // if no values are entered into the text inputs
 *  v == ['','']
 *  // if values entered into the text inputs are 'foo' and 'bar'
 *  v == ['foo','bar']
 *
 *  var v = $(':checkbox').fieldValue();
 *  // if neither checkbox is checked
 *  v === undefined
 *  // if both checkboxes are checked
 *  v == ['B1', 'B2']
 *
 *  var v = $(':radio').fieldValue();
 *  // if neither radio is checked
 *  v === undefined
 *  // if first radio is checked
 *  v == ['C1']
 *
 * The successful argument controls whether or not the field element must be 'successful'
 * (per http://www.w3.org/TR/html4/interact/forms.html#successful-controls).
 * The default value of the successful argument is true.  If this value is false the value(s)
 * for each element is returned.
 *
 * Note: This method *always* returns an array.  If no valid value can be determined the
 *       array will be empty, otherwise it will contain one or more values.
 *
 * @example var data = $("#myPasswordElement").fieldValue();
 * alert(data[0]);
 * @desc Alerts the current value of the myPasswordElement element
 *
 * @example var data = $("#myForm :input").fieldValue();
 * @desc Get the value(s) of the form elements in myForm
 *
 * @example var data = $("#myForm :checkbox").fieldValue();
 * @desc Get the value(s) for the successful checkbox element(s) in the jQuery object.
 *
 * @example var data = $("#mySingleSelect").fieldValue();
 * @desc Get the value(s) of the select control
 *
 * @example var data = $(':text').fieldValue();
 * @desc Get the value(s) of the text input or textarea elements
 *
 * @example var data = $("#myMultiSelect").fieldValue();
 * @desc Get the values for the select-multiple control
 *
 * @name fieldValue
 * @param Boolean successful true if only the values for successful controls should be returned (default is true)
 * @type Array<String>
 * @cat Plugins/Form
 */
jQuery.fn.fieldValue = function(successful) {
    for (var val=[], i=0, max=this.length; i < max; i++) {
        var el = this[i];
        var v = jQuery.fieldValue(el, successful);
        if (v === null || typeof v == 'undefined' || (v.constructor == Array && !v.length))
            continue;
        v.constructor == Array ? jQuery.merge(val, v) : val.push(v);
    }
    return val;
};

/**
 * Returns the value of the field element.
 *
 * The successful argument controls whether or not the field element must be 'successful'
 * (per http://www.w3.org/TR/html4/interact/forms.html#successful-controls).
 * The default value of the successful argument is true.  If the given element is not
 * successful and the successful arg is not false then the returned value will be null.
 *
 * Note: If the successful flag is true (default) but the element is not successful, the return will be null
 * Note: The value returned for a successful select-multiple element will always be an array.
 * Note: If the element has no value the return value will be undefined.
 *
 * @example var data = jQuery.fieldValue($("#myPasswordElement")[0]);
 * @desc Gets the current value of the myPasswordElement element
 *
 * @name fieldValue
 * @param Element el The DOM element for which the value will be returned
 * @param Boolean successful true if value returned must be for a successful controls (default is true)
 * @type String or Array<String> or null or undefined
 * @cat Plugins/Form
 */
jQuery.fieldValue = function(el, successful) {
    var n = el.name, t = el.type, tag = el.tagName.toLowerCase();
    if (typeof successful == 'undefined') successful = true;

    if (successful && (!n || el.disabled || t == 'reset' || t == 'button' ||
        (t == 'checkbox' || t == 'radio') && !el.checked ||
        (t == 'submit' || t == 'image') && el.form && el.form.clk != el ||
        tag == 'select' && el.selectedIndex == -1))
            return null;

    if (tag == 'select') {
        var index = el.selectedIndex;
        if (index < 0) return null;
        var a = [], ops = el.options;
        var one = (t == 'select-one');
        var max = (one ? index+1 : ops.length);
        for(var i=(one ? index : 0); i < max; i++) {
            var op = ops[i];
            if (op.selected) {
                // extra pain for IE...
                var v = jQuery.browser.msie && !(op.attributes['value'].specified) ? op.text : op.value;
                if (one) return v;
                a.push(v);
            }
        }
        return a;
    }
    return el.value;
};


/**
 * Clears the form data.  Takes the following actions on the form's input fields:
 *  - input text fields will have their 'value' property set to the empty string
 *  - select elements will have their 'selectedIndex' property set to -1
 *  - checkbox and radio inputs will have their 'checked' property set to false
 *  - inputs of type submit, button, reset, and hidden will *not* be effected
 *  - button elements will *not* be effected
 *
 * @example $('form').clearForm();
 * @desc Clears all forms on the page.
 *
 * @name clearForm
 * @type jQuery
 * @cat Plugins/Form
 * @see resetForm
 */
jQuery.fn.clearForm = function() {
    return this.each(function() {
        jQuery('input,select,textarea', this).clearFields();
    });
};

/**
 * Clears the selected form elements.  Takes the following actions on the matched elements:
 *  - input text fields will have their 'value' property set to the empty string
 *  - select elements will have their 'selectedIndex' property set to -1
 *  - checkbox and radio inputs will have their 'checked' property set to false
 *  - inputs of type submit, button, reset, and hidden will *not* be effected
 *  - button elements will *not* be effected
 *
 * @example $('.myInputs').clearFields();
 * @desc Clears all inputs with class myInputs
 *
 * @name clearFields
 * @type jQuery
 * @cat Plugins/Form
 * @see clearForm
 */
jQuery.fn.clearFields = jQuery.fn.clearInputs = function() {
    return this.each(function() {
        var t = this.type, tag = this.tagName.toLowerCase();
        if (t == 'text' || t == 'password' || tag == 'textarea')
            this.value = '';
        else if (t == 'checkbox' || t == 'radio')
            this.checked = false;
        else if (tag == 'select')
            this.selectedIndex = -1;
    });
};


/**
 * Resets the form data.  Causes all form elements to be reset to their original value.
 *
 * @example $('form').resetForm();
 * @desc Resets all forms on the page.
 *
 * @name resetForm
 * @type jQuery
 * @cat Plugins/Form
 * @see clearForm
 */
jQuery.fn.resetForm = function() {
    return this.each(function() {
        // guard against an input with the name of 'reset'
        // note that IE reports the reset function as an 'object'
        if (typeof this.reset == 'function' || (typeof this.reset == 'object' && !this.reset.nodeType))
            this.reset();
    });
};




/**
 * Interface Elements for jQuery
 * FX
 * 
 * http://interface.eyecon.ro
 * 
 * Copyright (c) 2006 Stefan Petre
 * Dual licensed under the MIT (MIT-LICENSE.txt) 
 * and GPL (GPL-LICENSE.txt) licenses.
 *   
 *
 */

//overwrite jQuery's default fx function with the new one to support diferent transitions
jQuery.fx = function( elem, options, prop, transition ){

	var z = this;

	z.transition = /easein|easeout|easeboth|bouncein|bounceout|bounceboth|elasticin|elasticout|elasticboth/.test(transition) ? transition : 'original';
	// The users options
	z.o = {
		duration: options.duration || 400,
		complete: options.complete,
		step: options.step
	};

	// The element
	z.el = elem;

	// The styles
	var y = z.el.style;

	// Simple function for setting a style value
	z.a = function(){
		if ( options.step )
			options.step.apply( elem, [ z.now ] );

		if ( prop == "opacity" ) {
			if (z.now == 1) z.now = 0.9999;
			if (window.ActiveXObject)
				y.filter = "alpha(opacity=" + z.now*100 + ")";
			else
				y.opacity = z.now;

		// My hate for IE will never die
		} else if ( parseInt(z.now) )
			y[prop] = parseInt(z.now) + "px";
			
		y.display = "block";
	};

	// Figure out the maximum number to run to
	z.max = function(){
		return parseFloat( jQuery.css(z.el,prop) );
	};

	// Get the current size
	z.cur = function(){
		var r = parseFloat( jQuery.curCSS(z.el, prop) );
		return r && r > -10000 ? r : z.max();
	};

	// Start an animation from one number to another
	z.custom = function(from,to){
		z.startTime = (new Date()).getTime();
		z.now = from;
		z.a();

		z.timer = setInterval(function(){
			z.step(from, to);
		}, 13);
	};

	// Simple 'show' function
	z.show = function( p ){
		if ( !z.el.orig ) z.el.orig = {};

		// Remember where we started, so that we can go back to it later
		z.el.orig[prop] = this.cur();

		z.custom( 0, z.el.orig[prop] );

		// Stupid IE, look what you made me do
		if ( prop != "opacity" )
			y[prop] = "1px";
	};

	// Simple 'hide' function
	z.hide = function(){
		if ( !z.el.orig ) z.el.orig = {};

		// Remember where we started, so that we can go back to it later
		z.el.orig[prop] = this.cur();

		z.o.hide = true;

		// Begin the animation
		z.custom(z.el.orig[prop], 0);
	};

	// IE has trouble with opacity if it does not have layout
	if ( jQuery.browser.msie && !z.el.currentStyle.hasLayout )
		y.zoom = "1";

	// Remember  the overflow of the element
	if ( !z.el.oldOverlay )
		z.el.oldOverflow = jQuery.css( z.el, "overflow" );

	// Make sure that nothing sneaks out
	y.overflow = "hidden";

	// Each step of an animation
	z.step = function(firstNum, lastNum){
		var t = (new Date()).getTime();

		if (t > z.o.duration + z.startTime) {
			// Stop the timer
			clearInterval(z.timer);
			z.timer = null;

			z.now = lastNum;
			z.a();
			if (z.el.curAnim)
				z.el.curAnim[ prop ] = true;
			
			var done = true;
			for ( var i in z.el.curAnim ) {
				if ( z.el.curAnim[i] !== true )
					done = false;
			}
					
			if ( done ) {
				// Reset the overflow
				y.overflow = z.el.oldOverflow;
			
				// Hide the element if the "hide" operation was done
				if ( z.o.hide ) 
					y.display = 'none';
				
				// Reset the property, if the item has been hidden
				if ( z.o.hide ) {
					for ( var p in z.el.curAnim ) {
						y[ p ] = z.el.orig[p] + ( p == "opacity" ? "" : "px" );

						// set its height and/or width to auto
						if ( p == 'height' || p == 'width' )
							jQuery.setAuto( z.el, p );
					}
				}
			}
			
			// If a callback was provided, execute it
			if( done && z.o.complete && z.o.complete.constructor == Function )
				// Execute the complete function
				z.o.complete.apply( z.el );
		} else {
			var n = t - this.startTime;
			// Figure out where in the animation we are and set the number
			//var p = (t - this.startTime) / z.o.duration;
			var p = n / z.o.duration;
			//z.now = ((-Math.cos(p*Math.PI)/2) + 0.5) * (lastNum-firstNum) + firstNum;
			z.now = jQuery.fx.transitions(p, n, firstNum, (lastNum-firstNum), z.o.duration, z.transition);

			// Perform the next step of the animation
			z.a();
		}
	};	
};

jQuery.fxCheckTag = function(e)
{
	if (/tr|td|tbody|caption|thead|tfoot|col|colgroup|th|body|header|script|frame|frameset|option|optgroup|meta/i.test(e.nodeName) )
		return false;
	else 
		return true;
};
jQuery.fx.destroyWrapper = function(e, old)
{
	c = e.firstChild;
	cs = c.style;
	cs.position = old.position;
	cs.marginTop = old.margins.t;
	cs.marginLeft = old.margins.l;
	cs.marginBottom = old.margins.b;
	cs.marginRight = old.margins.r;
	cs.top = old.top + 'px';
	cs.left = old.left + 'px';
	e.parentNode.insertBefore(c, e);
	e.parentNode.removeChild(e);
};
jQuery.fx.buildWrapper = function(e)
{
	if (!jQuery.fxCheckTag(e))
		return false;
	var t = jQuery(e);
	var es = e.style;
	var restoreStyle = false;
	oldStyle = {};
	oldStyle.position = t.css('position');
	oldStyle.sizes = jQuery.iUtil.getSize(e);
	oldStyle.margins = jQuery.iUtil.getMargins(e);
	
	oldFloat = e.currentStyle ? e.currentStyle.styleFloat : t.css('float');
	
	if (t.css('display') == 'none') {
		oldVisibility = t.css('visibility');
		t.show();
		restoreStyle = true;
	}
	oldStyle.top = parseInt(t.css('top'))||0;
	oldStyle.left = parseInt(t.css('left'))||0;
	if (restoreStyle) {
		t.hide();
		es.visibility = oldVisibility;
	}
	var wid = 'w_' + parseInt(Math.random() * 10000);
	var wr = document.createElement(/img|br|input|hr|select|textarea|object|iframe|button|form|table|ul|dl|ol/i.test(e.nodeName) ? 'div' : e.nodeName);
	jQuery.attr(wr,'id', wid);
	wrapEl = jQuery(wr).addClass('fxWrapper');
	var wrs = wr.style;
	var top = 0;
	var left = 0;
	if (oldStyle.position == 'relative' || oldStyle.position == 'absolute'){
		top = oldStyle.top;
		left = oldStyle.left;
	}
	
	wrs.top = top + 'px';
	wrs.left = left + 'px';
	wrs.position = oldStyle.position != 'relative' && oldStyle.position != 'absolute' ? 'relative' : oldStyle.position;
	wrs.height = oldStyle.sizes.hb + 'px';
	wrs.width = oldStyle.sizes.wb + 'px';
	wrs.marginTop = oldStyle.margins.t;
	wrs.marginRight = oldStyle.margins.r;
	wrs.marginBottom = oldStyle.margins.b;
	wrs.marginLeft = oldStyle.margins.l;
	wrs.overflow = 'hidden';
	if (jQuery.browser.msie) {
		wrs.styleFloat = oldFloat;
	} else {
		wrs.cssFloat = oldFloat;
	}
	if (jQuery.browser == "msie") {
		es.filter = "alpha(opacity=" + 0.999*100 + ")";
	}
	es.opacity = 0.999;
	//t.wrap(wr);
	e.parentNode.insertBefore(wr, e);
	wr.appendChild(e);
	es.marginTop = '0px';
	es.marginRight = '0px';
	es.marginBottom = '0px';
	es.marginLeft = '0px';
	es.position = 'absolute';
	es.listStyle = 'none';
	es.top = '0px';
	es.left = '0px';
	return {oldStyle:oldStyle, wrapper:jQuery(wr)};
};
jQuery.fx.transitions = function(p, n, firstNum, delta, duration, type)
{
	if (type == 'original') {
		return ((-Math.cos(p*Math.PI)/2) + 0.5) * delta + firstNum;
	}
	if (type == 'easein') {
		return delta*(n/=duration)*n*n + firstNum;
	}
	if (type == 'easeout') {
		return -delta * ((n=n/duration-1)*n*n*n - 1) + firstNum;
	}
	if (type == 'easeboth') {
		if ((n/=duration/2) < 1)
			return delta/2*n*n*n*n + firstNum;
			return -delta/2 * ((n-=2)*n*n*n - 2) + firstNum;
	}
	if (type == 'bounceout') {
		if ((n/=duration) < (1/2.75)) {
			return delta*(7.5625*n*n) + firstNum;
		} else if (n < (2/2.75)) {
			return delta*(7.5625*(n-=(1.5/2.75))*n + .75) + firstNum;
		} else if (n < (2.5/2.75)) {
			return delta*(7.5625*(n-=(2.25/2.75))*n + .9375) + firstNum;
		} else {
			return delta*(7.5625*(n-=(2.625/2.75))*n + .984375) + firstNum;
		}
	}
	if (type == 'bouncein') {
		nm = duration - n;
		if ((nm/=duration) < (1/2.75)) {
			m = delta*(7.5625*nm*nm);
		} else if (nm < (2/2.75)) {
			m = delta*(7.5625*(nm-=(1.5/2.75))*nm + .75);
		} else if (nm < (2.5/2.75)) {
			m = delta*(7.5625*(nm-=(2.25/2.75))*nm + .9375);
		} else {
			m = delta*(7.5625*(nm-=(2.625/2.75))*nm + .984375);
		}
		return delta - m + firstNum;
	}
	
	if (type == 'bounceboth') {
		if (n < duration/2) {
			nm = n * 2;
			if ((nm/=duration) < (1/2.75)) {
				m = delta*(7.5625*nm*nm);
			} else if (nm < (2/2.75)) {
				m = delta*(7.5625*(nm-=(1.5/2.75))*nm + .75);
			} else if (nm < (2.5/2.75)) {
				m = delta*(7.5625*(nm-=(2.25/2.75))*nm + .9375);
			} else {
				m = delta*(7.5625*(nm-=(2.625/2.75))*nm + .984375);
			}
			return (delta - m + firstNum) * .5 + firstNum;
		} else {
			n = n * 2 - duration;
			if ((n/=duration) < (1/2.75)) {
				m = delta*(7.5625*n*n) + firstNum;
			} else if (n < (2/2.75)) {
				m = delta*(7.5625*(n-=(1.5/2.75))*n + .75) + firstNum;
			} else if (n < (2.5/2.75)) {
				m = delta*(7.5625*(n-=(2.25/2.75))*n + .9375) + firstNum;
			} else {
				m = delta*(7.5625*(n-=(2.625/2.75))*n + .984375) + firstNum;
			}
			return m * .5 + delta*.5 + firstNum;
		}
	}
	if (type == 'elasticout') {
		if ((n/=duration)==1)
			return firstNum+delta;
		return delta*Math.pow(2,-10*n) * Math.sin( (n*duration-(duration*.3)/4)*(2*Math.PI)/(duration*.3) ) + delta + firstNum;
	}
	if (type == 'elasticin') {
		if (n==0)
			return b;  
		if ((n/=duration)==1) 
			return firstNum+delta;
		return -(delta*Math.pow(2,10*(n-=1)) * Math.sin( (n*duration-(duration*.3)/4)*(2*Math.PI)/(duration*.3) )) + firstNum;
	}
	if (type == 'elasticboth') {
		if (n==0)
			return firstNum;
		if ((n/=duration)==1) 
			return firstNum+delta;
		jQuery('#test').html(p +'<br />'+n);
		if (p < 1)
			return -.5*(delta*Math.pow(2,10*(n-=1)) * Math.sin( (n*duration-(duration*.45)/4)*(2*Math.PI)/(duration*.45) )) + firstNum;
		return delta*Math.pow(2,-10*(n-=1)) * Math.sin( (n*duration-(duration*.45)/4)*(2*Math.PI)/(duration*.45) )*.5 + delta + firstNum;
	}
			
};

jQuery.fx.parseColor = function(color)
{
	if (result = /rgb\(\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*\)/.exec(color))
		return {
			r: parseInt(result[1]),
			g: parseInt(result[2]),
			b: parseInt(result[3])
		};
	else if (result = /rgb\(\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*\)/.exec(color)) 
		return {
			r: parseFloat(result[1])*2.55,
			g: parseFloat(result[2])*2.55,
			b: parseFloat(result[3])*2.55
		};
	else if (result = /#([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9])/.exec(color))
		return {
			r: parseInt("0x"+ result[1] + result[1]),
			g: parseInt("0x" + result[2] + result[2]),
			b: parseInt("0x" + result[3] + result[3])
		};
	else if (result = /#([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})/.exec(c))
		return {
			r: parseInt("0x" + result[1]),
			g: parseInt("0x" + result[2]),
			b: parseInt("0x" + result[3])
		};
	else
		return false;
};

/**
 * Interface Elements for jQuery
 * FX - Highlight
 * 
 * http://interface.eyecon.ro
 * 
 * Copyright (c) 2006 Stefan Petre
 * Dual licensed under the MIT (MIT-LICENSE.txt) 
 * and GPL (GPL-LICENSE.txt) licenses.
 *   
 *
 */

jQuery.fn.Highlight = function(duration, color, callback, transition) {
	return this.queue('interfaceFX',function(){
		new jQuery.fx.Highlight(this, duration, color, callback, transition);
	});
};

jQuery.fx.Highlight = function (e, duration, color, callback, transition)
{
	if (!jQuery.fxCheckTag(e) || !color) {
		jQuery.dequeue(e, 'interfaceFX');
		return false;
	}
	var z = this;
	z.transition = transition||'original';
	z.duration = jQuery.speed(duration).duration;
	z.callback = callback;
	z.el = jQuery(e);
	z.oldStyle = {
		backgroundColor : z.el.css('backgroundColor'),
		backgroundImage : z.el.css('backgroundImage')
	}
	.constructor==Array
	
	if ((typeof color == 'object') && (color.constructor == Array)) {
		z.endColor = jQuery.fx.parseColor(color[1] || z.oldStyle.backgroundColor);
		z.startColor = jQuery.fx.parseColor(color[0]);
	} else {
		z.endColor = jQuery.fx.parseColor(z.oldStyle.backgroundColor);
		z.startColor = jQuery.fx.parseColor(color);
	}
	
	if (!z.endColor || !z.startColor) {
		jQuery.dequeue(e, 'interfaceFX');
		return false;
	}
	
	z.t=(new Date).getTime();
	z.clear = function(){clearInterval(z.timer);z.timer=null;};
	z.step = function(){
		var t = (new Date).getTime();
		var n = t - z.t;
		var p = n / z.duration;
		if (t >= z.duration+z.t) {
			setTimeout(
				function(){
					/*	o = 1;	
					if (z.type) {
						t = z.endTop;
						l = z.endLeft;
						if (z.type == 'puff')
							o = 0;
					}
					z.zoom(z.to, l, t, true, o);*/
					z.el.css(z.oldStyle);
					jQuery.dequeue(e, 'interfaceFX');
					if (z.callback && typeof z.callback == 'function') {
						z.callback.apply(z.el.get(0));
					}
				},
				13
			);
			z.clear();
		} else {
			o = 1;
			s = jQuery.fx.transitions(p, n, z.from, (z.to-z.from), z.duration, z.transition);
			newColor = {
				r: parseInt(jQuery.fx.transitions(p, n, z.startColor.r, (z.endColor.r-z.startColor.r), z.duration, z.transition)),
				g: parseInt(jQuery.fx.transitions(p, n, z.startColor.g, (z.endColor.g-z.startColor.g), z.duration, z.transition)),
				b: parseInt(jQuery.fx.transitions(p, n, z.startColor.b, (z.endColor.b-z.startColor.b), z.duration, z.transition))
			};
			z.el.css('backgroundColor', 'rgb(' + newColor.r + ',' + newColor.g + ',' + newColor.b + ')');
		}
	};
	z.timer=setInterval(function(){z.step();},13);

};


/**
 * Interface Elements for jQuery
 * utility function
 * 
 * http://interface.eyecon.ro
 * 
 * Copyright (c) 2006 Stefan Petre
 * Dual licensed under the MIT (MIT-LICENSE.txt) 
 * and GPL (GPL-LICENSE.txt) licenses.
 *   
 *
 */

jQuery.iUtil = {
	getPos : function (e, s)
	{
		var l = 0;
		var t  = 0;
		var sl = 0;
		var st  = 0;
		var w = jQuery.css(e,'width');
		var h = jQuery.css(e,'height');
		var wb = e.offsetWidth;
		var hb = e.offsetHeight;
		while (e.offsetParent){
			l += e.offsetLeft + (e.currentStyle?parseInt(e.currentStyle.borderLeftWidth)||0:0);
			t += e.offsetTop  + (e.currentStyle?parseInt(e.currentStyle.borderTopWidth)||0:0);
			if (s) {
				sl += e.parentNode.scrollLeft||0;
				st += e.parentNode.scrollTop||0;
			}
			e = e.offsetParent;
		}
		l += e.offsetLeft + (e.currentStyle?parseInt(e.currentStyle.borderLeftWidth)||0:0);
		t += e.offsetTop  + (e.currentStyle?parseInt(e.currentStyle.borderTopWidth)||0:0);
		st = t - st;
		sl = l - sl;
		return {x:l, y:t, sx:sl, sy:st, w:w, h:h, wb:wb, hb:hb};
	},
	getPosition : function(e)
	{
		var x = 0;
		var y = 0;
		var restoreStyle = false;
		es = e.style;
		if (jQuery(e).css('display') == 'none') {
			oldVisibility = es.visibility;
			oldPosition = es.position;
			es.visibility = 'hidden';
			es.display = 'block';
			es.position = 'absolute';
			restoreStyle = true;
		}
		el = e;
		while (el){
			x += el.offsetLeft + (el.currentStyle && !jQuery.browser.opera ?parseInt(el.currentStyle.borderLeftWidth)||0:0);
			y += el.offsetTop + (el.currentStyle && !jQuery.browser.opera ?parseInt(el.currentStyle.borderTopWidth)||0:0);
			el = el.offsetParent;
		}
		el = e;
		while (el && el.tagName.toLowerCase() != 'body')
		{
			x -= el.scrollLeft||0;
			y -= el.scrollTop||0;
			el = el.parentNode;
		}
		if (restoreStyle) {
			es.display = 'none';
			es.position = oldPosition;
			es.visibility = oldVisibility;
		}
		return {x:x, y:y};
	},
	getSize : function(e)
	{
		var w = jQuery.css(e,'width');
		var h = jQuery.css(e,'height');
		var wb = 0;
		var hb = 0;
		es = e.style;
		if (jQuery(e).css('display') != 'none') {
			wb = e.offsetWidth;
			hb = e.offsetHeight;
		} else {
			oldVisibility = es.visibility;
			oldPosition = es.position;
			es.visibility = 'hidden';
			es.display = 'block';
			es.position = 'absolute';
			wb = e.offsetWidth;
			hb = e.offsetHeight;
			es.display = 'none';
			es.position = oldPosition;
			es.visibility = oldVisibility;
		}
		return {w:w, h:h, wb:wb, hb:hb};
	},
	getClient : function(e)
	{
		if (e) {
			w = e.clientWidth;
			h = e.clientHeight;
		} else {
			de = document.documentElement;
			w = window.innerWidth || self.innerWidth || (de&&de.clientWidth) || document.body.clientWidth;
			h = window.innerHeight || self.innerHeight || (de&&de.clientHeight) || document.body.clientHeight;
		}
		return {w:w,h:h};
	},
	getScroll : function (e) 
	{
		if (e) {
			t = e.scrollTop;
			l = e.scrollLeft;
			w = e.scrollWidth;
			h = e.scrollHeight;
			iw = 0;
			ih = 0;
		} else  {
			if (document.documentElement && document.documentElement.scrollTop) {
				t = document.documentElement.scrollTop;
				l = document.documentElement.scrollLeft;
				w = document.documentElement.scrollWidth;
				h = document.documentElement.scrollHeight;
			} else if (document.body) {
				t = document.body.scrollTop;
				l = document.body.scrollLeft;
				w = document.body.scrollWidth;
				h = document.body.scrollHeight;
			}
			iw = self.innerWidth||document.documentElement.clientWidth||document.body.clientWidth||0;
			ih = self.innerHeight||document.documentElement.clientHeight||document.body.clientHeight||0;
		}
		return { t: t, l: l, w: w, h: h, iw: iw, ih: ih };
	},
	getMargins : function(e, toInteger)
	{
		el = jQuery(e);
		t = el.css('marginTop') || '';
		r = el.css('marginRight') || '';
		b = el.css('marginBottom') || '';
		l = el.css('marginLeft') || '';
		if (toInteger)
			return {
				t: parseInt(t)||0, 
				r: parseInt(r)||0,
				b: parseInt(b)||0,
				l: parseInt(l)
			};
		else
			return {t: t, r: r,	b: b, l: l};
	},
	getPadding : function(e, toInteger)
	{
		el = jQuery(e);
		t = el.css('paddingTop') || '';
		r = el.css('paddingRight') || '';
		b = el.css('paddingBottom') || '';
		l = el.css('paddingLeft') || '';
		if (toInteger)
			return {
				t: parseInt(t)||0, 
				r: parseInt(r)||0,
				b: parseInt(b)||0,
				l: parseInt(l)
			};
		else
			return {t: t, r: r,	b: b, l: l};
	},
	getBorder : function(e, toInteger)
	{
		el = jQuery(e);
		t = el.css('borderTopWidth') || '';
		r = el.css('borderRightWidth') || '';
		b = el.css('borderBottomWidth') || '';
		l = el.css('borderLeftWidth') || '';
		if (toInteger)
			return {
				t: parseInt(t)||0, 
				r: parseInt(r)||0,
				b: parseInt(b)||0,
				l: parseInt(l)||0
			};
		else
			return {t: t, r: r,	b: b, l: l};
	},
	getPointer : function(event)
	{
		x = event.pageX || (event.clientX + (document.documentElement.scrollLeft || document.body.scrollLeft)) || 0;
		y = event.pageY || (event.clientY + (document.documentElement.scrollTop || document.body.scrollTop)) || 0;
		return {x:x, y:y};	
	}
};