note

	description:

		"Combination of a name and an email address"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer and others"
	license: "MIT License"


class

	EPX_MIME_MAILBOX


create

	make


feature {NONE} -- Initialisation

	make (a_name: detachable STRING; an_email_address: STRING)
			-- Initialise
		require
			email_address_not_empty: an_email_address /= Void and then not an_email_address.is_empty
		do
			name := a_name
			email_address := an_email_address
		end


feature -- Access

	name: detachable STRING
			-- Optional name of user associated with `email_address'

	email_address: STRING
			-- Email address


invariant

	email_address_not_empty: email_address /= Void and then not email_address.is_empty
end
