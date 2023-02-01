/** @format */

import ApiService from "./api.service.js";

const install = (data) => {
	return ApiService.post("/action/install", data);
};

export { install };
