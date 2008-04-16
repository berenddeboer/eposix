indexing

	description: "Parser for the LDAP Data Interchange Format."

	standards: "RFC 2849"

	not_implemented: "loading resources from a url."

	author: "Berend de Boer"
	date: "$Date: 2006/04/14 $"
	revision: "$Revision: #1 $"


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
			yyval6: DS_LINKABLE [EPX_LDIF_ATTRIBUTE]
			yyval9: EPX_LDIF_ENTRY
			yyval3: INTEGER
			yyval2: STRING
			yyval10: BOOLEAN
			yyval5: EPX_LDIF_ATTRIBUTE
			yyval4: EPX_LDIF_ATTRIBUTE_DESCRIPTION
			yyval11: DS_LINKABLE [STRING]
			yyval8: DS_LINKABLE [EPX_LDIF_MOD_SPEC]
			yyval7: EPX_LDIF_MOD_SPEC
		do
			inspect yy_act
when 1 then
--|#line 104 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 104")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 2 then
--|#line 105 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 105")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 3 then
--|#line 109 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 109")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp3 := yyvsp3 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 4 then
--|#line 113 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 113")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp3 := yyvsp3 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 5 then
--|#line 117 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 117")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 6 then
--|#line 118 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 118")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 7 then
--|#line 122 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 122")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 8 then
--|#line 126 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 126")
end


if yy_parsing_status = yyContinue then
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
when 9 then
--|#line 127 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 127")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 10 then
--|#line 131 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 131")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 11 then
--|#line 132 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 132")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 12 then
--|#line 136 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 136")
end

attrval_record (yyvs2.item (yyvsp2)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp2 := yyvsp2 -1
	yyvsp6 := yyvsp6 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 13 then
--|#line 140 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 140")
end


if yy_parsing_status = yyContinue then
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
when 14 then
--|#line 141 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 141")
end

yyval6 := yyvs6.item (yyvsp6) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs6.put (yyval6, yyvsp6)
end
when 15 then
--|#line 145 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 145")
end

create yyval6.make (yyvs5.item (yyvsp5)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp6 := yyvsp6 + 1
	yyvsp5 := yyvsp5 -1
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
when 16 then
--|#line 146 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 146")
end

create yyval6.make (yyvs5.item (yyvsp5)); yyval6.put_right (yyvs6.item (yyvsp6)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp5 := yyvsp5 -1
	yyvs6.put (yyval6, yyvsp6)
end
when 17 then
--|#line 150 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 150")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 18 then
--|#line 151 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 151")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 19 then
--|#line 155 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 155")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp9 := yyvsp9 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 20 then
--|#line 160 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 160")
end

create yyval9.make_from_linkables (yyvs2.item (yyvsp2), yyvs1.item (yyvsp1 - 2), yyvs6.item (yyvsp6)); add_record (yyval9) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp9 := yyvsp9 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -4
	yyvsp6 := yyvsp6 -1
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
when 21 then
--|#line 161 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 161")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp9 := yyvsp9 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -5
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
when 22 then
--|#line 162 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 162")
end

change_record  (yyvs2.item (yyvsp2), yyvs8.item (yyvsp8)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp9 := yyvsp9 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -4
	yyvsp8 := yyvsp8 -1
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
when 23 then
--|#line 163 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 163")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp9 := yyvsp9 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -5
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
when 24 then
--|#line 167 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 167")
end


if yy_parsing_status = yyContinue then
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
when 25 then
--|#line 168 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 168")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 26 then
--|#line 172 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 172")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 27 then
--|#line 173 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 173")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 28 then
--|#line 177 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 177")
end

yyval3 := 1 
if yy_parsing_status = yyContinue then
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
when 29 then
--|#line 178 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 178")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp3 := yyvsp3 -1
	yyvsp1 := yyvsp1 -1
	yyvs3.put (yyval3, yyvsp3)
end
when 30 then
--|#line 178 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 178")
end

yyval3 := yyvs3.item (yyvsp3) 
if yy_parsing_status = yyContinue then
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
when 31 then
--|#line 182 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 182")
end

yyval3 := yyvs3.item (yyvsp3) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs3.put (yyval3, yyvsp3)
end
when 32 then
--|#line 187 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 187")
end

yyval3 := yyvs3.item (yyvsp3) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs3.put (yyval3, yyvsp3)
end
when 33 then
--|#line 192 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 192")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs2.put (yyval2, yyvsp2)
end
when 34 then
--|#line 196 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 196")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs2.put (yyval2, yyvsp2)
end
when 35 then
--|#line 197 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 197")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs2.put (yyval2, yyvsp2)
end
when 36 then
--|#line 201 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 201")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 37 then
--|#line 205 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 205")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 38 then
--|#line 209 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 209")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 39 then
--|#line 213 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 213")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 40 then
--|#line 217 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 217")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp1 := yyvsp1 -4
	yyvsp10 := yyvsp10 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 41 then
--|#line 221 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 221")
end


if yy_parsing_status = yyContinue then
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
when 42 then
--|#line 222 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 222")
end

yyval10 := yyvs10.item (yyvsp10) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs10.put (yyval10, yyvsp10)
end
when 43 then
--|#line 226 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 226")
end


if yy_parsing_status = yyContinue then
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
when 44 then
--|#line 227 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 227")
end


if yy_parsing_status = yyContinue then
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
when 45 then
--|#line 231 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 231")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp3 := yyvsp3 -1
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
when 46 then
--|#line 232 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 232")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp3 := yyvsp3 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 47 then
--|#line 236 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 236")
end

create yyval5.make (yyvs4.item (yyvsp4).attribute_type, yyvs4.item (yyvsp4).options, yyvs2.item (yyvsp2)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp5 := yyvsp5 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp2 := yyvsp2 -1
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
when 48 then
--|#line 240 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 240")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs2.put (yyval2, yyvsp2)
end
when 49 then
--|#line 241 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 241")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -3
	yyvs2.put (yyval2, yyvsp2)
end
when 50 then
--|#line 242 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 242")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp2 := yyvsp2 + 1
	yyvsp1 := yyvsp1 -4
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
when 51 then
--|#line 246 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 246")
end


if yy_parsing_status = yyContinue then
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
when 52 then
--|#line 247 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 247")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 53 then
--|#line 251 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 251")
end


if yy_parsing_status = yyContinue then
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
when 54 then
--|#line 255 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 255")
end

create yyval4.make (yyvs2.item (yyvsp2), yyvs11.item (yyvsp11)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 + 1
	yyvsp2 := yyvsp2 -1
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
when 55 then
--|#line 259 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 259")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp1 := yyvsp1 -1
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
when 56 then
--|#line 260 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 260")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 57 then
--|#line 264 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 264")
end


if yy_parsing_status = yyContinue then
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
when 58 then
--|#line 265 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 265")
end

yyval11 := yyvs11.item (yyvsp11) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs11.put (yyval11, yyvsp11)
end
when 59 then
--|#line 269 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 269")
end

create yyval11.make (yyvs2.item (yyvsp2)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp11 := yyvsp11 + 1
	yyvsp2 := yyvsp2 -1
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
when 60 then
--|#line 270 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 270")
end

create yyval11.make (yyvs2.item (yyvsp2)); yyval11.put_right (yyvs11.item (yyvsp11)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -1
	yyvs11.put (yyval11, yyvsp11)
end
when 61 then
--|#line 281 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 281")
end

yyval6 := yyvs6.item (yyvsp6) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs6.put (yyval6, yyvsp6)
end
when 62 then
--|#line 285 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 285")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 63 then
--|#line 289 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 289")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 10
	yyvsp1 := yyvsp1 -8
	yyvsp10 := yyvsp10 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 64 then
--|#line 293 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 293")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 65 then
--|#line 294 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 294")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 66 then
--|#line 298 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 298")
end

			if not yyvs2.item (yyvsp2).is_equal ("newrdn") then
				 report_error ("newrdn expected instead of " + yyvs2.item (yyvsp2))
				 abort
			end
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 67 then
--|#line 308 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 308")
end

			if not yyvs2.item (yyvsp2).is_equal ("deleteoldrdn") then
				 report_error ("deleteoldrdn expected instead of " + yyvs2.item (yyvsp2))
				 abort
			end
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 68 then
--|#line 318 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 318")
end

			if yyvs2.item (yyvsp2).is_equal ("1") then
				 yyval10 := True
			elseif yyvs2.item (yyvsp2).is_equal ("0") then
				yyval10 := False
			else
				 report_error ("0 or 1 expected instead of " + yyvs2.item (yyvsp2))
				 abort
			end
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp10 := yyvsp10 + 1
	yyvsp2 := yyvsp2 -1
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
when 69 then
--|#line 332 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 332")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 70 then
--|#line 333 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 333")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 71 then
--|#line 337 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 337")
end


if yy_parsing_status = yyContinue then
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
when 72 then
--|#line 338 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 338")
end

			if not yyvs2.item (yyvsp2 - 1).is_equal ("newsuperior") then
				 report_error ("newsuperior expected instead of " + yyvs2.item (yyvsp2 - 1))
				 abort
			end
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp2 := yyvsp2 -2
	yyvs1.put (yyval1, yyvsp1)
end
when 73 then
--|#line 348 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 348")
end

yyval8 := yyvs8.item (yyvsp8) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs8.put (yyval8, yyvsp8)
end
when 74 then
--|#line 352 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 352")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp8 := yyvsp8 + 1
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
when 75 then
--|#line 353 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 353")
end

yyval8 := yyvs8.item (yyvsp8) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs8.put (yyval8, yyvsp8)
end
when 76 then
--|#line 357 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 357")
end

create yyval8.make (yyvs7.item (yyvsp7)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp8 := yyvsp8 + 1
	yyvsp7 := yyvsp7 -1
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
when 77 then
--|#line 358 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 358")
end

create yyval8.make (yyvs7.item (yyvsp7)); yyval8.put_right (yyvs8.item (yyvsp8)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp7 := yyvsp7 -1
	yyvs8.put (yyval8, yyvsp8)
end
when 78 then
--|#line 362 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 362")
end

create yyval7.make (yyvs3.item (yyvsp3), yyvs4.item (yyvsp4), yyvs6.item (yyvsp6)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 7
	yyvsp7 := yyvsp7 + 1
	yyvsp3 := yyvsp3 -1
	yyvsp1 := yyvsp1 -4
	yyvsp4 := yyvsp4 -1
	yyvsp6 := yyvsp6 -1
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
when 79 then
--|#line 366 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 366")
end

yyval3 := 1 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp3 := yyvsp3 + 1
	yyvsp1 := yyvsp1 -1
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
when 80 then
--|#line 367 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 367")
end

yyval3 := 2 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp3 := yyvsp3 + 1
	yyvsp1 := yyvsp1 -1
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
when 81 then
--|#line 368 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 368")
end

yyval3 := 3 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp3 := yyvsp3 + 1
	yyvsp1 := yyvsp1 -1
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
when 82 then
--|#line 372 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 372")
end


if yy_parsing_status = yyContinue then
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
when 83 then
--|#line 373 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 373")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 84 then
--|#line 377 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 377")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 85 then
--|#line 381 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 381")
end


if yy_parsing_status = yyContinue then
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
when 86 then
--|#line 382 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 382")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 87 then
--|#line 386 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 386")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 88 then
--|#line 390 "epx_ldif_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_ldif_parser.y' at line 390")
end

			if yyvs2.item (yyvsp2).is_equal ("true") then
				 yyval10 := True
			elseif yyvs2.item (yyvsp2).is_equal ("false") then
				yyval10 := False
			else
				 report_error ("true or false expected")
				 abort
			end
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp10 := yyvsp10 + 1
	yyvsp2 := yyvsp2 -1
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
			when 142 then
					-- End-of-file expected action.
				report_eof_expected_error
			else
					-- Default action.
				report_error ("parse error")
			end
		end

feature {NONE} -- Table templates

	yytranslate_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			    0,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,   25,   22,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,   21,   24,
			   23,    2,    2,    2,    2,    2,    2,    2,    2,    2,
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
			   15,   16,   17,   18,   19,   20, yyDummy>>)
		end

	yyr1_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			    0,   57,   57,   58,   59,   60,   60,   62,   63,   63,
			   65,   65,   64,   56,   56,   41,   41,   61,   61,   66,
			   38,   38,   38,   38,   67,   67,   71,   71,   47,   47,
			   73,   52,   53,   37,   35,   35,   36,   29,   49,   30,
			   72,   44,   44,   75,   75,   74,   74,   28,   51,   51,
			   51,   46,   46,   76,   26,   27,   27,   45,   45,   48,
			   48,   33,   69,   70,   77,   77,   78,   80,   54,   79,
			   79,   81,   81,   34,   55,   55,   42,   42,   39,   40,
			   40,   40,   68,   68,   32,   43,   43,   31,   50, yyDummy>>)
		end

	yytypes1_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			    1,    1,    3,    3,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    3,    3,    3,    1,    1,
			    1,    1,    2,    9,    1,    1,    1,    1,    2,    1,
			    2,    1,    1,    2,    1,    1,    2,    2,    3,    2,
			    1,    4,    2,    5,    6,    1,    1,    1,    1,    1,
			    2,    2,    2,    2,    1,    1,    1,    2,    1,   11,
			    6,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			   11,    1,    1,   10,    1,    1,    2,    2,    1,    1,
			    1,    1,    1,    1,    6,    8,    1,    1,    1,    2,
			   10,    2,    1,    2,    1,    2,    2,   11,    1,    1,

			    1,    1,    1,    1,    1,    1,    7,    3,    8,    8,
			    6,    2,    1,    8,    1,    1,    1,    1,    1,    4,
			    1,    2,    2,    1,    1,    2,    2,    2,    1,    6,
			    6,    1,    1,    1,    2,   10,    1,    1,    2,    1,
			    2,    1,    1,    1,    1, yyDummy>>)
		end

	yytypes2_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			    1,    1,    1,    1,    1,    1,    1,    2,    2,    1,
			    1,    1,    1,    1,    1,    1,    1,    3,    2,    1,
			    1,    1,    1,    1,    1,    1, yyDummy>>)
		end

	yydefact_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			   28,   82,    8,   30,    1,    2,   83,    0,   10,    3,
			    4,    8,    0,    9,   17,    0,   32,   31,   11,    6,
			    0,   82,    0,   19,    7,   18,    0,   29,    0,   82,
			   33,    0,   24,    0,    0,    0,   36,   34,   45,   56,
			   82,    0,   57,   15,   12,    0,   25,   26,   55,   24,
			   87,   35,   84,   37,    0,    0,   82,    0,    0,   54,
			   16,   82,   27,   46,   41,   82,   82,   51,   47,   59,
			   58,    0,    0,   43,    0,   85,   52,   48,    0,   65,
			   64,    0,    0,    0,   20,   22,   21,   23,    0,   88,
			   42,   44,    0,   53,   50,   86,   49,   60,   74,   62,

			    0,    0,   40,   81,   80,   79,   76,   82,   75,   73,
			   61,    0,   82,   77,    0,   66,   82,    0,    0,    0,
			    0,   38,   69,    0,   13,   70,   39,    0,   82,   14,
			    0,   67,    0,    0,   68,    0,   78,   71,   82,   63,
			    0,   72,    0,    0,    0, yyDummy>>)
		end

	yydefgoto_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			   41,   42,   43,   51,  125,   52,   53,   84,   85,   30,
			   37,   22,   23,  106,  107,   44,  108,   96,   73,   59,
			   77,    2,   70,  122,   90,   57,    3,   17,  135,  109,
			  130,  142,    4,    5,    9,   10,   11,   12,   24,   13,
			   14,   45,   31,   86,   87,   46,   47,   15,   48,   92,
			   94,   88,  112,  118,  128,  139, yyDummy>>)
		end

	yypact_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			   77,   23,   60, -32768, -32768, -32768, -32768,   64,   60, -32768,
			 -32768,    2,   72, -32768,   -2,   59, -32768, -32768, -32768, -32768,
			   72,   -6,   58, -32768, -32768, -32768,   72, -32768,   56,   23,
			 -32768,   57,    0,   54,    3,   28, -32768, -32768,   51, -32768,
			   23,   35,   48,    3, -32768,   68, -32768,   63, -32768,   63,
			 -32768, -32768, -32768, -32768,   53,   53,   -7,   49,   43, -32768,
			 -32768,   23, -32768, -32768,   47,   23,   23,   45, -32768,   44,
			 -32768,   14,   50,   35,   32,   28, -32768, -32768,   43, -32768,
			 -32768,   42,   41,   39, -32768, -32768, -32768, -32768,   34, -32768,
			 -32768, -32768,   33, -32768, -32768, -32768, -32768, -32768,   15, -32768,

			    3,   37, -32768, -32768, -32768, -32768,   15,   23, -32768, -32768,
			 -32768,   31,   13, -32768,    3, -32768,   23,   30,   29,   27,
			   28, -32768, -32768,   36,    3, -32768, -32768,   24,   23, -32768,
			   16, -32768,   22,   18, -32768,   17, -32768,   26,   -6, -32768,
			    1, -32768,   19,    8, -32768, yyDummy>>)
		end

	yypgoto_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			  -22, -32768, -32768, -32768, -32768,   21,  -29, -32768, -32768,  -48,
			 -32768,  -15, -32768, -32768, -32768,  -42,  -17, -32768, -32768, -32768,
			 -32768, -32768,   10, -32768, -32768,   20, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768,   75,   73, -32768,   -5, -32768,   76,
			 -32768, -32768,   -1, -32768, -32768,   38, -32768, -32768,  -19, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, yyDummy>>)
		end

	yytable_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			    7,   60,   -5,   -8,   40,   28,   20,   39,  144,   26,
			   39,   33,    6,    6,   66,   29,   65,   38,    8,  143,
			   38,  141,    8,   83,   82,   81,   80,   79,   35,  105,
			  104,  103,    6,  138,  116,   63,   64,  137,  136,   55,
			  134,  133,    6,  127,  111,  131,   50,  124,  121,  123,
			   93,   69,  115,  102,  101,   67,   56,   89,  110,  100,
			   71,   99,   98,   76,   74,   75,   72,   40,   78,   68,
			   38,   61,   58,   54,   49,   36,   34,   21,   32,   27,
			    8,   16,  129,    1,   18,   62,   19,   25,   97,  113,
			  140,  126,  119,   91,    0,    0,   95,    0,    0,    0,

			    0,    0,    0,    0,    0,    0,  114,    0,    0,    0,
			    0,  117,    0,    0,    0,  120,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,  132, yyDummy>>)
		end

	yycheck_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			    1,   43,    0,    5,    4,   20,   11,    7,    0,   14,
			    7,   26,   19,   19,   21,   21,   23,   17,   20,    0,
			   17,   20,   20,    9,   10,   11,   12,   13,   29,   14,
			   15,   16,   19,    7,   21,   54,   55,   20,   20,   40,
			   18,   25,   19,    7,    7,   21,   18,   20,   18,   20,
			   18,    8,   21,   20,   20,   56,   21,    7,  100,   20,
			   61,   20,   20,   18,   65,   66,   19,    4,   24,   20,
			   17,    3,   24,   22,   20,   18,   20,    5,   20,   20,
			   20,   17,  124,    6,    8,   47,   11,   14,   78,  106,
			  138,  120,  114,   73,   -1,   -1,   75,   -1,   -1,   -1,

			   -1,   -1,   -1,   -1,   -1,   -1,  107,   -1,   -1,   -1,
			   -1,  112,   -1,   -1,   -1,  116,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,  128, yyDummy>>)
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

	yyvs4: SPECIAL [EPX_LDIF_ATTRIBUTE_DESCRIPTION]
			-- Stack for semantic values of type EPX_LDIF_ATTRIBUTE_DESCRIPTION

	yyvsc4: INTEGER
			-- Capacity of semantic value stack `yyvs4'

	yyvsp4: INTEGER
			-- Top of semantic value stack `yyvs4'

	yyspecial_routines4: KL_SPECIAL_ROUTINES [EPX_LDIF_ATTRIBUTE_DESCRIPTION]
			-- Routines that ought to be in SPECIAL [EPX_LDIF_ATTRIBUTE_DESCRIPTION]

	yyvs5: SPECIAL [EPX_LDIF_ATTRIBUTE]
			-- Stack for semantic values of type EPX_LDIF_ATTRIBUTE

	yyvsc5: INTEGER
			-- Capacity of semantic value stack `yyvs5'

	yyvsp5: INTEGER
			-- Top of semantic value stack `yyvs5'

	yyspecial_routines5: KL_SPECIAL_ROUTINES [EPX_LDIF_ATTRIBUTE]
			-- Routines that ought to be in SPECIAL [EPX_LDIF_ATTRIBUTE]

	yyvs6: SPECIAL [DS_LINKABLE [EPX_LDIF_ATTRIBUTE]]
			-- Stack for semantic values of type DS_LINKABLE [EPX_LDIF_ATTRIBUTE]

	yyvsc6: INTEGER
			-- Capacity of semantic value stack `yyvs6'

	yyvsp6: INTEGER
			-- Top of semantic value stack `yyvs6'

	yyspecial_routines6: KL_SPECIAL_ROUTINES [DS_LINKABLE [EPX_LDIF_ATTRIBUTE]]
			-- Routines that ought to be in SPECIAL [DS_LINKABLE [EPX_LDIF_ATTRIBUTE]]

	yyvs7: SPECIAL [EPX_LDIF_MOD_SPEC]
			-- Stack for semantic values of type EPX_LDIF_MOD_SPEC

	yyvsc7: INTEGER
			-- Capacity of semantic value stack `yyvs7'

	yyvsp7: INTEGER
			-- Top of semantic value stack `yyvs7'

	yyspecial_routines7: KL_SPECIAL_ROUTINES [EPX_LDIF_MOD_SPEC]
			-- Routines that ought to be in SPECIAL [EPX_LDIF_MOD_SPEC]

	yyvs8: SPECIAL [DS_LINKABLE [EPX_LDIF_MOD_SPEC]]
			-- Stack for semantic values of type DS_LINKABLE [EPX_LDIF_MOD_SPEC]

	yyvsc8: INTEGER
			-- Capacity of semantic value stack `yyvs8'

	yyvsp8: INTEGER
			-- Top of semantic value stack `yyvs8'

	yyspecial_routines8: KL_SPECIAL_ROUTINES [DS_LINKABLE [EPX_LDIF_MOD_SPEC]]
			-- Routines that ought to be in SPECIAL [DS_LINKABLE [EPX_LDIF_MOD_SPEC]]

	yyvs9: SPECIAL [EPX_LDIF_ENTRY]
			-- Stack for semantic values of type EPX_LDIF_ENTRY

	yyvsc9: INTEGER
			-- Capacity of semantic value stack `yyvs9'

	yyvsp9: INTEGER
			-- Top of semantic value stack `yyvs9'

	yyspecial_routines9: KL_SPECIAL_ROUTINES [EPX_LDIF_ENTRY]
			-- Routines that ought to be in SPECIAL [EPX_LDIF_ENTRY]

	yyvs10: SPECIAL [BOOLEAN]
			-- Stack for semantic values of type BOOLEAN

	yyvsc10: INTEGER
			-- Capacity of semantic value stack `yyvs10'

	yyvsp10: INTEGER
			-- Top of semantic value stack `yyvs10'

	yyspecial_routines10: KL_SPECIAL_ROUTINES [BOOLEAN]
			-- Routines that ought to be in SPECIAL [BOOLEAN]

	yyvs11: SPECIAL [DS_LINKABLE [STRING]]
			-- Stack for semantic values of type DS_LINKABLE [STRING]

	yyvsc11: INTEGER
			-- Capacity of semantic value stack `yyvs11'

	yyvsp11: INTEGER
			-- Top of semantic value stack `yyvs11'

	yyspecial_routines11: KL_SPECIAL_ROUTINES [DS_LINKABLE [STRING]]
			-- Routines that ought to be in SPECIAL [DS_LINKABLE [STRING]]

feature {NONE} -- Constants

	yyFinal: INTEGER is 144
			-- Termination state id

	yyFlag: INTEGER is -32768
			-- Most negative INTEGER

	yyNtbase: INTEGER is 26
			-- Number of tokens

	yyLast: INTEGER is 127
			-- Upper bound of `yytable' and `yycheck'

	yyMax_token: INTEGER is 275
			-- Maximum token id
			-- (upper bound of `yytranslate'.)

	yyNsyms: INTEGER is 82
			-- Number of symbols
			-- (terminal and nonterminal)

feature -- User-defined features



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
