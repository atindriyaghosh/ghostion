#!/bin/bash
# ***********************************************
# * SCRIPT NAME: ghost-blog.sh                  *
# *                                             *
# * VERSION: 1.0.0                              *
# *                                             *
# * DATE MODIFIED (MM-DD-YYYY): 05-04-2014      *
# *                                             *
# * AUTHOR: Atindriya Ghosh                     *
# *                                             *
# * FUNCTIONS:                                  *
# * 1. Start the blog                           *
# * 2. Stop the blog                            *
# * 3. Restart the blog                         *
# * 4. Deploy the latest release artifacts      *
# ***********************************************
## Functions
usage(){
    echo "PARAMETERS:"
    echo "1. $(tput setaf 6)./ghost-blog.sh -s$(tput sgr 0) or $(tput setaf 6)./ghost-blog.sh --start$(tput sgr 0)$(tput sgr 0) - Starts the blog"
    echo "2. $(tput setaf 6)./ghost-blog.sh -t$(tput sgr 0) or $(tput setaf 6)./ghost-blog.sh --terminate$(tput sgr 0)$(tput sgr 0) - Stops the blog"
	echo "3. $(tput setaf 6)./ghost-blog.sh -r$(tput sgr 0) or $(tput setaf 6)./ghost-blog.sh --restart$(tput sgr 0)$(tput sgr 0) - Restarts the blog"
	echo "4. $(tput setaf 6)./ghost-blog.sh -d$(tput sgr 0) or $(tput setaf 6)./ghost-blog.sh --deploy$(tput sgr 0)$(tput sgr 0) - Deploy the latest release"
}
startup(){ 
	echo "$(tput setaf 3)Starting The Blog ...$(tput sgr 0)"
	sudo rm -rf /var/cache/nginx/*
	sudo service nginx restart
	sudo NODE_ENV=production forever start /var/www/index.js
	echo "$(tput setaf 2)Blog Started Successfully$(tput sgr 0)"
}
shutdown(){ 
	echo "$(tput setaf 3)Stopping The Blog ...$(tput sgr 0)"
	sudo forever stop /var/www/index.js
	sudo service nginx stop
	echo "$(tput setaf 2)Blog Stopped Successfully$(tput sgr 0)"
}
restart(){ 
	echo "$(tput setaf 3)Restarting The Blog ...$(tput sgr 0)"
	shutdown
	startup
	echo "$(tput setaf 2)Blog Restarted Successfully$(tput sgr 0)"
}
deploy(){ 
	shutdown
	echo "$(tput setaf 3)Deploying Latest Release Artifacts ...$(tput sgr 0)"
	cd /var/www/content/themes/the-ghost-who-blogs
	sudo rm -rf *
	sudo unzip /home/ubuntu/Ghostion/releases/theme/the-ghost-who-blogs.zip
	cd /var/www
	echo "$(tput setaf 2)Release Artifacts Deployed Successfully$(tput sgr 0)"
	startup
}
## Main
while [ "$1" != "" ]; do
    case $1 in
    	"-s" | "--start"	)	startup
							exit
							;;
		"-t" | "--terminate"		)	shutdown
							exit
							;;
		"-r" | "--restart"	)	restart
							exit
							;;
		"-d" | "--deploy"	)	deploy
							exit
							;;	
		"-h" | "--help"		)	usage
							exit
							;;
		*				)	echo "$(tput setaf 1)Please pass the available parameters$(tput sgr 0)\n"
							usage
							exit
	esac
done
if ["$1" == ""]; then
	echo "$(tput setaf 1)Please pass the available parameters$(tput sgr 0)\n"
	usage
fi