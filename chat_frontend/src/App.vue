<script setup>
import { ref } from 'vue'
import axios from 'axios'

const api = axios.create({ baseURL: 'http://localhost:3000' })

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

const user = ref(JSON.parse(localStorage.getItem('user')) || null)
const token = ref(localStorage.getItem('token'))
const otherUserId = ref('')
const messages = ref([])
const newMessage = ref('')
const selectedFile = ref(null)
const page = ref(1)
const totalPages = ref(1)
const metrics = ref({})
const users = ref([])

const getUsers = async () => {
  try {
    const res = await api.get('/users')
    users.value = res.data.data.map(item => ({
      id: item.id,
      ...item.attributes
    }))
  } catch (e) { console.error(e) }
}

if (token.value) getUsers()

const getMetrics = async () => {
  try {
    const res = await api.get('/metrics')
    metrics.value = res.data.data.attributes
  } catch (e) { console.error(e) }
}

if (token.value) getMetrics()

const loginData = ref({ username: '', password: '' })
const doLogin = async () => {
  try {
    const res = await api.post('/login', loginData.value)
    localStorage.setItem('token', res.data.token)
    localStorage.setItem('user', JSON.stringify(res.data.user))
    user.value = res.data.user
    token.value = res.data.token
    getMetrics()
    getUsers()
  } catch (e) { alert('Erro login') }
}

const loadChat = async () => {
  page.value = 1
  messages.value = []
  await fetchMessages()
}

const fetchMessages = async () => {
  if (!otherUserId.value) return
  try {
    const res = await api.get(`/messages/${otherUserId.value}?page=${page.value}`)
    const rawMessages = res.data.data.map(item => ({
      id: item.id,
      ...item.attributes
    }))

    if (page.value === 1) {
      messages.value = rawMessages
    } else {
      messages.value = [...rawMessages, ...messages.value]
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

const handleFileUpload = (event) => {
  selectedFile.value = event.target.files[0]
}

const sendMessage = async () => {
  if (!newMessage.value && !selectedFile.value) return

  const formData = new FormData()
  formData.append('receiver_id', otherUserId.value)
  if (newMessage.value) formData.append('content', newMessage.value)
  if (selectedFile.value) formData.append('file', selectedFile.value)

  try {
    const res = await api.post('/messages', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
    
    const newMsg = {
      id: res.data.data.id,
      ...res.data.data.attributes
    }
    messages.value.push(newMsg)
    newMessage.value = ''
    selectedFile.value = null
    document.getElementById('fileInput').value = ''
  } catch (e) { alert('Erro ao enviar') }
}

const formatImageUrl = (url) => {
  if (!url) return null
  if (url.startsWith('http')) return url
  return `http://localhost:3000${url}`
}
</script>

<template>
  <div class="container">
    <div v-if="!token" class="login-container">
      <h2>Login</h2>
      <input v-model="loginData.username" placeholder="Usuário">
      <input v-model="loginData.password" type="password" placeholder="Senha">
      <button @click="doLogin">Entrar</button>
    </div>

    <div v-else class="chat-wrapper">
      <div class="header">
        <span>Logado como: {{ user?.username }}</span>
        <button @click="token = null; user = null; localStorage.clear()">Sair</button>
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
          
          <img v-if="msg.file_url" :src="formatImageUrl(msg.file_url)" class="msg-image" />
          
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

  <div v-if="token">
    <h2>Metrics</h2>
    <p>Total de usuários: {{ metrics.total_users }}</p>
    <p>Total de mensagens: {{ metrics.total_messages }}</p>
    <p>Usuários ativos (últimas 24h): {{ metrics.active_users_24h }}</p>
  </div>

  <div v-if="token">
    <h2>Usuários</h2>
    <ul>
      <li v-for="user in users" :key="user.id">
        {{ user.username }} - {{ user.id }}
      </li>
    </ul>
  </div>
</template>

<style>
* { box-sizing: border-box; }
body { font-family: sans-serif; padding: 20px; }

.container {
  max-width: 600px;
  margin: 0 auto;
  border: 1px solid black;
  height: 80vh;
  display: flex;
  flex-direction: column;
}

.chat-wrapper {
  display: flex;
  flex-direction: column;
  height: 100%;
  overflow: hidden;
}


.header {
  border-bottom: 1px solid black;
  padding: 10px;
  display: flex;
  justify-content: space-between;
}


.chat-controls {
  padding: 10px;
  border-bottom: 1px solid black;
  display: flex;
  gap: 5px;
}
.chat-controls input { flex: 1; }

.messages-area {
  flex: 1;
  overflow-y: auto;
  padding: 10px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.message {
  border: 1px solid #ccc;
  padding: 5px;
  max-width: 80%;
}
.sent { align-self: flex-end; background: #eee; }
.received { align-self: flex-start; }
.msg-image { max-width: 200px; display: block; }
.load-more { margin-bottom: 10px; }

.input-area {
  padding: 10px;
  border-top: 1px solid black;
  display: flex;
  gap: 5px;
}
.input-area input[type=text] { flex: 1; }


.login-container {
  padding: 20px;
  text-align: center;
}
.login-container input { display: block; margin: 10px auto; }
</style>