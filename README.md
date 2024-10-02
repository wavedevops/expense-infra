# Common Deployment Process

1. **Create EC2 Instance**  
   A new EC2 instance is launched using a specified AMI, security group, and instance type. This instance serves as a server for the required application.

2. **Provision Files and Execute Script**  
   After the EC2 instance is created, a shell script is uploaded to the server using the `null_resource` provisioner. The script is executed remotely via SSH to set up and configure the application. This step ensures that the instance has the necessary software, configurations, and files required for the application.

3. **Stop EC2 Instance**  
   Once the provisioning and configuration are completed, the EC2 instance is stopped to prepare it for creating an AMI. This step ensures that no changes occur on the instance while creating the AMI, making it a stable base image for launching future instances.

4. **Create AMI from Instance**  
   An Amazon Machine Image (AMI) is created from the stopped EC2 instance. This AMI can be used as a golden image to launch new instances with the pre-configured environment, which reduces the time needed for configuration in subsequent deployments.

5. **Create Application Load Balancer**  
   An Application Load Balancer (ALB) is set up to distribute incoming traffic to the EC2 instances. It is associated with the appropriate subnets and security groups.

6. **Create Load Balancer Target Group**  
   A target group is created to register the EC2 instances. The target group health checks ensure that only healthy instances receive traffic.

7. **Create Load Balancer Listener**  
   A listener is set up on the ALB to listen on a specified port (e.g., 80) and forward incoming requests to the registered target group.

8. **Set Up Auto Scaling Group for EC2 Instances**  
   An Auto Scaling Group (ASG) is created to manage the number of EC2 instances based on demand. The ASG uses a launch template referencing the AMI created in the previous step.

9. **Configure Auto Scaling Policy**  
   A target tracking scaling policy is configured to adjust the number of instances based on CPU utilization. If the average CPU utilization exceeds the target threshold, more instances will be launched.

10. **Create Load Balancer Listener Rules for Routing**  
    Listener rules are added to the ALB to route incoming requests to the instances based on specific host header conditions (e.g., `environment.example.com`).

## Backend Deployment Process

1. Create EC2 Instance
2. Provision Files and Execute Script
3. Stop EC2 Instance
4. Create AMI from Instance
5. Terminate EC2 Instance
6. Create Load Balancer Target Group
7. Create Launch Template
8. Create Auto Scaling Group
9. Create Auto Scaling Policy
10. Create Load Balancer Listener Rule


## Frontend Deployment Process

1. Create EC2 Instance for Frontend
2. Provision and Execute Frontend Deployment Script
3. Stop the EC2 Instance
4. Create an AMI from the Frontend EC2 Instance
5. Terminate the EC2 Instance
6. Create a Load Balancer Target Group for Frontend
7. Create Launch Template for Frontend Instances
8. Create Auto Scaling Group for Frontend
9. Configure Auto Scaling Policy for Frontend Scaling
10. Create Load Balancer Listener Rule for Frontend Routing
