indexing

	description: "Lexical analyzer input buffer which can detect return end_of_input when end of request has been read, so not more than necessary is read to prevent blocking."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

class

	EPX_IMAP4_RESPONSE_BUFFER


inherit

	EPX_STREAM_BUFFER
		rename
			make as epx_stream_buffer_make
		redefine
			default_capacity,
			fill
		end


create

	make


feature {NONE} -- Initialization

	make (a_file: like file; a_parser: EPX_IMAP4_RESPONSE_SCANNER) is
		require
			a_file_not_void: a_file /= Void
			a_file_open_read: a_file.is_open_read
			parser_not_void: a_parser /= Void
		do
			epx_stream_buffer_make (a_file)
			parser := a_parser
		end


feature -- Access

	end_of_file_after_end_of_line: BOOLEAN is
			-- Don't try to read more than necessary.
		do
			Result := parser.end_of_file_after_end_of_line
		end

	parser: EPX_IMAP4_RESPONSE_SCANNER


feature -- Element change

	fill is
		local
			prev_count: INTEGER
		do
			if not end_of_file then
				end_of_file := end_of_file_after_end_of_line and then end_of_line_read
				if not end_of_file then
					debug ("imap4")
						prev_count := count
					end
					precursor
					debug ("imap4")
						print ("=========================%N")
						print ("Last received response:%N")
						if count > prev_count then
							print (content.substring (prev_count + 1, count))
						end
						print ("%N=========================%N")
					end
					if not end_of_file then
						-- Can count be 0?
						-- I added an end_of_file check, so perhaps this
						-- fixes Hector D. Rodriguez' problem?
						end_of_line_read := content.item (count) = '%N'
					end
				else
					parser.reset_end_of_file_after_end_of_line
					content.put (End_of_buffer_character, count + 1)
					content.put (End_of_buffer_character, count + 2)
					filled := False
				end
			end
		end


feature {NONE} -- Constants

	default_capacity: INTEGER is
			-- Default capacity of buffer.
		once
			Result := 65534
		end


feature {NONE} -- Implementation

	end_of_line_read: BOOLEAN
			-- Does input end with an \n character?


invariant

	parser_not_void: parser /= Void

end
