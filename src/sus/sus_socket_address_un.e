indexing

	description: "Describes the AF_UNIX protocol sockaddr_un."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	SUS_SOCKET_ADDRESS_UN


inherit

	SUS_BASE

	SAPI_UN
		export
			{NONE} all;
			{ANY} is_valid_path_name
		end


create

	make,
	make_from_pointer


feature {NONE} -- Initialization

	make (a_path_name: STRING) is
			-- Initialize sockaddr_un from `a_path_name'.
		require
			path_name_not_empty: a_path_name /= Void and then not a_path_name.is_empty
		do
			create buf.allocate_and_clear (length)
			posix_set_sockaddr_un_sun_family (buf.ptr, AF_UNIX)
			set_path_name (a_path_name)
		ensure
			address_family_set: address_family = AF_UNIX
			path_name_set: path_name.is_equal (a_path_name)
		end

	make_from_pointer (an_address: POINTER; a_size: INTEGER) is
			-- Initialize a socket address by passing it a memory
			-- location where the information is stored. The information
			-- in `an_address' is copied.
			-- `an_address' should contain a pointer to a struct with a
			-- family supported by this class.
		require
			a_size_equal_to_length: a_size = length
		do
			create buf.allocate (length)
			buf.memory_copy (an_address, 0, 0, a_size)
		end


feature -- Access

	address_family: INTEGER is
			-- Family, AF_UNIX.
		do
			Result := AF_UNIX
		end

	path_name: STRING is
			-- Path name.
		do
			Result := sh.pointer_to_string (posix_sockaddr_un_sun_path (buf.ptr))
		ensure
			path_name_not_void: Result /= Void
		end

	supported_family: INTEGER is
			-- Family supported by this struct.
			-- Should be hard coded to return the family supported by the struct.
		do
			Result := AF_UNIX
		end


feature -- Set

	set_path_name (a_path_name: STRING) is
			-- Set `port'.
		require
			path_name_valid: is_valid_path_name (a_path_name)
		do
			posix_set_sockaddr_un_sun_path (buf.ptr, sh.string_to_pointer (a_path_name))
			sh.unfreeze_all
		ensure
			path_name_set: path_name.is_equal (a_path_name)
		end


feature -- Features the C API calls like

	length: INTEGER is
			-- Size of my struct (sockaddr_in or sockaddr_in6).
		do
			Result := posix_sockaddr_un_size
		ensure
			length_positive: length > 0
		end

	frozen ptr: POINTER is
			-- Points to struct sockaddr_in or sockaddr_in6.
		do
			Result := buf.ptr
		ensure
			valid_result: Result /= default_pointer
		end


feature {NONE} -- Implementation

	buf: STDC_BUFFER
			-- Pointer to a struct sockaddr_in/sockaddr_in6 structure.


invariant

	valid_buf: buf /= Void and then buf.capacity >= length
	family_supported: supported_family = address_family

end
