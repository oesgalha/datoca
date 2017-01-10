FactoryGirl.define do

  factory :user do
    name { Laranja::Nome.nome }
    email { Laranja::Internet.email }
    password 'password'
  end

end
