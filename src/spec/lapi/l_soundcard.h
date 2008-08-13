/*

Eiffel to C glue layer to access <sys/soundcard.h>

*/

#ifndef _L_SOUNDCARD_H_
#define _L_SOUNDCARD_H_

#if HAVE_CONFIG_H
#include <config.h>
#endif


#include <sys/soundcard.h>
#include "../../supportc/eiffel.h"


/* ioctl status retrieval commands */

EIF_INTEGER const_sndctl_dsp_getblksize ();
EIF_INTEGER const_sndctl_dsp_getcaps ();
EIF_INTEGER const_sndctl_dsp_getfmts ();


/* ioctl change commands */

EIF_INTEGER const_sndctl_dsp_channels ();
EIF_INTEGER const_sndctl_dsp_setfmt ();
EIF_INTEGER const_sndctl_dsp_setfragment ();
EIF_INTEGER const_sndctl_dsp_speed ();


#endif /* _L_SOUNDCARD_H_ */
