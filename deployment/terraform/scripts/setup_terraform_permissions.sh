#!/bin/bash

userArn=$(aws sts get-caller-identity --query "Arn" --output text)

cat > trust-policy.json <<EOF
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
EOF

aws iam create-role \
  --role-name TerraformExecutionRoleDB \
  --assume-role-policy-document file://trust-policy.json

declare -A policies

policies["TerraformVpcReadPolicy"]='{
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
}'

policies["TerraformVpcEndpointPolicy"]='{
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
}'

policies["TerraformEcrPolicy"]='{
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
}'

policies["TerraformEcsPolicy"]='{
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
}'

policies["TerraformPipelinePolicy"]='{
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
}'

policies["TerraformIamPolicy"]='{
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
}'

for policyName in "${!policies[@]}"; do
  echo "Creating policy: $policyName"
  echo "${policies[$policyName]}" > "$policyName.json"
  policyArn=$(aws iam create-policy \
    --policy-name "$policyName" \
    --policy-document file://"$policyName.json" \
    --query 'Policy.Arn' --output text)

  echo "Attaching $policyName to role TerraformExecutionRoleDB"
  aws iam attach-role-policy \
    --role-name TerraformExecutionRoleDB \
    --policy-arn "$policyArn"
done

echo "All done: role and policies created and attached successfully."
rm trust-policy.json
rm *.json