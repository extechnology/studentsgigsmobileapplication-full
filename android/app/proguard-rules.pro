# ========== Razorpay SDK Rules ==========
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**
-keep class proguard.annotation.KeepClassMembers

# ========== SmartAuth / Google Credentials ==========
-keep class com.google.android.gms.auth.api.credentials.** { *; }
-dontwarn com.google.android.gms.auth.api.credentials.**

# ========== Annotation Handling ==========
-keepattributes *Annotation*
-keepattributes InnerClasses

# ========== Warning Suppressions ==========
-dontwarn androidx.annotation.**
-dontwarn org.jetbrains.annotations.**
