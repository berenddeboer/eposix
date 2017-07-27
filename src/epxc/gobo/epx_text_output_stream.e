note

	description: "Certain eposix classes can write lines."

	author: "Berend de Boer"


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
