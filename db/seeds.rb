require 'csv'
require 'laranja'
Laranja.load('pt-BR')

LOREM1 = 'Mussum Ipsum, cacilds vidis litro abertis. Viva Forevis aptent taciti sociosqu ad litora torquent Copo furadis é disculpa de bebadis, arcu quam euismod magna. Sapien in monti palavris qui num significa nadis i pareci latim. Posuere libero varius. Nullam a nisl ut ante blandit hendrerit. Aenean sit amet nisi.'
LOREM2 = 'Mussum Ipsum, cacilds vidis litro abertis. Cevadis im ampola pa arma uma pindureta. Nec orci ornare consequat. Praesent lacinia ultrices consectetur. Sed non ipsum felis. Pra lá , depois divoltis porris, paradis.'
LOREM3 = 'Mussum Ipsum, cacilds vidis litro abertis. Viva Forevis aptent taciti sociosqu ad litora torquent Copo furadis é disculpa de bebadis, arcu quam euismod magna. Sapien in monti palavris qui num significa nadis i pareci latim. Posuere libero varius. Nullam a nisl ut ante blandit hendrerit. Aenean sit amet nisi.'
LOREMRS = [LOREM1, LOREM2, LOREM3]

def lorem
  LOREMRS.sample
end

PROBLEMS = [ 'Prever demanda da', 'Alocação de atendimento da', 'Otimizar compra de estoque da', 'Avaliar performance de promoções da' ]
COMPANIES = [ 'Construtora', 'Energia', 'Mercados', 'Telecom' ]

def competition_name
  "#{PROBLEMS.sample} #{Laranja::Nome.sobrenome} #{COMPANIES.sample}"
end

def random_csv
  File.join(Rails.root, 'tmp', "#{rand(10)}.csv").tap do |fullpath|
    CSV.open(fullpath, 'wb') do |csv|
      csv << ['id', 'value']
      for i in 0...10
        csv << [i.to_s, rand(1_000).to_s]
      end
    end
  end
end

def competiton_params
  {
    name: competition_name,
    total_prize: 2000 + rand(48_000),
    deadline: Time.current.midnight + (5 + rand(20)).days,
    expected_csv: File.open(random_csv),
    metric: Competition.metrics[:mae],
    created_at: Time.current - (5 + rand(20)).days,
    instructions_attributes: [
      { name: 'Avaliação', markdown: lorem },
      { name: 'Descrição', markdown: lorem },
      { name: 'Regras', markdown: lorem },
      { name: 'Dados', markdown: lorem }
    ]
  }
end

def user_params
  mail = Laranja::Internet.email
  {
    name: Laranja::Nome.nome,
    email: mail,
    location: Laranja::Endereco.cidade,
    password: Laranja::Internet.password,
  }
end

def team_params(users)
  base_name = lorem
  base_desc = lorem
  users_amount = 1 + rand(users.size)
  name = base_name[rand(base_name.size - 16), 16]
  {
    name: name,
    description: base_desc[rand(base_desc.size - 128), 128],
    users: users_amount.times.map { users.sample }.uniq
  }
end

puts 'GERANDO USUARIOS'
users = 20.times.map { User.create!(user_params) }

puts 'GERANDO TIMES'
teams = 10.times.map { Team.create!(team_params(users)) }

competitors = users + teams

puts 'GERANDO COMPETIÇÕES'
competitions = 4.times.map { Competition.create!(competiton_params) }

puts 'GERANDO SUBMISSÕES'
competitions.each do |competition|
  (1 + rand(9)).times do
    competition.submissions.create(
      csv: File.open(random_csv),
      competitor: competitors.sample
    )
  end
end
