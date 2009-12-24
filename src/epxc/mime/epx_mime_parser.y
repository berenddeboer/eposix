%{
indexing

	description: "eposix's MIME parser."

	standards: "Based on RFC 822, 2045, 2047 and 2616."

	implementation:
		"1. Not all recognized field names are parsed.%
		%   Should be easy to expand if you wish to do real message parsing.%
		%   That is not yet the case, everything about MIME messages%
		%   must be defined here and compiled in.%
		%2. Fields to add: Content-Type-Encoding; Content-Description%
		%3. What if no header, just empty line and body? Parsed ok?"

	known_bugs:
		"1. Dates with invalid time-zone get time-zone +0000."

	author: "Berend de Boer"
	date: "$Date: $"
	revision: "$Revision: $"

class

	EPX_MIME_PARSER


inherit

	EPX_MIME_SCANNER
		rename
			make as make_scanner
		redefine
			wrap
		end

	YY_PARSER_SKELETON
		rename
			parse as do_parse
		redefine
			make,
			report_error
		end

	EPX_MIME_PARAMETER_NAMES
		export
			{NONE} all
		end

	EPX_MIME_FIELD_NAMES
		export
			{NONE} all
		end

	STDC_CURRENT_PROCESS
		rename
			abort as abort_process
		export
			{NONE} all
		end


create

	make,
	make_from_file,
	make_from_stream,
	make_from_string,
	make_from_file_descriptor


%}

-- structured field names
%token FN_BCC FN_CC
%token FN_CONTENT_DISPOSITION FN_CONTENT_LENGTH FN_CONTENT_TRANSFER_ENCODING
%token FN_CONTENT_TYPE FN_DATE
%token FN_FROM FN_IF_MODIFIED_SINCE FN_LAST_MODIFIED FN_MESSAGE_ID
%token FN_RECEIVED FN_RETURN_PATH FN_RESENT_FROM FN_RESENT_REPLY_TO
%token FN_RESENT_SENDER
%token FN_SENDER FN_SET_COOKIE FN_TO FN_TRANSFER_ENCODING FN_VERSION
%token FN_WWW_AUTHENTICATE

-- structured field elements
%token <STRING> MIME_ATOM MIME_VALUE_ATOM DOMAIN_LITERAL QUOTED_STRING
%token <INTEGER> MONTH NUMBER

-- special keywords to be expected at certain points
%token KW_BY KW_FOR KW_FROM KW_ID KW_VIA KW_WITH
%token KW_SUN KW_MON KW_TUE KW_WED KW_THU KW_FRI KW_SAT

-- unstructured fields
%token <STRING> FIELD_NAME FIELD_BODY

-- syntactic elements
%token CRLF

-- types of nonterminals
%type <EPX_MIME_FIELD> header_field
%type <EPX_MIME_UNSTRUCTURED_FIELD> unrecognized_field
%type <EPX_MIME_FIELD> recognized_field

-- types of recognized fields
%type <EPX_MIME_FIELD_CONTENT_DISPOSITION> content_disposition_field
%type <EPX_MIME_FIELD_CONTENT_LENGTH> content_length_field
%type <EPX_MIME_FIELD_CONTENT_TRANSFER_ENCODING> content_transfer_encoding_field
%type <EPX_MIME_FIELD_CONTENT_TYPE> content_type_field
%type <EPX_MIME_FIELD_DATE> date_field
%type <EPX_MIME_FIELD_IF_MODIFIED_SINCE> if_modified_since_field
%type <EPX_MIME_FIELD_LAST_MODIFIED> last_modified_field
%type <EPX_MIME_FIELD_MESSAGE_ID> message_id_field
%type <EPX_MIME_FIELD_MIME_VERSION> mime_version_field
%type <EPX_MIME_FIELD_MAILBOX_LIST> bcc_field, cc_field, from_field, resent_from_field, resent_reply_to_field, to_field
%type <EPX_MIME_FIELD_SET_COOKIE> set_cookie_field
%type <EPX_MIME_FIELD_TRANSFER_ENCODING> transfer_encoding_field
%type <EPX_MIME_FIELD_WWW_AUTHENTICATE> www_authenticate_field

-- types of structured field parts
%type <EPX_MIME_MAILBOX> address
%type <DS_LINKABLE [EPX_MIME_MAILBOX]> address_list
%type <STRING> addr_spec
%type <STRING> angle_addr
%type <STRING> obs_angle_addr
%type <STRING> atom
%type <STRING> attribute
%type <STRING> auth_scheme
%type <STDC_TIME> date
%type <STDC_TIME> date_rfc1123
%type <STDC_TIME> date_rfc850
%type <STDC_TIME> date_asc
%type <STDC_TIME> date_time
%type <STRING> display_name
%type <STRING> domain
%type <STRING> domain_ref
%type <STRING> dot_atom
%type <STRING> dot_atom_text
%type <STDC_TIME> hour
%type <STDC_TIME> http_date
%type <STRING> id_left
%type <STRING> id_right
%type <STRING> obs_id_right
%type <STRING> local_part
%type <EPX_MIME_MAILBOX> mailbox
%type <DS_LINKABLE [EPX_MIME_MAILBOX]> mailbox_list
%type <DS_LINKABLE [EPX_MIME_MAILBOX]> optional_mailbox_list
%type <STRING> mechanism
%type <STRING> msg_id
%type <EPX_MIME_MAILBOX> name_addr
%type <STRING> no_fold_quote
%type <EPX_MIME_PARAMETER> parameter
%type <STRING> phrase
%type <STRING> phrase_item
%type <STRING> one_or_more_phrase_item
%type <INTEGER> optional_seconds
%type <STRING> sub_domain
%type <STRING> subtype
%type <STDC_TIME> time
%type <STRING> token
%type <STRING> type
%type <STRING> value
%type <INTEGER> zone
%type <INTEGER> optional_zone

-- types of unstructured field
%type <STRING> unstructured

-- basic types handled by nonterminals
%type <INTEGER> integer
%type <STRING> word

%%
-------------------------------------------------------------------------------

message
	: header_fields CRLF { accept }
	| CRLF { accept }
	;


header_fields
	: header_field
	| header_field header_fields
	;


header_field
	: recognized_field CRLF
		{ if $1 /= Void then part.header.add_non_unique_field ($1) end }
	| unrecognized_field CRLF
		{ part.header.add_non_unique_field ($1) }
	| error { reset_start_condition } CRLF
	;


-- @@BdB many fields listed here not created yet!!
recognized_field
	: bcc_field
		{ $$ := $1 }
	| cc_field
		{ $$ := $1 }
	| content_disposition_field
		{ $$ := $1 }
	| content_length_field
		{ $$ := $1 }
	| content_transfer_encoding_field
		{ $$ := $1 }
	| content_type_field
		{ $$ := $1 }
	| date_field
		{ $$ := $1 }
	| from_field
		 { $$ := $1 }
	| if_modified_since_field
		 { $$ := $1 }
	| last_modified_field
		 { $$ := $1 }
	| message_id_field
		{ $$ := $1 }
	| mime_version_field
		{ $$ := $1 }
	| received_field
	| resent_from_field
		 { $$ := $1 }
	| resent_sender_field
	| resent_reply_to_field
		 { $$ := $1 }
	| return_path_field
	| sender_field
	| set_cookie_field
		{ $$ := $1 }
	| to_field
		{ $$ := $1 }
	| transfer_encoding_field
		{ $$ := $1 }
	| www_authenticate_field
		{ $$ := $1 }
	;


-- structured fields

bcc_field
	: FN_BCC ':' address_list
		{
			create $$.make (field_name_bcc, $3)
		}
	| FN_BCC ':'
		{
			create $$.make (field_name_bcc, Void)
		}
	;

cc_field
	: FN_CC ':' address_list
		{
			create $$.make (field_name_cc, $3)
		}
	| FN_CC ':'
		{
			create $$.make (field_name_cc, Void)
		}
	;

content_disposition_field
	: FN_CONTENT_DISPOSITION ':'
	token
		{
			create my_content_disposition.make ($3)
			current_parameter_field := my_content_disposition
			start_parameter
		}
	optional_parameters
		{
			$$ := my_content_disposition
			my_content_disposition.cleanup_filename_parameter
			current_parameter_field := Void
		}
	;

content_length_field
	: FN_CONTENT_LENGTH ':'
	integer
		{
			create $$.make ($3)
		}
	;

content_transfer_encoding_field
	: FN_CONTENT_TRANSFER_ENCODING ':'
		mechanism
		{
			create $$.make ($3)
		}
	;

content_type_field
	: FN_CONTENT_TYPE ':'
	type '/' subtype
		{
			create my_content_type.make ($3, $5)
			current_parameter_field := my_content_type
			start_parameter
		}
	optional_parameters
		{
			$$ := my_content_type
			current_parameter_field := Void
		}
	;

-- @@BdB: have to create actual field
date_field
	: FN_DATE ':'
		{ expect_date }
		date_time
		{
			if $4 /= Void then
				create $$.make ($4)
			end
		}
	;

-- @@BdB: have to create actual field
from_field
	: FN_FROM ':' mailbox_list
		{
			create $$.make (field_name_from, $3)
		}
	;

if_modified_since_field
	: FN_IF_MODIFIED_SINCE ':'
		{ expect_date }
		http_date
		{
			create {EPX_MIME_FIELD_IF_MODIFIED_SINCE} $$.make ($4)
		}
	;

last_modified_field
	: FN_LAST_MODIFIED ':'
		{ expect_date }
		http_date
		{
			create {EPX_MIME_FIELD_LAST_MODIFIED} $$.make ($4)
		}
	;

message_id_field
	: FN_MESSAGE_ID ':' msg_id
		{ create $$.make ($3) }
	;

mime_version_field
	: FN_VERSION ':'
	INTEGER '.' INTEGER
		{ create $$.make ($3, $5) }
	;

received_field
	: FN_RECEIVED ':'
	optional_from_domain
	optional_by_domain
	optional_via_atom
	optional_with_atoms
	optional_id
	optional_for_addr_spec
	';' { expect_date } date_time
	;

resent_from_field
	: FN_RESENT_FROM ':' mailbox_list
		{
			create $$.make (field_name_resent_from, $3)
		}
	;

resent_reply_to_field
	: FN_RESENT_REPLY_TO ':' address_list
		{
			create $$.make (field_name_resent_reply_to, $3)
		}
	;

resent_sender_field
	: FN_RESENT_SENDER ':' mailbox
	;

return_path_field
	: FN_RETURN_PATH ':' path
	;

sender_field
	: FN_SENDER ':' mailbox
	;

set_cookie_field
	: FN_SET_COOKIE ':'
	token '=' value
		{
			create my_set_cookie.make ($3, $5)
			current_parameter_field := my_set_cookie
			start_parameter
		}
	optional_parameters
		{
			$$ := my_set_cookie
			current_parameter_field := Void
		}
	;

-- empty address_list seems not be be allowed, but occurs...
to_field
	: FN_TO ':' address_list
		{
			create $$.make (field_name_to, $3)
		}
	| FN_TO ':'
		{
			create $$.make (field_name_to, Void)
		}
	;

transfer_encoding_field
	: FN_TRANSFER_ENCODING ':'
	token
		{
			create my_transfer_encoding.make ($3)
			current_parameter_field := my_transfer_encoding
			start_parameter
		}
	optional_parameters
		{
			$$ := my_transfer_encoding
			current_parameter_field := Void
		}
	;

-- HTTP authentication challenge

www_authenticate_field
	: FN_WWW_AUTHENTICATE ':'
	auth_scheme
		{
			create my_www_authenticate.make ($3)
			current_parameter_field := my_www_authenticate
			start_parameter
		}
	one_or_more_auth_param
		{
			$$ := my_www_authenticate
			current_parameter_field := Void
		}
	;


-- structured fields parts

-- TODO: group not yet supported
address
	: mailbox
		{ $$ := $1 }
	| group
	;

-- obsolete RFC 822 format, RFC 2822 is better
address_list
	: ','
	| address
		{ create $$.make ($1) }
	| address ',' address_list
		{ create $$.make ($1); $$.put_right ($3) }
	;

optional_addr_spec
	: -- empty
	| addr_spec
		{ $$ := $1 }
	;

addr_spec
	: local_part '@' domain
		{
		create $$.make_from_string ($1)
		$$.append_character ('@')
		$$.append_string ($3)
		}
	;

angle_addr
	: '<' addr_spec '>'
		{ $$ := $2 }
	| obs_angle_addr
		{ $$ := $1 }
	;

atom
	: MIME_ATOM
		{ $$ := $1 }
	;

attribute
	: token
		{ $$ := $1 }
	;

auth_scheme
	: token { $$ := $1 }
	;

-- according to RFC 2617, parameters are separated by spaced, but
-- Apache returns them separated with a comma
one_or_more_auth_param
	: parameter
	| parameter one_or_more_auth_param
	| parameter ',' one_or_more_auth_param
	;


-- rfc1123-date, rfc850-date and asctime-date
date
	: date_rfc1123
		{ $$ := $1 }
	| date_rfc850
		{ $$ := $1 }
	| date_asc
		{ $$ := $1 }
	;

date_rfc1123
	: NUMBER MONTH NUMBER
		{
			if my_date.is_two_digit_year ($3.item) then
				my_year := my_date.four_digit_year ($3.item)
			else
				my_year := $3.item
			end
			if
				my_date.is_valid_date (my_year, $2.item, $1.item)
			then
				my_date.make_utc_date (my_year, $2.item, $1.item)
				$$ := my_date
			end
		}
	;

date_rfc850
	: NUMBER '-' MONTH '-' NUMBER
		{
			if my_date.is_two_digit_year ($5.item) then
				my_year := my_date.four_digit_year ($5.item)
			else
				my_year := $5.item
			end
			if my_date.is_valid_date (my_year, $3.item, $1.item) then
				my_date.make_utc_date (my_year, $3.item, $1.item)
				$$ := my_date
			end
		}
	;

date_asc
	: MONTH NUMBER
		{
			if my_date.is_valid_date (my_date.current_year, $1.item, $2.item) then
				my_date.make_utc_date (my_date.current_year, $1.item, $2.item)
				$$ := my_date
			end
		}
	;

-- zone is required, but what about the people who conveniently forget it??
-- Void if returned if date is somehow invalid
date_time
	: optional_day date time optional_zone
		{
			if $2 /= Void and then $3 /= Void and then my_date.is_valid_date_and_time ($2.year, $2.month, $2.day, $3.hour, $3.minute, $3.second) then
				create $$.make_utc_date_time ($2.year, $2.month, $2.day, $3.hour, $3.minute, $3.second)
				minutes := $4.item.abs \\ 100
				hours := $4.item.abs // 100
				seconds := (minutes * 60 + hours * 3600)
				if $4.item < 0 then
					seconds := -1 * seconds
				end
				$$.make_from_unix_time ($$.value - seconds)
				$$.to_utc
			end
		}
	;

day
	: KW_SUN
	| KW_MON
	| KW_TUE
	| KW_WED
	| KW_THU
	| KW_FRI
	| KW_SAT
	;

display_name
	: phrase
		{ $$ := $1 }
	;

domain
	: sub_domain
		{ $$ := $1 }
	| sub_domain '.' domain
		{ $$ := $1 + "." + $3 }
	;

domain_ref
	: atom
		{ $$ := $1 }
	;

dot_atom
	: dot_atom_text
		{ $$ := $1 }
	;

dot_atom_text
	: ATOM
		{ $$ := $1 }
	| ATOM '.' dot_atom_text
		 { $$ := $1 + "." + $3 }
	;

group
	: phrase ':' optional_mailbox_list ';'
	;

hour
	: NUMBER ':' NUMBER optional_seconds
		{
			if my_time.is_valid_time ($1.item, $3.item, $4.item) then
				my_time.make_utc_time ($1.item, $3.item, $4.item)
				$$ := my_time
			end
		}
	;

http_date
	: date_time
		{ $$ := $1 }
	;

id_left
	: dot_atom_text
		{ $$ := $1 }
	| no_fold_quote
		{ $$ := $1 }
--	| obs_id_left
	;

--obs_id_left
--	: local_part
--	;

id_right
	: dot_atom_text
		{ $$ := $1 }
	| no_fold_quote
		{ $$ := $1 }
	| obs_id_right
		{ $$ := $1 }
	;

-- is just domain, but because of overlap, we only take DOMAIN_LITERAL here
obs_id_right
	: DOMAIN_LITERAL
		{ $$ := $1 }
--	| domain
	;

integer
	: atom
		{
		if $1.is_integer then
			$$ := $1.to_integer
		else
			abort
		end
		}
	;

local_part
	: dot_atom
		 { $$ := $1 }
	| QUOTED_STRING
		 { $$ := $1 }
--   | obs-local-part
	;

mailbox
	: addr_spec
		{ create $$.make (Void, $1) }
	| name_addr
		{ $$ := $1 }
	;

mailbox_list
	: ','
	| mailbox
		{ create $$.make ($1) }
	| mailbox ',' mailbox_list
		{ create $$.make ($1); $$.put_right ($3) }
	;

mechanism
	: atom
		{ $$ := $1 }
	;

-- And we have to parse the stuff from the idiots that forget the
-- angle brackets. Can't people read specs??
msg_id
	: '<' id_left '@' id_right '>'
		{ $$ := $2 + $4 }
	| addr_spec
		{ $$ := $1 }
	;

name_addr
	: angle_addr
		{ create $$.make (Void, $1) }
	| display_name angle_addr
		{ create $$.make ($1, $2) }
	;

no_fold_quote
	: QUOTED_STRING
		{ $$ := $1 }
	;

obs_angle_addr
	: '<' obs_route addr_spec '>'
		{ $$ := $3 }
-- already in angle_addr
--	| '<' addr_spec '>'
	;

obs_route
	: obs_domain_list ':'
	;

obs_domain_list
	: obs_domain_list_item
	| obs_domain_list obs_domain_list_item
	;

obs_domain_list_item
	: ','
	| '@' domain
	;

obs_path
	: obs_angle_addr
	;

optional_by_domain
	: -- empty
	| KW_BY domain
	;

optional_day
	: -- empty
	| day ','
	;

optional_domain_literal
	: -- empty
	| DOMAIN_LITERAL
	;

-- The angle brackets are not according to the specs
-- but postfix insist on inserting it...
optional_for_addr_spec
	: -- empty
	| KW_FOR addr_spec
	| KW_FOR '<' addr_spec '>'
	;

-- fetchmail inserts a domain literal after from domain
-- ACM Email Forwarding Service has a from with only a comment
optional_from_domain
	: -- empty
	| KW_FROM domain optional_domain_literal
	;

optional_id
	: -- empty
	| KW_ID atom
	;

optional_mailbox_list
	: -- empty
	| mailbox_list
		{ $$ := $1 }
	;

optional_seconds
	: -- empty
		{ $$ := 0 }
	| ':' NUMBER
		{ $$ := $2.item }
	;

optional_via_atom
	: -- empty
	| KW_VIA atom
	;

optional_with_atoms
	: -- empty
	| with_atoms
	;

parameter
	: attribute '=' value
		{
			$1.to_lower
			create $$.make ($1, $3)
			current_parameter_field.parameters.put ($$, $1)
		}
	;

optional_parameters
	: -- empty
	| parameters
	;

-- There is some crap that just emits a ';' without any parameters,
-- or ends a parameter with a ';'
parameters
	: ';' parameter
	| ';'
	| ';' parameter parameters
	;

-- Return-Path on Exchange Server has no angle brackets??
-- Or is this just the spam??
path
	:  '<' optional_addr_spec '>'
	| obs_path
	| addr_spec -- this is not according to the specs
	;

phrase
	: one_or_more_phrase_item
		{ $$ := $1 }
	;

one_or_more_phrase_item
	: phrase_item
		{ $$ := $1 }
	| phrase_item one_or_more_phrase_item
		{ $$ := $1; $$.append_character (' '); $$.append_string ($2) }
	;

phrase_item
	: word
		{ $$ := $1 }
	;

sub_domain
	: domain_ref
		{ $$  := $1 }
	| DOMAIN_LITERAL
		{ $$ := $1 }
	;

subtype
	: atom
		{ $$ := $1 }
	;

time
	: hour
		{ $$ := $1 }
	;

token
	: atom
		{ $$ := $1 }
	;

-- discrete versus composite type does not seem to have much meaning
-- while parsing.
type
	: atom
		{
			if STRING_.same_string ($1.as_lower, "multipart") then
				$$ := "multipart"
				part.create_multipart_body
			else
				$$ := $1
			end
		}
	;

value
	: token
		{ $$ := $1 }
	| MIME_VALUE_ATOM
		{ $$ := $1 }
	| QUOTED_STRING
		{ $$ := $1 }
	;

with_atoms
	: KW_WITH atom
	| KW_WITH atom with_atoms
	;

word
	: atom
		{ $$ := $1 }
	| QUOTED_STRING
		{ $$ := $1 }
	;

-- parse the recognized zones in RFC822??
-- either something like UT or EST
-- or +0400 or -1200
-- We also try the idiots that send "GMT" instead of GMT
zone
	: NUMBER
		{ $$ := $1.item }
	| '"' NUMBER '"'
		{ $$ := $2.item }
	;

optional_zone
	: -- empty
		{ $$ := 0 }
	| zone
		{ $$ := $1 }
	;

-- all other fields
-- have to accept encoded-word here as well according to RFC 2047
unrecognized_field
	: FIELD_NAME ':' unstructured
		{ create $$.make ($1, $3) }
	;

unstructured
	: -- empty
		{ $$ := "" }
	| FIELD_BODY
		{ $$ := $1 }
	;

-------------------------------------------------------------------------------
%%


feature -- Initialization

	make is
		do
			if last_line = Void then
				make_scanner
				precursor
				create last_line.make (128)
			end
			level := 1
			boundary := Void
			create my_date.make_from_now
			my_date.to_utc
			create my_time.make_from_now
			my_time.to_utc
		end

	make_from_file (a_file: STDC_TEXT_FILE) is
			-- Like `make_from_stream', but turns off buffering in
			-- `a_file'.
		require
			file_not_void: a_file /= Void
			file_open: a_file.is_open
		do
			-- Turn off buffering, we're reading blocks anyway.
			a_file.set_no_buffering
			make_from_stream (a_file)
		end

	make_from_stream (a_stream: EPX_CHARACTER_INPUT_STREAM) is
			-- Initialize parser, and set the input buffer to `a_stream'.
		require
			stream_not_void: a_stream /= Void
			stream_open: a_stream.is_open_read
		do
			make
			set_input_buffer (new_mime_request_buffer (a_stream))
		end

	make_from_string (s: STRING) is
			-- Initialize parser, and set the input buffer to `s'.
		require
			s_not_void: s /= Void
		do
			make
			set_input_buffer (new_string_buffer (s))
		end

	make_from_file_descriptor (a_fd: ABSTRACT_FILE_DESCRIPTOR) is
		obsolete "Use make_from_stream instead."
		do
			make_from_stream (a_fd)
		end


feature -- Character reading

	eof: BOOLEAN is
			-- True if `read_character' hits end-of-file.
		obsolete "2006-04-03 use end_of_input instead"
		do
			Result := end_of_input
		end

	end_of_input: BOOLEAN is
			-- Has `read_character' hit the end-of-file character?
		do
			Result :=
				last_character = yyEnd_of_file_character and
				not input_buffer.filled
		end


feature {NONE} -- Scanning

	regular_buffer: like input_buffer
			-- Cache of `input_buffer', to be copied back on `wrap'.

	wrap: BOOLEAN is
			-- Check if we were parsing header, if so, resume with main
			-- buffer.
		do
			if regular_buffer /= Void then
				set_input_buffer (regular_buffer)
				regular_buffer := Void
			else
				Result := precursor
			end
		ensure then
			regular_buffer_void: regular_buffer = Void
		end


feature -- Parsing

	reset_parsing_errors is
			-- Reset count of parsing errors.
		do
			parsing_errors := 0
			accept
		ensure
			no_parsing_errors: parsing_errors = 0
		end

	parse is
			-- Read input and build `part'.
			-- Check `syntax_error' for parsing errors.
		do
			part := new_part
			parsing_errors := 0
			last_character := yyEnd_of_buffer_character
			inner_parse
		end

	parse_body is
			-- Parse MIME body.
			-- Assume `input_buffer' points to body part.
			-- If `a_content_length' positive, scans only as much body as
			-- given by `a_content_length', given that the input buffer
			-- is an EPX_MIME_BUFFER.
		require
			header_parsed: part /= Void
			part_not_void: part /= Void
		local
			buf: EPX_MIME_BUFFER
			is_multipart_body: BOOLEAN
			multipart_body: EPX_MIME_BODY_MULTIPART
			save_part: EPX_MIME_PART
			save_boundary: STRING
			parse_headers_after_chunk: BOOLEAN
		do
			-- Maximum size to parse is either determined by the
			-- Transfer-Coding or Content-Length. Both are specific to
			-- RFC 2616 MIME messages.
			if part.header.transfer_encoding /= Void then
				-- We only support chunked encoding.
				if part.header.transfer_encoding.is_chunked_coding then
					buf ?= input_buffer
					if buf /= Void then
						buf.set_index (yy_end)
						buf.set_transfer_encoding_chunked
						yy_end := buf.count + 1
						parse_headers_after_chunk := True
					end
				end
			elseif
				part.header.content_length /= Void and then
				part.header.content_length.length > 0
			then
				if level = 1 then
					buf ?= input_buffer
					if buf /= Void then
						buf.set_index (yy_end)
						buf.set_end_of_file_on_content_length (part.header.content_length.length)
					end
				else
					debug ("mime")
						stderr.put_string ("Content-Length field appears inside multipart body, ignored.%N")
					end
				end
			end

			-- Be very careful in determining if we should parse a
			-- multipart body.
			is_multipart_body :=
				part.body /= Void and then part.body.is_multipart and then
				part.header.content_type /= Void and then part.header.content_type.parameters.has (parameter_name_boundary)
			if is_multipart_body then
				part.header.content_type.parameters.search (parameter_name_boundary)
				is_multipart_body := part.header.content_type.parameters.found
				if is_multipart_body then
					save_boundary := boundary
					boundary := "--" + part.header.content_type.parameters.found_item.value
					is_multipart_body := boundary.count <= Max_rfc_2046_boundary_length + 2
				end
			end

			if is_multipart_body then
				-- Some overflow test here in `level'?
				level := level + 1
				save_part := part
				multipart_body ?= save_part.body
				forward_to_boundary
				-- Because we call ourselves recursively, we have to be
				-- very careful that state is correctly saved.
				from
				until
					end_of_file or else
					end_of_input or else
					boundary_with_trailer_read
				loop
					part := multipart_body.new_part
					inner_parse
				end
				boundary_with_trailer_read := False
				level := level - 1
				part := save_part
				if save_boundary /= Void and then boundary /= save_boundary then
					-- boundary changed (multipart in multipart), move
					-- forward to boundary, that's the end of the multipart
					-- in side the multipart.
					boundary := save_boundary
					forward_to_boundary
				end
			else
				-- We get here to read a body which ends with end_of_input or
				-- a mime boundary. Make sure we have a single part body.
				part.clear_body
				part.create_singlepart_body
				read_singlepart_body (part.header.content_transfer_encoding)
			end

			if
				not syntax_error and then
				parse_headers_after_chunk and then
				not buf.chunk_encoding_error
			then
				-- trailer can follow, parse it as well and append the fields
				buf.read_headers_after_chunk
				read_character
				if not end_of_input then
					less (0)
					set_start_condition (INITIAL)
					do_parse
				end
			end

			if
				parse_headers_after_chunk and then
				buf.chunk_encoding_error
			then
				error_count := error_count + 1
				abort
			end
		end

	parse_header is
			-- Read just the MIME header from the input and build a new
			-- `part'.  Check `syntax_error' for parsing errors.
		local
			buf: EPX_MIME_BUFFER
		do
			buf ?= input_buffer
			if buf /= Void then
				buf.set_end_of_file_on_end_of_header (True)
			end
			part := new_part
			reset_parsing_errors
			set_start_condition (INITIAL)
			do_parse
		end

	set_header (a_header: STRING) is
			-- Optional header that is parsed before the regular input
			-- is parsed.
		require
			a_header_not_empty: a_header /= Void and then not a_header.is_empty
		local
			string_buffer: YY_BUFFER
		do
			regular_buffer := input_buffer
			create string_buffer.make (a_header)
			set_input_buffer (string_buffer)
		end

	parsing_errors: INTEGER
			-- Number of errors encountered when parsing.


feature {NONE} -- Parse

	inner_parse is
			-- Read input and build `part'.
			-- To be called from inside `parse_body'.
		require
			part_not_void: part /= Void
		do
			set_start_condition (INITIAL)
			do_parse
			if not syntax_error then
				parse_body
			end
		end


feature {NONE} -- Error reporting

	report_error (a_message: STRING) is
			-- Dump error to stderr. Needs to be rewritten.
		do
			debug ("mime")
				std.error.put_string ("line ")
				std.error.put_integer (line)
				std.error.put_string (", ")
				std.error.put_integer (column)
				std.error.put_string (": ")
				std.error.put_string (a_message)
				std.error.put_character ('%N')
				std.error.put_string ("  text: %"")
				if last_string_value /= Void then
					std.error.put_string (last_string_value.out)
				end
				std.error.put_string ("%" (")
				std.error.put_string (text)
				std.error.put_string (")%N")
				std.error.put_string ("  token: ")
				std.error.put_integer (last_token)
				std.error.put_character ('%N')

				--exit_with_failure
				exceptions.raise ("problem")
			end
			parsing_errors := parsing_errors + 1
		end


feature -- Access

	read_first_body_part is
			-- First part of the body, if any, if `parse_header' has been
			-- used;
			-- Even if only the header is parsed using `parse_header',
			-- the first part of the body is still read by the parser's
			-- buffer as it doesn't know it's part of the body at that
			-- time. Use this to retrieve the first part of the body, the
			-- rest of the body can be read from the stream the usual
			-- way.
		require
			not_end_of_input: not end_of_input
			no_body: part.body = Void
		local
			body: EPX_MIME_BODY_TEXT
		do
			part.clear_body
			part.create_singlepart_body
			body ?= part.body
			read_cached_characters
			body.append_string (last_string)
		end

	part: EPX_MIME_PART
			-- Structure we're building


feature {NONE} -- State used during parsing

	seconds,
	minutes,
	hours: INTEGER

	level: INTEGER

	my_content_disposition: EPX_MIME_FIELD_CONTENT_DISPOSITION

	my_content_type: EPX_MIME_FIELD_CONTENT_TYPE

	my_set_cookie: EPX_MIME_FIELD_SET_COOKIE

	my_transfer_encoding: EPX_MIME_FIELD_TRANSFER_ENCODING

	my_www_authenticate: EPX_MIME_FIELD_WWW_AUTHENTICATE

	my_date: STDC_TIME

	my_time: STDC_TIME

	my_year: INTEGER

	current_parameter_field: EPX_MIME_FIELD_WITH_PARAMETERS


feature {NONE} -- Reading MIME bodies

	boundary: STRING
			-- For multipart MIME messages, it designates the end of a body.

	boundary_with_trailer_read: BOOLEAN

	determine_boundary_with_trailer_read is
			-- There was a boundary match, determine if two dashes follow
			-- (last boundary) and set `boundary_with_trailer_read' in that case.
		do
			-- NOTE: we've already read one character.
			boundary_with_trailer_read := last_character = '-'
			if boundary_with_trailer_read then
				read_character
				boundary_with_trailer_read := last_character = '-'
			end
		end

	forward_to_boundary is
			-- Move input cursor to line that contains `boundary'.
			-- Assume we start reading at beginning of a line.
		require
			boundary_not_empty: boundary /= Void and then not boundary.is_empty
		local
			boundary_read: BOOLEAN
			matching_boundary: BOOLEAN
			matched_index: INTEGER
			match: BOOLEAN
		do
			from
				matching_boundary := True
				matched_index := 1
				read_character
			until
				end_of_input or else
				boundary_read
			loop
				if last_character = '%N' then
					-- Start matching beginning of boundary
					matching_boundary := True
					matched_index := 1
				else
					if matching_boundary then
						match := boundary.item (matched_index) = last_character
						if match then
							-- Match found, advance to next character.
							matched_index := matched_index + 1
							boundary_read := matched_index > boundary.count
						else
							-- Mismatch. As boundary has to match only at
							-- beginning of line, we just have a data line.
							matching_boundary := False
						end
					end
				end
				read_character
			end

			if boundary_read then
				determine_boundary_with_trailer_read
			end
			forward_to_end_of_line
		end

	forward_to_end_of_line is
			-- Always move cursor to next line.
		do
			from
			until
				end_of_input or else
				last_character = '%N'
			loop
				read_character
			end
		ensure
			cursor_at_new_line: end_of_input or else last_character = '%N'
		end

	is_text_body: BOOLEAN is
			-- Does part.body contain text?
		local
			text_body: EPX_MIME_BODY_TEXT
		do
			text_body ?= part.body
			Result := text_body /= Void
		end

	last_line: STRING
			-- Last read line while reading multipart bodies

	Max_rfc_2046_boundary_length: INTEGER is 70
			-- Max length of a boundary according to RFC 2046

	new_part: EPX_MIME_PART is
			-- A new MIME part
		do
			create Result.make_empty
		ensure
			not_void: Result /= Void
		end

	read_singlepart_body (encoding: EPX_MIME_FIELD_CONTENT_TRANSFER_ENCODING) is
			-- Read from input until end of file is reached or a line
			-- contains `boundary'.
		require
			body_not_void: part.body /= Void
			body_is_single_part: not part.body.is_multipart
		local
			body: EPX_MIME_BODY_TEXT
		do
			if boundary = Void then
				read_singlepart_body_without_boundary
			else
				read_singlepart_body_with_boundary
			end
			if encoding /= Void then
				body ?= part.body
				if body /= Void then
					body.set_decoder (encoding.new_decoder)
				end
			end
		end

	read_singlepart_body_with_boundary is
			-- Start reading a single part. This routine has to do two
			-- things right: it has to stop when a boundary has been
			-- parsed, and the cr+lf before the boundary is not part of
			-- the file.
		require
			boundary_is_set: boundary /= Void
			has_buffer: last_line /= Void
			body_contains_text: is_text_body
		local
			boundary_read: BOOLEAN
			matched_index: INTEGER
			match: BOOLEAN
			c: CHARACTER
			matching_boundary: BOOLEAN
			body: EPX_MIME_BODY_TEXT
			add_cr: BOOLEAN
		do
			body ?= part.body
			-- This loop reads data character by character.
			-- We have to stop when a boundary occurs after a CRLF.
			from
				matching_boundary := True
				STRING_.wipe_out (last_line)
				matched_index := 1
				read_character
			invariant
				matched_index >= 1
				not boundary_read implies matched_index <= boundary.count
				matching_boundary implies matched_index <= last_line.count + 1
			until
				end_of_input or else
				boundary_read
			loop

				-- `c' contains the current character
				c := last_character

				inspect c
				when '%R' then
					-- when a CR is encountered, we've to check for a LF to
					-- know if this is an end of line or an incidental CR
					-- (pure data)
					last_line.append_character (c)
				when '%N' then
					-- the next line could contain the boundary so we don't
					-- write the (CR)LF, but keep it in `last_line'. The
					-- CRLF is part of the boundary in that case, not of
					-- the message.
					if last_line.count > 0 and then
						last_line.item (last_line.count) = '%R' then
						-- at this point a CRLF has been read
						last_line.remove (last_line.count)
						add_cr := True
					else
						add_cr := False
					end
					body.append_string (last_line)
					STRING_.wipe_out (last_line)
					if add_cr then
						last_line.append_character ('%R')
					end
					last_line.append_character (c)
					matched_index := 1
					matching_boundary := True
				else
					if matching_boundary then
						match := boundary.item (matched_index) = c
						if match then
							-- Match found, advance to next character.
							last_line.append_character (c)
							matched_index := matched_index + 1
							boundary_read := matched_index > boundary.count
						else
							-- Mismatch. As boundary has to match only at
							-- beginning of line, we just have a data line.
							body.append_string (last_line)
							body.append_character (c)
							STRING_.wipe_out (last_line)
							matching_boundary := False
						end
					else
						body.append_string (last_line)
						body.append_character (c)
						STRING_.wipe_out (last_line)
					end
				end

				-- very expensive check
					check
						-- last_line.has_substring (boundary) implies boundary_read
					end

				read_character
			end

			-- if boundary read, skip rest of line
			if boundary_read then
				determine_boundary_with_trailer_read
			end
			forward_to_end_of_line

				check
					stop_condition: boundary_read or end_of_input
				end
		end

	last_string: STRING
			-- Set by `read_string'

	read_cached_characters is
			-- Copy any characters in the input buffer to `last_string'.
			-- As this function is for performance reasons only, we no
			-- longer track line numbers etc.
		local
			c: CHARACTER
		do
			if last_string = Void then
				create last_string.make (8192)
			else
				STRING_.wipe_out (last_string)
			end
			if yy_content_area /= Void then
				from
					c := yy_content_area.item (yy_end)
				until
					yy_end > input_buffer.count
				loop
					last_string.append_character (c)
					yy_end := yy_end + 1
					c := yy_content_area.item (yy_end)
				end
			else
				from
					c := yy_content.item (yy_end)
				until
					yy_end > input_buffer.count
				loop
					last_string.append_character (c)
					yy_end := yy_end + 1
					c := yy_content.item (yy_end)
				end
			end
		ensure
			last_string_not_void: last_string /= Void
		end

	read_string is
			-- Optimized version of `read_character' which returns as many
			-- characters as possible in `last_string'.
		require
			not_end_of_input: not end_of_input
		do
			read_cached_characters
			if last_string.is_empty then
				read_character
				if not end_of_input then
					last_string.append_character (last_character)
				end
			else
				yy_position := yy_position + last_string.count
				input_buffer.set_beginning_of_line (yy_column = 1)
			end
		ensure
			last_string_not_void: last_string /= Void
			at_least_one_character: end_of_input = last_string.is_empty
		end

	read_singlepart_body_without_boundary is
			-- Read `file' until `end_of_file'. Does handle any line length.
		require
			body_contains_text: is_text_body
		local
			body: EPX_MIME_BODY_TEXT
		do
			if not end_of_input then
				body ?= part.body
				from
					read_string
				until
					end_of_input
				loop
					body.append_string (last_string)
					read_string
				end
			end
		ensure
			read_everything: end_of_input
		end


invariant

	last_line_not_void: last_line /= Void
	my_date_not_void: my_date /= Void
	my_date_in_utc: my_date.is_utc_time
	my_time_not_void: my_time /= Void
	my_time_in_utc: my_time.is_utc_time

end
