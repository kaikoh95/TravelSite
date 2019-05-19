<template>
  <div class="layout">
    <Layout>
      <Header style="background: #00CE00">
        <Menu mode="horizontal" style="background: #00CE00">
          <div class="layout-logo">
            <a href="/"><img src="./assets/travel-icon.png" width="300" height="55"></a>
          </div>
          <div v-if="loginFlag">
          <div class="layout-nav">
            <MenuItem style="float: right" onclick="window.location.href='/myProfile'">
              <Icon type="gear-b"></Icon>
              Personal Info
            </MenuItem>
            <MenuItem style="float: right" onclick="window.location.href='/categories'">
              <Icon type="search"></Icon>
              Search Categories
            </MenuItem>
            <MenuItem style="float: right" onclick="window.location.href='/venues'">
              <Icon type="map"></Icon>
              Search Venues
            </MenuItem>
            <MenuItem style="float: right" onclick="window.location.href='/addVenue'">
              <Icon type="compose"></Icon>
              Add Venue
            </MenuItem>
          </div>
          </div>
          <div v-else-if="logoutFlag">
          <div class="layout-nav">
            <MenuItem style="float: right" onclick="window.location.href='/categories'">
              <Icon type="search"></Icon>
              Search Categories
            </MenuItem>
            <MenuItem style="float: right" onclick="window.location.href='/venues'">
              <Icon type="map"></Icon>
              Search Venues
            </MenuItem>
            <MenuItem style="float: right" onclick="window.location.href='/register'">
              <Icon type="plus"></Icon>
              Sign up
            </MenuItem>
            <MenuItem style="float: right" onclick="window.location.href='/login'">
              <Icon type="person"></Icon>
              Login
            </MenuItem>
          </div>
          </div>
        </Menu>
      </Header>
      <Content :style="{padding: '0 100px'}">
        <Breadcrumb style="text-align: center; margin: 40px">
          <BreadcrumbItem>Welcome to Kai's Travels, where tourist destinations are at your fingertips!</BreadcrumbItem>
        </Breadcrumb>
        <Card>
          <div v-if="logoutFlag" style="min-height: 400px; text-align: center">
            Haven't signed up? What are you waiting for!
          </div>
          <div v-else-if="loginFlag" style="min-height: 400px; text-align: center">
            <h3>Welcome <h1><i><u>{{user}}</u></i></h1> What would you like to do today?</h3>
            <Card style="width: 120px; height: 120px">
              <div style="text-align:center">
                <img v-bind:src="imageView" onclick="window.location.href='/myProfile'" alt="No image uploaded" style="text-align: center; width: 80px; height: 80px">
              </div>
              Profile
            </Card>
          </div>
        </Card>
      </Content>
      <Footer class="layout-footer">
        <Button v-if="loginFlag" type="warning" @click="handleLogout">Logout</Button>
        2019 &copy; Kai Koh
      </Footer>
    </Layout>
  </div>
</template>
<script>
  export default {
    data() {
      return {
        imageView: '',
        loginFlag: false,
        logoutFlag: true,
        user: ''
      }
    },
    mounted: function() {
      if (this.$cookies.get("AuthToken") !== null && this.$cookies.get("AuthToken") !== undefined && this.$cookies.get("AuthToken") !== "") {
        this.loginFlag = true;
        this.logoutFlag = false;
      } else {
        this.loginFlag = false;
        this.logoutFlag = true;
      }
      this.imageView = "http://localhost:4941/api/v1/users/" + this.$cookies.get("UserId") + "/photo";
      this.getUsername();
    },
    methods: {
      getUsername() {
        this.$http.get('http://localhost:4941/api/v1/users/'+ this.$cookies.get("UserId"), {
          headers: {'X-Authorization': this.$cookies.get("AuthToken")}
        })
          .then(function (response) {
            this.$cookies.set("Username", response.data.username);
            this.user = this.$cookies.get("Username");
          });
      },
      handleLogout() {
        this.$http.post("http://localhost:4941/api/v1/users/logout", "", {
          headers: {"X-Authorization": this.$cookies.get("AuthToken")}
        })
          .then(function() {
            this.$cookies.remove("AuthToken");
            this.$cookies.remove("UserId");
            this.loginFlag = false;
            this.logoutFlag = true;
            alert("You have logged out successfully!");
            window.location.href = '/'
          }, function() {
            alert("Internal Server Error, please try again in a few moments!")
          });
      }
    }
  }
</script>
