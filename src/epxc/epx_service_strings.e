note

	description:

		"Strings used frequently when working with EPX_SERVICE."

	usage: "Use as mixin, so you avoid creating unnecessary strings."

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_SERVICE_STRINGS


feature -- Protocol strings

	once_tcp: STRING = "tcp"

	once_udp: STRING = "udp"


feature -- Port names as listed in /etc/services

	once_ftp: STRING = "ftp"
	once_http: STRING = "http"
	once_https: STRING = "https"
	once_ircd: STRING = "ircd"
	once_smtp: STRING = "smtp"


end
