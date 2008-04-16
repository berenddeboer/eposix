indexing

	description: "Windows file descriptor set."

	author: "Berend de Boer"
	date: "$Date: 2007/03/02 $"
	revision: "$Revision: #2 $"


class

	EPX_DESCRIPTOR_SET


inherit

	ABSTRACT_DESCRIPTOR_SET


creation {ABSTRACT_SELECT}

	make


feature -- Status

	is_valid_descriptor (a_descriptor: ABSTRACT_DESCRIPTOR): BOOLEAN is
			-- Is `a_descriptor' a descriptor that can be added or
			-- removed from this set, or checked for its presence?
			-- Descriptor should be open and for Windows it must be a socket.
		local
			socket: EPX_SOCKET
		do
			socket ?= a_descriptor
			Result :=
				socket /= Void and then
				a_descriptor /= Void and then
				a_descriptor.is_open
		end

end
