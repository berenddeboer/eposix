note

	description: "Class that covers a single POSIX signal. You can%
	%query and determine how a signal is handled for the current process."

	author: "Berend de Boer"


class

	POSIX_SIGNAL

inherit

	STDC_SIGNAL
		redefine
			make,
			apply,
			is_ignorable,
			set_default_action,
			set_ignore_action,
			set_handler
		end

	POSIX_BASE

	PAPI_SIGNAL


create

	make


feature -- Initialization

	make (a_value: INTEGER)
		do
			value := a_value
			create sigaction.allocate (posix_sigaction_size)
			refresh
		end


feature -- Set signal properties, make effective with `apply'

	apply
			-- Make changes effective.
		do
			signal_switch.ignore (Current)
			safe_call (posix_sigaction (value, sigaction.ptr, default_pointer))
			if my_callback /= Void then
				signal_switch.catch (Current, my_callback)
			end
		end

	set_child_stop (stop: BOOLEAN)
			-- Generate SIGCHLD when children stop.
		local
			flags: INTEGER
		do
			flags :=
				flip_bits (posix_sa_flags (sigaction.ptr),
							  SA_NOCLDSTOP,
							  not child_stop)
			posix_set_sa_flags (sigaction.ptr, flags)
		end

	set_default_action
			-- Install signal-specific default action when `apply' is called.
		do
			posix_set_sa_handler (sigaction.ptr, SIG_DFL)
			my_callback := Void
		end

	set_ignore_action
			-- Ignore signal when `apply' is called..
		do
			posix_set_sa_handler (sigaction.ptr, SIG_IGN)
			my_callback := Void
		end

	set_handler (a_handler: STDC_SIGNAL_HANDLER)
			-- Install one's own signal handler when `apply' is called.
		do
			posix_set_sa_handler (sigaction.ptr, signal_switch.handler)
			my_callback := a_handler
		end

	set_mask (a_mask: POSIX_SIGNAL_SET)
		obsolete "not yet implemented"
		do
			-- not yet implemented
		end


feature -- signal functions

	raise_in (a_pid: INTEGER)
			-- Raise the signal in the given process.
		do
			safe_call (posix_kill (a_pid, value))
		end


feature -- Signal state

	child_stop: BOOLEAN
			-- generate SIGCHLD when children stop
		do
			Result :=
				posix_and (posix_sa_flags (sigaction.ptr), SA_NOCLDSTOP) = 1
		end

	handler: POINTER
			-- pointer to function which catches this signal
		do
			Result := posix_sa_handler (sigaction.ptr)
		end

	is_defaulted: BOOLEAN
			-- signal is handled by its specific default action
		do
			Result := posix_sa_handler (sigaction.ptr) = SIG_DFL
		end

	is_ignored: BOOLEAN
			-- signal is ignored
		do
			Result := posix_sa_handler (sigaction.ptr) = SIG_IGN
		end

	is_ignorable: BOOLEAN
			-- True if this signal is ignorable, either it is so by
			-- default or it may be set so.
		do
			Result :=
				value /= SIGCHLD and then
				value /= SIGKILL and then
				value /= SIGSTOP
		ensure then
			ignore_consistent: Result implies not is_ignored
		end

	mask: detachable POSIX_SIGNAL_SET

	refresh
			-- get latest state for this signal
		do
			safe_call (posix_sigaction (value, default_pointer, sigaction.ptr))
		end


feature {NONE} -- private state

	sigaction: STDC_BUFFER
			-- C sigaction struct


invariant

	has_memory: sigaction /= Void


end -- class POSIX_SIGNAL
