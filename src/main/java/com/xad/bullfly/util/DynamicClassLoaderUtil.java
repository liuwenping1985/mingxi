package com.xad.bullfly.util;

import javax.tools.*;
import java.io.IOException;
import java.lang.reflect.Method;
import java.net.URI;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Created by liuwenping on 2020/9/9.
 */
public class DynamicClassLoaderUtil {

    public static void main(String[] args) throws Exception {
        String clsName = "Hello";
        String sourceStr = "public class Hello{    public String sayHello (String name) {return \"Hello,\" + name + \"!\";}}";

        JavaFileObject jfo = new StringJavaObject(clsName, sourceStr);
        JavaCompiler cmp = ToolProvider.getSystemJavaCompiler();
        StandardJavaFileManager fm = cmp.getStandardFileManager(null, null, Charset.forName("utf-8"));
        List<JavaFileObject> jfos = Arrays.asList(jfo);
        List<String> options = new ArrayList<>();
        // /Users/liuwenping/Documents/wmm/mingxi/target/classes
        options.addAll(Arrays.asList("-d","/Users/liuwenping/Documents/wmm/mingxi/target/classes/"));
        JavaCompiler.CompilationTask task = cmp.getTask(null, fm, null, options,null,jfos);
        if(task.call()){
            Class cls = Class.forName(clsName);
            Object object = cls.newInstance();
            Method method =cls.getMethod("sayHello",String.class);
            Object returnValue = method.invoke(object,"dynamic compiler");
            System.out.println(returnValue);

        }

    }

    static class StringJavaObject extends SimpleJavaFileObject {
        //源代码
        private String content = "";

        //遵循Java规范的类名及文件
        public StringJavaObject(String _javaFileName, String _content) {
            super(_createStringJavaObjectUri(_javaFileName), JavaFileObject.Kind.SOURCE);
            content = _content;
        }

        //产生一个URL资源路径
        private static URI _createStringJavaObjectUri(String name) {
            //注意此处没有设置包名
            return URI.create("String:///" + name + Kind.SOURCE.extension);
        }

        //文本文件代码
        @Override
        public CharSequence getCharContent(boolean ignoreEncodingErrors)
                throws IOException {
            return content;
        }
    }
}
