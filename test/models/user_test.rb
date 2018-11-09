require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name:'example User', email:'user@examplt.com',
                     password:'foobar', password_confirmation:'foobar')
  end
  test "should be valid" do
    assert @user.valid?
  end
  test 'should be present' do
    @user.name = '  '
    assert_not @user.valid?
  end
  test 'email should be present' do
    @user.email  = '   '
    assert_not @user.valid?
  end
  test 'email should not be too long ' do
    @user.email = '*' * 244 + '@example.com'
    assert_not @user.valid?
  end
  test 'name should not be  too long' do
    @user.name = '*'*51
    assert_not @user.valid?
  end
  test 'email validation should accept valid address' do
    valid_addresses  = %w[user@example.com USER@foo.com A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  test 'email addresses should be unique' do
    duplicate_user =  @user.dup
    @user.save
    duplicate_user.email = @user.email.upcase
    assert_not duplicate_user.valid?
  end
  test 'email addresses should be saved as lower-case' do
    mixed_case_email = 'foo@ExAmple.CoM'
    @user.email = mixed_case_email
    @user.save
    #reload 保存了之后的数据
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  test "password should have a mininum length" do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
end

