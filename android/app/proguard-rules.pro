# ==== Razorpay SDK Keep Rules ====
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Keep annotations (needed by Razorpay and R8)
-keepattributes *Annotation*

# Optional - Fix common annotation warnings
-dontwarn androidx.annotation.**
-dontwarn org.jetbrains.annotations.**
