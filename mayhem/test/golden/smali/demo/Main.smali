.class public Ldemo/Main;
.super Ljava/lang/Object;
.source "Main.java"

.method public constructor <init>()V
  .registers 1
    invoke-direct { v0 }, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static main([Ljava/lang/String;)V
  .registers 8
    new-instance v7, Ldemo/Calc;
    const/4 v0, 0x3
    invoke-direct { v7, v0 }, Ldemo/Calc;-><init>(I)V
    sget-object v1, Ljava/lang/System;->out:Ljava/io/PrintStream;
    const/16 v2, 0xa
    invoke-virtual { v7, v2 }, Ldemo/Calc;->fib(I)I
    move-result v2
    invoke-virtual { v1, v2 }, Ljava/io/PrintStream;->println(I)V
    sget-object v1, Ljava/lang/System;->out:Ljava/io/PrintStream;
    const/4 v2, 0x2
    invoke-virtual { v7, v2 }, Ldemo/Calc;->classify(I)Ljava/lang/String;
    move-result-object v3
    invoke-virtual { v1, v3 }, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
    sget-object v1, Ljava/lang/System;->out:Ljava/io/PrintStream;
    new-array v3, v0, [Ljava/lang/Integer;
    const/4 v4, 0x1
    invoke-static { v4 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v5
    const/4 v6, 0x0
    aput-object v5, v3, v6
    invoke-static { v2 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v5
    aput-object v5, v3, v4
    invoke-static { v0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v0
    aput-object v0, v3, v2
    invoke-static { v3 }, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;
    move-result-object v0
    invoke-virtual { v7, v0 }, Ldemo/Calc;->sum(Ljava/util/List;)I
    move-result v0
    invoke-virtual { v1, v0 }, Ljava/io/PrintStream;->println(I)V
    sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
    const/4 v1, 0x4
    invoke-virtual { v7, v1, v6 }, Ldemo/Calc;->safeDiv(II)I
    move-result v7
    invoke-virtual { v0, v7 }, Ljava/io/PrintStream;->println(I)V
    sget-object v7, Ljava/lang/System;->out:Ljava/io/PrintStream;
    new-instance v0, Ldemo/Calc$Inner;
    invoke-direct { v0 }, Ldemo/Calc$Inner;-><init>()V
    const-wide/16 v1, 0x6
    const-wide/16 v3, 0x7
    invoke-virtual { v0, v1, v2, v3, v4 }, Ldemo/Calc$Inner;->mul(JJ)J
    move-result-wide v0
    invoke-virtual { v7, v0, v1 }, Ljava/io/PrintStream;->println(J)V
    new-instance v7, Ldemo/Main$1;
    invoke-direct { v7 }, Ldemo/Main$1;-><init>()V
    invoke-interface { v7 }, Ljava/lang/Runnable;->run()V
    return-void
.end method

