package main

import (
	"github.com/spohnan/ws-test-01/meta"
)

// The main version number that is being run at the moment.
const Version = "1.0.1"

// A pre-release marker for the version. If this is "" (empty string)
// then it means that it is a final release. Otherwise, this is a pre-release
// such as "dev" (in development), "beta", "rc1", etc.
const VersionPrerelease = "SNAPSHOT"

// The git commit that was compiled. This will be filled in by the compiler.
var GitCommit string

// The version of Golang used to compile the app
var GolangVersion string

// A timestamp when the program was compiled
var BuildDate string

func InitAppInfo() {
	meta.App.Version = Version
	meta.App.VersionPrerelease = VersionPrerelease
	meta.App.GitCommit = GitCommit
	meta.App.BuildDate = BuildDate
}
