#!/bin/bash
#source ~/.bash_profile
/usr/local/bin/aws cloudformation describe-stacks --stack-name test-SG-creation --region ap-south-1
status=`echo $?`
echo $status
if [ $status -eq 0 ]
then
/usr/local/bin/aws cloudformation update-stack --stack-name test-SG-creation --template-body file:///opt/jenkins/subbranch/test/sg\ template.json.txt --parameters file:///opt/jenkins/subbranch/test/parameters.json --region ap-south-1
else
/usr/local/bin/aws cloudformation create-stack --stack-name test-SG-creation --template-body file:///opt/jenkins/subbranch/test/sg\ template.json.txt --parameters file:///opt/jenkins/subbranch/test/parameters.json --region ap-south-1
fi
/usr/local/bin/aws cloudformation describe-stack-events --stack-name test-SG-creation --region ap-south-1 | grep -iE 'ResourceStatus|ResourceType|LogicalResourceId'

