/*

C layer to POSIX termios.h routines

*/

#include "p_termios.h"


EIF_INTEGER posix_cfgetispeed(const struct termios *ptr)
{
  return cfgetispeed(ptr);
}

EIF_INTEGER posix_cfgetospeed(const struct termios *ptr)
{
  return cfgetospeed(ptr);
}

EIF_INTEGER posix_cfsetispeed(struct termios *ptr, EIF_INTEGER speed)
{
  return cfsetispeed(ptr, speed);
}

EIF_INTEGER posix_cfsetospeed(struct termios *ptr, EIF_INTEGER speed)
{
  return cfsetospeed(ptr, speed);
}


EIF_INTEGER posix_tcgetattr(EIF_INTEGER fildes, EIF_POINTER ptr)
{
  return tcgetattr(fildes, ptr);
}


EIF_INTEGER posix_tcsetattr(EIF_INTEGER fildes, EIF_INTEGER option, EIF_POINTER ptr)
{
  return tcsetattr(fildes, option, ptr);
}


EIF_INTEGER posix_tcflush(EIF_INTEGER fildes, EIF_INTEGER option)
{
  return tcflush(fildes, option);
}


EIF_INTEGER const_tcsanow()
{
  return TCSANOW;
}

EIF_INTEGER const_tcsadrain()
{
  return TCSADRAIN;
}

EIF_INTEGER const_tcsaflush()
{
  return TCSAFLUSH;
}


EIF_INTEGER posix_termios_size()
{
  return (sizeof (struct termios));
}


EIF_INTEGER posix_termios_iflag(struct termios *ptr)
{
  return (ptr->c_iflag);
}

EIF_INTEGER posix_termios_oflag(struct termios *ptr)
{
  return (ptr->c_oflag);
}

EIF_INTEGER posix_termios_cflag(struct termios *ptr)
{
  return (ptr->c_cflag);
}

EIF_INTEGER posix_termios_lflag(struct termios *ptr)
{
  return (ptr->c_lflag);
}

EIF_POINTER posix_termios_cc(struct termios *ptr)
{
  return (ptr->c_cc);
}


void posix_set_termios_iflag(struct termios *ptr, EIF_INTEGER iflag)
{
  ptr->c_iflag = iflag;
}

void posix_set_termios_oflag(struct termios *ptr, EIF_INTEGER oflag)
{
  ptr->c_oflag = oflag;
}

void posix_set_termios_cflag(struct termios *ptr, EIF_INTEGER cflag)
{
  ptr->c_cflag = cflag;
}

void posix_set_termios_lflag(struct termios *ptr, EIF_INTEGER lflag)
{
  ptr->c_lflag = lflag;
}


/* input mode flags */

EIF_INTEGER const_ignbrk()
{
  return IGNBRK;
}

EIF_INTEGER const_brkint()
{
  return BRKINT;
}

EIF_INTEGER const_ignpar()
{
  return IGNPAR;
}

EIF_INTEGER const_parmrk()
{
  return PARMRK;
}

EIF_INTEGER const_inpck()
{
  return INPCK;
}

EIF_INTEGER const_istrip()
{
  return ISTRIP;
}

EIF_INTEGER const_inlcr()
{
  return INLCR;
}

EIF_INTEGER const_igncr()
{
  return IGNCR;
}

EIF_INTEGER const_icrnl()
{
  return ICRNL;
}

EIF_INTEGER const_ixon()
{
  return IXON;
}

EIF_INTEGER const_ixoff()
{
  return IXOFF;
}


/* local mode flags */

EIF_INTEGER const_isig()
{
  return ISIG;
}

EIF_INTEGER const_icanon()
{
  return ICANON;
}

EIF_INTEGER const_echo()
{
  return ECHO;
}

EIF_INTEGER const_echoe()
{
  return ECHOE;
}

EIF_INTEGER const_echok()
{
  return ECHOK;
}

EIF_INTEGER const_echonl()
{
  return ECHONL;
}

EIF_INTEGER const_noflsh()
{
  return NOFLSH;
}

EIF_INTEGER const_tostop()
{
  return TOSTOP;
}

EIF_INTEGER const_iexten()
{
  return IEXTEN;
}


/* control mode flags */

EIF_INTEGER const_csize()
{
  return CSIZE;
}

EIF_INTEGER const_cs5()
{
  return CS5;
}

EIF_INTEGER const_cs6()
{
  return CS6;
}

EIF_INTEGER const_cs7()
{
  return CS7;
}

EIF_INTEGER const_cs8()
{
  return CS8;
}

EIF_INTEGER const_cstopb()
{
  return CSTOPB;
}

EIF_INTEGER const_cread()
{
  return CREAD;
}

EIF_INTEGER const_parenb()
{
  return PARENB;
}

EIF_INTEGER const_parodd()
{
  return PARODD;
}

EIF_INTEGER const_hupcl()
{
  return HUPCL;
}

EIF_INTEGER const_clocal()
{
  return CLOCAL;
}


/* baud rates */

#undef _POSIX_SOURCE

EIF_INTEGER const_b0()
{
  return B0;
}

EIF_INTEGER const_b50()
{
  return B50;
}

EIF_INTEGER const_b75()
{
  return B75;
}

EIF_INTEGER const_b110()
{
  return B110;
}

EIF_INTEGER const_b134()
{
  return B134;
}

EIF_INTEGER const_b150()
{
  return B150;
}

EIF_INTEGER const_b200()
{
  return B200;
}

EIF_INTEGER const_b300()
{
  return B300;
}

EIF_INTEGER const_b600()
{
  return B600;
}

EIF_INTEGER const_b1200()
{
  return B1200;
}

EIF_INTEGER const_b1800()
{
  return B1800;
}

EIF_INTEGER const_b2400()
{
  return B2400;
}

EIF_INTEGER const_b4800()
{
  return B4800;
}

EIF_INTEGER const_b9600()
{
  return B9600;
}

EIF_INTEGER const_b19200()
{
  return B19200;
}

EIF_INTEGER const_b38400()
{
  return B38400;
}

EIF_INTEGER const_b57600()
{
#ifdef B57600
  return B57600;
#else
  return 0;
#endif;
}

EIF_INTEGER const_b115200()
{
#ifdef B115200
  return B115200;
#else
  return 0;
#endif;
}

EIF_INTEGER const_b230400()
{
#ifdef B230400
  return B230400;
#else
  return 0;
#endif
}


/* tcflush constants */

EIF_INTEGER const_tciflush()
{
  return TCIFLUSH;
}

EIF_INTEGER const_tcoflush()
{
  return TCOFLUSH;
}

EIF_INTEGER const_tcioflush()
{
  return TCIOFLUSH;
}
