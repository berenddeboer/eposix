indexing

	description:

		"Status field that CGI programs can set to signal that a particular response code must be returned"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_MIME_FIELD_STATUS


inherit

	EPX_MIME_STRUCTURED_FIELD

	EPX_HTTP_RESPONSE
		export
			{NONE} all;
			{ANY} is_three_digit_response
		end


create

	make


feature {NONE} -- Initialisation

	make (a_status_code: INTEGER; a_reason: STRING) is
		require
			valid_status_code: is_three_digit_response (a_status_code)
		do
			set_status (a_status_code, a_reason)
		ensure
			status_code_set: status_code = a_status_code
		end


feature -- Access

	status_code: INTEGER

	reason: STRING

	name: STRING is "Status"

	value: STRING is
			-- Value of field.
		do
			Result := status_code.out + " " + reason
		end


feature -- Change

	set_status (a_status_code: INTEGER; a_reason: STRING) is
			-- Set `status_code' and `reason'.
		require
			valid_status_code: is_three_digit_response (a_status_code)
		do
			status_code := a_status_code
			if a_reason = Void or else a_reason.is_empty then
				reason := reason_phrase (a_status_code)
			else
				reason := a_reason
			end
		ensure
			status_code_ste: status_code = a_status_code
			reason_not_void: reason /= Void
		end


invariant

	status_code_valid: is_three_digit_response (status_code)
	reason_not_void: reason /= Void

end
