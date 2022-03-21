## Proxy settings
Sys.getenv()
Sys.setenv(http_proxy = "http://empweb1.ey.net:8080")
Sys.setenv(https_proxy = "http://empweb1.ey.net:8443")


Sys.unsetenv("http_proxy")
Sys.unsetenv("https_proxy")
