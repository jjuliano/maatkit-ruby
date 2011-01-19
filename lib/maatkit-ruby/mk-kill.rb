  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Kill MySQL queries that match certain criteria.
  #
  # Maatkit::Kill.new( array, str, array)
  #
  class Maatkit::Kill

    attr_accessor :all # FALSE
    attr_accessor :ask_pass # FALSE
    attr_accessor :busy_time # (No value)
    attr_accessor :charset # (No value)
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_kill.conf,/home/joel/.maatkit.conf,/home/joel/.mk_kill.conf
    attr_accessor :daemonize # FALSE
    attr_accessor :defaults_file # (No value)
    attr_accessor :execute_command # (No value)
    attr_accessor :heartbeat # FALSE
    attr_accessor :help # TRUE
    attr_accessor :host # (No value)
    attr_accessor :idle_time # (No value)
    attr_accessor :ignore_command # (No value)
    attr_accessor :ignore_db # (No value)
    attr_accessor :ignore_host # (No value)
    attr_accessor :ignore_info # (No value)
    attr_accessor :ignore_self # TRUE
    attr_accessor :ignore_state # Locked
    attr_accessor :ignore_user # (No value)
    attr_accessor :interval # 30
    attr_accessor :iterations # 1
    attr_accessor :kill # FALSE
    attr_accessor :kill_query # FALSE
    attr_accessor :log # (No value)
    attr_accessor :match_command # (No value)
    attr_accessor :match_db # (No value)
    attr_accessor :match_host # (No value)
    attr_accessor :match_info # (No value)
    attr_accessor :match_state # (No value)
    attr_accessor :match_user # (No value)
    attr_accessor :only_oldest # TRUE
    attr_accessor :password # (No value)
    attr_accessor :pid # (No value)
    attr_accessor :port # (No value)
    attr_accessor :print # FALSE
    attr_accessor :replication_threads # FALSE
    attr_accessor :run_time # (No value)
    attr_accessor :set_vars # wait_timeout=10000
    attr_accessor :socket # (No value)
    attr_accessor :user # (No value)
    attr_accessor :version # FALSE
    attr_accessor :wait_after_kill # (No value)
    attr_accessor :wait_before_kill # (No value)

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_kill

    #
    # Returns a new Kill Object
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

      unless @path_to_mk_kill
        ostring = "mk-kill "
      else
        ostring = @path_to_mk_kill + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-kill"
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

