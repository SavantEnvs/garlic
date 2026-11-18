/*
 * Decompiled by Garlic
 * Version: 1.8
 */ 
package demo;

import java.io.PrintStream;
import java.util.List;

// class: demo/Main
public class Main {

    public Main() {
        super();
    }

    public static void main(String[] stringArr) {
        Calc calc = new Calc(3);
        System.out.println(calc.fib(10));
        System.out.println(calc.classify(2));
        System.out.println(calc.sum(Arrays.asList(new Integer[]{Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3)})));
        System.out.println(calc.safeDiv(4, 0));
        System.out.println(new Calc$Inner().mul(6L, 7L));
        Main$1 main$1 = new Main$1();
        main$1.run();
    }

}
