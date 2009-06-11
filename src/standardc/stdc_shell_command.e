indexing

	description: "Class that covers the Standard C system command, %
	%i.e. interaction with the shell."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"

class

	STDC_SHELL_COMMAND


inherit

	STDC_CHILD_PROCESS

	CAPI_STDLIB
		export
			{NONE} all
		end


create

	make


feature -- Initialization

	make (a_command: STRING) is
			-- Set command to execute. Command is not subject to expansion.
		require
			valid_command: a_command /= Void and then not a_command.is_empty
		do
			command := a_command
		end


feature -- Execute the command

	execute is
			-- Execute `command'. Error reporting is system dependent.
		do
			running := True
			exit_code := posix_system (sh.string_to_pointer (command))
			sh.unfreeze_all
			running := False
		rescue
			running := False
		end


feature -- Access

	command: STRING
			-- The command to `execute'.

	exit_code: INTEGER
			-- Exit code after `execute'.


invariant

	valid_command: command /= Void and then not command.is_empty

end
