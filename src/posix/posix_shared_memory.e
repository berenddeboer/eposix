indexing

	description: "Class that covers Posix shared memory routines."

	usage: "A shared memory object basically is a FILE_DESCRIPTOR."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"

class

	POSIX_SHARED_MEMORY


inherit

	POSIX_FILE_DESCRIPTOR
		export {NONE}
			make_as_duplicate,
			make_from_file,
			ttyname
		redefine
			do_open,
			do_create
		end

	PAPI_MMAN


create

	open_read,
	open_read_write,
	create_write,
	create_read_write


feature {NONE} -- Internal open/create

	do_open (a_path: STRING; flags: INTEGER) is
		local
			cpath: POINTER
			a_fd: INTEGER
		do
			name.make_from_string (a_path)
			cpath := sh.string_to_pointer (name)
			a_fd := posix_shm_open (cpath, flags, 0)
			sh.unfreeze_all
			if a_fd = -1 then
				raise_posix_error
			else
				capacity := 1
				set_handle (a_fd, True)
			end
			-- file offset is unspecified, do a seek?
		end

	do_create (a_path: STRING; flags, mode: INTEGER) is
		local
			cpath: POINTER
			a_fd: INTEGER
		do
			name.make_from_string (a_path)
			cpath := sh.string_to_pointer (name)
			a_fd := posix_shm_open (cpath, flags, mode)
			sh.unfreeze_all
			if a_fd = -1 then
				raise_posix_error
			else
				capacity := 1
				set_handle (a_fd, True)
			end
			-- file offset is unspecified, do a seek?
		end


end
