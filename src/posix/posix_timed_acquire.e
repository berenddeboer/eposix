indexing

	description: "Given a semaphare, attempts for given seconds to acquire it."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	POSIX_TIMED_ACQUIRE


inherit

	POSIX_TIMED_COMMAND
		rename
			make as timed_make
		end


create

	make


feature -- Initialization

	make (a_seconds: INTEGER; a_semaphore: POSIX_SEMAPHORE) is
		require
			valid_seconds: a_seconds >= 1 and a_seconds <= 65535
			semaphore_not_void: a_semaphore /= Void
		do
			timed_make (a_seconds)
			semaphore := a_semaphore
		ensure
			seconds_set: seconds = a_seconds
			semaphore_set: semaphore = a_semaphore
		end


feature -- State

	semaphore: POSIX_SEMAPHORE


feature {NONE} -- Execution

	do_execute is
		do
			semaphore.acquire
		end


invariant

	valid_semaphore: semaphore /= Void


end
