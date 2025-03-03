require "minitest/autorun"

require_relative "book"

class TestWithMinitest < Minitest::Test
  def test_I_can_stub_title
    book = Book.new
    book.stub :title, "stubbed title" do
      assert_equal "stubbed title", book.title
    end
  end

  def test_I_can_mock_title
    book = Book.new
    mock = Minitest::Mock.new
    mock.expect :call, "stubbed title"
    book.stub :title, mock do
      assert_equal "stubbed title", book.title
    end
    mock.verify
  end

  def test_I_can_stub_class_method
    Book.stub :find, "stubbed find" do
      assert_equal "stubbed find", Book.find("any")
    end
  end

  def test_I_can_mock_class_method
    mock = Minitest::Mock.new
    mock.expect :call, "stubbed find", ["title"]
    Book.stub :find, mock do
      assert_equal "stubbed find", Book.find("title")
    end
    mock.verify
  end

  def test_I_can_mock_in_sequence
    mock = Minitest::Mock.new
    mock.expect :call, "stubbed find _1", ["title_1"]
    mock.expect :call, "stubbed find _2", ["title_2"]

    Book.stub :find, mock do
      assert_equal "stubbed find _1", Book.find("title_1")
      assert_equal "stubbed find _2", Book.find("title_2")
    end
    mock.verify
  end

  def test_I_can_mock_with_multiple_returns_in_sequence
    mock = Minitest::Mock.new
    mock.expect :call, "stubbed find _1", [String]
    mock.expect :call, "stubbed find _2", [String]

    Book.stub :find, mock do
      assert_equal "stubbed find _1", Book.find("any")
      assert_equal "stubbed find _2", Book.find("any")
    end
    mock.verify
  end

  def test_I_can_mock_any_instance
    mock = Minitest::Mock.new
    mock.expect :call, "stubbed title"

    Book.class_eval do
      alias_method :original_title, :title
      define_method(:title) { mock.call }
    end

    book = Book.new
    assert_equal "stubbed title", book.title
    mock.verify

    Book.class_eval do
      undef_method :title
      alias_method :title, :original_title
      undef_method :original_title
    end
  end

  def test_I_can_mock_with_ambigous_param
    mock = Minitest::Mock.new
    mock.expect :call, "stubbed find", [String]

    Book.stub :find, mock do
      assert_equal "stubbed find", Book.find("title")
    end
    mock.verify
  end
end
