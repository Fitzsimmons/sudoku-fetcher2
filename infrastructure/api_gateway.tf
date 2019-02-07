data "aws_caller_identity" "current" {}

resource "aws_api_gateway_rest_api" "sudoku_fetcher2" {
  name = "${terraform.workspace}_sudoku_fetcher2"
  description = "sudoku fetcher 2"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

output "base_api_url" {
  value = "https://${aws_api_gateway_rest_api.sudoku_fetcher2.id}.execute-api.us-east-2.amazonaws.com/"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id = "${aws_api_gateway_rest_api.sudoku_fetcher2.id}"
  resource_id = "${aws_api_gateway_rest_api.sudoku_fetcher2.root_resource_id}"
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = "${aws_api_gateway_rest_api.sudoku_fetcher2.id}"
  resource_id = "${aws_api_gateway_rest_api.sudoku_fetcher2.root_resource_id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.sudoku_fetcher2.arn}/invocations"
}

resource "aws_api_gateway_deployment" "production" {
  depends_on = ["aws_api_gateway_integration.integration"]

  rest_api_id = "${aws_api_gateway_rest_api.sudoku_fetcher2.id}"
  stage_name = "production"

  variables {
    deployed_at = "${timestamp()}"
  }

  # Comment this out to force a deployment
  # Is there a better way to do this?
  lifecycle {
    ignore_changes = ["variables"]
  }
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sudoku_fetcher2.arn}"
  principal = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.sudoku_fetcher2.id}/*/${aws_api_gateway_method.method.http_method}/"
}
