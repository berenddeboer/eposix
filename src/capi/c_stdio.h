/*

Access to Standard C stdio.h

*/

#ifndef _C_STDIO_H_
#define _C_STDIO_H_


#include "../supportc/eiffel.h"
#include <stdio.h>

/* constants */

EIF_INTEGER const_eof();

EIF_INTEGER const_filename_max();

EIF_INTEGER const_iofbf();
EIF_INTEGER const_iolbf();
EIF_INTEGER const_ionbf();

EIF_INTEGER const_seek_set();
EIF_INTEGER const_seek_cur();
EIF_INTEGER const_seek_end();

EIF_POINTER stream_stdin();
EIF_POINTER stream_stdout();
EIF_POINTER stream_stderr();

EIF_INTEGER const_tmp_max();


/* file system functions */

EIF_INTEGER posix_rename(EIF_POINTER old, EIF_POINTER new);
EIF_INTEGER posix_remove(EIF_POINTER filename);
EIF_POINTER posix_tmpfile();

/* functions which have a stream as argument */

void posix_clearerr(EIF_POINTER stream);
EIF_INTEGER posix_fclose(EIF_POINTER stream);
EIF_BOOLEAN posix_feof(EIF_POINTER stream);
EIF_BOOLEAN posix_ferror(EIF_POINTER stream);
EIF_INTEGER posix_fflush(EIF_POINTER stream);
EIF_INTEGER posix_fgetc(EIF_POINTER stream);
EIF_POINTER posix_fgets(EIF_POINTER s, EIF_INTEGER n, EIF_POINTER stream);
EIF_INTEGER posix_fgetpos(EIF_POINTER stream, EIF_POINTER pos);
EIF_POINTER posix_fopen(EIF_POINTER filename, EIF_POINTER mode);
EIF_INTEGER posix_fprintf_double(EIF_POINTER stream, EIF_DOUBLE d);
EIF_INTEGER posix_fprintf_int(EIF_POINTER stream, EIF_INTEGER i);
EIF_INTEGER posix_fprintf_real(EIF_POINTER stream, EIF_REAL r);
EIF_INTEGER posix_fputc(EIF_INTEGER c, EIF_POINTER stream);
EIF_INTEGER posix_fputs(EIF_POINTER s, EIF_POINTER stream);
EIF_INTEGER posix_fread(EIF_POINTER ptr, EIF_INTEGER size, EIF_INTEGER nmemb, EIF_POINTER stream);
EIF_POINTER posix_freopen(EIF_POINTER filename, EIF_POINTER mode, EIF_POINTER stream);
EIF_INTEGER posix_fscanf_double(EIF_POINTER stream, EIF_POINTER dp);
EIF_INTEGER posix_fscanf_integer(EIF_POINTER stream, EIF_POINTER ip);
EIF_INTEGER posix_fscanf_real(EIF_POINTER stream, EIF_POINTER rp);
EIF_INTEGER posix_fseek(EIF_POINTER stream, EIF_INTEGER offset, EIF_INTEGER whence);
EIF_INTEGER posix_fsetpos(EIF_POINTER stream, EIF_POINTER pos);
EIF_INTEGER posix_ftell(EIF_POINTER stream);
EIF_INTEGER posix_fwrite(EIF_POINTER ptr, EIF_INTEGER size, EIF_INTEGER nmemb, EIF_POINTER stream);
void posix_rewind(EIF_POINTER stream);
void posix_setbuf(EIF_POINTER stream, EIF_POINTER buf);
EIF_INTEGER posix_setvbuf(EIF_POINTER stream, EIF_POINTER buf, EIF_INTEGER mode, EIF_INTEGER size);
EIF_INTEGER posix_ungetc(EIF_INTEGER c, EIF_POINTER stream);


/* sizes */

EIF_INTEGER posix_fpos_t_size();


#endif /* _C_STDIO_H_ */
