class EX_MEM2

create
   
   make
   
feature

   make is
      local
         mem: STDC_BUFFER
         byte: INTEGER
      do
         create mem.allocate_and_clear (128)
         mem.poke_uint8 (2, 57)
         byte := mem.peek_uint8 (2)
         mem.resize (256)
         mem.deallocate
      end
   
end
