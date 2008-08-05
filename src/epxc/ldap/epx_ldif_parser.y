%{
indexing

	description: "Parser for the LDAP Data Interchange Format."

	standards: "RFC 2849"

	not_implemented: "loading resources from a url."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_LDIF_PARSER


inherit

	YY_PARSER_SKELETON
		rename
			make as make_parser
		end

	EPX_LDIF_SCANNER
		rename
			make as make_scanner
		end


creation

	make,
	make_from_stream


%}

-- keywords (known AttributeTypes)
%token CHANGETYPE_COLON CONTROL_COLON DN VERSION_COLON

-- all other AttributeTypes
%token <STRING> ATTRIBUTE_TYPE

-- AttributeType options
%token <STRING> OPTION

-- changetype keywords
%token ADD DELETE MODIFY MODRDN MODDN

-- change-moddn keywords
%token ADD_COLON DELETE_COLON REPLACE_COLON

-- numbers
%token <INTEGER> DIGITS

-- strings
%token <STRING> SAFE_STRING

-- characters
%token SPACES SEP

-- types
%type <EPX_LDIF_ATTRIBUTE_DESCRIPTION> AttributeDescription
%type <STRING> AttributeType
%type <EPX_LDIF_ATTRIBUTE> attrval_spec
%type <STRING> base64_distinguishedName
%type <STRING> base64_rdn
%type <STRING> base64_string
%type <STRING> base64_utf8_string
%type <DS_LINKABLE[EPX_LDIF_ATTRIBUTE]> change_add
%type <DS_LINKABLE[EPX_LDIF_MOD_SPEC]> change_modify
%type <STRING> distinguished_name
%type <STRING> distinguishedName
%type <STRING> dn_spec
%type <EPX_LDIF_ENTRY> ldif_change_record
%type <EPX_LDIF_MOD_SPEC> mod_spec
%type <INTEGER> mod_spec_operation
%type <DS_LINKABLE[EPX_LDIF_ATTRIBUTE]> one_or_more_attrval_specs
%type <DS_LINKABLE[EPX_LDIF_MOD_SPEC]> one_or_more_mod_specs
%type <STRING> optional_base64_string
%type <BOOLEAN> optional_criticality
%type <DS_LINKABLE[STRING]> optional_options
%type <STRING> optional_safe_string
%type <INTEGER> optional_version_spec
%type <DS_LINKABLE[STRING]> options
%type <STRING> rdn
%type <BOOLEAN> true_or_false
%type <STRING> value_spec
%type <INTEGER> version_spec
%type <INTEGER> version_number
%type <BOOLEAN> zero_or_one
%type <DS_LINKABLE[EPX_LDIF_MOD_SPEC]> zero_or_more_mod_specs
%type <DS_LINKABLE[EPX_LDIF_ATTRIBUTE]> zero_or_more_attrval_specs

%start ldif_file

%%
-------------------------------------------------------------------------------

ldif_file
	: ldif_content
	| ldif_changes
	;

ldif_content
	: optional_version_spec one_or_more_sep_ldif_attrval_records
	;

ldif_changes
	: optional_version_spec one_or_more_sep_ldif_change_records
	;

one_or_more_sep_ldif_attrval_records
	: seps_plus_ldif_attrval_record
	| seps_plus_ldif_attrval_record one_or_more_sep_ldif_attrval_records
	;

seps_plus_ldif_attrval_record
	: zero_or_more_seps ldif_attrval_record
	;

zero_or_more_seps
	: -- no seps
	| one_or_more_seps
	;

one_or_more_seps
	: SEP
	| SEP one_or_more_seps
	;

ldif_attrval_record
	: dn_spec SEP one_or_more_attrval_specs { attrval_record ($1) }
	;

zero_or_more_attrval_specs
	: -- none
	| one_or_more_attrval_specs { $$ := $1 }
	;

one_or_more_attrval_specs
	: attrval_spec { create $$.make ($1) }
	| attrval_spec one_or_more_attrval_specs { create $$.make ($1); $$.put_right ($2) }
	;

one_or_more_sep_ldif_change_records
	: seps_plus_ldif_change_record
	| seps_plus_ldif_change_record one_or_more_sep_ldif_change_records
	;

seps_plus_ldif_change_record
	: zero_or_more_seps ldif_change_record
	;

-- changerecord is inlined, avoids annoying type casting
ldif_change_record
	: dn_spec SEP optional_controls CHANGETYPE_COLON FILL change_add { create $$.make_from_linkables ($1, $3, $6); add_record ($$) }
	| dn_spec SEP optional_controls CHANGETYPE_COLON FILL change_delete
	| dn_spec SEP optional_controls CHANGETYPE_COLON FILL change_modify { change_record  ($1, $6) }
	| dn_spec SEP optional_controls CHANGETYPE_COLON FILL change_moddn
	;

optional_controls
	: -- optional
	| controls
	;

controls
	: control
	| control controls
	;

optional_version_spec
	: { $$ := 1 } -- no version
	| version_spec { $$ := $1 } SEP
	;

version_spec
	: VERSION_COLON FILL version_number
		{ $$ := $3 }
	;

version_number
	: DIGITS
		{ $$ := $1 }
	;

dn_spec
	: DN distinguished_name { $$ := $2 }
	;

distinguished_name
	: FILL distinguishedName { $$ := $2 }
	| ':' FILL base64_distinguishedName { $$ := $3 }
	;

distinguishedName
	: SAFE_STRING { $$ := $1 }
	;

base64_distinguishedName
	: base64_utf8_string { $$ := $1 }
	;

rdn
	: SAFE_STRING { $$ := $1 }
	;

base64_rdn
	: BASE64_UTF8_STRING { $$ := $1 }
	;

control
	: CONTROL_COLON FILL ldap_oid optional_criticality optional_control_value SEP
	;

optional_criticality
	: -- optional
	| SPACES true_or_false { $$ := $2 }
	;

optional_control_value
	: -- optional
	| value_spec
	;

ldap_oid
	: DIGITS
	| DIGITS '.' ldap_oid
	;

attrval_spec
	: AttributeDescription value_spec SEP { create $$.make ($1.attribute_type, $1.options, $2) }
	;

value_spec
	: ':' FILL optional_safe_string { $$ := $3 }
	| ':' ':' FILL optional_base64_string { $$ := $4 }
	| ':' '<' FILL url
	;

optional_safe_string
	: -- empty
	| SAFE_STRING { $$ := $1 }
	;

url
	: SAFE_STRING -- TODO: is url
	;

AttributeDescription
	: AttributeType optional_options { create $$.make ($1, $2) }
	;

AttributeType
	: ldap_oid
	| ATTRIBUTE_TYPE { $$ := $1 }
	;

optional_options
	: -- empty
	| ';' options { $$ := $2 }
	;

options
	: OPTION { create $$.make ($1) }
	| OPTION ';' options { create $$.make ($1); $$.put_right ($3) }
	;

-- changerecord
-- 	: CHANGETYPE_COLON FILL change_add
-- 	| CHANGETYPE_COLON FILL change_delete
-- 	| CHANGETYPE_COLON FILL change_modify
-- 	| CHANGETYPE_COLON FILL change_moddn
-- 	;

change_add
	: ADD SEP one_or_more_attrval_specs { $$ := $3 }
	;

change_delete
	: DELETE SEP
	;

change_moddn
	: modrdn_or_moddn SEP newrdn rdn_spec SEP deleteoldrdn FILL zero_or_one SEP optional_newsuperior
	;

modrdn_or_moddn
	: MODRDN
	| MODDN
	;

newrdn
	: ATTRIBUTE_TYPE ':'
		{
			if not STRING_.same_string ($1, "newrdn") then
				 report_error ("newrdn expected instead of " + $1)
				 abort
			end
		}
	;

deleteoldrdn
	: ATTRIBUTE_TYPE ':'
		{
			if not STRING_.same_string ($1, "deleteoldrdn") then
				 report_error ("deleteoldrdn expected instead of " + $1)
				 abort
			end
		}
	;

zero_or_one
	: SAFE_STRING -- error if not '0' or '1'
		{
			if STRING_.same_string ($1, "1") then
				 $$ := True
			elseif STRING_.same_string ($1, "0") then
				$$ := False
			else
				 report_error ("0 or 1 expected instead of " + $1)
				 abort
			end
		}
	;

rdn_spec
	: FILL rdn
	| ':' FILL base64_rdn
	;

optional_newsuperior
	: -- none
	| ATTRIBUTE_TYPE distinguished_name SEP
		{
			if not STRING_.same_string ($1, "newsuperior") then
				 report_error ("newsuperior expected instead of " + $1)
				 abort
			end
		}
	;

change_modify
	: MODIFY SEP zero_or_more_mod_specs { $$ := $3 }
	;

zero_or_more_mod_specs
	: -- none
	| one_or_more_mod_specs { $$ := $1 }
	;

one_or_more_mod_specs
	: mod_spec { create $$.make ($1) }
	| mod_spec one_or_more_mod_specs { create $$.make ($1); $$.put_right ($2) }
	;

mod_spec
	: mod_spec_operation FILL AttributeDescription SEP zero_or_more_attrval_specs '-' SEP { create $$.make ($1, $3, $5) }
	;

mod_spec_operation
	: ADD_COLON { $$ := 1 }
	| DELETE_COLON { $$ := 2 }
	| REPLACE_COLON { $$ := 3 }
	;

FILL
	: -- optional
	| SPACES
	;

base64_utf8_string
	: base64_string { $$ := $1 }
	;

optional_base64_string
	: -- empty
	| base64_string { $$ := $1 }
	;

base64_string
	: SAFE_STRING {$$ := $1 } -- must error if not [\x2b\x2f\x30-\x39\x3d\x41-\x5a\x61-\x7a]; also leave encoded for now
	;

true_or_false
	: ATTRIBUTE_TYPE -- error if not equal to "true" or "false"
		{
			if STRING_.same_string ($1, "true") then
				 $$ := True
			elseif STRING_.same_string ($1, "false") then
				$$ := False
			else
				 report_error ("true or false expected")
				 abort
			end
		}
	;

-------------------------------------------------------------------------------
%%

feature -- Initialization

	make is
			-- Parse server response into `a_response'.
		do
			make_scanner
			make_parser
		end

	make_from_stream (a_stream: EPX_CHARACTER_INPUT_STREAM) is
				 -- Prepare for parsing stream.
		require
			stream_not_void: a_stream /= Void
			stream_open: a_stream.is_open_read
		local
			 buffer: EPX_LDIF_BUFFER
		do
			 make
			 create buffer.make (a_stream)
			 set_input_buffer (buffer)
		end


feature {NONE} -- Callbacks

	attrval_record (distinguished_name: STRING) is
		do
		end

	add_record (an_entry: EPX_LDIF_ENTRY) is
		require
			entry_not_void: an_entry /= Void
		do
		end

	change_record (a_distinguished_name: STRING; a_mod_specs: DS_LINKABLE [EPX_LDIF_MOD_SPEC]) is
		require
			a_distinguished_name_not_empty: a_distinguished_name /= Void and then not a_distinguished_name.is_empty
		do
		end


feature {NONE} -- Implementation

	decode_base64_string (a_base64_string: STRING): STRING is
		local
			string_stream: KL_STRING_INPUT_STREAM
			base64_stream: UT_BASE64_DECODING_INPUT_STREAM
		do
			create string_stream.make (a_base64_string)
			create base64_stream.make (string_stream)
			base64_stream.read_string (a_base64_string.count)
			Result := base64_stream.last_string
		ensure
			result_not_void: Result /= Void
		end


end
