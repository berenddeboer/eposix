indexing

	description: "Email message in MIME format. Make creating MIME email slightly easier than using a plain EPX_MIME_PART."

	author: "Berend de Boer"


class

	EPX_MIME_EMAIL


inherit

	EPX_MIME_PART
		rename
			make_empty as make
		redefine
			header
		end

	EPX_FILE_SYSTEM
		export
			{NONE} all;
			{ANY} is_readable
		end


create

	make


feature -- Access

	header: EPX_MIME_EMAIL_HEADER
			-- Email message header


feature -- Change

	attach_file (a_type, a_subtype, a_file_name: STRING; an_inline: BOOLEAN) is
			-- Attach file `a_file_name' to the email using the given
			-- mime types.
			-- Use inline to tell the user agement that it would be nice
			-- if the file was displayed when opening the email. If it's
			-- false the attachment is usually not opened until the user
			-- performs some additional action, such as clicking an icon
			-- that represents the attachment.
		require
			type_not_empty: a_type /= Void and then not a_type.is_empty
			subtype_not_empty: a_subtype /= Void and then not a_subtype.is_empty
			valid_path: a_file_name /= Void and then not a_file_name.is_empty
			file_exists: is_readable (a_file_name)
			multipart_body: body /= Void and then body.is_multipart
		local
			file_part: EPX_MIME_PART
			cd: EPX_MIME_FIELD_CONTENT_DISPOSITION
			file: EPX_FILE_DESCRIPTOR
			path: STDC_PATH
		do
			create path.make_from_string (a_file_name)
			path.parse (Void)
			file_part := multipart_body.new_part
			file_part.header.set_content_type (a_type, a_subtype, Void)
			if an_inline then
				create cd.make (once "inline")
			else
				create cd.make (once "attachment")
			end
			file_part.header.add_field (cd)
			file_part.header.content_type.set_parameter (once "name", path.basename)
			file_part.create_base64_body
			-- Set filename after body create, so body isn't a file body.
			cd.set_parameter (once "filename", path.basename)
			create file.open_read (a_file_name)
			from
				file.read_string (8192)
			until
				file.end_of_input
			loop
				file_part.text_body.append_string (file.last_string)
				file.read_string (8192)
			end
			file.close
		end


end
