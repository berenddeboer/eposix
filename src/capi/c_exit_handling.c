#include "c_exit_handling.h"

/* at exit handling */


/* Global fields, so far for multithreading... */

EIF_REFERENCE exit_switch_object = NULL;
void (*exit_switch_address)(EIF_REFERENCE) = NULL;


/* The actual at_exit handler */

void epx_the_exit_handler(void) {
  if (exit_switch_object != NULL && exit_switch_address != NULL) {
#ifdef EIFFEL_VENDOR_ISE
    (exit_switch_address) (eif_access(exit_switch_object));
#endif
#ifdef EIFFEL_VENDOR_VE
    (exit_switch_address) (eif_access(exit_switch_object));
#endif
#ifdef EIFFEL_VENDOR_SE
    (exit_switch_address) (exit_switch_object);
#endif
#ifdef EIFFEL_VENDOR_GE
    (exit_switch_address) (eif_adopt(exit_switch_object));
#endif
  }
}


/* Clear at_exit */

void epx_clear_exit_switch()
{
  exit_switch_object = NULL;
  exit_switch_address = NULL;
}


/* Set at_exit */

void epx_set_exit_switch (EIF_POINTER object, EIF_POINTER address) {
#ifdef EIFFEL_VENDOR_VE
  exit_switch_object = eif_adopt(object);
#else
#ifdef EIFFEL_VENDOR_SE
  exit_switch_object = object;
#else
  exit_switch_object = (EIF_REFERENCE) eif_protect(object);
#endif
#endif
  exit_switch_address = address;
  atexit (epx_the_exit_handler);
}
