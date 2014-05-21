note

	description:

		"WSF_REQUEST but with eposix MIME handling"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2012, Berend de Boer"
	license: "MIT License (see LICENSE)"


class

	EPX_WSF_REQUEST


inherit

	WSF_REQUEST
		redefine
			save_uploaded_file
		end


create {WSF_TO_WGI_SERVICE}

	make_from_wgi


feature {WSF_MIME_HANDLER} -- Temporary File handling

	save_uploaded_file (a_up_file: WSF_UPLOADED_FILE; a_content: STRING)
			-- Save uploaded file to a temporary file.
		local
			t: SUS_TEMPORARY_FILE
			fs: expanded EPX_FILE_SYSTEM
			p: PATH
			bn: EPX_PATH
		do
			create t.make (fs.temporary_directory + "/" + a_up_file.filename + "-XXXXXX")
			create p.make_from_string (t.name)
			create bn.make_from_string (t.name)
			bn.parse (Void)
			a_up_file.set_tmp_path (p)
			a_up_file.set_tmp_basename (bn.basename)
			t.put_string (a_content)
			uploaded_files_table.force (a_up_file, a_up_file.name)
			t.close
		end

end
