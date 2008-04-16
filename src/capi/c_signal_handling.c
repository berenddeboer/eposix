#include "c_signal_handling.h"

/* signal handling */


/* Global flag, so far for multithreading... */

EIF_OBJECT signal_switch = NULL;
#ifdef EIFFEL_VENDOR_ISE
EIF_REFERENCE frozen_signal_switch = NULL;
#endif
#ifndef EIFFEL_VENDOR_SE
EIF_PROCEDURE signal_callback = NULL;
#endif


void epx_clear_signal_switch()
{
  signal_switch = NULL;
#ifndef EIFFEL_VENDOR_SE
  signal_callback = NULL;
#endif
}


/* Set our signal_switch object. As the signal handler itself uses
   this object, set it only at the last possible moment */

void epx_set_signal_switch (EIF_OBJECT a_switch)
{
#ifdef EIFFEL_VENDOR_ISE
  EIF_TYPE_ID tid;
  EIF_OBJECT temp;
  if ( signal_switch != NULL ) {
    temp = signal_switch;
    signal_switch = NULL;
    eif_unfreeze (frozen_signal_switch);
    frozen_signal_switch = NULL;
    eif_wean (temp);
  }
  if ( a_switch != NULL ) {
    tid = eif_type_id ("STDC_SIGNAL_SWITCH");
    signal_callback = eif_procedure ("switcher", tid);
    if (signal_callback == 0)
      { eif_panic ("switcher feature not found."); }
    frozen_signal_switch = eif_freeze (a_switch);
    signal_switch = eif_adopt (a_switch);
  }
#endif
#ifdef EIFFEL_VENDOR_VE
  EIF_OBJECT temp;
  if ( signal_switch != NULL ) {
    temp = signal_switch;
    signal_switch = NULL;
    eif_wean (temp);
  }
  if ( a_switch != NULL ) {
    eif_adopt (a_switch);
    signal_callback = eif_dynamic_routine (a_switch, "switcher");
    signal_switch = a_switch;
  }
#endif
#ifdef EIFFEL_VENDOR_SE
  signal_switch = a_switch;
#endif
}


#ifdef EIFFEL_VENDOR_SE
/* prototype callback function */
void stdc_signal_switch_switcher(EIF_OBJECT obj, EIF_INTEGER sig);
#endif

void epx_the_signal_handler (EIF_INTEGER sig)
{
  if (signal_switch != NULL) {
#ifdef EIFFEL_VENDOR_ISE
    /*    (signal_callback) (eif_access(signal_switch), sig);*/
    (signal_callback) (frozen_signal_switch, sig);
#endif
#ifdef EIFFEL_VENDOR_VE
    (signal_callback) (eif_access(signal_switch), sig);
#endif
#ifdef EIFFEL_VENDOR_SE
    stdc_signal_switch_switcher(signal_switch, sig);
#endif
  }
}


EIF_POINTER epx_signal_handler()
{
  return (EIF_POINTER)  &epx_the_signal_handler;
}
