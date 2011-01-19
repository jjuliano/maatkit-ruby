  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Parses logs and more. Analyze, transform, filter, review and report on queries.
  #
  # Maatkit::QueryDigest.new( array, str, array)
  #
  class Maatkit::QueryDigest

    attr_accessor :ask_pass # FALSE
    attr_accessor :attribute_aliases # db|Schema
    attr_accessor :attribute_value_limit # 4294967296
    attr_accessor :aux_dsn # (No # value)
    attr_accessor :charset # (No # value)
    attr_accessor :check_attributes_limit # 1000
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_query_digest.conf,/home/joel/.maatkit.conf,/home/joel/.mk_query_digest.conf
    attr_accessor :continue_on_error # TRUE
    attr_accessor :create_review_history_table # FALSE
    attr_accessor :create_review_table # FALSE
    attr_accessor :daemonize # FALSE
    attr_accessor :defaults_file # (No # value)
    attr_accessor :embedded_attributes # (No # value)
    attr_accessor :execute # (No # value)
    attr_accessor :execute_throttle # (No # value)
    attr_accessor :expected_range # 5,10
    attr_accessor :explain # (No # value)
    attr_accessor :filter # (No # value)
    attr_accessor :fingerprints # FALSE
    attr_accessor :for_explain # TRUE
    attr_accessor :group_by # fingerprint
    attr_accessor :gzip # TRUE
    attr_accessor :help # TRUE
    attr_accessor :host # (No # value)
    attr_accessor :ignore_attributes # arg,cmd,insert_id,ip,port,Thread_id,timestamp,exptime,flags,key,res,val,server_id,offset,end_log_pos,Xid
    attr_accessor :inherit_attributes # db,ts
    attr_accessor :interval # .1
    attr_accessor :iterations # 1
    attr_accessor :limit # 95%:20
    attr_accessor :log # (No # value)
    attr_accessor :mirror # (No # value)
    attr_accessor :order_by # Query_time:sum
    attr_accessor :outliers # Query_time:1:10
    attr_accessor :password # (No # value)
    attr_accessor :pid # (No # value)
    attr_accessor :pipeline_profile # FALSE
    attr_accessor :port # (No # value)
    attr_accessor :print # FALSE
    attr_accessor :print_iterations # FALSE
    attr_accessor :processlist # (No # value)
    attr_accessor :progress # time,30
    attr_accessor :read_timeout # (No # value)
    attr_accessor :report # TRUE
    attr_accessor :report_all # FALSE
    attr_accessor :report_format # rusage,date,files,header,profile,query_report,prepared
    attr_accessor :report_histogram # Query_time
    attr_accessor :review # (No # value)
    attr_accessor :review_history # (No # value)
    attr_accessor :run_time # (No # value)
    attr_accessor :sample # (No # value)
    attr_accessor :save_results # (No # value)
    attr_accessor :select #
    attr_accessor :set_vars # wait_timeout=10000
    attr_accessor :shorten # 1024
    attr_accessor :show_all #
    attr_accessor :since # (No # value)
    attr_accessor :socket # (No # value)
    attr_accessor :statistics # FALSE
    attr_accessor :table_access # FALSE
    attr_accessor :tcpdump_errors # (No # value)
    attr_accessor :timeline # FALSE
    attr_accessor :type # slowlog
    attr_accessor :until # (No # value)
    attr_accessor :user # (No # value)
    attr_accessor :version # FALSE
    attr_accessor :watch_server # (No # value)
    attr_accessor :zero_admin # TRUE
    attr_accessor :zero_bool # TRUE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_query_digest

    #
    # Returns a new QueryDigest Object
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

      unless @path_to_mk_query_digest
        ostring = "mk-query-digest "
      else
        ostring = @path_to_mk_query_digest + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-query-digest"
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

