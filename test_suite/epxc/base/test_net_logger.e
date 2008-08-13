indexing

	description: "getest based test for net logger classes."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


deferred class

	TEST_NET_LOGGER


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		redefine
			set_up
		end


feature -- Tests

	set_up is
		do
			create handler.make ("eposix_test")
			create my_logger.make (handler, "test_ulm")
		end

	test_valid_field_names is
		do
			assert ("PROG is valid", my_logger.is_valid_name (my_logger.names.PROG))
			assert ("Void string is not valid", not my_logger.is_valid_name (Void))
			assert ("empty string is not valid", not my_logger.is_valid_name (""))
			assert ("A is valid", my_logger.is_valid_name ("A"))
			assert (".A is not valid", not my_logger.is_valid_name (".A"))
			assert ("A.B is valid", my_logger.is_valid_name ("A.B"))
			assert ("A..B is not valid", not my_logger.is_valid_name ("A..B"))
			assert ("A.B. is not valid", not my_logger.is_valid_name ("A.B."))
			assert ("A_B is not valid", not my_logger.is_valid_name ("A_B"))
			assert ("A-B is valid", my_logger.is_valid_name ("A-B"))
			assert ("AB29 is valid", my_logger.is_valid_name ("AB29"))
		end

	test_valid_field_lists is
		local
			field: NET_LOGGER_FIELD
			fields: ARRAY [NET_LOGGER_FIELD]
		do
			create fields.make (0, 0)
			create field.make (my_logger.names.PROG, "temp")
			fields.put (field, 0)
			--assert ("<<PROG>> is valid", my_logger.is_valid_partial_field_list (fields))
			create fields.make (0, 1)
			create field.make (my_logger.names.PROG, "temp")
			fields.put (field, 0)
			fields.put (field, 1)
			--assert ("twice <<PROG>> is not valid", not my_logger.is_valid_partial_field_list (fields))

			create fields.make (0, 1)
			create field.make (my_logger.names.PROG, "temp")
			fields.put (field, 0)
			--assert ("Void field is not valid", not my_logger.is_valid_partial_field_list (fields))
		end

	test_log_levels is
			-- Tests by visual inspection only.
			-- To avoid "The description for Event ID ( 1 ) in Source (
			-- eposix_test ) cannot be found. The local computer may not
			-- have the necessary registry information or message DLL
			-- files to display messages from a remote computer. The
			-- following information is part of the event:" on Windows
			-- NT, register messages.dll under the "eposix_test" key.
		do
			my_logger.write_msg (my_logger.levels.fatal, "test_ulm", "Emergency.")
			my_logger.write_msg (my_logger.levels.error, "test_ulm", "Error.")
			my_logger.write_msg (my_logger.levels.warning, "test_ulm", "Warning.")
			my_logger.write_msg (my_logger.levels.info, "test_ulm", "Info.")
			my_logger.write_msg (my_logger.levels.debug0, "test_ulm", "debug0.")
			my_logger.write_msg (my_logger.levels.debug1, "test_ulm", "debug1.")
			my_logger.write_msg (my_logger.levels.trace, "test_ulm", "trace.")
		end

	test_logging is
			-- Tests by visual inspection only.
		local
			field: NET_LOGGER_FIELD
			fields: DS_LINKED_LIST [NET_LOGGER_FIELD]
		do
			my_logger.write_msg (my_logger.levels.error, "test_ulm", "Hello World.")

			create fields.make
			create field.make (my_logger.names.PROG, "temp")
			fields.put_last (field)
			my_logger.write (my_logger.levels.info, "test_ulm", fields)

			create fields.make
			create field.make (once "src_ip", "127.0.0.1")
			fields.put_last (field)
			create field.make (my_logger.names.PROG, "temp")
			fields.put_last (field)
			my_logger.write (my_logger.levels.info, "test_ulm", fields)

			create fields.make
			create field.make (once "src_ip", "127.0.0.1")
			fields.put_last (field)
			create field.make (my_logger.names.timestamp, "20020712092605")
			fields.put_last (field)
			create field.make (my_logger.names.local_host, "localhost")
			fields.put_last (field)
			my_logger.write (my_logger.levels.info, Void, fields)
		end


feature -- State

	my_logger: NET_LOGGER
	handler: EPX_LOG_HANDLER

end
