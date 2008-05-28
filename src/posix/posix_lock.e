indexing

   description: "Class that covers a single lock obtained or set through fcntl."

   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"
   

class 

   POSIX_LOCK


inherit

   POSIX_BASE
   
   PAPI_FCNTL
   

create
   
   make
   
   
feature -- creation
   
   make is
      do
         create buf.allocate_and_clear (posix_flock_size)
         set_seek_start
         set_allow_all
      end
   

feature -- members

   allow_read: BOOLEAN is
         -- This is a read lock
      do
         Result := posix_flock_type (buf.ptr) = F_RDLCK
      end

   allow_all: BOOLEAN is
         -- No lock or used to remove a lock
      do
         Result := posix_flock_type (buf.ptr) = F_UNLCK
      end

   allow_none: BOOLEAN is
         -- This is a write lock
      do
         Result := posix_flock_type (buf.ptr) = F_WRLCK
      end

   start: INTEGER is
      do
         Result := posix_flock_start (buf.ptr)
      end

   length: INTEGER is
      do
         Result := posix_flock_len (buf.ptr)
      end

   pid: INTEGER is
      do
         Result := posix_flock_pid (buf.ptr)
      end


feature -- settable members

   set_allow_read is
         -- this is a read or shared lock
      do
         posix_set_flock_type (buf.ptr, F_RDLCK)
      end

   set_allow_all is
         -- to remove a lock
      do
         posix_set_flock_type (buf.ptr, F_UNLCK)
      end

   set_allow_none is
         -- this is a write or exclusive lock
      do
         posix_set_flock_type (buf.ptr, F_WRLCK)
      end

   set_seek_start is
         -- start is measured from the beginning of the file
      do
         posix_set_flock_whence (buf.ptr, SEEK_SET)
      end

   set_seek_current is
         -- start is measured from the current position
      do
         posix_set_flock_whence (buf.ptr, SEEK_CUR)
      end

   set_seek_end is
         -- start is measured from the end of the file
      do
         posix_set_flock_whence (buf.ptr, SEEK_END)
      end

   set_start (a_start: INTEGER) is
         -- set relative offset in bytes
      do
         posix_set_flock_start (buf.ptr, a_start);
      end

   set_length (a_length: INTEGER) is
         -- number of bytes to lock
      do
         posix_set_flock_len (buf.ptr, a_length);
      end

   
feature {POSIX_FILE_DESCRIPTOR} -- private state
   
   buf: STDC_BUFFER


invariant   
   
   valid_buf: buf /= Void

   lock_type_known: allow_all or else allow_none or else allow_read

end -- class POSIX_LOCK
