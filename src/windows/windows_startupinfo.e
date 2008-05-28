indexing

   description: "Describes NT STARTUPINFO struct."

   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"


class

   WINDOWS_STARTUPINFO


inherit

   WINDOWS_BASE

   WAPI_WINDOWS


create

   make


feature -- creation

   make is
      do
         create psi.allocate_and_clear (posix_startupinfo_size)
         posix_set_startupinfo_cb (ptr, posix_startupinfo_size)
      end


feature -- state

   set_dwFlags (value: INTEGER) is
      do
         posix_set_startupinfo_dwflags (ptr, value)
      end

   set_wShowWindow (value: INTEGER) is
      do
         posix_set_startupinfo_wshowwindow (ptr, value)
      end

   set_hStdOutput (value: INTEGER) is
      do
         posix_set_startupinfo_hstdoutput (ptr, value)
      end

   set_hStdInput (value: INTEGER) is
      do
         posix_set_startupinfo_hstdinput (ptr, value)
      end

   set_hStdError (value: INTEGER) is
      do
         posix_set_startupinfo_hstderror (ptr, value)
      end


feature -- pointer to state

   ptr: POINTER is
      do
         Result := psi.ptr
      end


feature {NONE} -- private state

   psi: STDC_BUFFER


end
