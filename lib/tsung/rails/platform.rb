module Tsung
  module Rails

    case RUBY_PLATFORM
    when /darwin/i
      TSUNG_LIB_BIN_DIR="/usr/local/lib/tsung/bin"
      TSUNG_TEMPLATES_DIR="/usr/local/share/tsung/templates"
    else
      TSUNG_LIB_BIN_DIR=""
      TSUNG_TEMPLATES_DIR=""
    end
  end
end
