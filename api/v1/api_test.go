package api

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestVersion(t *testing.T) {
	req, _ := http.NewRequest("GET", "/version", nil)
	resp := httptest.NewRecorder()

	versionHandler(resp, req)

	if resp.Code != http.StatusOK {
		t.Errorf("Response code is %v", resp.Code)
	}

}
