note

	description: "Global definitions for FCGI protocol"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI protocol"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "MIT"


class

	EPX_FAST_CGI_CONSTANTS


feature -- Record

	Fcgi_max_len: INTEGER = 65535

	Fcgi_header_len: INTEGER = 8
	Fcgi_end_req_body_len: INTEGER = 8
	Fcgi_begin_req_body_len: INTEGER = 8
	Fcgi_unknown_body_type_body_len: INTEGER = 8

	Fcgi_version: INTEGER = 1


feature -- Record types

	Fcgi_begin_request: INTEGER = 1
	Fcgi_abort_request: INTEGER = 2
	Fcgi_end_request: INTEGER = 3
	Fcgi_params: INTEGER = 4
	Fcgi_stdin: INTEGER = 5
	Fcgi_stdout: INTEGER = 6
	Fcgi_stderr: INTEGER = 7
	Fcgi_data: INTEGER = 8
	Fcgi_get_values: INTEGER = 9
	Fcgi_get_values_result: INTEGER = 10
	Fcgi_unknown_type: INTEGER = 11
	Fcgi_max_type: INTEGER = 11

	Fcgi_null_request_id: INTEGER = 0


feature -- Access

	Fcgi_keep_conn:INTEGER = 1

	Fcgi_responder: INTEGER = 1
	Fcgi_authorizer: INTEGER = 2
	Fcgi_filter: INTEGER = 3

	Fcgi_request_complete: INTEGER = 0
	Fcgi_cant_mpx_conn: INTEGER = 1
	Fcgi_overload: INTEGER = 2
	Fcgi_unknown_role: INTEGER = 3

	Fcgi_max_conns: STRING = "FCGI_MAX_CONNS"
	Fcgi_max_reqs: STRING = "FCGI_MAX_REQS"
	Fcgi_mpxs_conns: STRING = "FCGI_MPXS_CONNS"

	Fcgi_stream_record: INTEGER = 0
	Fcgi_skip: INTEGER = 1
	Fcgi_begin_record: INTEGER = 2
	Fcgi_mgmt_record: INTEGER = 3

	Fcgi_unsupported_version: INTEGER = -2
	Fcgi_protocol_error: INTEGER = -3
	Fcgi_params_error: INTEGER = -4
	Fcgi_call_seq_error: INTEGER = -5

end
