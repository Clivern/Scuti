/** @format */

import axios from "axios";

const ApiService = {
	getURL(endpoint) {
		let apiURL = "";

		if (process.env.VUE_APP_API_URL) {
			apiURL = process.env.VUE_APP_API_URL.replace(/\/$/, "");
		}

		return apiURL + endpoint;
	},

	getHeaders(api_key = null) {
		let user_id = "";
		let user_uuid = "";
		let session_id = "";
		let session_uuid = "";

		if (localStorage.getItem("x_api_key") != null && api_key == null) {
			api_key = localStorage.getItem("x_api_key");
		}

		if (localStorage.getItem("x_user_id") != null) {
			user_id = localStorage.getItem("x_user_id");
		}

		if (localStorage.getItem("x_user_uuid") != null) {
			user_uuid = localStorage.getItem("x_user_uuid");
		}

		if (localStorage.getItem("x_session_id") != null) {
			session_id = localStorage.getItem("x_session_id");
		}

		if (localStorage.getItem("x_session_uuid") != null) {
			session_uuid = localStorage.getItem("x_session_uuid");
		}

		return {
			crossdomain: true,

			headers: {
				"X-API-Key": api_key,
				"X-USER-ID": user_id,
				"X-USER-UUID": user_uuid,
				"X-SESSION-ID": session_id,
				"X-SESSION-UUID": session_uuid,
				"X-Client-ID": "dashboard",
				"X-Requested-With": "XMLHttpRequest",
				"Content-Type": "application/json",
			},
		};
	},

	get(endpoint) {
		return axios.get(this.getURL(endpoint), this.getHeaders());
	},

	delete(endpoint) {
		return axios.delete(this.getURL(endpoint), this.getHeaders());
	},

	post(endpoint, data = {}) {
		return axios.post(this.getURL(endpoint), data, this.getHeaders());
	},

	put(endpoint, data = {}) {
		return axios.put(this.getURL(endpoint), data, this.getHeaders());
	},

	auth(endpoint, data = {}) {
		return axios.post(this.getURL(endpoint), data, this.getHeaders());
	},
};

export default ApiService;
