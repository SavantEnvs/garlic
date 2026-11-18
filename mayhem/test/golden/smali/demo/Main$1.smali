.class  Ldemo/Main$1;
.super Ljava/lang/Object;
.source "Main.java"
.implements Ljava/lang/Runnable;

.method  constructor <init>()V
  .registers 1
    invoke-direct { v0 }, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public run()V
  .registers 3
    sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
    const-string v1, "anon"
    invoke-virtual { v0, v1 }, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
    return-void
.end method

