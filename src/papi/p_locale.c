#include "p_locale.h"

/* constants */

EIF_INTEGER const_lc_messages()
{
#ifdef LC_MESSAGES
  return LC_MESSAGES;
#else
  return 0; /* have you better ideas?? */
#endif
}
