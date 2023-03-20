<template>
  <div class="cities">
    <div class="cities__user-section">
      <div class="name">{{ userName }}</div>
      <div class="logout" @click="logout">Log out</div>
    </div>
    <h1 class="cities__title">Cities list</h1>
    <v-responsive class="mx-auto" max-width="500">
      <v-text-field
        v-model="searchTerm"
        variant="solo"
        bg-color="#f3f4f9"
        hide-details
        label="Search here"
      ></v-text-field
    ></v-responsive>
    <div class="cities__list">
      <div class="cities__city-item" v-for="city in cities">
        <div class="top-row">
          <h2 class="city-name">{{ city.name }}</h2>
          <v-icon
            v-if="city.permissions.includes('EDIT')"
            @click="editClicked(city.reference)"
            style="cursor: pointer"
            icon="mdi-pencil"
          ></v-icon>
        </div>
        <img :src="city.img_url" />
      </div>
    </div>
    <div class="cities__pagination">
      <div class="size-dropdown">
        <v-select variant="outlined" hide-details v-model="size" :items="sizeOptions"></v-select>
      </div>
      <v-pagination
        class="pagination"
        v-model="page"
        :length="totalPages"
        :total-visible="totalVisible"
        rounded="circle"
      ></v-pagination>
    </div>
    <v-dialog class="cities__modal" width="600" v-model="editModalOpen">
      <v-card style="padding: 40px 20px">
        <div class="modal-content">
          <h2>Edit city</h2>
          <v-text-field
            hide-details
            variant="outlined"
            label="Name"
            v-model="selectedCityName"
          ></v-text-field>
          <v-text-field
            hide-details
            variant="outlined"
            label="Image url"
            v-model="selectedCityImageUrl"
          ></v-text-field>
          <v-btn variant="outlined" @click="saveClicked">Save</v-btn>
        </div>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  name: 'cities',
  data: () => ({
    cities: [],
    page: 1,
    size: 10,
    searchTerm: null,
    searchTermTimeout: null,
    getCitiesError: false,
    editCityError: false,
    sizeOptions: [10, 20, 50, 100],
    editModalOpen: false,
    selectedCityName: null,
    selectedCityImageUrl: null,
    selectedCityReference: null,
    showCityEdited: false
  }),
  props: ['userToken', 'userName'],
  emit: ['resetUser'],
  computed: {
    totalPages() {
      return Math.ceil(1000 / this.size)
    },
    totalVisible() {
      return this.searchTerm ? 1 : undefined
    }
  },
  methods: {
    async getCities() {
      const url = `http://pulsedev.prx:8666/kn/api/cities?${
        this.searchTerm ? 'query=' + this.searchTerm : ''
      }&size=${this.size}&page=${this.page - 1}`
      try {
        const response = await fetch(url, {
          headers: {
            authorization: `Bearer ${this.userToken}`
          }
        })
        if (response.status === 403) {
          // means token is expired in BE
          this.$emit('resetUser')
          localStorage.removeItem('userToken')
          localStorage.removeItem('userName')
        } else {
          const data = await response.json()
          this.cities = data.payload
        }
      } catch (error) {
        this.getCitiesError = true
      }
    },
    async editCity() {
      const url = `http://pulsedev.prx:8666/kn/api/cities/${this.selectedCityReference}`
      const body = JSON.stringify({
        name: this.selectedCityName,
        img_url: this.selectedCityImageUrl
      })
      try {
        const response = await fetch(url, {
          method: 'PUT',
          headers: {
            authorization: `Bearer ${this.userToken}`,
            'Content-Type': 'application/json'
          },
          body
        })
        if (response.status === 403) {
          // means token is expired in BE
          this.$emit('resetUser')
          localStorage.removeItem('userToken')
          localStorage.removeItem('userName')
        } else {
          const data = await response.json()
          const success = data.status === 'success'
          if (success) {
            this.showCityEdited = true
          } else {
            this.editCityError = true
          }
          this.getCities()
        }
      } catch (error) {
        this.editCityError = true
      }
    },
    editClicked(reference) {
      this.selectedCityReference = reference
      this.selectedCityName = this.cities.find((city) => city.reference === reference).name
      this.selectedCityImageUrl = this.cities.find((city) => city.reference === reference).img_url
      this.editModalOpen = true
    },
    saveClicked() {
      this.editCity()
      this.editModalOpen = false
    },
    async logout() {
      try {
        await fetch('http://pulsedev.prx:8666/kn/api/auth/logout', {
          headers: {
            authorization: `Bearer ${this.userToken}`,
            'Content-Type': 'application/json'
          }
        })
        this.$emit('resetUser')
        localStorage.removeItem('userToken')
        localStorage.removeItem('userName')
      } catch (error) {
        this.$emit('resetUser') // even if request fails log user out in FE since token will expire within an hour anyway
        localStorage.removeItem('userToken')
        localStorage.removeItem('userName')
      }
    }
  },
  watch: {
    page() {
      this.getCities()
    },
    size() {
      this.page = 1
      this.getCities()
    },
    searchTerm() {
      clearTimeout(this.searchTermTimeout)
      this.searchTermTimeout = setTimeout(() => {
        this.page = 1
        this.getCities()
        this.searchTermTimeout = null
      }, 1000)
    },
    editModalOpen() {
      if (!this.editModalOpen) {
        this.selectedCityName = null
        this.selectedCityImageUrl = null
        this.selectedCityReference = null
      }
    }
  },
  created() {
    this.getCities()
  }
}
</script>

<style scoped lang="scss">
.cities {
  height: 100vh;
  &__user-section {
    position: absolute;
    right: 0;
    top: -56px;
    .name {
      font-weight: 500;
      font-size: 18px;
      line-height: 24px;
      letter-spacing: 0.15px;
      color: #1560a5;
      margin-bottom: 4px;
    }
    .logout {
      font-weight: 500;
      font-size: 18px;
      cursor: pointer;
    }
  }
  &__title {
    font-weight: 400;
    font-size: 40px;
    line-height: 40px;
    text-align: center;
    margin-bottom: 40px;
  }
  &__list {
    margin-top: 40px;
    display: flex;
    flex-wrap: wrap;
    justify-content: space-around;
    column-gap: 20px;
    row-gap: 30px;
    margin-bottom: 48px;
  }
  &__city-item {
    width: 300px;
    overflow: hidden;
    .top-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 12px;
      .city-name {
        line-height: 1;
      }
    }
    img {
      width: 100%;
    }
  }
  &__pagination {
    padding: 16px;
    position: sticky;
    bottom: 20px;
    background-color: #f3f4f9;
    border-radius: 10px;
    display: flex;
    justify-content: space-around;
    .pagination {
      width: 50%;
    }
  }
  &__modal {
    .modal-content {
      display: flex;
      flex-direction: column;
      row-gap: 20px;
    }
  }
}
</style>
