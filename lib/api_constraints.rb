# ***********************************************************************
# ***********************************************************************

# The ApiConstraints class is called in rails routes. It is used to check
# the 'Accept' request header to see which version is specified, which in
# turn routes the user to the correct end point, in order to recieve 
# correct data. If no 'Accept' request header is specifiec, or the header
# is specifiec incorrectly, the user is routed to the currect version of
# the API.

# ***********************************************************************
# ***********************************************************************

class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    @default || req.headers['Accept'].include?("version=v#{@version}")
  end
end