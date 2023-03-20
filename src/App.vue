<template>
  <div class="app">
    <div class="container">
      <Login v-if="!userToken" @token-received="(payload) => tokenReceived(payload)" /><Cities
        v-else
        :userToken="userToken"
        :userName="userName"
        @reset-user="resetUser"
      />
    </div>
  </div>
</template>

<script>
import Login from './views/Login.vue'
import Cities from './views/Cities.vue'

export default {
  name: 'app',
  data: () => ({
    userToken: null,
    userName: null
  }),
  components: {
    Login,
    Cities
  },
  methods: {
    tokenReceived(payload) {
      this.userToken = payload.token
      this.userName = payload.username
    },
    resetUser() {
      this.userToken = null
      this.userName = null
    }
  },
  created() {
    const existingToken = localStorage.getItem('userToken')
    const existingUserName = localStorage.getItem('userName')
    if (existingToken) {
      this.userToken = existingToken
      this.userName = existingUserName
    }
  }
}
</script>

<style scoped lang="scss">
.app {
  min-height: 100vh;
  height: 100%;
  .container {
    width: 85%;
    margin: auto;
    padding-top: 80px;
  }
}
</style>
