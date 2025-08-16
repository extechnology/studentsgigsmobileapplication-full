# ========== Razorpay SDK Rules ==========
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**
-keep class proguard.annotation.KeepClassMembers

# ========== Annotation Handling ==========
-keepattributes *Annotation*
-keepattributes InnerClasses

# ========== Warning Suppressions ==========
-dontwarn androidx.annotation.**
-dontwarn org.jetbrains.annotations.**