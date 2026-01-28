# db/seeds.rb

puts "🗑️  Limpando banco de dados..."
Message.destroy_all
User.destroy_all

puts "🏢 Criando ambiente corporativo..."
default_pass = '123456'

# Usuário principal (Você)
dev = User.create!(
  username: 'Matheus_Dev',
  password: default_pass,
  password_confirmation: default_pass
)

# Gerente de Produto
pm = User.create!(
  username: 'Alice_ProductManager',
  password: default_pass,
  password_confirmation: default_pass
)

# Designer (Para testar o chat secundário)
designer = User.create!(
  username: 'Bruno_Designer',
  password: default_pass,
  password_confirmation: default_pass
)

puts "✅ Equipe criada:"
puts "   1. #{dev.username}"
puts "   2. #{pm.username}"
puts "   3. #{designer.username}"

puts "📅 Simulando Daily/Sprint Planning..."

# Conversa focada em entrega de tarefas
sprint_chat = [
  { sender: pm, receiver: dev, content: "Bom dia, Matheus. Como estamos com a entrega da API?" },
  { sender: dev, receiver: pm, content: "Bom dia, Alice. O backend está 90% pronto." },
  { sender: pm, receiver: dev, content: "Ótimo. O endpoint de login já está com JWT?" },
  { sender: dev, receiver: pm, content: "Sim, implementei ontem. Já fiz os testes de carga também." },
  { sender: dev, receiver: pm, content: "Falta apenas ajustar o upload de arquivos no S3." },
  { sender: pm, receiver: dev, content: "Perfeito. O cliente pediu prioridade nisso." },
  { sender: pm, receiver: dev, content: "Você acha que conseguimos subir para homologação hoje à tarde?" },
  { sender: dev, receiver: pm, content: "Acredito que sim. Vou fazer o Merge Request antes do almoço." },
  { sender: pm, receiver: dev, content: "Combinado. Vou avisar a equipe de QA para ficarem atentos." },
  { sender: dev, receiver: pm, content: "Ok, qualquer bloqueio eu te aviso no Slack." },
  { sender: pm, receiver: dev, content: "Obrigada, bom trabalho!" },
  { sender: dev, receiver: pm, content: "Valeu!" }
]

sprint_chat.each do |msg|
  Message.create!(msg)
  sleep(0.1) # Garante a ordem cronológica correta
end

puts "🎨 Simulando entrega de assets (Outro chat)..."
Message.create!(
  sender: designer, 
  receiver: dev, 
  content: "Fala Matheus! Acabei de exportar os ícones novos. Vou te mandar o anexo na próxima mensagem."
)

puts "🏁 Banco de dados populado!"
puts "🚀 Teste com usuário: 'Matheus_Dev' / Senha: '123456'"