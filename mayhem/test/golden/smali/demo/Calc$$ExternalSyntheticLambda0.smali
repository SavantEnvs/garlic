.class public final synthetic Ldemo/Calc$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"
.implements Ljava/util/function/Consumer;

.method public constructor <init>()V
  .registers 1
    invoke-direct { v0 }, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public final accept(Ljava/lang/Object;)V
  .registers 2
    check-cast v1, Ljava/lang/String;
    invoke-static { v1 }, Ldemo/Calc;->lambda$names$0(Ljava/lang/String;)V
    return-void
.end method

