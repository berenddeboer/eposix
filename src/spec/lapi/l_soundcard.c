#include "l_soundcard.h"


/* ioctl status retrieval commands */

EIF_INTEGER const_sndctl_dsp_getblksize ()
{
  return SNDCTL_DSP_GETBLKSIZE;
}

EIF_INTEGER const_sndctl_dsp_getcaps ()
{
  return SNDCTL_DSP_GETCAPS;
}

EIF_INTEGER const_sndctl_dsp_getfmts ()
{
  return SNDCTL_DSP_GETFMTS;
}


/* ioctl change commands */

EIF_INTEGER const_sndctl_dsp_channels ()
{
  return SNDCTL_DSP_CHANNELS;
}

EIF_INTEGER const_sndctl_dsp_setfmt ()
{
  return SNDCTL_DSP_SETFMT;
}

EIF_INTEGER const_sndctl_dsp_setfragment ()
{
  return SNDCTL_DSP_SETFRAGMENT;
}

EIF_INTEGER const_sndctl_dsp_speed ()
{
  return SNDCTL_DSP_SPEED;
}
