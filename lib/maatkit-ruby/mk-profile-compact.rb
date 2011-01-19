  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Compact the output from mk-query-profiler.
  #
  # Maatkit::ProfileCompact.new( array, str, array)
  #
  class Maatkit::ProfileCompact

    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk-profile-compact.conf,/home/joel/.maatkit.conf,/home/joel/.mk-profile-compact.conf
    attr_accessor :headers # 2000
    attr_accessor :help # TRUE
    attr_accessor :mode # (No # value)
    attr_accessor :queries # (No # value)
    attr_accessor :version # FALSE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_profile_compact

    #
    # Returns a new ProfileCompact Object
    #
    def initialize()
    end

    #
    # Execute the command
    #
    def start(options = nil)
      tmp = Tempfile.new('tmp')
      command = option_string() + options.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    def config
      option_string()
    end

    private

    def option_string()

      unless @path_to_mk_profile_compact
        ostring = "mk-profile-compact "
      else
        ostring = @path_to_mk_profile_compact + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-profile-compact"
          if (tmp_value.is_a? TrueClass) || (tmp_value.is_a? FalseClass)
            ostring += "#{tmp_string} "
          else
            ostring += "#{tmp_string} #{tmp_value} "
          end
        end
      end

      return ostring

    end

  end

