######################
        #aws
######################        
provider "aws" {
  region = "ap-south-1" 
  
}
resource "aws_s3_bucket" "my_bucket" {
  bucket = "ashar-tf-lab-bucket-20-nov-2025"
  force_destroy = true
}
