.class public Ldemo/Calc$Inner;
.super Ljava/lang/Object;
.source "Calc.java"

.method public constructor <init>()V
  .registers 1
    invoke-direct { v0 }, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public mul(JJ)J
  .registers 5
    mul-long v1, v1, v3
    return-wide v1
.end method

