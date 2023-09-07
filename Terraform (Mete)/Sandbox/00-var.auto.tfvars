aws_region        = "eu-central-1"
aws_access_key    = "ASIA6EHHJ2TXJ42KLFEZ"
aws_secret_key    = "PS/TGPRbPE664Hc3VRdmFLX2Tz/782ef3U3ekwmj"
aws_session_token = "IQoJb3JpZ2luX2VjELH//////////wEaDGV1LWNlbnRyYWwtMSJHMEUCIHCWvw4wI5o2LN1UzQyRuBORKZ2Gd3BgmZ3MhSYyplsmAiEA9LcEVKIqf6471jnj/i2V04Ow2I9TLVq93l02k8uQOtMqowMIiv//////////ARAAGgw5NzExNDc2OTUzNDIiDAFOkbFnyQobYEvaqCr3Auctsjvbf8D8nikRplASiDUkt3taWQ69TI9n1khqoOpzXEJJQNlnCs94GHhBJEeuN3CcJdYkGKW6qYTDxmnuRFlMc8+TjESUxMUaxeswoRb4C9xDtajeIuqC9nfq43oeKdQCKuAAZt+7Z6vCZHy+PpFe0lbpt1e0QjflHB3vwAWN2275Y2Xrsg0VlQ0mJd1Q3kKco0440au0GvBEQwMf7SSSOEwIaf1SdtkJrSkzWTMPtf6Kn6nW1BPGCmnUxlmhzYbYvxCspKQ5GN8DjLQ41sY2vOxEX5sqLDGB2/UE6i7ibqsSXevhfp4f0ZQIkr64LyO23m+7g4pdFrK9TxaZY22YWUxCc+yz9LHzghLNgn4ytuEvl6/DKF+f1haWISH6RxCsZnf/0kpdkyUBmhY1HYs5MJ+ffxb62/5GwQSeCxOWuBDJzkb8lfh5EkWo19FFXSipaEkJGHIJtdr7Wk4ES8zV5S4RSoWRCCX65y6o1dr8KfsviZfVsTCBmuanBjqmAaTIy+RCV88fz9EF1Ow7j1cIz7gLLI1t7Lxbt2tEAWYnbu329IGP4F5w82+pZvVMc6ekBWDHalVtnG6fo/4D0Yya4qcZO/C7xQSPkYd6FMp4c/bFrw7kYDS+X0B3WemC4ROkEVrG6GcUo16UxDBKiqkwX7oAFAZ43CwrwkQUCvfhY2wwOB5vdSq5wz4LwiAF1g9eEddjOWHB9Noa1WrufhJipxsHLy4="

# these are zones and subnets examples
#availability_zones = "eu-central-1a"
availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
subnet             = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
# private_subnets    = ["10.10.0.0/24", "10.10.1.0/24"]

# these are used for tags
app_name        = "Demo-NGINX-App"
app_environment = "test-env"
