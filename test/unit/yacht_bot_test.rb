require 'test_helper'
require 'yacht_bot'

class YachtBotTest < ActiveSupport::TestCase
  test "visible results" do
    body = fixture('visible_results.html')

    assert ! YachtBot.error?(body)
    assert_equal 144, YachtBot.results(body)
    assert YachtBot.vessels(body)
  end
  test "invisible results" do
    body = fixture('invisible_results.html')

    assert ! YachtBot.error?(body)
    assert_equal 3, YachtBot.results(body)
    assert YachtBot.vessels(body).empty?
  end
  test "too many results" do
    body = fixture('too_many_results.html')

    assert YachtBot.error?(body)
    assert_equal 203392, YachtBot.results(body)
    assert YachtBot.vessels(body).empty?
  end
  test "no results" do
    body = fixture('no_results.html')

    assert YachtBot.error?(body)
    assert_equal 0, YachtBot.results(body)
    assert YachtBot.vessels(body).empty?
  end

  test "info" do
    names = ["find_642731.html", "find_642732.html", "find_1095883.html"]
    names.each { |name|
      body = fixture(name)
      assert YachtBot.info(body)
    }
  end
end
