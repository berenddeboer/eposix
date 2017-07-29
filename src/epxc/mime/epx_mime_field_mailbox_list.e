note

	description:

		"MIME field that is a collection of email addresses"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer and others"
	license: "MIT License"


class

	EPX_MIME_FIELD_MAILBOX_LIST


inherit

	EPX_MIME_FIELD


create

	make


feature -- Initialization

	make (a_name: STRING; an_mailbox_list: detachable DS_LINKABLE [EPX_MIME_MAILBOX])
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
				not attached p
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

	value: STRING
			-- Contents of this field
		local
			mailbox: EPX_MIME_MAILBOX
		do
			create Result.make_empty
			from
				mailbox_list.start
			until
				mailbox_list.after
			loop
				if not Result.is_empty then
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

	once_comma_space: STRING = ", "
	once_double_quote_space: STRING = "%" "


invariant

	mailbox_list_not_void: mailbox_list /= Void

end
