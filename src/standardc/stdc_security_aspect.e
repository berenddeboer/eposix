indexing

	description:
		"Base class to describe a single security aspect."

	usage: "Inherit from STDC_SECURITY_ACCESSOR."

	author: "Berend de Boer"
	date: "$Date: 2003/01/09 $"
	revision: "$Revision: #2 $"


class

	STDC_SECURITY_ASPECT


inherit

	ANY

	EXCEPTIONS
		export {NONE} all
		end


feature {NONE} -- Security error

	raise_security_error (msg: STRING) is
		require
			valid_msg: msg /= Void and then not msg.is_empty
		do
			raise (msg)
		end


feature {NONE} -- Useful maximums

	Max_Int: INTEGER is
		do
			Result := 2147483647
		end


end
