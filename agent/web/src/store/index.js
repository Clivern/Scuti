/** @format */

import Vue from "vue";
import Vuex from "vuex";
import health from "./health.module";
import user from "./user.module";
import install from "./install.module";

Vue.use(Vuex);

export default new Vuex.Store({
	modules: {
		health,
		user,
		install,
	},
});
