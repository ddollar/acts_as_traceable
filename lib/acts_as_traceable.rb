module ActsAsTraceable
  
  LOG_MESSAGE = "[TRACE:%s:%s] %s#%s(%s)"

  def acts_as_traceable
    class_eval do
      def method_missing(method, *args, &block)
        traced_method = "__#{method}_traced__"
        raise NoMethodError.new("method #{method} does not exist") unless respond_to?(traced_method)
        
        class_name = self.class.to_s
        pretty_args = args.map { |arg| arg.inspect }.join(', ')
        id = Time.now.to_f
    
        puts(LOG_MESSAGE % [id, 'START', class_name, method, pretty_args])
        send(traced_method, *args, &block)
        puts(LOG_MESSAGE % [id, 'END', class_name, method, pretty_args])
      end
    end

    class << self
      def method_added(method)
        return if method.to_s.match(/^__.*__$/)
        return if method == :method_missing
        alias_method "__#{method}_traced__", method
        remove_method method
      end
    end
  end
end