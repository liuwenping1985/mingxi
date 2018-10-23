//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package www.seeyon.com.mocnoyees;

import java.io.ByteArrayInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Properties;
import java.util.Set;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import www.seeyon.com.mocnoyees.Enums.ErrorCode;
import www.seeyon.com.mocnoyees.Enums.UserTypeEnum;
import www.seeyon.com.utils.Base64Util;
import www.seeyon.com.utils.DateUtil;
import www.seeyon.com.utils.FileUtil;
import www.seeyon.com.utils.LoggerUtil;
import www.seeyon.com.utils.MacAddressUtil;
import www.seeyon.com.utils.StringUtil;
import www.seeyon.com.utils.XMLUtil;

public class MSGTMocnoyees extends LinkedHashMap {
    private static final long serialVersionUID = 2762981159058645565L;
    private static final String _$2 = "ISO8859-1";
    private static final String _$1 = "UTF-8";

    public MSGTMocnoyees(LRWMMocnoyees var1) throws DogException {
        String var2 = var1.lrwmmocnoyeesb();
        String var3 = var1.lrwmmocnoyeesc();
        if (var3 != null && var3.length() != 0) {
            var3 = RSMocnoyees.getModules(var3);
            var2 = _$1(var2, var3);
            this._$20(var2);
            this.checkLicense();
        } else {
            throw new DogException(ErrorCode.error_1013.getError());
        }
    }

    public MSGTMocnoyees(String var1) throws DogException {
        this._$20(var1);
        this.checkLicense();
    }

    public void checkLicense() throws DogException {
        String var1 = this._$8("");
//        if (var1 != null && var1.length() > 0 && !var1.equals("0") && !var1.equals("1")) {
//            try {
//                if (!MacAddressUtil.checkMac(var1)) {
//                    System.out.println(ErrorCode.error_3001.getError());
//                    stop();
//                    throw new DogException(ErrorCode.error_3001.getError());
//                }
//            } catch (Exception var5) {
//                throw new DogException(ErrorCode.error_1014.getError());
//            }
//        }

//        String var2 = this._$12("");
//        if (var2 != null && var2.length() > 0 && !var2.equals("-1")) {
//            Date var3 = DateUtil.toDate(var2, "yyyy-MM-dd");
//            Date var4 = new Date();
//            if (var4.after(var3)) {
//                System.out.println(ErrorCode.error_3005.getError() + var2);
//                stop();
//                throw new DogException(ErrorCode.error_3005.getError());
//            }
//        }

        String var6 = this._$7("");
        if (var6 != null && var6.length() > 0 && var6.equals("1")) {
            System.out.println(ErrorCode.error_3007.getError());
            stop();
            throw new DogException(ErrorCode.error_3007.getError());
        }
    }

    public static void stop() {
        llllIlIllIIIlIII var0 = new llllIlIllIIIlIII();
        var0.start();
    }

    static String _$1(String var0, String var1) throws DogException {
        return RSMocnoyees._$1(var0, var1);
    }

    private void _$20(String var1) throws DogException {
        if (var1 != null && var1.trim().length() != 0) {
            String var2 = ",AH:";
            int var3 = var1.indexOf(var2);
            int var4 = var1.indexOf(",", var3 + var2.length());
            String var5 = null;
            String var6 = null;
            if (var4 == -1) {
                var5 = var1;
            } else {
                var5 = var1.substring(0, var4);
                var6 = var1.substring(var4 + 1);
            }

            String[] var7 = var5.split(",");
            String[] var8 = var7;
            int var9 = var7.length;

            int var10;
            for(var10 = 0; var10 < var9; ++var10) {
                String var11 = var8[var10];
                String[] var12 = var11.split(":");
                String var13 = var12[0];
                if (var12.length == 1) {
                    this.put(var13, "");
                } else {
                    this.put(var13, var12[1]);
                }
            }

            if (var6 != null) {
                var8 = var6.split(",");
                String[] var16 = var8;
                var10 = var8.length;

                for(int var17 = 0; var17 < var10; ++var17) {
                    String var18 = var16[var17];
                    String[] var19 = var18.split(":");
                    String var14 = var19[0];
                    String var15 = var19[1];
                    this.put(var14, var15);
                }
            }

        } else {
            LoggerUtil.print("dogMessage为空！");
            throw new RuntimeException("dogMessage为空！");
        }
    }

    public String showMessage(String var1) {
        String var2 = "";

        try {
            String var3 = FileUtil.readTextFile(var1);
            Properties var4 = StringUtil.getProperties(var3);
            var2 = this.showMessage(var4);
        } catch (Exception var5) {
            var5.printStackTrace();
        }

        return var2;
    }

    public String showMessage(Properties var1) {
        StringBuffer var2 = new StringBuffer();
        StringBuffer var3 = new StringBuffer();

        try {
            Set var4 = this.keySet();
            Iterator var5 = var4.iterator();

            while(true) {
                while(var5.hasNext()) {
                    String var6 = (String)var5.next();
                    String var7 = (String)this.get(var6);
                    String var8;
                    String var9;
                    if (var6.startsWith("A")) {
                        var8 = var1.getProperty(var6);
                        var2.append(var8 + ":");
                        if (!var6.equals("AF") && !var6.equals("AO")) {
                            if (var7 != null && var7.trim().length() != 0) {
                                var9 = var1.getProperty(var6 + var7);
                                if (var9 != null && var9.length() > 0) {
                                    if (var9 != null && var9.trim().length() != 0) {
                                        var2.append(var9);
                                    } else {
                                        var2.append(var7);
                                    }
                                } else {
                                    var2.append(var7);
                                }
                            } else {
                                var2.append("");
                            }
                        } else {
                            var9 = var1.getProperty(var7);
                            var2.append(var9);
                        }

                        var2.append(System.getProperty("line.separator"));
                    } else if (var6.startsWith("B")) {
                        var8 = var1.getProperty(var6);
                        if (var7.length() >= 6 && var7.startsWith("base64")) {
                            var7 = var7.substring(6);
                            var7 = Base64Util.decode(var7);
                        }

                        var2.append(var8 + ":" + var7);
                    } else {
                        var8 = this._$17("productLine");
                        var9 = var1.getProperty(var8 + "-" + var6);
                        if (!var7.startsWith("-")) {
                            var3.append("模块/插件名称:").append(var9);
                            var3.append(System.getProperty("line.separator"));
                            if (!var7.equals("1")) {
                                ByteArrayInputStream var11 = null;

                                try {
                                    var11 = new ByteArrayInputStream(var7.getBytes("UTF-8"));
                                    Document var12 = XMLUtil.getXMLDocument(var11);
                                    Element var13 = var12.getDocumentElement();
                                    NodeList var14 = var13.getChildNodes();

                                    for(int var15 = 0; var15 < var14.getLength(); ++var15) {
                                        Node var16 = var14.item(var15);
                                        if (var16 instanceof Element) {
                                            Element var17 = (Element)var16;
                                            Element var18 = (Element)((Element)var17.getElementsByTagName("key").item(0));
                                            Element var19 = (Element)((Element)var17.getElementsByTagName("value").item(0));
                                            String var20 = XMLUtil.getNodeText(var18);
                                            String var21 = XMLUtil.getNodeText(var19);
                                            String var22 = var1.getProperty(var20);
                                            var3.append(var22).append(":").append(var21);
                                            var3.append(System.getProperty("line.separator"));
                                        }
                                    }
                                } catch (UnsupportedEncodingException var34) {
                                    LoggerUtil.printException(var34);
                                    throw var34;
                                } catch (Exception var35) {
                                    LoggerUtil.print(var35.toString());
                                    throw new RuntimeException(var35);
                                } finally {
                                    if (var11 != null) {
                                        try {
                                            var11.close();
                                        } catch (IOException var33) {
                                            LoggerUtil.printException(var33);
                                            throw var33;
                                        }
                                    }

                                }
                            }
                        }
                    }
                }

                return var2 + System.getProperty("line.separator") + var3;
            }
        } catch (FileNotFoundException var37) {
            LoggerUtil.printException(var37);
            throw new RuntimeException(var37);
        } catch (IOException var38) {
            LoggerUtil.printException(var38);
            throw new RuntimeException(var38);
        }
    }

    String _$1(byte[] var1) {
        String var2 = new String(var1);
        String var3 = (String)super.get(var2);
        if (var3 != null && var3.length() >= 6 && var3.startsWith("base64")) {
            var3 = var3.substring(6);
            var3 = Base64Util.decode(var3);
        }

        return var3;
    }

    String _$19(String var1) {
        byte[] var2 = new byte[]{65, 67};
        return this._$1(var2);
    }

    String _$18(String var1) {
        byte[] var2 = new byte[]{65, 66};
        return this._$1(var2);
    }

    String _$17(String var1) {
        byte[] var2 = new byte[]{65, 68};
        return this._$1(var2);
    }

    String _$16(String var1) {
        byte[] var2 = new byte[]{65, 70};
        return this._$1(var2);
    }

    String _$15(String var1) {
        byte[] var2 = new byte[]{65, 69};
        return this._$1(var2);
    }

    String _$14(String var1) {
        byte[] var2 = new byte[]{65, 79};
        return this._$1(var2);
    }

    String _$13(String var1) {
        byte[] var2 = new byte[]{65, 80};
        return this._$1(var2);
    }

    String _$12(String var1) {
        byte[] var2 = new byte[]{65, 72};
        return this._$1(var2);
    }

    String _$11(String var1) {
        byte[] var2 = new byte[]{65, 73};
        return this._$1(var2);
    }

    String _$10(String var1) {
        byte[] var2 = new byte[]{65, 71};
        String var3 = this._$1(var2);
        String var4 = String.valueOf(UserTypeEnum.internal.getKey());
        if (this._$19("").equals(var4)) {
            var3 = "10";
        }

        return var3;
    }

    String _$9(String var1) {
        byte[] var2 = new byte[]{65, 65};
        return this._$1(var2);
    }

    String _$8(String var1) {
        byte[] var2 = new byte[]{65, 74};
        return this._$1(var2);
    }

    String _$7(String var1) {
        byte[] var2 = new byte[]{65, 77};
        return this._$1(var2);
    }

    String _$6(String var1) {
        byte[] var2 = new byte[]{65, 76};
        return this._$1(var2);
    }

    String _$5(String var1) {
        byte[] var2 = new byte[]{65, 75};
        return this._$1(var2);
    }

    String _$4(String var1) {
        byte[] var2 = new byte[]{66, 65};
        return this._$1(var2);
    }

    String _$3(String var1) {
        byte[] var2 = new byte[]{65, 82};
        return this._$1(var2) == null ? "0" : this._$1(var2);
    }

    String _$2(String var1) {
        byte[] var2 = var1.getBytes();
        return this._$1(var2);
    }

    boolean _$1(String var1) {
        String var2 = String.valueOf(UserTypeEnum.internal.getKey());
        if (this._$19("").equals(var2)) {
            return true;
        } else {
            boolean var3 = false;
            byte[] var4 = var1.getBytes();
            String var5 = this._$1(var4);
            if (var5 != null && var5.length() > 0) {
                var5 = var5.startsWith("-") ? var5.substring(1).trim() : var5;
                if (var5 != null && var5.length() > 0 && !var5.equals("0")) {
                    var3 = true;
                }
            }

            return var3;
        }
    }
}
