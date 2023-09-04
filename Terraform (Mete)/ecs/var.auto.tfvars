
aws_access_key      = "ASIA6EHHJ2TXPKLWSI66"
aws_secret_key      = "mMoJAiWvEvY0ikAq2+mo6b9ZwFhn96iL3+xJOG9t"
aws_session_token   = "IQoJb3JpZ2luX2VjEGkaDGV1LWNlbnRyYWwtMSJHMEUCIA62JbX/rNPyGgDtWXhvklwoeE7hvzvQ+78XLMmXSS5qAiEA2s/yhZXe0+qwGgN9ruB2hiwTr6yZ4NEgFvOkZT/M+4kqmgMIQhAAGgw5NzExNDc2OTUzNDIiDO6ShWdBvr7PgH1skCr3As2mFXcARwIKHzE5RtqGbxz9uDnwthwLUrOT+2WUS34KyFOoJzyRqTp7jn6WGnMG2xUJI1suCtZa+43komaLYHBzig44+VLnOZonuiL2bDPsaqLVJ+iUfotaJIqilCyOyfVDJsgcUCMoDqM9kIHA3BwfKiGxR6zCaqM5PfumGYADhG5CbsGF8dEa0f72pcylz+1A1EE4CcuaQcGyY+Xw4S5d9PJBjAFKi0JZt12hBUM/z8nYN+Uwi0SE9wVGG3z4UQJaCVk5TTbqxCf387qmjm/hDxmvIaX77LKQGRpU41uFem/mm1iE+Z32UngxhzxHnq9U9g3ilO4xcDqwVy7+/Yw9/5BfRyxTOet4ta9BwcT/NDHkUYSCBRbb+UNDOr96xk2+eAGcOJwXpcjgXJlyWrho0aTiLBDA5Cjs+L63Lq5g+ViYzHUzEdU4zPd8xyXmOgN3GXnuBBhiWYDcI/sTnXjeXtJAnXlYgr5A2BAXImNmwDHUmT/kzDCsvtanBjqmAfSWy6N/CyWOwUsCx+SEZ379knFWIZo8pSvrvTCCvCJk0IBRX2zwDpoqdmjwHoN3O3Eo9Zn+BX7cjbWbbrqdZPe+nl0uLcYsq2F/BpQ86SV/LoArkTLOSpg6eG1+xoA/4mZV7Y+c6Jop71sXZ8ZOm4vJkY5QTrO1StTx96jv5yKsKLX/ZgF7xZdjkvRZk+qs79R6O1BoW/cx76k5nTJttXZ470n8MeU="

# these are zones and subnets examples
#availability_zones = "eu-central-1a"
availability_zones = ["eu-central-1a", "eu-central-1b"]
subnet     = ["10.0.1.0/24", "10.0.2.0/24"]
# private_subnets    = ["10.10.0.0/24", "10.10.1.0/24"]

# these are used for tags
app_name        = "Demo-NGINX-app"
app_environment = "test-env"