<p><strong>Tradition WordPress Website</strong></p>
<p>This project was designed to build a WordPress website that would be seen as a traditional on-premise architecture, but in the cloud.</p>
<p>Using Terraform to deploy the project into AWS, you can see the Architecture and all of its components below&hellip;</p>
<img width="1104" alt="Screenshot 2022-10-02 at 15 48 17" src="https://user-images.githubusercontent.com/88186800/193457987-11303200-7cb7-49c4-bec7-8bff8bb09011.png">
<p>Step 1 was to create our custom network to direct traffic to the website using the following tools...</p>
<ul>
    <li>AWS Route 53</li>
    <li>AWS CloudFront</li>
    <li>VPC</li>
    <li>AWS Internet Gateway</li>
</ul>
<p>Once that was up, we created &nbsp;2 availability zones to offset disaster happening to a region, and include 3 Subnets in each Availability Zone.&nbsp;</p>
<p>As you can see, we have added an Application Load Balancer to direct and manage incoming traffic from the Internet Gateway.&nbsp;</p>
<p>Since the Subnets are Public, we have added a Bastion Host with Autoscaling capabilities, which connects to the ALB, and two more WordPress Instances in our second group of Private Subnets that also have Autoscaling capabilities.</p>
<p>From here we can SSH into the Bastion Host and gain access to our WordPress Instance in the Private Subnets.</p>
<p>Now that we have our App stored inside the Private Instances, it&apos;s time to connect them to our VPC by creating a NAT Gateway.</p>
<p>To help with website load speed for the users, we need to add a Cache feature, and for that we have added ElastiCache in the third group of Private Subnets, connecting to the WordPress Instances.</p>
<p>The website will likely need a Database to store user data and such, so we created the Master Aurora &nbsp;database in the third group of Private Subnets in region A, and the Read Replica in region B for disaster management.</p>
<p>Nearly finished with the Architecture, we just need to include Amazon EFS and add an EFS Target Mount to both AZ in the third Private Subnet, which connects to the Wordpress Instances and an S3 Bucket to house any static assets that connects to CloudFront.</p>
<p>Finally, we need to create the Security Groups and configure the settings to protect against unwanted access and keep with our security protocol. You can see that in the &apos;security_group.tf&apos; file.</p>
