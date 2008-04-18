indexing

	description:

		"Arguments passed to a process"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_ARGUMENTS


inherit

	ARGUMENTS
		rename
			arguments as old_arguments
		export
			{NONE} all;
			{ANY} argument, argument_count, command_name
		end


end
