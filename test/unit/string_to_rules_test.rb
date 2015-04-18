require 'test_helper'

class StringToRulesTest < ActiveSupport::TestCase
  test "initializes" do
    css_string = ".fight {background: black}"
    assert_equal css_string, StringToRules.new(css_string).css_string
  end

  test '#call' do
    string_to_rules = StringToRules.new("a{foo:bar;}b{baz:qux;}")
    assert_equal ["a{foo:bar;}", "b{baz:qux;}"], string_to_rules.call
  end

  test '#call for single line comments' do
    string_to_rules = StringToRules.new("a{foo:bar;} /* comment p{bar:foo;} */ b{baz:qux;}")
    assert_equal ["a{foo:bar;}", "  b{baz:qux;}"], string_to_rules.call
  end

  test '#call for multiline comments' do
    string_to_rules = StringToRules.new("a{foo:bar;}\n/*\nMultiline comment p{bar:foo;}\n*/\nb{baz:qux;}")
    assert_equal ["a{foo:bar;}", "\n\nb{baz:qux;}"], string_to_rules.call
  end

  test '#call for strings with protocol independent urls' do
    string_to_rules = StringToRules.new("a{foo:url(//assets.server.com);}b{bar:url(//assets/server.com);}")
    assert_equal ["a{foo:url(//assets.server.com);}", "b{bar:url(//assets/server.com);}"], string_to_rules.call
  end

  test '#call containing media queries' do
    string_to_rules = StringToRules.new("a{foo:bar;}@media print{b{baz:qux;}c{quux:corge;}}d{grault:garply;}")
    assert_equal ["a{foo:bar;}", "@media print{b{baz:qux;}", "c{quux:corge;}", "}", "d{grault:garply;}"], string_to_rules.call
  end
end
