indexing

	description:

		"Base class for Internet Protocols that use a 3 digit numeric reply code such as FTP or SMTP."

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


deferred class

	EPX_TCP_CLIENT_WITH_REPLY_CODE_BASE


inherit

	EPX_TCP_CLIENT_BASE
		redefine
			close
		end

	EPX_REPLY_CODE
		rename
			reply_code as last_reply_code
		end


feature -- Close and open

	close is
			-- Close connection to server.
		do
			precursor
			last_reply_code := 0
		ensure then
			reply_code_reset: last_reply_code = 0
		end


feature -- Reading and writing

	read_reply is
			-- Read input from server and parse it into its components.
		require
			open: is_open
		local
			no_more_lines: BOOLEAN
			line: STRING
		do
			from
				last_reply_code := 0
			until
				socket.end_of_input or else
				no_more_lines
			loop
				socket.read_line
				if not socket.end_of_input then
					line := socket.last_string
					debug ("smtp")
						print (line)
						print ("%N")
					end
					if is_line_with_reply_code (line) then
						no_more_lines := line.item (4) = ' '
						if no_more_lines then
							last_reply_code := line.substring (1, 3).to_integer
							last_reply := line
						end
					end
				else
					-- Shouldn't happen.
					-- Set `last_reply_code' to something?
					last_reply_code := 426
				end
			end
		end


feature -- Access

	last_reply: STRING
			-- Last line of reply including the reply code


feature -- Status

	is_accepting_commands: BOOLEAN is
			-- Is the server in a state to accept any kind of command?
		do
			Result :=
				is_open and then
				socket.is_open_write
		end


feature {NONE} -- Low level protocol reading and writing

	async_put_command (a_command, a_parameter: STRING) is
			-- Send `a_command' and optional `a_parameter' to server.
			-- Do not wait for reply.
		require
			can_put_command: is_accepting_commands
			command_not_empty: a_command /= Void and then not a_command.is_empty
		local
			cmd: STRING
		do
			if a_parameter = Void or else a_parameter.is_empty then
				create cmd.make (a_command.count + 2)
			else
				create cmd.make (a_command.count + 1 + a_parameter.count + 2)
			end
			cmd.append_string (a_command)
			if a_parameter /= Void and then not a_parameter.is_empty then
				cmd.append_character (' ')
				cmd.append_string (a_parameter)
			end
			debug ("test")
				print ("->")
				print (cmd)
				print ("%N")
			end
			cmd.append_character ('%R')
			cmd.append_character ('%N')
			socket.put_string (cmd)
		end

	put_command (a_command, a_parameter: STRING) is
			-- Send `a_command' and optional `a_parameter' to server.
			-- Wait for reply.
		require
			can_put_command: is_accepting_commands
			command_not_empty: a_command /= Void and then not a_command.is_empty
		do
			async_put_command (a_command, a_parameter)
			read_reply
		end

	read_until_server_ready_for_input is
			-- Read until server sends a 220.
		require
			open: is_open
		do
			socket.errno.clear
			socket.errno.clear_first
			from
				last_reply_code := 0
			until
				socket.errno.is_not_ok or else
				socket.end_of_input or else
				last_reply_code = 220 or else
				is_permanent_negative_completion_reply
			loop
				read_reply
			end
		end


end
