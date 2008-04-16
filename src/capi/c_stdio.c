#include "c_stdio.h"


/* constants */

EIF_INTEGER const_eof()
{
  return EOF;
}


EIF_INTEGER const_iofbf()
{
  return _IOFBF;
}

EIF_INTEGER const_iolbf()
{
  return _IOLBF;
}

EIF_INTEGER const_ionbf()
{
  return _IONBF;
}


EIF_INTEGER const_seek_set()
{
  return SEEK_SET;
}

EIF_INTEGER const_seek_cur()
{
  return SEEK_CUR;
}


EIF_INTEGER const_seek_end()
{
  return SEEK_END;
}


EIF_POINTER stream_stdin()
{
  return (EIF_POINTER) stdin;
}

EIF_POINTER stream_stdout()
{
  return (EIF_POINTER) stdout;
}

EIF_POINTER stream_stderr()
{
  return (EIF_POINTER) stderr;
}


/* file system functions */

EIF_INTEGER posix_remove(EIF_POINTER filename)
{
  return remove(filename);
}


EIF_INTEGER posix_rename(EIF_POINTER old, EIF_POINTER new)
{
  return rename (old, new);
}


EIF_POINTER posix_tmpfile()
{
  return (EIF_POINTER) tmpfile();
}


/* functions which have a stream as argument */

void posix_clearerr(EIF_POINTER stream)
{
  clearerr((FILE *) stream);
}


EIF_INTEGER posix_fclose(EIF_POINTER stream)
{
  return fclose((FILE *) stream);
}


EIF_BOOLEAN posix_feof(EIF_POINTER stream)
{
  return feof( (FILE *) stream);
}


EIF_BOOLEAN posix_ferror(EIF_POINTER stream)
{
  return ferror( (FILE *) stream);
}


EIF_INTEGER posix_fflush(EIF_POINTER stream)
{
  return fflush( (FILE *) stream);
}


EIF_INTEGER posix_fgetc(EIF_POINTER stream)
{
  return fgetc( (FILE *) stream);
}


EIF_POINTER posix_fgets(EIF_POINTER s, EIF_INTEGER n, EIF_POINTER stream)
{
  return fgets (s, n, (FILE *) stream);
}


EIF_INTEGER posix_fgetpos(EIF_POINTER stream, EIF_POINTER pos)
{
  return fgetpos((FILE *) stream, (fpos_t *) pos);
}


EIF_POINTER posix_fopen(EIF_POINTER filename, EIF_POINTER mode)
{
  return ( (EIF_POINTER) fopen (filename, mode));
}


EIF_INTEGER posix_fprintf_double(EIF_POINTER stream, EIF_DOUBLE d)
{
  return fprintf((FILE *) stream, "%f", d);
}


EIF_INTEGER posix_fprintf_int(EIF_POINTER stream, EIF_INTEGER i)
{
  return fprintf((FILE *) stream, "%d", i);
}


EIF_INTEGER posix_fprintf_real(EIF_POINTER stream, EIF_REAL r)
{
  return fprintf((FILE *) stream, "%f", r);
}


EIF_INTEGER posix_fputc(EIF_INTEGER c, EIF_POINTER stream)
{
  return fputc(c, (FILE *) stream);
}


EIF_INTEGER posix_fputs(EIF_POINTER s, EIF_POINTER stream)
{
  return fputs(s, (FILE *) stream);
}


EIF_INTEGER posix_fread(EIF_POINTER ptr, EIF_INTEGER size, EIF_INTEGER nmemb, EIF_POINTER stream)
{
  return fread(ptr, size, nmemb, (FILE *) stream);
}


EIF_POINTER posix_freopen(EIF_POINTER filename, EIF_POINTER mode, EIF_POINTER stream)
{
  return ( (EIF_POINTER) freopen(filename, mode, (FILE *) stream));
}


EIF_INTEGER posix_fscanf_double(EIF_POINTER stream, EIF_POINTER dp)
{
  double res;
  int r;
  r = fscanf((FILE *) stream, "%lf", &res);
  if ( r >= 0 )
    { *((EIF_DOUBLE*)dp) = res; }
  return r;
}


EIF_INTEGER posix_fscanf_integer(EIF_POINTER stream, EIF_POINTER ip)
{
  int res;
  int r;
  r = fscanf((FILE *) stream, "%d", &res);
  if ( r >= 0 )
    { *((EIF_INTEGER*)ip) = res; }
  return r;
}

EIF_INTEGER posix_fscanf_real(EIF_POINTER stream, EIF_POINTER rp)
{
  float res;
  int r;
  r = fscanf((FILE *) stream, "%f", &res);
  if ( r >= 0 )
    { *((EIF_REAL*)rp) = res; }
  return r;
}



EIF_INTEGER posix_fseek(EIF_POINTER stream, EIF_INTEGER offset, EIF_INTEGER whence)
{
  return fseek((FILE *) stream, offset, whence);
}


EIF_INTEGER posix_fsetpos(EIF_POINTER stream, EIF_POINTER pos)
{
  return fsetpos((FILE *) stream, (fpos_t *) pos);
}


EIF_INTEGER posix_ftell(EIF_POINTER stream)
{
  return ftell((FILE *) stream);
}


EIF_INTEGER posix_fwrite(EIF_POINTER ptr, EIF_INTEGER size, EIF_INTEGER nmemb, EIF_POINTER stream)
{
  return fwrite(ptr, size, nmemb, (FILE *) stream);
}


void posix_rewind(EIF_POINTER stream)
{
  rewind((FILE *) stream);
}


void posix_setbuf(EIF_POINTER stream, EIF_POINTER buf)
{
  setbuf((FILE *) stream, buf);
}


EIF_INTEGER posix_setvbuf(EIF_POINTER stream, EIF_POINTER buf, EIF_INTEGER mode, EIF_INTEGER size)
{
  return setvbuf((FILE *) stream, buf, mode, size);
}


EIF_INTEGER posix_ungetc(EIF_INTEGER c, EIF_POINTER stream)
{
  return ungetc (c, (FILE *) stream);
}


/* sizes */

EIF_INTEGER posix_fpos_t_size()
{
  /* what if fpos_t is a struct?? */
  return sizeof(fpos_t);
}
