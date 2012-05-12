indexing

	description:

		"Like EPX_DAEMON but with watchdog capabilities; i.e. it respawns automatically when it crashes."

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2011, Berend de Boer"
	license: "MIT License (see LICENSE)"


deferred class

	EPX_WATCHDOG_DAEMON


inherit

	EPX_DAEMON
		redefine
			after_fork
		end


feature -- Daemon specific actions

	after_fork is
			-- If child terminates, restart it.
		local
			--child_pid: INTEGER
			is_parent: BOOLEAN
		do
			-- Just fork once more so we don't have a controlling terminal
			precursor

			-- And in child do our watchdog thing
			-- We fork once more, the child will be the process watched for.
			last_child_pid := posix_fork
			is_parent := last_child_pid /= 0
			if is_parent then
				write_pid
				set_pid (last_child_pid)
				from
				until
					terminate_signal.should_stop
				loop
					sleep (1)
					wait_for (False)
					if is_terminated then
						respawn
					end
				end
				if not is_terminated then
					force_terminate (1000)
				end
			else
				-- Let child continue to `execute'
			end
		end


	respawn is
			-- Respawn
		require
			terminated: is_terminated
		do
			last_child_pid := posix_fork
			if last_child_pid /= 0 then
				-- In parent, simply record pid of child
				set_pid (last_child_pid)
			else
				-- In child, `execute' and after gracefully terminate
				execute
				after_execute
				-- And make sure child never returns
				exit_with_success
			end
		rescue
			-- last resort
			minimal_exit (EXIT_FAILURE)
		end


end
