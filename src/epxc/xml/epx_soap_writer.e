indexing

	description: "Generates SOAP messages."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

class

	EPX_SOAP_WRITER

inherit

	EPX_XML_WRITER
		rename
			as_uc_string as message
		end

create

	make,
	make_with_capacity


feature -- SOAP specific calls

	start_envelope is
		require
			this_is_root_tag: not is_tag_started
		do
			start_tag (soap_env_envelope)
			set_a_name_space (soap_env, soap_name_space)
			set_ns_attribute (soap_env, encodingstyle, soap_default_encoding)
		end

	stop_envelope is
		require
			envelope_started: is_envelope_started
		do
			stop_tag
		end

	start_header is
		require
			envelope_started: is_envelope_started
		do
			start_tag (soap_env_header)
		end

	stop_header is
		require
			header_started: is_header_started
		do
			stop_tag
		end

	start_body is
		require
			envelope_started: is_envelope_started
		do
			start_tag (soap_env_body)
		end

	stop_body is
		require
			body_started: is_body_started
		do
			stop_tag
		end


feature -- SOAP header attributes

	set_must_understand (value: BOOLEAN) is
			-- Set the SOAP-Env:mustUnderstand attribute to `value'.
		require
			header_started: is_a_parent (soap_env_header)
		do
			if value then
				set_ns_attribute (soap_env, mustUnderstand, one_string)
			else
				set_ns_attribute (soap_env, mustUnderstand, zero_string)
			end
		end


feature -- Queries if tags started

	is_envelope_started: BOOLEAN is
		do
			Result := is_started (soap_env_envelope)
		end

	is_header_started: BOOLEAN is
		do
			Result := is_started (soap_env_header)
		end

	is_body_started: BOOLEAN is
		do
			Result := is_started (soap_env_body)
		end


feature -- SOAP tags

	soap_env_body: STRING is "SOAP-ENV:Body"
	soap_env_envelope: STRING is "SOAP-ENV:Envelope"
	soap_env_header: STRING is "SOAP-ENV:Header"


feature {NONE} -- SOAP attributes

	encodingStyle: STRING is "encodingStyle"
	mustUnderstand: STRING is "mustUnderstand"

feature -- SOAP name space

	soap_env: STRING is "SOAP-ENV"

	soap_name_space: STRING is "http://schemas.xmlsoap.org/soap/envelope/"


feature {NONE} -- SOAP encodings

	soap_default_encoding: STRING is "http://schemas.xmlsoap.org/soap/encoding/"

feature {NONE} -- Attribute values

	zero_string: STRING is "0"
	one_string: STRING is "1"

end
