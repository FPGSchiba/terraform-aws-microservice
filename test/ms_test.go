package test

import (
	"encoding/json"
	"fmt"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func validateBody(statusCode int, body string, region string) bool {
	fmt.Printf("Status code: %d\n", statusCode)
	fmt.Printf("Body: %s\n", body)
	if statusCode == 200 {
		var resBody map[string]string
		err := json.Unmarshal([]byte(body), &resBody)
		if err != nil {
			return false
		}
		if resBody["Region"] == region {
			return true
		}
		return false
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
	http_helper.HttpGetWithRetryWithCustomValidation(t, url, nil, 5, 5*time.Second, func(i int, s string) bool {
		return validateBody(i, s, awsRegion)
	})
}
