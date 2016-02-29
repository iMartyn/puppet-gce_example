class ourgo ($version = "latest") {
          package {"golang-go":
            ensure => $version, # Using the class parameter from above
          }
          file {"/local/":
            ensure  => directory,
          }
          file {"/local/code/":
            ensure  => directory,
          }
          file {"/local/code/file.go":
            ensure  => present,
            content => "package main\n\nimport (\n    \"fmt\"\n    \"net/http\"\n    \"os\"\n)\n\nfunc handler(w http.ResponseWriter, r *http.Request) {\n    h, _ := os.Hostname()\n    fmt.Fprintf(w, \"Hi there, This is served from %s!\", h)\n}\n\nfunc main() {\n    http.HandleFunc(\"/\", handler)\n    http.ListenAndServe(\":8080\", nil)\n}",
            require => Package["golang-go"],
          }
          exec {"whatnoservice":
            command => "/usr/bin/go run /local/code/file.go &",
            require => File["/local/code/file.go"],
          }
        }
include ourgo
