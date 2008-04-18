indexing

	description:

		"Covers a DCC CHAT session with a given ip4 address. A DCC chat is a line oriented protocol."

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_IRC_DCC_CHAT


inherit

	ANY

	EPX_IRC_NAMES
		export
			{NONE} all
		end


feature -- Access

	last_string: STRING is
			-- Last read line of data from sender.
		do
			Result := socket.last_string
		ensure
			not_void: Result /= Void
		end

	nick_name: STRING
			-- Chat is with this user


feature -- Status

	end_of_input: BOOLEAN is
			-- Is there no more data to read?
			-- I.e., has sender closed the connection?
		require
			open: is_open
		do
			Result := socket.end_of_input
		end

	is_open: BOOLEAN is
			-- Is connection completed?
		do
			Result := socket /= Void and then socket.is_open
		ensure
			socket_not_void: Result implies socket /= Void
		end

	is_string_read: BOOLEAN is
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

	read is
			-- Read the next line of data from the sender.
		require
			open: is_open
			not_end_of_input: not end_of_input
		do
			socket.read_line
			last_receive.make_from_now
		end

	put (s: STRING) is
			-- Write a line of data. If `s' does not end with a new-line,
			-- a new-line will be written to the receiver after `s' has
			-- been written.
		require
			open: is_open
		do
			if s /= Void and then not s.is_empty then
				socket.put_string (s)
				if s.item (s.count) /= '%N' then
					socket.put_character ('%N')
				end
			end
		end


feature -- Close

	close is
			-- End the DCC chat session.
		do
			socket.close
			last_receive := Void
		ensure
			closed: not is_open
		end


feature {NONE} -- Implementation

	host: EPX_HOST
	service: EPX_SERVICE
	hp: EPX_HOST_PORT
	socket: ABSTRACT_TCP_SOCKET


invariant

	valid_nick_name: is_valid_nick_name (nick_name)
	open_implies_last_receive: is_open implies last_receive /= Void

end
