indexing

	description: "Abstract class that covers Posix semaphore routines."

	author: "Berend de Boer"
	date: "$Date: 2004/12/18 $"
	revision: "$Revision: #4 $"


deferred class

	POSIX_SEMAPHORE


inherit

	EPX_SEMAPHORE
		export
			{ANY} value
		end

end
