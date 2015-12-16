[![Go Report Card](http://goreportcard.com/badge/spohnan/ws-test-01)](http://goreportcard.com/report/spohnan/ws-test-01)

A trivial golang project for me to continue to learn Go and Docker

Build and run tests on local machine
------------------------------------
```
make run
```

Run within a Docker container
-----------------------------
```
make docker-run
```

Endpoints
---------

### Return an environment variable value
```
http://localhost:8080/api/v1/env/BAZ/ -> {"Name":"BAZ","Value":"BAZVAL2"}
```

### Return the hostname
```
http://localhost:8080/api/v1/host/ -> {"HostName":"edba47764b7a"}
```

#### (Fake) Health Check
```
http://localhost:8080/health -> OK
```

#### Version info
```
http://localhost:8080/version -> {"Version":"1.1.0","VersionPrerelease":"dev","GitCommit":"7ef41aa00898d46e9e063a8389ed972b90d02a2d+CHANGES","BuildDate":"2015-12-17T15:26:42Z"}
```