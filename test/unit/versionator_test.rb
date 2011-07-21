require 'test_helper'
 
class VersionatorTest < ActiveSupport::TestCase
  def teardown
    File.delete(Versionator.version_file) rescue nil
  end

  test "module defined" do
    assert defined?(Versionator)
  end

  test "warning about file creation issued if VERSION file does not exist" do
    out, err = capture_io do
      Versionator::Version.new
    end
    assert_equal "Versionator file created: #{Versionator.version_file}\n", out
  end
  
  test "get 3 version categories as array" do
    version = Versionator::Version.new
    assert_equal version.version_categories("1.2.3"), [1,2,3]
  end
  
  test "version file created when Version is initailized if it does not exist" do
    assert File.exists?(Versionator.version_file)==false
    Versionator::Version.new
    assert File.exists?(Versionator.version_file)
  end
  
  test "instance vars are intialized" do
    version = Versionator::Version.new
    assert_equal version.patch, 0
    assert_equal version.minor, 0
    assert_equal version.major, 0
  end
  
  test "read version" do
    version = Versionator::Version.new
    assert_equal version.read, "0.0.0"
  end
  
  test "write specific version" do
    version = Versionator::Version.new
    version.write("1.1.1")
    assert_equal version.read, "1.1.1"
  end
  
  test "version returns string of version" do
    version = Versionator::Version.new
    assert_equal version.version, "0.0.0"
  end
  
  test "bump patch" do
    version = Versionator::Version.new
    version.bump(:patch)
    assert_equal version.version, "0.0.1"
    version.bump(:patch)
    assert_equal version.version, "0.0.2"
  end
  
  test "bump minor" do
    version = Versionator::Version.new
    version.bump(:minor)
    assert_equal version.version, "0.1.0"
    version.bump(:patch)
    assert_equal version.version, "0.1.1"
    version.bump(:minor)
    assert_equal version.version, "0.2.0"
  end
  
  test "bump major" do
    version = Versionator::Version.new
    version.bump(:major)
    assert_equal version.version, "1.0.0"
    version.bump(:minor)
    assert_equal version.version, "1.1.0"
    version.bump(:patch)
    assert_equal version.version, "1.1.1"
    version.bump(:major)
    assert_equal version.version, "2.0.0"
  end
  
  test "git checkout" do
    version = Versionator::Version.new
    output = version.git_checkout
    p output
    p output.include?("Already on 'master'")
    
    p output.include?("Switched to branch 'master'")
    assert (output.include?("Already on 'master'") or output.include?("Switched to branch 'master'"))
  end
  
  test "git pull" do
    version = Versionator::Version.new
    output = version.git_pull
    assert output.include?("Already up-to-date.")
  end
  
  test "git tag" do
    version = Versionator::Version.new
    #output = version.git_tag
  end
  
  test "git commit" do
    version = Versionator::Version.new
    #output = version.git_commit
  end
  
  test "git push" do
    version = Versionator::Version.new
    #output = version.git_push
  end
end