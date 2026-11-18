/*
 * Decompiled by Garlic
 * Version: 1.8
 */ 
package demo;

import java.util.List;

// class: demo/Main
public class Main {

    public Main() {
        super();
    }

    public static void main(String[] stringArr) {
        Calc calc = new Calc(i0);
        int i0 = 3;
        System.out.println(calc.fib(10));
        int i1 = 2;
        System.out.println(calc.classify(i1));
        Integer integer = new Integer[i0];
        int i2 = 1;
        int i3 = 0;
        integer[i3] = Integer.valueOf(i2);
        integer[i2] = Integer.valueOf(i1);
        integer[i1] = Integer.valueOf(i0);
        System.out.println(calc.sum(Arrays.asList(integer)));
        System.out.println(calc.safeDiv(4, i3));
        System.out.println(new Calc$Inner().mul(6L, 7L));
        new Runnable() {

                Main$1() {
                    super();
                }

                public void run() {
                    System.out.println("anon");
                }

        }.run();
    }

}
