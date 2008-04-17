#include "c_signal_handling.h"

/* signal handling */


/* Global fields, so far for multithreading... */

EIF_REFERENCE signal_switch_object = NULL;
void (*signal_switch_address)(EIF_REFERENCE, EIF_INTEGER_32) = NULL;


void epx_clear_signal_switch() {
  signal_switch_object = NULL;
  signal_switch_address = NULL;
}


/* Set address to callback to and the object reference to pass to that
   address. */

void epx_set_signal_switch (EIF_POINTER object, EIF_POINTER address) {
#ifdef EIFFEL_VENDOR_VE
  signal_switch_object = eif_adopt(object);
#else
#ifdef EIFFEL_VENDOR_SE
  signal_switch_object = object;
#else
  signal_switch_object = eif_protect(object);
#endif
#endif
  signal_switch_address = address;
}


/* This is the routine that is called upon a signal and switches back
   to Eiffel */
void epx_the_signal_handler (int sig) {
  if (signal_switch_object != NULL && signal_switch_address != NULL) {
#ifdef EIFFEL_VENDOR_ISE
    (signal_switch_address) (eif_access(signal_switch_object), sig);
#endif
#ifdef EIFFEL_VENDOR_VE
    (signal_switch_address) (eif_access(signal_switch_object), sig);
#endif
#ifdef EIFFEL_VENDOR_SE
    (signal_switch_address) (signal_switch_object, sig);
#endif
#ifdef EIFFEL_VENDOR_GE
    (signal_switch_address) (eif_adopt(signal_switch_object), sig);
#endif
  }
}


EIF_POINTER epx_signal_handler()
{
  return (EIF_POINTER)  &epx_the_signal_handler;
}
