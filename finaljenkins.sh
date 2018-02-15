#!/bin/bash
#Script for automatically running the AWS deployments from Jenkins using CFTs , Jekins and Git
#The source code and script is stored in Git repo and run from Jenkins
#source ~/.bash_profile
/usr/local/bin/aws cloudformation describe-stacks --stack-name test--SG-creation --region ap-south-1
status=`echo $?`
echo exit status is $status
if [ $status -eq 0 ]
then
echo "Updating the Stack Now"
/usr/local/bin/aws cloudformation update-stack --stack-name test--SG-creation --template-body file:///opt/jenkins/subbranch/test/sg\ template.json.txt --parameters file:///opt/jenkins/subbranch/test/parameters.json --region ap-south-1
else
echo "Creating the Stack Now"
/usr/local/bin/aws cloudformation create-stack --stack-name test--SG-creation --template-body file:///opt/jenkins/subbranch/test/sg\ template.json.txt --parameters file:///opt/jenkins/subbranch/test/parameters.json --region ap-south-1
fi
while true
do
/usr/local/bin/aws cloudformation describe-stack-events --stack-name test--SG-creation --region ap-south-1 |  grep -iE 'ResourceStatus|ResourceType' |sed 's|[",:]||g' | grep -E 'ResourceType.*AWSCloudFormationStack' > lines
cat lines
nooflines=`cat lines | wc -l`
echo "if number output lines are 2 ,then break;otherwise print until its 2."
if [ "$nooflines" -ne 2 ];
then
echo "Stack Creation is in Progress,Below are the events happening now"
/usr/local/bin/aws cloudformation describe-stack-events --stack-name test--SG-creation --region ap-south-1 | grep -iE 'ResourceStatus|ResourceType|LogicalResourceId|PhysicalResourceId'
else
if [ "$nooflines" -eq 2 ];
then
echo "Stack Creation Completed"
break
fi
fi
done
while true
do
/usr/local/bin/aws cloudformation describe-stack-resources --stack-name test--SG-creation --region ap-south-1 | grep -iE 'ResourceStatus|ResourceType' |sed 's|[",:]||g' |grep -E 'ResourceStatus.*_COMPLETE|ResourceType.*'
rsatus=`echo $?`
echo $rstatus
if [ $rstatus -ne 0 ];
then
echo "Resources are Created Successfully, below are the details"
/usr/local/bin/aws cloudformation describe-stack-resources --stack-name test--SG-creation --region ap-south-1 | grep -iE 'ResourceStatus|ResourceType|LogicalResourceId'
else
break
fi
done
