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


creation

	make,
	make_from_file,
	make_from_stream,
	make_from_string,
	make_from_file_descriptor



feature {NONE} -- Implementation

	yy_build_parser_tables is
			-- Build parser tables.
		do
			yytranslate := yytranslate_template
			yyr1 := yyr1_template
			yytypes1 := yytypes1_template
			yytypes2 := yytypes2_template
			yydefact := yydefact_template
			yydefgoto := yydefgoto_template
			yypact := yypact_template
			yypgoto := yypgoto_template
			yytable := yytable_template
			yycheck := yycheck_template
		end

	yy_create_value_stacks is
			-- Create value stacks.
		do
		end

	yy_init_value_stacks is
			-- Initialize value stacks.
		do
			yyvsp1 := -1
			yyvsp2 := -1
			yyvsp3 := -1
			yyvsp4 := -1
			yyvsp5 := -1
			yyvsp6 := -1
			yyvsp7 := -1
			yyvsp8 := -1
			yyvsp9 := -1
			yyvsp10 := -1
			yyvsp11 := -1
			yyvsp12 := -1
			yyvsp13 := -1
			yyvsp14 := -1
			yyvsp15 := -1
			yyvsp16 := -1
			yyvsp17 := -1
			yyvsp18 := -1
			yyvsp19 := -1
			yyvsp20 := -1
			yyvsp21 := -1
			yyvsp22 := -1
		end

	yy_clear_value_stacks is
			-- Clear objects in semantic value stacks so that
			-- they can be collected by the garbage collector.
		do
			if yyvs1 /= Void then
				yyvs1.clear_all
			end
			if yyvs2 /= Void then
				yyvs2.clear_all
			end
			if yyvs3 /= Void then
				yyvs3.clear_all
			end
			if yyvs4 /= Void then
				yyvs4.clear_all
			end
			if yyvs5 /= Void then
				yyvs5.clear_all
			end
			if yyvs6 /= Void then
				yyvs6.clear_all
			end
			if yyvs7 /= Void then
				yyvs7.clear_all
			end
			if yyvs8 /= Void then
				yyvs8.clear_all
			end
			if yyvs9 /= Void then
				yyvs9.clear_all
			end
			if yyvs10 /= Void then
				yyvs10.clear_all
			end
			if yyvs11 /= Void then
				yyvs11.clear_all
			end
			if yyvs12 /= Void then
				yyvs12.clear_all
			end
			if yyvs13 /= Void then
				yyvs13.clear_all
			end
			if yyvs14 /= Void then
				yyvs14.clear_all
			end
			if yyvs15 /= Void then
				yyvs15.clear_all
			end
			if yyvs16 /= Void then
				yyvs16.clear_all
			end
			if yyvs17 /= Void then
				yyvs17.clear_all
			end
			if yyvs18 /= Void then
				yyvs18.clear_all
			end
			if yyvs19 /= Void then
				yyvs19.clear_all
			end
			if yyvs20 /= Void then
				yyvs20.clear_all
			end
			if yyvs21 /= Void then
				yyvs21.clear_all
			end
			if yyvs22 /= Void then
				yyvs22.clear_all
			end
		end

	yy_push_last_value (yychar1: INTEGER) is
			-- Push semantic value associated with token `last_token'
			-- (with internal id `yychar1') on top of corresponding
			-- value stack.
		do
			inspect yytypes2.item (yychar1)
			when 1 then
				yyvsp1 := yyvsp1 + 1
				if yyvsp1 >= yyvsc1 then
					if yyvs1 = Void then
						debug ("GEYACC")
							std.error.put_line ("Create yyvs1")
						end
						create yyspecial_routines1
						yyvsc1 := yyInitial_yyvs_size
						yyvs1 := yyspecial_routines1.make (yyvsc1)
					else
						debug ("GEYACC")
							std.error.put_line ("Resize yyvs1")
						end
						yyvsc1 := yyvsc1 + yyInitial_yyvs_size
						yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
					end
				end
				yyvs1.put (last_any_value, yyvsp1)
			when 2 then
				yyvsp2 := yyvsp2 + 1
				if yyvsp2 >= yyvsc2 then
					if yyvs2 = Void then
						debug ("GEYACC")
							std.error.put_line ("Create yyvs2")
						end
						create yyspecial_routines2
						yyvsc2 := yyInitial_yyvs_size
						yyvs2 := yyspecial_routines2.make (yyvsc2)
					else
						debug ("GEYACC")
							std.error.put_line ("Resize yyvs2")
						end
						yyvsc2 := yyvsc2 + yyInitial_yyvs_size
						yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
					end
				end
				yyvs2.put (last_string_value, yyvsp2)
			when 3 then
				yyvsp3 := yyvsp3 + 1
				if yyvsp3 >= yyvsc3 then
					if yyvs3 = Void then
						debug ("GEYACC")
							std.error.put_line ("Create yyvs3")
						end
						create yyspecial_routines3
						yyvsc3 := yyInitial_yyvs_size
						yyvs3 := yyspecial_routines3.make (yyvsc3)
					else
						debug ("GEYACC")
							std.error.put_line ("Resize yyvs3")
						end
						yyvsc3 := yyvsc3 + yyInitial_yyvs_size
						yyvs3 := yyspecial_routines3.resize (yyvs3, yyvsc3)
					end
				end
				yyvs3.put (last_integer_value, yyvsp3)
			else
				debug ("GEYACC")
					std.error.put_string ("Error in parser: not a token type: ")
					std.error.put_integer (yytypes2.item (yychar1))
					std.error.put_new_line
				end
				abort
			end
		end

	yy_push_error_value is
			-- Push semantic value associated with token 'error'
			-- on top of corresponding value stack.
		local
			yyval1: ANY
		do
			yyvsp1 := yyvsp1 + 1
			if yyvsp1 >= yyvsc1 then
				if yyvs1 = Void then
					debug ("GEYACC")
						std.error.put_line ("Create yyvs1")
					end
					create yyspecial_routines1
					yyvsc1 := yyInitial_yyvs_size
					yyvs1 := yyspecial_routines1.make (yyvsc1)
				else
					debug ("GEYACC")
						std.error.put_line ("Resize yyvs1")
					end
					yyvsc1 := yyvsc1 + yyInitial_yyvs_size
					yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
				end
			end
			yyvs1.put (yyval1, yyvsp1)
		end

	yy_pop_last_value (yystate: INTEGER) is
			-- Pop semantic value from stack when in state `yystate'.
		local
			yy_type_id: INTEGER
		do
			yy_type_id := yytypes1.item (yystate)
			inspect yy_type_id
			when 1 then
				yyvsp1 := yyvsp1 - 1
			when 2 then
				yyvsp2 := yyvsp2 - 1
			when 3 then
				yyvsp3 := yyvsp3 - 1
			when 4 then
				yyvsp4 := yyvsp4 - 1
			when 5 then
				yyvsp5 := yyvsp5 - 1
			when 6 then
				yyvsp6 := yyvsp6 - 1
			when 7 then
				yyvsp7 := yyvsp7 - 1
			when 8 then
				yyvsp8 := yyvsp8 - 1
			when 9 then
				yyvsp9 := yyvsp9 - 1
			when 10 then
				yyvsp10 := yyvsp10 - 1
			when 11 then
				yyvsp11 := yyvsp11 - 1
			when 12 then
				yyvsp12 := yyvsp12 - 1
			when 13 then
				yyvsp13 := yyvsp13 - 1
			when 14 then
				yyvsp14 := yyvsp14 - 1
			when 15 then
				yyvsp15 := yyvsp15 - 1
			when 16 then
				yyvsp16 := yyvsp16 - 1
			when 17 then
				yyvsp17 := yyvsp17 - 1
			when 18 then
				yyvsp18 := yyvsp18 - 1
			when 19 then
				yyvsp19 := yyvsp19 - 1
			when 20 then
				yyvsp20 := yyvsp20 - 1
			when 21 then
				yyvsp21 := yyvsp21 - 1
			when 22 then
				yyvsp22 := yyvsp22 - 1
			else
				debug ("GEYACC")
					std.error.put_string ("Error in parser: unknown type id: ")
					std.error.put_integer (yy_type_id)
					std.error.put_new_line
				end
				abort
			end
		end

feature {NONE} -- Semantic actions

	yy_do_action (yy_act: INTEGER) is
			-- Execute semantic action.
		local
			yyval1: ANY
			yyval4: EPX_MIME_FIELD
			yyval15: EPX_MIME_FIELD_MAILBOX_LIST
			yyval6: EPX_MIME_FIELD_CONTENT_DISPOSITION
			yyval7: EPX_MIME_FIELD_CONTENT_LENGTH
			yyval8: EPX_MIME_FIELD_CONTENT_TRANSFER_ENCODING
			yyval9: EPX_MIME_FIELD_CONTENT_TYPE
			yyval10: EPX_MIME_FIELD_DATE
			yyval11: EPX_MIME_FIELD_IF_MODIFIED_SINCE
			yyval12: EPX_MIME_FIELD_LAST_MODIFIED
			yyval13: EPX_MIME_FIELD_MESSAGE_ID
			yyval14: EPX_MIME_FIELD_MIME_VERSION
			yyval16: EPX_MIME_FIELD_SET_COOKIE
			yyval17: EPX_MIME_FIELD_TRANSFER_ENCODING
			yyval18: EPX_MIME_FIELD_WWW_AUTHENTICATE
			yyval19: EPX_MIME_MAILBOX
			yyval20: DS_LINKABLE [EPX_MIME_MAILBOX]
			yyval2: STRING
			yyval21: STDC_TIME
			yyval3: INTEGER
			yyval22: EPX_MIME_PARAMETER
			yyval5: EPX_MIME_UNSTRUCTURED_FIELD
		do
			inspect yy_act
when 1 then
--|#line 175 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 175")
end

accept 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 2 then
--|#line 176 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 176")
end

accept 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 3 then
--|#line 181 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 181")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp4 := yyvsp4 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 4 then
--|#line 182 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 182")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 5 then
--|#line 187 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 187")
end

if yyvs4.item (yyvsp4) /= Void then part.header.add_non_unique_field (yyvs4.item (yyvsp4)) end 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs4.put (yyval4, yyvsp4)
end
when 6 then
--|#line 189 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 189")
end

part.header.add_non_unique_field (yyvs5.item (yyvsp5)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 + 1
	yyvsp5 := yyvsp5 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 7 then
--|#line 191 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 191")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs4.put (yyval4, yyvsp4)
end
when 8 then
--|#line 191 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 191")
end

reset_start_condition 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp4 := yyvsp4 + 1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 9 then
--|#line 197 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 197")
end

yyval4 := yyvs15.item (yyvsp15) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp15 := yyvsp15 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 10 then
--|#line 199 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 199")
end

yyval4 := yyvs15.item (yyvsp15) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp15 := yyvsp15 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 11 then
--|#line 201 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 201")
end

yyval4 := yyvs6.item (yyvsp6) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp6 := yyvsp6 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 12 then
--|#line 203 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 203")
end

yyval4 := yyvs7.item (yyvsp7) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp7 := yyvsp7 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 13 then
--|#line 205 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 205")
end

yyval4 := yyvs8.item (yyvsp8) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp8 := yyvsp8 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 14 then
--|#line 207 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 207")
end

yyval4 := yyvs9.item (yyvsp9) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp9 := yyvsp9 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 15 then
--|#line 209 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 209")
end

yyval4 := yyvs10.item (yyvsp10) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp10 := yyvsp10 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 16 then
--|#line 211 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 211")
end

yyval4 := yyvs15.item (yyvsp15) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp15 := yyvsp15 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 17 then
--|#line 213 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 213")
end

yyval4 := yyvs11.item (yyvsp11) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp11 := yyvsp11 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 18 then
--|#line 215 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 215")
end

yyval4 := yyvs12.item (yyvsp12) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp12 := yyvsp12 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 19 then
--|#line 217 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 217")
end

yyval4 := yyvs13.item (yyvsp13) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp13 := yyvsp13 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 20 then
--|#line 219 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 219")
end

yyval4 := yyvs14.item (yyvsp14) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp14 := yyvsp14 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 21 then
--|#line 221 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 221")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 22 then
--|#line 222 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 222")
end

yyval4 := yyvs15.item (yyvsp15) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp15 := yyvsp15 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 23 then
--|#line 224 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 224")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 24 then
--|#line 225 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 225")
end

yyval4 := yyvs15.item (yyvsp15) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp15 := yyvsp15 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 25 then
--|#line 227 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 227")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 26 then
--|#line 228 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 228")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 27 then
--|#line 229 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 229")
end

yyval4 := yyvs16.item (yyvsp16) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp16 := yyvsp16 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 28 then
--|#line 231 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 231")
end

yyval4 := yyvs15.item (yyvsp15) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp15 := yyvsp15 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 29 then
--|#line 233 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 233")
end

yyval4 := yyvs17.item (yyvsp17) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp17 := yyvsp17 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 30 then
--|#line 235 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 235")
end

yyval4 := yyvs18.item (yyvsp18) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp4 := yyvsp4 + 1
	yyvsp18 := yyvsp18 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 31 then
--|#line 243 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 243")
end

			create yyval15.make (field_name_bcc, yyvs20.item (yyvsp20))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp20 := yyvsp20 -1
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 32 then
--|#line 247 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 247")
end

			create yyval15.make (field_name_bcc, Void)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 33 then
--|#line 254 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 254")
end

			create yyval15.make (field_name_cc, yyvs20.item (yyvsp20))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp20 := yyvsp20 -1
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 34 then
--|#line 258 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 258")
end

			create yyval15.make (field_name_cc, Void)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 35 then
--|#line 265 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 265")
end

			yyval6 := my_content_disposition
			my_content_disposition.cleanup_filename_parameter
			current_parameter_field := Void
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
	yyvs6.put (yyval6, yyvsp6)
end
when 36 then
--|#line 265 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 265")
end

			create my_content_disposition.make (yyvs2.item (yyvsp2))
			current_parameter_field := my_content_disposition
			start_parameter
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp6 := yyvsp6 + 1
	if yyvsp6 >= yyvsc6 then
		if yyvs6 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs6")
			end
			create yyspecial_routines6
			yyvsc6 := yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.make (yyvsc6)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs6")
			end
			yyvsc6 := yyvsc6 + yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.resize (yyvs6, yyvsc6)
		end
	end
	yyvs6.put (yyval6, yyvsp6)
end
when 37 then
--|#line 281 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 281")
end

			create yyval7.make (yyvs3.item (yyvsp3))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp7 := yyvsp7 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp3 := yyvsp3 -1
	if yyvsp7 >= yyvsc7 then
		if yyvs7 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs7")
			end
			create yyspecial_routines7
			yyvsc7 := yyInitial_yyvs_size
			yyvs7 := yyspecial_routines7.make (yyvsc7)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs7")
			end
			yyvsc7 := yyvsc7 + yyInitial_yyvs_size
			yyvs7 := yyspecial_routines7.resize (yyvs7, yyvsc7)
		end
	end
	yyvs7.put (yyval7, yyvsp7)
end
when 38 then
--|#line 289 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 289")
end

			create yyval8.make (yyvs2.item (yyvsp2))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp8 := yyvsp8 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp2 := yyvsp2 -1
	if yyvsp8 >= yyvsc8 then
		if yyvs8 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs8")
			end
			create yyspecial_routines8
			yyvsc8 := yyInitial_yyvs_size
			yyvs8 := yyspecial_routines8.make (yyvsc8)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs8")
			end
			yyvsc8 := yyvsc8 + yyInitial_yyvs_size
			yyvs8 := yyspecial_routines8.resize (yyvs8, yyvsc8)
		end
	end
	yyvs8.put (yyval8, yyvsp8)
end
when 39 then
--|#line 297 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 297")
end

			yyval9 := my_content_type
			current_parameter_field := Void
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 7
	yyvsp1 := yyvsp1 -4
	yyvsp2 := yyvsp2 -2
	yyvs9.put (yyval9, yyvsp9)
end
when 40 then
--|#line 297 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 297")
end

			create my_content_type.make (yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2))
			current_parameter_field := my_content_type
			start_parameter
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp9 := yyvsp9 + 1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 41 then
--|#line 313 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 313")
end

			if yyvs21.item (yyvsp21) /= Void then
				create yyval10.make (yyvs21.item (yyvsp21))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -2
	yyvsp21 := yyvsp21 -1
	yyvs10.put (yyval10, yyvsp10)
end
when 42 then
--|#line 313 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 313")
end

expect_date 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp10 := yyvsp10 + 1
	if yyvsp10 >= yyvsc10 then
		if yyvs10 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs10")
			end
			create yyspecial_routines10
			yyvsc10 := yyInitial_yyvs_size
			yyvs10 := yyspecial_routines10.make (yyvsc10)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs10")
			end
			yyvsc10 := yyvsc10 + yyInitial_yyvs_size
			yyvs10 := yyspecial_routines10.resize (yyvs10, yyvsc10)
		end
	end
	yyvs10.put (yyval10, yyvsp10)
end
when 43 then
--|#line 325 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 325")
end

			create yyval15.make (field_name_from, yyvs20.item (yyvsp20))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp20 := yyvsp20 -1
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 44 then
--|#line 332 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 332")
end

			create {EPX_MIME_FIELD_IF_MODIFIED_SINCE} yyval11.make (yyvs21.item (yyvsp21))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -2
	yyvsp21 := yyvsp21 -1
	yyvs11.put (yyval11, yyvsp11)
end
when 45 then
--|#line 332 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 332")
end

expect_date 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp11 := yyvsp11 + 1
	if yyvsp11 >= yyvsc11 then
		if yyvs11 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs11")
			end
			create yyspecial_routines11
			yyvsc11 := yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.make (yyvsc11)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs11")
			end
			yyvsc11 := yyvsc11 + yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.resize (yyvs11, yyvsc11)
		end
	end
	yyvs11.put (yyval11, yyvsp11)
end
when 46 then
--|#line 341 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 341")
end

			create {EPX_MIME_FIELD_LAST_MODIFIED} yyval12.make (yyvs21.item (yyvsp21))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -2
	yyvsp21 := yyvsp21 -1
	yyvs12.put (yyval12, yyvsp12)
end
when 47 then
--|#line 341 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 341")
end

expect_date 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp12 := yyvsp12 + 1
	if yyvsp12 >= yyvsc12 then
		if yyvs12 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs12")
			end
			create yyspecial_routines12
			yyvsc12 := yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.make (yyvsc12)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs12")
			end
			yyvsc12 := yyvsc12 + yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.resize (yyvs12, yyvsc12)
		end
	end
	yyvs12.put (yyval12, yyvsp12)
end
when 48 then
--|#line 350 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 350")
end

create yyval13.make (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp13 := yyvsp13 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp2 := yyvsp2 -1
	if yyvsp13 >= yyvsc13 then
		if yyvs13 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs13")
			end
			create yyspecial_routines13
			yyvsc13 := yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.make (yyvsc13)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs13")
			end
			yyvsc13 := yyvsc13 + yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.resize (yyvs13, yyvsc13)
		end
	end
	yyvs13.put (yyval13, yyvsp13)
end
when 49 then
--|#line 355 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 355")
end

create yyval14.make (yyvs3.item (yyvsp3 - 1), yyvs3.item (yyvsp3)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp14 := yyvsp14 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp3 := yyvsp3 -2
	if yyvsp14 >= yyvsc14 then
		if yyvs14 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs14")
			end
			create yyspecial_routines14
			yyvsc14 := yyInitial_yyvs_size
			yyvs14 := yyspecial_routines14.make (yyvsc14)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs14")
			end
			yyvsc14 := yyvsc14 + yyInitial_yyvs_size
			yyvs14 := yyspecial_routines14.resize (yyvs14, yyvsc14)
		end
	end
	yyvs14.put (yyval14, yyvsp14)
end
when 50 then
--|#line 361 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 361")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 11
	yyvsp1 := yyvsp1 -9
	yyvsp21 := yyvsp21 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 51 then
--|#line 361 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 361")
end

expect_date 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 52 then
--|#line 372 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 372")
end

			create yyval15.make (field_name_resent_from, yyvs20.item (yyvsp20))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp20 := yyvsp20 -1
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 53 then
--|#line 379 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 379")
end

			create yyval15.make (field_name_resent_reply_to, yyvs20.item (yyvsp20))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp20 := yyvsp20 -1
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 54 then
--|#line 386 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 386")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp19 := yyvsp19 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 55 then
--|#line 390 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 390")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs1.put (yyval1, yyvsp1)
end
when 56 then
--|#line 394 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 394")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp19 := yyvsp19 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 57 then
--|#line 398 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 398")
end

			yyval16 := my_set_cookie
			current_parameter_field := Void
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 7
	yyvsp1 := yyvsp1 -4
	yyvsp2 := yyvsp2 -2
	yyvs16.put (yyval16, yyvsp16)
end
when 58 then
--|#line 398 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 398")
end

			create my_set_cookie.make (yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2))
			current_parameter_field := my_set_cookie
			start_parameter
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp16 := yyvsp16 + 1
	if yyvsp16 >= yyvsc16 then
		if yyvs16 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs16")
			end
			create yyspecial_routines16
			yyvsc16 := yyInitial_yyvs_size
			yyvs16 := yyspecial_routines16.make (yyvsc16)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs16")
			end
			yyvsc16 := yyvsc16 + yyInitial_yyvs_size
			yyvs16 := yyspecial_routines16.resize (yyvs16, yyvsc16)
		end
	end
	yyvs16.put (yyval16, yyvsp16)
end
when 59 then
--|#line 414 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 414")
end

			create yyval15.make (field_name_to, yyvs20.item (yyvsp20))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp20 := yyvsp20 -1
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 60 then
--|#line 418 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 418")
end

			create yyval15.make (field_name_to, Void)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 61 then
--|#line 425 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 425")
end

			yyval17 := my_transfer_encoding
			current_parameter_field := Void
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
	yyvs17.put (yyval17, yyvsp17)
end
when 62 then
--|#line 425 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 425")
end

			create my_transfer_encoding.make (yyvs2.item (yyvsp2))
			current_parameter_field := my_transfer_encoding
			start_parameter
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp17 := yyvsp17 + 1
	if yyvsp17 >= yyvsc17 then
		if yyvs17 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs17")
			end
			create yyspecial_routines17
			yyvsc17 := yyInitial_yyvs_size
			yyvs17 := yyspecial_routines17.make (yyvsc17)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs17")
			end
			yyvsc17 := yyvsc17 + yyInitial_yyvs_size
			yyvs17 := yyspecial_routines17.resize (yyvs17, yyvsc17)
		end
	end
	yyvs17.put (yyval17, yyvsp17)
end
when 63 then
--|#line 442 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 442")
end

			yyval18 := my_www_authenticate
			current_parameter_field := Void
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
	yyvs18.put (yyval18, yyvsp18)
end
when 64 then
--|#line 442 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 442")
end

			create my_www_authenticate.make (yyvs2.item (yyvsp2))
			current_parameter_field := my_www_authenticate
			start_parameter
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp18 := yyvsp18 + 1
	if yyvsp18 >= yyvsc18 then
		if yyvs18 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs18")
			end
			create yyspecial_routines18
			yyvsc18 := yyInitial_yyvs_size
			yyvs18 := yyspecial_routines18.make (yyvsc18)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs18")
			end
			yyvsc18 := yyvsc18 + yyInitial_yyvs_size
			yyvs18 := yyspecial_routines18.resize (yyvs18, yyvsc18)
		end
	end
	yyvs18.put (yyval18, yyvsp18)
end
when 65 then
--|#line 461 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 461")
end

yyval19 := yyvs19.item (yyvsp19) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs19.put (yyval19, yyvsp19)
end
when 66 then
--|#line 463 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 463")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp19 := yyvsp19 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp19 >= yyvsc19 then
		if yyvs19 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs19")
			end
			create yyspecial_routines19
			yyvsc19 := yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.make (yyvsc19)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs19")
			end
			yyvsc19 := yyvsc19 + yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.resize (yyvs19, yyvsc19)
		end
	end
	yyvs19.put (yyval19, yyvsp19)
end
when 67 then
--|#line 468 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 468")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp20 := yyvsp20 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp20 >= yyvsc20 then
		if yyvs20 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs20")
			end
			create yyspecial_routines20
			yyvsc20 := yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.make (yyvsc20)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs20")
			end
			yyvsc20 := yyvsc20 + yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.resize (yyvs20, yyvsc20)
		end
	end
	yyvs20.put (yyval20, yyvsp20)
end
when 68 then
--|#line 469 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 469")
end

create yyval20.make (yyvs19.item (yyvsp19)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp20 := yyvsp20 + 1
	yyvsp19 := yyvsp19 -1
	if yyvsp20 >= yyvsc20 then
		if yyvs20 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs20")
			end
			create yyspecial_routines20
			yyvsc20 := yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.make (yyvsc20)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs20")
			end
			yyvsc20 := yyvsc20 + yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.resize (yyvs20, yyvsc20)
		end
	end
	yyvs20.put (yyval20, yyvsp20)
end
when 69 then
--|#line 471 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 471")
end

create yyval20.make (yyvs19.item (yyvsp19)); yyval20.put_right (yyvs20.item (yyvsp20)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp19 := yyvsp19 -1
	yyvsp1 := yyvsp1 -1
	yyvs20.put (yyval20, yyvsp20)
end
when 70 then
--|#line 476 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 476")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 71 then
--|#line 477 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 477")
end

yyval1 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 72 then
--|#line 482 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 482")
end

		create yyval2.make_from_string (yyvs2.item (yyvsp2 - 1))
		yyval2.append_character ('@')
		yyval2.append_string (yyvs2.item (yyvsp2))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -1
	yyvs2.put (yyval2, yyvsp2)
end
when 73 then
--|#line 491 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 491")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs2.put (yyval2, yyvsp2)
end
when 74 then
--|#line 493 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 493")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 75 then
--|#line 498 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 498")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 76 then
--|#line 503 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 503")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 77 then
--|#line 508 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 508")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 78 then
--|#line 514 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 514")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp22 := yyvsp22 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 79 then
--|#line 515 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 515")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp22 := yyvsp22 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 80 then
--|#line 516 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 516")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp22 := yyvsp22 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 81 then
--|#line 522 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 522")
end

yyval21 := yyvs21.item (yyvsp21) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs21.put (yyval21, yyvsp21)
end
when 82 then
--|#line 524 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 524")
end

yyval21 := yyvs21.item (yyvsp21) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs21.put (yyval21, yyvsp21)
end
when 83 then
--|#line 526 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 526")
end

yyval21 := yyvs21.item (yyvsp21) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs21.put (yyval21, yyvsp21)
end
when 84 then
--|#line 531 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 531")
end

			if my_date.is_two_digit_year (yyvs3.item (yyvsp3).item) then
				my_year := my_date.four_digit_year (yyvs3.item (yyvsp3).item)
			else
				my_year := yyvs3.item (yyvsp3).item
			end
			if
				my_date.is_valid_date (my_year, yyvs3.item (yyvsp3 - 1).item, yyvs3.item (yyvsp3 - 2).item)
			then
				my_date.make_utc_date (my_year, yyvs3.item (yyvsp3 - 1).item, yyvs3.item (yyvsp3 - 2).item)
				yyval21 := my_date
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp21 := yyvsp21 + 1
	yyvsp3 := yyvsp3 -3
	if yyvsp21 >= yyvsc21 then
		if yyvs21 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs21")
			end
			create yyspecial_routines21
			yyvsc21 := yyInitial_yyvs_size
			yyvs21 := yyspecial_routines21.make (yyvsc21)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs21")
			end
			yyvsc21 := yyvsc21 + yyInitial_yyvs_size
			yyvs21 := yyspecial_routines21.resize (yyvs21, yyvsc21)
		end
	end
	yyvs21.put (yyval21, yyvsp21)
end
when 85 then
--|#line 548 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 548")
end

			if my_date.is_two_digit_year (yyvs3.item (yyvsp3).item) then
				my_year := my_date.four_digit_year (yyvs3.item (yyvsp3).item)
			else
				my_year := yyvs3.item (yyvsp3).item
			end
			if my_date.is_valid_date (my_year, yyvs3.item (yyvsp3 - 1).item, yyvs3.item (yyvsp3 - 2).item) then
				my_date.make_utc_date (my_year, yyvs3.item (yyvsp3 - 1).item, yyvs3.item (yyvsp3 - 2).item)
				yyval21 := my_date
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp21 := yyvsp21 + 1
	yyvsp3 := yyvsp3 -3
	yyvsp1 := yyvsp1 -2
	if yyvsp21 >= yyvsc21 then
		if yyvs21 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs21")
			end
			create yyspecial_routines21
			yyvsc21 := yyInitial_yyvs_size
			yyvs21 := yyspecial_routines21.make (yyvsc21)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs21")
			end
			yyvsc21 := yyvsc21 + yyInitial_yyvs_size
			yyvs21 := yyspecial_routines21.resize (yyvs21, yyvsc21)
		end
	end
	yyvs21.put (yyval21, yyvsp21)
end
when 86 then
--|#line 563 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 563")
end

			if my_date.is_valid_date (my_date.current_year, yyvs3.item (yyvsp3 - 1).item, yyvs3.item (yyvsp3).item) then
				my_date.make_utc_date (my_date.current_year, yyvs3.item (yyvsp3 - 1).item, yyvs3.item (yyvsp3).item)
				yyval21 := my_date
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp21 := yyvsp21 + 1
	yyvsp3 := yyvsp3 -2
	if yyvsp21 >= yyvsc21 then
		if yyvs21 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs21")
			end
			create yyspecial_routines21
			yyvsc21 := yyInitial_yyvs_size
			yyvs21 := yyspecial_routines21.make (yyvsc21)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs21")
			end
			yyvsc21 := yyvsc21 + yyInitial_yyvs_size
			yyvs21 := yyspecial_routines21.resize (yyvs21, yyvsc21)
		end
	end
	yyvs21.put (yyval21, yyvsp21)
end
when 87 then
--|#line 575 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 575")
end

			if yyvs21.item (yyvsp21 - 1) /= Void and then yyvs21.item (yyvsp21) /= Void and then my_date.is_valid_date_and_time (yyvs21.item (yyvsp21 - 1).year, yyvs21.item (yyvsp21 - 1).month, yyvs21.item (yyvsp21 - 1).day, yyvs21.item (yyvsp21).hour, yyvs21.item (yyvsp21).minute, yyvs21.item (yyvsp21).second) then
				create yyval21.make_utc_date_time (yyvs21.item (yyvsp21 - 1).year, yyvs21.item (yyvsp21 - 1).month, yyvs21.item (yyvsp21 - 1).day, yyvs21.item (yyvsp21).hour, yyvs21.item (yyvsp21).minute, yyvs21.item (yyvsp21).second)
				minutes := yyvs3.item (yyvsp3).item.abs \\ 100
				hours := yyvs3.item (yyvsp3).item.abs // 100
				seconds := (minutes * 60 + hours * 3600)
				if yyvs3.item (yyvsp3).item < 0 then
					seconds := -1 * seconds
				end
				yyval21.make_from_unix_time (yyval21.value - seconds)
				yyval21.to_utc
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp21 := yyvsp21 -1
	yyvsp1 := yyvsp1 -1
	yyvsp3 := yyvsp3 -1
	yyvs21.put (yyval21, yyvsp21)
end
when 88 then
--|#line 592 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 592")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 89 then
--|#line 593 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 593")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 90 then
--|#line 594 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 594")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 91 then
--|#line 595 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 595")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 92 then
--|#line 596 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 596")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 93 then
--|#line 597 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 597")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 94 then
--|#line 598 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 598")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 95 then
--|#line 602 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 602")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 96 then
--|#line 607 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 607")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 97 then
--|#line 609 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 609")
end

yyval2 := yyvs2.item (yyvsp2 - 1) + "." + yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -1
	yyvs2.put (yyval2, yyvsp2)
end
when 98 then
--|#line 614 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 614")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 99 then
--|#line 619 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 619")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 100 then
--|#line 624 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 624")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 101 then
--|#line 626 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 626")
end

yyval2 := yyvs2.item (yyvsp2 - 1) + "." + yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -1
	yyvs2.put (yyval2, yyvsp2)
end
when 102 then
--|#line 631 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 631")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -1
	yyvsp2 := yyvsp2 -1
	yyvsp20 := yyvsp20 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 103 then
--|#line 635 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 635")
end

			if my_time.is_valid_time (yyvs3.item (yyvsp3 - 2).item, yyvs3.item (yyvsp3 - 1).item, yyvs3.item (yyvsp3).item) then
				my_time.make_utc_time (yyvs3.item (yyvsp3 - 2).item, yyvs3.item (yyvsp3 - 1).item, yyvs3.item (yyvsp3).item)
				yyval21 := my_time
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp21 := yyvsp21 + 1
	yyvsp3 := yyvsp3 -3
	yyvsp1 := yyvsp1 -1
	if yyvsp21 >= yyvsc21 then
		if yyvs21 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs21")
			end
			create yyspecial_routines21
			yyvsc21 := yyInitial_yyvs_size
			yyvs21 := yyspecial_routines21.make (yyvsc21)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs21")
			end
			yyvsc21 := yyvsc21 + yyInitial_yyvs_size
			yyvs21 := yyspecial_routines21.resize (yyvs21, yyvsc21)
		end
	end
	yyvs21.put (yyval21, yyvsp21)
end
when 104 then
--|#line 645 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 645")
end

yyval21 := yyvs21.item (yyvsp21) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs21.put (yyval21, yyvsp21)
end
when 105 then
--|#line 650 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 650")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 106 then
--|#line 652 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 652")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 107 then
--|#line 662 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 662")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 108 then
--|#line 664 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 664")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 109 then
--|#line 666 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 666")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 110 then
--|#line 672 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 672")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 111 then
--|#line 678 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 678")
end

		if yyvs2.item (yyvsp2).is_integer then
			yyval3 := yyvs2.item (yyvsp2).to_integer
		else
			abort
		end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp3 := yyvsp3 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp3 >= yyvsc3 then
		if yyvs3 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs3")
			end
			create yyspecial_routines3
			yyvsc3 := yyInitial_yyvs_size
			yyvs3 := yyspecial_routines3.make (yyvsc3)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs3")
			end
			yyvsc3 := yyvsc3 + yyInitial_yyvs_size
			yyvs3 := yyspecial_routines3.resize (yyvs3, yyvsc3)
		end
	end
	yyvs3.put (yyval3, yyvsp3)
end
when 112 then
--|#line 689 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 689")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 113 then
--|#line 691 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 691")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 114 then
--|#line 697 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 697")
end

create yyval19.make (Void, yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp19 := yyvsp19 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp19 >= yyvsc19 then
		if yyvs19 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs19")
			end
			create yyspecial_routines19
			yyvsc19 := yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.make (yyvsc19)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs19")
			end
			yyvsc19 := yyvsc19 + yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.resize (yyvs19, yyvsc19)
		end
	end
	yyvs19.put (yyval19, yyvsp19)
end
when 115 then
--|#line 699 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 699")
end

yyval19 := yyvs19.item (yyvsp19) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs19.put (yyval19, yyvsp19)
end
when 116 then
--|#line 704 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 704")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp20 := yyvsp20 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp20 >= yyvsc20 then
		if yyvs20 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs20")
			end
			create yyspecial_routines20
			yyvsc20 := yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.make (yyvsc20)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs20")
			end
			yyvsc20 := yyvsc20 + yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.resize (yyvs20, yyvsc20)
		end
	end
	yyvs20.put (yyval20, yyvsp20)
end
when 117 then
--|#line 705 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 705")
end

create yyval20.make (yyvs19.item (yyvsp19)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp20 := yyvsp20 + 1
	yyvsp19 := yyvsp19 -1
	if yyvsp20 >= yyvsc20 then
		if yyvs20 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs20")
			end
			create yyspecial_routines20
			yyvsc20 := yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.make (yyvsc20)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs20")
			end
			yyvsc20 := yyvsc20 + yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.resize (yyvs20, yyvsc20)
		end
	end
	yyvs20.put (yyval20, yyvsp20)
end
when 118 then
--|#line 707 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 707")
end

create yyval20.make (yyvs19.item (yyvsp19)); yyval20.put_right (yyvs20.item (yyvsp20)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp19 := yyvsp19 -1
	yyvsp1 := yyvsp1 -1
	yyvs20.put (yyval20, yyvsp20)
end
when 119 then
--|#line 712 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 712")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 120 then
--|#line 719 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 719")
end

yyval2 := yyvs2.item (yyvsp2 - 1) + yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -3
	yyvs2.put (yyval2, yyvsp2)
end
when 121 then
--|#line 721 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 721")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 122 then
--|#line 726 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 726")
end

create yyval19.make (Void, yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp19 := yyvsp19 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp19 >= yyvsc19 then
		if yyvs19 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs19")
			end
			create yyspecial_routines19
			yyvsc19 := yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.make (yyvsc19)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs19")
			end
			yyvsc19 := yyvsc19 + yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.resize (yyvs19, yyvsc19)
		end
	end
	yyvs19.put (yyval19, yyvsp19)
end
when 123 then
--|#line 728 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 728")
end

create yyval19.make (yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp19 := yyvsp19 + 1
	yyvsp2 := yyvsp2 -2
	if yyvsp19 >= yyvsc19 then
		if yyvs19 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs19")
			end
			create yyspecial_routines19
			yyvsc19 := yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.make (yyvsc19)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs19")
			end
			yyvsc19 := yyvsc19 + yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.resize (yyvs19, yyvsc19)
		end
	end
	yyvs19.put (yyval19, yyvsp19)
end
when 124 then
--|#line 733 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 733")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 125 then
--|#line 738 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 738")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -3
	yyvs2.put (yyval2, yyvsp2)
end
when 126 then
--|#line 745 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 745")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 127 then
--|#line 749 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 749")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 128 then
--|#line 750 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 750")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 129 then
--|#line 754 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 754")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 130 then
--|#line 755 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 755")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 131 then
--|#line 759 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 759")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 132 then
--|#line 763 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 763")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 133 then
--|#line 764 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 764")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 134 then
--|#line 768 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 768")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 135 then
--|#line 769 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 769")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 136 then
--|#line 773 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 773")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 137 then
--|#line 774 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 774")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 138 then
--|#line 780 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 780")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 139 then
--|#line 781 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 781")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 140 then
--|#line 782 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 782")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -2
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 141 then
--|#line 788 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 788")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 142 then
--|#line 789 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 789")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 143 then
--|#line 793 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 793")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 144 then
--|#line 794 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 794")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 145 then
--|#line 798 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 798")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp20 := yyvsp20 + 1
	if yyvsp20 >= yyvsc20 then
		if yyvs20 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs20")
			end
			create yyspecial_routines20
			yyvsc20 := yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.make (yyvsc20)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs20")
			end
			yyvsc20 := yyvsc20 + yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.resize (yyvs20, yyvsc20)
		end
	end
	yyvs20.put (yyval20, yyvsp20)
end
when 146 then
--|#line 799 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 799")
end

yyval20 := yyvs20.item (yyvsp20) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs20.put (yyval20, yyvsp20)
end
when 147 then
--|#line 804 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 804")
end

yyval3 := 0 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp3 := yyvsp3 + 1
	if yyvsp3 >= yyvsc3 then
		if yyvs3 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs3")
			end
			create yyspecial_routines3
			yyvsc3 := yyInitial_yyvs_size
			yyvs3 := yyspecial_routines3.make (yyvsc3)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs3")
			end
			yyvsc3 := yyvsc3 + yyInitial_yyvs_size
			yyvs3 := yyspecial_routines3.resize (yyvs3, yyvsc3)
		end
	end
	yyvs3.put (yyval3, yyvsp3)
end
when 148 then
--|#line 806 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 806")
end

yyval3 := yyvs3.item (yyvsp3).item 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs3.put (yyval3, yyvsp3)
end
when 149 then
--|#line 811 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 811")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 150 then
--|#line 812 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 812")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 151 then
--|#line 816 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 816")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 152 then
--|#line 817 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 817")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 153 then
--|#line 821 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 821")
end

			yyvs2.item (yyvsp2 - 1).to_lower
			create yyval22.make (yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2))
			current_parameter_field.parameters.put (yyval22, yyvs2.item (yyvsp2 - 1))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp22 := yyvsp22 + 1
	yyvsp2 := yyvsp2 -2
	yyvsp1 := yyvsp1 -1
	if yyvsp22 >= yyvsc22 then
		if yyvs22 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs22")
			end
			create yyspecial_routines22
			yyvsc22 := yyInitial_yyvs_size
			yyvs22 := yyspecial_routines22.make (yyvsc22)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs22")
			end
			yyvsc22 := yyvsc22 + yyInitial_yyvs_size
			yyvs22 := yyspecial_routines22.resize (yyvs22, yyvsc22)
		end
	end
	yyvs22.put (yyval22, yyvsp22)
end
when 154 then
--|#line 830 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 830")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 155 then
--|#line 831 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 831")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 156 then
--|#line 837 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 837")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp22 := yyvsp22 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 157 then
--|#line 838 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 838")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 158 then
--|#line 839 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 839")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp22 := yyvsp22 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 159 then
--|#line 845 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 845")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs1.put (yyval1, yyvsp1)
end
when 160 then
--|#line 846 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 846")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 161 then
--|#line 847 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 847")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 162 then
--|#line 851 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 851")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 163 then
--|#line 856 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 856")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 164 then
--|#line 858 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 858")
end

yyval2 := yyvs2.item (yyvsp2 - 1); yyval2.append_character (' '); yyval2.append_string (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp2 := yyvsp2 -1
	yyvs2.put (yyval2, yyvsp2)
end
when 165 then
--|#line 863 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 863")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 166 then
--|#line 868 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 868")
end

yyval2  := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 167 then
--|#line 870 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 870")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 168 then
--|#line 875 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 875")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 169 then
--|#line 880 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 880")
end

yyval21 := yyvs21.item (yyvsp21) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs21.put (yyval21, yyvsp21)
end
when 170 then
--|#line 885 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 885")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 171 then
--|#line 892 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 892")
end

			if STRING_.same_string (yyvs2.item (yyvsp2).as_lower, "multipart") then
				yyval2 := "multipart"
				part.create_multipart_body
			else
				yyval2 := yyvs2.item (yyvsp2)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 172 then
--|#line 904 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 904")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 173 then
--|#line 906 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 906")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 174 then
--|#line 908 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 908")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 175 then
--|#line 913 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 913")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 176 then
--|#line 914 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 914")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 177 then
--|#line 918 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 918")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 178 then
--|#line 920 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 920")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 179 then
--|#line 929 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 929")
end

yyval3 := yyvs3.item (yyvsp3).item 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs3.put (yyval3, yyvsp3)
end
when 180 then
--|#line 931 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 931")
end

yyval3 := yyvs3.item (yyvsp3).item 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs3.put (yyval3, yyvsp3)
end
when 181 then
--|#line 936 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 936")
end

yyval3 := 0 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp3 := yyvsp3 + 1
	if yyvsp3 >= yyvsc3 then
		if yyvs3 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs3")
			end
			create yyspecial_routines3
			yyvsc3 := yyInitial_yyvs_size
			yyvs3 := yyspecial_routines3.make (yyvsc3)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs3")
			end
			yyvsc3 := yyvsc3 + yyInitial_yyvs_size
			yyvs3 := yyspecial_routines3.resize (yyvs3, yyvsc3)
		end
	end
	yyvs3.put (yyval3, yyvsp3)
end
when 182 then
--|#line 938 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 938")
end

yyval3 := yyvs3.item (yyvsp3) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs3.put (yyval3, yyvsp3)
end
when 183 then
--|#line 945 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 945")
end

create yyval5.make (yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp5 := yyvsp5 + 1
	yyvsp2 := yyvsp2 -2
	yyvsp1 := yyvsp1 -1
	if yyvsp5 >= yyvsc5 then
		if yyvs5 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs5")
			end
			create yyspecial_routines5
			yyvsc5 := yyInitial_yyvs_size
			yyvs5 := yyspecial_routines5.make (yyvsc5)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs5")
			end
			yyvsc5 := yyvsc5 + yyInitial_yyvs_size
			yyvs5 := yyspecial_routines5.resize (yyvs5, yyvsc5)
		end
	end
	yyvs5.put (yyval5, yyvsp5)
end
when 184 then
--|#line 950 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 950")
end

yyval2 := "" 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp2 := yyvsp2 + 1
	if yyvsp2 >= yyvsc2 then
		if yyvs2 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs2")
			end
			create yyspecial_routines2
			yyvsc2 := yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.make (yyvsc2)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs2")
			end
			yyvsc2 := yyvsc2 + yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
		end
	end
	yyvs2.put (yyval2, yyvsp2)
end
when 185 then
--|#line 952 "epx_mime_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_mime_parser.y' at line 952")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
			else
				debug ("GEYACC")
					std.error.put_string ("Error in parser: unknown rule id: ")
					std.error.put_integer (yy_act)
					std.error.put_new_line
				end
				abort
			end
		end

	yy_do_error_action (yy_act: INTEGER) is
			-- Execute error action.
		do
			inspect yy_act
			when 289 then
					-- End-of-file expected action.
				report_eof_expected_error
			else
					-- Default action.
				report_error ("parse error")
			end
		end

feature {NONE} -- Table templates

	yytranslate_template: SPECIAL [INTEGER] is
			-- Template for `yytranslate'
		once
			Result := yyfixed_array (<<
			    0,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,   57,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,   52,   56,   49,   48,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,   47,   50,
			   54,   51,   55,    2,   53,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,

			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,

			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    1,    2,    3,    4,
			    5,    6,    7,    8,    9,   10,   11,   12,   13,   14,
			   15,   16,   17,   18,   19,   20,   21,   22,   23,   24,
			   25,   26,   27,   28,   29,   30,   31,   32,   33,   34,
			   35,   36,   37,   38,   39,   40,   41,   42,   43,   44,

			   45,   46, yyDummy>>)
		end

	yyr1_template: SPECIAL [INTEGER] is
			-- Template for `yyr1'
		once
			Result := yyfixed_array (<<
			    0,  126,  126,  127,  127,   58,   58,   58,  128,   60,
			   60,   60,   60,   60,   60,   60,   60,   60,   60,   60,
			   60,   60,   60,   60,   60,   60,   60,   60,   60,   60,
			   60,   70,   70,   71,   71,   61,  134,   62,   63,   64,
			  135,   65,  136,   72,   66,  137,   67,  138,   68,   69,
			  129,  145,   73,   74,  130,  131,  132,   76,  147,   75,
			   75,   77,  148,   78,  150,   79,   79,   80,   80,   80,
			  152,  152,   81,   82,   82,   84,   85,   86,  149,  149,
			  149,   87,   87,   87,   88,   89,   90,   91,  154,  154,
			  154,  154,  154,  154,  154,   92,   93,   93,   94,   95,

			   96,   96,  151,   97,   98,   99,   99,  100,  100,  100,
			  101,  124,  102,  102,  103,  103,  104,  104,  104,  106,
			  107,  107,  108,  108,  109,   83,  155,  156,  156,  157,
			  157,  158,  140,  140,  153,  153,  159,  159,  144,  144,
			  144,  139,  139,  143,  143,  105,  105,  114,  114,  141,
			  141,  142,  142,  110,  133,  133,  161,  161,  161,  146,
			  146,  146,  111,  113,  113,  112,  115,  115,  116,  117,
			  118,  119,  120,  120,  120,  160,  160,  125,  125,  121,
			  121,  122,  122,   59,  123,  123, yyDummy>>)
		end

	yytypes1_template: SPECIAL [INTEGER] is
			-- Template for `yytypes1'
		once
			Result := yyfixed_array (<<
			    1,    1,    2,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    4,    5,    4,    6,
			    7,    8,    9,   10,   11,   12,   13,   14,   15,   15,
			   15,   15,   15,   15,   16,   17,   18,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    4,    1,    1,    1,    1,
			    2,    2,    2,    2,    2,    2,    2,    3,    2,    1,
			    1,    2,   19,   20,    2,    2,    2,    2,    2,    2,

			    2,    2,   19,   19,    2,    2,    2,    2,    1,    2,
			   19,    2,   19,   20,    1,   19,   20,    1,    2,    2,
			    2,    2,    1,    1,    1,    1,    1,    2,    2,   12,
			   11,   20,   10,    2,    2,    2,    2,    3,    2,   20,
			   20,    1,   18,    1,   17,    1,    1,    2,    1,    1,
			    1,    1,    1,    2,    1,    1,    2,    2,    2,    1,
			    1,    2,    1,    2,    2,    2,    2,    2,    1,    1,
			    2,    2,    2,    2,    1,    1,    1,    1,    1,    1,
			    1,   21,   21,    1,    1,   21,   21,    1,    6,    2,
			   22,    2,    1,    3,    1,    1,    1,    2,    1,    2,

			    1,    1,   20,    2,    2,   20,   20,    2,    2,    2,
			    2,   20,    1,    2,    1,    1,    2,    1,    1,    1,
			    3,    3,   21,   21,   21,   21,    1,    2,    2,    1,
			    1,    1,    1,   22,    1,    1,   16,    2,    2,    1,
			    1,    1,    2,    2,    2,    2,    2,    1,    3,    3,
			    3,   21,   21,    9,    2,    1,    1,    1,    2,    1,
			    1,    1,    3,    3,    1,    1,    3,    3,    3,    1,
			    1,    2,    1,    1,    1,    3,    3,    1,    2,    1,
			    3,    1,    3,    1,    2,    1,    3,    1,   21,    1,
			    1,    1, yyDummy>>)
		end

	yytypes2_template: SPECIAL [INTEGER] is
			-- Template for `yytypes2'
		once
			Result := yyfixed_array (<<
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    2,    2,    2,    2,    3,
			    3,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    2,    2,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1, yyDummy>>)
		end

	yydefact_template: SPECIAL [INTEGER] is
			-- Template for `yydefact'
		once
			Result := yyfixed_array (<<
			    0,    2,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    8,    0,    0,    0,   11,
			   12,   13,   14,   15,   17,   18,   19,   20,    9,   10,
			   16,   22,   24,   28,   27,   29,   30,    0,   21,   23,
			   25,   26,  184,    0,    0,    0,   60,    0,    0,    0,
			    0,    0,    0,  141,    0,   47,   45,    0,   42,    0,
			    0,    0,    0,   34,   32,    0,    4,    6,    5,    1,
			  185,  183,   75,  170,   64,   77,  111,    0,   62,    0,
			   67,  178,   68,   59,  114,  122,   74,  177,    0,  112,

			   99,    0,   65,  115,   95,  163,  162,  165,   66,    0,
			   56,   95,   54,   53,  116,  117,   52,   70,  113,  161,
			  131,  100,   55,  160,    0,  132,    0,  121,   48,  134,
			  134,   43,  134,  171,    0,  119,   38,   37,   36,   33,
			   31,    7,    0,    0,  154,    0,  129,    0,    0,    0,
			  127,    0,    0,  123,    0,  145,  178,  177,  164,    0,
			    0,   71,    0,  167,   98,  136,  166,   96,    0,  149,
			  124,  105,    0,  106,   94,   93,   92,   91,   90,   89,
			   88,  104,   46,    0,    0,   44,   41,    0,  154,    0,
			   78,   76,   63,   49,  157,   61,  155,  130,   73,    0,

			  126,  128,   69,  101,   72,  146,    0,  174,  173,  172,
			   58,  118,  159,  137,  142,    0,  133,    0,  151,    0,
			    0,    0,    0,   81,   82,   83,  135,  168,   40,   35,
			    0,    0,   79,  156,  125,  102,  154,   97,  150,    0,
			  143,  152,  110,  107,    0,  109,  108,    0,    0,   86,
			    0,  169,  181,  154,  153,   80,  158,   57,  175,    0,
			  138,  120,    0,   84,    0,    0,  179,  182,   87,   39,
			  176,  144,    0,    0,    0,  147,    0,    0,  139,   51,
			   85,    0,  103,  180,    0,  134,  148,  140,   50,    0,
			    0,    0, yyDummy>>)
		end

	yydefgoto_template: SPECIAL [INTEGER] is
			-- Template for `yydefgoto'
		once
			Result := yyfixed_array (<<
			   26,   27,   28,   29,   30,   31,   32,   33,   34,   35,
			   36,   37,   38,   39,   40,   41,   42,   43,   44,   45,
			   46,   92,   93,   94,   95,   96,   97,  189,   84,  222,
			  223,  224,  225,  181,   98,  165,  166,   99,  100,  251,
			  182,  172,  244,  245,  101,  102,  116,  206,  136,  128,
			  103,  173,  190,  111,  105,  106,  282,  167,  228,  252,
			  191,  134,  210,  267,  268,   81,   87,  107,  289,   47,
			   75,   48,   49,   50,   51,  195,  188,  253,  132,  130,
			  129,  125,  169,  218,  240,  260,  273,  285,  122,  236,
			  144,  192,  142,  108,  162,  183,  184,  148,  149,  150,

			  123,  214,  241,  196, yyDummy>>)
		end

	yypact_template: SPECIAL [INTEGER] is
			-- Template for `yypact'
		once
			Result := yyfixed_array (<<
			  266, -32768,  162,  161,  160,  158,  157,  156,  155,  154,
			  153,  152,  151,  150,  149,  148,  147,  146,  145,  144,
			  143,  142,  141,  140,  134, -32768,  222,  139,  138, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768,  136, -32768, -32768,
			 -32768, -32768,  135,  110,  110,  110,   20,  110,   42,   42,
			   20,    9,   30,  132,   28, -32768, -32768,    9, -32768,  110,
			  110,  110,  110,   20,   20,  128, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768,  124, -32768,   72,
			 -32768,  126,  123, -32768, -32768, -32768, -32768,  -18,  122, -32768,

			 -32768,  116, -32768, -32768,  121,   60, -32768, -32768, -32768,  120,
			 -32768, -32768, -32768, -32768, -32768,  107, -32768,   72, -32768, -32768,
			 -32768,  114, -32768, -32768,   32,  127,   50, -32768, -32768,   89,
			   89, -32768,   89, -32768,  113, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768,  110,  110,   90,   32, -32768,  112,   41,   34,
			 -32768,   20,  110, -32768,   32,    9, -32768, -32768, -32768,   79,
			    9, -32768,  105, -32768, -32768,  125, -32768,  108,   32,  119,
			 -32768, -32768,  102, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768,   14,  101, -32768, -32768,  110,   90,  100,
			   24, -32768, -32768, -32768,  110, -32768, -32768, -32768, -32768,   95,

			 -32768, -32768, -32768, -32768, -32768, -32768,   99, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768,   32, -32768,  110,  106,   93,
			   21,  118,  117, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			   79,  110, -32768,   90, -32768, -32768,   90, -32768, -32768,  110,
			  111, -32768, -32768, -32768,   91, -32768, -32768,  115,  109, -32768,
			   96, -32768,    8,   90, -32768, -32768, -32768, -32768,  106,  110,
			  104, -32768,   82, -32768,  103,   92, -32768, -32768, -32768, -32768,
			 -32768, -32768,   26,   73,   80,   61,   46,   41, -32768, -32768,
			 -32768,   68, -32768, -32768,   38,   89, -32768, -32768, -32768,   83,
			   29, -32768, yyDummy>>)
		end

	yypgoto_template: SPECIAL [INTEGER] is
			-- Template for `yypgoto'
		once
			Result := yyfixed_array (<<
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768,  -32,  -57,  163,  185,  -53, -32768, -32768, -32768,
			 -32768, -32768, -32768, -129, -32768, -121, -32768, -32768, -106, -32768,
			   86, -32768, -32768, -32768, -32768,  -46,  -44, -32768, -32768, -32768,
			 -32768,   -5,   18,  -34, -32768,  159, -32768, -32768, -32768, -32768,
			  -47, -32768,  -17, -32768, -32768, -32768,  -41, -32768, -32768,  184,
			 -32768, -32768, -32768, -32768, -32768, -174, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -163, -32768, -32768, -32768, -32768, -32768, -32768, -32768,   62,

			 -32768, -32768,  -86,  -63, yyDummy>>)
		end

	yytable_template: SPECIAL [INTEGER] is
			-- Template for `yytable'
		once
			Result := yyfixed_array (<<
			   83,   86,   83,  186,   83,  119,   85,  127,   88,  121,
			  109,  121,  110,  112,  229,  115,  133,  135,   86,   83,
			  171,  115,  104,  131,  197,  138,  104,  232,  113,  291,
			  137,  152,  147,  204,   82, -100,  121,   91,  266,  104,
			  104,  139,  140,  221,  220,   82,  203,  216,   91,   82,
			  248,   82,  157,   82,  118,   82,  118,   82,  118,  163,
			  161,  114,  257,   89,  121,  265,   82,   82,  255,  118,
			   91,  164,   90,  121,   89,   82,  231,  247,  170,  269,
			  277,  200,  126,  290,  117,   82,  146,  145,  156,   83,
			   86,  199,  164,  287,  237,  121,   89,   82,  286,  121,

			  118,  164,  193,  283,   82,  208,   83,  207,  281,  115,
			  280,  205,  209,  243,  115,  164,  211,  104,   82,  202,
			  242,  170,  276,  279,  146,  145,  180,  179,  178,  177,
			  176,  175,  174,  275,  227,   82,  272,   83,  274,  263,
			  194,   83,  239,  264,  262,  259,  261,  250,  249,  235,
			  234,  230,  213,  226,  217,  219,  288,  215,  168,  160,
			  212,  187,  164,  152,  238,  124,  121,  198,  155,  154,
			  256,  159,  270,  143,  141,  151,   89,   83,   83, -113,
			   80,   74,   79,  209,   78,   77,  258,   73,   72,   71,
			   70,   69,   68,   67,   66,   65,   64,   63,   62,   61,

			   60,   59,   58,   57,   56,   55,  271,   54,   53,   52,
			   76,  201,  233,  254,  246,  278,  185,    0,    0,  121,
			  284,    0,    0,   25,  121,   24,   23,   22,   21,   20,
			   19,   18,   17,   16,   15,   14,   13,   12,   11,   10,
			    9,    8,    7,    6,    5,    4,    3,  120,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,  153,    0,    0,  158,    0,    2,   25,   -3,   24,
			   23,   22,   21,   20,   19,   18,   17,   16,   15,   14,
			   13,   12,   11,   10,    9,    8,    7,    6,    5,    4,
			    3,    0,    0,    0,    0,    0,    0,    0,    0,    0,

			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    2,    0,    1, yyDummy>>)
		end

	yycheck_template: SPECIAL [INTEGER] is
			-- Template for `yycheck'
		once
			Result := yyfixed_array (<<
			   53,   54,   55,  132,   57,   62,   53,   64,   55,   62,
			   57,   64,   58,   59,  188,   61,   69,   70,   71,   72,
			  126,   67,   56,   67,  145,   72,   60,  190,   60,    0,
			   71,   49,   89,  154,   25,   53,   89,   28,   30,   73,
			   74,   73,   74,   29,   30,   25,  152,  168,   28,   25,
			   29,   25,  105,   25,   28,   25,   28,   25,   28,   27,
			  117,   52,  236,   54,  117,   57,   25,   25,  231,   28,
			   28,  124,   52,  126,   54,   25,   52,   56,   28,  253,
			   54,   47,   54,    0,   54,   25,   52,   53,   28,  142,
			  143,  148,  145,   55,  215,  148,   54,   25,   30,  152,

			   28,  154,  143,   57,   25,   26,  159,   28,   47,  155,
			   30,  155,  159,  219,  160,  168,  160,  151,   25,  151,
			   27,   28,   30,   50,   52,   53,   37,   38,   39,   40,
			   41,   42,   43,   30,  187,   25,   32,  190,   56,   30,
			   50,  194,   36,   47,   29,   34,   55,   30,   30,   50,
			   55,   51,   27,   52,   35,   53,  285,   49,   31,   52,
			   55,   48,  215,   49,  217,   33,  219,   55,   47,   53,
			  233,   51,  258,   49,   46,   52,   54,  230,  231,   53,
			   45,   47,   46,  230,   46,   46,  239,   47,   47,   47,
			   47,   47,   47,   47,   47,   47,   47,   47,   47,   47,

			   47,   47,   47,   47,   47,   47,  259,   47,   47,   47,
			   26,  149,  194,  230,  219,  272,  130,   -1,   -1,  272,
			  277,   -1,   -1,    1,  277,    3,    4,    5,    6,    7,
			    8,    9,   10,   11,   12,   13,   14,   15,   16,   17,
			   18,   19,   20,   21,   22,   23,   24,   62,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   98,   -1,   -1,  105,   -1,   44,    1,   46,    3,
			    4,    5,    6,    7,    8,    9,   10,   11,   12,   13,
			   14,   15,   16,   17,   18,   19,   20,   21,   22,   23,
			   24,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,

			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   44,   -1,   46, yyDummy>>)
		end

feature {NONE} -- Semantic value stacks

	yyvs1: SPECIAL [ANY]
			-- Stack for semantic values of type ANY

	yyvsc1: INTEGER
			-- Capacity of semantic value stack `yyvs1'

	yyvsp1: INTEGER
			-- Top of semantic value stack `yyvs1'

	yyspecial_routines1: KL_SPECIAL_ROUTINES [ANY]
			-- Routines that ought to be in SPECIAL [ANY]

	yyvs2: SPECIAL [STRING]
			-- Stack for semantic values of type STRING

	yyvsc2: INTEGER
			-- Capacity of semantic value stack `yyvs2'

	yyvsp2: INTEGER
			-- Top of semantic value stack `yyvs2'

	yyspecial_routines2: KL_SPECIAL_ROUTINES [STRING]
			-- Routines that ought to be in SPECIAL [STRING]

	yyvs3: SPECIAL [INTEGER]
			-- Stack for semantic values of type INTEGER

	yyvsc3: INTEGER
			-- Capacity of semantic value stack `yyvs3'

	yyvsp3: INTEGER
			-- Top of semantic value stack `yyvs3'

	yyspecial_routines3: KL_SPECIAL_ROUTINES [INTEGER]
			-- Routines that ought to be in SPECIAL [INTEGER]

	yyvs4: SPECIAL [EPX_MIME_FIELD]
			-- Stack for semantic values of type EPX_MIME_FIELD

	yyvsc4: INTEGER
			-- Capacity of semantic value stack `yyvs4'

	yyvsp4: INTEGER
			-- Top of semantic value stack `yyvs4'

	yyspecial_routines4: KL_SPECIAL_ROUTINES [EPX_MIME_FIELD]
			-- Routines that ought to be in SPECIAL [EPX_MIME_FIELD]

	yyvs5: SPECIAL [EPX_MIME_UNSTRUCTURED_FIELD]
			-- Stack for semantic values of type EPX_MIME_UNSTRUCTURED_FIELD

	yyvsc5: INTEGER
			-- Capacity of semantic value stack `yyvs5'

	yyvsp5: INTEGER
			-- Top of semantic value stack `yyvs5'

	yyspecial_routines5: KL_SPECIAL_ROUTINES [EPX_MIME_UNSTRUCTURED_FIELD]
			-- Routines that ought to be in SPECIAL [EPX_MIME_UNSTRUCTURED_FIELD]

	yyvs6: SPECIAL [EPX_MIME_FIELD_CONTENT_DISPOSITION]
			-- Stack for semantic values of type EPX_MIME_FIELD_CONTENT_DISPOSITION

	yyvsc6: INTEGER
			-- Capacity of semantic value stack `yyvs6'

	yyvsp6: INTEGER
			-- Top of semantic value stack `yyvs6'

	yyspecial_routines6: KL_SPECIAL_ROUTINES [EPX_MIME_FIELD_CONTENT_DISPOSITION]
			-- Routines that ought to be in SPECIAL [EPX_MIME_FIELD_CONTENT_DISPOSITION]

	yyvs7: SPECIAL [EPX_MIME_FIELD_CONTENT_LENGTH]
			-- Stack for semantic values of type EPX_MIME_FIELD_CONTENT_LENGTH

	yyvsc7: INTEGER
			-- Capacity of semantic value stack `yyvs7'

	yyvsp7: INTEGER
			-- Top of semantic value stack `yyvs7'

	yyspecial_routines7: KL_SPECIAL_ROUTINES [EPX_MIME_FIELD_CONTENT_LENGTH]
			-- Routines that ought to be in SPECIAL [EPX_MIME_FIELD_CONTENT_LENGTH]

	yyvs8: SPECIAL [EPX_MIME_FIELD_CONTENT_TRANSFER_ENCODING]
			-- Stack for semantic values of type EPX_MIME_FIELD_CONTENT_TRANSFER_ENCODING

	yyvsc8: INTEGER
			-- Capacity of semantic value stack `yyvs8'

	yyvsp8: INTEGER
			-- Top of semantic value stack `yyvs8'

	yyspecial_routines8: KL_SPECIAL_ROUTINES [EPX_MIME_FIELD_CONTENT_TRANSFER_ENCODING]
			-- Routines that ought to be in SPECIAL [EPX_MIME_FIELD_CONTENT_TRANSFER_ENCODING]

	yyvs9: SPECIAL [EPX_MIME_FIELD_CONTENT_TYPE]
			-- Stack for semantic values of type EPX_MIME_FIELD_CONTENT_TYPE

	yyvsc9: INTEGER
			-- Capacity of semantic value stack `yyvs9'

	yyvsp9: INTEGER
			-- Top of semantic value stack `yyvs9'

	yyspecial_routines9: KL_SPECIAL_ROUTINES [EPX_MIME_FIELD_CONTENT_TYPE]
			-- Routines that ought to be in SPECIAL [EPX_MIME_FIELD_CONTENT_TYPE]

	yyvs10: SPECIAL [EPX_MIME_FIELD_DATE]
			-- Stack for semantic values of type EPX_MIME_FIELD_DATE

	yyvsc10: INTEGER
			-- Capacity of semantic value stack `yyvs10'

	yyvsp10: INTEGER
			-- Top of semantic value stack `yyvs10'

	yyspecial_routines10: KL_SPECIAL_ROUTINES [EPX_MIME_FIELD_DATE]
			-- Routines that ought to be in SPECIAL [EPX_MIME_FIELD_DATE]

	yyvs11: SPECIAL [EPX_MIME_FIELD_IF_MODIFIED_SINCE]
			-- Stack for semantic values of type EPX_MIME_FIELD_IF_MODIFIED_SINCE

	yyvsc11: INTEGER
			-- Capacity of semantic value stack `yyvs11'

	yyvsp11: INTEGER
			-- Top of semantic value stack `yyvs11'

	yyspecial_routines11: KL_SPECIAL_ROUTINES [EPX_MIME_FIELD_IF_MODIFIED_SINCE]
			-- Routines that ought to be in SPECIAL [EPX_MIME_FIELD_IF_MODIFIED_SINCE]

	yyvs12: SPECIAL [EPX_MIME_FIELD_LAST_MODIFIED]
			-- Stack for semantic values of type EPX_MIME_FIELD_LAST_MODIFIED

	yyvsc12: INTEGER
			-- Capacity of semantic value stack `yyvs12'

	yyvsp12: INTEGER
			-- Top of semantic value stack `yyvs12'

	yyspecial_routines12: KL_SPECIAL_ROUTINES [EPX_MIME_FIELD_LAST_MODIFIED]
			-- Routines that ought to be in SPECIAL [EPX_MIME_FIELD_LAST_MODIFIED]

	yyvs13: SPECIAL [EPX_MIME_FIELD_MESSAGE_ID]
			-- Stack for semantic values of type EPX_MIME_FIELD_MESSAGE_ID

	yyvsc13: INTEGER
			-- Capacity of semantic value stack `yyvs13'

	yyvsp13: INTEGER
			-- Top of semantic value stack `yyvs13'

	yyspecial_routines13: KL_SPECIAL_ROUTINES [EPX_MIME_FIELD_MESSAGE_ID]
			-- Routines that ought to be in SPECIAL [EPX_MIME_FIELD_MESSAGE_ID]

	yyvs14: SPECIAL [EPX_MIME_FIELD_MIME_VERSION]
			-- Stack for semantic values of type EPX_MIME_FIELD_MIME_VERSION

	yyvsc14: INTEGER
			-- Capacity of semantic value stack `yyvs14'

	yyvsp14: INTEGER
			-- Top of semantic value stack `yyvs14'

	yyspecial_routines14: KL_SPECIAL_ROUTINES [EPX_MIME_FIELD_MIME_VERSION]
			-- Routines that ought to be in SPECIAL [EPX_MIME_FIELD_MIME_VERSION]

	yyvs15: SPECIAL [EPX_MIME_FIELD_MAILBOX_LIST]
			-- Stack for semantic values of type EPX_MIME_FIELD_MAILBOX_LIST

	yyvsc15: INTEGER
			-- Capacity of semantic value stack `yyvs15'

	yyvsp15: INTEGER
			-- Top of semantic value stack `yyvs15'

	yyspecial_routines15: KL_SPECIAL_ROUTINES [EPX_MIME_FIELD_MAILBOX_LIST]
			-- Routines that ought to be in SPECIAL [EPX_MIME_FIELD_MAILBOX_LIST]

	yyvs16: SPECIAL [EPX_MIME_FIELD_SET_COOKIE]
			-- Stack for semantic values of type EPX_MIME_FIELD_SET_COOKIE

	yyvsc16: INTEGER
			-- Capacity of semantic value stack `yyvs16'

	yyvsp16: INTEGER
			-- Top of semantic value stack `yyvs16'

	yyspecial_routines16: KL_SPECIAL_ROUTINES [EPX_MIME_FIELD_SET_COOKIE]
			-- Routines that ought to be in SPECIAL [EPX_MIME_FIELD_SET_COOKIE]

	yyvs17: SPECIAL [EPX_MIME_FIELD_TRANSFER_ENCODING]
			-- Stack for semantic values of type EPX_MIME_FIELD_TRANSFER_ENCODING

	yyvsc17: INTEGER
			-- Capacity of semantic value stack `yyvs17'

	yyvsp17: INTEGER
			-- Top of semantic value stack `yyvs17'

	yyspecial_routines17: KL_SPECIAL_ROUTINES [EPX_MIME_FIELD_TRANSFER_ENCODING]
			-- Routines that ought to be in SPECIAL [EPX_MIME_FIELD_TRANSFER_ENCODING]

	yyvs18: SPECIAL [EPX_MIME_FIELD_WWW_AUTHENTICATE]
			-- Stack for semantic values of type EPX_MIME_FIELD_WWW_AUTHENTICATE

	yyvsc18: INTEGER
			-- Capacity of semantic value stack `yyvs18'

	yyvsp18: INTEGER
			-- Top of semantic value stack `yyvs18'

	yyspecial_routines18: KL_SPECIAL_ROUTINES [EPX_MIME_FIELD_WWW_AUTHENTICATE]
			-- Routines that ought to be in SPECIAL [EPX_MIME_FIELD_WWW_AUTHENTICATE]

	yyvs19: SPECIAL [EPX_MIME_MAILBOX]
			-- Stack for semantic values of type EPX_MIME_MAILBOX

	yyvsc19: INTEGER
			-- Capacity of semantic value stack `yyvs19'

	yyvsp19: INTEGER
			-- Top of semantic value stack `yyvs19'

	yyspecial_routines19: KL_SPECIAL_ROUTINES [EPX_MIME_MAILBOX]
			-- Routines that ought to be in SPECIAL [EPX_MIME_MAILBOX]

	yyvs20: SPECIAL [DS_LINKABLE [EPX_MIME_MAILBOX]]
			-- Stack for semantic values of type DS_LINKABLE [EPX_MIME_MAILBOX]

	yyvsc20: INTEGER
			-- Capacity of semantic value stack `yyvs20'

	yyvsp20: INTEGER
			-- Top of semantic value stack `yyvs20'

	yyspecial_routines20: KL_SPECIAL_ROUTINES [DS_LINKABLE [EPX_MIME_MAILBOX]]
			-- Routines that ought to be in SPECIAL [DS_LINKABLE [EPX_MIME_MAILBOX]]

	yyvs21: SPECIAL [STDC_TIME]
			-- Stack for semantic values of type STDC_TIME

	yyvsc21: INTEGER
			-- Capacity of semantic value stack `yyvs21'

	yyvsp21: INTEGER
			-- Top of semantic value stack `yyvs21'

	yyspecial_routines21: KL_SPECIAL_ROUTINES [STDC_TIME]
			-- Routines that ought to be in SPECIAL [STDC_TIME]

	yyvs22: SPECIAL [EPX_MIME_PARAMETER]
			-- Stack for semantic values of type EPX_MIME_PARAMETER

	yyvsc22: INTEGER
			-- Capacity of semantic value stack `yyvs22'

	yyvsp22: INTEGER
			-- Top of semantic value stack `yyvs22'

	yyspecial_routines22: KL_SPECIAL_ROUTINES [EPX_MIME_PARAMETER]
			-- Routines that ought to be in SPECIAL [EPX_MIME_PARAMETER]

feature {NONE} -- Constants

	yyFinal: INTEGER is 291
			-- Termination state id

	yyFlag: INTEGER is -32768
			-- Most negative INTEGER

	yyNtbase: INTEGER is 58
			-- Number of tokens

	yyLast: INTEGER is 312
			-- Upper bound of `yytable' and `yycheck'

	yyMax_token: INTEGER is 301
			-- Maximum token id
			-- (upper bound of `yytranslate'.)

	yyNsyms: INTEGER is 162
			-- Number of symbols
			-- (terminal and nonterminal)

feature -- User-defined features




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
			parse_body
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
				last_line.wipe_out
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
					last_line.wipe_out
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
							last_line.wipe_out
							matching_boundary := False
						end
					else
						body.append_string (last_line)
						body.append_character (c)
						last_line.wipe_out
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

	read_string is
			-- Optimized version `read_character' which returns as many
			-- characters as possible in `last_string'.
		local
			c: CHARACTER
		do
			if last_string = Void then
				create last_string.make (4096)
			else
				last_string.wipe_out
			end
			if yy_content_area /= Void then
				from
					c := yy_content_area.item (yy_end)
				until
					c = yyEnd_of_buffer_character
				loop
					last_string.append_character (c)
					yy_end := yy_end + 1
					if c = yyNew_line_character then
						yy_line := yy_line + 1
						yy_column := 1
					else
						yy_column := yy_column + 1
					end
					c := yy_content_area.item (yy_end)
				end
			else
				from
					c := yy_content.item (yy_end)
				until
					c = yyEnd_of_buffer_character
				loop
					last_string.append_character (c)
					yy_end := yy_end + 1
					if c = yyNew_line_character then
						yy_line := yy_line + 1
						yy_column := 1
					else
						yy_column := yy_column + 1
					end
					c := yy_content.item (yy_end)
				end
			end
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
			at_least_one_character: end_of_input = last_string.is_empty
		end

	read_singlepart_body_without_boundary is
			-- Read `file' until `end_of_file'. Does handle any line length.
		require
			body_contains_text: is_text_body
		local
			body: EPX_MIME_BODY_TEXT
		do
			body ?= part.body
-- 			from
-- 				read_character
-- 			until
-- 				end_of_input
-- 			loop
-- 				body.append_character (last_character)
-- 				read_character
-- 			end
			from
				read_string
			until
				end_of_input
			loop
				body.append_string (last_string)
				read_string
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
