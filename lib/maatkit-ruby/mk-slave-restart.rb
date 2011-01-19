  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Watch and restart MySQL replication after errors.
  #
  # Maatkit::SlaveRestart.new( array, str, array)
  #
  class Maatkit::SlaveRestart

    attr_accessor :always # FALSE
    attr_accessor :ask_pass # FALSE
    attr_accessor :charset # (No # value)
    attr_accessor :check_relay_log # TRUE
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_slave_restart.conf,/home/joel/.maatkit.conf,/home/joel/.mk_slave_restart.conf
    attr_accessor :daemonize # FALSE
    attr_accessor :database # (No # value)
    attr_accessor :defaults_file # (No # value)
    attr_accessor :error_length # (No # value)
    attr_accessor :error_numbers # (No # value)
    attr_accessor :error_text # (No # value)
    attr_accessor :help # TRUE
    attr_accessor :host # (No # value)
    attr_accessor :log # (No # value)
    attr_accessor :max_sleep # 64
    attr_accessor :min_sleep # 0.015625
    attr_accessor :monitor # TRUE
    attr_accessor :password # (No # value)
    attr_accessor :pid # (No # value)
    attr_accessor :port # (No # value)
    attr_accessor :quiet # FALSE
    attr_accessor :recurse # (No # value)
    attr_accessor :recursion_method # (No # value)
    attr_accessor :run_time # (No # value)
    attr_accessor :sentinel # /tmp/mk_slave_restart_sentinel
    attr_accessor :set_vars # wait_timeout=10000
    attr_accessor :skip_count # 1
    attr_accessor :sleep # 1
    attr_accessor :socket # (No # value)
    attr_accessor :stop # FALSE
    attr_accessor :until_master # (No # value)
    attr_accessor :until_relay # (No # value)
    attr_accessor :user # (No # value)
    attr_accessor :verbose # 1
    attr_accessor :version # FALSE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_slave_restart

    #
    # Returns a new SlaveRestart Object
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

      unless @path_to_mk_slave_restart
        ostring = "mk-slave-restart "
      else
        ostring = @path_to_mk_slave_restart + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-slave-restart"
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

