FactoryGirl.define do

  sequence :lorem do |n|
    'Mussum Ipsum, cacilds vidis litro abertis. Viva Forevis aptent taciti sociosqu ad litora torquent Copo furadis é disculpa de bebadis, arcu quam euismod magna. Sapien in monti palavris qui num significa nadis i pareci latim. Posuere libero varius. Nullam a nisl ut ante blandit hendrerit. Aenean sit amet nisi.'
  end

  sequence :csv do |n|
    File.join(Rails.root, 'tmp', "#{n}.csv").tap do |fullpath|
      CSV.open(fullpath, 'wb') do |csv|
        csv << ['id', 'value']
        1.upto(10).each { |i| csv << [i.to_s, rand(1_000).to_s] }
      end
    end
  end

  factory :user do
    name { Laranja::Nome.nome }
    email { Laranja::Internet.email(name) }
    password 'password'

    factory :admin do
      role { User.roles[:admin] }
    end
  end

  factory :competition do
    name 'Competição 123'
    total_prize { 1_000 + rand(9_000) }
    deadline { Time.current.midnight + (5 + rand(20)).days }
    expected_csv { File.open(generate(:csv)) }
    created_at { Time.current - (5 + rand(20)).days }
    metric { Competition.metrics[:mae] }
    instructions_attributes {
      [
        { name: 'Avaliação',  markdown: generate(:lorem) },
        { name: 'Descrição',  markdown: generate(:lorem) },
        { name: 'Regras',     markdown: generate(:lorem) },
        { name: 'Dados',      markdown: generate(:lorem) }
      ]
    }
  end

end
