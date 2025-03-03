require "minitest/autorun"
require "mocha/minitest"

require_relative "book"

class TestWithMocha < Minitest::Test
  def test_I_can_stub_title
    book = Book.new
    book.stubs(:title).returns("stubbed title")
    assert_equal "stubbed title", book.title
  end

  def test_I_can_mock_title
    book = Book.new
    book.expects(:title).returns("stubbed title")
    assert_equal "stubbed title", book.title
  end

  def test_I_can_stub_class_method
    Book.stubs(:find).returns("stubbed find")
    assert_equal "stubbed find", Book.find("any")
  end

  def test_I_can_mock_class_method
    Book.stubs(:find).with("title").returns("stubbed find")
    assert_equal "stubbed find", Book.find("title")
  end

  def test_I_can_mock_in_sequence
    sequence = sequence("sequence")
    Book.expects(:find).with("title_1").returns("stubbed find _1").in_sequence(sequence)
    Book.expects(:find).with("title_2").returns("stubbed find _2").in_sequence(sequence)

    assert_equal "stubbed find _1", Book.find("title_1")
    assert_equal "stubbed find _2", Book.find("title_2")
  end

  def test_I_can_mock_with_multiple_returns_in_sequence
    Book.stubs(:find).returns("stubbed find _1", "stubbed find _2")

    assert_equal "stubbed find _1", Book.find("any")
    assert_equal "stubbed find _2", Book.find("any")
  end

  def test_I_can_mock_any_instance
    Book.any_instance.stubs(:title).returns("stubbed title")

    book = Book.new
    assert_equal "stubbed title", book.title
  end

  def test_I_can_mock_with_ambigous_param
    Book.stubs(:find).with(instance_of(String)).returns("stubbed find")

    assert_equal "stubbed find", Book.find("title")
  end
end
