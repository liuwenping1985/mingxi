package com.seeyon.apps.duban.wrapper;

import com.seeyon.apps.duban.vo.form.FormField;
import com.seeyon.apps.duban.vo.form.FormTable;

/**
 * Created by liuwenping on 2019/11/7.
 */
public interface DataWrapper {


     Object wrapper(FormTable formTable, FormField field, Object val);



}
