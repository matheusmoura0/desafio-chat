<script setup>
import { ref } from 'vue'
import axios from 'axios'

const api = axios.create({ baseURL: 'http://localhost:3000' })

// Interceptor JWT
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

// Estados
const user = ref(null) // Usuário logado
const token = ref(localStorage.getItem('token'))
const otherUserId = ref('') // ID com quem vou falar
const messages = ref([])
const newMessage = ref('')
const selectedFile = ref(null) // Arquivo selecionado
const page = ref(1)
const totalPages = ref(1)

// Login Rápido (Username + Senha)
const loginData = ref({ username: '', password: '' })
const doLogin = async () => {
  try {
    const res = await api.post('/login', loginData.value)
    localStorage.setItem('token', res.data.token)
    user.value = res.data.user
    token.value = res.data.token
  } catch (e) { alert('Erro login') }
}

// Carregar Conversa (Resetando)
const loadChat = async () => {
  page.value = 1
  messages.value = []
  await fetchMessages()
}

// Buscar Mensagens (Paginação)
const fetchMessages = async () => {
  if (!otherUserId.value) return
  try {
    const res = await api.get(`/messages/${otherUserId.value}?page=${page.value}`)
    // Se for página 1, substitui. Se for pag 2+, adiciona no topo (prepend)
    if (page.value === 1) {
      messages.value = res.data.messages
    } else {
      messages.value = [...res.data.messages, ...messages.value]
    }
    totalPages.value = res.data.meta.total_pages
  } catch (e) { console.error(e) }
}

const loadMore = () => {
  if (page.value < totalPages.value) {
    page.value++
    fetchMessages()
  }
}

// Lidar com seleção de arquivo
const handleFileUpload = (event) => {
  selectedFile.value = event.target.files[0]
}

// ENVIAR (O Segredo do FormData)
const sendMessage = async () => {
  if (!newMessage.value && !selectedFile.value) return

  // Para enviar arquivos, usamos FormData, não JSON puro
  const formData = new FormData()
  formData.append('receiver_id', otherUserId.value)
  if (newMessage.value) formData.append('content', newMessage.value)
  if (selectedFile.value) formData.append('file', selectedFile.value)

  try {
    const res = await api.post('/messages', formData, {
      headers: { 'Content-Type': 'multipart/form-data' } // Importante!
    })
    
    messages.value.push(res.data) // Adiciona na tela
    newMessage.value = ''
    selectedFile.value = null
    document.getElementById('fileInput').value = '' // Limpa input
  } catch (e) { alert('Erro ao enviar') }
}
</script>

<template>
  <div class="container">
    <div v-if="!token">
      <h2>Login</h2>
      <input v-model="loginData.username" placeholder="User">
      <input v-model="loginData.password" type="password" placeholder="Pass">
      <button @click="doLogin">Entrar</button>
    </div>

    <div v-else>
      <div class="header">
        <span>Logado como: {{ user?.username }}</span>
        <button @click="token = null; localStorage.clear()">Sair</button>
      </div>

      <div class="chat-controls">
        <input v-model="otherUserId" placeholder="ID do Destinatário" type="number">
        <button @click="loadChat">Abrir Conversa</button>
      </div>

      <div class="messages-area">
        <button v-if="page < totalPages" @click="loadMore" class="load-more">
          Carregar mensagens antigas
        </button>

        <div v-for="msg in messages" :key="msg.id" 
             :class="['message', msg.sender_id === user?.id ? 'sent' : 'received']">
          
          <p v-if="msg.content">{{ msg.content }}</p>
          
          <img v-if="msg.file_url" :src="msg.file_url" class="msg-image" />
          
          <small>{{ new Date(msg.created_at).toLocaleTimeString() }}</small>
        </div>
      </div>

      <div class="input-area">
        <input type="file" @change="handleFileUpload" id="fileInput">
        <input v-model="newMessage" placeholder="Digite sua mensagem..." @keyup.enter="sendMessage">
        <button @click="sendMessage">Enviar</button>
      </div>
    </div>
  </div>
</template>

<style>
.messages-area { border: 1px solid #ddd; height: 400px; overflow-y: auto; padding: 10px; display: flex; flex-direction: column; }
.message { max-width: 70%; padding: 8px; margin: 5px; border-radius: 8px; }
.sent { align-self: flex-end; background: #dcf8c6; }
.received { align-self: flex-start; background: #f1f0f0; }
.msg-image { max-width: 100%; border-radius: 5px; margin-top: 5px; }
.load-more { margin: 0 auto 10px; cursor: pointer; background: #eee; border: none; padding: 5px; }
</style>