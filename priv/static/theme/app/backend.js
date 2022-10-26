let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

var scuti_app = scuti_app || {};

function show_notification(text) {
    $("#toast_notification").removeClass("hide");
    $("#toast_notification").addClass("show");
    $("#toast_notification").find(".toast-body").text(text);
}

function format_datetime(datetime) {
    const originalDate = new Date(datetime);

    const formattedDate = originalDate.toLocaleString(
        'en-US',
        {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit',
            hour12: true
        }
    );

    return formattedDate;
}

// Install Page
scuti_app.install_screen = (Vue, axios, $) => {

    return new Vue({
        delimiters: ['${', '}'],
        el: '#app_install',
        data() {
            return {
                isInProgress: false,
            }
        },
        methods: {
            installAction(event) {
                event.preventDefault();
                this.isInProgress = true;

                let inputs = {};
                let _self = $(event.target);
                let _form = _self.closest("form");

                _form.serializeArray().map((item, index) => {
                    inputs[item.name] = item.value;
                });

                axios.post(_form.attr('action'), inputs)
                    .then((response) => {
                        if (response.status >= 200) {
                            show_notification(response.data.successMessage);
                            location.reload();
                        }
                    })
                    .catch((error) => {
                        this.isInProgress = false;
                        // Show error
                        show_notification(error.response.data.errorMessage);
                    });
            }
        }
    });

}

// Login Page
scuti_app.login_screen = (Vue, axios, $) => {

    return new Vue({
        delimiters: ['${', '}'],
        el: '#app_login',
        data() {
            return {
                isInProgress: false,
            }
        },
        methods: {
            loginAction(event) {
                event.preventDefault();
                this.isInProgress = true;

                let inputs = {};
                let _self = $(event.target);
                let _form = _self.closest("form");

                _form.serializeArray().map((item, index) => {
                    inputs[item.name] = item.value;
                });

                axios.post(_form.attr('action'), inputs)
                    .then((response) => {
                        if (response.status >= 200) {
                            show_notification(response.data.successMessage);
                            Cookies.set('_token', response.data.token);
                            Cookies.set('_uid', response.data.user);
                            location.reload();
                        }
                    })
                    .catch((error) => {
                        this.isInProgress = false;
                        // Show error
                        show_notification(error.response.data.errorMessage);
                    });
            }
        }
    });

}

// Settings Page
scuti_app.settings_screen = (Vue, axios, $) => {

    return new Vue({
        delimiters: ['${', '}'],
        el: '#app_settings',
        data() {
            return {
                isInProgress: false,
            }
        },
        methods: {
            settingsAction(event) {
                event.preventDefault();
                this.isInProgress = true;

                let inputs = {};
                let _self = $(event.target);
                let _form = _self.closest("form");

                _form.serializeArray().map((item, index) => {
                    inputs[item.name] = item.value;
                });

                axios.put(_form.attr('action'), inputs)
                    .then((response) => {
                        if (response.status >= 200) {
                            show_notification(response.data.successMessage);
                        }
                    })
                    .catch((error) => {
                        this.isInProgress = false;
                        // Show error
                        show_notification(error.response.data.errorMessage);
                    });
            }
        }
    });

}

// Profile Page
scuti_app.profile_screen = (Vue, axios, $) => {

    return new Vue({
        delimiters: ['${', '}'],
        el: '#app_profile',
        data() {
            return {
                isInProgress: false,
            }
        },
        methods: {
            profileAction(event) {
                event.preventDefault();
                this.isInProgress = true;

                let inputs = {};
                let _self = $(event.target);
                let _form = _self.closest("form");

                _form.serializeArray().map((item, index) => {
                    inputs[item.name] = item.value;
                });

                axios.post(_form.attr('action'), inputs)
                    .then((response) => {
                        if (response.status >= 200) {
                            show_notification(response.data.successMessage);
                        }
                    })
                    .catch((error) => {
                        this.isInProgress = false;
                        // Show error
                        show_notification(error.response.data.errorMessage);
                    });
            }
        }
    });

}

// Add User Modal
scuti_app.add_user_modal = (Vue, axios, $) => {

    return new Vue({
        delimiters: ['${', '}'],
        el: '#add_user_modal',
        data() {
            return {
                isInProgress: false,
            }
        },
        methods: {
            addUserAction(event) {
                event.preventDefault();
                this.isInProgress = true;

                let inputs = {};
                let _self = $(event.target);
                let _form = _self.closest("form");

                _form.serializeArray().map((item, index) => {
                    inputs[item.name] = item.value;
                });

                axios.post(_form.attr('action'), inputs)
                    .then((response) => {
                        if (response.status >= 200) {
                            show_notification(i18n_globals.new_user);
                            setTimeout(() => {
                                location.reload();
                            }, 2000);
                        }
                    })
                    .catch((error) => {
                        this.isInProgress = false;
                        // Show error
                        show_notification(error.response.data.errorMessage);
                    });
            }
        }
    });

}

// Add Team Modal
scuti_app.add_team_modal = (Vue, axios, $) => {

    return new Vue({
        delimiters: ['${', '}'],
        el: '#add_team_modal',
        data() {
            return {
                isInProgress: false,
                users: [],
                teamName: '',
                teamSlug: ''
            }
        },
        mounted() {
            this.loadData();
        },
        methods: {
            slugifyTeamName() {
                this.teamSlug = this.teamName.toLowerCase().replace(/\s+/g, '-');
            },
            loadData() {
                axios.get($("#add_team_modal").attr("data-action"), {
                        params: {
                            offset: 0,
                            limit: 10000
                        }
                    })
                    .then((response) => {
                        if (response.status >= 200) {
                            this.users = response.data.users;
                        }
                    })
                    .catch((error) => {
                        show_notification(error.response.data.errorMessage);
                    });
            },
            addTeamAction(event) {
                event.preventDefault();
                this.isInProgress = true;

                let inputs = {};
                let _self = $(event.target);
                let _form = _self.closest("form");

                _form.serializeArray().map((item, index) => {
                    inputs[item.name] = item.value;
                });

                inputs["members"] = $("[name='members']").val();

                axios.post(_form.attr('action'), inputs)
                    .then((response) => {
                        if (response.status >= 200) {
                            show_notification(i18n_globals.new_team);
                            setTimeout(() => {
                                location.reload();
                            }, 2000);
                        }
                    })
                    .catch((error) => {
                        this.isInProgress = false;
                        // Show error
                        show_notification(error.response.data.errorMessage);
                    });
            }
        }
    });

}

// Teams list
scuti_app.teams_list = (Vue, axios, $) => {

    return new Vue({
        delimiters: ['${', '}'],
        el: '#teams_list',
        data() {
            return {
                currentPage: 1,
                limit: 10,
                totalCount: 5,
                teams: []
            }
        },
        mounted() {
            this.loadDataAction();
        },
        computed: {
            totalPages() {
                return Math.ceil(this.totalCount / this.limit);
            }
        },
        methods: {
            editTeamAction(id) {
                console.log("Edit team with ID:", id);
            },

            formatDatetime(datatime) {
                return format_datetime(datatime);
            },

            deleteTeamAction(id) {
                if (confirm(i18n_globals.delete_team_alert) != true) {
                    return;
                }

                axios.delete(i18n_globals.delete_team_endpoint.replace("UUID", id), {})
                    .then((response) => {
                        if (response.status >= 200) {
                            show_notification(i18n_globals.delete_team_message);
                            setTimeout(() => { location.reload(); }, 2000);
                        }
                    })
                    .catch((error) => {
                        show_notification(error.response.data.errorMessage);
                    });
            },
            loadDataAction() {
                var offset = (this.currentPage - 1) * this.limit;

                axios.get($("#teams_list").attr("data-action"), {
                        params: {
                            offset: offset,
                            limit: this.limit
                        }
                    })
                    .then((response) => {
                        if (response.status >= 200) {
                            this.teams = response.data.teams;
                            this.limit = response.data._metadata.limit;
                            this.offset = response.data._metadata.offset;
                            this.totalCount = response.data._metadata.totalCount;
                        }
                    })
                    .catch((error) => {
                        show_notification(error.response.data.errorMessage);
                    });
            },
            loadPreviousPageAction(event) {
                event.preventDefault();

                if (this.currentPage > 1) {
                    this.currentPage--;
                    this.loadDataAction();
                }
            },
            loadNextPageAction(event) {
                event.preventDefault();

                if (this.currentPage < this.totalPages) {
                    this.currentPage++;
                    this.loadDataAction();
                }
            }
        }
    });
}

// Users list
scuti_app.users_list = (Vue, axios, $) => {

    return new Vue({
        delimiters: ['${', '}'],
        el: '#users_list',
        data() {
            return {
                currentPage: 1,
                limit: 10,
                totalCount: 5,
                users: []
            }
        },
        mounted() {
            this.loadDataAction();
        },
        computed: {
            totalPages() {
                return Math.ceil(this.totalCount / this.limit);
            }
        },
        methods: {
            editUserAction(id) {
                console.log("Edit user with ID:", id);
            },

            formatDatetime(datatime) {
                return format_datetime(datatime);
            },

            deleteUserAction(id) {
                if (confirm(i18n_globals.delete_user_alert) != true) {
                    return;
                }

                axios.delete(i18n_globals.delete_user_endpoint.replace("UUID", id), {})
                    .then((response) => {
                        if (response.status >= 200) {
                            show_notification(i18n_globals.delete_user_message);
                            setTimeout(() => { location.reload(); }, 2000);
                        }
                    })
                    .catch((error) => {
                        show_notification(error.response.data.errorMessage);
                    });
            },

            loadDataAction() {
                var offset = (this.currentPage - 1) * this.limit;

                axios.get($("#users_list").attr("data-action"), {
                        params: {
                            offset: offset,
                            limit: this.limit
                        }
                    })
                    .then((response) => {
                        if (response.status >= 200) {
                            this.users = response.data.users;
                            this.limit = response.data._metadata.limit;
                            this.offset = response.data._metadata.offset;
                            this.totalCount = response.data._metadata.totalCount;
                        }
                    })
                    .catch((error) => {
                        show_notification(error.response.data.errorMessage);
                    });
            },
            loadPreviousPageAction(event) {
                event.preventDefault();

                if (this.currentPage > 1) {
                    this.currentPage--;
                    this.loadDataAction();
                }
            },
            loadNextPageAction(event) {
                event.preventDefault();

                if (this.currentPage < this.totalPages) {
                    this.currentPage++;
                    this.loadDataAction();
                }
            }
        }
    });
}

$(document).ready(() => {
    axios.defaults.headers.common = {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': csrfToken
    };

    if (document.getElementById("app_install")) {
        scuti_app.install_screen(
            Vue,
            axios,
            $
        );
    }

    if (document.getElementById("app_login")) {
        scuti_app.login_screen(
            Vue,
            axios,
            $
        );
    }

    if (document.getElementById("app_settings")) {
        scuti_app.settings_screen(
            Vue,
            axios,
            $
        );
    }

    if (document.getElementById("app_profile")) {
        scuti_app.profile_screen(
            Vue,
            axios,
            $
        );
    }

    if (document.getElementById("add_user_modal")) {
        scuti_app.add_user_modal(
            Vue,
            axios,
            $
        );
    }

    if (document.getElementById("add_team_modal")) {
        scuti_app.add_team_modal(
            Vue,
            axios,
            $
        );
    }

    if (document.getElementById("teams_list")) {
        scuti_app.teams_list(
            Vue,
            axios,
            $
        );
    }

    if (document.getElementById("users_list")) {
        scuti_app.users_list(
            Vue,
            axios,
            $
        );
    }
});
