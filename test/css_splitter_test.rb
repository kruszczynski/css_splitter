require 'test_helper'

class CssSplitterTest < ActiveSupport::TestCase

  setup :clear_assets_cache

  test "truth" do
    assert_kind_of Module, CssSplitter
  end

  test "asset pipeline stylesheet splitting" do
    part1 = "#test{background-color:red}"   * CssSplitter::Splitter::MAX_SELECTORS_DEFAULT
    part2 = "#test{background-color:green}" * CssSplitter::Splitter::MAX_SELECTORS_DEFAULT
    part3 = "#test{background-color:blue}"

    assert_equal "#{part1}#{part2}#{part3}\n",  assets["erb_stylesheet"].to_s
    assert_equal "#{part2}\n",                  assets["erb_stylesheet_split2"].to_s
    assert_equal "#{part3}\n",                  assets["erb_stylesheet_split3"].to_s
  end

  test "asset pipeline stylesheet splitting on stylesheet combined using requires" do
    red   = "#test{background-color:red}"   * 100
    green = "#test{background-color:green}" * CssSplitter::Splitter::MAX_SELECTORS_DEFAULT
    blue  = "#test{background-color:blue}"

    assert_equal "#{red}#{green}#{blue}\n",                           assets["combined"].to_s
    assert_equal "#{"#test{background-color:green}" * 100}#{blue}\n", assets["combined_split2"].to_s
  end

  test "should not separate keyframes declarations" do
    green = "#test{background-color:green}" * (CssSplitter::Splitter::MAX_SELECTORS_DEFAULT - 1)
    keyframes = "@keyframes my-anim{0%{top:0px}20%{top:20px}40%{top:40px}60%{top:60px}80%{top:80px}100%{top:100px}}"
    assert_equal "#{green}#{keyframes}\n", assets["keyframes"].to_s
    assert_equal "#{keyframes}", assets["keyframes_split2"].to_s
  end

  private

  def clear_assets_cache
    assets_cache = Rails.root.join("tmp/cache/assets")
    assets_cache.rmtree if assets_cache.exist?
  end

  def assets
    Rails.application.assets
  end

end
