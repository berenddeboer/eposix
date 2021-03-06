note

	description:

		"Covers a DCC CHAT session with a given ip4 address. A DCC chat is a line oriented protocol."

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "MIT License"


deferred class

	EPX_IRC_DCC_CHAT


inherit

	ANY

	EPX_IRC_NAMES
		export
			{NONE} all
		end


feature {NONE} -- Initialisation

	do_make (a_nick_name: like nick_name)
		require
			valid_nick_name: is_valid_nick_name (a_nick_name)
		do
			nick_name := a_nick_name
			create {EPX_TCP_CLIENT_SOCKET} socket.make
			create last_receive.make_from_now
		end


feature -- Access

	last_string: STRING
			-- Last read line of data from sender.
		do
			Result := socket.last_string
		ensure
			not_void: Result /= Void
		end

	nick_name: STRING
			-- Chat is with this user


feature -- Status

	end_of_input: BOOLEAN
			-- Is there no more data to read?
			-- I.e., has sender closed the connection?
		require
			open: is_open
		do
			Result := socket.end_of_input
		end

	is_open: BOOLEAN
			-- Is connection completed?
		do
			Result := socket.is_open
		ensure
			socket_not_void: Result implies attached socket
		end

	is_string_read: BOOLEAN
			-- Has call to `read' made a new line of data available on
			-- `last_string'?
		require
			open: is_open
		do
			Result := not socket.last_blocked
		end

	last_receive: STDC_TIME
			-- Last time something has been received;
			-- Initialised to start of connection.


feature -- Reading and writing

	read
			-- Read the next line of data from the sender.
		require
			open: is_open
			not_end_of_input: not end_of_input
		do
			socket.read_line
			last_receive.make_from_now
		end

	put (s: STRING)
			-- Write a line of data if `s' is not empty. If `s' does not
			-- end with a new-line, a new-line will be written to the
			-- receiver after `s' has been written.
		require
			open: is_open
		do
			if not s.is_empty then
				socket.put_string (s)
				if s.item (s.count) /= '%N' then
					socket.put_character ('%N')
				end
			end
		end


feature -- Close

	close
			-- End the DCC chat session.
		do
			socket.close
		ensure
			closed: not is_open
		end


feature {NONE} -- Implementation

	hp: detachable EPX_HOST_PORT
	socket: ABSTRACT_TCP_SOCKET


invariant

	valid_nick_name: is_valid_nick_name (nick_name)
	open_implies_last_receive: is_open implies attached last_receive

end
