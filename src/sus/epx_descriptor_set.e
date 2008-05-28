indexing

	description: "SUSv3 descriptor sets have a slightly different precondition than the Windows descriptor sets."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_DESCRIPTOR_SET


inherit

	ABSTRACT_DESCRIPTOR_SET


create {ABSTRACT_SELECT}

	make


feature -- Status

	is_valid_descriptor (a_descriptor: ABSTRACT_DESCRIPTOR): BOOLEAN is
			-- Is `a_descriptor' a descriptor that can be added or
			-- removed from this set, or checked for its presence?
			-- Descriptor should be open and its handle should be less
			-- than FD_SETSIZE.
		do
			Result :=
				a_descriptor /= Void and then
				a_descriptor.is_open and then
				a_descriptor.fd < abstract_api.FD_SETSIZE
		end


invariant

	highest_descriptor_value_less_than_max_size: highest_descriptor_value < abstract_api.FD_SETSIZE

end
