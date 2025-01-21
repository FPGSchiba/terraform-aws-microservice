package main

import (
	"context"
	"encoding/json"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-xray-sdk-go/xray"
	"log"
	"net/http"
	"os"
)

func init() {
	// Initialize the S3 client outside of the handler, during the init phase
	_, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("unable to load AWS-SDK config, %v", err)
	}

	err = xray.Configure(xray.Config{
		ServiceVersion: "1.2.3",
	})
	if err != nil {
		log.Fatalf("unable to load X-Ray-SDK config, %v", err)
	}
}

func response(status int, body interface{}) (*events.APIGatewayProxyResponse, error) {
	resp := events.APIGatewayProxyResponse{Headers: map[string]string{"Content-Type": "application/json",
		"Access-Control-Allow-Origin":      "*",
		"Access-Control-Allow-Headers":     "Content-Type",
		"Access-Control-Allow-Methods":     "OPTIONS, POST, GET, PUT, DELETE",
		"Access-Control-Allow-Credentials": "true"}}
	resp.StatusCode = status

	// Convert body to json data
	sBody, _ := json.Marshal(body)
	resp.Body = string(sBody)

	return &resp, nil
}

func handleRequest(ctx context.Context, event events.APIGatewayProxyRequest) (*events.APIGatewayProxyResponse, error) {
	// Parse the input event
	return response(http.StatusOK,
		map[string]interface{}{
			"Region": os.Getenv("AWS_REGION"),
		})
}

func main() {
	lambda.Start(handleRequest)
}
