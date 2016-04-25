class TravisProfilerFormatter < XCPretty::Formatter

  def initialize(use_unicode, colorize)
    super(use_unicode, colorize)
    @compilation_phases = []
    @current_compilation_phase = []
    @compilation_phase_end_times = []
  end

  # For each file that we compile, track the current timestamp
  def format_compile(file_name, file_path)
    mark_compilation(file_path, file_name)
    EMPTY;
  end

  def format_compile_command(compiler_command, file_path)
    mark_compilation(file_path, nil)
    EMPTY;
  end

  # Every time we enter the linking phase, we wrap up a compilation phase
  # Store statistics for the current phase and set up for a new phase
  def format_linking(file, build_variant, arch)
    start_new_compilation_phase
    EMPTY;
  end

  # When the build succeeded, we can generate our statistics and print them to the console
  def format_phase_success(phase_name)
    unless @current_compilation_phase.empty?
      start_new_compilation_phase
    end

    if phase_name == "BUILD"
      compile_times = calculate_compile_times
      compile_times.sort_by { | compilation |
        compilation[:compile_time]
      }.each do | compilation |
        puts "[#{format("%.4f", compilation[:compile_time])}] #{compilation[:file_path]}"
      end

      total_time = compile_times.reduce(0) { | acc, compilation |
        acc + compilation[:compile_time]
      }
      puts "-----"
      puts "[#{format("%.4f", total_time)}] Total compilation time"
    end
    EMPTY;
  end

  def mark_compilation(file_path, file_name)
    @current_compilation_phase.push({
      :start_time => Time.now,
      :file_path => file_path,
      :file_name => file_name
    })
  end

  def start_new_compilation_phase
    @compilation_phase_end_times.push(Time.now)
    @compilation_phases.push(@current_compilation_phase)
    @current_compilation_phase = []
  end

  def calculate_compile_times
    compile_times = []
    @compilation_phases.each_with_index do | compilation_phase, i |
      compilation_phase.each_with_index do | compilation, j |
        if j < (compilation_phase.count - 1) && compilation[:file_name]
          compile_times.push({
            :file_path => compilation[:file_path],
            :file_name => compilation[:file_name],
            :compile_time => compilation_phase[j+1][:start_time].to_f - compilation[:start_time].to_f
          })
        elsif j == compilation_phase.count - 1 && compilation[:file_name]
          compile_times.push({
            :file_path => compilation[:file_path],
            :file_name => compilation[:file_name],
            :compile_time => @compilation_phase_end_times[i].to_f - compilation[:start_time].to_f
          })
        end
      end
    end

    return compile_times
  end

  ###
  ### Travis Formatting
  ###
  # from https://github.com/kattrali/xcpretty-travis-formatter
  def open_fold(text)
    return if text == @open_fold
    close_fold(@open_fold) if @open_fold
    print "travis_fold:start:#{text}\r"
    @open_fold = text
  end

  def close_fold(text)
    print "travis_fold:end:#{text}\r"
    @open_fold = nil
  end

  def format_build_target(target, project, configuration)
    open_fold("Build")
    super
  end

  def format_analyze_target(target, project, configuration)
    open_fold("Analyze")
    super
  end

  def format_clean_target(target, project, configuration)
    open_fold("Clean")
    super
  end

  def format_test_run_started(name)
    open_fold("Tests-#{scrub(name)}")
    super
  end

  def format_test_run_finished(name, time)
    close_fold("Tests-#{scrub(name)}")
    super
  end

  def scrub(text)
    text.gsub(/\s/,"_").split(".").first
  end
end

TravisProfilerFormatter
