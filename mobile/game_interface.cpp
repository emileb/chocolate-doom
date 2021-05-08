

extern "C"
{

#include "game_interface.h"

#include <signal.h>
#include <stdlib.h>
#include <limits.h>
#include <sys/types.h>
#include <stdarg.h>
#include <stdio.h>
#include <sys/stat.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>

#include "SDL.h"
#include "SDL_keycode.h"

#include "i_system.h"
#include "m_fixed.h"
#include "m_controls.h"

// FIFO STUFF ////////////////////
// Copied from FTEQW, I don't know if this is thread safe, but it's safe enough for a game :)
#define EVENTQUEUELENGTH 128

//This event_t is from choc Doom d_event.h
event_t  eventlist[EVENTQUEUELENGTH];

volatile int events_avail; /*volatile to make sure the cc doesn't try leaving these cached in a register*/
volatile int events_used;

static  event_t *in_newevent(void)
{
	if (events_avail >= events_used + EVENTQUEUELENGTH)
		return 0;
	return &eventlist[events_avail & (EVENTQUEUELENGTH-1)];
}

static void in_finishevent(void)
{
	events_avail++;
}

int add_choc_event(evtype_t type, int data1, int data2, int data3){

	//LOGI("PortableKeyEvent %d %d",state,code);
	event_t *ev = in_newevent();
	if (!ev)
		return 0;

	ev->type = type;
	ev->data1 = data1;
	ev->data2 = data2;
	ev->data3 = data3;

	in_finishevent();
	return 0;
}
///////////////////////


extern int SDL_SendKeyboardKey(Uint8 state, SDL_Scancode scancode);

int PortableKeyEvent(int state, int code, int unicode){
	LOGI("PortableKeyEvent %d %d %d",state,code,unicode);

	if (state)
		SDL_SendKeyboardKey(SDL_PRESSED, (SDL_Scancode)code);
	else
		SDL_SendKeyboardKey(SDL_RELEASED, (SDL_Scancode) code);

	return 0;

}

void PortableBackButton()
{
    LOGI("Back button");
    PortableKeyEvent(1, SDL_SCANCODE_ESCAPE,0 );
    PortableKeyEvent(0, SDL_SCANCODE_ESCAPE, 0);
}

void ActionKey(int state,int key)
{
	add_choc_event(state?ev_keydown:ev_keyup,key,0,0);
}

static int newweapon = -1;

#ifdef CHOC_SETUP
static boolean net_waiting_for_launch = true; // Create this to make menu buttons work below
#else
extern boolean net_waiting_for_launch; // In real game this exists
#endif

void PortableAction(int state, int action)
{
	LOGI("PortableAction %d   %d, ts = %d",state,action,PortableGetScreenMode());

	if (( PortableGetScreenMode() == TS_MENU ) || ( PortableGetScreenMode() == TS_BLANK )  || ( PortableGetScreenMode() == TS_Y_N ))
	{
		if( net_waiting_for_launch )
		{
			if (action >= PORT_ACT_MENU_UP && action <= PORT_ACT_MENU_ABORT)
			{
				int sdl_code [] = { SDL_SCANCODE_UP, SDL_SCANCODE_DOWN, SDL_SCANCODE_LEFT,
						SDL_SCANCODE_RIGHT, SDL_SCANCODE_RETURN, SDL_SCANCODE_ESCAPE, SDL_SCANCODE_Y, SDL_SCANCODE_N };

				PortableKeyEvent(state, sdl_code[action-PORT_ACT_MENU_UP], 0);

				return;
			}
		}

		int key = -1;

		switch (action)
		{
		case PORT_ACT_MENU_UP:
			key = key_menu_up;
			break;
		case PORT_ACT_MENU_DOWN:
			key = key_menu_down;
			break;
		case PORT_ACT_MENU_LEFT:
			key = key_menu_left;
			break;
		case PORT_ACT_MENU_RIGHT:
			key = key_menu_right;
			break;
		case PORT_ACT_MENU_SELECT:
			key = key_menu_forward;
			break;
		case PORT_ACT_MENU_BACK:
			key = key_menu_activate;
			break;
		case PORT_ACT_MENU_CONFIRM:
			key = key_menu_confirm;
			break;
		case PORT_ACT_MENU_ABORT:
			key = key_menu_abort;
			break;
		}

		if (key != -1)
			ActionKey(state,key);
	}
	else
	{
		int key = -1;

		switch (action)
		{
		/* 04/03/18, why was this here??Broke gamepad buttons
		case PORT_ACT_MENU_UP:
		    key = key_menu_up;
		    break;
        case PORT_ACT_MENU_DOWN:
            key = key_menu_down;
            break;
        case PORT_ACT_MENU_LEFT:
            key = key_menu_left;
            break;
        case PORT_ACT_MENU_RIGHT:
            key = key_menu_right;
            break;
        case PORT_ACT_MENU_SELECT:
            key = key_menu_forward;
            break;
        case PORT_ACT_MENU_BACK:
            key = key_menu_activate;
            break;
        case PORT_ACT_MENU_CONFIRM:
            key = key_menu_confirm;
            break;
        case PORT_ACT_MENU_ABORT:
            key = key_menu_abort;
            break;
            */
		case PORT_ACT_LEFT:
			key = key_left;
			break;
		case PORT_ACT_RIGHT:
			key = key_right;
			break;
		case PORT_ACT_FWD:
			key = key_up;
			break;
		case PORT_ACT_BACK:
			key = key_down;
			break;
		case PORT_ACT_MOVE_LEFT:
			key = key_strafeleft;
			break;
		case PORT_ACT_MOVE_RIGHT:
			key = key_straferight;
			break;
		case PORT_ACT_USE:
			key = key_use;
			break;
		case PORT_ACT_ATTACK:
			key = key_fire;
			break;
		case PORT_ACT_JUMP:
			key = key_jump;
			break;
		case PORT_ACT_STRAFE:
			key = key_strafe;
			break;
		case PORT_ACT_SPEED:
			key = key_speed;
			break;
		case PORT_ACT_MAP:
			key = key_map_toggle;
			break;
		case PORT_ACT_MAP_ZOOM_IN:
			key = key_map_zoomin;
			break;
		case PORT_ACT_MAP_ZOOM_OUT:
			key = key_map_zoomout;
			break;
		case PORT_ACT_INVUSE:
			key = key_useartifact;
			break;
		case PORT_ACT_INVDROP:
			key = key_invdrop;
			break;
		case PORT_ACT_INVPREV:
			key = key_invleft;
			break;
		case PORT_ACT_INVNEXT:
			key = key_invright;
			break;
		case PORT_ACT_NEXT_WEP:
			key = key_nextweapon;
			break;
		case PORT_ACT_PREV_WEP:
			key = key_prevweapon;
			break;
		case PORT_ACT_QUICKSAVE:
			key = key_menu_qsave;
			break;
		case PORT_ACT_QUICKLOAD:
			key = key_menu_qload;
			break;
		case PORT_ACT_GAMMA:
			key = key_menu_gamma;
			break;
		case PORT_ACT_HELPCOMP:
			key = key_mission;
			break;
		case PORT_ACT_SHOW_WEAPONS:
			key = key_invpop;
			break;
		case PORT_ACT_SHOW_KEYS:
			key = key_invkey;
			break;
		case PORT_ACT_FLY_UP:
			key = key_flyup;
			break;
		case PORT_ACT_FLY_DOWN:
			key = key_flydown;
			break;
		case PORT_ACT_FLY_CENTER:
			key = key_flycenter;
			break;
		case PORT_ACT_WEAP1:
			newweapon = 1;
			break;
		case PORT_ACT_WEAP2:
			newweapon = 2;
			break;
		case PORT_ACT_WEAP3:
			newweapon = 3;
			break;
		case PORT_ACT_WEAP4:
			newweapon = 4;
			break;
		case PORT_ACT_WEAP5:
			newweapon = 5;
			break;
		case PORT_ACT_WEAP6:
			newweapon = 6;
			break;
		case PORT_ACT_WEAP7:
			newweapon = 7;
			break;
		case PORT_ACT_WEAP8:
			newweapon = 8;
			break;
		}

		if (key != -1)
			ActionKey(state,key);
	}
}

void PortableCommand(const char * cmd)
{

}

// =================== FORWARD and SIDE MOVMENT ==============

float forwardmove_android, sidemove_android; //Joystick mode

void PortableMoveFwd(float fwd)
{
	if (fwd > 1)
		fwd = 1;
	else if (fwd < -1)
		fwd = -1;

	forwardmove_android = fwd;
}

void PortableMoveSide(float strafe)
{
	if (strafe > 1)
		strafe = 1;
	else if (strafe < -1)
		strafe = -1;

	sidemove_android = strafe;
}

void PortableMove(float fwd, float strafe)
{
	PortableMoveFwd(fwd);
	PortableMoveSide(strafe);
}

//======================================================================

//Look up and down
float look_pitch_mouse,look_pitch_abs,look_pitch_joy;
void PortableLookPitch(int mode, float pitch)
{
	switch(mode)
	{
	case LOOK_MODE_MOUSE:
		look_pitch_mouse -= pitch;
		break;
	case LOOK_MODE_JOYSTICK:
		look_pitch_joy = pitch;
		break;
	}
}

//left right
float look_yaw_mouse,look_yaw_joy;
void PortableLookYaw(int mode, float yaw)
{
	switch(mode)
	{
	case LOOK_MODE_MOUSE:
		look_yaw_mouse += yaw;
		break;
	case LOOK_MODE_JOYSTICK:
		look_yaw_joy = yaw;
		break;
	}
}


extern int main_android(int argc, char *argv[]);

void PortableInit(int argc,const char ** argv){
	main_android(argc,(char **)argv);
}


static float am_zoom = 0;
static float am_pan_x = 0;
static float am_pan_y = 0;

void PortableAutomapControl(float zoom, float x, float y)
{
	am_zoom += zoom;
	am_pan_x += x;
	am_pan_y += y;
}


#ifdef CHOC_SETUP
    touchscreemode_t PortableGetScreenMode()
    {
        return TS_MENU;
    }
#else

#if defined(CHOC_DOOM) || defined(CHOC_STRIFE)
    #define MENUACTIVE menuactive
    #define ASKYN messageNeedsInput
#elif defined(CHOC_HEXEN) || defined(CHOC_HERETIC)
    #define MENUACTIVE MenuActive
    #define ASKYN askforquit
#endif

    extern boolean MENUACTIVE;
    extern boolean paused;
    extern boolean usergame;
    extern boolean ASKYN;
    extern boolean automapactive;

    touchscreemode_t PortableGetScreenMode()
    {
		if( ASKYN )
		{
			return TS_Y_N;
		}
		else if(MENUACTIVE || paused || net_waiting_for_launch)
        {
			return TS_MENU;
        }
        else if(usergame)
        {
            if(automapactive)
                return TS_MAP;
            else
                return TS_GAME;
        }
        else
            return TS_BLANK;
    }

#endif


int PortableShowKeyboard(void){

	return 0;
}

#ifndef CHOC_SETUP

void I_UpdateAndroid(void)
{
	event_t *ev;

	while (events_used != events_avail)
	{
		ev = &eventlist[events_used & (EVENTQUEUELENGTH-1)];

		D_PostEvent(ev);

		events_used++;
	}
}

void Mobile_AM_controls(double *zoom, fixed_t *pan_x, fixed_t *pan_y )
{
	if (am_zoom)
	{
        *zoom = am_zoom * 10;
		am_zoom = 0;
	}

	*pan_x += (fixed_t)(am_pan_x * 200000000);
	*pan_y += -(fixed_t)(am_pan_y * 100000000);
	am_pan_x = am_pan_y = 0;
	//LOGI("zoom = %f",*zoom);
}

extern fixed_t forwardmove[2];
extern fixed_t sidemove[2];
extern fixed_t angleturn[3];     // + slow turn

static int mlooky = 0;
//Called from the game
void G_AndroidBuildTiccmd(ticcmd_t *cmd)
{

    int blockGamepad( void );
    int blockMove = blockGamepad() & ANALOGUE_AXIS_FWD;
    int blockLook = blockGamepad() & ANALOGUE_AXIS_PITCH;


    if( !blockMove )
    {
	    cmd->forwardmove  += forwardmove_android * forwardmove[1];
    	cmd->sidemove  += sidemove_android   * sidemove[1];
    }

    if( !blockLook )
    {
        mlooky += look_pitch_mouse * 10000;
        look_pitch_mouse = 0;
        mlooky += look_pitch_joy * 300;

        //LOGI("mlooky = %d",mlooky);

#ifdef CHOC_STRIFE
        if (abs(mlooky) > 50) //make look more senstive for strife
#else
        if (abs(mlooky) > 100)
#endif
        {
            int look = -mlooky/100;
            if (look > 7) look = 7;
            if (look < -7) look = -7;

            if (look < 0)
            {
                look += 16;
            }
            cmd->lookfly |= look & 0xF;

            if (mlooky > 0)
                cmd->buttons2 |= BT2_LOOKDOWN;
            else
                cmd->buttons2 |= BT2_LOOKUP;

            mlooky = 0;
        }


        cmd->angleturn += look_yaw_mouse * 70000;
        look_yaw_mouse = 0;
        cmd->angleturn += look_yaw_joy * 1000;
    }

	if (newweapon != -1)
	{
		cmd->buttons |= BT_CHANGE;
		cmd->buttons |= (newweapon-1)<<BT_WEAPONSHIFT;
		newweapon = -1;
	}
}
#endif
}


