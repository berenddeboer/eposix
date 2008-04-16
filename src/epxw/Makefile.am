# Process this file with automake to produce Makefile.in

# We have a rule to produce the messages.dll that clients can use
# in an NT Event Source to register as the messages file.

include $(top_srcdir)/config/myrules.mak

BUILT_SOURCES = messages.dll

EXTRA_DIST = messages.mc messages.dll


messages.dll: messages.mc
	mc $<
	rc -r -fo messages.res messages.rc
	link -machine:IX86 -dll -noentry -out:$@ messages.res
