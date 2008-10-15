require 'test_helper'

class Class
  def publicize_methods
    saved_private_instance_methods = self.private_instance_methods
    self.class_eval { public *saved_private_instance_methods }
    yield
    self.class_eval { private *saved_private_instance_methods }
  end
end

def user_params(name)
  {:password => "password",
   :password_confirmation => "password",
   :login => name + "login",
   :email => name + "@email.com"}
end

def link_params(name)
  {:title => name,
   :url => name}
end

class LinkTest < Test::Unit::TestCase
  fixtures :all

  should_belong_to :creator
  should_have_many :users, :through => :votes

  should_require_attributes :title
  should_require_attributes :url
  should_require_unique_attributes :url
  should_require_attributes :creator_id
  should_protect_attributes :creator_id
  
  context "on call to private with_user" do
    setup do
      @usera = User.create user_params("A")
      @userb = User.create user_params("B")

      @user = User.create user_params("C")
      @link = Link.create link_params("A").merge(:creator => @usera)
    end

    context "when user has voted for link" do
      setup do
        @link.users = [@usera, @userb, @user]
      end
      
      should "return number of users" do
        assert_equal(3, Link.with_user(@link, @user))
      end
    end
    
    context "when user has not voted for link" do
      setup do
        @link.users = [@usera, @userb]
      end
      
      should "return number of users + 1" do
        assert_equal(3, Link.with_user(@link, @user))
      end
    end
  end

  context "on call to private common_users" do
    setup do
      @usera = User.create user_params("A")
      @userb = User.create user_params("B")

      @user = User.create user_params("C")
      @linka = Link.create link_params("A").merge(:creator => @usera)
      @linkb = Link.create link_params("B").merge(:creator => @usera)

      @linka.users = [@usera, @userb]
      @linkb.users = [@userb]
    end

    context "when user has voted for second link" do
      setup do
        @user.links = [@linka, @linkb]
      end
      
      should "return number of common users" do
        assert_equal(2, Link.common_users(@linka, @linkb, @user))
      end
    end

    context "when user has not voted for second link" do
      setup do
        @user.links = [@linka]
      end
      
      should "return number of common users + 1" do
        assert_equal(2, Link.common_users(@linka, @linkb, @user))
      end
    end
  end
  
  context "on call to private bayes" do
    should "return P(A|B1...BN) = P(B1|A)...P(BN|A)P(A)/P(B1)...P(BN)" do
      assert_equal(1, Link.bayes(
        1, [1.0, 2.0, 3.0],
        proc{|e, h| e == 1.0 ? 1.0 : 0.5 },
        proc{|e| 0.5 },
        proc{|h| 0.5 }
      ))
    end

    should "also return P(A|B1...BN) = P(B1|A)...P(BN|A)P(A)/P(B1)...P(BN)" do
      assert_equal(0.25, Link.bayes(
        1, [1.0, 2.0],
        proc{|e, h| e == 1.0 ? 0.5 : 0.2 },
        proc{|e| e == 1.0 ? 0.5 : 0.4 },
        proc{|h| 0.5 }
      ))
    end
  end
end
