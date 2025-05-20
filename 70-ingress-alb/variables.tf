variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true"
    }
}


variable "zone_id" {
    default = "Z04263705DOX3TZF5K54"
}

variable "domain_name" {
    default = "santhoshdatti.online"
}