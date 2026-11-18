.class public Ldemo/Calc;
.super Ljava/lang/Object;
.source "Calc.java"

.field private static final NAME:Ljava/lang/String;

.field private final base:I

.method public constructor <init>(I)V
  .registers 2
    invoke-direct { v0 }, Ljava/lang/Object;-><init>()V
    iput v1, v0, Ldemo/Calc;->base:I
    return-void
.end method

.method static lambda$names$0(Ljava/lang/String;)V
  .registers 2
    sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
    invoke-virtual { v1 }, Ljava/lang/String;->length()I
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/io/PrintStream;->println(I)V
    return-void
.end method

.method public avg([D)D
  .catchall { :try_start_0 .. :try_end_0 } :catchall_0
  .catchall { :try_start_1 .. :try_end_1 } :catchall_0
  .registers 10
    monitor-enter v8
    nop
  :try_start_0
    array-length v0, v9
    const-wide/16 v1, 0x0
    const/4 v3, 0x0
    move-wide v4, v1
  :goto_0
    if-ge v3, v0, :cond_0
    aget-wide v6, v9, v3
    add-double/2addr v4, v6
    add-int/lit8 v3, v3, 0x1
    goto :goto_0
  :cond_0
    array-length v0, v9
    if-nez v0, :cond_1
    goto :goto_1
  :cond_1
    array-length v9, v9
  :try_end_0
    int-to-double v0, v9
    div-double v1, v4, v0
  :goto_1
    monitor-exit v8
    return-wide v1
  :catchall_0
    move-exception v9
  :try_start_1
    monitor-exit v8
  :try_end_1
    throw v9
.end method

.method public classify(I)Ljava/lang/String;
  .registers 2
    packed-switch v1, :pswitch_data_0
    if-gez v1, :cond_0
    const-string v1, "negative"
    goto :goto_0
  :pswitch_2
    const-string v1, "two"
    return-object v1
  :pswitch_1
    const-string v1, "one"
    return-object v1
  :pswitch_0
    const-string v1, "zero"
    return-object v1
  :cond_0
    const-string v1, "many"
  :goto_0
    return-object v1

  :pswitch_data_0
  .packed-switch 0x0
    :pswitch_0
    :pswitch_1
    :pswitch_2
  .end packed-switch
.end method

.method public fib(I)I
  .registers 6
    const/4 v0, 0x2
    if-ge v5, v0, :cond_0
    return v5
  :cond_0
    nop
    const/4 v1, 0x1
    const/4 v2, 0x0
  :goto_0
    if-gt v0, v5, :cond_1
    add-int/2addr v2, v1
    nop
    nop
    add-int/lit8 v0, v0, 0x1
    move v3, v2
    move v2, v1
    move v1, v3
    goto :goto_0
  :cond_1
    iget v5, v4, Ldemo/Calc;->base:I
    add-int/2addr v1, v5
    return v1
.end method

.method public names(I)Ljava/util/List;
  .registers 6
    new-instance v0, Ljava/util/ArrayList;
    invoke-direct { v0 }, Ljava/util/ArrayList;-><init>()V
    const/4 v1, 0x0
  :goto_0
    if-ge v1, v5, :cond_0
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "n"
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-interface { v0, v2 }, Ljava/util/List;->add(Ljava/lang/Object;)Z
    add-int/lit8 v1, v1, 0x1
    goto :goto_0
  :cond_0
    new-instance v5, Ldemo/Calc$$ExternalSyntheticLambda0;
    invoke-direct { v5 }, Ldemo/Calc$$ExternalSyntheticLambda0;-><init>()V
    invoke-interface { v0, v5 }, Ljava/util/List;->forEach(Ljava/util/function/Consumer;)V
    return-object v0
.end method

.method public safeDiv(II)I
  .catch Ljava/lang/ArithmeticException; { :try_start_0 .. :try_end_0 } :catch_0
  .catchall { :try_start_0 .. :try_end_0 } :catchall_0
  .registers 4
    const-string v0, "calc"
  :try_start_0
    div-int/2addr v2, v3
  :try_end_0
    sget-object v3, Ljava/lang/System;->out:Ljava/io/PrintStream;
    invoke-virtual { v3, v0 }, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
    return v2
  :catchall_0
    move-exception v2
    sget-object v3, Ljava/lang/System;->out:Ljava/io/PrintStream;
    invoke-virtual { v3, v0 }, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
    throw v2
  :catch_0
    move-exception v2
    nop
    sget-object v2, Ljava/lang/System;->out:Ljava/io/PrintStream;
    invoke-virtual { v2, v0 }, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
    const/4 v2, -0x1
    return v2
.end method

.method public sum(Ljava/util/List;)I
  .registers 4
    nop
    invoke-interface { v3 }, Ljava/util/List;->iterator()Ljava/util/Iterator;
    move-result-object v3
    const/4 v0, 0x0
  :goto_0
    invoke-interface { v3 }, Ljava/util/Iterator;->hasNext()Z
    move-result v1
    if-eqz v1, :cond_0
    invoke-interface { v3 }, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Ljava/lang/Integer;
    invoke-virtual { v1 }, Ljava/lang/Integer;->intValue()I
    move-result v1
    add-int/2addr v0, v1
    goto :goto_0
  :cond_0
    return v0
.end method

