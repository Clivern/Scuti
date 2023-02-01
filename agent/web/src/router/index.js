/** @format */

import Vue from "vue";
import VueRouter from "vue-router";

Vue.use(VueRouter);

const routes = [
	{
		path: "/",
		name: "Home",
		component: () => import("../views/Home.vue"),
		meta: {
			requiresAuth: false,
		},
	},
	{
		path: "/login",
		name: "Login",
		component: () => import("../views/Login.vue"),
		meta: {
			requiresAuth: false,
		},
	},
	{
		path: "/install",
		name: "Install",
		component: () => import("../views/Install.vue"),
		meta: {
			requiresAuth: false,
		},
	},
	{
		path: "/admin/dashboard",
		name: "Dashboard",
		component: () => import("../views/Dashboard.vue"),
		meta: {
			requiresAuth: true,
		},
	},
	{
		path: "/admin/hostgroups",
		name: "HostGroupsList",
		component: () => import("../views/HostGroupsList.vue"),
		meta: {
			requiresAuth: true,
		},
	},
	{
		path: "/admin/hostgroups/add",
		name: "HostGroupsAdd",
		component: () => import("../views/HostGroupsAdd.vue"),
		meta: {
			requiresAuth: true,
		},
	},
	{
		path: "/admin/hostgroups/edit/:id",
		name: "HostGroupsEdit",
		component: () => import("../views/HostGroupsEdit.vue"),
		meta: {
			requiresAuth: true,
		},
	},
	{
		path: "/admin/hosts",
		name: "HostsList",
		component: () => import("../views/HostsList.vue"),
		meta: {
			requiresAuth: true,
		},
	},
	{
		path: "/admin/hosts/add",
		name: "HostsAdd",
		component: () => import("../views/HostsAdd.vue"),
		meta: {
			requiresAuth: true,
		},
	},
	{
		path: "/admin/hosts/edit/:id",
		name: "HostsEdit",
		component: () => import("../views/HostsEdit.vue"),
		meta: {
			requiresAuth: true,
		},
	},
	{
		path: "/admin/deployments",
		name: "DeploymentsList",
		component: () => import("../views/DeploymentsList.vue"),
		meta: {
			requiresAuth: true,
		},
	},
	{
		path: "/admin/deployments/add",
		name: "DeploymentsAdd",
		component: () => import("../views/DeploymentsAdd.vue"),
		meta: {
			requiresAuth: true,
		},
	},
	{
		path: "/admin/deployments/edit/:id",
		name: "DeploymentsEdit",
		component: () => import("../views/DeploymentsEdit.vue"),
		meta: {
			requiresAuth: true,
		},
	},
	{
		path: "/admin/users",
		name: "UsersList",
		component: () => import("../views/UsersList.vue"),
		meta: {
			requiresAuth: true,
		},
	},
	{
		path: "/admin/users/add",
		name: "UsersAdd",
		component: () => import("../views/UsersAdd.vue"),
		meta: {
			requiresAuth: true,
		},
	},
	{
		path: "/admin/users/edit/:id",
		name: "UsersEdit",
		component: () => import("../views/UsersEdit.vue"),
		meta: {
			requiresAuth: true,
		},
	},
	{
		path: "/admin/teams",
		name: "TeamsList",
		component: () => import("../views/TeamsList.vue"),
		meta: {
			requiresAuth: true,
		},
	},
	{
		path: "/admin/teams/add",
		name: "TeamsAdd",
		component: () => import("../views/TeamsAdd.vue"),
		meta: {
			requiresAuth: true,
		},
	},
	{
		path: "/admin/teams/edit/:id",
		name: "TeamsEdit",
		component: () => import("../views/TeamsEdit.vue"),
		meta: {
			requiresAuth: true,
		},
	},
	{
		path: "/404",
		name: "NotFound",
		component: () => import("../views/NotFound.vue"),
		meta: {
			requiresAuth: false,
		},
	},
	{
		path: "*",
		redirect: "/404",
	},
];

const router = new VueRouter({
	routes,
});

// Auth Middleware
router.beforeEach((to, from, next) => {
	if (to.matched.some((record) => record.meta.requiresAuth)) {
		if (localStorage.getItem("x_api_key") == null) {
			next({
				path: "/login",
				params: { nextUrl: to.fullPath },
			});
		}
	} else if (to.name == "Login") {
		localStorage.removeItem("x_api_key");
	}
	next();
});

export default router;
