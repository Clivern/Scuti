sq add mandrill.db --handle @mandrill

sq inspect @mandrill

sq ping --all

sq '@mandrill | .options | .[0:]' -j

sq '@mandrill | .sessions | .[0:]' -j

sq '@mandrill | .users | .[0:]' -j

sq '@mandrill | .tasks | .[0:]' -j

sq '@mandrill | .logs | .[0:]' -j

sq '@mandrill | .hosts | .[0:]' -j

sq '@mandrill | .host_groups | .[0:]' -j

sq '@mandrill | .deployments | .[0:]' -j

sq '@mandrill | .teams | .[0:]' -j

rhino serve -c api.mock.json

