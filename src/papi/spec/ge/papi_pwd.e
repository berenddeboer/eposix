indexing

	description: "Class that covers POSIX pwd.h header."

	author: "Berend de Boer"
	date: "$Date: 2007/05/18 $"
	revision: "$Revision: #1 $"

class

	PAPI_PWD


feature -- POSIX C binding

	posix_getpwuid (a_uid: INTEGER): POINTER is
			-- Reads user database based on user ID

		external "C blocking"



		end

	posix_getpwnam (a_name: POINTER): POINTER is
			-- Reads user database based on user name

		external "C blocking"



		end

	posix_pw_name (a_passwd: POINTER): POINTER is
		external "C"
		end

	posix_pw_uid (a_passwd: POINTER): INTEGER is
		external "C"
		end

	posix_pw_gid (a_passwd: POINTER): INTEGER is
		external "C"
		end

	posix_pw_dir (a_passwd: POINTER): POINTER is
		external "C"
		end

	posix_pw_shell (a_passwd: POINTER): POINTER is
		external "C"
		end


end -- class PAPI_PWD
