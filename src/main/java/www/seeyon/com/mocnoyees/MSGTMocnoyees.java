//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package www.seeyon.com.mocnoyees;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import www.seeyon.com.mocnoyees.Enums.ErrorCode;
import www.seeyon.com.mocnoyees.Enums.UserTypeEnum;
import www.seeyon.com.utils.*;

import java.io.*;
import java.util.*;

public class MSGTMocnoyees extends LinkedHashMap implements Serializable {
    private static final long serialVersionUID = 2762981159058645565L;
    private static final String ORIGINAL_CHARSET = "ISO8859-1";
    private static final String FILE_CHARSET = "UTF-8";
    private transient LRWMMocnoyees lrwmMocnoyees;

    public MSGTMocnoyees(LRWMMocnoyees o) throws DogException {
        this.lrwmMocnoyees = null;
        String dogMsg = o.lrwmmocnoyeesb();
        String modules = o.lrwmmocnoyeesc();
        if(modules != null && modules.length() != 0) {
            modules = RSMocnoyees.getModules(modules);
            dogMsg = msgmocnoyeesdl(dogMsg, modules);
            this.msgmocnoyees(dogMsg);
            this.lrwmMocnoyees = o;
            this.checkLicense();
        } else {
            throw new DogException(ErrorCode.error_1013.getError());
        }
    }

    public MSGTMocnoyees(String s) throws DogException {
        this(s, true);
    }

    public MSGTMocnoyees(String s, boolean needCheck) throws DogException {
        this.lrwmMocnoyees = null;
        this.msgmocnoyees(s);
        if(needCheck) {
            this.checkLicense();
        }

    }

    public void checkLicense() throws DogException {

        String limitUseDate = this.methodh("");
        if(limitUseDate != null && limitUseDate.length() > 0 && !limitUseDate.equals("-1")) {
            Date d = DateUtil.toDate(limitUseDate, "yyyy-MM-dd");
            Date currentDate = this.now();
            if(currentDate.after(d)) {
                System.out.println(ErrorCode.error_3005.getError() + "  " + limitUseDate);
                stop();
                throw new DogException(ErrorCode.error_3005.getError());
            }
        }

        String isNeedBindDB = this.methodm("");
        if(isNeedBindDB != null && isNeedBindDB.length() > 0 && isNeedBindDB.equals("1")) {
            System.out.println(ErrorCode.error_3007.getError());
            stop();
            throw new DogException(ErrorCode.error_3007.getError());
        }
    }

    public Date now() throws DogException {
        Date currentDate = new Date();
        if(this.lrwmMocnoyees != null) {
            currentDate = this.lrwmMocnoyees.now();
        }

        return currentDate;
    }

    public static void stop() {
        Thread t = new Thread() {
            public void run() {
                try {
                    Thread.sleep(15000L);
                    System.exit(-1);
                } catch (Exception var2) {
                    ;
                }

            }
        };
        t.start();
    }

    static String msgmocnoyeesdl(String msg, String m) throws DogException {
        return RSMocnoyees.mocnoyeesdl(msg, m);
    }

    private void msgmocnoyees(String s) throws DogException {
        if(s != null && s.trim().length() != 0) {
            String splitStr = ",AH:";
            int ahIndex = s.indexOf(splitStr);
            int splitIndex = s.indexOf(",", ahIndex + splitStr.length());
            String productInfoCodeStr = null;
            String moduleStr = null;
            if(splitIndex == -1) {
                productInfoCodeStr = s;
            } else {
                productInfoCodeStr = s.substring(0, splitIndex);
                moduleStr = s.substring(splitIndex + 1);
            }

            String[] fieldCodeStrArray = productInfoCodeStr.split(",");
            String[] var11 = fieldCodeStrArray;
            int var10 = fieldCodeStrArray.length;

            String[] fieldCodeAndValueStr;
            for(int var9 = 0; var9 < var10; ++var9) {
                String fieldCodeStr = var11[var9];
                fieldCodeAndValueStr = fieldCodeStr.split(":");
                String fieldCode = fieldCodeAndValueStr[0];
                if(fieldCodeAndValueStr.length == 1) {
                    this.put(fieldCode, "");
                } else {
                    this.put(fieldCode, fieldCodeAndValueStr[1]);
                }
            }

            if(moduleStr != null) {
                String[] moduleKeyValueStrArray = moduleStr.split(",");
                fieldCodeAndValueStr = moduleKeyValueStrArray;
                int var18 = moduleKeyValueStrArray.length;

                for(var10 = 0; var10 < var18; ++var10) {
                    String moduleKeyValueStr = fieldCodeAndValueStr[var10];
                    String[] moduleKeyValue = moduleKeyValueStr.split(":");
                    String moduleCode = moduleKeyValue[0];
                    String moduleSublisence = moduleKeyValue[1];
                    this.put(moduleCode, moduleSublisence);
                }
            }

        } else {
            LoggerUtil.print("dogMessage为空！");
            throw new RuntimeException("dogMessage为空！");
        }
    }

    public String showMessage(String messageDataFileFullPath) {
        String msg = "";

        try {
            String fileContent = FileUtil.readTextFile(messageDataFileFullPath);
            Properties ps = StringUtil.getProperties(fileContent);
            msg = this.showMessage(ps);
        } catch (Exception var5) {
            var5.printStackTrace();
        }

        return msg;
    }

    public String showMessage(Properties ps) {
        StringBuffer piStrBuf = new StringBuffer();
        StringBuffer mdStrBuf = new StringBuffer();

        try {
            Collection<String> keys = this.keySet();
            Iterator var6 = keys.iterator();

            while(true) {
                while(var6.hasNext()) {
                    String key = (String)var6.next();
                    String value = (String)this.get(key);
                    String valueString;
                    String keyValueStr;
                    if(key.startsWith("A")) {
                        valueString = ps.getProperty(key);
                        piStrBuf.append(valueString + ":");
                        if(!key.equals("AF") && !key.equals("AO")) {
                            if(key.equals("AD")) {
                                keyValueStr = value;
                                if(this.get("AE").toString().startsWith("V7")) {
                                    keyValueStr = "A8V5".equals(value)?"A8+":("A6V5".equals(value)?"A6+":value);
                                }

                                piStrBuf.append(keyValueStr);
                            } else if(value != null && value.trim().length() != 0) {
                                keyValueStr = ps.getProperty(key + value);
                                if(keyValueStr != null && keyValueStr.length() > 0) {
                                    if(keyValueStr != null && keyValueStr.trim().length() != 0) {
                                        piStrBuf.append(keyValueStr);
                                    } else {
                                        piStrBuf.append(value);
                                    }
                                } else {
                                    piStrBuf.append(value);
                                }
                            } else {
                                piStrBuf.append("");
                            }
                        } else {
                            keyValueStr = ps.getProperty(value);
                            piStrBuf.append(keyValueStr);
                        }

                        piStrBuf.append(System.getProperty("line.separator"));
                    } else if(key.startsWith("B") && !key.startsWith("BI")) {
                        valueString = ps.getProperty(key);
                        if(value.length() >= 6 && value.startsWith("base64")) {
                            value = value.substring(6);
                            value = Base64Util.decode(value);
                        }

                        piStrBuf.append(valueString + ":" + value);
                    } else {
                        valueString = this.methodc("productLine");
                        keyValueStr = ps.getProperty(valueString + "-" + key);
                        if(!value.startsWith("-")) {
                            mdStrBuf.append("插件名称: ").append(keyValueStr);
                            mdStrBuf.append(System.getProperty("line.separator"));
                            if(!value.equals("1")) {
                                ByteArrayInputStream is = null;

                                try {
                                    is = new ByteArrayInputStream(value.getBytes("UTF-8"));
                                    Document d = XMLUtil.getXMLDocument(is);
                                    Element root = d.getDocumentElement();
                                    NodeList subLisenceList = root.getChildNodes();

                                    for(int i = 0; i < subLisenceList.getLength(); ++i) {
                                        Node lisenceNode = subLisenceList.item(i);
                                        if(lisenceNode instanceof Element) {
                                            Element lisenceNodeElement = (Element)lisenceNode;
                                            Element lisenceNodeKeyElement = (Element)lisenceNodeElement.getElementsByTagName("key").item(0);
                                            Element lisenceNodeValueElement = (Element)lisenceNodeElement.getElementsByTagName("value").item(0);
                                            String lisenceNodeKey = XMLUtil.getNodeText(lisenceNodeKeyElement);
                                            String lisenceNodeValue = XMLUtil.getNodeText(lisenceNodeValueElement);
                                            String valueOfLisenceNodeKey = ps.getProperty(lisenceNodeKey);
                                            if("base64".equals(lisenceNodeValue)) {
                                                lisenceNodeValue = "";
                                            }

                                            if(lisenceNodeValue.length() >= 6 && lisenceNodeValue.startsWith("base64")) {
                                                lisenceNodeValue = lisenceNodeValue.substring(6);
                                                lisenceNodeValue = Base64Util.decode(lisenceNodeValue);
                                            }

                                            if(!"".equals(lisenceNodeKey)) {
                                                mdStrBuf.append("                  ").append(valueOfLisenceNodeKey).append(":").append(lisenceNodeValue);
                                                mdStrBuf.append(System.getProperty("line.separator"));
                                            }
                                        }
                                    }
                                } catch (UnsupportedEncodingException var34) {
                                    LoggerUtil.printException(var34);
                                    throw var34;
                                } catch (Exception var35) {
                                    LoggerUtil.print(var35.toString());
                                    throw new RuntimeException(var35);
                                } finally {
                                    if(is != null) {
                                        try {
                                            is.close();
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

                return piStrBuf + System.getProperty("line.separator") + mdStrBuf;
            }
        } catch (FileNotFoundException var37) {
            LoggerUtil.printException(var37);
            throw new RuntimeException(var37);
        } catch (IOException var38) {
            LoggerUtil.printException(var38);
            throw new RuntimeException(var38);
        }
    }

    String get(byte[] b) {
        String key = new String(b);
        String str = (String)super.get(key);
        if(str != null && str.length() >= 6 && str.startsWith("base64")) {
            str = str.substring(6);
            str = Base64Util.decode(str);
        }

        return str;
    }

    String methoda(String s) {
        byte[] b = new byte[]{65, 67};
        return this.get(b);
    }

    String methodb(String s) {
        byte[] b = new byte[]{65, 66};
        return this.get(b);
    }

    String methodc(String s) {
        byte[] b = new byte[]{65, 68};
        return this.get(b);
    }

    String methodd(String s) {
        byte[] b = new byte[]{65, 70};
        return this.get(b);
    }

    String methode(String s) {
        byte[] b = new byte[]{65, 69};
        return this.get(b);
    }

    String methodf(String s) {
        byte[] b = new byte[]{65, 79};
        return this.get(b);
    }

    String methodg(String s) {
        byte[] b = new byte[]{65, 80};
        return this.get(b);
    }

    String methodh(String s) {
        byte[] b = new byte[]{65, 72};
        return this.get(b);
    }

    String methodi(String s) {
        byte[] b = new byte[]{65, 73};
        return this.get(b);
    }

    String methodj(String s) {
        byte[] b = new byte[]{65, 71};
        String str = this.get(b);
        String userType = String.valueOf(UserTypeEnum.internal.getKey());
        if(this.methoda("").equals(userType)) {
            str = "10";
        }

        return str;
    }

    String methodk(String s) {
        byte[] b = new byte[]{65, 65};
        return this.get(b);
    }

    String methodl(String s) {
        byte[] b = new byte[]{65, 74};
        return this.get(b);
    }

    String methods(String s) {
        byte[] b = new byte[]{65, 83};
        return this.get(b);
    }

    String methodm(String s) {
        byte[] b = new byte[]{65, 77};
        return this.get(b);
    }

    String methodn(String s) {
        byte[] b = new byte[]{65, 76};
        return this.get(b);
    }

    String methodo(String s) {
        byte[] b = new byte[]{65, 75};
        return this.get(b);
    }

    String methodp(String s) {
        byte[] b = new byte[]{66, 65};
        return this.get(b);
    }

    String methodq(String s) {
        byte[] b = new byte[]{65, 82};
        return this.get(b) == null?"0":this.get(b);
    }

    String methodz(String s) {
        byte[] b = s.getBytes();
        return this.get(b);
    }

    boolean methodzz(String s) {
        String userType = String.valueOf(UserTypeEnum.internal.getKey());
        if(userType.equals(this.methoda(""))) {
            return true;
        } else {
            boolean returnValue = false;
            byte[] b = s.getBytes();
            String str = this.get(b);
            if(str != null && str.length() > 0) {
                str = str.startsWith("-")?str.substring(1).trim():str;
                if(str != null && str.length() > 0 && !str.equals("0")) {
                    returnValue = true;
                }
            }

            return returnValue;
        }
    }
}
