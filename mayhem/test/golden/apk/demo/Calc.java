/*
 * Decompiled by Garlic
 * Version: 1.8
 */ 
package demo;

import java.util.ArrayList;
import java.util.Iterator;

// class: demo/Calc
public class Calc {
    final private static String NAME;
    final private int base;

    public Calc(int i0) {
        super();
        this.base = i0;
    }

    public double avg(double[] doubleArr) {
        synchronized (this) {
            int i0 = doubleArr.length;
            long l0 = 0L;
            long l1 = l0;
            for (int i1 = 0; i1 < i0; i1 += 1) {
                l1 += doubleArr[i1];
            }
            if (doubleArr.length != 0) {
                double dbl0 = (double)doubleArr.length;
            }
            return var_1_1;
        }
    }

    public String classify(int i0) {
        switch(i0) {
            default: {
                if (i0 < 0) {
                    return "negative";
                }
                else {
                    String str0 = "many";
                }
                return str0;
            }
            case 2: {
                return "two";
            }
            case 1: {
                return "one";
            }
            case 0: {
                return "zero";
            }
        }
    }

    public int fib(int i0) {
        int i1 = 2;
        if (i0 < i1) {
            return i0;
        }
        else {
            int i2 = 1;
            int i3 = 0;
            while (i1 <= i0) {
                int i4 = i3 + i2;
                i1 += 1;
                int i5 = i4;
                int i6 = i2;
                i2 = i5;
                continue;
            }
            return i2 + this.base;
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

    public int safeDiv(int i0, int i1) {
        String str0 = "calc";
        try {
            System.out.println(str0);
            return i0 / i1;
        }
        catch (ArithmeticException var_2_2) {
            System.out.println(str0);
            return -1;
        }
        finally {
            System.out.println(str0);
            throw var_2_6;
        }
    }

    public int sum(List<Integer> list) {
        int i0 = 0;
        for (Iterator iterator = list.iterator(); iterator.hasNext(); i0 += iterator.next().intValue()) {
        }
        return i0;
    }

    // class: demo/Calc$Inner
    public class Calc$Inner {

        public Calc$Inner() {
            super();
        }

        public long mul(long l1, long l3) {
            return var_1_0;
        }

    }
}
