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

def competiton_params
  {
    name: competition_name,
    total_prize: 2000 + rand(48_000),
    deadline: Time.now.midnight + (5 + rand(40)).days,
    description_attributes: {
      name: 'Descrição',
      markdown: lorem
    },
    evaluation_text_attributes: {
      name: 'Regras',
      markdown: lorem
    },
    rules_attributes: {
      name: 'Regras',
      markdown: lorem
    }
  }
end

10.times do
  Competition.create!(competiton_params)
end
