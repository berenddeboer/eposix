indexing

	description:

		"Abstraction for the 3 digit numeric reply code used by the FTP or SMTP protocols."

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


class

	EPX_REPLY_CODE



feature -- Access

	reply_code: INTEGER
			-- Last reply code sent by server


feature -- Status

	is_line_with_reply_code (a_line: STRING): BOOLEAN is
			-- Does `line' start with a reply code?
		require
			line_not_void: a_line /= Void
		local
			long_enough_for_reply_code: BOOLEAN
			fourth_char: CHARACTER
			s: STRING
		do
			long_enough_for_reply_code := a_line.count >= 4
			if long_enough_for_reply_code then
				s := a_line.substring (1, 3)
				fourth_char := a_line.item (4)
				Result :=
					s.is_integer and then
					(fourth_char = ' ' or else
					 fourth_char = '-')
			end
		ensure
			at_least_four_characters: Result implies a_line.count >= 4
			has_reply_code: Result implies a_line.substring (1, 3).is_integer
			stop_or_continue_character: Result implies (a_line.item (4) = ' ' or else a_line.item (4) = '-')
		end


feature -- Status for first digit of reply code

	is_positive_preliminary_reply: BOOLEAN is
			-- Is `reply_code' a Positive Preliminary reply?
			-- The requested action is being initiated; expect another
			-- reply before proceeding with a new command.
		do
			Result := reply_code >= 100 and then reply_code <= 199
		ensure
			definition: Result implies reply_code >= 100 and then reply_code <= 199
		end

	is_positive_completion_reply: BOOLEAN is
			-- Is `reply_code' a Positive Completion reply?
			-- The requested action has been successfully completed. A
			-- new request may be initiated.
		do
			Result := reply_code >= reply_code_ok and then reply_code <= 299
		ensure
			definition: Result implies reply_code >= reply_code_ok and then reply_code <= 299
		end

	is_positive_intermediate_reply: BOOLEAN is
			-- Is `reply_code' a Positive Intermediate reply?
			-- The command has been accepted, but the requested action is
			-- being held in abeyance, pending receipt of further
			-- information. The user should send another command
			-- specifying this information.  This reply is used in
			-- command sequence groups.
		do
			Result := reply_code >= 300 and then reply_code <= 399
		ensure
			definition: Result implies reply_code >= 300 and then reply_code <= 399
		end

	is_transient_negative_completion_reply: BOOLEAN is
			-- Is `reply_code' a Transient Negative Completion reply?
			-- The command was not accepted and the requested action did
			-- not take place, but the error condition is temporary and
			-- the action may be requested again. The user should return
			-- to the beginning of the command sequence, if any.
		do
			Result := reply_code >= 400 and then reply_code <= 499
		ensure
			definition: Result implies reply_code >= 400 and then reply_code <= 499
		end

	is_permanent_negative_completion_reply: BOOLEAN is
			-- Is `reply_code' a Permanent Negative Completion reply?
			-- The command was not accepted and the requested action did
			-- not take place. The User-process is discouraged from
			-- repeating the exact request (in the same sequence).
		do
			Result := reply_code >= 500 and then reply_code <= 599
		ensure
			definition: Result implies reply_code >= 500 and then reply_code <= 599
		end


feature -- Constants for reply codes that are shared among all protocols

	reply_code_ok: INTEGER is 200


invariant

	three_digit_reply_code:
		reply_code = 0 or else
		(reply_code >= 100 and reply_code <= 999)

end
