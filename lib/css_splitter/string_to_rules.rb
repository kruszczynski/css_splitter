class StringToRules
  attr_reader :css_string

  def initialize(css_string)
    @css_string = css_string
  end

  def call
    strip_comments(css_string).chomp.scan /[^}]*}/
  end

  private

  def strip_comments(s)
    s.gsub(/\/\*.*?\*\//m, "")
  end
end