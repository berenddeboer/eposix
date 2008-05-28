class EX_MEM

create
   
   make
   
feature

   make is
      local
         mem: POSIX_BUFFER
         byte: INTEGER
      do
         create mem.allocate (256)
         mem.poke_uint8 (2, 57)
         byte := mem.peek_uint8 (2)
         mem.resize (512)
         mem.deallocate
      end
   
end
