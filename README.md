# Backend Deployment Process

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


# Frontend Deployment Process

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




## The deployment process described has several advantages for organizations using AWS and Terraform. Here are the main benefits:

### **1. Faster Deployment and Consistency**
- **Automated Provisioning**: The entire deployment process is automated using Terraform, reducing the need for manual configuration and human intervention.
- **Reusable Configurations**: Using a common deployment process and Terraform modules ensures that the same configurations can be applied across different environments (e.g., development, staging, production), guaranteeing consistency.

### **2. Reliability and Stability**
- **AMI Creation for Standardized Environments**: By stopping the instance and creating an Amazon Machine Image (AMI), the deployment process captures a stable and consistent environment. Future instances launched using this AMI will have the exact same configurations, minimizing the chances of discrepancies.
- **Health Checks and Load Balancing**: Configuring health checks for EC2 instances in the target group ensures that only healthy instances receive traffic, improving reliability and minimizing downtime.

### **3. Cost Efficiency**
- **Auto Scaling Based on Demand**: The Auto Scaling Group (ASG) adjusts the number of instances based on utilization metrics such as CPU usage, ensuring that resources are only provisioned when needed, thereby optimizing costs.
- **Idle Resource Management**: The process includes stopping the EC2 instance after creating the AMI, which helps manage costs by preventing unnecessary charges from running instances that are not in use.

### **4. Flexibility and Scalability**
- **Scalable Architecture**: By using ASGs and the ALB, the architecture can scale up or down seamlessly based on demand, ensuring optimal performance during peak times and cost savings during low-traffic periods.
- **Customizable Routing with Listener Rules**: ALB listener rules allow for complex routing configurations, making it easy to route requests based on specific host headers or paths. This is especially useful for scenarios like blue/green deployments, canary releases, or separating traffic for different applications.

### **5. Simplified Management and Maintenance**
- **Separation of Concerns**: Each component (EC2 instances, ALB, ASG, AMI) has a dedicated role and can be managed or updated independently, simplifying maintenance.
- **State Management and Change Tracking**: With Terraform’s state file management and version control, tracking changes and managing deployments becomes more straightforward.

### **6. Enhanced Security and Compliance**
- **Automated Security Group Configurations**: The deployment process ensures that the right security groups are associated with the EC2 instances, ALB, and other resources, reducing the risk of exposure to security threats.
- **Immutable Infrastructure**: By using AMIs, the infrastructure becomes more secure and less prone to configuration drifts since new instances are launched from a pre-built, immutable image.

### **7. Reduced Time-to-Market**
- **Pre-Built AMIs**: Launching instances from a pre-configured AMI significantly reduces the time needed to provision and configure servers. This is particularly beneficial when deploying updates or new environments rapidly.
- **Quick Rollback and Recovery**: In the event of an issue, teams can easily roll back to a previous state by using a previously created AMI or Terraform configuration.

### **8. Integration with CI/CD Pipelines**
- **Automated Deployments**: This process can be integrated with Continuous Integration and Continuous Deployment (CI/CD) pipelines, enabling automated testing and deployments based on the defined Terraform configurations.
- **Infrastructure as Code (IaC)**: Treating infrastructure as code allows for easy integration with tools like Jenkins, GitHub Actions, or GitLab CI, ensuring that infrastructure changes follow the same review and approval processes as application code.

Overall, this deployment process leverages the power of Terraform and AWS services to create a highly efficient, scalable, and manageable cloud infrastructure that supports both development and production environments.



for dir in 01-vpc 02-sg 03-vpn-bastion 04-db 05-app-alb 06-backend 07-acm 08-web-alb 09-frontend; do echo "Applying in $dir..."; (cd $dir && make apply ); done

