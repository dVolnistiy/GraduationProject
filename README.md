# GraduationProject

If you want to deploy your python application in Amazon ECS, this project will help you with that. All you need is change variables in _roles/group_vars_, and specify line in application with initialization of database, smth like **Database.initialise(database="{{ db }}", user="{{ db_user }}", password="{{ db_pass }}", host="{{ item }}")'**, ~~also need to install dependencies like boto3, ansible, aws cli and many other... But about that in future!~~
When all is done, you can download this repo, specify your own application, necessary libraries and other dependecies write in requirements.txt! And after that just type **make** in directory with repo and follow the instructions! Good luck!
