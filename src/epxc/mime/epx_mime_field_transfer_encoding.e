indexing

	description: "Field Transfer-Encoding"

	standards: "RFC 2616 chapter 3.6"
	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_MIME_FIELD_TRANSFER_ENCODING


inherit

	EPX_MIME_FIELD_WITH_PARAMETERS
		rename
			value as transformation
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		end


create

	make


feature -- Initialization

	make (a_transformation: STRING) is
			-- Initialize Transfer-Encoding.
		require
			transformation_not_empty: a_transformation /= Void and then not a_transformation.is_empty
		do
			make_parameters
			transformation := a_transformation
		end


feature -- Status

	is_chunked_coding: BOOLEAN is
			-- Is this transfer encoding the chunked encoding?
		do
			Result := STRING_.same_case_insensitive (transformation, once_chunked)
		end


feature -- Access

	transformation: STRING
			-- Type of encoding transformation that has been applied to the body

	name: STRING is "Transfer-Encoding"
			-- Authorative name


feature {NONE} -- Implementation

	once_chunked: STRING is "chunked"


invariant

	transformation_not_empty: transformation /= Void and then not transformation.is_empty

end
