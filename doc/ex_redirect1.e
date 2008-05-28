class EX_REDIRECT1

inherit

   POSIX_CURRENT_PROCESS

create

   make

feature

   make is
      do
         -- flush stream buffers, else output may be in wrong order
         stdout.flush
         stderr.flush

         fd_stderr.make_as_duplicate (fd_stdout)
         -- all output written to stderr goes to stdout now
      end

end
