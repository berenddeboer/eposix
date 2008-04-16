/*

Access to Standard C locale.h

*/

#include "c_locale.h"


/* constants */

EIF_INTEGER const_lc_ctype()
{
  return LC_CTYPE;
}

EIF_INTEGER const_lc_numeric()
{
  return LC_NUMERIC;
}

EIF_INTEGER const_lc_time()
{
  return LC_TIME;
}

EIF_INTEGER const_lc_collate()
{
  return LC_COLLATE;
}

EIF_INTEGER const_lc_monetary()
{
  return LC_MONETARY;
}

EIF_INTEGER const_lc_all()
{
  return LC_ALL;
}


/* functions */

EIF_POINTER posix_localeconv()
{
  return (EIF_POINTER) localeconv();
}

EIF_POINTER posix_setlocale(EIF_INTEGER category, const EIF_POINTER locale)
{
  return setlocale(category, locale);
}


/* lconv members */

EIF_POINTER posix_lconv_decimal_point(struct lconv *p)
{
  return p->decimal_point;
}

EIF_POINTER posix_lconv_thousands_sep(struct lconv *p)
{
  return p->thousands_sep;
}

EIF_POINTER posix_lconv_grouping(struct lconv *p)
{
  return p->grouping;
}

EIF_POINTER posix_lconv_int_curr_symbol(struct lconv *p)
{
  return p->int_curr_symbol;
}

EIF_POINTER posix_lconv_currency_symbol(struct lconv *p)
{
  return p->currency_symbol;
}

EIF_POINTER posix_lconv_mon_decimal_point(struct lconv *p)
{
  return p->mon_decimal_point;
}

EIF_POINTER posix_lconv_mon_thousands_sep(struct lconv *p)
{
  return p->mon_thousands_sep;
}

EIF_POINTER posix_lconv_mon_grouping(struct lconv *p)
{
  return p->mon_grouping;
}

EIF_POINTER posix_lconv_positive_sign(struct lconv *p)
{
  return p->positive_sign;
}

EIF_POINTER posix_lconv_negative_sign(struct lconv *p)
{
  return p->negative_sign;
}

EIF_INTEGER posix_lconv_int_frac_digits(struct lconv *p)
{
  return p->int_frac_digits;
}

EIF_INTEGER posix_lconv_frac_digits(struct lconv *p)
{
  return p->frac_digits;
}

EIF_INTEGER posix_lconv_p_cs_precedes(struct lconv *p)
{
  return p->p_cs_precedes;
}

EIF_INTEGER posix_lconv_p_sep_by_space(struct lconv *p)
{
  return p->p_sep_by_space;
}

EIF_INTEGER posix_lconv_n_cs_precedes(struct lconv *p)
{
  return p->n_cs_precedes;
}

EIF_INTEGER posix_lconv_n_sep_by_space(struct lconv *p)
{
  return p->n_sep_by_space;
}

EIF_INTEGER posix_lconv_p_sign_posn(struct lconv *p)
{
  return p->p_sign_posn;
}

EIF_INTEGER posix_lconv_n_sign_posn(struct lconv *p)
{
  return p->n_sign_posn;
}
