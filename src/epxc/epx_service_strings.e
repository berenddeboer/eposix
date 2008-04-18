indexing

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

	once_tcp: STRING is "tcp"

	once_udp: STRING is "udp"


feature -- Port names as listed in /etc/services

	once_ftp: STRING is "ftp"
	once_http: STRING is "http"
	once_https: STRING is "https"
	once_ircd: STRING is "ircd"
	once_smtp: STRING is "smtp"


end
