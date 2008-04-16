indexing

	description: "Abstract factory to create POSIX or Windows classes."

	usage: "Use the effective class EPX_FACTORY for your OS."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


deferred class

	ABSTRACT_FACTORY


feature -- Access

	current_process: ABSTRACT_CURRENT_PROCESS is
			-- Access to current process info
		once
			create {EPX_CURRENT_PROCESS} Result
		ensure
			current_process_not_void: Result /= Void
		end

	fs: ABSTRACT_FILE_SYSTEM is
			-- Access to file system
		once
			create {EPX_FILE_SYSTEM} Result
		ensure
			file_system_not_void: Result /= Void
		end

	system_info: ABSTRACT_SYSTEM is
			-- Access to system info
		once
			create {EPX_SYSTEM} Result
		ensure
			system_info_not_void: Result /= Void
		end


feature -- binary/text file open mode

	is_binary_mode: BOOLEAN is
			-- what's the current open mode?
			-- Always True for POSIX (not really applicable there)
		deferred
		end

	set_binary_mode (value: BOOLEAN) is
			-- set mode in which to open files: binary or text. Is not
			-- applicable with POSIX, but an important distinction in Windows.
			-- default mode is text.
		deferred
		ensure
			binary_mode_set: value implies is_binary_mode
		end


feature -- file descriptor

	create_with_mode (a_path: STRING; flags, mode: INTEGER): ABSTRACT_FILE_DESCRIPTOR is
		deferred
		end

	create_write (a_path: STRING): ABSTRACT_FILE_DESCRIPTOR is
		deferred
		end

	create_read_write (a_path: STRING): ABSTRACT_FILE_DESCRIPTOR is
		deferred
		end

	open (a_path: STRING; a_flags: INTEGER): ABSTRACT_FILE_DESCRIPTOR is
		deferred
		end

	open_read (a_path: STRING): ABSTRACT_FILE_DESCRIPTOR is
		deferred
		end

	open_read_write (a_path: STRING): ABSTRACT_FILE_DESCRIPTOR is
		deferred
		end

	open_truncate (a_path: STRING): ABSTRACT_FILE_DESCRIPTOR is
		deferred
		end

	open_write (a_path: STRING): ABSTRACT_FILE_DESCRIPTOR is
		deferred
		end


feature  -- pipe


feature  -- socket


end -- class ABSTRACT_FACTORY
