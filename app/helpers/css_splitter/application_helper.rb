module CssSplitter
  module ApplicationHelper
    def split_stylesheet_link_tag(*sources)
      options     = sources.extract_options!
      split_count = options.delete(:split_count) || 2

      sources.map do |source|
        split_sources = (2..split_count).map { |index| "#{source}_split#{index}" }
        split_options = options.dup
        if Rails.env == 'development' && !split_options.key?(:debug)
          split_options[:debug] = false
        end
        split_sources << split_options

        [
          stylesheet_link_tag(source, options),
          "<!--[if lte IE 9]>",
          stylesheet_link_tag(*split_sources),
          "<![endif]-->"
        ]
      end.flatten.join("\n").html_safe
    end
  end
end
