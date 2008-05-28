indexing

	description:

		"Objects that ..."

	library: "eposix library"
	author: "Till G. Bay"
	copyright: "Copyright (c) 2007, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_SOCKET_MULTIPLEXER


inherit

	EPX_SELECT
		rename
			make as make_select,
			set_timeout as set_timeout_select,
			ready_descriptors as number_of_fired_callbacks
		export
			{NONE}
				execute,
				check_for_exception_conditions,
				check_for_reading,
				check_for_writing,
				exception_conditions,
				ready_for_reading,
				ready_for_writing,
				set_timeout_select,
				is_valid_descriptor_set
		end


create

	make


feature -- Initialize

	make is
			-- create an empty multiplexer
		do
			make_select
			idle_callback := False
			timeout := create {EPX_TIME_VALUE}.make
			--timeout.set_to_infinity
			timeout.set_microseconds (0)
			timeout.set_seconds (1)
		end


feature -- Options

	idle_callback: BOOLEAN
			-- should read and write sockets get a idle_callback when
			-- no bytes can be read or written respectivily

	set_idle_callbeack (new_value: BOOLEAN) is
			-- set the `idle_callback'
		do
			idle_callback := new_value
		ensure
			idle_callback_set: idle_callback = new_value
		end

	set_timeout (a_timeout: EPX_TIME_VALUE) is
			-- set the timeout
		require
			a_timeout_not_void: a_timeout /= Void
		do
			timeout := a_timeout
		ensure
			timeout_set: timeout = a_timeout
		end


feature -- Multiplex

	multiplex  is
			-- Go through all registered sockets.
			-- for read sockets
			--    call multiplexer_read_callback if bytes can be read
			--    call multiplexer_read_idle_callback if no bytes can be read and idle_callback is true
			-- for write sockets
			--    call multiplexer_write_callback if bytes can be written
			--    call multiplexer_write_idle_callback if no bytes can be written and idle_callback is true
			-- for error sockets
			--    call multiplexer_error_callback if bytes can be read
			-- the number of fired callbacks (without the idle_callbacks) is stored in `number_of_fired_callbacks'
		require
			at_least_one_socket: num_read_sockets + num_write_sockets + num_error_sockets > 0
		local
			socket: ABSTRACT_SOCKET
			copy_of_check_for_reading: DS_SET [ABSTRACT_DESCRIPTOR]
			copy_of_check_for_writing: DS_SET [ABSTRACT_DESCRIPTOR]
			copy_of_exception_conditions: DS_SET [ABSTRACT_DESCRIPTOR]
		do
			execute

			-- this is necessary since the callbacks can change the data structure by adding or removing sockets
			copy_of_check_for_reading := check_for_reading.cloned_object
			copy_of_check_for_writing := check_for_writing.cloned_object
			copy_of_exception_conditions := exception_conditions.cloned_object

			from copy_of_check_for_reading.start
			until copy_of_check_for_reading.after
			loop
				socket ?= copy_of_check_for_reading.item_for_iteration
				if ready_for_reading.has (socket) then
					socket.multiplexer_read_callback (current)
				elseif idle_callback then
					socket.multiplexer_read_idle_callback (current)
				end
				copy_of_check_for_reading.forth
			end

			from copy_of_check_for_writing.start
			until copy_of_check_for_writing.after
			loop
				socket ?= copy_of_check_for_writing.item_for_iteration
				if ready_for_writing.has (socket) then
					socket.multiplexer_write_callback (current)
				elseif idle_callback then
					socket.multiplexer_write_idle_callback (current)
				end
				copy_of_check_for_writing.forth
			end

			from copy_of_exception_conditions.start
			until copy_of_exception_conditions.after
			loop
				socket ?= copy_of_exception_conditions.item_for_iteration
				socket.multiplexer_error_callback (current)
				copy_of_exception_conditions.forth
			end

		end


feature -- Change Sockets

	add_read_socket (a_socket: ABSTRACT_SOCKET) is
			-- register a read socket to be handled by the multiplexer
		require
			a_socket_not_void: a_socket /= Void
		do
			check_for_reading.put (a_socket)
		ensure
			a_socket_added: has_read_socket (a_socket)
		end

	remove_read_socket (a_socket: ABSTRACT_SOCKET) is
			-- register a read socket to be handled by the multiplexer
		require
			a_socket_not_void: a_socket /= Void
		do
			check_for_reading.remove (a_socket)
		ensure
			a_socket_removed: not has_read_socket (a_socket)
		end


	add_write_socket (a_socket: ABSTRACT_SOCKET) is
			-- register a write socket to be handled by the multiplexer
		require
			a_socket_not_void: a_socket /= Void
		do
			check_for_writing.put (a_socket)
		ensure
			a_socket_added: has_write_socket (a_socket)
		end

	remove_write_socket (a_socket: ABSTRACT_SOCKET) is
			-- register a write socket to be handled by the multiplexer
		require
			a_socket_not_void: a_socket /= Void
		do
			check_for_writing.remove (a_socket)
		ensure
			a_socket_removed: not has_write_socket (a_socket)
		end


	add_error_socket (a_socket: ABSTRACT_SOCKET) is
			-- register a error socket to be handled by the multiplexer
		require
			a_socket_not_void: a_socket /= Void
		do
			check_for_exception_conditions.put (a_socket)
		ensure
			a_socket_removed: not has_error_socket (a_socket)
		end

	remove_error_socket (a_socket: ABSTRACT_SOCKET) is
			-- register a error socket to be handled by the multiplexer
		require
			a_socket_not_void: a_socket /= Void
		do
			check_for_exception_conditions.remove (a_socket)
		ensure
			a_socket_removed: not has_error_socket (a_socket)
		end


feature -- Query Sockets

	has_read_socket (a_socket: ABSTRACT_SOCKET): BOOLEAN is
			-- returns true if `a_socket' is registered for managing reads
		require
			a_socket_not_void: a_socket /= Void
		do
			Result := check_for_reading.has (a_socket)
		end

	has_write_socket (a_socket: ABSTRACT_SOCKET): BOOLEAN is
			-- returns true if `a_socket' is registered for managing reads
		require
			a_socket_not_void: a_socket /= Void
		do
			Result := check_for_writing.has (a_socket)
		end

	has_error_socket (a_socket: ABSTRACT_SOCKET): BOOLEAN is
			-- returns true if `a_socket' is registered for managing reads
		require
			a_socket_not_void: a_socket /= Void
		do
			Result := check_for_exception_conditions.has (a_socket)
		end

	num_read_sockets: INTEGER is
			-- get the numbr of registered read sockets
		do
			Result := check_for_reading.count
		end

	num_write_sockets: INTEGER is
			-- get the numbr of registered write sockets
		do
			Result := check_for_writing.count
		end

	num_error_sockets: INTEGER is
			-- get the numbr of registered error sockets
		do
			Result := check_for_exception_conditions.count
		end


end
