indexing

	description:

		"MIME field that is a collection of email addresses"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_MIME_FIELD_MAILBOX_LIST


inherit

	EPX_MIME_FIELD


create

	make


feature -- Initialization

	make (a_name: STRING; an_mailbox_list: DS_LINKABLE [EPX_MIME_MAILBOX]) is
			-- Initialize unstructured field.
		require
			valid_name: is_valid_mime_name (a_name)
		local
			p: DS_LINKABLE [EPX_MIME_MAILBOX]
		do
			name := a_name
			create {DS_LINKED_LIST [EPX_MIME_MAILBOX]} mailbox_list.make
			from
				p := an_mailbox_list
			until
				p = Void
			loop
				mailbox_list.put_last (p.item)
				p := p.right
			end
		end


feature -- Access

	mailbox_list: DS_LIST [EPX_MIME_MAILBOX]

	name: STRING
			-- Name of MIME field;
			-- Names are case-insensitive.

	value: STRING is
			-- Contents of this field
		local
			mailbox: EPX_MIME_MAILBOX
		do
			from
				mailbox_list.start
			until
				mailbox_list.after
			loop
				if Result = Void then
					Result := ""
				else
					Result.append_string (once_comma_space)
				end
				mailbox := mailbox_list.item_for_iteration
				if mailbox.name /= Void then
					Result.append_character ('"')
					Result.append_string (mailbox.name)
					Result.append_string (once_double_quote_space)
				end
				Result.append_character ('<')
				Result.append_string (mailbox.email_address)
				Result.append_character ('>')
				mailbox_list.forth
			end
		end


feature {NONE} -- Implementation

	once_comma_space: STRING is ", "
	once_double_quote_space: STRING is "%" "


invariant

	mailbox_list_not_void: mailbox_list /= Void

end
