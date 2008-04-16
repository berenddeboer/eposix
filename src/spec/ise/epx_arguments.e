indexing

	description:

		"Arguments passed to a process"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/03/14 $"
	revision: "$Revision: #1 $"


class

	EPX_ARGUMENTS


inherit

	ARGUMENTS
		export
			{NONE} all;
			{ANY} argument, argument_count, command_name
		end


end
