LOCAL_CHOC_PATH := $(call my-dir)/../

STATIC_LIB = opl
STATIC_PATH = $(LOCAL_CHOC_PATH)/opl
include $(LOCAL_CHOC_PATH)/mobile/Android_static.mk

STATIC_LIB = textscreen
STATIC_PATH = $(LOCAL_CHOC_PATH)/textscreen
include $(LOCAL_CHOC_PATH)/mobile/Android_static.mk

STATIC_LIB = pcsound
STATIC_PATH = $(LOCAL_CHOC_PATH)/pcsound
include $(LOCAL_CHOC_PATH)/mobile/Android_static.mk

STATIC_LIB = doom
STATIC_PATH = $(LOCAL_CHOC_PATH)/src/doom
include $(LOCAL_CHOC_PATH)/mobile/Android_static.mk
include $(LOCAL_CHOC_PATH)/mobile/Android_src.mk


#STATIC_LIB = strife
#STATIC_PATH = $(LOCAL_CHOC_PATH)/src/strife
#include $(LOCAL_CHOC_PATH)/mobile/Android_static.mk
#include $(LOCAL_CHOC_PATH)/mobile/Android_src.mk

#STATIC_LIB = hexen
#STATIC_PATH = $(LOCAL_CHOC_PATH)/src/hexen
#include $(LOCAL_CHOC_PATH)/mobile/Android_static.mk
#include $(LOCAL_CHOC_PATH)/mobile/Android_src.mk


#STATIC_LIB = heretic
#STATIC_PATH = $(LOCAL_CHOC_PATH)/src/heretic
#include $(LOCAL_CHOC_PATH)/mobile/Android_static.mk
#include $(LOCAL_CHOC_PATH)/mobile/Android_src.mk

#STATIC_LIB = setup
#STATIC_PATH = $(LOCAL_CHOC_PATH)/src/setup
#include $(LOCAL_CHOC_PATH)/mobile/Android_static.mk
#include $(LOCAL_CHOC_PATH)/mobile/Android_src.mk

