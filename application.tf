module "aio" {  
    source                 = "terraform-aws-modules/ec2-instance/aws"  
    version                = "~> 2.0"  
    name                   = "MGL-AIO" #changeme  
    instance_count         = 1  
    ami                    = data.aws_ami.latest_server2016.id  
    instance_type          = "c5.xlarge"  
    key_name               = "gonzalez-oregon" #changeme  
    monitoring             = false
    vpc_security_group_ids = ["sg-021e7c04b776838bd"]  
    #vpc_security_group_ids = [aws_security_group.checkmarx-manager-sg.id, aws_security_group.remote_management.id ]  
    subnet_id              = "subnet-003fee140a33ba0be"  
    user_data = data.template_file.manager_provisioner.rendered  
    associate_public_ip_address = true  
    ebs_optimized = true 

    root_block_device = [    
        {      
            volume_type = "gp2"      
            volume_size = 150    
        }  
        ]  
        
        tags = {    
            Terraform   = "true"    
            Environment = "Deveopment"    
            Owner = "miguel.gonzalez@checkmarx.com" #changeme  
            }
        }

data "template_file" "manager_provisioner" {  
    template = <<EOF
    <powershell>>
    ###################################################################################################
    # Terraform bootstrap - enable TLS 1.2, WinRM, Install Chocolatey + Tools, and Set Admin Password
    ###################################################################################################
    # Enforce TLS 1.2 and execution policy
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;  
    
    # Enable WinRM for Terraform file provisioner
    iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'))
    
    # Set the admin password for win rm# Install Chocolatey and some basic tools
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    cinst notepadplusplus git googlechrome sql-server-management-studio -y   
    </powershell>
    EOF
    }