package com.seeyon.apps.duban.wrapper;

import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.duban.vo.form.FormField;
import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import org.springframework.util.CollectionUtils;

import java.lang.reflect.Field;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2019/11/7.
 */
public final class DataTransferStrategy {


    public static <T> T filledFtdValueByObjectType(Class<T> cls, Map data, FormTableDefinition ftd) {
        try {
            T obj = cls.newInstance();

            List<FormField> formFiledList = ftd.getFormTable().getFormFieldList();
            if (!CollectionUtils.isEmpty(formFiledList)) {

                for (FormField ff : formFiledList) {
                    String barcode = ff.getBarcode();
                    if (!CommonUtils.isEmpty(barcode)) {
                        Field f = getClassField(cls, barcode);
                        if (f != null) {
                            f.setAccessible(true);
                            String export = ff.getExport();
                            Object val = data.get(ff.getName());
                            if ("enum".equals(export)) {
                                val = CommonUtils.getEnumShowValue(val);
                            }
                            if ("member".equals(export)) {
                                Long mid = CommonUtils.getLong(val);
                                if (mid != null) {
                                    V3xOrgMember member = CommonUtils.getOrgManager().getMemberById(mid);
                                    if (member != null) {
                                        val = member.getName();
                                    }
                                }

                            }
                            if ("department".equals(export)) {
                                Long mid = CommonUtils.getLong(val);
                                if (mid != null) {
                                    V3xOrgDepartment dept = CommonUtils.getOrgManager().getDepartmentById(mid);
                                    if (dept != null) {
                                        val = dept.getName();
                                    }
                                }

                            }
                            if (f.getType() == Long.class) {
                                f.setLong(obj, CommonUtils.getLong(val));
                            } else if (f.getType() == String.class) {
                                if (val == null) {
                                    f.set(obj, "");
                                } else {
                                    f.set(obj, String.valueOf(val));
                                }

                            } else {
                                f.set(obj, val);
                            }
                        }


                    }


                }

            }
            return obj;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    private static Field getClassField(Class cls, String fieldName) {
        Field f = null;
        try {
            f = cls.getDeclaredField(fieldName);
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        }
        if (f == null) {
            cls = cls.getSuperclass();
            while (cls != null) {
                try {
                    f = cls.getDeclaredField(fieldName);
                    if (f != null) {
                        break;
                    }
                } catch (NoSuchFieldException e) {
                    e.printStackTrace();
                }
                cls = cls.getSuperclass();

            }

        }

        return f;

    }
}
