/** @format */

import ApiService from "./api.service.js";

const auth = (data) => {
	return ApiService.auth("/action/auth", data);
};

export { auth };
