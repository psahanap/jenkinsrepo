#!/bin/bash
#source ~/.bash_profile
/usr/local/bin/aws cloudformation describe-stacks --stack-name test-sg-creation --region ap-south-1
status=`echo $?`
echo $status
if [ $status -eq 0 ]
	then
		/usr/local/bin/aws cloudformation update-stack --stack-name test-sg-creation --template-body file:///opt/jenkins/subbranch/test/sg\ template.json.txt --parameters file:///opt/jenkins/subbranch/test/parameters.json --region ap-south-1 --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM"
				while true
					do
					/usr/local/bin/aws cloudformation describe-stack-events --stack-name test-sg-creation --region ap-south-1 |  grep -iE 'ResourceStatus|ResourceType' |sed 's|[",:]||g' | grep -E 'ResourceStatus.*UPDATE_COMPLETE*' > update
					/usr/local/bin/aws cloudformation describe-stack-events --stack-name test-sg-creation --region ap-south-1 |  grep -iE 'ResourceStatus|ResourceType' |sed 's|[",:]||g' | grep -E 'ResourceStatus.*UPDATE_IN_PROGRESS' > updatestart
					cat updatestart
					noupdate=`cat updatestart | wc -l`
					cat update
					nooflines=`cat update | wc -l`
					echo "The Loop will continue until stack is completed/updated."
					if [ "$nooflines" -gt 0 ] && [ "$nooflines" -lt 2 ];
					then
					echo "Stack Creation is in Progress,Below are the events happening now"
					/usr/local/bin/aws cloudformation describe-stack-events --stack-name test-sg-creation --region ap-south-1 | grep -iE 'ResourceStatus|ResourceType|LogicalResourceId|PhysicalResourceId'
					sleep 3s
					else
					if [ "$nooflines" -ge 2 ] ;
					then
					echo "Stack Creation Completed"
					break
					else
					if [ "$noupdate" -eq 0 ] ;
					then
					echo "(ValidationError) when calling the UpdateStack operation: No updates are to be performed."
					break
					fi
					fi
					fi
					done
					while true
					do
					/usr/local/bin/aws cloudformation describe-stack-resources --stack-name test-sg-creation --region ap-south-1 | grep -iE 'ResourceStatus|ResourceType' |sed 's|[",:]||g' |grep -E 'ResourceStatus.*_COMPLETE|ResourceType.*'
					rsatus=`echo $?`
					echo $rstatus
					if [ $rstatus -ne 0 ];
					then
					echo "Resources are Created Successfully, below are the details"
					/usr/local/bin/aws cloudformation describe-stack-resources --stack-name test-sg-creation --region ap-south-1 | grep -iE 'ResourceStatus|ResourceType|LogicalResourceId'
					else
					break
					fi
					done
else
					/usr/local/bin/aws cloudformation create-stack --stack-name test-sg-creation --template-body file:///opt/jenkins/subbranch/test/sg\ template.json.txt --parameters file:///opt/jenkins/subbranch/test/parameters.json --region ap-south-1 --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM"
			while true
					do
					/usr/local/bin/aws cloudformation describe-stack-events --stack-name test-sg-creation --region ap-south-1 |  grep -iE 'ResourceStatus|ResourceType' |sed 's|[",:]||g' | grep -E 'ResourceType.*AWSCloudFormationStack' > lines
					cat lines
					nooflines=`cat lines | wc -l`
					echo "The Loop will continue until stack is completed/updated."
						if [ "$nooflines" -gt 0 ] && [ "$nooflines" -lt 2 ]
					then
						echo "Stack Creation is in Progress,Below are the events happening now"
						/usr/local/bin/aws cloudformation describe-stack-events --stack-name test-sg-creation --region ap-south-1 | grep -iE 'ResourceStatus|ResourceType|LogicalResourceId|PhysicalResourceId'
						sleep 3s
					else
						if [ "$nooflines" -ge 2 ];
					then
						echo "Stack Creation Completed"
						break
						fi
						fi
			done
			while true
					do
					/usr/local/bin/aws cloudformation describe-stack-resources --stack-name test-sg-creation --region ap-south-1 | grep -iE 'ResourceStatus|ResourceType' |sed 's|[",:]||g' |grep -E 'ResourceStatus.*_COMPLETE|ResourceType.*'
					rsatus=`echo $?`
					echo $rstatus
						if [ $rstatus -ne 0 ];
					then
						echo "Resources are Created Successfully, below are the details"
						/usr/local/bin/aws cloudformation describe-stack-resources --stack-name test-sg-creation --region ap-south-1 | grep -iE 'ResourceStatus|ResourceType|LogicalResourceId'
					else
						break
						fi
						done
						fi