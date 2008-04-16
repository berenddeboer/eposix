indexing

	description: "Class that covers Windows child processes."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


deferred class

	WINDOWS_CHILD_PROCESS


inherit

	WINDOWS_PROCESS

	ABSTRACT_CHILD_PROCESS
		undefine
			raise_posix_error
		end


feature -- actions that parent may execute

	wait_for (suspend: BOOLEAN) is
			-- wait for this process to terminate. If `suspend' then we
			-- wait until the information about this process is available,
			-- else we return immediately.
			-- If suspend is False, check the terminated property to see
			-- if this child is really terminated.
		do
			-- to be implemented
		end


end
