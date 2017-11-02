
LOCAL_PATH := $(call my-dir)/../src/

include $(CLEAR_VARS)

LOCAL_MODULE    := choc-$(STATIC_LIB)

LOCAL_CFLAGS :=  -Wall -Wdeclaration-after-statement  -D_GNU_SOURCE=1 -D_REENTRANT -DCHOCOLATE


LOCAL_C_INCLUDES :=     $(SDL_INCLUDE_PATHS)  \
                        $(TOP_DIR) \
                        $(TOP_DIR)/MobileTouchControls \
                        $(TOP_DIR)/Clibs_OpenTouch \
                        $(TOP_DIR)/Doom/common_interface \
                        $(LOCAL_PATH)/../textscreen  \
                        $(LOCAL_PATH)/../pcsound  \
                        $(LOCAL_PATH)/../opl  \
                        $(LOCAL_PATH)/../mobile \


 
ANDROID_FILES = \
      ../../common_interface/android_jni.cpp \
      ../../common_interface/touch_interface.cpp \
      ../mobile/game_interface.cpp \
          
COMMON_SOURCE_FILES=\
i_main.c                                   \
i_system.c           i_system.h            \
m_argv.c             m_argv.h              \
m_misc.c             m_misc.h

GAME_SOURCE_FILES=\
aes_prng.c           aes_prng.h            \
d_event.c            d_event.h             \
                     doomkeys.h            \
                     doomtype.h            \
d_iwad.c             d_iwad.h              \
d_loop.c             d_loop.h              \
d_mode.c             d_mode.h              \
                     d_ticcmd.h            \
deh_str.c            deh_str.h             \
gusconf.c            gusconf.h             \
i_cdmus.c            i_cdmus.h             \
i_endoom.c           i_endoom.h            \
i_input.c            i_input.h             \
i_joystick.c         i_joystick.h          \
                     i_swap.h              \
i_oplmusic.c                               \
i_pcsound.c                                \
i_sdlmusic.c                               \
i_sdlsound.c                               \
i_sound.c            i_sound.h             \
i_timer.c            i_timer.h             \
i_video.c            i_video.h             \
i_videohr.c          i_videohr.h           \
midifile.c           midifile.h            \
mus2mid.c            mus2mid.h             \
m_bbox.c             m_bbox.h              \
m_cheat.c            m_cheat.h             \
m_config.c           m_config.h            \
m_controls.c         m_controls.h          \
m_fixed.c            m_fixed.h             \
net_client.c         net_client.h          \
net_common.c         net_common.h          \
net_dedicated.c      net_dedicated.h       \
net_defs.h                                 \
net_gui.c            net_gui.h             \
net_io.c             net_io.h              \
net_loop.c           net_loop.h            \
net_packet.c         net_packet.h          \
net_query.c          net_query.h           \
net_sdl.c            net_sdl.h             \
net_server.c         net_server.h          \
net_structrw.c       net_structrw.h        \
sha1.c               sha1.h                \
memio.c              memio.h               \
tables.c             tables.h              \
v_diskicon.c         v_diskicon.h          \
v_video.c            v_video.h             \
                     v_patch.h             \
w_checksum.c         w_checksum.h          \
w_main.c             w_main.h              \
w_wad.c              w_wad.h               \
w_file.c             w_file.h              \
w_file_stdc.c                              \
w_file_posix.c                             \
w_file_win32.c                             \
w_merge.c            w_merge.h             \
z_zone.c             z_zone.h

DEHACKED_SOURCE_FILES =                    \
deh_defs.h                                 \
deh_io.c             deh_io.h              \
deh_main.c           deh_main.h            \
deh_mapping.c        deh_mapping.h         \
deh_text.c


SETUP_FILES = \
deh_str.c            deh_str.h             \
d_mode.c             d_mode.h              \
d_iwad.c             d_iwad.h              \
i_timer.c            i_timer.h             \
m_config.c           m_config.h            \
m_controls.c         m_controls.h          \
net_io.c             net_io.h              \
net_packet.c         net_packet.h          \
net_sdl.c            net_sdl.h             \
net_query.c          net_query.h           \
net_structrw.c       net_structrw.h        \
z_native.c           z_zone.h


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

LOCAL_STATIC_LIBRARIES += static-opl static-textscreen static-pcsound SDL2_net
LOCAL_STATIC_LIBRARIES += static-$(STATIC_LIB) static-textscreen license_static

LOCAL_SHARED_LIBRARIES := touchcontrols SDL2 SDL2_mixer

include $(BUILD_SHARED_LIBRARY)






