variable "PHP_EXTENSIONS" {
  default = ""
}

variable "PHP_EXTENSION_LIBS" {
  default = ""
}

variable "XCADDY_ARGS" {
  default = ""
}

variable "EMBED" {
  default = ""
}

target "default" {
  platforms = ["linux/amd64"]
}

target "static-builder" {
  inherits = ["default"]
  dockerfile = "static-build.Dockerfile"
  tags = ["static-app:latest"]
  args = {
    PHP_EXTENSIONS = PHP_EXTENSIONS
    PHP_EXTENSION_LIBS = PHP_EXTENSION_LIBS
    XCADDY_ARGS = XCADDY_ARGS
    EMBED = EMBED
  }
}