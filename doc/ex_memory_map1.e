class EX_MEMORY_MAP1

inherit

	POSIX_SYSTEM

	POSIX_CURRENT_PROCESS

create

	make

feature

	make is
		local
			fd: POSIX_FILE_DESCRIPTOR
			map: POSIX_MEMORY_MAP
			byte: INTEGER
			correct: BOOLEAN
		do
			if supports_memory_mapped_files then

				-- Open a file.
				create fd.open_read_write ("ex_memory_map1.e")

				-- Create memory map.
				create map.make_shared (fd, 0, 64)

				-- Read a byte from the mapping.
				byte := map.peek_uint8 (2)
				correct := byte = ('a').code
				if not correct then
					print ("Oops.%N")
				end

				-- Cleanup.
				map.close
				fd.close
			end
		end
end
