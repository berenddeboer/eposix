#include "w_fcntl.h"

EIF_INTEGER const_o_append()
{
  return _O_APPEND;
}

EIF_INTEGER const_o_binary()
{
  return _O_BINARY;
}

EIF_INTEGER const_o_creat()
{
  return _O_CREAT;
}

EIF_INTEGER const_o_excl()
{
  return _O_EXCL;
}

EIF_INTEGER const_o_random()
{
#ifdef __BORLANDC__
  return 0x0010;
#else
#ifdef _O_RANDOM
  return _O_RANDOM;
#else
  return 0x0010;
#endif
#endif
}

EIF_INTEGER const_o_rdonly()
{
  return _O_RDONLY;
}

EIF_INTEGER const_o_rdwr()
{
  return _O_RDWR;
}

EIF_INTEGER const_o_short_lived()
{
#ifdef _O_SHORT_LIVED
  return _O_SHORT_LIVED;
#else
  return 0x1000;
#endif
}

EIF_INTEGER const_o_temporary()
{
#ifdef _O_TEMPORARY
  return _O_TEMPORARY;
#else
  return 0x0040;
#endif
}

EIF_INTEGER const_o_sequential()
{
#ifdef _O_SEQUENTIAL
  return _O_SEQUENTIAL;
#else
  return 0x0020;
#endif
}

EIF_INTEGER const_o_text()
{
  return _O_TEXT;
}

EIF_INTEGER const_o_trunc()
{
  return _O_TRUNC;
}

EIF_INTEGER const_o_wronly()
{
  return _O_WRONLY;
}
