indexing

	description: "Certain eposix classes can write lines."

	author: "Berend de Boer"
	date: "$Date: 2004/12/18 $"
	revision: "$Revision: #1 $"


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
