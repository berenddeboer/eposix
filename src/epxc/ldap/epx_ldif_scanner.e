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


feature -- Status report

	valid_start_condition (sc: INTEGER): BOOLEAN is
			-- Is `sc' a valid start condition?
		do
			Result := (INITIAL <= sc and sc <= OPTIONS)
		end

feature {NONE} -- Implementation

	yy_build_tables is
			-- Build scanner tables.
		do
			yy_nxt := yy_nxt_template
			yy_chk := yy_chk_template
			yy_base := yy_base_template
			yy_def := yy_def_template
			yy_ec := yy_ec_template
			yy_meta := yy_meta_template
			yy_accept := yy_accept_template
		end

	yy_execute_action (yy_act: INTEGER) is
			-- Execute semantic action.
		do
if yy_act <= 19 then
if yy_act <= 10 then
if yy_act <= 5 then
if yy_act <= 3 then
if yy_act <= 2 then
if yy_act = 1 then
	yy_line := yy_line + 1
	yy_column := 1
--|#line 48 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 48")
end
-- eat comment
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 53 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 53")
end
last_token := SPACES
end
else
yy_set_line (0)
--|#line 59 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 59")
end
last_token := SEP
end
else
if yy_act = 4 then
yy_set_line (0)
--|#line 60 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 60")
end
last_token := SEP
else
	yy_column := yy_column + 1
--|#line 63 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 63")
end
last_token := Minus_code; in_modify := True
end
end
else
if yy_act <= 8 then
if yy_act <= 7 then
if yy_act = 6 then
	yy_column := yy_column + 11
--|#line 66 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 66")
end
last_token := CHANGETYPE_COLON; set_start_condition (CHANGETYPE)
else
	yy_column := yy_column + 8
--|#line 67 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 67")
end
last_token := CONTROL_COLON
end
else
	yy_column := yy_column + 3
--|#line 68 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 68")
end
last_token := DN; set_start_condition (VALUE_SPEC); in_modify :=  False
end
else
if yy_act = 9 then
	yy_column := yy_column + 8
--|#line 70 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 70")
end
last_token := VERSION_COLON; set_start_condition (VERSION)
else
	yy_column := yy_column + 4
--|#line 73 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 73")
end
conditional_modify_token (ADD_COLON)
end
end
end
else
if yy_act <= 15 then
if yy_act <= 13 then
if yy_act <= 12 then
if yy_act = 11 then
	yy_column := yy_column + 7
--|#line 74 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 74")
end
conditional_modify_token (DELETE_COLON)
else
	yy_column := yy_column + 8
--|#line 75 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 75")
end
conditional_modify_token (REPLACE_COLON)
end
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 78 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 78")
end
last_token := ATTRIBUTE_TYPE; create last_string_value.make_from_string (text)
end
else
if yy_act = 14 then
	yy_column := yy_column + 1
--|#line 81 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 81")
end
last_token := Semicolon_code; set_start_condition (OPTIONS)
else
	yy_column := yy_column + 1
--|#line 84 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 84")
end
last_token := Colon_code; set_start_condition (VALUE_SPEC)
end
end
else
if yy_act <= 17 then
if yy_act = 16 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 87 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 87")
end
last_token := DIGITS; last_integer_value := text.to_integer
else
	yy_column := yy_column + 1
--|#line 88 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 88")
end
last_token := Dot_code
end
else
if yy_act = 18 then
	yy_column := yy_column + 3
--|#line 92 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 92")
end
last_token := ADD; set_start_condition (VALUE_SPEC)
else
	yy_column := yy_column + 6
--|#line 93 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 93")
end
last_token := DELETE; set_start_condition (VALUE_SPEC)
end
end
end
end
else
if yy_act <= 28 then
if yy_act <= 24 then
if yy_act <= 22 then
if yy_act <= 21 then
if yy_act = 20 then
	yy_column := yy_column + 6
--|#line 94 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 94")
end
last_token := MODIFY; set_start_condition (INITIAL); in_modify := True
else
	yy_column := yy_column + 6
--|#line 95 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 95")
end
last_token := MODRDN; set_start_condition (INITIAL)
end
else
	yy_column := yy_column + 5
--|#line 96 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 96")
end
last_token := MODDN; set_start_condition (INITIAL)
end
else
if yy_act = 23 then
	yy_line := yy_line + 1
	yy_column := 1
--|#line 97 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 97")
end
last_token := SEP; set_start_condition (INITIAL)
else
	yy_line := yy_line + 1
	yy_column := 1
--|#line 98 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 98")
end
last_token := SEP; set_start_condition (INITIAL)
end
end
else
if yy_act <= 26 then
if yy_act = 25 then
	yy_line := yy_line + 1
	yy_column := 1
--|#line 103 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 103")
end
last_token := SEP; set_start_condition (INITIAL)
else
	yy_line := yy_line + 1
	yy_column := 1
--|#line 104 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 104")
end
last_token := SEP; set_start_condition (INITIAL)
end
else
if yy_act = 27 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 105 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 105")
end
last_token := DIGITS; last_integer_value := text.to_integer
else
	yy_column := yy_column + 1
--|#line 106 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 106")
end
fatal_error ("version number expected.%N")
end
end
end
else
if yy_act <= 33 then
if yy_act <= 31 then
if yy_act <= 30 then
if yy_act = 29 then
yy_set_line (0)
--|#line 114 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 114")
end
last_token := SEP; set_start_condition (INITIAL)
else
yy_set_line (0)
--|#line 115 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 115")
end
last_token := SEP; set_start_condition (INITIAL)
end
else
	yy_column := yy_column + 1
--|#line 118 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 118")
end
last_token := Colon_code
end
else
if yy_act = 32 then
	yy_column := yy_column + 1
--|#line 121 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 121")
end
last_token := Less_than_code
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 130 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 130")
end
 last_token := SAFE_STRING; last_string_value := text 
end
end
else
if yy_act <= 35 then
if yy_act = 34 then
	yy_column := yy_column + 1
--|#line 138 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 138")
end
last_token := Semicolon_code
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 139 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 139")
end
last_token := OPTION; last_string_value := text
end
else
if yy_act = 36 then
	yy_column := yy_column + 1
--|#line 140 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 140")
end
last_token := Colon_code; set_start_condition (VALUE_SPEC)
else
yy_set_line_column
--|#line 0 "epx_ldif_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_ldif_scanner.l' at line 0")
end
last_token := yyError_token
fatal_error ("scanner jammed")
end
end
end
end
end
			yy_set_beginning_of_line
		end

	yy_execute_eof_action (yy_sc: INTEGER) is
			-- Execute EOF semantic action.
		do
			terminate
		end

feature {NONE} -- Table templates

	yy_nxt_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,   14,   15,   16,   17,   14,   18,   19,   20,   20,
			   20,   21,   22,   14,   23,   23,   23,   23,   23,   23,
			   24,   25,   26,   23,   23,   23,   23,   23,   23,   23,
			   23,   23,   23,   27,   23,   23,   28,   23,   23,   23,
			   23,   14,   17,   29,   31,   32,   33,   42,   43,   17,
			   34,   34,   34,   31,   32,   33,   35,   63,   62,   34,
			   34,   34,   37,   38,   17,   44,  125,   45,   53,   53,
			   53,   39,   56,   40,   46,   58,  124,   57,   65,   65,
			   65,  123,   59,   53,   53,   53,   65,   65,   65,   63,
			   62,   54,   54,   54,  122,   94,   62,   74,   74,   74,

			   95,   14,   37,   38,   17,   41,   96,  121,  120,  119,
			  118,   39,  117,   40,   14,   14,   14,   14,   14,   30,
			   30,   30,   30,   30,  116,  115,  114,  113,   62,   36,
			   36,   36,   36,   36,   47,   47,   47,   47,   47,  112,
			  111,   14,   42,   43,   17,   29,   62,   62,   62,   62,
			   62,   66,  110,   66,   66,   66,  109,  108,  107,  106,
			   44,  105,   45,   69,   69,   69,   69,   69,  104,   46,
			   14,   14,   14,   17,   14,  103,   14,  102,  101,  100,
			   48,   49,   14,   99,   98,   97,   93,   68,   92,   91,
			   90,   89,   88,   87,   51,   86,   85,   84,   83,   67,

			   63,   82,   81,   80,   79,   78,   77,   76,   52,   75,
			   14,   14,   14,   14,   17,   29,   50,   14,   73,   72,
			   71,   48,   49,   14,   70,   68,   67,   63,   52,   64,
			   63,   61,   60,   55,   52,   51,   50,  126,   17,   29,
			  126,  126,  126,  126,  126,  126,  126,  126,  126,  126,
			  126,   14,   13,  126,  126,  126,  126,  126,  126,  126,
			  126,  126,  126,  126,  126,  126,  126,  126,  126,  126,
			  126,  126,  126,  126,  126,  126,  126,  126,  126,  126,
			  126,  126,  126,  126,  126,  126,  126,  126,  126,  126,
			  126,  126,  126,  126, yy_Dummy>>)
		end

	yy_chk_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    4,    4,    5,    5,    5,    9,    9,    9,
			    5,    5,    5,    6,    6,    6,    6,   41,   41,    6,
			    6,    6,    7,    7,    7,    9,  124,    9,   20,   20,
			   20,    7,   25,    7,    9,   26,  123,   25,   34,   34,
			   34,  119,   26,   53,   53,   53,   65,   65,   65,   69,
			   69,  131,  131,  131,  118,   86,   41,  135,  135,  135,

			   86,    7,    8,    8,    8,    8,   86,  117,  115,  114,
			  110,    8,  109,    8,  127,  127,  127,  127,  127,  128,
			  128,  128,  128,  128,  108,  107,  106,  105,   69,  129,
			  129,  129,  129,  129,  130,  130,  130,  130,  130,  104,
			  102,    8,   10,   10,   10,   10,  132,  132,  132,  132,
			  132,  133,  101,  133,  133,  133,  100,   99,   98,   97,
			   10,   96,   10,  134,  134,  134,  134,  134,   95,   10,
			   11,   11,   11,   11,   11,   94,   11,   93,   92,   91,
			   11,   11,   11,   90,   89,   88,   85,   83,   82,   81,
			   79,   78,   77,   76,   75,   73,   72,   71,   68,   67,

			   62,   61,   60,   59,   58,   57,   56,   55,   52,   51,
			   11,   12,   12,   12,   12,   12,   50,   12,   46,   45,
			   44,   12,   12,   12,   43,   38,   37,   35,   33,   32,
			   29,   28,   27,   24,   17,   16,   15,   13,    3,    2,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,   12,  126,  126,  126,  126,  126,  126,  126,  126,
			  126,  126,  126,  126,  126,  126,  126,  126,  126,  126,
			  126,  126,  126,  126,  126,  126,  126,  126,  126,  126,
			  126,  126,  126,  126,  126,  126,  126,  126,  126,  126,
			  126,  126,  126,  126, yy_Dummy>>)
		end

	yy_base_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,  234,  234,   38,   42,   51,   60,  100,   45,
			  140,  169,  210,  237,  252,  234,  233,  230,  252,  252,
			   60,  252,  252,    0,  211,   46,   52,  209,  208,  228,
			  252,  252,  227,  224,   70,  225,    0,  224,  223,  252,
			  252,   55,  252,  222,  198,  196,  187,    0,  252,  252,
			  214,  206,  204,   75,    0,  185,  186,  175,  176,  192,
			  170,  168,  198,  252,  252,   78,    0,  197,  195,   87,
			  252,  175,  168,  173,    0,  192,  182,  162,  156,  167,
			  252,  161,  154,  185,  252,  163,   73,  252,  160,  151,
			  148,  159,  151,  142,  145,  144,  139,  136,  127,  134,

			  135,  121,  117,  252,  100,   97,   91,   97,  113,   89,
			   80,  252,  252,  252,   70,   97,  252,   96,   83,   49,
			  252,  252,  252,   53,   55,  252,  252,  113,  118,  128,
			  133,   88,  145,  150,  162,   94, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,  126,    1,  127,  127,  128,  128,  129,  129,  127,
			  127,  130,  130,  126,  126,  126,  126,  126,  126,  126,
			  126,  126,  126,  131,  131,  131,  131,  131,  131,  132,
			  126,  126,  126,  126,  126,  132,  133,  126,  126,  126,
			  126,  134,  126,  126,  126,  126,  126,  135,  126,  126,
			  126,  126,  126,  126,  131,  131,  131,  131,  131,  131,
			  131,  131,  132,  126,  126,  126,  133,  126,  126,  134,
			  126,  126,  126,  126,  135,  126,  131,  131,  131,  131,
			  126,  131,  131,  126,  126,  126,  126,  126,  131,  131,
			  131,  131,  131,  126,  126,  126,  126,  131,  131,  131,

			  131,  131,  126,  126,  126,  126,  131,  131,  131,  131,
			  131,  126,  126,  126,  131,  131,  126,  131,  131,  131,
			  126,  126,  126,  131,  131,  126,    0,  126,  126,  126,
			  126,  126,  126,  126,  126,  126, yy_Dummy>>)
		end

	yy_ec_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    2,    1,    1,    3,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    4,    1,    1,    5,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    6,    7,    1,    8,    8,
			    8,    8,    8,    8,    8,    8,    9,   10,   11,   12,
			   13,    1,    1,    1,    1,   14,   14,   14,   14,   14,
			   14,   14,   14,   14,   14,   14,   14,   14,   14,   14,
			   14,   14,   14,   14,   14,   14,   15,   16,   17,   18,
			   19,    1,    1,    1,    1,    1,    1,   20,   14,   21,

			   22,   23,   24,   25,   26,   27,   14,   14,   28,   29,
			   30,   31,   32,   14,   33,   34,   35,   14,   36,   37,
			   38,   39,   40,    1,    1,    1,    1,    1,   41,   41,
			   41,   41,   41,   41,   41,   41,   41,   41,   41,   41,
			   41,   41,   41,   41,   41,   41,   41,   41,   41,   41,
			   41,   41,   41,   41,   41,   41,   41,   41,   41,   41,
			   41,   41,   41,   41,   41,   41,   41,   41,   41,   41,
			   41,   41,   41,   41,   41,   41,   41,   41,   41,   41,
			   41,   41,   41,   41,   41,   41,   41,   41,   41,   41,
			   41,   41,   41,   41,   41,   41,   41,   41,   41,   41,

			   41,   41,   41,   41,   41,   41,   41,   41,   41,   41,
			   41,   41,   41,   41,   41,   41,   41,   41,   41,   41,
			   41,   41,   41,   41,   41,   41,   41,   41,   41,   41,
			   41,   41,   41,   41,   41,   41,   41,   41,   41,   41,
			   41,   41,   41,   41,   41,   41,   41,   41,   41,   41,
			   41,   41,   41,   41,   41,   41,   41, yy_Dummy>>)
		end

	yy_meta_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    2,    2,    1,    1,    3,    1,    3,    4,
			    5,    1,    1,    1,    3,    3,    3,    3,    3,    3,
			    3,    3,    3,    3,    3,    3,    3,    3,    3,    3,
			    3,    3,    3,    3,    3,    3,    3,    3,    3,    3,
			    3,    2, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,   38,   37,    3,   37,    2,    5,   17,
			   16,   15,   14,   13,   13,   13,   13,   13,   13,   37,
			   28,   25,   28,    2,   27,   28,   33,   29,   37,   31,
			   32,   33,   23,   37,   37,   37,   37,   35,   36,   34,
			    3,    4,    2,   16,   13,   13,   13,   13,   13,   13,
			   13,   13,    0,    1,   26,   27,   33,   29,   30,   33,
			   24,    0,    0,    0,   35,    0,   13,   13,   13,   13,
			    8,   13,   13,    0,   18,    0,    0,   10,   13,   13,
			   13,   13,   13,    0,    0,    0,    0,   13,   13,   13,

			   13,   13,    0,   22,    0,    0,   13,   13,   13,   13,
			   13,   19,   20,   21,   13,   13,   11,   13,   13,   13,
			    7,   12,    9,   13,   13,    6,    0, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER is 252
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER is 126
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER is 127
			-- Mark between normal states and templates

	yyNull_equiv_class: INTEGER is 41
			-- Equivalence code for NULL character

	yyReject_used: BOOLEAN is false
			-- Is `reject' called?

	yyVariable_trail_context: BOOLEAN is false
			-- Is there a regular expression with
			-- both leading and trailing parts having
			-- variable length?

	yyReject_or_variable_trail_context: BOOLEAN is false
			-- Is `reject' called or is there a
			-- regular expression with both leading
			-- and trailing parts having variable length?

	yyNb_rules: INTEGER is 37
			-- Number of rules

	yyEnd_of_buffer: INTEGER is 38
			-- End of buffer rule code

	yyLine_used: BOOLEAN is true
			-- Are line and column numbers used?

	yyPosition_used: BOOLEAN is false
			-- Is `position' used?

	INITIAL: INTEGER is 0
	COMMENT: INTEGER is 1
	VERSION: INTEGER is 2
	VALUE_SPEC: INTEGER is 3
	CHANGETYPE: INTEGER is 4
	OPTIONS: INTEGER is 5
			-- Start condition codes

feature -- User-defined features



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
