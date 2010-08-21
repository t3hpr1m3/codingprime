class ApplicationConfigurationNode
  def initialize( data )
    data.each do |k,v|
      self.assign_value( k, v )
    end
  end

  def assign_value( name, val )
    if val.is_a?( Hash )
      self.instance_variable_set( "@#{name.to_s}".to_sym, ApplicationConfiguration.new( val ) )
    else
      self.instance_variable_set( "@#{name.to_s}".to_sym, val )
    end
  end

  def method_missing( name, *args )
    if name.to_s =~ /(.*)=$/
      self.assign_value( $1, args.first )
    else
      if self.instance_variable_defined?( "@#{name.to_s}".to_sym )
        self.instance_variable_get( "@#{name.to_s}".to_sym )
      else
        nil
      end
    end
  end
end

class ApplicationConfiguration < Rails::OrderedOptions
  def initialize
    config_file = "#{RAILS_ROOT}/config/config.yml"
    if File.exists?( config_file )
      config_hash = YAML.load_file( config_file )
      if config_hash.has_key?( RAILS_ENV )
        @parameters = ApplicationConfigurationNode.new( config_hash[RAILS_ENV] )
      end
    end
  end

  def method_missing( name, *args )
    @parameters.method_missing( name, args.first )
  end
end

::AppConfig = ApplicationConfiguration.new
