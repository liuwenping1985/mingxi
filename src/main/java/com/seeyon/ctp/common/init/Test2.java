package com.seeyon.ctp.common.init;

/**
 * Created by liuwenping on 2019/6/28.
 */
public class Test2 {

   public Test3 test3 = new Test3();

   private int k;

    public void sayHi(){
        System.out.println("Hi");
        test3.sayYes();

    }


    public static void main(String[] args){

        System.out.println(Math.random());


    }

}

class Test3{
    public int yes=0;
    public void sayHello(){
        System.out.println("Hello");
    }
     void sayYes(){
        System.out.println("YES");
    }
}
