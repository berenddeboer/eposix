class EX_HTTP1

create

	make

feature

	url: STRING is "http://www.freebsd.org/index.html"

	make is
		local
			uri: UT_URI
			client: EPX_HTTP_10_CLIENT
		do
			create uri.make (url)
			create client.make (uri.authority) -- www.freebsd.org
			client.get (uri.path) -- /index.html
			client.read_response
			print (client.body.as_string)
		end

end
