class EX_ULM

create

	make

feature -- Initialization

	make is
		local
			logger: NET_LOGGER
			handler: EPX_LOG_HANDLER
			field: NET_LOGGER_FIELD
			fields: DS_LINKED_LIST [NET_LOGGER_FIELD]
		do
			-- Create handler and logger
			create handler.make (identification)
			create logger.make (handler, system_name)

			-- Log a simple message
			logger.write_msg (logger.levels.warning, "testing", "Hello World.")

			-- Log a message with a custom field
			create fields.make
			create field.make ("myField", "127.0.0.1")
			fields.put (field, 0)
			logger.write (logger.levels.info, "testing", fields)
		end

feature -- Access

	identification: STRING is "example"

	system_name: STRING is "ex_ulm"

end
