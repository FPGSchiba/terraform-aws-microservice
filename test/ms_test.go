package test

import (
	"fmt"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"regexp"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func validateBody(statusCode int, body string) bool {
	if statusCode == 200 {
		fmt.Println(body)
		r, _ := regexp.Compile("{\"Region\": \"(us(-gov)?|ap|ca|cn|eu|sa)-(central|(north|south)?(east|west)?)-\\d\"}")
		matched := r.MatchString(body)
		if matched {
			return true
		} else {
			return false
		}
	} else {
		return false
	}
}

func TestMicroservice(t *testing.T) {
	awsRegion := "eu-central-1"
	pathName := "test"

	terraformOpts := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./terraform/",
		Vars: map[string]interface{}{
			"suffix":       strings.ToLower(random.UniqueId()),
			"code_dir":     "files/region-test/",
			"cors_enabled": true,
			"prefix":       fmt.Sprintf("microservice-terratest-%s", strings.ToLower(random.UniqueId())),
			"path_name":    pathName,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	})

	defer terraform.Destroy(t, terraformOpts)

	terraform.InitAndApply(t, terraformOpts)

	stageUrl := terraform.Output(t, terraformOpts, "stage_url")

	url := fmt.Sprintf("%s/%s", stageUrl, pathName)
	http_helper.HttpGetWithRetryWithCustomValidation(t, url, nil, 5, 5*time.Second, validateBody)
}
