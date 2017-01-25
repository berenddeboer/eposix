note

	description: "Class that can return the last signal. Is compiler dependent."

	usage: "Inherit from this class. The `signal' feature gives you the %
	%last signal."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $";
	revision: "$Revision: #3 $"

class

	LAST_SIGNAL


inherit

	ANY

	EXCEPTIONS
		rename
			raise as exceptions_raise
		export
			{NONE} all
		end


feature

	signal: INTEGER
			-- Last signal
		local
			us: UNIX_SIGNALS
		do
			create us
			Result := us.signal
		end

end
