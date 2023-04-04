variable "app_id" {
  description = "nombre del recurso"
  type        = string
  default     = "http-crud-lambda"
}

variable "app_env" {
  description = "environment del recurso"
  type        = string
  default     = "dev"

}

variable "package" {
  description = "zip de la aplicacion"
  type        = string
  default     = "../function.zip"
}