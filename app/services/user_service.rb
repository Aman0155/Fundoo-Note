# app/services/user_service.rb

class UserService
  def self.create_user(user_params)
    user = User.new(user_params)
    if user.save
      return { user: user, success: true }
    else
      return { errors: user.errors.full_messages, success: false }
    end
  end

  def self.login_user(email, password)
    user = User.find_by(email: email)
    
    if user && user.authenticate(password)
      token = JsonWebToken.encode(user_id: user.id, name: user.name, email: user.email)
      return { token: token, message: 'Login successful', success: true }
    else
      return { error: 'Invalid email or password', success: false }
    end
  end

  def self.delete_user(user_id)
    user = User.find_by(id: user_id)
    
    if user
      user.destroy
      return { message: 'User deleted successfully', success: true }
    else
      return { error: 'User not found', success: false }
    end
  end

  def self.get_users
    User.all
  end

  def self.get_user(user_id)
    User.find_by(id: user_id)
  end
end
9