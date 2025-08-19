# Get the current user's ARN
$userArn = (aws iam get-user | ConvertFrom-Json).User.Arn

# Create the trust policy
$trustPolicy = @"
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "$userArn"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
"@

aws iam create-role `
  --role-name TerraformExecutionRoleDB `
  --assume-role-policy-document "$trustPolicy"

# Define policies as a hashtable
$policies = @{
  "TerraformVpcReadPolicy" = @'
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "VpcRead",
    "Effect": "Allow",
    "Action": [
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSecurityGroups"
    ],
    "Resource": "*"
  }]
}
'@

  "TerraformVpcEndpointPolicy" = @'
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "VpcEndpointManage",
    "Effect": "Allow",
    "Action": [
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:CreateVpcEndpoint",
      "ec2:DeleteVpcEndpoints",
      "ec2:DescribeVpcEndpoints"
    ],
    "Resource": "*"
  }]
}
'@

  "TerraformEcrPolicy" = @'
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "EcrManage",
    "Effect": "Allow",
    "Action": [
      "ecr:CreateRepository",
      "ecr:DeleteRepository",
      "ecr:DescribeRepositories",
      "ecr:GetAuthorizationToken",
      "ecr:ListImages"
    ],
    "Resource": "*"
  }]
}
'@

  "TerraformEcsPolicy" = @'
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "EcsManage",
    "Effect": "Allow",
    "Action": [
      "ecs:CreateCluster",
      "ecs:DeleteCluster",
      "ecs:DescribeClusters",
      "ecs:RegisterTaskDefinition",
      "ecs:CreateService",
      "ecs:DeleteService",
      "ecs:DescribeServices",
      "ecs:UpdateService"
    ],
    "Resource": "*"
  }]
}
'@

  "TerraformPipelinePolicy" = @'
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "PipelineManage",
    "Effect": "Allow",
    "Action": [
      "codepipeline:CreatePipeline",
      "codepipeline:DeletePipeline",
      "codepipeline:GetPipeline",
      "codepipeline:UpdatePipeline",
      "codepipeline:StartPipelineExecution",
      "codebuild:CreateProject",
      "codebuild:DeleteProject",
      "codebuild:BatchGetProjects",
      "codebuild:StartBuild"
    ],
    "Resource": "*"
  }]
}
'@

  "TerraformIamPolicy" = @'
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "IamManage",
    "Effect": "Allow",
    "Action": [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PassRole",
      "iam:GetRole"
    ],
    "Resource": "*"
  }]
}
'@
}

# Create and attach each policy to the role
foreach ($policyName in $policies.Keys) {
  Write-Host "Creating policy: $policyName"
  $policyDoc = $policies[$policyName]
  $policyArn = aws iam create-policy `
    --policy-name $policyName `
    --policy-document $policyDoc `
    | ConvertFrom-Json | Select-Object -ExpandProperty Policy | Select-Object -ExpandProperty Arn

  Write-Host "Attaching $policyName to role TerraformExecutionRoleDB"
  aws iam attach-role-policy `
    --role-name TerraformExecutionRoleDB `
    --policy-arn $policyArn
}

Write-Host "All done: role and policies created and attached successfully."
