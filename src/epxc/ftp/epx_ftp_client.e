indexing

	description:

		"FTP client"

	standards: "RFC 959"
	bugs: "No support for reply 125, data connection already open. When does that happen?"
	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"


class

	EPX_FTP_CLIENT


inherit

	EPX_TCP_CLIENT_WITH_REPLY_CODE_BASE
		rename
			socket as control_connection,
			tcp_socket as tcp_control_connection
		redefine
			close
		end

	EPX_FTP_REPLY_CODE
		rename
			reply_code as last_reply_code
		end

	EPX_NET_API


create

	make,
	make_anonymous,
	make_anonymous_with_port,
	make_with_port


feature {NONE} -- Initialization

	make_anonymous (a_server_name: STRING; an_email: STRING) is
			-- Connect to `a_server_name' using the anonymous
			-- user. Password is either an email address or just "guest"
			-- if the remote system allows that.
		require
			closed: not is_open
			server_name_not_empty: a_server_name /= Void and then not a_server_name.is_empty
		do
			make (a_server_name, once_anonymous, an_email)
		end

	make_anonymous_with_port (a_server_name: STRING; a_port: INTEGER; an_email: STRING) is
			-- Connect to `a_server_name' using the anonymous
			-- user. Password is either an email address or just "guest"
			-- if the remote system allows that.
		require
			closed: not is_open
			server_name_not_empty: a_server_name /= Void and then not a_server_name.is_empty
			valid_port: a_port >= 0 and a_port <= 65535
		do
			make_with_port (a_server_name, a_port, once_anonymous, an_email)
		end


feature -- Open/close

	close is
			-- Close connection to FTP server.
		do
			is_authenticated := False
			precursor
		end

	close_data_connection is
			-- Close `data_connection' and set it to Void.
		do
			if
				data_connection /= Void and then
				data_connection.is_open
			then
				data_connection.close
			end
			data_connection := Void
		ensure
			data_connection_gone: data_connection = Void
		end


feature -- Connection registration

	authenticate is
		do
			read_until_server_ready_for_input
			if last_reply_code = 220 then
				user_and_password (user_name, password)
			else
				close
			end
		end


feature -- Access

	data_connection: ABSTRACT_TCP_CLIENT_SOCKET
			-- Connection over which data is transferred, in a specified
			-- mode and type; the data transferred may be a part of a
			-- file, an entire file or a number of files.
			-- Only valid after a command is sent that returns data.

	default_port: INTEGER is 25
			-- Default FTP port

	default_port_name: STRING is
		do
			Result := once_ftp
		end

	server_operating_system: STRING
			-- OS if `operating_system' has been called;
			-- It should be one of the names listed RFC 943.


feature -- Status

	is_authenticated: BOOLEAN
			-- Is client successfully authenticated at the server?

	is_command_ok: BOOLEAN is
			-- Did last command complete successfully?
		require
			open: is_open
		do
			Result := last_reply_code >= 200 and last_reply_code <= 299
		end


feature -- FTP commands

	change_to_parent_directory is
			-- This command is a special case of CWD, and is included to
			-- simplify the implementation of programs for transferring
			-- directory trees between operating systems having different
			-- syntaxes for naming the parent directory.  The reply codes
			-- shall be identical to the reply codes of CWD.
		require
			ready_for_commands: is_accepting_commands
		do
			put_command (commands.cdup, Void)
		end

	change_directory (a_directory: STRING) is
			-- This command allows the user to work with a different
			-- directory or dataset for file storage or retrieval without
			-- altering his login or accounting information.  Transfer
			-- parameters are similarly unchanged.  The argument is a
			-- pathname specifying a directory or other system dependent
			-- file group designator.
		require
			ready_for_commands: is_accepting_commands
			a_directory_not_empty: a_directory /= Void and then not a_directory.is_empty
		do
			put_command (commands.cwd, a_directory)
		end

	change_working_directory (a_directory: STRING) is
		obsolete "2004-12-10: use change_directory instead"
		do
			change_directory (a_directory)
		end

	delete_file (a_filename: STRING) is
		obsolete "Use remove_file instead."
		do
			remove_file (a_filename)
		end

	help is
			-- This command shall cause the server to send helpful
			-- information regarding its implementation status over the
			-- control connection to the user.  The command may take an
			-- argument (e.g., any command name) and return more specific
			-- information as a response.  The reply is type 211 or 214.
			-- It is suggested that HELP be allowed before entering a
			-- USER command. The server may use this reply to specify
			-- site-dependent parameters, e.g., in response to HELP SITE.
		require
			ready_for_commands: is_accepting_commands
		do
			put_command (commands.help, Void)
		end

	list is
			-- This command causes a list to be sent from the server to
			-- the passive DTP.
			-- Since the information on a file may vary widely from
			-- system to system, this information may be hard to use
			-- automatically in a program, but may be quite useful to a
			-- human user.
		require
			ready_for_commands: is_accepting_commands
		do
			put_command_with_data_connection (commands.list, Void)
		ensure
			have_data_connection_on_success:
				last_reply_code = 150 = (data_connection /= Void)
			data_connection_can_read_and_write:
				data_connection /= Void implies
					data_connection.is_open_read and then
					data_connection.is_open_write
		end

	make_directory (a_directory: STRING) is
			-- This command causes the directory specified in the
			-- pathname to be created as a directory (if the pathname is
			-- absolute) or as a subdirectory of the current working
			-- directory (if the pathname is relative).
		require
			ready_for_commands: is_accepting_commands
			a_directory_not_empty: a_directory /= Void and then not a_directory.is_empty
		do
			put_command (commands.mkd, a_directory)
		end

	name_list is
			-- This command causes a directory listing to be sent from
			-- server to user site through `data_connection'. The server
			-- will return a stream of names of files and no other
			-- information.
		require
			ready_for_commands: is_accepting_commands
		do
			put_command_with_data_connection (commands.nlst, Void)
		ensure
			have_data_connection_on_success:
				last_reply_code = 150 = (data_connection /= Void)
			data_connection_can_read_and_write:
				data_connection /= Void implies
					data_connection.is_open_read and then
					data_connection.is_open_write
		end

	noop is
			-- This command does not affect any parameters or previously
			-- entered commands. It specifies no action other than that
			-- the server send an OK reply.
		require
			ready_for_commands: is_accepting_commands
		do
			put_command (commands.noop, Void)
		end

	quit is
			-- This command terminates a USER and if file transfer is not
			-- in progress, the server closes the control connection.  If
			-- file transfer is in progress, the connection will remain
			-- open for result response and the server will then close
			-- it.  If the user-process is transferring files for several
			-- USERs but does not wish to close and then reopen
			-- connections for each, then the REIN command should be used
			-- instead of QUIT.
		require
			ready_for_commands: is_accepting_commands
		do
			put_command (commands.quit, Void)
			is_authenticated := False
			--control_connection.shutdown_write
			if tcp_control_connection /= Void then
				tcp_control_connection.shutdown_write
			end
		ensure
			not_authenticated: not is_authenticated
			cannot_write: not control_connection.is_open_write
		end

	remove_directory (a_directory: STRING) is
			-- This command causes the directory specified in the
			-- pathname to be removed as a directory (if the pathname is
			-- absolute) or as a subdirectory of the current working
			-- directory (if the pathname is relative).
		require
			ready_for_commands: is_accepting_commands
			a_directory_not_empty: a_directory /= Void and then not a_directory.is_empty
		do
			put_command (commands.rmd, a_directory)
		end

	remove_file (a_filename: STRING) is
			-- This command causes the file specified in the pathname to
			-- be deleted at the server site.
		require
			ready_for_commands: is_accepting_commands
			filename_not_empty: a_filename /= Void and then not a_filename.is_empty
		do
			put_command (commands.dele, a_filename)
		end

	rename_to (an_old_filename, a_new_filename: STRING) is
			-- Rename a filename from `an_old_filename_ to `a_new_filename'.
		require
			ready_for_commands: is_accepting_commands
			old_filename_not_empty: an_old_filename /= Void and then not an_old_filename.is_empty
			new_filename_not_empty: a_new_filename /= Void and then not a_new_filename.is_empty
		do
			put_command (commands.rnfr, an_old_filename)
			if last_reply_code = 350 then
				put_command (commands.rnto, a_new_filename)
			end
		end

	retrieve (a_filename: STRING) is
			-- Start copying the giving file to `data_connection'. Client
			-- must read all bytes from `data_connection' to retrieve the
			-- data. Afterwards call `read_reply' to retrieve the final
			-- status code for this call.
		require
			ready_for_commands: is_accepting_commands
			filename_not_empty: a_filename /= Void and then not a_filename.is_empty
		do
			put_command_with_data_connection (commands.retr, a_filename)
		ensure
			have_data_connection_on_success:
				last_reply_code = 150 = (data_connection /= Void)
			data_connection_can_read_and_write:
				data_connection /= Void implies
					data_connection.is_open_read and then
					data_connection.is_open_write
		end

	operating_system is
			-- This command (SYST) is used to find out the type of
			-- operating system at the server. The reply has as its first
			-- word one of the system names listed in the current version
			-- of the Assigned Numbers document.
		require
			ready_for_commands: is_accepting_commands
		local
			p: INTEGER
		do
			put_command (commands.syst, Void)
			if last_reply_code = 215 then
				if last_reply.count >= 5 then
					p := last_reply.index_of (' ', 6)
					if p = 0 then
						p := last_reply.count + 1
					end
					server_operating_system := last_reply.substring (5, p - 1)
				else
					create server_operating_system.make_empty
				end
			else
				server_operating_system := Void
			end
		ensure
			remote_operating_system_set: last_reply_code = 215 = (server_operating_system /= Void)
		end

	store (a_filename: STRING) is
			-- This command causes the server-DTP to accept the data
			-- transferred via the data connection and to store the data
			-- as a file at the server site.  If the file specified in
			-- the pathname exists at the server site, then its contents
			-- shall be replaced by the data being transferred.  A new
			-- file is created at the server site if the file specified
			-- in the pathname does not already exist.
			-- Client must write data to `data_connection' and close
			-- `data_connection' when finished.
			-- Afterwards call `read_reply' to retrieve the final
			-- status code for this call.
		require
			ready_for_commands: is_accepting_commands
			filename_not_empty: a_filename /= Void and then not a_filename.is_empty
		do
			put_command_with_data_connection (commands.stor, a_filename)
		ensure
			have_data_connection_on_success:
				last_reply_code = 150 = (data_connection /= Void)
			data_connection_can_read_and_write:
				data_connection /= Void implies
					data_connection.is_open_read and then
					data_connection.is_open_write
		end

	type_ascii is
			-- The sender converts the data from an internal character
			-- representation to the standard 8-bit NVT-ASCII
			-- representation (see the Telnet specification).
		require
			ready_for_commands: is_accepting_commands
		do
			put_command (commands.type, "A")
		end

	type_binary is
			-- Data is sent without change as a stream of continguous
			-- bits.
		require
			ready_for_commands: is_accepting_commands
		do
			put_command (commands.type, "I")
		end

	user_and_password (a_user_name, a_password: STRING) is
			-- Identify as `a_user_name' to server.
		require
			ready_for_commands: is_accepting_commands
			a_user_name_not_empty: a_user_name /= Void and then not a_user_name.is_empty
		do
			user_name := a_user_name
			password := a_password
			put_command (commands.user, a_user_name)
			if last_reply_code= 331 then
				put_command (commands.password, password)
				is_authenticated := last_reply_code = 230
			end
		end


feature -- FTP connection control

	await_reply is
		obsolete "2004-12-10: use read_reply instead."
		do
			read_reply
		end


feature {NONE} -- Lowest level FTP server interaction

	async_send_command (a_command, a_parameter: STRING) is
		obsolete "2004-12-10: Use async_put_command instead."
		do
			async_put_command (a_command, a_parameter)
		end

	commands: EPX_FTP_COMMANDS is
			-- FTP commands
		once
			create Result
		ensure
			not_void: Result /= Void
		end

	hp: EPX_HOST_PORT

	put_command_with_data_connection  (a_command, a_parameter: STRING) is
			-- Setup a data connection, send `a_command'.
			-- If reply other than 150 is received, data connection is closed.
		require
			can_put_command: is_accepting_commands
			command_not_empty: a_command /= Void and then not a_command.is_empty
		do
			setup_data_connection
			if data_connection /= Void then
				put_command (a_command, a_parameter)
				if last_reply_code /= 150 then
					close_data_connection
				end
			end
		ensure
			have_data_connection_on_success:
				last_reply_code = 150 = (data_connection /= Void)
			data_connection_can_read_and_write:
				data_connection /= Void implies
					data_connection.is_open_read and then
					data_connection.is_open_write
		end

	send_command (a_command, a_parameter: STRING) is
		obsolete "2004-12-10: use put_command instead."
		do
			put_command (a_command, a_parameter)
		end

	setup_data_connection is
			-- Setup a data connection with the server.
		require
			ready_for_commands: is_accepting_commands
		local
			tcp: EPX_TCP_CLIENT_SOCKET
			ip4: EPX_IP4_ADDRESS
			data_host: EPX_HOST
			data_service: EPX_SERVICE
			a1,a2,a3,a4,p1,p2: INTEGER
		do
			if
				data_connection /= Void and then
				data_connection.is_open
			then
				data_connection.close
			end
			data_connection := Void
			put_command (commands.passive, Void)
			if last_reply_code = 227 then
				-- parse pasv reply
				-- 227 Entering Passive Mode (127,0,0,1,255,195)
				--                                      p1, p2
				-- TODO: Support IPv6?
				rx_pasv_post_port.match (last_reply)
				if rx_pasv_post_port.has_matched then
					a1 := rx_pasv_post_port.captured_substring (1).to_integer
					a2 := rx_pasv_post_port.captured_substring (2).to_integer
					a3 := rx_pasv_post_port.captured_substring (3).to_integer
					a4 := rx_pasv_post_port.captured_substring (4).to_integer
					p1 := rx_pasv_post_port.captured_substring (5).to_integer
					p2 := rx_pasv_post_port.captured_substring (6).to_integer
					create ip4.make_from_components (a1, a2, a3, a4)
					create data_host.make_from_address (ip4)
					-- The user-process default data port is the same as the
					-- control connection port.
					create data_service.make_from_port (p1 * 256 + p2, "tcp")
					debug ("test")
						print ("connecting data socket to ")
						print (ip4.value)
						print (":")
						print (data_service.port)
						print (" (")
						print (posix_htonl (ip4.value))
						print (":")
						print (posix_htons (data_service.port))
						print (")%N")
					end
					create hp.make (data_host, data_service)
					create tcp.open_by_address (hp)
					data_connection := tcp
				else
					last_reply_code := 501
				end
				rx_pasv_post_port.wipe_out
			end
		ensure
			data_connection_connected:
				data_connection = Void or else
				data_connection.is_open_read and then
				data_connection.is_open_write
		end


feature {NONE} -- Implementation

	rx_pasv_post_port: RX_PCRE_REGULAR_EXPRESSION is
		once
			create Result.make
			Result.compile ("([0-2]?[0-9]?[0-9]),([0-2]?[0-9]?[0-9]),([0-2]?[0-9]?[0-9]),([0-2]?[0-9]?[0-9]),([0-2]?[0-9]?[0-9]),([0-2]?[0-9]?[0-9])")
		ensure
			rx_pasv_post_port_not_void: Result /= Void
			rx_pasv_post_port_compiled: Result.is_compiled
		end


feature {NONE} -- Once strings

	once_anonymous: STRING is "anonymous"


invariant

	authenticated_implies_open: is_authenticated implies is_open

end
