LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
include $(LOCAL_PATH)/curl/src/Makefile.inc
LOCAL_MODULE            := curl
LOCAL_SRC_FILES         := $(addprefix curl/src/,$(CURL_CFILES))
LOCAL_SRC_FILES         += $(addprefix curl/src/,$(CURLX_CFILES))
LOCAL_SRC_FILES         += $(LOCAL_PATH)/tinynew.cpp
LOCAL_C_INCLUDES        := $(LOCAL_PATH)/curl/lib $(LOCAL_PATH)/brotli/c/include 
ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_C_INCLUDES    += $(LOCAL_PATH)/config32
else ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
    LOCAL_C_INCLUDES    += $(LOCAL_PATH)/config64
else ifeq ($(TARGET_ARCH_ABI),x86)
    LOCAL_C_INCLUDES    += $(LOCAL_PATH)/config32
else ifeq ($(TARGET_ARCH_ABI),x86_64)
    LOCAL_C_INCLUDES    += $(LOCAL_PATH)/config64
else ifeq ($(TARGET_ARCH_ABI),riscv64)
    LOCAL_C_INCLUDES    += $(LOCAL_PATH)/config64
endif
LOCAL_CFLAGS            := -DHAVE_CONFIG_H
LOCAL_STATIC_LIBRARIES  := curl_static
include $(LOCAL_PATH)/build-executable.mk

include $(CLEAR_VARS)
include $(LOCAL_PATH)/curl/lib/Makefile.inc
LOCAL_MODULE            := curl_static
LOCAL_SRC_FILES         := $(addprefix curl/lib/,$(CSOURCES))
LOCAL_C_INCLUDES        := $(LOCAL_PATH)/curl/include $(LOCAL_PATH)/curl/lib  $(LOCAL_PATH)/brotli/c/include
ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_C_INCLUDES    += $(LOCAL_PATH)/config32
else ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
    LOCAL_C_INCLUDES    += $(LOCAL_PATH)/config64
else ifeq ($(TARGET_ARCH_ABI),x86)
    LOCAL_C_INCLUDES    += $(LOCAL_PATH)/config32
else ifeq ($(TARGET_ARCH_ABI),x86_64)
    LOCAL_C_INCLUDES    += $(LOCAL_PATH)/config64
else ifeq ($(TARGET_ARCH_ABI),riscv64)
    LOCAL_C_INCLUDES    += $(LOCAL_PATH)/config64
endif
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/curl/include
LOCAL_EXPORT_LDLIBS     := -lz
LOCAL_CFLAGS            := -DHAVE_CONFIG_H -DBUILDING_LIBCURL
LOCAL_STATIC_LIBRARIES  := ssl_static nghttp2_static nghttp3_static ngtcp2_static brotli_static zstd_static
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
include $(LOCAL_PATH)/nghttp2/lib/Makefile.am
LOCAL_MODULE            := nghttp2_static
LOCAL_SRC_FILES         := $(addprefix nghttp2/lib/,$(OBJECTS))
LOCAL_C_INCLUDES        := $(LOCAL_PATH)/nghttp2/lib/includes
LOCAL_C_INCLUDES        += $(LOCAL_PATH)/config
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/nghttp2/lib/includes
LOCAL_CFLAGS            := -DHAVE_CONFIG_H
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
include $(LOCAL_PATH)/ngtcp2/lib/Makefile.am
LOCAL_MODULE            := ngtcp2_static
LOCAL_SRC_FILES         := $(addprefix ngtcp2/lib/,$(OBJECTS))
LOCAL_C_INCLUDES        := $(LOCAL_PATH)/ngtcp2/lib/includes
LOCAL_C_INCLUDES        += $(LOCAL_PATH)/config
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/ngtcp2/lib/includes
LOCAL_CFLAGS            := -DHAVE_CONFIG_H
LOCAL_STATIC_LIBRARIES  := ngtcp2_crypto_static
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
include $(LOCAL_PATH)/ngtcp2/crypto/boringssl/Makefile.am
LOCAL_MODULE            := ngtcp2_crypto_static
LOCAL_SRC_FILES         += $(addprefix ngtcp2/crypto/boringssl/,$(libngtcp2_crypto_boringssl_a_SOURCES))
LOCAL_C_INCLUDES        := $(LOCAL_PATH)/ngtcp2/lib $(LOCAL_PATH)/ngtcp2/lib/includes
LOCAL_C_INCLUDES        += $(LOCAL_PATH)/ngtcp2/crypto $(LOCAL_PATH)/ngtcp2/crypto/includes
LOCAL_C_INCLUDES        += $(LOCAL_PATH)/config
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/ngtcp2/crypto/includes
LOCAL_CFLAGS            := -DHAVE_CONFIG_H
LOCAL_STATIC_LIBRARIES  := ssl_static
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
include $(LOCAL_PATH)/nghttp3/lib/Makefile.am
LOCAL_MODULE            := nghttp3_static
LOCAL_SRC_FILES         := $(addprefix nghttp3/lib/,$(OBJECTS))
LOCAL_C_INCLUDES        := $(LOCAL_PATH)/nghttp3/lib/includes
LOCAL_C_INCLUDES        += $(LOCAL_PATH)/config
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/nghttp3/lib/includes
LOCAL_CFLAGS            := -DHAVE_CONFIG_H
include $(BUILD_STATIC_LIBRARY)


include $(CLEAR_VARS)
LOCAL_MODULE            := brotli_static
LOCAL_SRC_FILES         := $(wildcard $(LOCAL_PATH)/brotli/c/common/*.c)
LOCAL_SRC_FILES         += $(wildcard $(LOCAL_PATH)/brotli/c/dec/*.c)
LOCAL_SRC_FILES         += $(wildcard $(LOCAL_PATH)/brotli/c/enc/*.c)
LOCAL_C_INCLUDES        := $(LOCAL_PATH)/brotli/c/include
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/brotli/c/include
LOCAL_CFLAGS            := -DBROTLI_BUILD_PORTABLE
include $(BUILD_STATIC_LIBRARY)


# Zstandard module definition - simplified with wildcards
include $(CLEAR_VARS)
LOCAL_MODULE            := zstd_static
LOCAL_SRC_FILES         := $(wildcard $(LOCAL_PATH)/zstd/lib/common/*.c)
LOCAL_SRC_FILES         += $(wildcard $(LOCAL_PATH)/zstd/lib/compress/*.c)
LOCAL_SRC_FILES         += $(wildcard $(LOCAL_PATH)/zstd/lib/decompress/*.c)
LOCAL_SRC_FILES         += $(wildcard $(LOCAL_PATH)/zstd/lib/dictBuilder/*.c)
LOCAL_SRC_FILES         += $(wildcard $(LOCAL_PATH)/zstd/lib/legacy/*.c)
LOCAL_C_INCLUDES        := $(LOCAL_PATH)/zstd/lib
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/zstd/lib
LOCAL_CFLAGS            := -DXXH_NAMESPACE=ZSTD_ -DZSTD_DISABLE_ASM
include $(BUILD_STATIC_LIBRARY)




$(call import-module,prefab/boringssl)
