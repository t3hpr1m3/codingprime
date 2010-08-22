module CustomControllerMatchers
  def require_authentication_for( method, action, *args )
    options = args.extract_options!
    RequireAuthenticationMatcher.new( method, action, options, self )
  end

  class RequireAuthenticationMatcher
    def initialize( method, action, args, context )
      @method = method
      @action = action
      @args = args
      @context = context
      @actual_exception = nil
    end

    def matches?( controller )
      @raised_permission_denied = false
      begin
        @context.send( @method, @action, @args )
      rescue Exceptions::PermissionDenied => @actual_exception
        @raised_permission_denied = true
      rescue Exception => @actual_exception
        foo = 'bar'
      end

      @raised_permission_denied 
    end

    def failure_message_for_should
      if @actual_exception.nil?
        "Expected PermissionDenied, but nothing was raised"
      else
        "Expected PermissionDenied, got #{@actual_exception.inspect}"
      end
    end

    def failure_message_for_should_not
      if @except.nil?
        'Not sure what happened'
      else
        "Expected the call to succeed, but #{@except.message} was raised"
      end
    end

    def description
      "require authentication for #{@action}"
    end
  end
end
