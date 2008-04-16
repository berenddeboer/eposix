indexing

	description: "Abstract class that covers Posix semaphore routines."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


deferred class

	POSIX_SEMAPHORE


inherit

	EPX_SEMAPHORE
		export
			{ANY} value
		end

end
