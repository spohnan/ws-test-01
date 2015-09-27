package meta

type appInfo struct {
	Version           string
	VersionPrerelease string
	GitCommit         string
	BuildDate         string
}

// App contains information about the application build
var App *appInfo

func init() {
	App = &appInfo{}
}
