#!/usr/bin/env zsh

emulate -LR zsh

    clear
    print -r  '  ___________.._______    '
    print -r  ' | .__________))______|   '
    print -r  ' | | / /      ||          '
    print -r  ' | |/ /       ||          '
    print -r  ' | | /        ||.-''.     '
    print -r  ' | |/         |/  _  \    '
    print -r  ' | |          ||  `/,|    '
    print -r  ' | |          (\\`_.'     ''
    print -r  ' | |         .-`--'.      ''
    print -r  ' | |        /Y . . Y\     '
    print -r  ' | |       // |   | \\    '
    print -r  ' | |      //  | . |  \\   '
    print -r  ' | |      '  \|  \|   '    '''
    print -r  ' | |          || ||       '
    print -r  ' | |          || ||       '
    print -r  ' | |          || ||       '
    print -r  ' | |          || ||       '
    print -r  ' | |         / | | \      '
    print -r  ' """"""""""|_`-' '-` |"""|'
    print -r  ' |"|"""""""\ \         |"|'
    print -r  ' | |        \ \        | |'
    print -r  ' : :         \ \       : :'
    print -r  ' . .          `'       . .''
    print -r  '                          '
    sleep 2
# Ascii art by Manus O'Donnell

. ./themes

autoload -Uz colors; colors

# variables

red=$fg[red]
green=$fg[green]
magenta=$fg[magenta]
yellow=$fg[yellow]

TYPE=""  # a scalar holding the theme string

typeset -a type  # this variable will hold the array of the chosen theme (animals, jobs, etc.)

# functions 

array_choose ()
{
	chosen=$type[$(($RANDOM % $#type))] 
    chosen_length=$#chosen
	chosen_array=(${(s::)chosen})
    print $TYPE:u
    print
    print "The word contains $chosen_length characters"
}

try_letter ()
{
    limit_test=0
    read -k -s letter
    chosen_array_length=$#chosen_array
    repeat $chosen_array_length
    do
        if [[ $letter == ${chosen_array[$chosen_array_length]} ]]
        then 
	        clear
            if [[ ! ${typed_letters[(r)$letter]} == $letter ]]
            then
                typed_letters+=("$(print $letter)")
                ((guessed++))
            else
                :
            fi
            print $TYPE:u
            print
            print "The word contains the character $letter" 
            print
            print "Tries: $(($tries - $misses))     Characters:  ${typed_letters[@]}" 
            print
            type_lines[$chosen_array_length]=$letter
            print "$type_lines"
            print
			drawing
        else
            ((limit_test++))
            if [[ $limit_test -eq $#chosen_array ]]
            then
                print
		        clear
                if [[ ! ${typed_letters[(r)$letter]} == $letter ]]
                then
                    typed_letters+=("$(print $letter)")
                    ((misses++))
                else
                    :
                fi
                print $TYPE:u
                print
                print "The word does not contain the character $letter"
                if [[ $(($tries - $misses)) -eq 0 ]]
                then
                    :
                else
                    print
                    print "Tries: $(($tries - $misses))     Characters: ${typed_letters[@]}"
		    print
                    print "$type_lines"
		    print
			drawing
                fi
            fi
        fi
        ((chosen_array_length--))
        if [[ $type_lines == ${chosen_array[@]} ]]
        then
			print
            print $green"YOU WON!!!"
            print
            print "The word is $magenta${(U)chosen}"$reset_color
			print
            print "Press a key to return to menu"
            read -s -k 1
            [[ -n $REPLY ]] && menu
         fi
    done
    
}

game ()
{
    clear
    array_choose
    typed_letters=()
    print
    print "Tries: $(($tries - $misses))     Characters: ${typed_letters[@]}"
	print
    type_lines=(`printf "_ %.0s" {1..$#chosen_array}`)
    print $type_lines
	print
	drawing
    print
    while (( misses < tries ));
    do
        try_letter
		if [[ $type_lines == ${chosen_array[@]} ]] 
		then
		    break
    	fi
    done
    
    if [[ ! $type_lines == ${chosen_array[@]} ]]
    then	    
	    print "Tries: $(($tries - $misses))     Characters: ${typed_letters[@]}"
        print
        print $type_lines
        print
        print $red"YOU LOST!!!"
		print
        print "The correct word is $magenta${(U)chosen}"$reset_color
		print
		drawing
        print
        print "Press a key to return to menu"
        read -s -k 1
        [[ -n $REPLY ]] && menu 
    fi
}



# Function menu

menu ()
{
	tries=10
	misses=0
	guessed=0

	unset chosen chosen_array

    clear
    print $yellow"     ZHANGMAN "$reset_color
    print
    print "Choose the theme and press enter:"
    print
    menu_option=(Animals Jobs Sports Quit)
	PROMPT3=$'\nChoice: '
    select opt in "${menu_option[@]}"
    do
        case $opt in
            Animals)
				TYPE=animals
				type=($animals)
                game
                ;;
            Jobs)
				TYPE=jobs
				type=($jobs)
                game
                ;;
            Sports)
				TYPE=sports
				type=($sports)
                game
                ;;
            Quit)
                exit 0
                ;;
            *)
                print "Invalid option!"
                ;;
        esac
        print
    done
}

drawing ()
{
	drawing_10 ()
	{
		if (( misses == 0 ));then print '
	    __________
	     |/      
	     |      
	     |      
	     |       
	     |       
	     |
	  ___|___'
		fi
	}
	
	drawing_9 ()
	{
		if (( misses == 1 ));then print '
	    __________
	     |/      |
	     |      
	     |      
	     |       
	     |       
	     |
	  ___|___'
		fi
	}
	
	drawing_8 ()
	{
		if (( misses == 2 ));then print '
	    __________
	     |/      |
	     |        )
	     |      
	     |       
	     |       
	     |
	  ___|___'
		fi
	}
	
	drawing_7 ()
	{
		if (( misses == 3 ));then print '
	    __________
	     |/      |
	     |      ( )
	     |      
	     |       
	     |       
	     |
	  ___|___'
		fi
	}
	
	drawing_6 ()
	{
		if (( misses == 4 ));then print '
	    __________
	     |/      |
	     |      (_)
	     |       
	     |       
	     |       
	     |
	  ___|___'
		fi
	}
	
	drawing_5 ()
	{
		if (( misses == 5 ));then print '
	    __________
	     |/      |
	     |      (_)
	     |       |
	     |       
	     |       
	     |
	  ___|___'
		fi
	}
	
	drawing_4 ()
	{
		if (( misses == 6 ));then print '
	    __________
	     |/      |
	     |      (_)
	     |       |/
	     |       
	     |       
	     |
	  ___|___'
		fi
	}
	
	drawing_3 ()
	{
		if (( misses == 7 ));then print '
	    __________
	     |/      |
	     |      (_)
	     |      \\|/
	     |       
	     |       
	     |
	  ___|___'
		fi
	}
	
	drawing_2 ()
	{
		if (( misses == 8 ));then print '
	    __________
	     |/      |
	     |      (_)
	     |      \\|/
	     |       |
	     |        
	     |
	  ___|___'
		fi
	}
	
	drawing_1 ()
	{
		if (( misses == 9 ));then print '
	    __________
	     |/      |
	     |      (_)
	     |      \\|/
	     |       |
	     |        \\
	     |
	  ___|___'
		fi
	}
	
	drawing_0 ()
	{
		if (( misses == 10 ));then print '
	    __________
	     |/      |
	     |      (_)
	     |      \\|/
	     |       |
	     |      / \\
	     |
	  ___|___'
		fi
	}

	drawing_10; drawing_9; drawing_8; drawing_7; drawing_6;	drawing_5; drawing_4; drawing_3; drawing_2; drawing_1; drawing_0
}

menu
