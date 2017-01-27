require 'test_helper'

class CompetitionTest < ActiveSupport::TestCase
  test 'It count the expected csv lines' do
    comp = create(:competition)
    assert_equal 11, comp.expected_csv_line_count

    comp.expected_csv = File.open(random_csv(100))
    comp.save
    assert_equal 100, comp.expected_csv_line_count

    comp.expected_csv = File.open(random_csv(42))
    comp.save
    assert_equal 42, comp.expected_csv_line_count
  end
end
