aws_user_id       = "[971147695342_Student]"
aws_region        = "eu-central-1"
aws_access_key    = "ASIA6EHHJ2TXICCWJTVJ"
aws_secret_key    = "WoLAx1ClIPSmUrotouZTvFo76DiiKofvy5iadql+"
aws_session_token = "IQoJb3JpZ2luX2VjELz//////////wEaDGV1LWNlbnRyYWwtMSJHMEUCIQDZX3ZvUYifjsOHLmvbaEUyftHGKv9BrOzgeI9H717BSwIgJBgNS+A1cXkJnmj1CO/n5+lp9nFqqWSNKLhuZVbs0rIqowMIpf//////////ARAAGgw5NzExNDc2OTUzNDIiDPT4gMhAQ576odIQJir3Av6QctlVR0H/DMWnHCgcGmQy6Vuq8OAnlyOYLebY9FoEjWN0YpSedJnJ6Q6JDg3ArmoN0ZlqpEf1Y3UAGJsKfewjUN7jvE0DWk7JTkEmWWyOAC9gf9VRnytsqbwQfjcMOOoL6yXy4A9GgpQH/nT8EX3vr90azEfRPat8pXDxeYiy2/TixwHbJnFbPDZ7FzuFfuR3mkwCSgOSyvDUFga8bVHfVvq1kKSI317OxMgE4hyZkRB7X7A24ZLEselUHL+MaCGIQuJN8grdXpRRz2IJgi9PvFSGoR0U7Dz8q0+chQPkUkBzp3htDsWN6AWmukmLacXW5gBkSqTca9Hc+FjjF8kEicnMACZTDK+lzuZlgFaLYpDuTaBdQTYmDme39t+o4mcp/4aMvWA9t7kM6zu1I4E/F4CQBfqY6L7O2pP+RHitPRC815/rzNuwHusw/EyrXd46Nwwd6ROgBkSXos7WiPheDZb/VyL9K07Kim8/wvkl9xfFlOutvDD37KCoBjqmAejhVOXsPrH14oy+7ajC67eP7V71xxWZEbyvlI6mpz5uptRd9YAp8I1aPn0cyFcpGB5F3zoyPEvX5aRqLIHnJieB7TFdW1iEGgVaLzSgzhUZDIgEWI5i2z+8Y/8ESN1B+CIH6yme+T34iLmb7WO4tZzQuk8WKkm4KL6EhnPhvFvwFOs99duSAVwR2lUIDSBB1YbQwTMJoHGZhcRycLzLHgiHXB9+l9w="

# these are zones and subnets examples
#availability_zones = "eu-central-1a"
availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
subnet             = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
# private_subnets    = ["10.10.0.0/24", "10.10.1.0/24"]

# these are used for tags
app_name        = "Ansible"
app_environment = "test-env"
