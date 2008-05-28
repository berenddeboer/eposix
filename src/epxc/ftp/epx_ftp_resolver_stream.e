indexing

	description:

		"Streams returned by EPX_FTP_URI_RESOLVER"

	library: "eposix"
	author: "Colin Adams"
	copyright: "Copyright (c) 2004, Colin Adams"
	license: "MIT License"
	date: "$Date: "
	revision: "$Revision: "


class

	EPX_FTP_RESOLVER_STREAM

inherit

	KI_CHARACTER_INPUT_STREAM
		redefine
			close, read_to_string,
			read_to_buffer, is_closable, valid_unread_character,
			rewind
		end

create

	make

feature {NONE} -- Initialization

	make (a_client: like client; a_tcp_socket: like socket) is
			-- Establish invariant.
		require
			client_not_void: a_client /= Void
			socket_not_void: a_tcp_socket /= Void
		do
			client := a_client
			socket := a_tcp_socket
		ensure
			client_set: client = a_client
			socket_set: socket = a_tcp_socket
		end

feature -- Acesss

	client: EPX_FTP_CLIENT
			-- Ftp client

	socket: EPX_TCP_CLIENT_SOCKET
			-- Ftp client socket

	last_string: STRING is
			-- Last string read
			-- (Note: this query always return the same object.
			-- Therefore a clone should be used if the result
			-- is to be kept beyond the next call to this feature.
			-- However `last_string' is not shared between file objects.)
		do
			Result := socket.last_string
		end

	name: STRING is
			-- Name of input stream
		do
			Result := socket.name
		end

	last_character: CHARACTER is
			-- Last item read
		do
			Result := socket.last_character
		end

feature -- Basic operations

	close is
			-- Try to close input stream if it is closable. Set
			-- `is_open_read' to false if operation was successful.
		do
			socket.close
			client.close
		end

	rewind is
			-- Move input position to the beginning of stream.
		do
			socket.rewind
		end

feature -- Input

	read_string (nb: INTEGER) is
			-- Read at most `nb' characters from input stream.
			-- Make the characters that have actually been read
			-- available in `last_string'.
		do
			socket.non_blocking_read_string (nb)
		end

	read_to_string (a_string: STRING; pos, nb: INTEGER): INTEGER is
			-- Fill `a_string', starting at position `pos', with
			-- at most `nb' characters read from input stream.
			-- Return the number of characters actually read.
		do
			Result := socket.non_blocking_read_to_string (a_string, pos, nb)
		end

	read_character is
			-- Read the next item in input stream.
			-- Make the result available in `last_item
		do
			socket.non_blocking_read_character
		end

	unread_character (an_item: CHARACTER) is
			-- Put `an_item' back in input stream.
			-- This item will be read first by the next
			-- call to a read routine.
		do
			-- not supported
		end

	read_to_buffer (a_buffer: KI_BUFFER [CHARACTER]; pos, nb: INTEGER): INTEGER is
			-- Fill `a_buffer', starting at position `pos', with
			-- at most `nb' items read from input stream.
			-- Return the number of items actually read.
		do
			Result := socket.non_blocking_read_to_buffer (a_buffer, pos, nb)
		end

feature -- Status report

	is_closable: BOOLEAN is
			-- Can current input stream be closed?
		do
			Result := socket.is_closable
		end

	is_open_read: BOOLEAN is
			-- Can items be read from input stream?
		do
			Result := socket.is_open_read
		end

	end_of_input: BOOLEAN is
			-- Has the end of input stream been reached?
		do
			Result := socket.end_of_input
		end

	valid_unread_character (an_item: CHARACTER): BOOLEAN is
			-- Can `an_item' be put back in input stream?
		do
			Result := socket.valid_unread_character (an_item)
		end

invariant

	client_not_void: client /= Void
	socket_not_void: socket /= Void

end
