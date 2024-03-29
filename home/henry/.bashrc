#!/bin/bash


#=================================================================================================================================#
###	FANCY BASH PROMPT SCRIPT ORIGINALLY TAKEN FROM ANDRES GONGORA https://github.com/andresgongora/synth-shell-prompt	###
#=================================================================================================================================#



###	FUNCTIONS	###								
#=========================#

											
##	bash_prompt_command()	##
#--------------------------------#

#	This function takes your current working directory and stores a shortened version in the variable "NEW_PWD".
#		* The home directory (HOME) is replaced with a ~
#		* The last pwdmaxlen characters of the PWD are displayed
#		* Leading partial directory names are striped off
#			/home/me/stuff -> ~/stuff (if USER=me)
#			/usr/share/big_dir_name -> ../share/big_dir_name (if pwdmaxlen=20)
#	Original source: WOLFMAN'S color bash promt
#	https://wiki.chakralinux.org/index.php?title=Color_Bash_Prompt#Wolfman.27s

bash_prompt_command() {
	# How many characters of the $PWD should be kept
	local pwdmaxlen=25

	# Indicate that there has been dir truncation
	local trunc_symbol=".."

	# Store local dir
	local dir=${PWD##*/}

	# Which length to use
	pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))

	NEW_PWD=${PWD/#$HOME/\~}
	
	local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))

	# Generate name
	if [ ${pwdoffset} -gt "0" ]
	then
		NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
		NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
	fi
}


##	format_font()	##
#------------------------#

#	A small helper function to generate color formating codes from simple number codes (defined below as local variables for convenience).

format_font()
{
	## FIRST ARGUMENT TO RETURN FORMAT STRING
	local output=$1


	case $# in
	2)
		eval $output="'\[\033[0;${2}m\]'"
		;;
	3)
		eval $output="'\[\033[0;${2};${3}m\]'"
		;;
	4)
		eval $output="'\[\033[0;${2};${3};${4}m\]'"
		;;
	*)
		eval $output="'\[\033[0m\]'"
		;;
	esac
}


##	bash_prompt()	##
#------------------------#
	
#	This function colorizes the bash promt. The exact color scheme can be configured here. The structure of the function is as follows:
#		1. A. Definition of font effects, available colors for 16 bit and 256 bits.
#		2. Configuration >> EDIT YOUR PROMT HERE<<.
#		4. Generation of color codes.
#		5. Generation of window title (some terminal expect the first part of $PS1 to be the window title)
#		6. Formating of the bash promt ($PS1).

bash_prompt() {


	## FONT EFFECTS & COLORS ##
	#-------------------------#
	
	## FONT EFFECT
	local      NONE='0'
	local      BOLD='1'
	local       DIM='2'
	local UNDERLINE='4'
	local     BLINK='5'
	local    INVERT='7'
	local    HIDDEN='8'
	
	
	## COLORS
	local   DEFAULT='9'
	local     BLACK='0'
	local       RED='1'
	local     GREEN='2'
	local    YELLOW='3'
	local      BLUE='4'
	local   MAGENTA='5'
	local      CYAN='6'
	local    L_GRAY='7'
	local    D_GRAY='60'
	local     L_RED='61'
	local   L_GREEN='62'
	local  L_YELLOW='63'
	local    L_BLUE='64'
	local L_MAGENTA='65'
	local    L_CYAN='66'
	local     WHITE='67'

	
	## TYPE
	local     RESET='0'
	local    EFFECT='0'
	local     COLOR='30'
	local        BG='40'
	
	
	## 256 COLOR CODES
	local NO_FORMAT="\[\033[0m\]"
	local ORANGE_BOLD="\[\033[1;38;5;208m\]"
	local TOXIC_GREEN_BOLD="\[\033[1;38;5;118m\]"
	local RED_BOLD="\[\033[1;38;5;1m\]"
	local CYAN_BOLD="\[\033[1;38;5;87m\]"
	local BLACK_BOLD="\[\033[1;38;5;0m\]"
	local WHITE_BOLD="\[\033[1;38;5;15m\]"
	local GRAY_BOLD="\[\033[1;90m\]"
		

        ## ANSI 256 COLOR CODES (DRACULA COLOR SCHEME https://draculatheme.com/contribute)
	local BACKGROUND="\[\033[1;38;5;59m\]"
	local CURRENT_LINE="\[\033[1;38;5;60m\]"
	local FOREGROUND="\e[40;38;5;231m"
	local COMMENT="\[\033[1;38;5;103m\]"
	local DRACULA_CYAN="\[\033[1;38;5;159m\]"
	local DRACULA_GREEN="\[\033[1;38;5;120m\]"
	local DRACULA_ORANGE="\e[40;38;5;93m"
	local DRACULA_PINK="\[\033[1;38;5;212m\]"
	local DRACULA_PURPLE="\[\033[1;38;5;183m\]"
	local DRACULA_RED="\[\033[1;38;5;210m\]"
	local DRACULA_YELLOW="\[\033[1;38;5;229m\]"
	
	
	## CHOOSE COLOR COMBINATION HERE
	local FONT_COLOR_1=$BLUE_BOLD
	local BACKGROUND_1=$BLUE
	local TEXTEFFECT_1=$BOLD
	
	local FONT_COLOR_2=$WHITE
	local BACKGROUND_2=$L_BLUE
	local TEXTEFFECT_2=$BOLD
	
	local FONT_COLOR_3=$D_GRAY
	local BACKGROUND_3=$WHITE
	local TEXTEFFECT_3=$BOLD
	
	local PROMT_FORMAT=$BLUE_BOLD
  

	## CONFIGURATIONS ##
	#------------------#
	
	## CONFIGURATION: ORANGEISMYFAVOURITE
	if [ "$HOSTNAME" = wasabi ]; then
		FONT_COLOR_1=$L_GRAY; TEXTEFFECT_1=$BOLD
		FONT_COLOR_2=$D_GRAY; TEXTEFFECT_2=$BOLD
		FONT_COLOR_3=$L_GRAY; TEXTEFFECT_3=$BOLD
		PROMT_FORMAT=$ORANGE_BOLD
	fi
	

	## COLOR CODES GENERATION FOR TEXT ##
	#-----------------------------------#
	
	## CONVERT CODES: add offset
	FC1=$(($FONT_COLOR_1+$COLOR))
	#BG1=$(($BACKGROUND_1+$BG))
	FE1=$(($TEXTEFFECT_1+$EFFECT))
	
	FC2=$(($FONT_COLOR_2+$COLOR))
	#BG2=$(($BACKGROUND_2+$BG))
	FE2=$(($TEXTEFFECT_2+$EFFECT))
	
	FC3=$(($FONT_COLOR_3+$COLOR))
	#BG3=$(($BACKGROUND_3+$BG))
	FE3=$(($TEXTEFFECT_3+$EFFECT))
	
	FC4=$(($FONT_COLOR_4+$COLOR))
	#BG4=$(($BACKGROUND_4+$BG))
	FE4=$(($TEXTEFFECT_4+$EFFECT))
	

	## CALL FORMATING HELPER FUNCTION: effect + font color + BG color
	local TEXT_FORMAT_1
	local TEXT_FORMAT_2
	local TEXT_FORMAT_3
	local TEXT_FORMAT_4	
	format_font TEXT_FORMAT_1 $FE1 $FC1 $BG1
	format_font TEXT_FORMAT_2 $FE2 $FC2 $BG2
	format_font TEXT_FORMAT_3 $FC3 $FE3 $BG3
	format_font TEXT_FORMAT_4 $FC4 $FE4 $BG4
	
	
	## GENERATE PROMT SECTIONS
	local PROMT_USER=$"$TEXT_FORMAT_1 \u "
	local PROMT_HOST=$"$TEXT_FORMAT_2 \h "
	local PROMT_PWD=$"$TEXT_FORMAT_3 \${NEW_PWD} "
	local PROMT_INPUT=$"$PROMT_FORMAT "


	## COLOR CODES GENERATION FOR SEPARATOR ##
	#----------------------------------------#
	
	## CONVERT CODES
	#TSFC1=$(($BACKGROUND_1+$COLOR))
	#TSBG1=$(($BACKGROUND_2+$BG))
	
	#TSFC2=$(($BACKGROUND_2+$COLOR))
	#TSBG2=$(($BACKGROUND_3+$BG))
	
	#TSFC3=$(($BACKGROUND_3+$COLOR))
	#TSBG3=$(($DEFAULT+$BG))
	

	## CALL FORMATING HELPER FUNCTION: effect + font color + BG color
	#local SEPARATOR_FORMAT_1
	#local SEPARATOR_FORMAT_2
	#local SEPARATOR_FORMAT_3
	#format_font SEPARATOR_FORMAT_1 $TSFC1 $TSBG1
	#format_font SEPARATOR_FORMAT_2 $TSFC2 $TSBG2
	#format_font SEPARATOR_FORMAT_3 $TSFC3 $TSBG3
	

	# GENERATE SEPARATORS WITH FANCY TRIANGLE
	#local TRIANGLE=$'\uE0B0'	
	#local SEPARATOR_1=$SEPARATOR_FORMAT_1$TRIANGLE
	#local SEPARATOR_2=$SEPARATOR_FORMAT_2$TRIANGLE
	#local SEPARATOR_3=$SEPARATOR_FORMAT_3$TRIANGLE


	## WINDOW TITLE GENERATION ##
	#---------------------------#

	case $TERM in
	xterm*|rxvt*)
		local TITLEBAR='\[\033]0;\u:${NEW_PWD}\007\]'
		;;
	*)
		local TITLEBAR=""
		;;
	esac


	## BASH PROMT FORMATTING ##
	#-------------------------#

	PS1="$TITLEBAR\n${PROMT_USER}${SEPARATOR_1}${PROMT_HOST}${SEPARATOR_2}${PROMT_PWD}${SEPARATOR_3}${PROMT_INPUT}"

	

	## For terminal line coloring, leaving the rest standard
	none="$(tput sgr0)"
	trap 'echo -ne "${none}"' DEBUG
}




###	MAIN SCRIPT BODY	###
#=================================#


##	It calls the adequate helper functions to colorize your promt and sets
##	a hook to regenerate your working directory "NEW_PWD" when you change it.

##	Bash provides an environment variable called PROMPT_COMMAND. 
##	The contents of this variable are executed as a regular Bash command 
##	just before Bash displays a prompt. 
##	We want it to call our own command to truncate PWD and store it in NEW_PWD

PROMPT_COMMAND=bash_prompt_command


##	Call bash_promnt only once, then unset it (not needed any more)
##	It will set $PS1 with colors and relative to $NEW_PWD, 
##	which gets updated by $PROMT_COMMAND on behalf of the terminal

bash_prompt
unset bash_prompt



### 	END OF FANCY BASH PROMPT	###
#=========================================#




### 	ALIASES 	###
#=========================#

alias ls="ls -l --color=auto"
alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias ip="ip --color=auto"
alias i="neofetch"
#alias update="yay -Syu && sudo flatpak update && yay -Qtdq | yay -Rns - && yay -Qqd | yay -Rsu -"
alias backup="	backupsystem 
		backupmedia   "
alias c="clear"
alias reboot="sudo reboot"
alias poweroff="sudo poweroff"
#alias lock="./matrixlock.sh"
alias logout="qtile cmd-obj -o cmd -f shutdown"
alias task="btm -b"
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=/"
alias sudo="sudo -E"


### 	CHEATSHEET 	###
#=========================#

echo "USEFUL ALIASES & COMMANDS:
-------------------------------------------------------------------------------------------------------------------------------------
|  update    To update the system    |  i          For system information    |  dotfiles             Git repo of config files       |
|  clean     To clean the system     |  c          To clear the terminal     |  dotfiles add [file]  Adds a modified or new [file]  |
|  backup    To backup to SSD        |  z [dir]    To jump to [dir]          |  dotfiles commit      Commits changes locally        |
|  lock      To lock the screen      |  task       Task manager (btm)        |  dotfiles push        Push changes to GitHub         |
|  logout    To log out of Qtile     |  speedtest  Tests internet speed      |  dotfiles status      Shows uncommitted changes      |
|  reboot    Reboots the PC          |  tldr [cmd] For quick [cmd] info      |  dotfiles ls-files    List all tracked files         |
|  poweroff  Turns PC off            |  tree       Display directory tree    |  dotfiles rm [file]   Removes [file] from repo       |
-------------------------------------------------------------------------------------------------------------------------------------
"


### 	LOAD ZOXIDE CONFIGURATION 	###
#=========================================#

eval "$(zoxide init bash)"


###	EXPORT LS_COLORS VARIABLE	###
#=========================================#

# 	Creating and exporing LS_COLORS global variable, using the dircolors database, the code below was creaded following the instructions on page 
#	https://opensource.com/article/19/9/linux-terminal-colors
#	running the following command:
#	dircolors --bourne-shell ~/.dircolors >> ~.bashrc
#	source ~/.bashrc

LS_COLORS='fi=00;38;5;159:rs=0:di=01;38;5;159:ln=38;5;159:mh=00:pi=01;38;5;222:so=01;35:do=01;35:bd=01;33:cd=01;33:or=38;5;210:mi=00:su=01;38;5;212:sg=01;38;5;212:ca=00:tw=01;38;5;159:ow=01;38;5;159:st=01;38;5;159:ex=01;38;5;120:*.tar=01;38;5;183:*.tgz=01;38;5;183:*.arc=01;38;5;183:*.arj=01;38;5;183:*.taz=01;38;5;183:*.lha=01;38;5;183:*.lz4=01;38;5;183:*.lzh=01;38;5;183:*.lzma=01;38;5;183:*.tlz=01;38;5;183:*.txz=01;38;5;183:*.tzo=01;38;5;183:*.t7z=01;38;5;183:*.zip=01;38;5;183:*.z=01;38;5;183:*.dz=01;38;5;183:*.gz=01;38;5;183:*.lrz=01;38;5;183:*.lz=01;38;5;183:*.lzo=01;38;5;183:*.xz=01;38;5;183:*.zst=01;38;5;183:*.tzst=01;38;5;183:*.bz2=01;38;5;183:*.bz=01;38;5;183:*.tbz=01;38;5;183:*.tbz2=01;38;5;183:*.tz=01;38;5;183:*.deb=01;38;5;183:*.rpm=01;38;5;183:*.jar=01;38;5;183:*.war=01;38;5;183:*.ear=01;38;5;183:*.sar=01;38;5;183:*.rar=01;38;5;183:*.alz=01;38;5;183:*.ace=01;38;5;183:*.zoo=01;38;5;183:*.cpio=01;38;5;183:*.7z=01;38;5;183:*.rz=01;38;5;183:*.cab=01;38;5;183:*.wim=01;38;5;183:*.swm=01;38;5;183:*.dwm=01;38;5;183:*.esd=01;38;5;183:*.avif=38;5;229:*.jpg=38;5;229:*.jpeg=38;5;229:*.mjpg=38;5;229:*.mjpeg=38;5;229:*.gif=38;5;229:*.bmp=38;5;229:*.pbm=38;5;229:*.pgm=38;5;229:*.ppm=38;5;229:*.tga=38;5;229:*.xbm=38;5;229:*.xpm=38;5;229:*.tif=38;5;229:*.tiff=38;5;229:*.png=38;5;229:*.svg=38;5;229:*.svgz=38;5;229:*.mng=38;5;229:*.pcx=38;5;229:*.mov=38;5;229:*.mpg=38;5;229:*.mpeg=38;5;229:*.m2v=38;5;229:*.mkv=38;5;229:*.webm=38;5;229:*.webp=38;5;229:*.ogm=38;5;229:*.mp4=38;5;229:*.m4v=38;5;229:*.mp4v=38;5;229:*.vob=38;5;229:*.qt=38;5;229:*.nuv=38;5;229:*.wmv=38;5;229:*.asf=38;5;229:*.rm=38;5;229:*.rmvb=38;5;229:*.flc=38;5;229:*.avi=38;5;229:*.fli=38;5;229:*.flv=38;5;229:*.gl=38;5;229:*.dl=38;5;229:*.xcf=38;5;229:*.xwd=38;5;229:*.yuv=38;5;229:*.cgm=38;5;229:*.emf=38;5;229:*.ogv=38;5;229:*.ogx=38;5;229:*.aac=38;5;120:*.au=38;5;120:*.flac=38;5;120:*.m4a=38;5;120:*.mid=38;5;120:*.midi=38;5;120:*.mka=38;5;120:*.mp3=38;5;120:*.mpc=38;5;120:*.ogg=38;5;120:*.ra=38;5;120:*.wav=38;5;120:*.oga=38;5;120:*.opus=38;5;120:*.spx=38;5;120:*.xspf=38;5;120:*~=38;5;183:*#=38;5;183:*.bak=38;5;183:*.crdownload=38;5;183:*.dpkg-dist=38;5;183:*.dpkg-new=38;5;183:*.dpkg-old=38;5;183:*.dpkg-tmp=38;5;183:*.old=38;5;183:*.orig=38;5;183:*.part=38;5;183:*.rej=38;5;183:*.rpmnew=38;5;183:*.rpmorig=38;5;183:*.rpmsave=38;5;183:*.swp=38;5;183:*.tmp=38;5;183:*.ucf-dist=38;5;183:*.ucf-new=38;5;183:*.ucf-old=38;5;183:';
export LS_COLORS
