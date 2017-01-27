require 'rspec'
require_relative '../comparator/version'

def expectBigger(smaller, bigger)
  expect(smaller <=> bigger).to eql(-1)
  expect(bigger <=> smaller).to eql(1)
  expect(smaller <=> smaller).to eql(0)
  expect(bigger <=> bigger).to eql(0)
end

describe 'Version' do
  it 'initializes with version string' do
    version = Version.new("1.1.2")
    expect(version.major).to eql(1)
    expect(version.minor).to eql(1)
    expect(version.patch).to eql(2)
  end

  it 'compares' do
    version1 = Version.new("1.1.2")
    version2 = Version.new("1.1.3")
    version3 = Version.new("1.2.1")
    version4 = Version.new("1.2.3")
    version5 = Version.new("4.1.1")
    version6 = Version.new("4.2.1")

    expectBigger(version1, version2)
    expectBigger(version2, version3)
    expectBigger(version3, version4)
    expectBigger(version4, version5)
    expectBigger(version5, version6)
    expectBigger(version2, version6)
  end

  it 'does not compare with strings' do
    version1 = Version.new("1.1.2")
    expect(version1 <=> "hello").to eql(nil)
  end
end
