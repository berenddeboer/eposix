indexing

	description: "Certain eposix classes can write lines."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


deferred class

	EPX_TEXT_OUTPUT_STREAM


inherit

	EPX_CHARACTER_OUTPUT_STREAM

	KI_TEXT_OUTPUT_STREAM
		undefine
			append,
			close
		end


end
