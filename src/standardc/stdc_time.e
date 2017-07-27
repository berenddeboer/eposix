note

	description: "Class that covers Standard C time related routines. %
	%Assumes that ANSI C is POSIX compliant, so time is defined with %
	%base January 1, 1970. So dates before 1970 and after 2038 are not %
	%really supported...%
	%Time resolutation is one second."

	author: "Berend de Boer"


class

	STDC_TIME

inherit

	STDC_BASE
		redefine
			is_equal
		end

	COMPARABLE
		redefine
			is_equal
		end

	HASHABLE
		redefine
			is_equal
		end

inherit {NONE}

	CAPI_TIME
		redefine
			is_equal
		end

	KL_GREGORIAN_CALENDAR
		redefine
			is_equal
		end


create

	make_date,
	make_date_time,
	make_from_dt_date_time,
	make_from_utc_dt_date_time,
	make_from_now,
	make_from_unix_time,
	make_time,
	make_utc_date,
	make_utc_date_time,
	make_utc_time,
	make_from_iso_8601


feature -- Initialization

	make_date (a_year, a_month, a_day: INTEGER)
			-- Create a time according to this day, time 00:00:00.
			-- Date is assumed to be a local date.
		require
			valid_date: is_valid_date (a_year, a_month, a_day)
		do
			make_date_time (a_year, a_month, a_day, 0, 0, 0)
		ensure
			time_zone_known: is_time_zone_known
			local_time: is_local_time
		end

	make_date_time (a_year, a_month, a_day, an_hour, a_minute, a_second: INTEGER)
			-- Date is assumed to be a local date.
			-- We assume daylight saving time setting in effect is
			-- available from system.
		require
			valid_date_and_time: is_valid_date_and_time (a_year, a_month, a_day, an_hour, a_minute, a_second)
		do
			do_make
			set_dst_to_current
			my_time_zone := local_time_zone
			set_date_time (a_year, a_month, a_day, an_hour, a_minute, a_second)
		ensure
			time_zone_known: is_time_zone_known
			local_time: is_local_time
		end

	make_date_time_without_dst (a_year, a_month, a_day, an_hour, a_minute, a_second: INTEGER)
			-- Date is assumed to be a date/time without daylight saving
			-- taken into account, such as a UTC based date/time.
		require
			valid_date_and_time: is_valid_date_and_time (a_year, a_month, a_day, an_hour, a_minute, a_second)
		do
			do_make
			set_dst_to_none
			my_time_zone := local_time_zone
			set_date_time (a_year, a_month, a_day, an_hour, a_minute, a_second)
		ensure
			time_zone_known: is_time_zone_known
			local_time: is_local_time

		end

	make_from_dt_date_time (a_date_time: DT_DATE_TIME_VALUE)
			-- Make from Gobo date time.
			-- Date is assumed to be a local date.
			-- We assume daylight saving time setting in effect is
			-- available from system.
		require
			valid_year: is_valid_date_and_time (a_date_time.year, a_date_time.month, a_date_time.day, a_date_time.hour, a_date_time.minute, a_date_time.second)
		do
			make_date_time (a_date_time.year, a_date_time.month, a_date_time.day, a_date_time.hour, a_date_time.minute, a_date_time.second)
		ensure
			time_zone_known: is_time_zone_known
			local_time: is_local_time
		end

	make_from_utc_dt_date_time (a_date_time: DT_DATE_TIME_VALUE)
			-- Make from Gobo date time.
			-- Date is assumed to be in UTC.
		require
			valid_year: is_valid_date_and_time (a_date_time.year, a_date_time.month, a_date_time.day, a_date_time.hour, a_date_time.minute, a_date_time.second)
		do
			make_utc_date_time (a_date_time.year, a_date_time.month, a_date_time.day, a_date_time.hour, a_date_time.minute, a_date_time.second)
		ensure
			time_zone_known: is_time_zone_known
			utc_time: is_utc_time
		end

	make_from_now
			-- Make `value' equal to current unix time.
			-- Afterwards call `to_local' or `to_utc' to turn individual
			-- fields in local time or in utc time.
		do
			make_from_unix_time (posix_time)
		ensure
			time_zone_not_set: not is_time_zone_known
		end

	make_from_unix_time (a_value: INTEGER)
			-- `a_value' is a time_t value.
			-- Afterwards call `to_local' or `to_utc' to turn individual
			-- fields in local time or in utc time.
		require
			valid_time: a_value >= 0
		do
			do_make
			value := a_value
			my_time_zone := 0
		ensure
			value_set: value = a_value
			time_zone_not_set: not is_time_zone_known
		end

	make_time (an_hour, a_minute, a_second: INTEGER)
			-- Time is assumed to be a local time.
			-- We assume daylight saving time setting in effect is
			-- available from system.
			-- Day will be January 1, `minimum_year'.
		obsolete "This routine is unsafe, use make_utc_time instead."
		require
			valid_time: is_valid_time (an_hour, a_minute, a_second)
		do
			make_date_time (minimum_year, 1, 1, an_hour, a_minute, a_second)
		ensure
			time_zone_known: is_time_zone_known
			local_time: is_local_time
		end

	make_utc_date (a_year, a_month, a_day: INTEGER)
			-- Create a time according to this day, time 00:00:00.
			-- Date is assumed to be in UTC.
		require
			valid_date: is_valid_date (a_year, a_month, a_day)
		do
			make_utc_date_time (a_year, a_month, a_day, 0, 0, 0)
		ensure
			time_zone_known: is_time_zone_known
			utc_time: is_utc_time
			year_set: a_year = year
			month_set: a_month = month
			day_set: a_day = day
		end

	make_utc_date_time (a_year, a_month, a_day, an_hour, a_minute, a_second: INTEGER)
			-- Date is assumed to be in UTC.
			-- Conversion to the unix time is done without taking into
			-- account leap seconds, as per the specification.
		require
			valid_date_and_time: is_valid_date_and_time (a_year, a_month, a_day, an_hour, a_minute, a_second)
		local
			some_value: INTEGER
			number_of_days_since_epoch: INTEGER
		do
			do_make
			set_dst_to_none
			my_time_zone := utc_time_zone
			-- Don't you love it when you have a formula you have no idea
			-- how it works, but it does somehow?
			-- Supposedly it appeared in Astronomical Computing, Sky &
			-- Telescope, May, 1984. I found it on the Internet in a
			-- posting by Larry Rosler in the form of Perl code.
			if a_month < 9 then
				some_value := -1
			else
				some_value := 1
			end
			number_of_days_since_epoch :=
				(367 * a_year - 678972 - 40587 + (275 * a_month // 9) +
				 a_day - ((
							  ((a_year + some_value * ((a_month - 9).abs // 7)) // 100)
							  + 1) * 3 // 4) -
				 (7 * (((a_month + 9) // 12) + a_year) // 4))
			value :=
				Seconds_in_day * number_of_days_since_epoch +
				Seconds_in_hour * an_hour +
				Seconds_in_minute * a_minute +
				a_second
			to_utc
		ensure
			year_set: a_year = year
			month_set: a_month = month
			day_set: a_day = day
			an_hour_set: an_hour = hour
			minute_set: a_minute = minute
			second_set: a_second = second
			time_zone_known: is_time_zone_known
			utc_time: is_utc_time
		end

	make_utc_time (an_hour, a_minute, a_second: INTEGER)
			-- Time is assumed to be UTC time at January 1, `minimum_year'.
			-- We assume daylight saving time setting in effect is
			-- available from system.
		require
			valid_time: is_valid_time (an_hour, a_minute, a_second)
		do
			make_utc_date_time (minimum_year, 1, 1, an_hour, a_minute, a_second)
		ensure
			time_zone_known: is_time_zone_known
			utc_time: is_utc_time
			an_hour_set: an_hour = hour
			minute_set: a_minute = minute
			second_set: a_second = second
		end

	make_from_iso_8601 (s: STRING)
			-- `s' should be in ISO 8601 format.
			-- Only full date and time are supported.
		require
			is_iso_8601_date_time: is_valid_iso_8601_date (s)
		local
			tz_hour,
			tz_minute,
			tz_seconds: INTEGER
		do
			iso_8601_rx.match (s)
			make_utc_date_time (iso_8601_rx.captured_substring (1).to_integer, iso_8601_rx.captured_substring (2).to_integer, iso_8601_rx.captured_substring (3).to_integer, iso_8601_rx.captured_substring (4).to_integer, iso_8601_rx.captured_substring (5).to_integer, iso_8601_rx.captured_substring (6).to_integer)
			if iso_8601_rx.match_count >= 7 and then iso_8601_rx.captured_substring (7) /~ "Z" then
				tz_hour := iso_8601_rx.captured_substring (8).to_integer
				tz_minute := iso_8601_rx.captured_substring (9).to_integer
				tz_seconds := tz_hour * 3600 + tz_minute * 60
				add_seconds (tz_seconds)
				to_utc
			end
		end


feature -- Make individual time fields valid

	is_local_time: BOOLEAN
			-- Is time in `local time'?
		do
			Result := my_time_zone = local_time_zone
		end

	is_utc_time: BOOLEAN
			-- Is the time zone UTC?
		do
			Result := my_time_zone = utc_time_zone
		end

	is_time_zone_known: BOOLEAN
			-- After a make routine, call either `to_local' or `to_utc'.
		do
			Result := my_time_zone /= 0
		ensure
			my_time_zone_set_implies_result: Result = (my_time_zone /= 0)
		end

	to_local
			-- Switch time fields to local time based on time in `value'.
		local
			p: POINTER
		do
			p := posix_localtime (value)
			tm.memory_copy (p, 0, 0, posix_tm_size)
			my_time_zone := local_time_zone
		ensure
			local_time: is_local_time
			time_zone_known: is_time_zone_known
		end

	to_utc
			-- Switch time fields to utc time based on time in `value'.
		local
			p: POINTER
		do
			p := posix_gmtime (value)
			tm.memory_copy (p, 0, 0, posix_tm_size)
			my_time_zone := utc_time_zone
			-- On FreeBSD 6.4 errno is set on first call???
			errno.clear
		ensure
			utc_time: is_utc_time
			time_zone_known: is_time_zone_known
		end


feature -- Change

	add_seconds (a_seconds: INTEGER)
			-- Add `a_seconds' to current time.
		do
			value  := value + a_seconds
		ensure
			definition: value = old value + a_seconds
		end


feature -- Manually set individual time fields

	set_date (a_year, a_month, a_day: INTEGER)
			-- Set date part, time remains unchanged, unless daylight
			-- savings has to be taken into account.
		require
			time_zone_known: is_time_zone_known
		do
			posix_set_tm_date (tm.ptr, a_year - 1900, a_month - 1, a_day)
			value := posix_mktime (tm.ptr)
		ensure
			year_set: old is_daylight_savings_in_effect implies year = a_year
			month_set: old is_daylight_savings_in_effect implies month = a_month
			day_set: old is_daylight_savings_in_effect implies day = a_day
		end

	set_date_time (a_year, a_month, a_day, an_hour, a_minute, a_second: INTEGER)
			-- Set individual time fields. Set `value' based on given
			-- fields, assuming that it is a local time.
			-- We assume daylight saving time setting in effect (or not)
			-- has been set.
		require
			time_zone_known: is_time_zone_known
			valid_date_and_time: is_valid_date_and_time (a_year, a_month, a_day, an_hour, a_minute, a_second)
		do
			posix_set_tm_date (tm.ptr, a_year - 1900, a_month - 1, a_day)
			posix_set_tm_time (tm.ptr, an_hour, a_minute, a_second)
			value := posix_mktime (tm.ptr)
			if value = -1 then
				debug ("STDC_TIME")
					print ("Invalid date: ")
					print (a_year.out)
					print ("-")
					print (a_month.out)
					print ("-")
					print (a_day.out)
					print (" ")
					print (an_hour.out)
					print (":")
					print (a_minute.out)
					print (":")
					print (a_second.out)
					print (".%N")
				end
				raise_posix_error
			end
		ensure
			year_set: old is_daylight_savings_in_effect implies year = a_year
			month_set: old is_daylight_savings_in_effect implies month = a_month
			day_set: old is_daylight_savings_in_effect implies day = a_day
			hour_set: old is_daylight_savings_in_effect implies hour = an_hour
			minute_set: old is_daylight_savings_in_effect implies minute = a_minute
			second_set: old is_daylight_savings_in_effect implies second = a_second
		end

	set_dst_to_current
			-- Let system figure out if daylight saving time is in effect.
		do
			posix_set_tm_isdst (tm.ptr, -1)
		end

	set_dst_to_none
			-- Daylight saving time is not in effect.
		do
			posix_set_tm_isdst (tm.ptr, 0)
		end

	set_dst_in_effect
			-- Daylight saving time is in effect.
		do
			posix_set_tm_isdst (tm.ptr, 1)
		end

	set_time (an_hour, a_minute, a_second: INTEGER)
			-- Set time part, date remains unchanged unless daylight
			-- savings has to be taken into account.
		require
			valid_time: is_valid_time (an_hour, a_minute, a_second)
		do
			posix_set_tm_time (tm.ptr, an_hour, a_minute, a_second)
			value := posix_mktime (tm.ptr)
		ensure
			hour_set: old is_daylight_savings_in_effect implies hour = an_hour
			minute_set: old is_daylight_savings_in_effect implies minute = a_minute
			second_set: old is_daylight_savings_in_effect implies minute = a_second
		end

	to_dos_seconds
			-- Make sure the seconds are divisible by two, a value DOS
			-- and clones like Windows NT like.
		do
			if value \\ 2 = 1 then
				if is_time_zone_known then
					set_time (hour, minute, second - 1)
				else
					value := value - 1
				end
			end
		ensure
			even_seconds: is_time_zone_known implies second \\ 2 = 0
			even_value: value \\ 2 = 0
		end


feature -- Individual time fields, need call to `to_local' or `to_utc'

	year: INTEGER
		require
			time_zone_known: is_time_zone_known
		do
			Result := 1900 + posix_tm_year (tm.ptr)
		ensure
			valid_year: year >= minimum_year
		end

	month: INTEGER
		require
			time_zone_known: is_time_zone_known
		do
			Result := posix_tm_mon (tm.ptr) + 1
		ensure
			valid_month: month >= 1 and month <= 12
		end

	day: INTEGER
			-- Day of the month.
		require
			time_zone_known: is_time_zone_known
		do
			Result := posix_tm_mday (tm.ptr)
		ensure
			valid_day: is_valid_day (year, month, Result)
		end

	weekday: INTEGER
			-- Days since Sunday.
		require
			time_zone_known: is_time_zone_known
		do
			Result := posix_tm_wday (tm.ptr)
		end

	day_of_year: INTEGER
			-- Days since January 1st
		require
			time_zone_known: is_time_zone_known
		do
			Result := posix_tm_yday (tm.ptr)
		end

	hour: INTEGER
		require
			time_zone_known: is_time_zone_known
		do
			Result := posix_tm_hour (tm.ptr)
		end

	minute: INTEGER
		require
			time_zone_known: is_time_zone_known
		do
			Result := posix_tm_min (tm.ptr)
		end

	second: INTEGER
		require
			time_zone_known: is_time_zone_known
		do
			Result := posix_tm_sec (tm.ptr)
		end

	is_daylight_savings_in_effect: BOOLEAN
			-- Does the broken down time take into account daylight savings?
		require
			time_zone_known: is_time_zone_known
		do
			Result := posix_tm_isdst (tm.ptr) = 1
		end

	is_daylight_savings_unknown: BOOLEAN
			-- Do we not know if the broken time includes daylight saving?
		require
			time_zone_known: is_time_zone_known
		do
			Result := posix_tm_isdst (tm.ptr) = -1
		end


feature -- Time as string

	short_weekday_name: STRING
			-- Abbreviated weekday name
		require
			time_zone_known: is_time_zone_known
		do
			Result := format ("%%a")
		ensure
			short_weekday_name_not_empty: raise_exception_on_error implies Result /= Void and then not Result.is_empty
		end

	weekday_name: STRING
			-- Full weekday name
		require
			time_zone_known: is_time_zone_known
		do
			Result := format ("%%A")
		ensure
			weekday_name_not_empty: raise_exception_on_error implies Result /= Void and then not Result.is_empty
		end

	short_month_name: STRING
			-- Abbreviated month name
		require
			time_zone_known: is_time_zone_known
		do
			Result := format ("%%b")
		ensure
			short_month_name_not_empty: raise_exception_on_error implies Result /= Void and then not Result.is_empty
		end

	month_name: STRING
			-- Full month name
		require
			time_zone_known: is_time_zone_known
		do
			Result := format ("%%B")
		ensure
			month_name_not_empty: raise_exception_on_error implies Result /= Void and then not Result.is_empty
		end

	format (format_str: STRING): STRING
			-- Formatted date/time according to `format_str'. See
			-- man strftime for details.
		require
			time_zone_known: is_time_zone_known
			format_str_not_empty: format_str /= Void and then not format_str.is_empty
		local
			p: STDC_BUFFER
			r: INTEGER
		do
			create p.allocate (128)
			r := posix_strftime (p.ptr, p.capacity, sh.string_to_pointer (format_str), tm.ptr)
			sh.unfreeze_all
			if r = 0 then
				p.deallocate
				raise_posix_error
				Result := ""
			else
				Result := sh.pointer_to_string (p.ptr)
				p.deallocate
			end
		ensure
			format_not_empty: raise_exception_on_error implies Result /= Void and then not Result.is_empty
		end

	default_format: STRING
			-- Time as string of the form "Mon Apr 17 21:49:20 2000"
		require
			time_zone_known: is_time_zone_known
		do
			Result := sh.pointer_to_string (posix_asctime (tm.ptr))
			Result.remove (Result.count)
		ensure
			default_format_not_empty: raise_exception_on_error implies Result /= Void and then not Result.is_empty
		end

	local_date_string: STRING
			-- Date part in format local to current country.
		require
			time_zone_known: is_time_zone_known
		do
			Result := format ("%%x")
		ensure
			local_date_string_not_empty: raise_exception_on_error implies Result /= Void and then not Result.is_empty
		end

	local_time_string: STRING
			-- Time part in format local to current country.
		require
			time_zone_known: is_time_zone_known
		do
			Result := format (once "%%X")
		ensure
			local_time_string_not_empty: raise_exception_on_error implies Result /= Void and then not Result.is_empty
		end

	rfc_date_string: STRING
			-- RFC 1123 (same as RFC 822) style date;
			-- i.e. Tue, 15 Nov 1994 08:12:31 GMT
		require
			time_zone_known: is_time_zone_known
		do
			if is_windows then
				if is_utc_time then
					-- For Windows, %z is just not obeyed...
					Result := format (once_rfc_822_format)
					Result.append_string (once_gmt)
				else
					Result := format (once_rfc_822_format_with_tz)
				end
			else
				Result := format (once_rfc_822_format_with_tz)
			end
		ensure
			rfc_date_string_not_empty: raise_exception_on_error implies Result /= Void and then not Result.is_empty
		end

	as_iso_8601: STRING
			-- Date in ISO8601 (XML Schema dateTime) format
		do
			if is_utc_time then
				Result := format (once_iso_8601_utc_format)
			else
				Result := format (once_iso_8601_format_with_tz)
			end
		end


feature -- Date calculations

	is_equal (other: like Current): BOOLEAN
		do
			Result := other.value = value
		end

	plus alias "+" (other: like Current): like Current
			-- Sum with `other'
		do
			create Result.make_from_unix_time (value + other.value)
			if is_utc_time then
				Result.to_utc
			elseif is_local_time then
				Result.to_local
			end
		ensure
			time_zone_same: my_time_zone = Result.my_time_zone
		end

	minus alias "-" (other: like Current): like Current
			-- Creates a new time which is the difference between
			-- `Current' and `Other'
		local
			diff: DOUBLE
		do
			diff := posix_difftime (value, other.value)
			create Result.make_from_unix_time (diff.truncated_to_integer)
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		local
			diff: DOUBLE
		do
			diff := posix_difftime (value, other.value)
			Result := diff < 0
		end


feature -- Status

	is_two_digit_year (a_year: INTEGER): BOOLEAN
			-- Is `a_year' a two digit year that can be handled by
			-- `four_digit_year'.
		do
			Result := a_year >= 0 and then a_year < 100
		end

	is_valid_date (a_year, a_month, a_day: INTEGER): BOOLEAN
			-- Do `a_year', `a_month' and `a_day' form a date recognized
			-- by this class?
			-- Because this class represents unix dates, only dates
			-- between 1970-Jan-01 UTC and 2038-Jan-19 UTC are valid.
		do
			Result :=
				a_year >= minimum_year and then a_year <= maximum_year and then
				a_month >= 1 and a_month <= 12 and then
				is_valid_day (a_year, a_month, a_day) and then
				(a_year /= 2038 or else (a_month = 1 and then a_day <= 19))
		end

	is_valid_date_and_time (a_year, a_month, a_day, an_hour, a_minute, a_second: INTEGER): BOOLEAN
			-- Do `a_year', `a_month' and `a_day' form a date that can be
			-- represented by this class?
			-- Because this class represents unix dates, only dates
			-- between 1970-Jan-01 00:00 UTC and 2038-Jan-19 03:14:08 UTC
			-- are valid.
		do
			-- Note: max_unix_time should not be expanded inline as at
			-- least SmartEiffel 1.2r5 creates incorrect code in that
			-- case.
			Result :=
				is_valid_date (a_year, a_month, a_day) and then
				is_valid_time (an_hour, a_minute, a_second) and then
				(a_year /= 2038 or else a_day /= 19 or else
				 ((an_hour * 3600 + a_minute * 60 + a_second) < max_unix_time))
		end

	is_valid_day (a_year, a_month, a_day: INTEGER): BOOLEAN
			-- Is `a_day' a valid day given year and month.
		require
			valid_year: a_year >= minimum_year
			valid_month: a_month >= 1 and a_month <= 12
		do
			Result := a_day >= 1 and then a_day <= days_in_month (a_month, a_year)
		ensure
			clearly_invalid_day: (a_day < 1 or a_day > 31) implies not Result
		end

	is_valid_time (an_hour, a_minute, a_second: INTEGER): BOOLEAN
			-- Do `an_hour', `a_minute' and `a_second' form a valid 24
			-- hour clock time?
		do
			Result :=
				an_hour >= 0 and an_hour <= 23 and then
				a_minute >= 0 and a_minute <= 59 and then
				a_second >= 0 and a_second <= 59
		end

	is_valid_iso_8601_date (s: STRING): BOOLEAN
			-- Is `s' in ISO 8601 format?
			-- Definition: https://en.wikipedia.org/wiki/ISO_8601
		local
			my_year,
			my_month,
			my_day: INTEGER
			my_hour,
			my_minute,
			my_second: INTEGER
			calendar: KL_GREGORIAN_CALENDAR
			tz_hour,
			tz_minute: INTEGER
		do
			create calendar
			iso_8601_rx.match (s)
			Result := iso_8601_rx.has_matched
			if Result then
				my_year := iso_8601_rx.captured_substring (1).to_integer
				my_month := iso_8601_rx.captured_substring (2).to_integer
				my_day := iso_8601_rx.captured_substring (3).to_integer
				my_hour := iso_8601_rx.captured_substring (4).to_integer
				my_minute := iso_8601_rx.captured_substring (5).to_integer
				my_second := iso_8601_rx.captured_substring (6).to_integer
				if iso_8601_rx.match_count >= 7 then
					tz_hour := iso_8601_rx.captured_substring (8).to_integer
					tz_minute := iso_8601_rx.captured_substring (9).to_integer
				end
				Result :=
					my_month >= calendar.January and then my_month <= calendar.December and then
					my_day >= 1 and then my_day <= calendar.days_in_month (my_month, my_year) and then
					my_hour >= 0 and then my_hour <= 23 and then
					my_minute >= 0 and then my_minute <= 59 and then
					my_second >= 0 and then my_second <= 59 and then
					tz_hour >= -14 and then tz_hour <= 14 and then
					tz_minute >= 0 and then tz_hour <= 59
			end
		end


feature -- Access

	current_year: INTEGER
			-- Current year.
		local
			now: STDC_TIME
		do
			create now.make_from_now
			now.to_utc
			Result := now.year
		ensure
			valid_year: Result >= minimum_year
		end

	four_digit_year (a_year: INTEGER): INTEGER
			-- Return a four digit year given a possibly two digit year.
		require
			valid_year:
				(a_year >= minimum_year) or else
				(a_year >= 0 and a_year < 100)
		do
			if a_year >= minimum_year then
				Result := a_year
			elseif a_year < 70 then
				Result := a_year + ((current_year // 100) * 100)
			else
				Result := a_year + (((current_year - 100) // 100) * 100)
			end
		ensure
			valid_year: Result >= minimum_year
			two_digits_retained: Result \\ 100 = a_year
		end

	hash_code: INTEGER
		do
			Result := value
		end

	minimum_year: INTEGER
			-- The minimum year for the current platform.
			-- For POSIX is 1970, for Windows is 1980.
		once
			if is_windows then
				Result := 1980
			else
				Result := 1970
			end
		ensure
			not_negative: Result >= 0
		end

	maximum_year: INTEGER
			-- The maximum Epoch year.
		do
			Result := 2038
		ensure
			greater_as_minimum: Result >= minimum_year
		end

	value: INTEGER
			-- Time in seconds since January 1, 1970.


feature -- Conversion

	as_dt_date_time: DT_DATE_TIME
			-- Date time in Gobo date time format.
			-- Always returns a new object.
		do
			create Result.make (year, month, day, hour, minute, second)
		ensure
			not_void: Result /= Void
		end


feature {STDC_TIME} -- Implementation

	my_time_zone: INTEGER
			-- Current time zone


feature {NONE} -- Implementation

	utc_time_zone,
	local_time_zone: INTEGER = unique
			-- Allowed values for `my_time_zone'

	tm: detachable STDC_BUFFER
			-- Buffer for struct tm

	assert_has_tm
		do
			if tm = Void then
				create tm.allocate_and_clear (posix_tm_size)
				set_dst_to_current
			end
		ensure
			tm_not_void: tm /= Void
		end

	do_make
			-- Common initialization for all creation routines.
		do
			assert_has_tm
		end

	is_windows: BOOLEAN
			-- Enable Windows quirks?
		external "C"
		end

	max_unix_time: INTEGER = 11648
			-- Denotes time, 03:14:08, on last Unix day, i.e.
			-- 03 * 3600 + 14 * 60 + 08

	unix_1980_timestamp: INTEGER = 315532800
			-- Gates trickery.


feature {NONE} -- ISO 8601 date internals

	once_iso_8601_format_with_tz: STRING = "%%FT%%H:%%M:%%S%%z"
	once_iso_8601_utc_format: STRING = "%%FT%%H:%%M:%%SZ"

	iso_8601_date_format: STRING = "(-?[0-9]{4})-([0-1][0-9])-([0-3][0-9])"
	iso_8601_time_format: STRING = "([0-2][0-9]):([0-5][0-9]):([0-5][0-9])"
	iso_8601_optional_time_zone_format: STRING = "(Z|([+\-][0-1][0-9]):([0-5][0-9]))?"

	iso_8601_rx: RX_PCRE_REGULAR_EXPRESSION
			-- Note: only supports full date time; week or dates without
			-- year are not supported.
		once
			create Result.make
			Result.compile (once "^" + iso_8601_date_format + once "T" + iso_8601_time_format + iso_8601_optional_time_zone_format + once "$")
		ensure
			compiled: Result.is_compiled
		end



feature {NONE} -- Once strings

	once_gmt: STRING = " GMT"
	once_rfc_822_format_with_tz: STRING = "%%a, %%d %%b %%Y %%H:%%M:%%S %%z"
	once_rfc_822_format: STRING = "%%a, %%d %%b %%Y %%H:%%M:%%S"


invariant

	tm_not_void: tm /= Void
	tm_has_proper_capacity: tm.capacity >= posix_tm_size
	value_not_negative: value >= 0
	my_time_zone_valid:
		my_time_zone = 0 or else
		my_time_zone = utc_time_zone or else
		my_time_zone = local_time_zone

end
