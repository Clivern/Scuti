<!-- @format -->
<template>
	<div class="columns is-desktop is-centered">
		<div class="column is-4">
			<br />
			<img alt="logo" src="../assets/logo.png" width="200" />
			<br /><br />
			<b-field label="Application Name">
				<b-input
					v-model="form.app_name"
					placeholder="Mandrill"
					rounded
				></b-input>
			</b-field>

			<b-field label="Application Email">
				<b-input
					v-model="form.app_email"
					placeholder="hello@mandrill.com"
					rounded
				></b-input>
			</b-field>

			<b-field label="Application URL">
				<b-input
					v-model="form.app_url"
					placeholder="http://mandrill.com"
					rounded
				></b-input>
			</b-field>

			<b-field label="Admin Name">
				<b-input
					v-model="form.admin_name"
					placeholder="Joe Doe"
					rounded
				></b-input>
			</b-field>

			<b-field label="Admin Email">
				<b-input
					v-model="form.admin_email"
					placeholder="admin@mandrill.com"
					rounded
				></b-input>
			</b-field>

			<b-field label="Admin Password">
				<b-input
					type="password"
					v-model="form.admin_password"
					password-reveal
					rounded
				></b-input>
			</b-field>

			<div class="field">
				<p class="control">
					<b-button
						type="submit is-danger is-light"
						v-bind:disabled="form.button_disabled"
						@click="installEvent"
						>Install</b-button
					>
				</p>
			</div>
			<br />
			<small>
				Made with
				<span class="icon has-text-danger"><i class="fas fa-heart"></i></span>
				by
				<a href="https://github.com/Clivern" target="_blank" rel="noopener"
					>Clivern</a
				><br />
			</small>
		</div>
	</div>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
a {
	color: #42b983;
}
</style>

<script>
export default {
	name: "InstallPage",

	data() {
		return {
			// Loader
			loader: {
				isFullPage: true,
				ref: null,
			},
			form: {
				app_name: "",
				app_url: "",
				app_email: "",
				admin_name: "",
				admin_email: "",
				admin_password: "",
				button_disabled: false,
			},
		};
	},

	methods: {
		loading() {
			this.loader.ref = this.$buefy.loading.open({
				container: this.loader.isFullPage ? null : this.$refs.element.$el,
			});
		},
		installEvent() {
			this.form.button_disabled = true;

			this.$store
				.dispatch("install/installAction", {
					app_name: this.form.app_name,
					app_url: this.form.app_url,
					app_email: this.form.app_email,
					admin_name: this.form.admin_name,
					admin_email: this.form.admin_email,
					admin_password: this.form.admin_password,
				})
				.then(
					(res) => {
						this.$buefy.toast.open({
							message: res.data.successMessage,
							type: "is-success",
						});
						setTimeout(() => this.$router.push("/login"), 700);
					},
					(err) => {
						if (err.response.data.errorMessage) {
							this.$buefy.toast.open({
								message: err.response.data.errorMessage,
								type: "is-danger",
							});
						} else {
							this.$buefy.toast.open({
								message: "Oops! Something Goes Wrong!",
								type: "is-danger",
							});
						}
						this.form.button_disabled = false;
					}
				);
		},
	},

	mounted() {
		this.$emit("refresh-state");

		this.loading();

		this.$store.dispatch("health/fetchReadiness").then(
			() => {
				this.$router.push("/");
				this.loader.ref.close();
			},
			() => {
				this.$buefy.toast.open({
					message: "Please provide the following data to install Mandrill",
					type: "is-info is-light",
				});

				localStorage.removeItem("x_user_id");
				localStorage.removeItem("x_user_email");
				localStorage.removeItem("x_api_key");
				localStorage.removeItem("x_user_uuid");
				localStorage.removeItem("x_user_name");
				localStorage.removeItem("x_session_id");
				localStorage.removeItem("x_session_uuid");

				this.loader.ref.close();
			}
		);
	},
};
</script>
