data "aws_vpc" "cx_na_lab" {  
        id = "vpc-01f164835a3b8889c"
        }

data "aws_ami" "latest_server2016" {    
    most_recent = true    
    owners = ["801119661308"] # Amazon    
    filter{        
            name   = "name"        
            values = ["Windows_Server-2016-English-Full-Base*"]    
            }    
    filter {        
            name   = "virtualization-type"        
            values = ["hvm"]    
            }
}