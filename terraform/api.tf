resource "aws_apigatewayv2_api" "api" {
  name          = "${var.app_id}-${var.app_env}-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "integration" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  payload_format_version = "2.0"
  integration_uri        = aws_lambda_function.test_lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "route1" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.integration.id}"
}
resource "aws_apigatewayv2_route" "route2" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "PUT /items"
  target    = "integrations/${aws_apigatewayv2_integration.integration.id}"
}
resource "aws_apigatewayv2_route" "route3" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.integration.id}"
}
resource "aws_apigatewayv2_route" "route4" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "DELETE /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.integration.id}"
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFROMAPIGATEWAY"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}