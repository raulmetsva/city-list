<template>
  <div class="login">
    <div class="login__section">
      <h1>Login</h1>
      <v-text-field
        label="Username"
        v-model="userName"
        variant="outlined"
        bg-color="#f3f4f9"
      ></v-text-field>
      <v-text-field
        label="Password"
        v-model="password"
        variant="outlined"
        bg-color="#f3f4f9"
      ></v-text-field>
      <v-btn @click="login" variant="outlined">Login</v-btn>
      <p class="error" v-if="loginError">Please check your username/password</p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'login',
  data: () => ({
    userName: '',
    password: '',
    loginError: false
  }),
  emits: ['tokenReceived'],
  methods: {
    async login() {
      const body = JSON.stringify({
        username: this.userName,
        credentials: this.password
      })
      try {
        const response = await fetch('http://pulsedev.prx:8666/kn/api/auth/login', {
          method: 'POST',
          body,
          headers: {
            'Content-Type': 'application/json'
          }
        })
        const data = await response.json()
        localStorage.setItem('userToken', data.token)
        localStorage.setItem('userName', data.username)
        this.$emit('tokenReceived', data)
      } catch (error) {
        this.loginError = true
      }
    }
  }
}
</script>

<style scoped lang="scss">
.login {
  &__section {
    width: 400px;
    margin: auto;
    margin-top: 120px;
    display: flex;
    flex-direction: column;
    row-gap: 20px;
    .error {
      color: #ba1a1a;
      font-weight: 500;
    }
  }
}
</style>
