indexing

	description: "Email message in MIME format. Make creating MIME email slightly easier than using a plain EPX_MIME_PART."

	author: "Berend de Boer"
	date: "$Date: 2004/12/18 $"
	revision: "$Revision: #1 $"


class

	EPX_MIME_EMAIL


inherit

	EPX_MIME_PART
		rename
			make_empty as make
		redefine
			header
		end


creation

	make


feature -- Access

	header: EPX_MIME_EMAIL_HEADER
			-- Email message header


end
