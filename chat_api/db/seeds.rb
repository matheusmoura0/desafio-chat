# db/seeds.rb

puts "🗑️  Limpando banco de dados..."
Message.destroy_all
User.destroy_all

puts "👤 Criando usuários..."
# A senha é definida via password_digest (has_secure_password)
# Estamos fixando a senha '123456' para facilitar seus testes

matheus = User.create!(
  username: 'Matheus',
  password: '123456',
  password_confirmation: '123456'
)

recrutador = User.create!(
  username: 'Recrutador',
  password: '123456',
  password_confirmation: '123456'
)

colega = User.create!(
  username: 'DevTeam',
  password: '123456',
  password_confirmation: '123456'
)

puts "✅ Usuários criados:"
puts "   1. Matheus (Senha: 123456)"
puts "   2. Recrutador (Senha: 123456)"
puts "   3. DevTeam (Senha: 123456)"

puts "💬 Gerando conversa entre Matheus e Recrutador (Teste de Paginação)..."

# Mensagens antigas
conversas = [
  { sender: recrutador, receiver: matheus, content: "Olá Matheus, vi seu perfil no GitHub." },
  { sender: matheus, receiver: recrutador, content: "Olá! Obrigado, estou muito interessado na vaga." },
  { sender: recrutador, receiver: matheus, content: "Gostamos dos seus projetos em Vue.js." },
  { sender: matheus, receiver: recrutador, content: "Obrigado! Tenho focado bastante em componentização." },
  { sender: recrutador, receiver: matheus, content: "E sobre Ruby on Rails, qual sua experiência?" },
  { sender: matheus, receiver: recrutador, content: "Trabalho com Rails API e gosto muito do Active Record." },
  { sender: recrutador, receiver: matheus, content: "Perfeito. Vamos agendar uma entrevista técnica?" },
  { sender: matheus, receiver: recrutador, content: "Claro! Tenho disponibilidade amanhã à tarde." },
  { sender: recrutador, receiver: matheus, content: "Combinado. Vou te mandar o link do Meet." },
  { sender: matheus, receiver: recrutador, content: "Fico no aguardo." },
  { sender: recrutador, receiver: matheus, content: "Link enviado por email!" },
  { sender: matheus, receiver: recrutador, content: "Recebido. Até lá!" }
]

conversas.each do |msg|
  Message.create!(msg)
  # Pequeno delay para garantir timestamps diferentes (ajuda na ordenação)
  sleep(0.1) 
end

puts "💬 Gerando conversa com DevTeam (Teste de Chat Vazio/Novo)..."
Message.create!(
  sender: colega, 
  receiver: matheus, 
  content: "E aí Matheus, bora codar o desafio?"
)

puts "🏁 Seeds concluídos com sucesso!"
puts "🚀 Agora rode 'rails server' e teste o login com usuário 'Matheus' e senha '123456'."