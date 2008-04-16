#include "s_stdlib.h"


EIF_INTEGER posix_mkstemp(EIF_POINTER template)
{
  return (EIF_INTEGER) mkstemp ((char *) template);
}

EIF_INTEGER posix_putenv(EIF_POINTER string)
{
  return putenv(string);
}

EIF_POINTER posix_realpath(EIF_POINTER path, EIF_POINTER resolved_path)
{
#ifdef HAVE_REALPATH
  return (EIF_POINTER) realpath (path, resolved_path);
#else
  /* BeOS has no realpath, make something up */
  int r;
  char *p;
  char *tmp;
  tmp = malloc(PATH_MAX);
  if (tmp == NULL) {
    return NULL;
  }
  p = getcwd (tmp, PATH_MAX);
  if (p == NULL) {
    free (tmp);
    return NULL;
  }
  r = chdir (path);
  if (r == -1 ) {
    free (tmp);
    return NULL;
  }
  p = getcwd (resolved_path, PATH_MAX);
  if (p == NULL) {
    free (tmp);
    return NULL;
  }
  r = chdir (tmp);
  if (r == -1 ) {
    free (tmp);
    return NULL;
  }
  free (tmp);
  return resolved_path;
#endif
}
