indexing

	description: "Class that covers the Standard C numeric and monetary locale info."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	STDC_LOCALE_NUMERIC

inherit

	STDC_BASE

	CAPI_LOCALE
		rename
			posix_localeconv as lconv
		end


feature -- read-only properties

	local_currency_symbol: STRING is
			-- Local currency symbol for the current locale (e.g.,
			-- $ for United States.)
		do
			Result := sh.pointer_to_string (posix_lconv_currency_symbol (lconv))
		end

	local_digits: INTEGER is
			-- Number of digits after the decimal point
			-- formatted monetary quantities
		do
			Result := posix_lconv_frac_digits (lconv)
		end

	decimal_point: STRING is
			-- The character used to format non-monetary quantities
		do
			Result := sh.pointer_to_string (posix_lconv_decimal_point (lconv))
		end

	international_currency_symbol: STRING is
			-- International currency symbol for the current locale (e.g.,
			-- USD for United States.)
		do
			Result := sh.pointer_to_string (posix_lconv_int_curr_symbol (lconv))
		end

	international_digits: INTEGER is
			-- Number of digits after the decimal point for internationally
			-- formatted monetary quantities
		do
			Result := posix_lconv_int_frac_digits (lconv)
		end


end
