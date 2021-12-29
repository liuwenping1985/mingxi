//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.common.init;

import com.seeyon.ctp.util.Base64;
import com.seeyon.ctp.util.IOUtility;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import www.seeyon.com.mocnoyees.RSMocnoyees;
import www.seeyon.com.utils.Base64Util;

public class Xcyskm extends ClassLoader {
    private static final List<String> seekretList = new ArrayList();

    static {
        seekretList.add("com.seeyon.ctp.common.init.SystemLoader");
        seekretList.add("com.seeyon.ctp.common.plugin.PluginSystemInit");
//        seekretList.add("com.seeyon.ctp.login.LoginHelper");
//        seekretList.add("com.seeyon.ctp.product.ProductInfo");
        seekretList.add("com.seeyon.ctp.permission.bo.LicensePerInfo");
        seekretList.add("com.seeyon.v3x.dee.context.EngineController");
        seekretList.add("com.seeyon.apps.mplus.a.v.a");
    }

    public Xcyskm(ClassLoader parent) {
        super(parent);
    }

    public Class<?> loadClass(String className) throws ClassNotFoundException {
        return this.loadClass(className, false);
    }

    protected Class<?> loadClass(String name, boolean resolve) throws ClassNotFoundException {
        Class<?> foundClass = this.findLoadedClass(name);
        if(foundClass != null) {
            return foundClass;
        } else {
            if(seekretList.contains(name)) {
                try {
                    foundClass = this.findClass(name);
                } catch (Exception var5) {
                    ;
                }
            } else {
                foundClass = super.loadClass(name, resolve);
                if(foundClass != null) {
                    return foundClass;
                }
            }

            if(resolve && foundClass != null) {
                this.resolveClass(foundClass);
            }

            return foundClass;
        }
    }

    public Class<?> findClass(String className) throws ClassNotFoundException {
        byte[] classData = null;

        try {
            classData = this.loadClassData(className);
        } catch (Throwable var4) {
            ;
        }

        if(classData == null) {
            return null;
        } else {
            Class c = this.defineClass(className, classData, 0, classData.length);
            return c;
        }
    }

    public byte[] loadClassData(String className) throws IOException {
        String res = className.replace('.', '/').concat(".class");
        InputStream is = this.getResourceAsStream(res);
        byte[] classData = IOUtility.toByteArray(is);
        if(seekretList.contains(className)) {
            try {
                byte[] datas = Base64.decodeBase64(classData);
                classData = RSMocnoyees.decode(RSMocnoyees.getPublicKey("65537", Base64Util.decode("Nzg4NDM2MTAxMzc1NzA0MDQ1Nzc3ODQ3MzM0OTg2NzgxNjEzNDM5Mzg5OTMyODA2ODcwNDQ0Nzk4NDIyODE2MTk0MTEzMzA2NDcyNjkzNTQzMDg4NjUyODc4NDA0NjUwMDEwMDAyNjI0ODQ4NjMxMzA3MjgzMTc4NzE1ODYzMjE1OTYzMDY3NDkwNTYzNDc1NTg0ODM0NzU1NzQ5MDI2NDkyMDk5NTUyMTIzNDAyOTA2NDIyMzgzMTQ1ODUzMjc3OTM4MDQxMDQ5MTU5NzczOTk0ODY3NzA5NzYwMjQzMDcwNTQzMjA3")), datas, 96);
            } catch (Throwable var6) {
                return null;
            }
        }

        return classData;
    }
    public static  void main(String[] args){

        System.out.println("test 123");
    }
}
