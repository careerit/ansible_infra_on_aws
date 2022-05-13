#!/bin/bash

if [[ -z $1  ]]
then
	read -p "Please enter action Build/Destroy" action
else	
	action=$1
fi 


if [[ $action == 'Build' || $action == 'build' ]]
then   
    bash infra.sh 

elif [[ $action == 'Destroy' || $action == 'destroy' ]]
then
    cd Terraform/
    terraform destroy --auto-approve

else
		echo -e "Incorrect Arguments \nUse One of the Following Actions:\n\tBuild\n\tDestroy"
		echo -e "Usage: ./setup.sh [Build|Destroy] "
		echo -e 'Examples:\n./setup.sh Build '
		echo -e './setup.sh Destroy '
		
fi 


