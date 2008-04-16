#include "c_exit_handling.h"

/* at exit handling */


/* Global varibales */

EIF_OBJECT exit_switch = NULL;
#ifndef EIFFEL_VENDOR_SE
EIF_PROCEDURE exit_callback = NULL;
#endif


/* The actual at_exit handler */

#ifdef EIFFEL_VENDOR_SE
/* prototype callback function */
void stdc_exit_switch_at_exit(EIF_OBJECT obj);
#endif

void epx_the_exit_handler(void)
{
  if (exit_switch != NULL) {
#ifdef EIFFEL_VENDOR_ISE
    (exit_callback) (eif_access(exit_switch));
#endif
#ifdef EIFFEL_VENDOR_VE
    (exit_callback) (eif_access(exit_switch));
#endif
#ifdef EIFFEL_VENDOR_SE
    stdc_exit_switch_at_exit (exit_switch);
#endif
  }
}


/* Clear at_exit */

void epx_clear_exit_switch()
{
  exit_switch = NULL;
#ifndef EIFFEL_VENDOR_SE
  exit_callback = NULL;
#endif
}


/* Set at_exit */

void epx_set_exit_switch (EIF_OBJECT a_switch)
{
#ifdef EIFFEL_VENDOR_ISE
  EIF_TYPE_ID tid;
  if ( exit_switch != NULL ) {
    eif_wean (exit_switch);
    exit_switch = NULL;
  }
  if ( a_switch != NULL ) {
    exit_switch = eif_adopt (a_switch);
    tid = eif_type_id ("STDC_EXIT_SWITCH");
    exit_callback = eif_procedure ("at_exit", tid);
    if (exit_callback == 0)
      { eif_panic ("at_exit feature not found."); }
  }
#endif
#ifdef EIFFEL_VENDOR_VE
  if ( exit_switch != NULL ) {
    eif_wean (exit_switch);
    exit_switch = NULL;
  }
  if ( a_switch != NULL ) {
    eif_adopt (a_switch);
    exit_switch = a_switch;
    exit_callback = eif_dynamic_routine (exit_switch, "at_exit");
  }
#endif
#ifdef EIFFEL_VENDOR_SE
  exit_switch = a_switch;
#endif
  atexit (epx_the_exit_handler);
}
