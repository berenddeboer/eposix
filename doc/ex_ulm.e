class EX_ULM

creation

	make

feature -- Initialization

	make is
		local
			logger: ULM_LOGGING
			handler: EPX_LOG_HANDLER
			field: ULM_FIELD
			fields: ARRAY [ULM_FIELD]
		do
			-- Create handler and logger
			create handler.make (identification)
			create logger.make (handler, system_name)

			-- Log a simple message
			logger.log_message (logger.Alert, subsystem_name, "Hello World.")

			-- Log a message with a custom field
			create fields.make (0, 0)
			create field.make (logger.SRC_IP, "127.0.0.1")
			fields.put (field, 0)
			logger.log_event (logger.Usage, Void, fields)
		end

feature -- Access

	identification: STRING is "example"

	system_name: STRING is "ex_ulm"

	subsystem_name: STRING is "none"

end
