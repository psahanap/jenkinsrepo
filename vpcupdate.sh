#!/bin/bash
#source ~/.bash_profile
/usr/local/bin/aws cloudformation describe-stacks --stack-name test-vpc-creation --region us-east-2
status=`echo $?`
echo $status
if [ $status -eq 0 ]
	then
		/usr/local/bin/aws cloudformation update-stack --stack-name test-vpc-creation --template-body file:///opt/jenkins/subbranch/test/vpc\ template.json.txt --parameters file:///opt/jenkins/subbranch/test/parameters.json --region us-east-2 --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM"
				while true
					do
					/usr/local/bin/aws cloudformation describe-stack-events --stack-name test-vpc-creation --region us-east-2 |  grep -iE 'ResourceStatus|ResourceType' |sed 's|[",:]||g' | grep -E 'ResourceStatus.*UPDATE_COMPLETE' > update
					cat update
					nooflines=`cat update | wc -l`
					echo "The Loop will continue until stack is completed/updated."
					if [ "$nooflines" -ne 1 ];
					then
					echo "Stack Creation is in Progress,Below are the events happening now"
					/usr/local/bin/aws cloudformation describe-stack-events --stack-name test-vpc-creation --region us-east-2 | grep -iE 'ResourceStatus|ResourceType|LogicalResourceId|PhysicalResourceId'
					sleep 3s
					else
					if [ "$nooflines" -eq 1 ];
					then
					echo "Stack Creation Completed"
					break
					fi
					fi
					done
					while true
					do
					/usr/local/bin/aws cloudformation describe-stack-resources --stack-name test-vpc-creation --region us-east-2 | grep -iE 'ResourceStatus|ResourceType' |sed 's|[",:]||g' |grep -E 'ResourceStatus.*_COMPLETE|ResourceType.*'
					rsatus=`echo $?`
					echo $rstatus
					if [ $rstatus -ne 0 ];
					then
					echo "Resources are Created Successfully, below are the details"
					/usr/local/bin/aws cloudformation describe-stack-resources --stack-name test-vpc-creation --region us-east-2 | grep -iE 'ResourceStatus|ResourceType|LogicalResourceId'
					else
					break
					fi
					done
else
					/usr/local/bin/aws cloudformation create-stack --stack-name test-vpc-creation --template-body file:///opt/jenkins/subbranch/test/vpc\ template.json.txt --parameters file:///opt/jenkins/subbranch/test/parameters.json --region us-east-2 --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM"
			while true
					do
					/usr/local/bin/aws cloudformation describe-stack-events --stack-name test-vpc-creation --region us-east-2 |  grep -iE 'ResourceStatus|ResourceType' |sed 's|[",:]||g' | grep -E 'ResourceType.*AWSCloudFormationStack' > lines
					cat lines
					nooflines=`cat lines | wc -l`
					echo "The Loop will continue until stack is completed/updated."
						if [ "$nooflines" -ne 2 ];
					then
						echo "Stack Creation is in Progress,Below are the events happening now"
						/usr/local/bin/aws cloudformation describe-stack-events --stack-name test-vpc-creation --region us-east-2 | grep -iE 'ResourceStatus|ResourceType|LogicalResourceId|PhysicalResourceId'
						sleep 3s
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
					/usr/local/bin/aws cloudformation describe-stack-resources --stack-name test-vpc-creation --region us-east-2 | grep -iE 'ResourceStatus|ResourceType' |sed 's|[",:]||g' |grep -E 'ResourceStatus.*_COMPLETE|ResourceType.*'
					rsatus=`echo $?`
					echo $rstatus
						if [ $rstatus -ne 0 ];
					then
						echo "Resources are Created Successfully, below are the details"
						/usr/local/bin/aws cloudformation describe-stack-resources --stack-name test-vpc-creation --region us-east-2 | grep -iE 'ResourceStatus|ResourceType|LogicalResourceId'
					else
						break
						fi
						done
						fi