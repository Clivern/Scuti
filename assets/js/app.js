// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

import socket from "./user_socket"
import "./modals.js"

var scuti_app = scuti_app || {};

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
                            toastr.clear();
                            toastr.info(response.data.successMessage);
                            location.reload();
                        }
                    })
                    .catch((error) => {
                        this.isInProgress = false;
                        // Show error
                        toastr.clear();
                        toastr.error(error.response.data.errorMessage);
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
                            toastr.clear();
                            toastr.info(response.data.successMessage);
                            Cookies.set('_token', response.data.token);
                            Cookies.set('_uid', response.data.user);
                            location.reload();
                        }
                    })
                    .catch((error) => {
                        this.isInProgress = false;
                        // Show error
                        toastr.clear();
                        toastr.error(error.response.data.errorMessage);
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
                            toastr.clear();
                            toastr.info(response.data.successMessage);
                        }
                    })
                    .catch((error) => {
                        this.isInProgress = false;
                        // Show error
                        toastr.clear();
                        toastr.error(error.response.data.errorMessage);
                    });
            }
        }
    });

}

// Add User Modal
scuti_app.add_user_modal = (Vue, axios, $) => {

    console.log("users_screen");

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
                            toastr.clear();
                            toastr.info(i18n_globals.new_user);
                            location.reload();
                        }
                    })
                    .catch((error) => {
                        this.isInProgress = false;
                        // Show error
                        toastr.clear();
                        toastr.error(error.response.data.errorMessage);
                    });
            },

            closeModal(event) {
                $("#add-new-user").removeClass("is-active");
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
            }
        },
        methods: {
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
                            toastr.clear();
                            toastr.info(i18n_globals.new_team);
                            location.reload();
                        }
                    })
                    .catch((error) => {
                        this.isInProgress = false;
                        // Show error
                        toastr.clear();
                        toastr.error(error.response.data.errorMessage);
                    });
            },

            closeModal(event) {
                $("#add-new-team").removeClass("is-active");
            }
        }
    });

}

$(document).ready(() => {
    axios.defaults.headers.common = {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': csrfToken,
        'X-User-Token': Cookies.get('_token') || '',
        'X-User-Id': Cookies.get('_uid') || ''
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
});
