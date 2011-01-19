  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Execute queries on multiple servers and check for differences.
  #
  # Maatkit::Upgrade.new( array, str, array)
  #
  class Maatkit::Upgrade

    attr_accessor :ask_pass # FALSE
    attr_accessor :base_dir # /tmp
    attr_accessor :charset # (No # value)
    attr_accessor :clear_warnings # TRUE
    attr_accessor :clear_warnings_table # (No # value)
    attr_accessor :compare # query_times,results,warnings
    attr_accessor :compare_results_method # CHECKSUM
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_upgrade.conf,/home/joel/.maatkit.conf,/home/joel/.mk_upgrade.conf
    attr_accessor :continue_on_error # FALSE
    attr_accessor :convert_to_select # FALSE
    attr_accessor :daemonize # FALSE
    attr_accessor :explain_hosts # FALSE
    attr_accessor :filter # (No # value)
    attr_accessor :fingerprints # FALSE
    attr_accessor :float_precision # (No # value)
    attr_accessor :help # TRUE
    attr_accessor :host # (No # value)
    attr_accessor :iterations # 1
    attr_accessor :limit # 95%:20
    attr_accessor :log # (No # value)
    attr_accessor :max_different_rows # 10
    attr_accessor :order_by # differences:sum
    attr_accessor :password # (No # value)
    attr_accessor :pid # (No # value)
    attr_accessor :port # (No # value)
    attr_accessor :query # (No # value)
    attr_accessor :report # TRUE
    attr_accessor :reports # differences,errors,queries,statistics
    attr_accessor :run_time # (No # value)
    attr_accessor :set_vars # wait_timeout=10000,query_cache_type=0
    attr_accessor :shorten # 1024
    attr_accessor :socket # (No # value)
    attr_accessor :temp_database # (No # value)
    attr_accessor :temp_table # mk_upgrade
    attr_accessor :user # (No # value)
    attr_accessor :version # FALSE
    attr_accessor :zero_query_times # FALSE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_upgrade

    #
    # Returns a new Upgrade Object
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

      unless @path_to_mk_upgrade
        ostring = "mk-upgrade "
      else
        ostring = @path_to_mk_upgrade + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-upgrade"
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

