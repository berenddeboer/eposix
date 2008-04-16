[Cluster]
Name=EPOSIX
Sources=EPOSIX.Sources.$VE_OS
Category=SYSTEM
Description=Eiffel Full POSIX binding
Bindings=EPOSIX.Bindings

[EPOSIX.Sources.Win32]
EPOSIX_spec.Source=
EPOSIX_support.Source=
EPOSIX_capi.Source=
EPOSIX_standardc.Source=
EPOSIX_epxc.Source=
EPOSIX_wapi.Source=
EPOSIX_windows.Source=
EPOSIX_abstract.Source=

[EPOSIX.Sources.Linux]
EPOSIX_spec.Source=
EPOSIX_support.Source=
EPOSIX_capi.Source=
EPOSIX_standardc.Source=
EPOSIX_abstract.Source=
EPOSIX_papi.Source=
EPOSIX_posix.Source=
EPOSIX_sapi.Source=
EPOSIX_sus.Source=
EPOSIX_epxc.Source=
EPOSIX_epxp.Source=
EPOSIX_epxs.Source=


[EPOSIX_support.Source]
Mask=support/*.e
[EPOSIX_capi.Source]
Mask=capi/*.e
[EPOSIX_standardc.Source]
Mask=standardc/*.e
[EPOSIX_abstract.Source]
Mask=abstract/*.e
[EPOSIX_papi.Source]
Mask=papi/*.e
[EPOSIX_posix.Source]
Mask=posix/*.e
[EPOSIX_sapi.Source]
Mask=sapi/*.e
[EPOSIX_spec.Source]
Mask=spec/ve/*.e
[EPOSIX_sus.Source]
Mask=sus/*.e
[EPOSIX_wapi.Source]
Mask=wapi/*.e
[EPOSIX_windows.Source]
Mask=windows/*.e
[EPOSIX_epxc.Source]
Mask=epxc/*.e
[EPOSIX_epxp.Source]
Mask=epxp/*.e
[EPOSIX_epxs.Source]
Mask=epxs/*.e

[EPOSIX.Bindings]
Clusters=EPOSIX.Clusters
Systems=EPOSIX.Systems

[EPOSIX.Clusters]
Kernel=
MiscPool=

[Kernel]
Name=Kernel
Path=$VE_Lib/Kernel

[MiscPool]
Name=Misc/Pool
Path=$VE_Lib/Misc/Pool

[EPOSIX.Systems]
EPOSIX.System=

[EPOSIX.System]
Link_options=EPOSIX.Link_options.$VE_OS

[EPOSIX.Link_options.Linux]
$EPOSIX/lib/libeposix-VE.a=
/usr/lib/libpthread.a=
/usr/lib/librt.a=

[EPOSIX.Link_options.Win32]
$EPOSIX/lib/libeposix-VE-MSC.lib=
libc.lib=
oldnames.lib=
