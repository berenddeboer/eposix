indexing

	description: "getest based test for ULM classes."

	author: "Berend de Boer"
	date: "$Date: 2003/11/29 $"
	revision: "$Revision: #1 $"


deferred class

	TEST_ULM

inherit

	TS_TEST_CASE
		redefine
			set_up
		end

feature -- Tests

	set_up is
		do
			create handler.make ("eposix_test")
			create logger.make (handler, "test_ulm")
		end

	test_valid_field_names is
		do
			assert ("PROG is valid", logger.is_valid_field_name (logger.PROG))
			assert ("Void string is not valid", not logger.is_valid_field_name (Void))
			assert ("empty string is not valid", not logger.is_valid_field_name (""))
			assert ("A is valid", logger.is_valid_field_name ("A"))
			assert (".A is not valid", not logger.is_valid_field_name (".A"))
			assert ("A.B is valid", logger.is_valid_field_name ("A.B"))
			assert ("A..B is not valid", not logger.is_valid_field_name ("A..B"))
			assert ("A.B. is not valid", not logger.is_valid_field_name ("A.B."))
			assert ("A_B is not valid", not logger.is_valid_field_name ("A_B"))
			assert ("A-B is valid", logger.is_valid_field_name ("A-B"))
			assert ("AB29 is valid", logger.is_valid_field_name ("AB29"))
		end

	test_valid_field_lists is
		local
			field: ULM_FIELD
			fields: ARRAY [ULM_FIELD]
		do
			create fields.make (0, 0)
			create field.make (logger.PROG, "temp")
			fields.put (field, 0)
			assert ("<<PROG>> is valid", logger.is_valid_partial_field_list (fields))
			create fields.make (0, 1)
			create field.make (logger.PROG, "temp")
			fields.put (field, 0)
			fields.put (field, 1)
			assert ("twice <<PROG>> is not valid", not logger.is_valid_partial_field_list (fields))

			create fields.make (0, 1)
			create field.make (logger.PROG, "temp")
			fields.put (field, 0)
			assert ("Void field is not valid", not logger.is_valid_partial_field_list (fields))
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
			logger.log_message (logger.Emergency, "test_ulm", "Emergency.")
			logger.log_message (logger.Alert, "test_ulm", "Alert.")
			logger.log_message (logger.Error, "test_ulm", "Error.")
			logger.log_message (logger.Warning, "test_ulm", "Warning.")
			logger.log_message (logger.Authentication, "test_ulm", "Authentication.")
			logger.log_message (logger.Security, "test_ulm", "Security.")
			logger.log_message (logger.Usage, "test_ulm", "Usage.")
			logger.log_message (logger.System_usage, "test_ulm", "System_usage.")
			logger.log_message (logger.Important, "test_ulm", "Important.")
			logger.log_message (logger.Debugging, "test_ulm", "Debugging.")
		end

	test_logging is
			-- Tests by visual inspection only.
		local
			field: ULM_FIELD
			fields: ARRAY [ULM_FIELD]
		do
			logger.log_message (logger.Alert, "test_ulm", "Hello World.")

			create fields.make (0, 0)
			create field.make (logger.PROG, "temp")
			fields.put (field, 0)
			logger.log_event (logger.Usage, "test_ulm", fields)

			create fields.make (0, 1)
			create field.make (logger.SRC_IP, "127.0.0.1")
			fields.put (field, 0)
			create field.make (logger.PROG, "temp")
			fields.put (field, 1)
			logger.log_event (logger.Usage, "test_ulm", fields)

			create fields.make (0, 2)
			create field.make (logger.SRC_IP, "127.0.0.1")
			fields.put (field, 0)
			create field.make (logger.DATE, "20020712092605")
			fields.put (field, 1)
			create field.make (logger.SRC_NAME, "localhost")
			fields.put (field, 2)
			logger.log_event (logger.Usage, Void, fields)
		end


feature -- State

	logger: ULM_LOGGING
	handler: EPX_LOG_HANDLER

end
