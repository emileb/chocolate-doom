
#LOCAL_PATH := $(call my-dir)/../src/$(STATIC_LIB)
#include $(LOCAL_CHOC_PATH)/../src/$(STATIC_LIB)/Makefile.am
LOCAL_PATH := $(STATIC_PATH)
include $(STATIC_PATH)/Makefile.am

include $(CLEAR_VARS)

LOCAL_MODULE    := static-$(STATIC_LIB)

LOCAL_CFLAGS :=  -Wall -Wdeclaration-after-statement  -D_GNU_SOURCE=1 -D_REENTRANT

LOCAL_C_INCLUDES +=     $(SDL_INCLUDE_PATHS) \
                        $(LOCAL_CHOC_PATH)/mobile \
                        $(LOCAL_CHOC_PATH)/src \
                        $(LOCAL_CHOC_PATH)/textscreen

LOCAL_SRC_FILES_ALL = $(lib$(STATIC_LIB)_a_SOURCES)

LOCAL_SRC_FILES = $(filter %.c,$(LOCAL_SRC_FILES_ALL))

#Strip unused functions/data
LOCAL_CFLAGS += -fvisibility=hidden -fdata-sections -ffunction-sections

include $(BUILD_STATIC_LIBRARY)






