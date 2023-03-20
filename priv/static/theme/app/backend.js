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

function generateRandomSecret() {
  const secretChars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#^&*()';

  let secret = '';
  for (let i = 0; i < 20; i++) {
    secret += secretChars.charAt(Math.floor(Math.random() * secretChars.length));
  }

  return secret;
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
scuti_app.profile_api_screen = (Vue, axios, $) => {

    return new Vue({
        delimiters: ['${', '}'],
        el: '#app_api_key',
        data() {
            return {
                apiKey: "*********************",
                isInProgress: false,
            }
        },
        methods: {
            showApiKeyAction(event) {
                event.preventDefault();
                this.isInProgress = true;

                axios.get(_globals.fetch_api_key_endpoint)
                    .then((response) => {
                        if (response.status >= 200) {
                            this.apiKey = response.data.apiKey;
                        }
                    })
                    .catch((error) => {
                        this.isInProgress = false;
                        // Show error
                        show_notification(error.response.data.errorMessage);
                    });
            },

            rotateApiKeyAction(event) {
                event.preventDefault();
                this.isInProgress = true;

                let inputs = {};
                let _self = $(event.target);
                let _form = _self.closest("form");

                _form.serializeArray().map((item, index) => {
                    inputs[item.name] = item.value;
                });

                axios.put(_globals.rotate_api_key_endpoint, {})
                    .then((response) => {
                        if (response.status >= 200) {
                            this.apiKey = response.data.apiKey;
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
                            show_notification(_globals.new_user);
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
                teamName: ''
            }
        },
        mounted() {
            this.loadData();
        },
        methods: {
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

                inputs["members"] = $("form#add_team_form select[name='members']").val();

                axios.post(_form.attr('action'), inputs)
                    .then((response) => {
                        if (response.status >= 200) {
                            show_notification(_globals.new_team);
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
            showTeamInfoAction(description) {
                $("div#team_info_modal_content").text(description);
            },

            editTeamAction(id) {
                let current = $('form#update_team_form input[name="uuid"]').val()
                if (current != "") {
                    $('form#update_team_form').attr('action', function(i, val) {
                        return val.replace(current, "UUID");
                    });
                }

                $('form#update_team_form input[name="uuid"]').val(id);
                $('form#update_team_form').attr('action', function(i, val) {
                    return val.replace('UUID', id);
                });

                axios.get($("#update_team_form").attr("action"))
                    .then((response) => {
                        if (response.status >= 200) {
                            $('form#update_team_form input[name="name"]').val(response.data.name);
                            $('form#update_team_form input[name="slug"]').val(response.data.slug);
                            $('form#update_team_form textarea[name="description"]').val(response.data.description);
                            $('form#update_team_form select[name="members"]').val(response.data.members);
                        }
                    })
                    .catch((error) => {
                        show_notification(error.response.data.errorMessage);
                    });
            },

            formatDatetime(datatime) {
                return format_datetime(datatime);
            },

            deleteTeamAction(id) {
                if (confirm(_globals.delete_team_alert) != true) {
                    return;
                }

                axios.delete(_globals.delete_team_endpoint.replace("UUID", id), {})
                    .then((response) => {
                        if (response.status >= 200) {
                            show_notification(_globals.delete_team_message);
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

scuti_app.edit_team_modal = (Vue, axios, $) => {

    return new Vue({
        delimiters: ['${', '}'],
        el: '#edit_team_modal',
        data() {
            return {
                isInProgress: false,
                users: []
            }
        },
        mounted() {
            this.loadData();
        },
        methods: {
            loadData() {
                axios.get($("#edit_team_modal").attr("data-action"), {
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
            updateTeamAction(event) {
                event.preventDefault();
                this.isInProgress = true;

                let inputs = {};
                let _self = $(event.target);
                let _form = _self.closest("form");

                _form.serializeArray().map((item, index) => {
                    inputs[item.name] = item.value;
                });

                inputs["members"] = $("form#update_team_form select[name='members']").val();

                axios.put(_form.attr('action'), inputs)
                    .then((response) => {
                        if (response.status >= 200) {
                            show_notification(_globals.update_team_message);

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
                let current = $('form#update_user_form input[name="uuid"]').val()
                if (current != "") {
                    $('form#update_user_form').attr('action', function(i, val) {
                        return val.replace(current, "UUID");
                    });
                }

                $('form#update_user_form input[name="uuid"]').val(id);
                $('form#update_user_form').attr('action', function(i, val) {
                    return val.replace('UUID', id);
                });

                axios.get($("#update_user_form").attr("action"))
                    .then((response) => {
                        if (response.status >= 200) {
                            $('form#update_user_form input[name="name"]').val(response.data.name);
                            $('form#update_user_form select[name="role"]').val(response.data.role);
                            $('form#update_user_form input[name="email"]').val(response.data.email);
                        }
                    })
                    .catch((error) => {
                        show_notification(error.response.data.errorMessage);
                    });
            },

            formatDatetime(datatime) {
                return format_datetime(datatime);
            },

            deleteUserAction(id) {
                if (confirm(_globals.delete_user_alert) != true) {
                    return;
                }

                axios.delete(_globals.delete_user_endpoint.replace("UUID", id), {})
                    .then((response) => {
                        if (response.status >= 200) {
                            show_notification(_globals.delete_user_message);
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

scuti_app.edit_user_modal = (Vue, axios, $) => {

    return new Vue({
        delimiters: ['${', '}'],
        el: '#edit_user_modal',
        data() {
            return {
                isInProgress: false
            }
        },
        methods: {
            updateUserAction(event) {
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
                            show_notification(_globals.update_user_message);

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

// Groups list
scuti_app.groups_list = (Vue, axios, $) => {

    return new Vue({
        delimiters: ['${', '}'],
        el: '#groups_list',
        data() {
            return {
                currentPage: 1,
                limit: 10,
                totalCount: 5,
                groups: [],
                groupModal: null
            }
        },
        mounted() {
            this.loadDataAction();
            this.groupModal = $("div#group_info_modal_content").html();
        },
        computed: {
            totalPages() {
                return Math.ceil(this.totalCount / this.limit);
            }
        },
        methods: {
            showGroupInfoAction(group) {
                var data = this.groupModal;
                data = data.replace("_HOST_GROUP_UUID", group.id);
                data = data.replace("_HOST_GROUP_SECRET", group.secretKey);
                $("div#group_info_modal_content").html(data);
            },

            editGroupAction(id) {
                let current = $('form#update_group_form input[name="uuid"]').val()
                if (current != "") {
                    $('form#update_group_form').attr('action', function(i, val) {
                        return val.replace(current, "UUID");
                    });
                }

                $('form#update_group_form input[name="uuid"]').val(id);
                $('form#update_group_form').attr('action', function(i, val) {
                    return val.replace('UUID', id);
                });

                axios.get($("#update_group_form").attr("action"))
                    .then((response) => {
                        if (response.status >= 200) {
                            $('form#update_group_form input[name="name"]').val(response.data.name);
                            $('form#update_group_form textarea[name="description"]').val(response.data.description);
                            $('form#update_group_form textarea[name="labels"]').val(response.data.labels);
                            if (response.data.remoteJoin) {
                                $('form#update_group_form select[name="remote_join"]').val("enabled");
                            } else {
                                $('form#update_group_form select[name="remote_join"]').val("disabled");
                            }
                            $('form#update_group_form select[name="team_id"]').val(response.data.team.id);
                        }
                    })
                    .catch((error) => {
                        show_notification(error.response.data.errorMessage);
                    });
            },

            formatDatetime(datatime) {
                return format_datetime(datatime);
            },

            viewGroupAction(id) {
                window.location.href = _globals.group_view_page.replace("UUID", id);
            },

            deleteGroupAction(id) {
                if (confirm(_globals.delete_group_alert) != true) {
                    return;
                }

                axios.delete(_globals.delete_group_endpoint.replace("UUID", id), {})
                    .then((response) => {
                        if (response.status >= 200) {
                            show_notification(_globals.delete_group_message);
                            setTimeout(() => { location.reload(); }, 2000);
                        }
                    })
                    .catch((error) => {
                        show_notification(error.response.data.errorMessage);
                    });
            },

            loadDataAction() {
                var offset = (this.currentPage - 1) * this.limit;

                axios.get($("#groups_list").attr("data-action"), {
                        params: {
                            offset: offset,
                            limit: this.limit
                        }
                    })
                    .then((response) => {
                        if (response.status >= 200) {
                            this.groups = response.data.groups;
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

scuti_app.edit_group_modal = (Vue, axios, $) => {

    return new Vue({
        delimiters: ['${', '}'],
        el: '#edit_group_modal',
        data() {
            return {
                isInProgress: false,
                teams: []
            }
        },
        mounted() {
            this.loadDataAction();
        },
        methods: {
            loadDataAction() {
                axios.get($("#edit_group_modal").attr("data-action"), {
                        params: {
                            offset: 0,
                            limit: 10000
                        }
                    })
                    .then((response) => {
                        if (response.status >= 200) {
                            this.teams = response.data.teams;
                        }
                    })
                    .catch((error) => {
                        show_notification(error.response.data.errorMessage);
                    });
            },
            updateGroupAction(event) {
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
                            show_notification(_globals.update_group_message);

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

// Add Group Modal
scuti_app.add_group_modal = (Vue, axios, $) => {

    return new Vue({
        delimiters: ['${', '}'],
        el: '#add_group_modal',
        data() {
            return {
                isInProgress: false,
                teams: []
            }
        },
        mounted() {
            this.loadData();
        },
        methods: {
            loadData() {
                axios.get($("#add_group_modal").attr("data-action"), {
                        params: {
                            offset: 0,
                            limit: 10000
                        }
                    })
                    .then((response) => {
                        if (response.status >= 200) {
                            this.teams = response.data.teams;
                        }
                    })
                    .catch((error) => {
                        show_notification(error.response.data.errorMessage);
                    });
            },
            addGroupAction(event) {
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
                            show_notification(_globals.new_group);
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

// Hosts list
scuti_app.hosts_list = (Vue, axios, $) => {

    return new Vue({
        delimiters: ['${', '}'],
        el: '#hosts_list',
        data() {
            return {
                currentPage: 1,
                limit: 10,
                totalCount: 5,
                hosts: [],
                hostModal: null
            }
        },
        mounted() {
            this.loadDataAction();
            this.hostModal = $("div#host_info_modal_content").html();
        },
        computed: {
            totalPages() {
                return Math.ceil(this.totalCount / this.limit);
            }
        },
        methods: {
            showHostInfoAction(host) {
                var data = this.hostModal;
                data = data.replace("_HOST_GROUP_UUID", host.group.id);
                data = data.replace("_HOST_UUID", host.id);
                data = data.replace("_HOST_GROUP_SECRET", host.group.secretKey);
                data = data.replace("_HOST_SECRET", host.secretKey);
                $("div#host_info_modal_content").html(data);
            },

            formatDatetime(datatime) {
                return format_datetime(datatime);
            },

            deleteHostAction(id) {
                if (confirm(_globals.delete_host_alert) != true) {
                    return;
                }

                axios.delete(_globals.delete_host_endpoint.replace("UUID", id), {})
                    .then((response) => {
                        if (response.status >= 200) {
                            show_notification(_globals.delete_host_message);
                            setTimeout(() => { location.reload(); }, 2000);
                        }
                    })
                    .catch((error) => {
                        show_notification(error.response.data.errorMessage);
                    });
            },

            loadDataAction() {
                var offset = (this.currentPage - 1) * this.limit;

                axios.get($("#hosts_list").attr("data-action"), {
                        params: {
                            offset: offset,
                            limit: this.limit
                        }
                    })
                    .then((response) => {
                        if (response.status >= 200) {
                            this.hosts = response.data.hosts;
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

// Add Host Modal
scuti_app.add_host_modal01 = (Vue, axios, $) => {

    return new Vue({
        delimiters: ['${', '}'],
        el: '#mentry',
        data() {
            return {
                isInProgress: false
            }
        },
        mounted() {
            $('input[name="secret_key"]').val(generateRandomSecret());
        },
        methods: {
            addHostAction(event) {
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
                            show_notification(_globals.new_host);
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


// Add Host Modal
scuti_app.add_host_modal02 = (Vue, axios, $) => {

    return new Vue({
        delimiters: ['${', '}'],
        el: '#rjoin',
        data() {
            return {
                group: {}
            }
        },
        mounted() {
            this.loadDataAction();
        },
        methods: {
            loadDataAction() {
                axios.get($("#rjoin").attr("data-action"))
                    .then((response) => {
                        if (response.status >= 200) {
                            this.group = response.data;
                            this.group.hostUUID = crypto.randomUUID();
                            this.group.hostSecret = generateRandomSecret();
                            $("#host_group_name").text(this.group.name);
                        }
                    })
                    .catch((error) => {
                        show_notification(error.response.data.errorMessage);
                    });
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

    if (document.getElementById("app_api_key")) {
        scuti_app.profile_api_screen(
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

    if (document.getElementById("edit_user_modal")) {
        scuti_app.edit_user_modal(
            Vue,
            axios,
            $
        );
    }

    if (document.getElementById("edit_team_modal")) {
        scuti_app.edit_team_modal(
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

    if (document.getElementById("groups_list")) {
        scuti_app.groups_list(
            Vue,
            axios,
            $
        );
    }

    if (document.getElementById("edit_group_modal")) {
        scuti_app.edit_group_modal(
            Vue,
            axios,
            $
        );
    }

    if (document.getElementById("add_group_modal")) {
        scuti_app.add_group_modal(
            Vue,
            axios,
            $
        );
    }


    if (document.getElementById("hosts_list")) {
        scuti_app.hosts_list(
            Vue,
            axios,
            $
        );
    }

    if (document.getElementById("add_host_modal")) {
        scuti_app.add_host_modal01(
            Vue,
            axios,
            $
        );
    }

    if (document.getElementById("add_host_modal")) {
        scuti_app.add_host_modal02(
            Vue,
            axios,
            $
        );
    }
});
