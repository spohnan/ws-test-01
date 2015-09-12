package meta

type AppInfo struct {
	Version           string
	VersionPrerelease string
	GitCommit         string
	BuildDate         string
}

var App *AppInfo

func init() {
	App = &AppInfo{}
}
