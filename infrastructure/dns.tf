data "aws_acm_certificate" "sudoku_fetcher2" {
  domain = "${var.domain_name}"
  types = ["AMAZON_ISSUED"]
  statuses = ["ISSUED"]
  most_recent = true
}

resource "aws_api_gateway_domain_name" "sudoku_fetcher2" {
  domain_name = "${var.domain_name}"
  regional_certificate_arn = "${data.aws_acm_certificate.sudoku_fetcher2.arn}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "test" {
  api_id = "${aws_api_gateway_rest_api.sudoku_fetcher2.id}"
  domain_name = "${var.domain_name}"
  stage_name = "production"
}

resource "aws_route53_record" "sudoku_fetcher2" {
  name = "${aws_api_gateway_domain_name.sudoku_fetcher2.domain_name}"
  type = "A"
  zone_id = "${var.zone_id}"

  alias {
    evaluate_target_health = true
    name = "${aws_api_gateway_domain_name.sudoku_fetcher2.regional_domain_name}"
    zone_id = "${aws_api_gateway_domain_name.sudoku_fetcher2.regional_zone_id}"
  }
}

output "aliased_api_url" {
  value = "https://${var.domain_name}"
}
