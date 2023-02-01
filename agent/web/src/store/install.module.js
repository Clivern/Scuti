/** @format */

import { install } from "@/common/install.api";

const state = () => ({
	installResult: {},
});

const getters = {
	getInstall: (state) => {
		return state.installResult;
	},
};

const actions = {
	async installAction(context, data) {
		const result = await install(data);
		context.commit("SET_INSTALL_RESULT", result.data);
		return result;
	},
};

const mutations = {
	SET_INSTALL_RESULT(state, installResult) {
		state.installResult = installResult;
	},
};

export default {
	namespaced: true,
	state,
	getters,
	actions,
	mutations,
};
