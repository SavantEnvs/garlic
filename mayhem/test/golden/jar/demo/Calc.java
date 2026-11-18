/*
 * Decompiled by Garlic
 * Version: 1.8
 */ 
package demo;

import java.util.Iterator;
import java.util.ArrayList;
import java.util.function.Consumer;
import java.io.PrintStream;

// class: demo/Calc
public class Calc {
    final private int base;
    final private static String NAME;

    public Calc(int i0) {
        super();
        this.base = i0;
    }

    public int fib(int i0) {
        if (i0 < 2) {
            return i0;
        }
        else {
            int i5 = 0;
            int i6 = 1;
            for (int i3 = 2; i3 <= i0; i3 += 1) {
                int i4 = i5 + i6;
                i5 = i6;
            }
            return i4 + this.base;
        }
    }

    public String classify(int i0) {
        switch(i0) {
            case 0: {
                return "zero";
            }
            case 1: {
                return "one";
            }
            case 2: {
                return "two";
            }
            default: {
                if (i0 < 0) {
                    return "negative";
                }
                else {
                    return "many";
                }
            }
        }
    }

    public int sum(List<Integer> list) {
        int i0 = 0;
        for (Iterator iterator = list.iterator(); iterator.hasNext(); i0 += integer.intValue()) {
            Integer integer = (Integer)iterator.next();
        }
        return i0;
    }

    public int safeDiv(int i0, int i1) {
        try {
            int i2 = i0 / i1;
            System.out.println("calc");
            return i2;
        }
        catch (ArithmeticException var_3_1) {
            int i3 = -1;
            System.out.println("calc");
            return i3;
        }
        finally {
            Throwable throwable = v_7;
            System.out.println("calc");
            throw throwable;
        }
    }

    public List<String> names(int i0) {
        ArrayList list = new ArrayList();
        for (int i1 = 0; i1 < i0; i1 += 1) {
            list.add(new StringBuilder().append("n").append(i1).toString());
        }
        list.forEach((str0) -> {
            System.out.println(str0.length());
        });
        return list;
    }

    public double avg(double[] doubleArr) {
        double dbl0 = 0.000000;
        for (int i1 = 0; i1 < doubleArr.length; i1 += 1) {
            double dbl1 = doubleArr[i1];
            dbl0 += dbl1;
        }
        if (doubleArr.length == 0) {
            return 0.000000;
        }
        else {
            return dbl0 / (double)doubleArr.length;
        }
    }

    private static /* synthetic */ void lambda$names$0(String str0) {
        System.out.println(str0.length());
    }

    // class: demo/Calc$Inner
    public class Calc$Inner {

        public Calc$Inner() {
            super();
        }

        public long mul(long l1, long l3) {
            return l1 * l3;
        }

    }
}
