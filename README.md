# AWS-terraform-infrastructure-portfolio

The idea behind this repo is to learn how to use Terraform to provision AWS infrastructure for a public-facing web server. The project includes:
 - AWS EC2 RHEL for web hosting (Python/Flask backend)
 - Using Security Groups to act as a firewall and control Inbound/Outbound traffic (e.g HTTP(80) and SSH(22))
 - AWS S3 to host static assets (i.e media or html/css)

## Resources

Below are the resources used to get me started:
- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- https://flask.palletsprojects.com/en/stable/

## To Do

- Create a VPC & Subnet
    - Try to tighten the SSH to my personal IP only
- Create an Internet Gateway & Route Table
- Pair the Subnet to the Route Table
- Create a Network Interface within the IP range of the subnet
- Install Flask on the provisioned server and create a static webpage
