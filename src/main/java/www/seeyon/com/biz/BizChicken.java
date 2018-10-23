//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package www.seeyon.com.biz;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.spec.InvalidKeySpecException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import www.seeyon.com.biz.enums.BizOperationEnum;
import www.seeyon.com.biz.enums.FormSourceTypeEnum;
import www.seeyon.com.utils.Base64Util;
import www.seeyon.com.utils.DesUtil;
import www.seeyon.com.utils.ReflectUtil;

public class BizChicken {
    public static final int no_limit = -1;
    private static final int _$7 = 10;
    private static final int _$6 = 0;
    private static int _$5 = 0;
    private static int _$4 = 10;
    private static int _$3 = 0;
    private static final String _$2 = "::";
    private static final String _$1 = "[oy8;h;flegku$324@jlfj2o93893/fdfrh024ufoklsdro";

    public BizChicken() {
    }

    public static void main(String[] var0) {
        try {
            _$1("279119AE5ABE5F1CF44762558DF01B7B7C7B128B813FFD3EF3F30080F8E8FC7E5CC0524C0AE786EE");
        } catch (Exception var2) {
            var2.printStackTrace();
        }

    }

    public static List<Long> initUsedCount(List<Map<String, Object>> var0) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException, NoSuchProviderException, NoSuchPaddingException, InvalidKeySpecException {
        boolean var1 = ((Boolean)ReflectUtil.invokeMethod("com.seeyon.ctp.common.SystemEnvironment", "isDevOrTG", (Object)null, (Class[])null, (Object[])null)).booleanValue();
        _$1(var1);
        return _$1(var1, var0);
    }

    private static void _$1(boolean var0) {
        if(var0) {
            _$4 = -1;
        } else {
            String var1 = null;
            boolean var2 = ((Boolean)ReflectUtil.invokeMethod("com.seeyon.ctp.common.AppContext", "hasPlugin", (Object)null, new Class[]{String.class}, new String[]{"formBiz"})).booleanValue();
            if(!var2) {
                _$4 = 0;
            } else {
                var1 = (String)ReflectUtil.invokeMethod("com.seeyon.ctp.common.AppContext", "getPlugin", (Object)null, new Class[]{String.class}, new String[]{"formBiz.formBiz1"});

                try {
                    if(null == var1) {
                        _$4 = 10;
                        System.out.println(_$6("6Kej5p6Q5oC75Lqn6IO95byC5bi477yM5L2/55So6buY6K6k5Lqn6IO9MTA="));
                    } else {
                        _$4 = Integer.parseInt(var1.trim());
                    }
                } catch (Exception var4) {
                    _$4 = 10;
                    System.out.println(_$6("5pWw5a2X5qC85byP5YyW5aSx6LSl77yM5ZWG5Yqh5b2V5YWl55qE5L+h5oGv5pyJ6ZSZ6K+v"));
                }
            }
        }

    }

    private static List<Long> _$1(boolean var0, List<Map<String, Object>> var1) throws BadPaddingException, NoSuchPaddingException, NoSuchAlgorithmException, IllegalBlockSizeException, UnsupportedEncodingException, NoSuchProviderException, InvalidKeyException, InvalidKeySpecException {
        ArrayList var2 = null;
        if(!var0) {
            var2 = new ArrayList();
            ArrayList var3 = new ArrayList();
            ArrayList var4 = new ArrayList();
            _$1(var1, var4, var3, var2);
            List var5;
            if(var4.size() > getAllowNum()) {
                var5 = var4.subList(getAllowNum(), var4.size());
                var2.addAll(var5);
                var2.addAll(var3);
                _$3 = getAllowNum();
            } else {
                int var6 = getAllowNum() - var4.size();
                if(var6 > 0) {
                    if(var3.size() > var6) {
                        var5 = var3.subList(var6, var3.size());
                        var2.addAll(var5);
                        _$3 = getAllowNum();
                    } else {
                        _$3 = var4.size() + var3.size();
                    }
                } else {
                    _$3 = getAllowNum();
                    var2.addAll(var3);
                }
            }
        }

        return var2;
    }

    private static void _$1(List<Map<String, Object>> var0, List<Long> var1, List<Long> var2, List<Long> var3) throws BadPaddingException, NoSuchPaddingException, NoSuchAlgorithmException, IllegalBlockSizeException, UnsupportedEncodingException, NoSuchProviderException, InvalidKeyException, InvalidKeySpecException {
        String var4 = BizEgg.getCustomerName();
        Iterator var5 = var0.iterator();

        while(var5.hasNext()) {
            Map var6 = (Map)var5.next();
            Long var7 = (Long)var6.get("id");
            String var8 = (String)var6.get("sourceType");
            Integer var9 = (Integer)var6.get("useFlag");
            String[] var10 = _$1(var8);
            if(!_$1(var10, var7)) {
                var3.add(var7);
            } else if(_$5(var10[2])) {
                if(var9.intValue() == 1) {
                    if(_$1(var10, var7, false)) {
                        if(var4.equals(var10[2])) {
                            var1.add(var7);
                        } else {
                            var2.add(var7);
                        }
                    } else if(!var4.equals(var10[2])) {
                        var3.add(var7);
                    }
                }

                if(var9.intValue() == 0) {
                    if(_$2(var10, var7)) {
                        ++_$5;
                    }

                    if(!_$1(var10, var7, false) && !var4.equals(var10[2])) {
                        var3.add(var7);
                    }
                }
            }
        }

    }

    private static String _$6(String var0) {
        return Base64Util.decode(var0);
    }

    private static boolean _$2(String var0, Long var1) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException, NoSuchProviderException, NoSuchPaddingException, InvalidKeySpecException {
        String[] var2 = _$1(var0);
        return _$1(var2, var1, true);
    }

    private static boolean _$5(String var0) {
        return !_$2(var0) && !_$3(var0);
    }

    private static boolean _$4(String var0) {
        return "致远内部".equals(var0);
    }

    private static boolean _$3(String var0) {
        return "公有蛋".equals(var0);
    }

    private static boolean _$2(String var0) {
        return (FormSourceTypeEnum.create_form_upgrade.getKey() + "").equals(var0);
    }

    private static boolean _$1(String[] var0, Long var1, boolean var2) {
        if(!_$1(var0, var1)) {
            return true;
        } else {
            FormSourceTypeEnum var3 = getFormSourceType(var0, var1);
            boolean var4 = var3.isEffectNum();
            if(!var4 && var2 && _$5(var0[2])) {
                String var5 = BizEgg.getCustomerName();
                var4 = !var5.equals(var0[2]);
            }

            return var4;
        }
    }

    private static boolean _$2(String[] var0, Long var1) {
        FormSourceTypeEnum var2 = getFormSourceType(var0, var1);
        return var2.isEffectNum4Update();
    }

    public static FormSourceTypeEnum getFormSourceType(String var0, Long var1) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException, NoSuchProviderException, NoSuchPaddingException, InvalidKeySpecException {
        String[] var2 = _$1(var0);
        return getFormSourceType(var2, var1);
    }

    public static FormSourceTypeEnum getFormSourceType(String[] var0, Long var1) {
        if(!_$1(var0, var1)) {
            return FormSourceTypeEnum.create_form_custom;
        } else {
            String var2 = var0[0];
            return FormSourceTypeEnum.getTypeByKey(Integer.parseInt(var2));
        }
    }

    private static boolean _$1(String var0, Long var1) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException, NoSuchProviderException, NoSuchPaddingException, InvalidKeySpecException {
        String[] var2 = _$1(var0);
        return _$1(var2, var1);
    }

    private static boolean _$1(String[] var0, Long var1) {
        if(var0 != null && var0.length == 3) {
            if(!var1.toString().equals(var0[1])) {
                System.out.println(_$6("SUTkuI3ljLnphY3vvIzmnInmi7fotJ3lq4znlpHvvIznrpfkvZzlt7LnlKg="));
                return false;
            } else {
                return true;
            }
        } else {
            System.out.println(_$6("6Kej5a+G5aSx6LSl77yM5pyJ56+h5pS55auM55aR77yM5YGc55So"));
            return false;
        }
    }

    public static String getEncodeString(FormSourceTypeEnum var0, Long var1) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, NoSuchProviderException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidKeySpecException {
        return getEncodeString(var0, var1, var0.getCustomerName());
    }

    public static String getEncodeString(BizEgg var0, Long var1) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, NoSuchProviderException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidKeySpecException {
        FormSourceTypeEnum var2 = var0.getSourceTypeEnum();
        return getEncodeString(var2, var1, var2.getCustomerName(var0));
    }

    public static String getEncodeString(FormSourceTypeEnum var0, Long var1, String var2) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, NoSuchProviderException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidKeySpecException {
        return getEncodeString(var0.getKey() + "", var1.toString(), var2);
    }

    public static String getEncodeString(String var0, String var1, String var2) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, NoSuchProviderException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidKeySpecException {
        String var3 = var0 + "::" + var1 + "::" + var2;
        var3 = DesUtil.encode(var3, "[oy8;h;flegku$324@jlfj2o93893/fdfrh024ufoklsdro");
        return var3;
    }

    public static boolean isSameCustomName(String var0, Long var1, String var2) {
        if(_$5(var2) && !_$4(var2)) {
            String[] var3;
            try {
                var3 = _$1(var0);
            } catch (Exception var5) {
                System.out.println(var1 + "解密失败！");
                return false;
            }

            return _$1(var3, var1) && var2.equals(var3[2]);
        } else {
            return false;
        }
    }

    public static String updateSourceInfo4CustomName(String var0, String var1) throws Exception {
        String[] var2;
        try {
            var2 = _$1(var0);
        } catch (Exception var4) {
            System.out.println(var0 + "解密失败！");
            return var0;
        }

        return getEncodeString(var2[0], var2[1], var1);
    }

    private static String[] _$1(String var0) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException, NoSuchProviderException, NoSuchPaddingException, InvalidKeySpecException {
        if(var0 != null && !"".equals(var0.trim())) {
            String var1 = DesUtil.decode(var0, "[oy8;h;flegku$324@jlfj2o93893/fdfrh024ufoklsdro");
            String[] var2 = null;
            if(var1 != null && var1.contains("::")) {
                var2 = var1.split("::");
            }

            return var2;
        } else {
            return null;
        }
    }

    public static int getUsedNum() {
        return _$3;
    }

    public static int getTotalNum() {
        return 1000;
    }

    public static int getAllowNum() {
        return getTotalNum() - getUsedNum();
    }

    public static boolean isAllowAdd() {
        return isAllowAdd(1);
    }

    public static boolean isAllowAdd(int var0) {
        boolean var1 = false;
        int var2 = getAllowNum();
        if(var0 <= var2) {
            var1 = true;
        }

        return var1;
    }

    public static synchronized void modifyUsedCount(BizOperationEnum var0) {
        _$3 += var0.getAddCount();
        _$5 += var0.getAddUpgradeCount();
        if(_$3 < 0) {
            _$3 = 0;
        }

    }

    public static FormSourceTypeEnum getCreateSourceType(BizOperationEnum var0) {
        boolean var2 = ((Boolean)ReflectUtil.invokeMethod("com.seeyon.ctp.common.SystemEnvironment", "isDevOrTG", (Object)null, (Class[])null, (Object[])null)).booleanValue();
        FormSourceTypeEnum var1;
        if(var2) {
            var1 = var0.getType4TG();
        } else {
            var1 = var0.getType4Normal();
        }

        return var1;
    }

    public static boolean isEffectNum(String var0, Long var1) throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException, NoSuchProviderException, NoSuchPaddingException, InvalidKeySpecException {
        return _$2(var0, var1);
    }
}
