indexing

	description: "Class that covers the Single Unix Spec sys/un.h header. It contains definitions for UNIX domain sockets."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	SAPI_UN


feature -- C binding for members of sockaddr_un

	posix_sockaddr_un_size: INTEGER is
		external "C"
		end

	posix_sockaddr_un_sun_family (a_sockaddr_un: POINTER): INTEGER is
			-- AF_UNET
		require
			valid_sockaddr_un: a_sockaddr_un /= default_pointer
		external "C"
		end

	posix_sockaddr_un_sun_path (a_sockaddr_un: POINTER): POINTER is
			-- Socket pathname.
		require
			valid_sockaddr_un: a_sockaddr_un /= default_pointer
		external "C"
		end

	posix_set_sockaddr_un_sun_family (a_sockaddr_un: POINTER; sin_family: INTEGER) is
		require
			valid_sockaddr_un: a_sockaddr_un /= default_pointer
		external "C"
		end

	posix_set_sockaddr_un_sun_path (a_sockaddr_un: POINTER; a_sun_path: POINTER) is
			-- Set sun_path by moving bytes from `a_sun_path'.
		require
			valid_sockaddr_un: a_sockaddr_un /= default_pointer
			valid_sun_path: a_sun_path /= default_pointer
		external "C"
		end


feature -- Queries

	is_valid_path_name (a_path_name: STRING): BOOLEAN is
			-- Is `a_path_name' a valid unix domain path name?
			-- It's valid if it's not empty and its size is less than 100
			-- characters.
		do
			Result :=
				a_path_name /= Void and then
				not a_path_name.is_empty and then
				a_path_name.count < 100
		end


end
