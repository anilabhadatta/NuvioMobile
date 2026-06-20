# Project-specific ProGuard rules for composeApp Android release builds.

# Keep useful metadata for crash reports.
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# Preserve Kotlin metadata/signatures needed by reflection/generics-heavy libraries.
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod
-keepattributes RuntimeVisibleAnnotations

# ── Kotlin serialization ──────────────────────────────────────────────────────
# R8 can strip the companion object and generated $serializer inner class
# from @Serializable classes, causing "Serializer not found" crashes at runtime.
-keepattributes *Annotation*, InnerClasses
-dontnote kotlinx.serialization.AnnotationsKt

-keep,includedescriptorclasses class com.nuvio.app.**$$serializer { *; }
-keepclassmembers class com.nuvio.app.** {
    *** Companion;
}
-keepclasseswithmembers class com.nuvio.app.** {
    kotlinx.serialization.KSerializer serializer(...);
}
# Also protect all generated serializers in the kotlinx namespace itself.
-keep class kotlinx.serialization.** { *; }
-dontwarn kotlinx.serialization.**

# ── Compose Navigation (type-safe routes) ─────────────────────────────────────
# @Serializable data classes used as nav routes: R8 may remove no-arg
# constructors or rename fields, breaking toRoute<T>() at runtime.
-keep @kotlinx.serialization.Serializable class * {
    *;
}

# ── Ktor / Supabase ───────────────────────────────────────────────────────────
-keep class io.github.jan.supabase.** { *; }
-keep class io.ktor.** { *; }
-dontwarn io.ktor.**

# ── Coil ─────────────────────────────────────────────────────────────────────
-keep class coil3.** { *; }
-dontwarn coil3.**

# ── Kermit logger ────────────────────────────────────────────────────────────
-keep class co.touchlab.kermit.** { *; }
-dontwarn co.touchlab.kermit.**

# ── QuickJS plugin runtime ───────────────────────────────────────────────────
-keep class com.dokar.quickjs.** { *; }
-keep class com.nuvio.app.features.plugins.** { *; }

# ── P2P / TorrServer ────────────────────────────────────────────────────────
-keep class com.nuvio.app.features.p2p.** { *; }

# ── Media3 / ExoPlayer ──────────────────────────────────────────────────────
-dontwarn androidx.media3.**
-keep class androidx.media3.** { *; }
-keep interface androidx.media3.** { *; }
-keep class com.google.android.exoplayer2.** { *; }
-keep interface com.google.android.exoplayer2.** { *; }

# ── Specific large composables that crash under R8 optimisation ──────────────
-keep class com.nuvio.app.features.catalog.CatalogTargetKind { *; }
-keep class com.nuvio.app.features.streams.StreamBadgeChipKt { *; }
-keep class com.nuvio.app.features.streams.StreamBadgeChipSize { *; }
-keep class com.nuvio.app.features.streams.StreamBadgeChipDefaults { *; }
-keep class com.nuvio.app.features.streams.StreamsScreenKt { *; }
-keep class com.nuvio.app.features.streams.StreamsScreenKt$* { *; }
-keep class com.nuvio.app.features.player.PlayerScreenKt { *; }
-keep class com.nuvio.app.features.player.PlayerScreenKt$* { *; }

# ── Common optional security providers used by okhttp ───────────────────────
-dontwarn okhttp3.internal.platform.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**
