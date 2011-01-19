  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Make a MySQL slave server lag behind its master.
  #
  # Maatkit::SlaveDelay.new( array, str, array)
  #
  class Maatkit::SlaveDelay

    attr_accessor :ask_pass # FALSE
    attr_accessor :charset # (No # value)
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_slave_delay.conf,/home/joel/.maatkit.conf,/home/joel/.mk_slave_delay.conf
    attr_accessor :continue # TRUE
    attr_accessor :daemonize # FALSE
    attr_accessor :defaults_file # (No # value)
    attr_accessor :delay # 3600
    attr_accessor :help # TRUE
    attr_accessor :host # (No # value)
    attr_accessor :interval # 60
    attr_accessor :log # (No # value)
    attr_accessor :password # (No # value)
    attr_accessor :pid # (No # value)
    attr_accessor :port # (No # value)
    attr_accessor :quiet # FALSE
    attr_accessor :run_time # (No # value)
    attr_accessor :set_vars # wait_timeout=10000
    attr_accessor :socket # (No # value)
    attr_accessor :use_master # FALSE
    attr_accessor :user # (No # value)
    attr_accessor :version # FALSE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_slave_delay

    #
    # Returns a new SlaveDelay Object
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

      unless @path_to_mk_slave_delay
        ostring = "mk-slave-delay "
      else
        ostring = @path_to_mk_slave_delay + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-slave-delay"
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

