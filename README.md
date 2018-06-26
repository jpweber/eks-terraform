# Terraform EKS cluster

This project is  a fork from the hashicorp example found here https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/eks-getting-started. Modified to build out more than an example cluster. This will create the following

* VPC
* Private Subnets
* Public Subnets
* Internet Gateway
* NAT Gateway
* Route tables
* Route table associations
* EKS Cluster
* EKS Worker node scaling group
* Bastion Host
* EKS Control plane security groups
* Worker node security groups
* All required IAM policies



All variables in the `variables.tf` file can be overridden. An example vars file has been provided to work from. 

Please reference the AWS documentation (https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html) If you have not created an eks cluster before. Import points that this terraform project doesn't cover; installing heptio authenticator, or apply the config map for nodes to be able to authenticate with the cluster. 



The output from `terraform apply` will provide you with a config map for AWS auth and a kubeconfig with all the required values populated. 

```

Outputs:

config-map-aws-auth =

apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::000000000000000:role/terraform-eks-demo-node
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes

kubeconfig =

apiVersion: v1
clusters:
- cluster:
    server: https://94EF5DCC7DD400000000000000000.yl4.us-west-2.eks.amazonaws.com
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJ<snipped>HQjdub0FvMWNjSmRNajEzZTJlOXVZSzk4NkJhMmxJZDZqaz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: heptio-authenticator-aws
      args:
        - "token"
        - "-i"
        - "terraform-eks-demo"
```

