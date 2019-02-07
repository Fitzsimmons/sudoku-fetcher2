provider "aws" {
	profile = "${var.aws_profile}"
	region = "${var.aws_region}"
}

resource "aws_cloudwatch_log_group" "sudoku_fetcher2" {
  name = "/aws/lambda/${aws_lambda_function.sudoku_fetcher2.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "sudoku_fetcher2" {
  filename = "../build/sudoku_fetcher2.zip"
  function_name = "sudoku_fetcher2"
  role = "${aws_iam_role.iam_for_lambda.arn}"
  handler = "sudoku_fetcher2.sudoku_fetcher2"
  source_code_hash = "${base64sha256(file("../build/sudoku_fetcher2.zip"))}"
  runtime = "ruby2.5"
  timeout = "30"
}
