/** @format */

import ApiService from "./api.service.js";

const getReadiness = () => {
	return ApiService.get("/ready");
};

const getHealth = () => {
	return ApiService.get("/health");
};

const auth = (email, password) => {
	return ApiService.auth("/action/auth", { email: email, password: password });
};

export { getReadiness, getHealth, auth };
