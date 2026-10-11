# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# =============================================================================
# ONNX Runtime Mobile（Android）JNI 绑定必须保留原类名
# -----------------------------------------------------------------------------
# onnxruntime 的 Java 绑定由 C 层用硬编码类名做 FindClass 查找，例如：
#   ai/onnxruntime/TensorInfo         OrtJniUtil.c，把 native 输出包装成 OnnxTensor 时
#   ai/onnxruntime/NodeInfo           ai_onnxruntime_OrtSession.c，getInputInfo 取输入名时
#   ai/onnxruntime/OnnxModelMetadata  getMetadata 时
#   ai/onnxruntime/MapInfo / SequenceInfo / OnnxMap / OnnxSequence / OrtException
# 这些类在 Java 源码里几乎看不到引用，release 构建（isMinifyEnabled = true）下
# R8 会把它们改名甚至整类删除；FindClass 返回 null 之后 JNI 仍继续调用
# GetMethodID/NewObject，ART 会直接以 "JNI DETECTED ERROR IN APPLICATION"
# abort 掉整个进程——表现为 OCR 阶段闪退，Java 侧 try/catch(Throwable) 完全抓不到。
# 所以这里按原名保留整个 ai.onnxruntime 包。
# =============================================================================
-keep class ai.onnxruntime.** { *; }
-keepclassmembers class ai.onnxruntime.** { *; }
-dontwarn ai.onnxruntime.**

# =============================================================================
# Tauri Android 插件桥
# -----------------------------------------------------------------------------
# Rust 侧按类名字符串注册插件，参数类由 Jackson 反射反序列化，两者都依赖名字。
# =============================================================================
-keep class app.tauri.** { *; }
-keep @app.tauri.annotation.TauriPlugin class * { *; }
-keep @app.tauri.annotation.InvokeArg class * { *; }
-keepclassmembers class * { @app.tauri.annotation.* <methods>; }

# 本应用的原生插件：由 Rust 侧以 "com.sansan.sf_novel_flow.SfacgOcrPlugin" 等名字注册。
-keep class com.sansan.sf_novel_flow.** { *; }

# android-gif-drawable 的 native 绑定。
-keep class pl.droidsonroids.gif.** { *; }
-dontwarn pl.droidsonroids.**
