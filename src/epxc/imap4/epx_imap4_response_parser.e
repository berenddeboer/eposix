indexing

	description: "Parser for IMAP4 server responses."

	standards: "Follows RFC 3501"

	author: "Berend de Boer"
	date: "$Date: 2006/05/30 $"
	revision: "$Revision: #6 $"


class

	EPX_IMAP4_RESPONSE_PARSER


inherit

	YY_OLD_PARSER_SKELETON [ANY]
		rename
			make as make_parser
		end

	EPX_IMAP4_RESPONSE_SCANNER
		rename
			make as make_scanner
		end


creation

	make



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

feature {NONE} -- Semantic actions

	yy_do_action (yy_act: INTEGER) is
			-- Execute semantic action.
		local
			yyval2: STRING
			yyval3: INTEGER_REF
		do
			inspect yy_act
when 1 then
--|#line 126 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 126")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 2 then
--|#line 127 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 127")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 3 then
--|#line 131 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 131")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp := yyvsp - 5
	yyvs.put (yyval, yyvsp)
end
when 4 then
--|#line 136 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 136")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 5 then
--|#line 142 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 142")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 6 then
--|#line 149 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 149")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 7 then
--|#line 154 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 154")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 8 then
--|#line 158 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 158")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 9 then
--|#line 160 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 160")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 10 then
--|#line 168 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 168")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 11 then
--|#line 170 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 170")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 12 then
--|#line 172 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 172")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 13 then
--|#line 174 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 174")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 14 then
--|#line 176 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 176")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 15 then
--|#line 178 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 178")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 16 then
--|#line 180 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 180")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 17 then
--|#line 182 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 182")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 18 then
--|#line 184 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 184")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 19 then
--|#line 186 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 186")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 20 then
--|#line 188 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 188")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 21 then
--|#line 190 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 190")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 22 then
--|#line 192 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 192")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 23 then
--|#line 194 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 194")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 24 then
--|#line 196 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 196")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 25 then
--|#line 198 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 198")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 26 then
--|#line 200 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 200")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 27 then
--|#line 202 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 202")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 28 then
--|#line 204 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 204")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 29 then
--|#line 206 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 206")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 30 then
--|#line 208 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 208")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 31 then
--|#line 210 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 210")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 32 then
--|#line 212 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 212")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 33 then
--|#line 214 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 214")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 34 then
--|#line 216 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 216")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 35 then
--|#line 218 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 218")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 36 then
--|#line 220 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 220")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 37 then
--|#line 222 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 222")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 38 then
--|#line 227 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 227")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 39 then
--|#line 228 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 228")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 40 then
--|#line 232 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 232")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 41 then
--|#line 233 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 233")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 42 then
--|#line 237 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 237")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 43 then
--|#line 238 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 238")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 44 then
--|#line 244 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 244")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 45 then
--|#line 245 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 245")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 46 then
--|#line 246 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 246")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 47 then
--|#line 250 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 250")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 48 then
--|#line 251 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 251")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 49 then
--|#line 255 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 255")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 50 then
--|#line 256 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 256")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 51 then
--|#line 257 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 257")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 52 then
--|#line 258 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 258")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp := yyvsp - 3
	yyvs.put (yyval, yyvsp)
end
when 53 then
--|#line 262 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 262")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 54 then
--|#line 263 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 263")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 55 then
--|#line 267 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 267")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 56 then
--|#line 268 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 268")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 57 then
--|#line 269 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 269")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp := yyvsp - 3
	yyvs.put (yyval, yyvsp)
end
when 58 then
--|#line 273 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 273")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp := yyvsp - 4
	yyvs.put (yyval, yyvsp)
end
when 59 then
--|#line 277 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 277")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 60 then
--|#line 281 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 281")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp := yyvsp - 3
	yyvs.put (yyval, yyvsp)
end
when 61 then
--|#line 282 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 282")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 62 then
--|#line 286 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 286")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 63 then
--|#line 290 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 290")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 64 then
--|#line 294 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 294")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 65 then
--|#line 295 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 295")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 66 then
--|#line 299 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 299")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 67 then
--|#line 303 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 303")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 68 then
--|#line 307 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 307")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 69 then
--|#line 311 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 311")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 70 then
--|#line 312 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 312")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 71 then
--|#line 316 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 316")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 72 then
--|#line 317 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 317")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 73 then
--|#line 321 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 321")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 74 then
--|#line 325 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 325")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 75 then
--|#line 326 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 326")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 76 then
--|#line 327 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 327")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 77 then
--|#line 332 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 332")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 78 then
--|#line 336 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 336")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 79 then
--|#line 340 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 340")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp := yyvsp - 4
	yyvs.put (yyval, yyvsp)
end
when 80 then
--|#line 344 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 344")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 81 then
--|#line 349 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 349")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 82 then
--|#line 353 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 353")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 9
	yyvsp := yyvsp - 8
	yyvs.put (yyval, yyvsp)
end
when 83 then
--|#line 357 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 357")
end

			yyval := yyval_default;
yyval := yytype3 (yyvs.item (yyvsp)) 

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 84 then
--|#line 362 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 362")
end

			yyval := yyval_default;
yyval := yytype3 (yyvs.item (yyvsp)) 

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 85 then
--|#line 367 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 367")
end

			yyval := yyval_default;
yyval := yytype3 (yyvs.item (yyvsp)) 

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 86 then
--|#line 372 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 372")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 12
	yyvsp := yyvsp - 11
	yyvs.put (yyval, yyvsp)
end
when 87 then
--|#line 376 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 376")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 88 then
--|#line 377 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 377")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 89 then
--|#line 381 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 381")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 90 then
--|#line 382 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 382")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 91 then
--|#line 386 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 386")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 92 then
--|#line 390 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 390")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 93 then
--|#line 391 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 391")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 94 then
--|#line 395 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 395")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 95 then
--|#line 399 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 399")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 96 then
--|#line 403 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 403")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 97 then
--|#line 407 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 407")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 98 then
--|#line 408 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 408")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 99 then
--|#line 412 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 412")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 100 then
--|#line 413 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 413")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 101 then
--|#line 417 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 417")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 102 then
--|#line 418 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 418")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 103 then
--|#line 422 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 422")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 104 then
--|#line 424 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 424")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 105 then
--|#line 426 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 426")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 106 then
--|#line 428 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 428")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 107 then
--|#line 430 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 430")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 108 then
--|#line 432 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 432")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 109 then
--|#line 434 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 434")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 110 then
--|#line 436 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 436")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 111 then
--|#line 441 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 441")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 112 then
--|#line 442 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 442")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 113 then
--|#line 446 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 446")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 114 then
--|#line 451 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 451")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 115 then
--|#line 456 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 456")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 116 then
--|#line 457 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 457")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 117 then
--|#line 461 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 461")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 118 then
--|#line 462 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 462")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 119 then
--|#line 466 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 466")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 120 then
--|#line 467 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 467")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 121 then
--|#line 471 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 471")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 122 then
--|#line 475 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 475")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 123 then
--|#line 476 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 476")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 124 then
--|#line 480 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 480")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 125 then
--|#line 484 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 484")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 126 then
--|#line 488 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 488")
end


read_literal (yytype3 (yyvs.item (yyvsp - 2)).item); yyval2 := last_string 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp := yyvsp - 3
	yyvs.put (yyval, yyvsp)
end
when 127 then
--|#line 493 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 493")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 128 then
--|#line 495 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 495")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 129 then
--|#line 501 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 501")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 130 then
--|#line 502 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 502")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 131 then
--|#line 503 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 503")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 132 then
--|#line 504 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 504")
end

			yyval := yyval_default;
			if response.current_mailbox /= Void then
				response.current_mailbox.set_count (yytype3 (yyvs.item (yyvsp - 1)).item)
			end
		

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 133 then
--|#line 510 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 510")
end

			yyval := yyval_default;
			if response.current_mailbox /= Void then
				response.current_mailbox.set_recent (yytype3 (yyvs.item (yyvsp - 1)).item)
			end
		

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 134 then
--|#line 520 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 520")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 135 then
--|#line 522 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 522")
end



			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 136 then
--|#line 526 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 526")
end

			yyval := yyval_default;
			if yytype2 (yyvs.item (yyvsp - 1)) = Void or else yytype2 (yyvs.item (yyvsp - 1)).count = 1 then
				response.set_delimiter (yytype2 (yyvs.item (yyvsp - 1)))
			end
			-- @@BdB: here add mailbox to response.mailboxes
		

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp := yyvsp - 4
	yyvs.put (yyval, yyvsp)
end
when 137 then
--|#line 536 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 536")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 138 then
--|#line 537 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 537")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 139 then
--|#line 541 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 541")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 140 then
--|#line 542 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 542")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 141 then
--|#line 546 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 546")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 142 then
--|#line 547 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 547")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 143 then
--|#line 548 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 548")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 144 then
--|#line 553 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 553")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 145 then
--|#line 554 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 554")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 146 then
--|#line 555 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 555")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 147 then
--|#line 560 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 560")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 148 then
--|#line 561 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 561")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 149 then
--|#line 562 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 562")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 150 then
--|#line 564 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 564")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 151 then
--|#line 568 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 568")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 152 then
--|#line 572 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 572")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 153 then
--|#line 576 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 576")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 154 then
--|#line 580 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 580")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 155 then
--|#line 581 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 581")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 156 then
--|#line 585 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 585")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 157 then
--|#line 589 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 589")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 158 then
--|#line 590 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 590")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 159 then
--|#line 594 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 594")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 160 then
--|#line 595 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 595")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp := yyvsp - 4
	yyvs.put (yyval, yyvsp)
end
when 161 then
--|#line 595 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 595")
end

			yyval := yyval_default;
			if response.current_message /= Void then
				response.current_message.clear_flags
			end
		

if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 162 then
--|#line 602 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 602")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 163 then
--|#line 602 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 602")
end

			yyval := yyval_default;
expect_date_time 

if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 164 then
--|#line 603 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 603")
end

			yyval := yyval_default;
			if response.current_message /= Void then
				response.current_message.set_message (yytype2 (yyvs.item (yyvsp)))
			end
		

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 165 then
--|#line 609 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 609")
end

			yyval := yyval_default;
			if response.current_message /= Void then
				response.current_message.set_message_header (yytype2 (yyvs.item (yyvsp)))
			end
		

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 166 then
--|#line 615 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 615")
end

			yyval := yyval_default;
			if response.current_message /= Void then
				response.current_message.set_message_size (yytype3 (yyvs.item (yyvsp)).item)
			end
		

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 167 then
--|#line 621 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 621")
end

			yyval := yyval_default;
			if response.current_message /= Void then
				response.current_message.set_message_body (yytype2 (yyvs.item (yyvsp)))
			end
		

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 168 then
--|#line 627 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 627")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 169 then
--|#line 628 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 628")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 170 then
--|#line 629 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 629")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 171 then
--|#line 630 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 630")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp := yyvsp - 3
	yyvs.put (yyval, yyvsp)
end
when 172 then
--|#line 631 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 631")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 173 then
--|#line 635 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 635")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 174 then
--|#line 636 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 636")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 175 then
--|#line 640 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 640")
end

			yyval := yyval_default;
			if response.current_message /= Void then
				response.current_message.append_flag (yytype2 (yyvs.item (yyvsp)))
			end
		

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 176 then
--|#line 646 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 646")
end

			yyval := yyval_default;
			if response.current_message /= Void then
				response.current_message.append_flag (yytype2 (yyvs.item (yyvsp)))
			end
		

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 177 then
--|#line 655 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 655")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 178 then
--|#line 657 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 657")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 179 then
--|#line 662 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 662")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 180 then
--|#line 666 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 666")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 181 then
--|#line 670 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 670")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 182 then
--|#line 672 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 672")
end



			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 183 then
--|#line 676 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 676")
end


yyval3 := yytype3 (yyvs.item (yyvsp)) 
			yyval := yyval3
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 184 then
--|#line 681 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 681")
end


yyval3 := yytype3 (yyvs.item (yyvsp)) 
			yyval := yyval3
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 185 then
--|#line 689 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 689")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 186 then
--|#line 691 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 691")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 187 then
--|#line 693 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 693")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 188 then
--|#line 695 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 695")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 189 then
--|#line 697 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 697")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 190 then
--|#line 699 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 699")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 191 then
--|#line 704 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 704")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 192 then
--|#line 705 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 705")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 193 then
--|#line 709 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 709")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 194 then
--|#line 710 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 710")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 195 then
--|#line 714 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 714")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 196 then
--|#line 715 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 715")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 197 then
--|#line 720 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 720")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 198 then
--|#line 723 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 723")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 199 then
--|#line 724 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 724")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 200 then
--|#line 728 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 728")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 201 then
--|#line 729 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 729")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 202 then
--|#line 733 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 733")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 7
	yyvsp := yyvsp - 6
	yyvs.put (yyval, yyvsp)
end
when 203 then
--|#line 733 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 733")
end

			yyval := yyval_default;
			-- not needed, server closes connection, so we get a proper eof:
			--end_of_file_after_end_of_line := True
			response.set_bye
			scan_resp_text
		

if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 204 then
--|#line 733 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 733")
end

			yyval := yyval_default;
response.set_bye_response_text (yytype2 (yyvs.item (yyvsp - 1))) 

if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 205 then
--|#line 746 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 746")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 206 then
--|#line 747 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 747")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 7
	yyvsp := yyvsp - 6
	yyvs.put (yyval, yyvsp)
end
when 207 then
--|#line 747 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 747")
end

			yyval := yyval_default;
end_of_file_after_end_of_line := True 

if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 208 then
--|#line 747 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 747")
end

			yyval := yyval_default;
response.set_ok; scan_resp_text 

if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 209 then
--|#line 747 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 747")
end

			yyval := yyval_default;
response.set_response_text (yytype2 (yyvs.item (yyvsp))) 

if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 210 then
--|#line 757 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 757")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp := yyvsp - 3
	yyvs.put (yyval, yyvsp)
end
when 211 then
--|#line 757 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 757")
end

			yyval := yyval_default;
end_of_file_after_end_of_line := True 

if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 212 then
--|#line 768 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 768")
end

			yyval := yyval_default;
response.set_response_text (yytype2 (yyvs.item (yyvsp))) 

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 213 then
--|#line 768 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 768")
end

			yyval := yyval_default;
response.set_ok; scan_resp_text 

if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 214 then
--|#line 772 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 772")
end

			yyval := yyval_default;
response.set_response_text (yytype2 (yyvs.item (yyvsp))) 

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 215 then
--|#line 772 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 772")
end

			yyval := yyval_default;
response.set_no; scan_resp_text 

if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 216 then
--|#line 776 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 776")
end

			yyval := yyval_default;
response.set_response_text (yytype2 (yyvs.item (yyvsp))) 

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 217 then
--|#line 776 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 776")
end

			yyval := yyval_default;
response.set_bad; scan_resp_text 

if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 218 then
--|#line 783 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 783")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 219 then
--|#line 785 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 785")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 220 then
--|#line 787 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 787")
end



			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 221 then
--|#line 791 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 791")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 222 then
--|#line 792 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 792")
end

			yyval := yyval_default;
expect_resp_text 

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 223 then
--|#line 797 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 797")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 224 then
--|#line 798 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 798")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 225 then
--|#line 799 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 799")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp := yyvsp - 3
	yyvs.put (yyval, yyvsp)
end
when 226 then
--|#line 800 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 800")
end

			yyval := yyval_default;
			if response.current_mailbox /= Void then
				response.current_mailbox.set_is_writable (False)
			end
		

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 227 then
--|#line 806 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 806")
end

			yyval := yyval_default;
			if response.current_mailbox /= Void then
				response.current_mailbox.set_is_writable (True)
			end
		

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 228 then
--|#line 812 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 812")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 229 then
--|#line 813 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 813")
end

			yyval := yyval_default;
			if response.current_mailbox /= Void then
				response.current_mailbox.set_identifier (yytype3 (yyvs.item (yyvsp)).item)
			end
		

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 230 then
--|#line 819 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 819")
end

			yyval := yyval_default;
			if response.current_mailbox /= Void then
				response.current_mailbox.set_unseen (yytype3 (yyvs.item (yyvsp)).item)
			end
		

if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 231 then
--|#line 825 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 825")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 232 then
--|#line 829 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 829")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 233 then
--|#line 830 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 830")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 234 then
--|#line 834 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 834")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 235 then
--|#line 835 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 835")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 236 then
--|#line 842 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 842")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 237 then
--|#line 843 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 843")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 238 then
--|#line 844 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 844")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp := yyvsp - 3
	yyvs.put (yyval, yyvsp)
end
when 239 then
--|#line 849 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 849")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyvsp := yyvsp + 1
	if yyvsp >= yyvsc then
		yyvsc := yyvsc + yyInitial_stack_size
		yyvs := yy_special_routines.resize (yyvs, yyvsc)
		debug ("GEYACC")
			std.error.put_string ("Stack (yyvs) size increased to ")
			std.error.put_integer (yyvsc)
			std.error.put_new_line
		end
	end
	yyvs.put (yyval, yyvsp)
end
when 240 then
--|#line 850 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 850")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 241 then
--|#line 854 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 854")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 242 then
--|#line 855 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 855")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 243 then
--|#line 864 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 864")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 244 then
--|#line 865 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 865")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
end
when 245 then
--|#line 866 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 866")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp := yyvsp - 2
	yyvs.put (yyval, yyvsp)
end
when 246 then
--|#line 867 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 867")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 247 then
--|#line 871 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 871")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 248 then
--|#line 873 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 873")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 249 then
--|#line 878 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 878")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 250 then
--|#line 883 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 883")
end


yyval2 := yytype2 (yyvs.item (yyvsp)) 
			yyval := yyval2
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 251 then
--|#line 888 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 888")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp := yyvsp - 4
	yyvs.put (yyval, yyvsp)
end
when 252 then
--|#line 893 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 893")
end

			yyval := yyval_default;


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 253 then
--|#line 897 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 897")
end


yyval3 := yytype3 (yyvs.item (yyvsp)) 
			yyval := yyval3
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs.put (yyval, yyvsp)
end
when 254 then
--|#line 899 "epx_imap4_response_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'epx_imap4_response_parser.y' at line 899")
end


yyval3 := yytype3 (yyvs.item (yyvsp)); yyval3.set_item (-1 * yyval3.item) 
			yyval := yyval3
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp := yyvsp - 1
	yyvs.put (yyval, yyvsp)
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
			when 393 then
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
			    2,    2,    2,    2,   67,    2,    2,    2,    2,    2,
			   64,   65,   73,   66,    2,   68,   76,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,   77,    2,
			   71,    2,   72,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,   74,    2,   75,    2,    2,    2,    2,    2,    2,

			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,   69,    2,   70,    2,    2,    2,    2,
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

			   45,   46,   47,   48,   49,   50,   51,   52,   53,   54,
			   55,   56,   57,   58,   59,   60,   61,   62,   63, yyDummy>>)
		end

	yyr1_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			    0,   96,   96,   97,   99,  101,  100,   98,   78,   78,
			   79,   79,   79,   79,   79,   79,   79,   79,   79,   79,
			   79,   79,   79,   79,   79,   79,   79,   79,   79,   79,
			   79,   79,   79,   79,   79,   79,   79,   79,  102,  102,
			  105,  105,  106,  106,  107,  107,  107,  108,  108,  109,
			  109,  109,  109,  113,  113,  114,  114,  114,  116,  118,
			  111,  111,  119,  117,  112,  112,  123,  110,  120,  115,
			  115,  124,  124,  125,  103,  103,  103,  126,  104,  127,
			  128,  134,  135,  136,  137,  138,  132,  146,  146,  147,
			  147,  140,  142,  142,  148,  149,  141,  144,  144,  143,

			  143,  145,  145,   80,   80,   80,   80,   80,   80,   80,
			   80,  150,  150,   81,   82,  151,  151,  152,  152,  153,
			  153,  154,  155,  155,  156,  157,   86,   83,   83,  158,
			  158,  158,  158,  158,   84,   84,  159,  160,  160,  161,
			  161,  162,  162,  162,  129,  129,  129,  163,  163,  163,
			  163,  131,  130,  133,  164,  164,  165,  166,  166,  167,
			  167,  169,  167,  170,  167,  167,  167,  167,  167,  167,
			  167,  167,  167,  168,  168,  174,  174,   85,   85,  172,
			  121,   87,   87,   88,   89,   90,   90,   90,   90,   90,
			   90,  175,  175,  176,  176,  178,  178,  179,  179,  179,

			  177,  177,  182,  183,  185,  184,  184,  186,  187,  188,
			  181,  189,  180,  190,  180,  191,  180,  192,   91,   91,
			   91,  193,  193,  194,  194,  194,  194,  194,  194,  194,
			  194,  194,  195,  195,  122,  122,  171,  171,  171,  197,
			  197,  198,  198,  196,  196,  196,  196,   92,   92,   93,
			   94,  139,  173,   95,   95, yyDummy>>)
		end

	yytypes1_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			    1,    1,    1,    2,    1,    1,    1,    1,    1,    1,
			    1,    2,    2,    2,    2,    2,    2,    2,    3,    3,
			    3,    1,    1,    1,    1,    2,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    2,    2,    2,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    2,    2,    2,
			    2,    1,    2,    2,    2,    2,    2,    2,    2,    2,
			    1,    1,    1,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,

			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    1,    1,    1,    2,    1,    3,    3,    3,    3,
			    1,    1,    1,    1,    1,    1,    1,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    1,    1,
			    2,    2,    1,    1,    1,    1,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    1,    3,    3,    1,    1,
			    2,    2,    2,    2,    1,    3,    2,    2,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    2,    1,    2,    2,    2,    2,    2,    3,    1,
			    1,    2,    1,    2,    2,    2,    2,    2,    2,    2,

			    2,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    2,    2,    2,    3,    1,    1,    2,
			    1,    1,    1,    1,    3,    1,    2,    1,    2,    1,
			    2,    1,    1,    1,    1,    1,    1,    2,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    2,    1,    1,    1,    1,    1,    3,    2,    2,
			    2,    2,    1,    1,    2,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    2,    1,    1,    2,
			    1,    1,    3,    1,    2,    1,    1,    1,    3,    1,
			    1,    1,    1,    2,    1,    3,    1,    1,    1,    1,

			    1,    1,    1,    1,    2,    1,    2,    1,    2,    1,
			    1,    2,    1,    1,    1,    1,    3,    2,    1,    2,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    1,    1,    2,    3,    1,    1,    2,    1,    1,    1,
			    3,    1,    2,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    2,    1,    1,    3,    1,    1,    3,    1,
			    2,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    3,    3,    2,    1,    1,    1,    1,    1,    1,    3,
			    3,    1,    1,    1,    1,    2,    1,    1,    1,    2,
			    1,    3,    1,    1,    1,    1, yyDummy>>)
		end

	yytypes2_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			    1,    1,    1,    2,    2,    2,    2,    2,    3,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    2,    2,    2,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1, yyDummy>>)
		end

	yydefact_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			    0,    0,  221,  211,  195,    0,  192,  193,  196,  200,
			  201,  215,  213,  203,  217,    0,    0,    0,  184,    0,
			    0,    0,    0,    0,    0,    0,  220,    0,  191,  194,
			  221,  221,  221,  221,  137,  131,  130,    0,  129,  133,
			  132,    0,  154,  198,  199,  197,  232,    0,    0,    0,
			  227,  226,    0,  224,  223,    0,   81,  250,  249,  219,
			  218,    0,  214,  212,    0,  216,  113,  142,  141,  143,
			    0,  138,  139,   28,   22,   21,   25,   27,   29,   14,
			   11,   37,   34,   33,   32,   31,   20,   15,   13,   12,
			   18,   17,   30,   16,   24,   23,   19,  107,  106,  108,

			  105,  104,  103,   10,   26,   36,   35,  114,  111,  110,
			  109,    0,    0,  155,  233,  231,  183,  230,  229,  228,
			  117,  222,  210,  204,    0,  140,  121,  112,    0,    0,
			    0,    0,    0,  163,    0,    0,    0,    0,    0,  157,
			  116,  115,  119,    0,  118,  205,  190,  189,  188,  187,
			  186,  185,  180,    0,  134,  135,  184,  252,  172,    0,
			  248,  167,  247,  181,  182,  166,  165,  164,    0,    0,
			  159,    0,  169,    0,  168,    0,  161,  156,  158,  225,
			  120,  207,  202,  127,  128,    8,  136,    9,    0,    0,
			  162,   91,    0,  150,    0,    0,  149,  148,  147,    0,

			    0,   40,    0,    0,    0,   47,   47,   47,    0,    0,
			    0,    0,  236,    0,  243,  246,  239,    0,    0,  170,
			    0,  173,    0,    0,   83,    0,   96,    0,  152,  153,
			  151,  145,  146,   38,   39,   41,   53,   67,   74,   48,
			   49,   75,   76,    0,    0,   77,   70,    0,    0,  144,
			    0,    0,  244,    0,    0,  240,  237,    0,  171,  108,
			  177,  175,    0,  174,  208,  126,    0,    0,   93,    0,
			   78,   54,   55,    0,   50,   61,    0,    0,   71,   63,
			    0,    0,   66,   80,  124,    0,  122,  245,  241,  238,
			    0,  179,  160,  176,  221,   84,    0,    0,    0,    1,

			    0,  100,    0,    0,    0,    0,   64,   51,   73,   69,
			   72,   59,    0,    0,  125,  123,  242,  209,    0,    7,
			    0,   92,    2,    0,    0,   98,    0,   56,    0,  234,
			    0,    0,   44,   45,   52,   42,   62,    0,   79,    0,
			   85,    0,    4,    0,   99,    0,    0,  102,    0,   57,
			   60,   65,  235,    0,   43,   68,   58,  206,    0,    0,
			    6,    0,   97,    0,    0,   88,    0,   46,    0,    0,
			  253,    0,    5,    0,  101,    0,    0,   90,    0,    0,
			  254,   82,    3,   87,    0,   94,    0,    0,   89,   95,
			    0,  251,   86,    0,    0,    0, yyDummy>>)
		end

	yydefgoto_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			  284,  107,  141,  109,  110,  186,  153,  261,  160,  332,
			  333,   20,  162,   25,  163,   59,   60,  371,  298,  299,
			  320,  343,  361,  373,  172,  202,  203,  204,  334,  335,
			  238,  239,  240,  274,  307,  270,  271,  244,  245,  280,
			  312,  337,  356,  164,  330,  283,  277,  278,  205,  206,
			  207,  208,  229,  209,  170,  210,    4,  190,  225,  296,
			  341,  359,  192,  227,  269,  302,  326,  348,  366,  378,
			  386,  390,  111,  142,  143,  144,   38,  285,  286,  252,
			   21,   35,   70,   71,   72,  211,   22,  113,  138,  139,
			  262,  221,  168,  175,  220,  158,  263,  393,    5,    6,

			    7,    8,   23,    9,   10,   32,  182,  145,  222,  294,
			  339,   27,   31,   30,   33,   26,   55,  115,  217,  254,
			  255, yyDummy>>)
		end

	yypact_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			   21,  153,   72, -32768, -32768,   21, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768,  228,  228,  227,  158,  156,
			  129,  226,  225,  224,  493,  223,  155,  -10, -32768, -32768,
			   72,   72,   72,   72,  106, -32768, -32768,  672, -32768, -32768,
			 -32768,  221, -32768, -32768, -32768, -32768,  250,  124,  124,  124,
			 -32768, -32768,  205, -32768, -32768,  174, -32768, -32768, -32768, -32768,
			 -32768,  192, -32768, -32768,  189, -32768, -32768, -32768, -32768, -32768,
			  186,  106, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,

			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768,  428,  700, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			  552, -32768, -32768, -32768,  498, -32768, -32768, -32768,  147,  184,
			  124,  184,  184, -32768,  128,   93,  -46,  180,  185, -32768,
			 -32768, -32768, -32768,  177,  552,  238, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768,  307, -32768, -32768, -32768, -32768, -32768,  124,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,  171,  184,
			 -32768,  427, -32768,   18, -32768,   35, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,  165,  212,
			 -32768, -32768,  184, -32768,  492,  187, -32768, -32768, -32768,  492,

			  492, -32768,  169,  168,  483,  184,  184,  184,   34,   34,
			   34,  492, -32768,    8, -32768, -32768,  137,  135,  124, -32768,
			  184,  612,  150,  144, -32768,  127, -32768,   50, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768,   34, -32768, -32768, -32768,
			   43, -32768, -32768,  492,  184, -32768, -32768,  128,  124, -32768,
			  368,  125, -32768,  147,  102,  111, -32768,  113, -32768, -32768,
			 -32768, -32768,  101,  612, -32768, -32768,  161,  -11, -32768,   48,
			 -32768, -32768,   43,  492,  353, -32768,  492,  472, -32768, -32768,
			  184,   93, -32768, -32768, -32768,  236, -32768, -32768, -32768, -32768,
			  147, -32768, -32768, -32768,   72, -32768,   76,  184,   88, -32768,

			  -11, -32768,   36,  353,   34,  492, -32768,  295, -32768, -32768,
			 -32768, -32768,  184,  124, -32768, -32768, -32768, -32768,  134, -32768,
			  184, -32768, -32768,   74,  -11, -32768,   33,  295,   75, -32768,
			  452,  295, -32768, -32768,  295, -32768, -32768,  124, -32768,   56,
			 -32768,  105, -32768,  184, -32768,   70,  -11, -32768,   16,  295,
			 -32768, -32768, -32768,  140, -32768, -32768, -32768, -32768,   38,    7,
			 -32768,  184, -32768,   66,  -11, -32768,   13, -32768,  103,   91,
			 -32768,    6, -32768,   40, -32768,   62,  -11, -32768,  184,  -28,
			 -32768, -32768, -32768, -32768,   37, -32768,  184,   31, -32768, -32768,
			  -40, -32768, -32768,   30,   19, -32768, yyDummy>>)
		end

	yypgoto_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			  203, -142,  -27,   -2, -32768, -32768, -32768,   61,  190, -124,
			   -1, -112,  196,  -29, -140, -32768, -32768, -32768, -288, -289,
			 -32768, -32768, -32768, -32768, -119, -32768, -32768, -32768, -300, -320,
			   25, -32768, -32768,   49,   15, -32768, -32768, -215,   -7, -32768,
			 -32768, -32768, -32768, -118, -32768,    0, -32768,   32, -32768, -32768,
			 -32768, -32768,  -83, -32768,   68, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768,  175, -32768, -32768, -32768, -32768,   22,   57,
			 -32768,  283, -32768, -32768,  235, -32768, -32768, -32768, -32768,  162,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,  289,

			  288, -32768,  263, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, yyDummy>>)
		end

	yytable_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			   19,   62,   63,   64,   65,  161,  155,  166,  167,  322,
			  108,  185,  323,  187,  354,  370,  157,  174,  171,  395,
			  152,  272,  215,  152,    3,  392,  156,  349,  173,  354,
			  394,  353,   69,  354,  322,   14,  345,   12,   11,  391,
			  152,  152,  152,  152,  151,  191,  117,  118,  119,  387,
			  152,  219,  201,  297,  228,  152,  322,  152,  363,  228,
			  228,  216,  150,  149,  228,  148,  147,  146,  226,   69,
			  251,  228,  250,  381,  322,  369,  375,  376,  214,  213,
			  364,  237,  237,  237,  127,  235,  322,    2,  384,  328,
			  246,  246,  246,  212,    1,  322,  258,  346,  243,  380,

			  324,  297,  388,  276,  159,  382,  218,  273,  185,  268,
			  187,  379,  300,  358,  267,  368,  231,  232,  246,  357,
			  279,  236,  275,   68,   67,   66,  297,  383,  249,  165,
			  297,  374,  116,  304,  297,  362,  308,  276,  297,  344,
			  350,  288,  340,  185,  318,  187,   24,  152,  116,  151,
			  306,  301,  297,  321,  275,  156,  311,  171,  188,   58,
			   57,   18,  313,   42,   41,  329,  292,  150,  149,  295,
			  148,  147,  146,  319,   17,   16,   15,  289,  316,  306,
			   40,   39, -183, -183,  325,  291,  246,  290,  336,  250,
			  352,  152,  169,  151,  260,  266,  342,  264,   14,   13,

			   12,   11,  247,  248,  331,  367,  137,  265,  347,  159,
			  256,  150,  149,  253,  148,  147,  146,  257,  230,  360,
			  224,  136,  135,  134,  133,  132,  131,  130,  129,  128,
			  365,  241,  242,  234,  233,  223,  260,  372,  189,  106,
			  105,  181,  179,  104,  176,  151,  103,  282,  377,  121,
			  177,  124,  123,  159,  385,  122,  114,   96,   95,   94,
			   93,   92,  389,  150,  149,  317,  148,  147,  146,  120,
			   91,   90,   89,   88,   87,   86,   85,   84,   83,   82,
			   81,   80,   79,   78,   77,  112,   56,   45,   44,   43,
			   61,   37,   34,   29,   28,   76,   75,   74,   73,   36,

			  178,  314,  152,  116,  151,  159,  125,  315,  287,  310,
			  106,  105,  282,  338,  104,  281,  151,  103,  327,  180,
			  154,  303,  150,  149,  293,  148,  147,  146,   96,   95,
			   94,   93,   92,  183,  150,  149,  355,  148,  147,  146,
			    0,   91,   90,   89,   88,   87,   86,   85,   84,   83,
			   82,   81,   80,   79,   78,   77,  184,    0,    0,  331,
			  152,  200,  151,    0,  159,    0,   76,   75,   74,   73,
			    0,  106,  105,    0,    0,  104,  159,  151,  103,    0,
			  150,  149,    0,  148,  147,  146,    0,    0,    0,   96,
			   95,   94,   93,   92,    0,  150,  149,    0,  148,  147,

			  146,    0,   91,   90,   89,   88,   87,   86,   85,   84,
			   83,   82,   81,   80,   79,   78,   77,  305,    0,    0,
			    0,    0,  159,    0,    0,    0,    0,   76,   75,   74,
			   73,  106,  105,    0,    0,  104,  199,  159,  103,  102,
			  101,  100,   99,   98,   97,    0,    0,   66,    0,   96,
			   95,   94,   93,   92,  198,  197,  196,  195,    0,  194,
			  193,  151,   91,   90,   89,   88,   87,   86,   85,   84,
			   83,   82,   81,   80,   79,   78,   77,    0,    0,  150,
			  149,  151,  148,  147,  146,    0,    0,   76,   75,   74,
			   73,  171,  151,  126,    0,    0,  159,    0,    0,  150,

			  149,  151,  148,  147,  146,  152,    0,  151,    0,    0,
			  150,  149,    0,  148,  147,  146,    0,  351,    0,  150,
			  149,  159,  148,  147,  146,  150,  149,    0,  148,  147,
			  146,    0,    0,    0,    0,    0,    0,  309,    0,    0,
			    0,  159,   54,   53,   52,   51,   50,  171,   49,   48,
			   47,   46,  159,    0,    0,  106,  105,    0,    0,  104,
			    0,  159,  103,  102,  101,  100,   99,   98,   97,    0,
			    0,   66,  140,   96,   95,   94,   93,   92,    0,    0,
			    0,    0,    0,    0,    0,    0,   91,   90,   89,   88,
			   87,   86,   85,   84,   83,   82,   81,   80,   79,   78,

			   77,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,   76,   75,   74,   73,  106,  105,    0,    0,  104,
			    0,    0,  103,  102,  101,  100,  259,   98,   97,    0,
			    0,   66,    0,   96,   95,   94,   93,   92,    0,    0,
			    0,    0,    0,    0,    0,    0,   91,   90,   89,   88,
			   87,   86,   85,   84,   83,   82,   81,   80,   79,   78,
			   77,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,   76,   75,   74,   73,  106,  105,    0,    0,  104,
			    0,    0,  103,  102,  101,  100,   99,   98,   97,    0,
			    0,   66,    0,   96,   95,   94,   93,   92,    0,    0,

			    0,    0,    0,    0,    0,    0,   91,   90,   89,   88,
			   87,   86,   85,   84,   83,   82,   81,   80,   79,   78,
			   77,  137,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,   76,   75,   74,   73,    0,  136,  135,  134,  133,
			  132,  131,  130,  129,  128, yyDummy>>)
		end

	yycheck_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			    1,   30,   31,   32,   33,  129,  124,  131,  132,  298,
			   37,  153,  300,  153,  334,    8,  128,  136,   64,    0,
			    7,  236,    4,    7,    3,   65,    8,  327,   74,  349,
			    0,  331,   34,  353,  323,   45,  324,   47,   48,    8,
			    7,    7,    7,    7,    9,  169,   47,   48,   49,   77,
			    7,  175,  171,   64,  194,    7,  345,    7,  346,  199,
			  200,  173,   27,   28,  204,   30,   31,   32,  192,   71,
			   62,  211,   64,   67,  363,   68,  364,   64,   60,   61,
			   64,  205,  206,  207,  111,  204,  375,   66,  376,  304,
			  208,  209,  210,   75,   73,  384,  220,   64,   64,    8,

			   64,   64,   65,  243,   69,   65,   71,   64,  250,  227,
			  250,    8,   64,    8,   64,   77,  199,  200,  236,   63,
			  244,  204,  240,   17,   18,   19,   64,   65,  211,  130,
			   64,   65,    8,  273,   64,   65,  276,  277,   64,   65,
			   65,  253,    8,  285,   68,  285,   74,    7,    8,    9,
			  274,  269,   64,   65,  272,    8,  280,   64,  159,    4,
			    5,    8,  281,   34,   35,  305,   65,   27,   28,    8,
			   30,   31,   32,  297,   21,   22,   23,   75,  290,  303,
			   24,   25,   24,   25,  302,   72,  304,   76,  312,   64,
			  330,    7,   64,    9,  221,   68,  320,   47,   45,   46,

			   47,   48,  209,  210,   64,   65,   21,   63,  326,   69,
			   75,   27,   28,   76,   30,   31,   32,  218,   31,  343,
			    8,   36,   37,   38,   39,   40,   41,   42,   43,   44,
			  348,  206,  207,   65,   65,   70,  263,  361,   67,    3,
			    4,    3,   65,    7,   64,    9,   10,  248,  366,   75,
			   65,   65,   63,   69,  378,   63,    6,   21,   22,   23,
			   24,   25,  386,   27,   28,  294,   30,   31,   32,   64,
			   34,   35,   36,   37,   38,   39,   40,   41,   42,   43,
			   44,   45,   46,   47,   48,   64,   63,   63,   63,   63,
			   27,   64,   64,    5,    5,   59,   60,   61,   62,   16,

			  138,   65,    7,    8,    9,   69,   71,  285,  251,  277,
			    3,    4,  313,  313,    7,  247,    9,   10,  303,  144,
			  124,  272,   27,   28,  263,   30,   31,   32,   21,   22,
			   23,   24,   25,   26,   27,   28,  337,   30,   31,   32,
			   -1,   34,   35,   36,   37,   38,   39,   40,   41,   42,
			   43,   44,   45,   46,   47,   48,  153,   -1,   -1,   64,
			    7,  171,    9,   -1,   69,   -1,   59,   60,   61,   62,
			   -1,    3,    4,   -1,   -1,    7,   69,    9,   10,   -1,
			   27,   28,   -1,   30,   31,   32,   -1,   -1,   -1,   21,
			   22,   23,   24,   25,   -1,   27,   28,   -1,   30,   31,

			   32,   -1,   34,   35,   36,   37,   38,   39,   40,   41,
			   42,   43,   44,   45,   46,   47,   48,   64,   -1,   -1,
			   -1,   -1,   69,   -1,   -1,   -1,   -1,   59,   60,   61,
			   62,    3,    4,   -1,   -1,    7,    9,   69,   10,   11,
			   12,   13,   14,   15,   16,   -1,   -1,   19,   -1,   21,
			   22,   23,   24,   25,   27,   28,   29,   30,   -1,   32,
			   33,    9,   34,   35,   36,   37,   38,   39,   40,   41,
			   42,   43,   44,   45,   46,   47,   48,   -1,   -1,   27,
			   28,    9,   30,   31,   32,   -1,   -1,   59,   60,   61,
			   62,   64,    9,   65,   -1,   -1,   69,   -1,   -1,   27,

			   28,    9,   30,   31,   32,    7,   -1,    9,   -1,   -1,
			   27,   28,   -1,   30,   31,   32,   -1,   65,   -1,   27,
			   28,   69,   30,   31,   32,   27,   28,   -1,   30,   31,
			   32,   -1,   -1,   -1,   -1,   -1,   -1,   65,   -1,   -1,
			   -1,   69,   49,   50,   51,   52,   53,   64,   55,   56,
			   57,   58,   69,   -1,   -1,    3,    4,   -1,   -1,    7,
			   -1,   69,   10,   11,   12,   13,   14,   15,   16,   -1,
			   -1,   19,   20,   21,   22,   23,   24,   25,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   34,   35,   36,   37,
			   38,   39,   40,   41,   42,   43,   44,   45,   46,   47,

			   48,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   59,   60,   61,   62,    3,    4,   -1,   -1,    7,
			   -1,   -1,   10,   11,   12,   13,   14,   15,   16,   -1,
			   -1,   19,   -1,   21,   22,   23,   24,   25,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   34,   35,   36,   37,
			   38,   39,   40,   41,   42,   43,   44,   45,   46,   47,
			   48,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   59,   60,   61,   62,    3,    4,   -1,   -1,    7,
			   -1,   -1,   10,   11,   12,   13,   14,   15,   16,   -1,
			   -1,   19,   -1,   21,   22,   23,   24,   25,   -1,   -1,

			   -1,   -1,   -1,   -1,   -1,   -1,   34,   35,   36,   37,
			   38,   39,   40,   41,   42,   43,   44,   45,   46,   47,
			   48,   21,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   59,   60,   61,   62,   -1,   36,   37,   38,   39,
			   40,   41,   42,   43,   44, yyDummy>>)
		end

feature {NONE} -- Conversion

	yytype2 (v: ANY): STRING is
		require
			valid_type: yyis_type2 (v)
		do
			Result ?= v
		ensure
			definition: Result = v
		end

	yyis_type2 (v: ANY): BOOLEAN is
		local
			u: STRING
		do
			u ?= v
			Result := (u = v)
		end

	yytype3 (v: ANY): INTEGER_REF is
		require
			valid_type: yyis_type3 (v)
		do
			Result ?= v
		ensure
			definition: Result = v
		end

	yyis_type3 (v: ANY): BOOLEAN is
		local
			u: INTEGER_REF
		do
			u ?= v
			Result := (u = v)
		end


feature {NONE} -- Constants

	yyFinal: INTEGER is 395
			-- Termination state id

	yyFlag: INTEGER is -32768
			-- Most negative INTEGER

	yyNtbase: INTEGER is 78
			-- Number of tokens

	yyLast: INTEGER is 744
			-- Upper bound of `yytable' and `yycheck'

	yyMax_token: INTEGER is 318
			-- Maximum token id
			-- (upper bound of `yytranslate'.)

	yyNsyms: INTEGER is 199
			-- Number of symbols
			-- (terminal and nonterminal)

feature -- User-defined features



feature {NONE} -- Initialization

	make (a_response: EPX_IMAP4_RESPONSE) is
			-- Parse server response into `a_response'.
		require
			a_response_not_void: a_response /= Void
		do
			make_scanner
			make_parser
			response := a_response
		end


feature {NONE} -- Response

	response: EPX_IMAP4_RESPONSE
			-- Server response is stored here.


feature -- Character reading

	end_of_input: BOOLEAN is
			-- True if `read_character' hits end-of-file.
		do
			Result :=
				last_character = yyEnd_of_file_character and
				not input_buffer.filled
		end


feature {NONE} -- Scanning literals

	read_literal (nbytes: INTEGER) is
			-- Literal is expected to follow in next lines.
			-- This function seems to be at least 3 times faster than the
			-- commented-out function below when the input comes from an
			-- EPX_CHARACTER_INPUT_STREAM.
		require
			nbytes_not_negative: nbytes >= 0
		local
			i: INTEGER
			epx_input_buffer: EPX_STREAM_BUFFER
			file: EPX_CHARACTER_INPUT_STREAM
			buffer: STDC_BUFFER
			remaining: INTEGER
		do
			-- You would expect that a string filled with '%U' would skip
			-- filling itself when it got its memory through
			-- calloc. Unfortunately, that doesn't happen it seems.
			create last_string.make_filled ('%U', nbytes)
			-- First we read the bytes currently in our `input_buffer' cache.
			from
				i := 1
			until
				yy_end > input_buffer.count or else
				i > nbytes
			loop
				last_string.put (yy_content.item (yy_end), i)
				yy_end := yy_end + 1
				i := i + 1
			end
			-- And next the bytes coming through our socket
			-- Branch depending if we have an EPX_STREAM_BUFFER or not.
			remaining := (nbytes - i) + 1
			if remaining > 0 then
				epx_input_buffer ?= input_buffer
				if epx_input_buffer = Void then
					from
					until
						end_of_input or else
						i > nbytes
					loop
						read_character
						if not end_of_input then
							last_string.put (last_character, i)
							i := i + 1
						end
					end
				else
					file := epx_input_buffer.file
					create buffer.allocate (131072)
					from
					until
						remaining = 0 or else
						file.end_of_input
					loop
						file.read_buffer (buffer, 0, remaining.min (buffer.capacity))
						if not file.end_of_input then
							buffer.put_to_string (last_string, i, 0, file.last_read - 1)
							remaining := remaining - file.last_read
							i := i + file.last_read
						end
					end
					buffer.deallocate
				end
			end
		ensure
			last_string_not_void: last_string /= Void
			last_string_complete: last_string.count = nbytes or else end_of_input
		end

-- 	read_literal (nbytes: INTEGER) is
-- 			-- Literal is expected to follow in next lines.
-- 		require
-- 			nbytes_not_negative: nbytes >= 0
-- 		local
-- 			i: INTEGER
-- 		do
-- 			from
-- 				i := 1
-- 				--create last_string.make (nbytes)
-- 				create last_string.make_filled ('%U', nbytes)
-- 			until
-- 				end_of_input or else
-- 				i > nbytes
-- 			loop
-- 				read_character
-- 				--last_string.append_character (last_character)
-- 				last_string.put (last_character, i)
-- 				i := i + 1
-- 			end
-- -- 			debug ("imap4")
-- -- 				print ("@@@@@@@@read literal: %N")
-- -- 				print (last_string)
-- -- 				print ("%N")
-- -- 			end
-- 		ensure
-- 			last_string_not_void: last_string /= Void
-- 			last_string_complete: last_string.count = nbytes or else end_of_input
-- 		end


invariant

	response_not_void: response /= Void

end
