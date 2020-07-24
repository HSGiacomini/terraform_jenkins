
terraform {
    backend "s3" {
        bucket = "__BUCKETNAME__"
        key    = "modulos/apphelloworld.tfstate"
        region = "regiao_aws"
    }
}