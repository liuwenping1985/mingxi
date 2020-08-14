package com.xad.weboffice.demo.testjava8;

import java.util.*;
import java.util.function.Function;

/**
 * :: 可以理解为方法引用
 * Created by liuwenping on 2020/8/13.
 */
public class DoubleColons {

    static String yes() {

        return "yes";
    }
    static String yes(String yes) {

        return "yes:"+yes;
    }
    static void nonono() {
        System.out.println("nonono");
    }
    @FunctionalInterface
    interface GenDataStructer<M extends Collection> {

        M newDataStructer();
    }

    @FunctionalInterface
    interface IConvert<F, T> {

        T convert(F form);
    }
    @FunctionalInterface
    interface NoPrint{

        void print();
    }

    /**
     * Method References
     You use lambda expressions to create anonymous methods. Sometimes, however, a lambda expression does nothing but call an existing method. In those cases, it’s often clearer to refer to the existing method by name. Method references enable you to do this; they are compact, easy-to-read lambda expressions for methods that already have a name.
     * @param args
     */
    public static void main(String[] args) {

        //IConvert<String,String> convert = DoubleColons::yes;
        NoPrint p = DoubleColons::nonono;

        p.print();


        GenDataStructer<List<String>> gds = ArrayList<String>::new;
        /*上述写法等价于下边*/
//        NoPrint p2 = new NoPrint() {
//            @Override
//            public void print() {
//                DoubleColons.nonono();
//            }
//        };
//        p2.print();
        List<String> list = gds.newDataStructer();


    }
}
