/*

Access to Standard C locale.h

*/

#ifndef _C_LOCALE_H_
#define _C_LOCALE_H_


#include "../supportc/eiffel.h"
#include <locale.h>


/* constants */

EIF_INTEGER const_lc_ctype();
EIF_INTEGER const_lc_numeric();
EIF_INTEGER const_lc_time();
EIF_INTEGER const_lc_collate();
EIF_INTEGER const_lc_monetary();
EIF_INTEGER const_lc_all();


/* functions */

EIF_POINTER posix_localeconv();
EIF_POINTER posix_setlocale(EIF_INTEGER category, const EIF_POINTER locale);


/* lconv members */

EIF_POINTER posix_lconv_decimal_point(struct lconv *p);
EIF_POINTER posix_lconv_thousands_sep(struct lconv *p);
EIF_POINTER posix_lconv_grouping(struct lconv *p);
EIF_POINTER posix_lconv_int_curr_symbol(struct lconv *p);
EIF_POINTER posix_lconv_currency_symbol(struct lconv *p);
EIF_POINTER posix_lconv_mon_decimal_point(struct lconv *p);
EIF_POINTER posix_lconv_mon_thousands_sep(struct lconv *p);
EIF_POINTER posix_lconv_mon_grouping(struct lconv *p);
EIF_POINTER posix_lconv_positive_sign(struct lconv *p);
EIF_POINTER posix_lconv_negative_sign(struct lconv *p);
EIF_INTEGER posix_lconv_int_frac_digits(struct lconv *p);
EIF_INTEGER posix_lconv_frac_digits(struct lconv *p);
EIF_INTEGER posix_lconv_p_cs_precedes(struct lconv *p);
EIF_INTEGER posix_lconv_p_sep_by_space(struct lconv *p);
EIF_INTEGER posix_lconv_n_cs_precedes(struct lconv *p);
EIF_INTEGER posix_lconv_n_sep_by_space(struct lconv *p);
EIF_INTEGER posix_lconv_p_sign_posn(struct lconv *p);
EIF_INTEGER posix_lconv_n_sign_posn(struct lconv *p);


#endif /* _C_LOCALE_H_ */
