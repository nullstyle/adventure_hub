module AdventureHub
  class Reporter
    
    include Celluloid

    def initialize(io=$stdout)
      @io = io
      save_term_pos
    end

    def log(message)
      @io.puts message
      save_term_pos

      # save cursor position
    end
    
    def progress(label, current, total)
      return unless @io.tty?

      restore_term_pos
      #reset to saved cursor position
      @io.puts progress_line(label, current, total)
    end

    private
    def get_screen_width
      TermInfo.screen_size.last
    end

    def progress_line(label, current, total)
      line = "#{label} "
      progress_bar_length = get_screen_width - line.length
      progress_bar_body_length = progress_bar_length - 2 # [] removed from bar size


      percentage_complete = current / total.to_f
      chars_filled  = (progress_bar_body_length * percentage_complete).round
      progress_body = "=" * chars_filled

      line += "[#{progress_body.ljust(progress_bar_body_length)}]"
      line
    end

    def save_term_pos
      @io.printf "\033[s" if @io.tty?
    end

    def restore_term_pos
      @io.printf "\033[u" if @io.tty?
    end
  end
end