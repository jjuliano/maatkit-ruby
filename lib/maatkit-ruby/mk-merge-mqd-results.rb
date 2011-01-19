  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Merge multiple mk-query-digest reports into one.
  #
  # Maatkit::MergeMqdResults.new( array, str, array)
  #
  class Maatkit::MergeMqdResults

    #
    # Prompt for a password when connecting to MySQL.
    attr_accessor :ask_pass # FALSE

    #
    # short form: -A; type: string
    # Default character set.  If the value is utf8, sets Perl's binmode on STDOUT to utf8, passes the
    # mysql_enable_utf8 option to DBD::mysql, and runs SET NAMES UTF8 after connecting to MySQL.  Any other
    # value sets binmode on STDOUT without the utf8 layer, and runs SET NAMES after connecting to MySQL.
    attr_accessor :charset # (No # value)

    #
    # type: Array
    # Read this comma-separated list of config files; if specified, this must be the first option on the
    # command line.
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_merge_mqd_results.conf,/home/joel/.maatkit.conf,/home/joel/.mk_merge_mqd_results.conf

    #
    # short form: -F; type: string
    # Only read mysql options from the given file.  You must give an absolute pathname.
    attr_accessor :defaults_file # (No # value)

    #
    # type: array; default: 5,10
    # Explain items when there are more or fewer than expected.
    # Defines the number of items expected to be seen in the report as controlled by "--limit" and
    # "--outliers".  If there  are more or fewer items in the report, each one will explain why it was
    # included.
    attr_accessor :expected_range # 5,10

    #
    # type: DSN
    # Run EXPLAIN for the sample query with this DSN and print results.
    # This causes mk-merge-mqd-results to run EXPLAIN and include the output into the report.  For safety,
    # queries that appear to have a subquery that EXPLAIN will execute won't be EXPLAINed.  Those are
    # typically "derived table" queries of the form
    #   select ... from ( select .... ) der;
    attr_accessor :explain # (No # value)

    #
    # Add query fingerprints to the standard query analysis report.  This is mostly useful for debugging
    # purposes.
    attr_accessor :fingerprints # FALSE

    #
    # default: yes
    # Print extra information to make analysis easy.
    # This option adds code snippets to make it easy to run SHOW CREATE TABLE and SHOW TABLE STATUS for the
    # query's tables.  It also rewrites non-SELECT queries into a SELECT that might be helpful for
    # determining the non-SELECT statement's index usage.
    attr_accessor :for_explain # TRUE

    #
    # Show help and exit.
    attr_accessor :help # TRUE

    #
    # short form: -h; type: string
    # Connect to host.
    attr_accessor :host # (No # value)

    #
    # type: string; default: 95%:20
    # Limit output to the given percentage or count.
    # If the argument is an integer, report only the top N worst queries.  If the argument is an integer
    # followed by the "%" sign, report that percentage of the worst queries.  If the percentage is followed
    # by a colon and another integer, report the top percentage or the number specified by that integer,
    # whichever comes first.
    # See also "--outliers".
    attr_accessor :limit # 95%:20

    #
    # type: string; default: Query_time:sum
    # Sort events by this attribute and aggregate function.
    attr_accessor :order_by # Query_time:sum

    #
    # type: string; default: Query_time:1:10
    # Report outliers by attribute:percentile:count.
    # The syntax of this option is a comma-separated list of colon-delimited strings.  The first field is the
    # attribute by which an outlier is defined.  The second is a number that is compared to the attribute's
    # 95th percentile.  The third is optional, and is compared to the attribute's cnt aggregate.  Queries
    # that pass this specification are added to the report, regardless of any limits you specified in
    # "--limit".
    # For example, to report queries whose 95th percentile Query_time is at least 60 seconds and which are
    # seen at least 5 times, use the following argument:
    #   --outliers Query_time:60:5
    attr_accessor :outliers # Query_time:1:10

    #
    # short form: -p; type: string
    # Password to use when connecting.
    attr_accessor :password # (No # value)

    #
    # short form: -P; type: int
    # Port number to use for connection.
    attr_accessor :port # (No # value)

    #
    # type: Array; default: rusage,date,files,header,profile,query_report,prepared
    # Print these sections of the query analysis report.
    #   SECTION# # PRINTS
    #   ============ ==============================================================
    #   rusgae# #  CPU times and memory usage reported by ps
    #   date# # # Current local date and time
    #   files# #   Input files read/parse
    #   header# #  Summary of the entire analysis run
    #   profile# # Compact table of queries for an at-a-glance view of the report
    #   query_report Detailed information about each unique query
    #   prepared#   Prepared statements
    # The sections are printed in the order specified.  The rusage, date, files and header sections are
    # grouped together if specified together; other sections are separted by blank lines.
    attr_accessor :report_format # rusage,date,files,header,profile,query_report,prepared

    #
    # type: string; default: Query_time
    # Chart the distribution of this attribute's values.
    # The distribution chart is limited to time-based attributes, so charting "Rows_examined", for example,
    # will produce a useless chart.
    attr_accessor :report_histogram # Query_time

    #
    # type: string; default: wait_timeout=10000
    # Set these MySQL variables.  Immediately after connecting to MySQL, this string will be appended to SET
    # and executed.
    attr_accessor :set_vars # wait_timeout=10000

    #
    # type: int; default: 1024
    # Shorten long statements in reports.
    # Shortens long statements, replacing the omitted portion with a "/*... omitted ...*/" comment.  This
    # applies only to the output in reports, not to information stored other places.  It prevents a large
    # statement from causing difficulty in a report.  The argument is the preferred length of the shortened
    # statement.  Not all statements can be shortened, but very large INSERT and similar statements often
    # can; and so can IN() lists, although only the first such list in the statement will be shortened.
    # If it shortens something beyond recognition, you can find the original statement in the log, at the
    # offset shown in the report header.
    attr_accessor :shorten # 1024

    #
    # type: Hash
    # Show all values for these attributes.
    # By default mk-query-digest only shows as many of an attribute's value that fit on a single line.  This
    # option allows you to specify attributes for which all values will be shown (line width is ignored).
    # This only works for attributes with string values like user, host, db, etc.  Multiple attributes can be
    # specified, comma-separated.
    attr_accessor :show_all #

    #
    # short form: -S; type: string
    # Socket file to use for connection.
    attr_accessor :socket # (No # value)

    #
    # short form: -u; type: string
    # User for login if not current user.
    attr_accessor :user # (No # value)

    #
    # Show version and exit.
    attr_accessor :version # FALSE

    #
    # default: yes
    # Print 0% boolean values in report.
    attr_accessor :zero_bool # TRUE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_merge_mqd_results

    #
    # Returns a new MergeMqdResults Object
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

      unless @path_to_mk_merge_mqd_results
        ostring = "mk-merge-mqd-results "
      else
        ostring = @path_to_mk_merge_mqd_results + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-merge-mqd-results"
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

