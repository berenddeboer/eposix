indexing

   description: "Class that covers Standard C locale.h."

   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

class 

   CAPI_LOCALE


feature {NONE}
   
   posix_localeconv: POINTER is
         -- Gets rules to format numeric quantities for the current locale
      external "C"
      end
   
   posix_setlocale (category: INTEGER; locale: POINTER): POINTER is
         -- Sets or queries a program's locale
      external "C"
      end


feature {NONE} -- C binding for members of lconv

   posix_lconv_decimal_point (a_lconv: POINTER): POINTER is
      external "C"
      end

   posix_lconv_thousands_sep (a_lconv: POINTER): POINTER is
      external "C"
      end

   posix_lconv_grouping (a_lconv: POINTER): POINTER is
      external "C"
      end

   posix_lconv_int_curr_symbol (a_lconv: POINTER): POINTER is
      external "C"
      end

   posix_lconv_currency_symbol (a_lconv: POINTER): POINTER is
      external "C"
      end

   posix_lconv_mon_decimal_point (a_lconv: POINTER): POINTER is
      external "C"
      end

   posix_lconv_mon_thousands_sep (a_lconv: POINTER): POINTER is
      external "C"
      end

   posix_lconv_mon_grouping (a_lconv: POINTER): POINTER is
      external "C"
      end

   posix_lconv_positive_sign (a_lconv: POINTER): POINTER is
      external "C"
      end

   posix_lconv_negative_sign (a_lconv: POINTER): POINTER is
      external "C"
      end

   posix_lconv_int_frac_digits (a_lconv: POINTER): INTEGER is
      external "C"
      end

   posix_lconv_frac_digits (a_lconv: POINTER): INTEGER is
      external "C"
      end

   posix_lconv_p_cs_precedes (a_lconv: POINTER): INTEGER is
      external "C"
      end

   posix_lconv_p_sep_by_space (a_lconv: POINTER): INTEGER is
      external "C"
      end

   posix_lconv_n_cs_precedes (a_lconv: POINTER): INTEGER is
      external "C"
      end

   posix_lconv_n_sep_by_space (a_lconv: POINTER): INTEGER is
      external "C"
      end

   posix_lconv_p_sign_posn (a_lconv: POINTER): INTEGER is
      external "C"
      end

   posix_lconv_n_sign_posn (a_lconv: POINTER): INTEGER is
      external "C"
      end


end -- class CAPI_LOCALE
