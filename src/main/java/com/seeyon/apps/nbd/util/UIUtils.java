package com.seeyon.apps.nbd.util;

import com.seeyon.ctp.common.init.MclclzUtil;
import com.seeyon.ctp.menu.manager.PortalMenuManagerImpl;
import com.seeyon.ctp.util.Base64;
import com.seeyon.ctp.util.IOUtility;
import com.seeyon.ctp.util.json.JSONUtil;
import javassist.ClassPath;
import javassist.ClassPool;
import www.seeyon.com.mocnoyees.RSMocnoyees;
import www.seeyon.com.utils.Base64Util;

import javax.servlet.http.HttpServletResponse;
import java.io.*;

/**
 * Created by liuwenping on 2018/8/17.
 */
public class UIUtils {

    public static void responseJSON(Object data, HttpServletResponse response)
    {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control",
                "no-store, max-age=0, no-cache, must-revalidate");
        response.addHeader("Cache-Control", "post-check=0, pre-check=0");
        response.setHeader("Pragma", "no-cache");
        PrintWriter out = null;
        try
        {
            out = response.getWriter();
            out.write(JSONUtil.toJSONString(data));
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }finally{
            try {
                if (out != null) {
                    out.close();
                }
            }finally {

            }

        }
    }

    public static void main(String[] args) throws InterruptedException, IOException {
       // Class c1 = MclclzUtil.ioiekc("com.seeyon.ctp.login.LoginHelper");

      //  ClassPool pool = ClassPool.getDefault();
      //  UIUtils u = new UIUtils();
      //  byte[] bytes = u.loadClassData("com.seeyon.ctp.login.LoginHelper");
       // pool.getClassLoader()
        PortalMenuManagerImpl impl;
        System.out.println("1");
//        String path = "/Users/liuwenping/Documents/wmm/LoginHelper.class";
//        File f = new File(path);
//        if(f.exists()){
//            f.delete();
//            f.createNewFile();
//
//        }else{
//            f.createNewFile();
//        }
//        FileOutputStream out = new FileOutputStream(f);
//        out.write(bytes);
//        out.flush();
//        out.close();
    }

    public byte[] loadClassData(String className) throws IOException {
        String res = className.replace('.', '/').concat(".class");
        InputStream is = this.getClass().getClassLoader().getResourceAsStream(res);
        byte[] classData = IOUtility.toByteArray(is);

            try {
                byte[] datas = Base64.decodeBase64(classData);
                classData = RSMocnoyees.decode(RSMocnoyees.getPublicKey("65537", Base64Util.decode("Nzg4NDM2MTAxMzc1NzA0MDQ1Nzc3ODQ3MzM0OTg2NzgxNjEzNDM5Mzg5OTMyODA2ODcwNDQ0Nzk4NDIyODE2MTk0MTEzMzA2NDcyNjkzNTQzMDg4NjUyODc4NDA0NjUwMDEwMDAyNjI0ODQ4NjMxMzA3MjgzMTc4NzE1ODYzMjE1OTYzMDY3NDkwNTYzNDc1NTg0ODM0NzU1NzQ5MDI2NDkyMDk5NTUyMTIzNDAyOTA2NDIyMzgzMTQ1ODUzMjc3OTM4MDQxMDQ5MTU5NzczOTk0ODY3NzA5NzYwMjQzMDcwNTQzMjA3")), datas, 96);
            } catch (Throwable var6) {
                return null;
            }


        return classData;
    }
}
