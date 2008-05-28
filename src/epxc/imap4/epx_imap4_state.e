indexing

	description: "IMAP4rev1 client state and state changes."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_IMAP4_STATE


create

	make


feature {NONE} -- Initialization

	make is
		do
			item := Not_authenticated_state
		end


feature -- Change state

	set_not_authenticated is
		do
			item := Not_authenticated_state
		ensure
			not_authenticated: is_not_authenticated
		end

	set_authenticated is
		require
			unauthenticated_or_selected:
				is_not_authenticated or else
				is_selected
		do
			item := Authenticated_state
		ensure
			authenticated: is_authenticated
		end

	set_selected is
		require
			authenticated_or_selected:
				is_authenticated or else
				is_selected
		do
			item := Selected_state
		ensure
			selected: is_selected
		end

	set_logged_out is
		require
			not_logged_out: not is_logged_out
		do
			item := Logout_state
		ensure
			logged_out: is_logged_out
		end


feature -- Status

	is_not_authenticated: BOOLEAN is
			-- Is client not-authenticated?
		do
			Result := item = Not_authenticated_state
		end

	is_authenticated: BOOLEAN is
			-- Is client authenticated?
		do
			Result := item = Authenticated_state
		end

	is_selected: BOOLEAN is
			-- Has client selected a mailbox?
		do
			Result := item = Selected_state
		end

	is_logged_out: BOOLEAN is
			-- Is client logged out?
		do
			Result := item = Logout_state
		end


feature {NONE} -- Implementation

	Not_authenticated_state,
	Authenticated_state,
	Selected_state,
	Logout_state: INTEGER is unique
			-- IMAP4rev1 has four states.

	is_valid_state (a_state: INTEGER): BOOLEAN is
		-- Is `a_state' a valid IMAP state?
		do
			Result :=
				a_state >= Not_authenticated_state and then
				a_state <= Logout_state
		end

	item: INTEGER
			-- Current state, one of four.

invariant

	state_is_valid: is_valid_state (item)

end
