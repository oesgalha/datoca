FactoryGirl.define do

  factory :user do
    name { Laranja::Nome.nome }
    email { Laranja::Internet.email }
    password 'password'
  end

  factory :admin, class: User do
    name { Laranja::Nome.nome }
    email { Laranja::Internet.email }
    password 'password'
    role { User.roles[:admin] }
  end

end
