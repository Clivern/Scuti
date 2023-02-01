<!-- @format -->

<template>
	<div id="app">
		<div id="nav">
			<template v-if="logged">
				<router-link to="/admin/dashboard">
					<b-icon pack="fas" icon="tachometer-alt" size="is-small"> </b-icon>
					Dashboard</router-link
				>
				|
				<router-link to="/admin/host-groups">
					<b-icon pack="fas" icon="folder" size="is-small"> </b-icon>
					Host Groups</router-link
				>
				|
				<router-link to="/admin/hosts">
					<b-icon pack="fas" icon="server" size="is-small"> </b-icon>
					Hosts</router-link
				>
				|
				<router-link to="/admin/deployments">
					<b-icon pack="fas" icon="compass" size="is-small"> </b-icon>
					Deployments</router-link
				>
				|
				<template v-if="user_role == 'super'">
					<router-link to="/admin/team">
						<b-icon pack="fas" icon="user" size="is-small"> </b-icon>
						Teams</router-link
					>
					|
					<router-link to="/admin/users">
						<b-icon pack="fas" icon="user" size="is-small"> </b-icon>
						Users</router-link
					>
					|
				</template>
				<a href="#" @click="logout">
					<b-icon pack="fas" icon="sign-out-alt" size="is-small"> </b-icon>
					Logout</a
				>
			</template>
			<template v-else>
				<router-link to="/"
					><b-icon pack="fas" icon="home" size="is-small"> </b-icon>
					Home</router-link
				>
				|
				<router-link to="/login">
					<b-icon pack="fas" icon="sign-in-alt" size="is-small"> </b-icon>
					Login</router-link
				>
			</template>
		</div>
		<router-view @refresh-state="refreshState" />
	</div>
</template>

<style>
#app {
	text-align: center;
	color: #2c3e50;
}

#nav {
	padding: 30px;
}

#nav a {
	font-weight: bold;
	color: #2c3e50;
}

#nav a.router-link-exact-active {
	color: #42b983;
}
</style>

<script>
export default {
	data() {
		return {
			logged: localStorage.getItem("x_api_key") != null,
			user_role: localStorage.getItem("x_user_role")
		};
	},
	methods: {
		logout() {
			this.logged = false;
			localStorage.removeItem("x_user_id");
			localStorage.removeItem("x_user_email");
			localStorage.removeItem("x_api_key");
			localStorage.removeItem("x_user_uuid");
			localStorage.removeItem("x_user_name");
			localStorage.removeItem("x_session_id");
			localStorage.removeItem("x_session_uuid");
			localStorage.removeItem("x_user_role");
			this.$router.push("/login");
		},
		refreshState() {
			this.logged = localStorage.getItem("x_api_key") != null;
		},
	},
	mounted() {
		this.logged = localStorage.getItem("x_api_key") != null;
	},
};
</script>
