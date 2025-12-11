# OkHttp rules
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**

# BouncyCastle rules
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**
-dontwarn org.slf4j.**

# Keep SSL classes
-keep class org.conscrypt.** { *; }
-keep class org.bouncycastle.** { *; }
-keep class org.openjsse.** { *; }