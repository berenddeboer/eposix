indexing

   description: "Class that covers the Posix file permissions."
   usage: "You can set the permissions, call apply to make them permanent."

   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"


deferred class

   POSIX_PERMISSIONS

inherit

   POSIX_BASE


feature

   apply is
         -- make permissions changes (if any) permanent
      do
         if (original_owner_id /= owner_id) or
            (original_group_id /= group_id) then
            apply_owner_and_group
            original_owner_id := owner_id
            original_group_id := group_id
         end
         if original_mode /= mode then
            apply_mode
            original_mode := mode
         end
      end

   refresh is
         -- synchronize with permission changes possibly made on disk
      do
         status.refresh
         update_from_status
      end


feature {NONE}

   apply_mode is
         -- make mode change permanent
      deferred
      end

   apply_owner_and_group is
         -- make owner and group change permanent
      deferred
      end


feature -- query mode

   allow_anyone_execute: BOOLEAN is
         -- anyone allowed to execute the file?
      do
         Result := test_bits (mode, S_IXOTH)
      end

   allow_anyone_read: BOOLEAN is
         -- anyone allowed to read the file?
      do
         Result := test_bits (mode, S_IROTH)
      end

   allow_anyone_read_write: BOOLEAN is
         -- anyone allowed to read and write the file?
      do
         Result := test_bits (mode, S_IROTH + S_IWOTH)
      end

   allow_anyone_write: BOOLEAN is
         -- anyone allowed to write the file?
      do
         Result := test_bits (mode, S_IWOTH)
      end

   allow_group_execute: BOOLEAN is
         -- process with a group ID that matches the file's group
         -- allowed to execute the file?
      do
         Result := test_bits (mode, S_IXGRP)
      end

   allow_group_read: BOOLEAN is
         -- process with a group ID that matches the file's group
         -- allowed to read the file?
      do
         Result := test_bits (mode, S_IRGRP)
      end

   allow_group_read_write: BOOLEAN is
         -- process with a group ID that matches the file's group
         -- allowed to read the file?
      do
         Result := test_bits (mode, S_IRGRP + S_IWGRP)
      end

   allow_group_write: BOOLEAN is
         -- process with a group ID that matches the file's group
         -- allowed to write the file?
      do
         Result := test_bits (mode, S_IWGRP)
      end

   allow_owner_execute: BOOLEAN is
         -- owner allowed to execute the file
      do
         Result := test_bits (mode, S_IXUSR)
      end

   allow_read, allow_owner_read: BOOLEAN is
      do
         Result := test_bits (mode, S_IREAD)
      end

   allow_read_write, allow_owner_read_write: BOOLEAN is
      do
         Result := test_bits (mode, S_IREAD + S_IWRITE)
      end

   allow_write, allow_owner_write: BOOLEAN is
      do
         Result := test_bits (mode, S_IWRITE)
      end

   is_set_group_id, is_set_gid: BOOLEAN is
         -- group ID set on execution?
      do
         Result := test_bits (mode, S_ISGID)
      end

   is_set_user_id, is_set_uid: BOOLEAN is
         -- user ID set on execution?
      do
         Result := test_bits (mode, S_ISUID)
      end


feature -- set permissions

   set_allow_anyone_execute (allow: BOOLEAN) is
         -- give anyone execute permission
      do
         mode := flip_bits (mode, S_IXOTH, allow)
      ensure
         executability: (not allow) or allow_anyone_execute
      end

   set_allow_anyone_read (allow: BOOLEAN) is
         -- give anyone read permission
      do
         mode := flip_bits (mode, S_IROTH, allow)
      ensure
         readability: (not allow) or allow_anyone_read
      end

   set_allow_anyone_read_write (allow: BOOLEAN) is
         -- give anyone read and write permissions
      do
         mode := flip_bits (mode, S_IROTH + S_IWOTH, allow)
      ensure
          writability: (not allow) or allow_anyone_read_write
      end

   set_allow_anyone_write (allow: BOOLEAN) is
         -- give anyone write permission
      do
         mode := flip_bits (mode, S_IWOTH, allow)
      ensure
         writability: (not allow) or allow_anyone_write
      end

   set_allow_group_execute (allow: BOOLEAN) is
         -- give group execute permission
      do
         mode := flip_bits (mode, S_IXGRP, allow)
      ensure
         executability: (not allow) or allow_group_execute
      end

   set_allow_group_read (allow: BOOLEAN) is
         -- give group read permission
      do
         mode := flip_bits (mode, S_IRGRP, allow)
      ensure
         readability: (not allow) or allow_group_read
      end

   set_allow_group_read_write (allow: BOOLEAN) is
         -- give group read and write permission
      do
         mode := flip_bits (mode, S_IRGRP + S_IWGRP, allow)
      ensure
         writability: (not allow) or allow_group_read_write
      end

   set_allow_group_write (allow: BOOLEAN) is
         -- give group write permission
      do
         mode := flip_bits (mode, S_IWGRP, allow)
      ensure
         writability: (not allow) or allow_group_write
      end

   set_allow_owner_execute (allow: BOOLEAN) is
         -- give owner execute permission
      do
         mode := flip_bits (mode, S_IXUSR, allow)
      ensure
         executability: (not allow) or allow_owner_execute
      end

   set_allow_read, set_allow_owner_read (allow: BOOLEAN) is
         -- give read permission
      do
         mode := flip_bits (mode, S_IREAD, allow)
      ensure
         readability: (not allow) or allow_owner_read
      end

   set_allow_read_write (allow: BOOLEAN) is
         -- give read/write permission
      do
         mode := flip_bits (mode, S_IREAD + S_IWRITE, allow)
      ensure
         writability: (not allow) or allow_owner_read_write
      end

   set_allow_write, set_allow_owner_write (allow: BOOLEAN) is
         -- give write permission
      do
         mode := flip_bits (mode, S_IWRITE, allow)
      ensure
         writability: (not allow) or allow_owner_write
      end


feature -- direct access to Unix fields

   uid, owner_id: INTEGER
         -- id of object owner, always 0 on NT

   gid, group_id: INTEGER
         -- id of group, always 0 on NT

   mode: INTEGER
         -- the bit coded Unix mode field


feature -- set owner and group

   set_owner_id (a_owner_id: INTEGER) is
         -- change the owner
      do
         owner_id := a_owner_id
      end

   set_group_id (a_group_id: INTEGER) is
         -- change the group
      do
         group_id := a_group_id
      end


feature {NONE} -- state to support refresh

   status: POSIX_STATUS
         -- used to be able to refresh itself

   original_mode: INTEGER

   original_owner_id: INTEGER

   original_group_id: INTEGER


feature {POSIX_STATUS}

   update_from_status is
         -- assume status contains latest information, i.e. is Refreshed
         -- update the permissions from directly from status
      do
         owner_id := status.unix_uid
         group_id := status.unix_gid
         mode := status.unix_mode
         original_mode := mode
         original_owner_id := owner_id
         original_group_id := group_id
      end


end -- class POSIX_PERMISSIONS
