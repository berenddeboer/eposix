#include "w_windows5.h"


/* jobs */

EIF_INTEGER posix_createjobobject(EIF_POINTER lpJobAttributes, EIF_POINTER lpName) {
  return CreateJobObject(lpJobAttributes, lpName);
}
