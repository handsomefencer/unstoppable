class User < ApplicationRecord
  # Include default devise :confirmable, :trackable, modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :confirmable, :trackable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
