indexing

	description: "The exit handler that calls all other exit handlers."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


class

	STDC_EXIT_SWITCH

inherit

	EPX_SINGLETON

	MEMORY
		redefine
			dispose
		end

	EPX_POINTER_HELPER
		export
			{NONE} all
		end


create {STDC_EXIT_SWITCH_ACCESSOR}

	make


feature {NONE} -- Initialization

	make is
		do
			create {DS_LINKED_STACK [STDC_EXIT_HANDLER]} exit_handlers.make
			epx_set_exit_switch (any_to_pointer (Current), $at_exit)
		end


feature {NONE} -- gc

	dispose is
			-- Make sure remaining handlers are made harmless.
		do
			epx_clear_exit_switch
			precursor
		end


feature -- install/uninstall handlers

	is_installed (handler: STDC_EXIT_HANDLER): BOOLEAN is
		require
			handler_not_void: handler /= Void
		do
			Result := exit_handlers.has (handler)
		end

	install (handler: STDC_EXIT_HANDLER) is
		require
			valid_handler: handler /= Void
			handler_not_installed: not is_installed (handler)
		do
			exit_handlers.put (handler)
		ensure
			handler_installed: is_installed (handler)
		end

	uninstall (handler: STDC_EXIT_HANDLER) is
		require
			valid_handler: handler /= Void
			handler_installed: is_installed (handler)
		do
			exit_handlers.remove
		ensure
			handler_not_installed: not is_installed (handler)
		end


feature {NONE} -- Callback

	at_exit is
			-- Callback routine, is called when program terminates.
		do
			from
			until
				exit_handlers.is_empty
			loop
				exit_handlers.item.execute
				exit_handlers.remove
			end
		end


feature {NONE} -- Implementation

	exit_handlers: DS_STACK [STDC_EXIT_HANDLER]


feature {NONE} -- C binding

	epx_clear_exit_switch is
		external "C"
		end

	epx_set_exit_switch (an_object, an_address: POINTER) is
		external "C"
		end


feature {NONE} -- Implementation

	frozen singleton: EPX_SINGLETON is
		once
			Result := Current
		end


invariant

	exit_handlers_not_void: exit_handlers /= Void

end
