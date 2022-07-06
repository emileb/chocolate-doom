
LOCAL_PATH := $(call my-dir)/../src/

include $(CLEAR_VARS)

LOCAL_MODULE    := choc-$(STATIC_LIB)

LOCAL_CFLAGS :=  -DENGINE_NAME=\"chocdoom\" -Wall -Wdeclaration-after-statement  -D_GNU_SOURCE=1 -D_REENTRANT -DCHOCOLATE


LOCAL_C_INCLUDES :=     $(SDL_INCLUDE_PATHS)  \
                        $(TOP_DIR) \
                        $(TOP_DIR)/MobileTouchControls \
                        $(TOP_DIR)/Clibs_OpenTouch \
                        $(TOP_DIR)/Clibs_OpenTouch/idtech1 \
                        $(LOCAL_PATH)/../textscreen  \
                        $(LOCAL_PATH)/../pcsound  \
                        $(LOCAL_PATH)/../opl  \
                        $(LOCAL_PATH)/../mobile \
 
ANDROID_FILES = \
      ../../../Clibs_OpenTouch/idtech1/android_jni.cpp \
      ../../../Clibs_OpenTouch/idtech1/touch_interface.cpp \
      ../mobile/game_interface.cpp \
          
COMMON_SOURCE_FILES=\
i_main.c  \
i_system.c \
m_argv.c \
m_misc.c

GAME_SOURCE_FILES= \
aes_prng.c \
d_event.c \
d_iwad.c \
d_loop.c \
d_mode.c \
deh_str.c \
gusconf.c \
i_cdmus.c \
i_endoom.c \
i_input.c \
i_joystick.c \
i_oplmusic.c \
i_pcsound.c \
i_sdlmusic.c \
i_sdlsound.c \
i_sound.c \
i_timer.c \
i_video.c \
i_videohr.c \
midifile.c \
mus2mid.c \
m_bbox.c \
m_cheat.c \
m_config.c \
m_controls.c \
m_fixed.c   \
net_client.c \
net_common.c \
net_dedicated.c \
net_gui.c \
net_io.c  \
net_loop.c \
net_packet.c \
net_query.c \
net_sdl.c \
net_server.c \
net_structrw.c \
sha1.c \
memio.c \
tables.c \
v_diskicon.c \
v_video.c \
w_checksum.c \
w_main.c \
w_wad.c \
w_file.c \
w_file_stdc.c \
w_file_posix.c \
w_file_win32.c \
w_merge.c \
z_zone.c

DEHACKED_SOURCE_FILES =                    \
deh_io.c \
deh_main.c  \
deh_mapping.c \
deh_text.c


SETUP_FILES = \
deh_str.c \
d_mode.c \
d_iwad.c \
i_timer.c \
m_config.c \
m_controls.c \
net_io.c \
net_packet.c \
net_sdl.c \
net_query.c \
net_structrw.c \
z_native.c

ifeq ($(STATIC_LIB),setup)
LOCAL_SRC_FILES = $(ANDROID_FILES) $(COMMON_SOURCE_FILES) $(SETUP_FILES)
else
LOCAL_SRC_FILES = $(ANDROID_FILES) $(COMMON_SOURCE_FILES) $(GAME_SOURCE_FILES)
endif

ifeq ($(STATIC_LIB),doom)
    LOCAL_SRC_FILES += $(DEHACKED_SOURCE_FILES)
    LOCAL_CFLAGS += -DCHOC_DOOM
else ifeq ($(STATIC_LIB),hexen)
    LOCAL_CFLAGS += -DCHOC_HEXEN
else ifeq ($(STATIC_LIB),strife)
    LOCAL_SRC_FILES += $(DEHACKED_SOURCE_FILES)
    LOCAL_CFLAGS += -DCHOC_STRIFE
else ifeq ($(STATIC_LIB),heretic)
    LOCAL_SRC_FILES += $(DEHACKED_SOURCE_FILES)
    LOCAL_CFLAGS += -DCHOC_HERETIC
else ifeq ($(STATIC_LIB),setup)
    LOCAL_CFLAGS += -DCHOC_SETUP
endif


LOCAL_LDLIBS += -llog -lz -lGLESv1_CM

LOCAL_STATIC_LIBRARIES += static-opl static-textscreen static-pcsound SDL2_net logwritter
LOCAL_STATIC_LIBRARIES += static-$(STATIC_LIB) static-textscreen

LOCAL_SHARED_LIBRARIES := touchcontrols SDL2 SDL2_mixer core_shared saffal

#Strip unused functions/data
LOCAL_CFLAGS += -fvisibility=hidden -fdata-sections -ffunction-sections -fPIC
LOCAL_LDFLAGS += -Wl,--gc-sections -flto

include $(BUILD_SHARED_LIBRARY)






