cluster_name				= "cms-webservices-dev"
cluster_tags = {
	"ApplicationName"		= "InsuranceApps"
	"Automated"				= "True"
	"BackupPlan"			= "None"
	"CostCenter"			= "FMG"
	"CreatedBy"				= "DevOps"
	"CreatedOn"				= "11052024"
	"DataClassification"	= "Low"
	"Department"			= "IAPPS"
	"Infrastructure"		= "False"
	"LastUpdated"			= "11052024"
	"TechStack"				= "AWS"
	"Usage"					= "Project"
	"Version"				= "1.0"
	"Monitor"				= "TRUE"
}

iam_role_name				= "cms-ecs-task-execution-role-dev"

iam_role_tags = {
	"ApplicationName"		= "InsuranceApps"
	"Automated"				= "True"
	"BackupPlan"			= "None"
	"CostCenter"			= "FMG"
	"CreatedBy"				= "DevOps"
	"CreatedOn"				= "11052024"
	"DataClassification"	= "Low"
	"Department"			= "IAPPS"
	"Infrastructure"		= "False"
	"LastUpdated"			= "11052024"
	"TechStack"				= "AWS"
	"Usage"					= "Project"
	"Version"				= "1.0"
}

cloudwatch_log_group_name	= "/ecs/cms-webservices-dev"
cloudwatch_log_group_retention = 30
cloudwatch_log_group_tags = {
	"ApplicationName"		= "InsuranceApps"
	"Automated"				= "True"
	"BackupPlan"			= "None"
	"CostCenter"			= "FMG"
	"CreatedBy"				= "DevOps"
	"CreatedOn"				= "11052024"
	"DataClassification"	= "Low"
	"Department"			= "IAPPS"
	"Infrastructure"		= "False"
	"LastUpdated"			= "11052024"
	"TechStack"				= "AWS"
	"Usage"					= "Project"
	"Version"				= "1.0"
}

task_definition_family		= "cms-webservices-task-dev"
container_definition_name	= "cms-webservices-container"
container_definition_image	= "116762271881.dkr.ecr.us-east-1.amazonaws.com/fmg-insuranceapps:cms-webservices-dev"
cd_portmapping_containerport = 8080
cd_portmapping_hostport = 8080
cd_portmapping_protocol = "tcp"
cd_env_vars = [
	{
		"name"	=	"JWT_TOKEN_EXPIRY_MINS",
		"value"	=	"30"
	},
	{
		"name"	=	"LOG_LEVEL",
		"value"	=	"DEBUG"
	}
]
task_definition_cpu			= "1024"
task_definition_memory		= "2048"

td_tags = {
	"ApplicationName"		= "InsuranceApps"
	"Automated"				= "True"
	"BackupPlan"			= "None"
	"CostCenter"			= "FMG"
	"CreatedBy"				= "DevOps"
	"CreatedOn"				= "11052024"
	"DataClassification"	= "Low"
	"Department"			= "IAPPS"
	"Infrastructure"		= "False"
	"LastUpdated"			= "11052024"
	"TechStack"				= "AWS"
	"Usage"					= "Project"
	"Version"				= "1.0"
}

service_name				= "cms-service-dev"
service_subnets				= ["subnet-0734d8f28467d319f", "subnet-06291ceaa523f684c"]
service_sg					= ["sg-0dfba98fd195639f7"]
service_tg_arn				= "arn:aws:elasticloadbalancing:us-east-1:116762271881:targetgroup/fmg-cmsservice-tg-dev/ba6d6714da12b66d"
