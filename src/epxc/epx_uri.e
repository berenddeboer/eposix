indexing

	description: "Class that splits an URI into its components."

	standards:
		"1. Based upon RFC 2396.%
		%2. Also takes into account the revised version:%
		%      http://www.apache.org/~fielding/uri/rev-2002/rfc2396bis.html%
		%3. See for issues and other examples:%
		%     http://www.apache.org/~fielding/uri/rev-2002/issues.html"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #8 $"

class

	EPX_URI


obsolete

		"2006-07-29: Use UT_URI instead."

inherit

	UT_URI


create

	make,
	make_resolve


end
