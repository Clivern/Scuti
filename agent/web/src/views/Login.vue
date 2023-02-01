<!-- @format -->

<template>
	<div class="columns is-desktop is-centered">
		<div class="column is-4">
			<br />
			<img alt="logo" src="../assets/logo.png" width="200" />
			<br /><br />
			<b-field label="Email">
				<b-input
					v-model="form.email"
					placeholder="mandrill@clivern.com"
					rounded
				></b-input>
			</b-field>

			<b-field label="Password">
				<b-input
					type="password"
					v-model="form.password"
					password-reveal
					rounded
				></b-input>
			</b-field>

			<div class="field">
				<p class="control">
					<b-button
						type="submit is-danger is-light"
						v-bind:disabled="form.button_disabled"
						@click="loginEvent"
						>Login</b-button
					>
				</p>
			</div>
		</div>
	</div>
</template>

<script>
export default {
	name: "LoginPage",
	data() {
		return {
			form: {
				email: "",
				password: "",
				button_disabled: false,
			},
			// Loader
			loader: {
				isFullPage: true,
				ref: null,
			},
		};
	},

	methods: {
		loading() {
			this.loader.ref = this.$buefy.loading.open({
				container: this.loader.isFullPage ? null : this.$refs.element.$el,
			});
		},
		loginEvent() {
			this.form.button_disabled = true;

			this.$store
				.dispatch("user/authAction", {
					email: this.form.email,
					password: this.form.password,
				})
				.then(
					() => {
						this.$buefy.toast.open({
							message: "You logged in successfully",
							type: "is-success",
						});

						let user_id = this.$store.getters["user/getAuth"].user_id;
						let email = this.$store.getters["user/getAuth"].email;
						let api_key = this.$store.getters["user/getAuth"].api_key;
						let user_uuid = this.$store.getters["user/getAuth"].user_uuid;
						let name = this.$store.getters["user/getAuth"].name;
						let session_id = this.$store.getters["user/getAuth"].session_id;
						let session_uuid = this.$store.getters["user/getAuth"].session_uuid;
						let role = this.$store.getters["user/getAuth"].role;

						localStorage.setItem("x_user_id", user_id);
						localStorage.setItem("x_user_email", email);
						localStorage.setItem("x_api_key", api_key);
						localStorage.setItem("x_user_uuid", user_uuid);
						localStorage.setItem("x_user_name", name);
						localStorage.setItem("x_session_id", session_id);
						localStorage.setItem("x_session_uuid", session_uuid);
						localStorage.setItem("x_user_role", role);

						this.$router.push("/admin/dashboard");
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
				this.loader.ref.close();
			},
			() => {
				this.$router.push("/install");
				this.loader.ref.close();
			}
		);
	},
};
</script>
