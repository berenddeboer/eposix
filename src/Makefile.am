# Process this file with automake to produce Makefile.in

# our main goal is to build libeposix.a

SUBDIRS = supportc capi standardc epxc papi posix sapi sus wapi windows epxw spec

EXTRA_DIST = \
	$(ESRC) \
	Makefile.e_sources \
	build.eant library.xace loadpath.se


if LINUX
eposix_la_list = \
	supportc/libsupportc.la \
	spec/lapi/liblapi.la \
	capi/libcapi.la \
	papi/libpapi.la \
	sapi/libsapi.la
else
eposix_la_list = \
	supportc/libsupportc.la \
	capi/libcapi.la \
	papi/libpapi.la \
	sapi/libsapi.la
endif

if SE
lib_LTLIBRARIES = libeposix_se.la
libeposix_se_la_SOURCES =
libeposix_se_la_LDFLAGS = -no-undefined -version-info 0:0:0
libeposix_se_la_LIBADD = ${eposix_la_list}
endif

if GE
lib_LTLIBRARIES = libeposix_ge.la
libeposix_ge_la_SOURCES =
libeposix_ge_la_LDFLAGS = -no-undefined -version-info 0:0:0
libeposix_ge_la_LIBADD = ${eposix_la_list}
endif

if ISE
if THREADS
lib_LTLIBRARIES = libeposixmt_ise.la
libeposixmt_ise_la_SOURCES =
libeposixmt_ise_la_LDFLAGS = -no-undefined -version-info 0:0:0
libeposixmt_ise_la_LIBADD = ${eposix_la_list}
else
lib_LTLIBRARIES = libeposix_ise.la
libeposix_ise_la_SOURCES =
libeposix_ise_la_LDFLAGS = -no-undefined -version-info 0:0:0
libeposix_ise_la_LIBADD = ${eposix_la_list}
endif
endif

include Makefile.e_sources

noinst_PKGDATA = \
	Makefile.e_sources \
	library.xace cluster.es \
	sus/loadpath.se posix/loadpath.se windows/loadpath.se standardc/loadpath.se \
	$(ESRC)


# Override tags, autoconf doesn't seem to work with Darren Hieberts
# Exuberant Ctags package which I need

TAGS: $(ESRC)
	etags -R  --extra=+q --exclude=*.mak --exclude=Makefile*
