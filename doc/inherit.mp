input bon.mp ;

beginfig (1) ;

path stdcbase, posixbase ;

stdcbase := deferredclass (btex \it STDC\_BASE etex, 4cm, 5cm) ;
posixbase := deferredclass (btex \it POSIX\_BASE etex, 4cm, 1cm) ;
isa (posixbase, stdcbase) ;

endfig ;


\beginfig (2) ;
path stdcbase, posixbase, basebase ;

stdcbase := deferredclass (btex \it STDC\_BASE etex, 4cm, 9cm) ;
basebase := deferredclass (btex \it ABSTRACT etex, 4cm, 5cm) ;
posixbase := deferredclass (btex \it POSIX\_BASE etex, 4cm, 1cm) ;
isa (basebase, stdcbase) ;
isa (posixbase, basebase) ;

endfig ;


beginfig (3) ;

path posixbase ;

posixbase := deferredclass (btex \it POSIX\_BASE etex, 4cm, 1cm) ;

endfig ;


\beginfig (4) ;
path posixbase, basebase ;

basebase := deferredclass (btex \it ABSTRACT etex, 4cm, 5cm) ;
posixbase := deferredclass (btex \it POSIX\_BASE etex, 4cm, 1cm) ;
isa (posixbase, basebase) ;

endfig ;


% ex_file1.e
\beginfig (5) ;
  path stdcfile, stdctextfile ;
  path posixfile, posixtextfile, ex ;

  stdcfile := deferredclass (btex \it STDC\_FILE etex, 9cm, 9cm) ;
  stdctextfile := effectiveclass (btex \it STDC\_TEXT\_FILE etex, 4cm, 5cm) ;
  posixfile := deferredclass (btex \it POSIX\_FILE etex, 9cm, 5cm) ;
  posixtextfile := effectiveclass (btex \it POSIX\_TEXT\_FILE etex, 9cm, 1cm) ;
  isa (stdctextfile, stdcfile) ;
  isa (posixfile, stdcfile) ;
  isa (posixtextfile, stdctextfile) ;
  isa (posixtextfile, posixfile) ;
  ex := rootclass (btex \it EX\_FILE1 etex, 4cm, 1cm) ;
  hasa (ex, posixtextfile) ;
endfig ;


% ex_fork1.e
\beginfig (6) ;
  path posixtextfile, posixforkroot, posixchildprocess, posixcurrentprocess ;
  path ex, forkchild ;

  posixcurrentprocess := class (btex \it POSIX\_CURRENT\_PROCESS etex, 9cm, 9cm) ;
  posixchildprocess := deferredclass (btex \it POSIX\_CHILD\_PROCESS etex, 14cm, 9cm) ;
  posixtextfile := effectiveclass (btex \it POSIX\_TEXT\_FILE etex, 9cm, 5cm) ;
  posixforkroot := deferredclass (btex \it POSIX\_FORK\_ROOT etex, 14cm, 5cm) ;
  forkchild := deferredclass (btex \it FORK\_CHILD etex, 14cm, 1cm) ;
  ex := rootclass (btex \it EX\_FORK1 etex, 4cm, 1cm) ;
  hasa (ex, posixtextfile) ;
  hasa (ex, forkchild) ;
  hasa (forkchild, posixtextfile) ;
  isa (forkchild, posixforkroot) ;
  isa (posixforkroot, posixchildprocess) ;
  isa (posixforkroot, posixcurrentprocess) ;
  isa (ex, posixcurrentprocess) ;
endfig ;


% constants
\beginfig (7) ;
  path posixconstants, stdcconstants ;

  stdcconstants := effectiveclass (btex \it STDC\_CONSTANTS etex, 4cm, 5cm) ;
  posixconstants := effectiveclass (btex \it POSIX\_CONSTANTS etex, 4cm, 1cm) ;
  isa (posixconstants, stdcconstants) ;
endfig ;


% ex_modem.e
\beginfig (8) ;
  path posixbase, posixtermios, posixfd ;
  path ex ;

  posixbase := deferredclass (btex \it POSIX\_BASE etex, 9cm, 5cm) ;
  posixfd := effectiveclass (btex \it POSIX\_FILE\_DESCRIPTOR etex, 4cm, 1cm) ;
  posixtermios := effectiveclass (btex \it POSIX\_TERMIOS etex, 14cm, 1cm) ;
  isa (posixtermios, posixbase) ;
  isa (posixfd, posixbase) ;
  ex := rootclass (btex \it EX\_MODEM etex, 9cm, 1cm) ;
  hasa (ex, posixtermios) ;
  hasa (ex, posixfd) ;
endfig ;


% ex_file3.e
\beginfig (9) ;
  path stdcfile, stdctextfile ;
  path ex ;

  stdcfile := deferredclass (btex \it STDC\_FILE etex, 9cm, 5cm) ;
  stdctextfile := effectiveclass (btex \it STDC\_TEXT\_FILE etex, 9cm, 1cm) ;
  isa (stdctextfile, stdcfile) ;
  ex := rootclass (btex \it EX\_FILE3 etex, 4cm, 1cm) ;
  hasa (ex, stdctextfile) ;
endfig ;


% ex_fd4.e
\beginfig (10) ;
  path posixfd, posixlock ;
  path ex ;

  posixbase := deferredclass (btex \it POSIX\_BASE etex, 9cm, 5cm) ;
  posixfd := effectiveclass (btex \it POSIX\_FILE\_DESCRIPTOR etex, 4cm, 1cm) ;
  posixlock := effectiveclass (btex \it POSIX\_LOCK etex, 14cm, 1cm) ;
  isa (posixlock, posixbase) ;
  isa (posixfd, posixbase) ;
  ex := rootclass (btex \it EX\_FD4 etex, 9cm, 1cm) ;
  hasa (ex, posixtermios) ;
  hasa (ex, posixfd) ;
endfig ;


% ex_dir5.e
\beginfig (11) ;
  path stdcfilesystem, stdcbase ;
  path ex ;

  stdcbase := deferredclass (btex \it STDC\_BASE etex, 4cm, 9cm) ;
  stdcfilesystem := effectiveclass (btex \it STDC\_FILE\_SYSTEM etex, 4cm, 5cm) ;
  isa (stdcfilesystem, stdcbase) ;
  ex := rootclass (btex \it EX\_DIR5 etex, 4cm, 1cm) ;
  isa (ex, stdcfilesystem) ;
endfig ;


beginfig (12) ;

path stdcbase, windowsbase ;

stdcbase := deferredclass (btex \it STDC\_BASE etex, 4cm, 5cm) ;
windowsbase := deferredclass (btex \it WINDOWS\_BASE etex, 4cm, 1cm) ;
isa (windowsbase, stdcbase) ;

endfig ;


\beginfig (13) ;
path stdcbase, posixbase, abstractfd, windowsbase, windowsfd ;
path factory ;

stdcbase := deferredclass (btex \it STDC\_BASE etex, 6cm, 9cm) ;

posixbase := deferredclass (btex \it POSIX\_BASE etex, 1cm, 5cm) ;
abstractfd := deferredclass (btex \it ABSTRACT\_FD etex, 6cm, 5cm) ;
windowsbase := deferredclass (btex \it WINDOWS\_BASE etex, 11cm, 5cm) ;

posixfd := effectiveclass (btex \it POSIX\_FD etex, 1cm, 1cm) ;
factory := effectiveclass (btex \it EPX\_FACTORY etex, 6cm, 1cm) ;
windowsfd := effectiveclass (btex \it WINDOWS\_FD etex, 11cm, 1cm) ;

isa (windowsbase, stdcbase) ;
isa (abstractfd, stdcbase) ;
isa (posixbase, stdcbase) ;
isa (posixfd, posixbase) ;
isa (posixfd, abstractfd) ;
isa (windowsfd, windowsbase) ;
isa (windowsfd, abstractfd) ;
hasa (factory, posixfd) ;
hasa (factory, windowsfd) ;
hasa (factory, abstractfd) ;

endfig ;


beginfig (14) ;

path stdccurrentprocess, xmlgenerator, xhtmlgenerator, epxcgi ;

stdccurrentprocess := effectiveclass (btex \it STDC\_CURRENT\_PROCESS etex, 1cm, 5cm) ;
xmlgenerator := effectiveclass (btex \it XML\_GENERATOR etex, 7cm, 9cm) ;
xhtmlgenerator := effectiveclass (btex \it XHTML\_GENERATOR etex, 7cm, 5cm) ;
isa (xhtmlgenerator, xmlgenerator) ;

epxcgi := effectiveclass (btex \it EPX\_CGI etex, 4cm, 1cm) ;
isa (epxcgi, stdccurrentprocess) ;
isa (epxcgi, xhtmlgenerator) ;

endfig ;


\beginfig (15) ;
path posixbase, abstractfd, windowsbase, windowsfd ;
path epxfda, epxfdb ;

posixbase := deferredclass (btex \it POSIX\_BASE etex, 1cm, 9cm) ;
abstractfd := deferredclass (btex \it ABSTRACT\_FD etex, 6cm, 9cm) ;
windowsbase := deferredclass (btex \it WINDOWS\_BASE etex, 11cm, 9cm) ;

epxfda := effectiveclass (btex \it EPX\_FD etex, 1cm, 5cm) ;
epxfdb := effectiveclass (btex \it EPX\_FD etex, 11cm, 5cm) ;

posixfd := effectiveclass (btex \it POSIX\_FD etex, 1cm, 1cm) ;
windowsfd := effectiveclass (btex \it WINDOWS\_FD etex, 11cm, 1cm) ;

isa (epxfda, abstractfd) ;
isa (epxfda, posixbase) ;
isa (epxfdb, abstractfd) ;
isa (epxfdb, windowsbase) ;

isa (posixfd, epxfda) ;
isa (windowsfd, epxfdb) ;

endfig ;


\beginfig (16) ;
path server, connection, servlet ;
% path socket ;

connection := effectiveclass (btex \it EPX\_HTTP\_CONNECTION etex, 1cm, 9cm) ;
server := effectiveclass (btex \it EPX\_HTTP\_SERVER etex, 6cm, 9cm) ;
servlet := effectiveclass (btex \it EPX\_HTTP\_SERVLET etex, 11cm, 9cm) ;

% socket := effectiveclass (btex \it EPX\_TCP\_SERVER\_SOCKET etex, 1cm, 5cm) ;

hasa (server, connection) ;
hasa (server, servlet) ;
% hasa (server, socket) ;

endfig ;


end.