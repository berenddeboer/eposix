note

	description:

		"Definition of an IRC message"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"


class

	EPX_IRC_MESSAGE


create

	make_parse


feature {NONE} -- Initialisation

	make_parse (a_line: STRING)
			-- Parse `a_line' into its basic components.
		require
			a_line_not_empty: a_line /= Void and then not a_line.is_empty
		local
			has_prefix: BOOLEAN
			p, q: INTEGER
			param_start: INTEGER
			parameter: STRING
			is_trailing_parameter: BOOLEAN
			i: INTEGER
		do
			create user_name.make_empty
			create nick_name.make_empty
			create host_name.make_empty
			-- Parse prefix
			has_prefix := a_line.item (1) = ':'
			if has_prefix then
				p := a_line.index_of (' ', 2)
				msg_prefix := a_line.substring (2, p-1)
				parse_prefix
			else
				msg_prefix := ""
			end

			-- Extract command and make sure it's uppercased
			q := a_line.index_of (' ', p+1)
			if q = 0 then
				q := a_line.count + 1
			end
			command := a_line.substring (p+1, q-1)
			has_reply_code := command.is_integer
			if has_reply_code then
				reply_code := command.to_integer
			else
				command.to_upper
			end

			-- Extract parameters
			if q < a_line.count then
				create { DS_LINKED_LIST [STRING] } parameters.make
				param_start := q + 1
				from
					i := param_start
				until
					i > a_line.count
				loop
					inspect a_line.item (i)
					when ' ' then
						parameter := a_line.substring (param_start, i - 1)
						parameters.put_last (parameter)
						param_start := i + 1
					when ':' then
						is_trailing_parameter := i = param_start
						if is_trailing_parameter then
							param_start := param_start + 1 -- don't include colon in param
							i := a_line.count -- quit loop
						end
					else
						-- ignore
					end
					i := i + 1
				variant
					(a_line.count - i) + 1
				end
				-- Copy last parameter
				parameter := a_line.substring (param_start, a_line.count)
				parameters.put_last (parameter)
			else
				parameters := Void
			end
		end


feature -- Status

	has_reply_code: BOOLEAN
			-- Is `command' a numeric reply'

	is_error_reply: BOOLEAN
			-- Did server send an error reply?
		local
			r: INTEGER
		do
			if has_reply_code then
				r := reply_code
				Result := r >= 400 and then r <= 599
			end
		ensure
			must_be_numeric: Result implies has_reply_code
		end


feature -- Access

	command: STRING
			-- Command, numeric or alphabetic

	host_name: STRING
			-- Name of host if `msg_prefix' contains a host name

	msg_prefix: STRING
			-- Nick name or server name

	nick_name: STRING
			-- Nick name if `msg_prefix' contains a host name

	parameters: detachable DS_LIST [STRING]

	reply_code: INTEGER
			-- Return reply code if `command' is a numeric reply code.

	user_name: STRING
			-- Name of user if `msg_prefix' contains a user; empty otherwise


feature {NONE} -- Implementation

	parse_prefix
			-- Parse `msg_prefix' into its components if it contains the
			-- @ character.
		require
			msg_prefix_not_void: msg_prefix /= Void
		local
			p, q: INTEGER
			contains_host,
			contains_user: BOOLEAN
		do
			p := msg_prefix.index_of ('@', 1)
			contains_host := p > 1 and p < msg_prefix.count
			if contains_host then
				host_name := msg_prefix.substring (p + 1, msg_prefix.count)
				q := msg_prefix.index_of ('!', 1)
				contains_user := q > 1 and q + 1 < p - 1
				if contains_user then
					user_name := msg_prefix.substring (q + 1, p - 1)
					if user_name.item (1) = '~' then
						user_name.remove (1)
					end
					nick_name := msg_prefix.substring (1, q - 1)
				else
					nick_name := msg_prefix.substring (1, p - 1)
				end
			end
		end


invariant

	command_not_empty: command /= Void and then not command.is_empty
	command_is_upper_case: command.is_equal (command.as_upper)
	prefix_does_not_start_with_colon: msg_prefix /= Void implies msg_prefix.item (1) /= ':'
	host_name_void_or_not_empty: host_name = Void or else not host_name.is_empty
	nick_name_void_or_not_empty: nick_name = Void or else not nick_name.is_empty

	parameters_void_or_not_empty: parameters = Void or else not parameters.is_empty

end
