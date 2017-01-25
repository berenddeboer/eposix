note

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
   
   make
      do
         create buf.allocate_and_clear (posix_flock_size)
         set_seek_start
         set_allow_all
      end
   

feature -- members

   allow_read: BOOLEAN
         -- This is a read lock
      do
         Result := posix_flock_type (buf.ptr) = F_RDLCK
      end

   allow_all: BOOLEAN
         -- No lock or used to remove a lock
      do
         Result := posix_flock_type (buf.ptr) = F_UNLCK
      end

   allow_none: BOOLEAN
         -- This is a write lock
      do
         Result := posix_flock_type (buf.ptr) = F_WRLCK
      end

   start: INTEGER
      do
         Result := posix_flock_start (buf.ptr)
      end

   length: INTEGER
      do
         Result := posix_flock_len (buf.ptr)
      end

   pid: INTEGER
      do
         Result := posix_flock_pid (buf.ptr)
      end


feature -- settable members

   set_allow_read
         -- this is a read or shared lock
      do
         posix_set_flock_type (buf.ptr, F_RDLCK)
      end

   set_allow_all
         -- to remove a lock
      do
         posix_set_flock_type (buf.ptr, F_UNLCK)
      end

   set_allow_none
         -- this is a write or exclusive lock
      do
         posix_set_flock_type (buf.ptr, F_WRLCK)
      end

   set_seek_start
         -- start is measured from the beginning of the file
      do
         posix_set_flock_whence (buf.ptr, SEEK_SET)
      end

   set_seek_current
         -- start is measured from the current position
      do
         posix_set_flock_whence (buf.ptr, SEEK_CUR)
      end

   set_seek_end
         -- start is measured from the end of the file
      do
         posix_set_flock_whence (buf.ptr, SEEK_END)
      end

   set_start (a_start: INTEGER)
         -- set relative offset in bytes
      do
         posix_set_flock_start (buf.ptr, a_start);
      end

   set_length (a_length: INTEGER)
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
