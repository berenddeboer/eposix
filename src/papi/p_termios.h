/*

C layer to Standard C termios.h routines

*/


#ifndef _P_TERMIOS_H_
#define _P_TERMIOS_H_

#include "p_defs.h"
#include <sys/types.h>
#include <termios.h>
#include "../supportc/eiffel.h"


EIF_INTEGER posix_cfgetispeed(const struct termios *ptr);
EIF_INTEGER posix_cfgetospeed(const struct termios *ptr);
EIF_INTEGER posix_cfsetispeed(struct termios *ptr, EIF_INTEGER speed);
EIF_INTEGER posix_cfsetospeed(struct termios *ptr, EIF_INTEGER speed);

EIF_INTEGER posix_tcgetattr(EIF_INTEGER fildes, EIF_POINTER ptr);
EIF_INTEGER posix_tcsetattr(EIF_INTEGER fildes, EIF_INTEGER option, EIF_POINTER ptr);

EIF_INTEGER posix_tcflush(EIF_INTEGER fildes, EIF_INTEGER option);

EIF_INTEGER const_tcsanow();
EIF_INTEGER const_tcsadrain();
EIF_INTEGER const_tcsaflush();

EIF_INTEGER posix_termios_size();

EIF_INTEGER posix_termios_iflag(struct termios *ptr);
EIF_INTEGER posix_termios_oflag(struct termios *ptr);
EIF_INTEGER posix_termios_cflag(struct termios *ptr);
EIF_INTEGER posix_termios_lflag(struct termios *ptr);
EIF_POINTER posix_termios_cc(struct termios *ptr);

void posix_set_termios_iflag(struct termios *ptr, EIF_INTEGER iflag);
void posix_set_termios_oflag(struct termios *ptr, EIF_INTEGER oflag);
void posix_set_termios_cflag(struct termios *ptr, EIF_INTEGER cflag);
void posix_set_termios_lflag(struct termios *ptr, EIF_INTEGER lflag);


/* input mode flags */
EIF_INTEGER const_ignbrk();
EIF_INTEGER const_brkint();
EIF_INTEGER const_ignpar();
EIF_INTEGER const_parmrk();
EIF_INTEGER const_inpck();
EIF_INTEGER const_istrip();
EIF_INTEGER const_inlcr();
EIF_INTEGER const_igncr();
EIF_INTEGER const_icrnl();
EIF_INTEGER const_ixon();
EIF_INTEGER const_ixoff();

/* local mode flags */
EIF_INTEGER const_isig();
EIF_INTEGER const_icanon();
EIF_INTEGER const_echo();
EIF_INTEGER const_echoe();
EIF_INTEGER const_echok();
EIF_INTEGER const_echonl();
EIF_INTEGER const_noflsh();
EIF_INTEGER const_tostop();
EIF_INTEGER const_iexten();


/* control mode flags */
EIF_INTEGER const_csize();
EIF_INTEGER const_cs5();
EIF_INTEGER const_cs6();
EIF_INTEGER const_cs7();
EIF_INTEGER const_cs8();
EIF_INTEGER const_cstopb();
EIF_INTEGER const_cread();
EIF_INTEGER const_parenb();
EIF_INTEGER const_parodd();
EIF_INTEGER const_hupcl();
EIF_INTEGER const_clocal();


/* baud rates */
EIF_INTEGER const_b0();
EIF_INTEGER const_b50();
EIF_INTEGER const_b75();
EIF_INTEGER const_b110();
EIF_INTEGER const_b134();
EIF_INTEGER const_b150();
EIF_INTEGER const_b200();
EIF_INTEGER const_b300();
EIF_INTEGER const_b600();
EIF_INTEGER const_b1200();
EIF_INTEGER const_b1800();
EIF_INTEGER const_b2400();
EIF_INTEGER const_b4800();
EIF_INTEGER const_b9600();
EIF_INTEGER const_b19200();
EIF_INTEGER const_b38400();
EIF_INTEGER const_b57600();
EIF_INTEGER const_b115200();
EIF_INTEGER const_b230400();


/* tcflush constants */
EIF_INTEGER const_tciflush();
EIF_INTEGER const_tcoflush();
EIF_INTEGER const_tcioflush();


#endif /* _P_TERMIOS_H_ */
