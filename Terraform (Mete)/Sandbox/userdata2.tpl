#!/bin/bash
sudo yum update -y &&
sudo yum upgrade -y

# amazon-linux-extras list | grep ansible
sudo amazon-linux-extras install ansible2 -y

sudo yum install python-pip -y

pip install boto

sudo su

ssh-add ~/.ssh/privatekey

# pip3 install boto

# https://www.youtube.com/watch?v=CjqzlmKMq44

mkdir ~/.aws
touch ~/.aws/credentials

cd /home/ec2-user/

# copy_credentials="

# [971147695342_Student]
# aws_access_key_id=ASIA6EHHJ2TXN3NJNY7P
# aws_secret_access_key=Jyb/+IUFthQSF1WWTaeTpyjT3lz3KHHj7QHfaGaO
# aws_session_token=IQoJb3JpZ2luX2VjEHAaDGV1LWNlbnRyYWwtMSJGMEQCIA44Ra5+5DFDWz5mF10Gsd0a6h4QHqx379pcyYPYvFN2AiBlEk5z44/F9ztbsv+JkJlapYhKUEbewltTd1wvJHbnvyqaAwhZEAAaDDk3MTE0NzY5NTM0MiIM1fx9aZ/SI7N1e/OPKvcC5GJtMUcwZpqU36u4YABfuTp4V7frMTqg8MSjoCRq9LVIanoKHjEhNIy9+ovhiQmV+fPyRIW1mS+jWa0WbMPkzdMFLLOacNWANH1oUAgem55NEhQp2Qbs1ZGfJx45GsZTJJE6ZOmONgW4Q4CaCZwfhCVxEEd8p3YOUg2Q0wJvde9pcKjganlVbt1595q31Fp0HEgZ5F8KreUp3ClGIdcoS0vKzicGue28zl4e2k+lNVl5TKV/NW1qyOZHuwESCrmPLq0TlxLMeGI4O6HCQNamKDLu8Q44a8KFSVm4OlBRdqpJe+4vZyB9RmNAQk1wBjwS2z2znhdzE4SVcE5WcIF5ZBmCMiPeTcRtdpYLEN7GvvFWELmSkzXLQMCVw0Ew1rBNryzXG6nUp/ewUDpfkpbyUA77ILph2kGiaaszGpgy2gaef+5ixtJUgelSukWkL5DqVncq3KzS3LfnmuhfH1gGOobtiq4VWJfRHXh33N4AbjlZXIDmrf78MJCYkKgGOqcBDWuvk7YqVKo+NUe53/k2Xf8Eq5bI8pBMq0VyPqW7O6yRqm25qAYNP4PKa1irUeXCH8sIFDmPsHnI/4+DvKshwTHqUUQDtoVQenFUdGmGiQHak2PRcrKEybPWuMiLsIoj4M/ChymgcAdklMAYGvQOioouJ553c225Oux4qiTx0dIERQLrAo+tnePYMD8O/JnfNduRT0AKm0U1VckFKIhG55wiaphgAk8=

# " 
# echo "$copy_credentials" | sudo tee "~/.aws/credentials"

echo "target_subnet: ${subnet}" >> launch_ec2_vars

echo "${user_id}" >> ~/.aws/credentials
echo "aws_access_key_id=${access_key}" >> ~/.aws/credentials
echo "aws_secret_access_key=${secret_key}" >> ~/.aws/credentials
echo "aws_session_token=${session_token}" >> ~/.aws/credentials


ansible-galaxy collection install amazon.aws -y



