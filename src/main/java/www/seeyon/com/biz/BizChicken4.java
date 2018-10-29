//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package www.seeyon.com.biz;

import com.seeyon.cap4.form.po.CapBizConfig;
import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.spec.InvalidKeySpecException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import www.seeyon.com.biz.enums.BizOperationEnum4;
import www.seeyon.com.biz.enums.FormSourceTypeEnum;
import www.seeyon.com.utils.Base64Util;
import www.seeyon.com.utils.DesUtil;
import www.seeyon.com.utils.ReflectUtil;

public class BizChicken4 {
    public static final int no_limit = -1;
    private static final int app_default_number = 5000;
    private static final int no_create = 0;
    private static int app_limit_number = 10;
    private static int app_used_number = 0;
    private static List<Long> outIds = Collections.synchronizedList(new ArrayList());
    private static final String split_str = "::";
    private static final String ppp = "[oy8;h;flegku$324@jlfj2o93893/fdfrh024ufoklsdro";

    public BizChicken4() {
    }

    public static void main(String[] args) {
        System.out.println(getDecodeStr("6Kej5p6Q5oC75Lqn6IO95byC5bi477yM5L2/55So6buY6K6k5Lqn6IO9MTA="));

        try {
            decode("70707D626099E240F9FB6B80513BC70F84EBBC916F3638060B12CADB2A910851F0C7D1CDDCC9FDE8B284040E7210F9CCF44DEC910B00FCC748CE02B6098BD82119CD58E6997AA9E4EE8F2C3E8EBAA3548858775428BBC476");
        } catch (Exception var2) {
            var2.printStackTrace();
        }

    }

    public static boolean isOut(Long id) {
        return outIds.contains(id);
    }

    public static void initUsedCount(List<CapBizConfig> capBizConfigList) throws Exception {
        boolean b = ((Boolean)ReflectUtil.invokeMethod("com.seeyon.ctp.common.SystemEnvironment", "isDevOrTG", (Object)null, (Class[])null, (Object[])null)).booleanValue();
        initLimitNumber(b);
        if(!b) {
            if(capBizConfigList.size() <= getAllowNum()) {
                app_used_number = capBizConfigList.size();
            } else {
                Iterator var3 = capBizConfigList.subList(getAllowNum(), capBizConfigList.size()).iterator();

                while(var3.hasNext()) {
                    CapBizConfig capBizConfig = (CapBizConfig)var3.next();
                    outIds.add(capBizConfig.getId());
                }

                app_used_number = getAllowNum();
            }

            System.out.println("1q2w3e2:" + app_used_number);
        }

    }

    private static void initLimitNumber(boolean isDevOrTG) {

        app_limit_number = 5000;
//        if(isDevOrTG) {
//            app_limit_number = -1;
//        } else {
//            boolean hasApp = ((Boolean)ReflectUtil.invokeMethod("com.seeyon.ctp.common.AppContext", "hasPlugin", (Object)null, new Class[]{String.class}, new String[]{"cap_advance"})).booleanValue();
//            String appNum = null;
//            if(!hasApp) {
//                app_limit_number = 0;
//            } else {
//                appNum = (String)ReflectUtil.invokeMethod("com.seeyon.ctp.common.AppContext", "getPlugin", (Object)null, new Class[]{String.class}, new String[]{"cap_advance.cap_cap"});
//                System.out.println("1q2w3e1:" + appNum);
//
//                try {
//                    if(appNum == null) {
//                        app_limit_number = 5;
//                    } else {
//                        app_limit_number = Integer.parseInt(appNum.trim());
//                    }
//                } catch (Exception var4) {
//                    app_limit_number = 5;
//                }
//            }
//        }

    }

    private static String getDecodeStr(String encodeStr) {
        return Base64Util.decode(encodeStr);
    }

    private static boolean isAddUsedCount(String sourceType, Long id) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException, NoSuchProviderException, NoSuchPaddingException, InvalidKeySpecException {
        String[] str = decode(sourceType);
        return isAddUsedCount(str, id, true);
    }

    private static boolean isCheckRightForm(String customName) {
        return !isUpgradeForm(customName) && !isPublicForm(customName);
    }

    private static boolean isSeeyonForm(String customName) {
        return "致远内部".equals(customName);
    }

    private static boolean isPublicForm(String customName) {
        return "公有蛋".equals(customName);
    }

    private static boolean isUpgradeForm(String customName) {
        return String.valueOf(FormSourceTypeEnum.create_form_upgrade.getKey()).equals(customName);
    }

    private static boolean isAddUsedCount(String[] str, Long id, boolean checkCustomName) {
        if(!validateDecodeObj(str, id)) {
            return true;
        } else {
            FormSourceTypeEnum st = getFormSourceType(str, id);
            boolean result = st.isEffectNum();
            if(!result && checkCustomName && isCheckRightForm(str[2])) {
                String cn = BizEgg.getCustomerName();
                result = !cn.equals(str[2]);
            }

            return result;
        }
    }

    public static FormSourceTypeEnum getFormSourceType(String sourceType, Long id) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException, NoSuchProviderException, NoSuchPaddingException, InvalidKeySpecException {
        String[] str = decode(sourceType);
        return getFormSourceType(str, id);
    }

    public static FormSourceTypeEnum getFormSourceType(String[] str, Long id) {
        if(!validateDecodeObj(str, id)) {
            return FormSourceTypeEnum.create_form_custom;
        } else {
            String typeStr = str[0];
            return FormSourceTypeEnum.getTypeByKey(Integer.parseInt(typeStr));
        }
    }

    private static boolean validateDecodeObj(String sourceType, Long id) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException, NoSuchProviderException, NoSuchPaddingException, InvalidKeySpecException {
        String[] str = decode(sourceType);
        return validateDecodeObj(str, id);
    }

    private static boolean validateDecodeObj(String[] str, Long id) {
        if(str != null && str.length == 3) {
            if(!id.toString().equals(str[1])) {
                System.out.println(getDecodeStr("SUTkuI3ljLnphY3vvIzmnInmi7fotJ3lq4znlpHvvIznrpfkvZzlt7LnlKg="));
                return false;
            } else {
                return true;
            }
        } else {
            System.out.println(getDecodeStr("6Kej5a+G5aSx6LSl77yM5pyJ56+h5pS55auM55aR77yM5YGc55So"));
            return false;
        }
    }

    public static String getEncodeString(FormSourceTypeEnum type, Long formId) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, NoSuchProviderException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidKeySpecException {
        return getEncodeString(type, formId, type.getCustomerName());
    }

    public static String getEncodeString(BizEgg egg, Long formId) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, NoSuchProviderException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidKeySpecException {
        FormSourceTypeEnum type = egg.getSourceTypeEnum();
        return getEncodeString(type, formId, type.getCustomerName(egg));
    }

    public static String getEncodeString(FormSourceTypeEnum type, Long formId, String customerName) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, NoSuchProviderException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidKeySpecException {
        return getEncodeString(String.valueOf(type.getKey()), formId.toString(), customerName);
    }

    public static String getEncodeString(String type, String formId, String customerName) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, NoSuchProviderException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidKeySpecException {
        String sourceType = type + "::" + formId + "::" + customerName;
        sourceType = DesUtil.encode(sourceType, "[oy8;h;flegku$324@jlfj2o93893/fdfrh024ufoklsdro");
        return sourceType;
    }

    public static boolean isSameCustomName(String sourceStr, Long formId, String customerName) {
        if(isCheckRightForm(customerName) && !isSeeyonForm(customerName)) {
            String[] str;
            try {
                str = decode(sourceStr);
            } catch (Exception var5) {
                System.out.println(formId + "解密失败！");
                return false;
            }

            return validateDecodeObj(str, formId) && customerName.equals(str[2]);
        } else {
            return false;
        }
    }

    public static String updateSourceInfo4CustomName(String sourceStr, String customerName) throws Exception {
        String[] str;
        try {
            str = decode(sourceStr);
        } catch (Exception var4) {
            System.out.println(sourceStr + "解密失败！");
            return sourceStr;
        }

        return getEncodeString(str[0], str[1], customerName);
    }

    private static String[] decode(String sourceType) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException, NoSuchProviderException, NoSuchPaddingException, InvalidKeySpecException {
        if(sourceType != null && !"".equals(sourceType.trim())) {
            String str = DesUtil.decode(sourceType, "[oy8;h;flegku$324@jlfj2o93893/fdfrh024ufoklsdro");
            String[] source = null;
            if(str != null && str.contains("::")) {
                source = str.split("::");
            }

            return source;
        } else {
            return null;
        }
    }

    public static int getUsedNum() {
        return app_used_number;
    }

    public static int getTotalNum() {
        return app_limit_number;
    }

    public static int getAllowNum() {
        return getTotalNum() - getUsedNum();
    }

    public static boolean isAllowAdd() {
        return isAllowAdd(1);
    }

    public static boolean isAllowAdd(int addNum) {
        boolean b = false;
        int allNum = getAllowNum();
        if(addNum <= allNum) {
            b = true;
        }

        return b;
    }

    public static synchronized void modifyUsedCount(BizOperationEnum4 operation) {
        app_used_number += operation.getAddCount();
        if(app_used_number < 0) {
            app_used_number = 0;
        }

    }

    public static FormSourceTypeEnum getCreateSourceType(BizOperationEnum4 operation) {
        boolean b = ((Boolean)ReflectUtil.invokeMethod("com.seeyon.ctp.common.SystemEnvironment", "isDevOrTG", (Object)null, (Class[])null, (Object[])null)).booleanValue();
        FormSourceTypeEnum result;
        if(b) {
            result = operation.getType4TG();
        } else {
            result = operation.getType4Normal();
        }

        return result;
    }

    public static boolean isEffectNum(String sourceStr, Long formId) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException, NoSuchProviderException, NoSuchPaddingException, InvalidKeySpecException {
        return isAddUsedCount(sourceStr, formId);
    }
}
