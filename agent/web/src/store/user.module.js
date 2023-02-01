/** @format */

import { auth } from "@/common/user.api";

const state = () => ({
	authResult: {},
});

const getters = {
	getAuth: (state) => {
		return state.authResult;
	},
};

const actions = {
	async authAction(context, data) {
		const result = await auth(data);
		context.commit("SET_AUTH_RESULT", result.data);
		return result;
	},
};

const mutations = {
	SET_AUTH_RESULT(state, authResult) {
		state.authResult = authResult;
	},
};

export default {
	namespaced: true,
	state,
	getters,
	actions,
	mutations,
};
