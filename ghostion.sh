#!/bin/bash

# ghostion.sh - A script to install Gulp plugins required to develop Ghostion Ghost theme and releasing the theme, documentation, demo builder, and source files.

## Function
function usage
{
    echo "$(tput setaf 2)[AxianTheme] Ghostion Theme Command Line Usage$(tput sgr 0)\n"
    echo "$(tput setaf 6)sh ghostion.sh -i$(tput sgr 0) or $(tput setaf 6)sh ghostion.sh --install$(tput sgr 0)\nInstalling all necessary Gulp plugins required to develop Ghostion theme\n"
    echo "$(tput setaf 6)sh ghostion.sh -d$(tput sgr 0) or $(tput setaf 6)sh ghostion.sh --develop$(tput sgr 0)\nStarting Ghostion theme development. Gulp will be watching scss and js file changes\n"
	echo "$(tput setaf 6)sh ghostion.sh -b$(tput sgr 0) or $(tput setaf 6)sh ghostion.sh --build$(tput sgr 0)\nBuilding Ghostion theme, documentation, demobuilder, and source files\n\n"
    echo "$(tput setaf 6)sh ghostion.sh -r <Release_Version>$(tput sgr 0) or $(tput setaf 6)sh ghostion.sh --release <Release_Version>$(tput sgr 0)\nReleasing Ghostion theme, documentation, demobuilder, and source files\n"
    echo "$(tput setaf 6)sh ghostion.sh -h$(tput sgr 0) or $(tput setaf 6)sh ghostion.sh --help$(tput sgr 0)\nGhostion theme command line usage help overview\n"
}

## Main
while [ "$1" != "" ]; do
    case $1 in
    	-i | --install	)	echo "$(tput setaf 3)[AxianTheme] Installing Necessary Gulp Plugins for Ghostion$(tput sgr 0)"
							npm install event-stream gulp-ruby-sass gulp-rename gulp-minify-css gulp-concat gulp-uglify gulp-notify gulp-clean gulp-zip --save-dev yargs gulp-bump
							echo "$(tput setaf 2)[AxianTheme] Necessary Gulp Plugins for Ghostion are Installed Successfully$(tput sgr 0)"
							exit
							;;
		-d | --develop	)	echo "$(tput setaf 3)[AxianTheme] Starting Ghostion Development: Watching scss and js Files Change ...$(tput sgr 0)"
							gulp develop
							exit
							;;
		-b | --build	)	echo "$(tput setaf 3)[AxianTheme] Building Ghostion Theme Files$(tput sgr 0)"
							if ["$2" == ""]; 
							then
								echo "$(tput setaf 1)Please pass build version$(tput sgr 0)\n"
								usage
							else
								gulp build --buildversion $2
								echo "$(tput setaf 2)[AxianTheme] Ghostion Theme Files Built Successfully$(tput sgr 0)"
							fi
							exit
							;;
		-r | --release	)	echo "$(tput setaf 3)[AxianTheme] Releasing Ghostion Theme Files$(tput sgr 0)"
							if ["$2" == ""]; 
							then
								echo "$(tput setaf 1)Please pass release version$(tput sgr 0)\n"
								usage
							else
								gulp release --releaseversion $2
								echo "$(tput setaf 2)[AxianTheme] Ghostion Theme Files Released Successfully$(tput sgr 0)"
							fi
							exit
							;;
		-h | --help		)	usage
							exit
							;;
		*				)	echo "$(tput setaf 1)[AxianTheme] Please pass the available parameters$(tput sgr 0)\n"
							usage
							exit
	esac
done

if ["$1" == ""]; then
	echo "$(tput setaf 1)[AxianTheme] Please pass the available parameters$(tput sgr 0)\n"
	usage
fi