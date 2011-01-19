  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Pipeline relay logs on a MySQL slave to pre-warm caches.
  #
  # Maatkit::SlavePrefetch.new( array, str, array)
  #
  class Maatkit::SlavePrefetch

    attr_accessor :ask_pass # FALSE
    attr_accessor :charset # (No # value)
    attr_accessor :check_interval # 16,1,1024
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_slave_prefetch.conf,/home/joel/.maatkit.conf,/home/joel/.mk_slave_prefetch.conf
    attr_accessor :continue_on_error # TRUE
    attr_accessor :daemonize # FALSE
    attr_accessor :database # (No # value)
    attr_accessor :defaults_file # (No # value)
    attr_accessor :dry_run # FALSE
    attr_accessor :errors # 0
    attr_accessor :execute # FALSE
    attr_accessor :help # TRUE
    attr_accessor :host # (No # value)
    attr_accessor :inject_columns # TRUE
    attr_accessor :io_lag # 1024
    attr_accessor :log # (No # value)
    attr_accessor :max_query_time # 1
    attr_accessor :num_prefix # FALSE
    attr_accessor :offset # 128
    attr_accessor :password # (No # value)
    attr_accessor :permit_regexp # (No # value)
    attr_accessor :pid # (No # value)
    attr_accessor :port # (No # value)
    attr_accessor :print # FALSE
    attr_accessor :print_nonrewritten # FALSE
    attr_accessor :progress # (No # value)
    attr_accessor :query_sample_size # 4
    attr_accessor :reject_regexp # (No # value)
    attr_accessor :relay_log # (No # value)
    attr_accessor :relay_log_dir # (No # value)
    attr_accessor :run_time # (No # value)
    attr_accessor :secondary_indexes # FALSE
    attr_accessor :sentinel # /tmp/mk_slave_prefetch_sentinel
    attr_accessor :set_vars # wait_timeout=10000
    attr_accessor :sleep # 1
    attr_accessor :socket # (No # value)
    attr_accessor :statistics # FALSE
    attr_accessor :stop # FALSE
    attr_accessor :threads # 2
    attr_accessor :tmpdir # /dev/null
    attr_accessor :user # (No # value)
    attr_accessor :version # FALSE
    attr_accessor :window # 4096

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_slave_prefetch

    #
    # Returns a new SlavePrefetch Object
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

      unless @path_to_mk_slave_prefetch
        ostring = "mk-slave-prefetch "
      else
        ostring = @path_to_mk_slave_prefetch + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-slave-prefetch"
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

