%{
indexing

	description: "Scanner for the LDAP Data Interchange Format."

	standards: "RFC 2849"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_LDIF_SCANNER

inherit

	YY_COMPRESSED_SCANNER_SKELETON

	EPX_LDIF_TOKENS
		export
			{NONE} all
		end

	UT_CHARACTER_CODES
		export
			{NONE} all
		end

%}

%option outfile="epx_ldif_scanner.e"
--%option nocase-sensitive
%option line
%option nodefault

%x COMMENT
%x VERSION VALUE_SPEC CHANGETYPE OPTIONS

-- Definitions

%%
-------------------------------------------------------------------------------

----------/** comments **/-----------------------------------------------------

<*>^"#"[^\n]*\n   -- eat comment


----------/** handle FILL (spaces) in every state **/--------------------------

<*>[ ]+           last_token := SPACES


----------/** tokens **/-------------------------------------------------------

-- separators
"\n"+          |
("\r\n")+      last_token := SEP

-- a '-' is used to separate mod-spec entries, can't occur otherwise
"-"            last_token := Minus_code; in_modify := True

-- known attribute types
"changetype:"  last_token := CHANGETYPE_COLON; set_start_condition (CHANGETYPE)
"control:"     last_token := CONTROL_COLON
"dn:"          last_token := DN; set_start_condition (VALUE_SPEC); in_modify :=  False
-- perhaps handle version specially only on first line??
"version:"     last_token := VERSION_COLON; set_start_condition (VERSION)

-- handle changetype modify parts if they were attribute types
"add:"         conditional_modify_token (ADD_COLON)
"delete:"      conditional_modify_token (DELETE_COLON)
"replace:"     conditional_modify_token (REPLACE_COLON)

-- unknown attribute types
[A-Za-z][A-Za-z0-9\-]* last_token := ATTRIBUTE_TYPE; create last_string_value.make_from_string (text)

-- AttributeType options
";"            last_token := Semicolon_code; set_start_condition (OPTIONS)

-- end of AttributeType
":"            last_token := Colon_code; set_start_condition (VALUE_SPEC)

-- ldap_oid
[0-9]+         last_token := DIGITS; last_integer_value := text.to_integer
"."            last_token := Dot_code

----------/** change type tokens **/-------------------------------------------

<CHANGETYPE>"add"        last_token := ADD; set_start_condition (VALUE_SPEC)
<CHANGETYPE>"delete"     last_token := DELETE; set_start_condition (VALUE_SPEC)
<CHANGETYPE>"modify"     last_token := MODIFY; set_start_condition (INITIAL); in_modify := True
<CHANGETYPE>"modrdn"     last_token := MODRDN; set_start_condition (INITIAL)
<CHANGETYPE>"moddn"      last_token := MODDN; set_start_condition (INITIAL)
<CHANGETYPE>"\n"         |
<CHANGETYPE>"\r\n"       last_token := SEP; set_start_condition (INITIAL)


----------/** version **/------------------------------------------------------

<VERSION>"\n"           |
<VERSION>"\r\n"         last_token := SEP; set_start_condition (INITIAL)
<VERSION>[0-9]+         last_token := DIGITS; last_integer_value := text.to_integer
<VERSION>.              fatal_error ("version number expected.%N")


----------/** value-spec **/---------------------------------------------------

-- Handle multiple SEPs as one, if we do that handling multiple SEPs
-- at end of file (blank lines) are not a problem any more. According
-- to the spec this is forbidden, but it occurs of course.
<VALUE_SPEC>"\n"+         |
<VALUE_SPEC>("\r\n")+     last_token := SEP; set_start_condition (INITIAL)

-- start of base 64 string
<VALUE_SPEC>":"            last_token := Colon_code

-- start of resource to be loaded from url
<VALUE_SPEC>"<"            last_token := Less_than_code

-- first character:
--   any value <= 127 except NUL, LF, CR,
--   SPACE, colon (":", ASCII 58 decimal)
--   and less-than ("<" , ASCII 60 decimal)
-- following characters:
--   any value <= 127 decimal except NUL, LF,
--   and CR
<VALUE_SPEC>[\x01-\x09\x0b-\x0c\x0e-\x1f\x21-\x39\x3b\x3d-\x7f][\x01-\x09\x0b-\x0c\x0e-\x7f]* { last_token := SAFE_STRING; last_string_value := text }

-- this one shouldn't happen...
--<VALUE_SPEC>.  last_token := text_item (1).code


----------/** options **/------------------------------------------------------

<OPTIONS>";"             last_token := Semicolon_code
<OPTIONS>[A-Za-z0-9-]+   last_token := OPTION; last_string_value := text
<OPTIONS>":"             last_token := Colon_code; set_start_condition (VALUE_SPEC)

-------------------------------------------------------------------------------

%%

feature {NONE} -- Implementation

	conditional_modify_token (a_token: INTEGER) is
			-- Within changetype modify we need to handle an "add:"
			-- AttributeType specially. As it seems that objects can have
			-- an AttributeType "add", we need to do it such that we
			-- parse it only at the point where it actually can occur,
			-- and not in other cases.
		do
			if in_modify then
				last_token := a_token
				in_modify := False
			else
				unread_character (':')
				last_token := ATTRIBUTE_TYPE
				last_string_value := text
			end
		ensure
			no_longer_in_modify: not in_modify
		end

	in_modify: BOOLEAN
			-- Are we parsing a change record with changetype = "modify"?

	value_spec_string: STRING
			-- String build during state VALUE_SPEC

end
