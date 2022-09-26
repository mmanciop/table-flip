# Table-flip: the shell prompt that accurately expresses your mood.
# Copyright (C) 2022  Michele Mancioppi
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

PROMPT_COMMAND=__prompt_command # Function to generate PS1 after CMDs

__prompt_command() {
    local EXIT="${?}"

    local RCol='\[\e[0m\]'
    local FlipLevels=('32' '93' '33' '95' '35' '91' '31')

    if ! [[ "${TABLE_FLIPNESS}" =~ ^[0-9]+$ ]]; then
        # Value is not an integer; reset (although probably we
        # should set it a very high number on principle)
        TABLE_FLIPNESS=0
    fi

    local FlipLevel=${TABLE_FLIPNESS:-0}
    local OriginalFlipLevel=${FlipLevel}

    if [ ${EXIT} != 0 ]; then
        let FlipLevel++
    elif (( ${FlipLevel} > 0 )); then
        let FlipLevel--
    fi

    export TABLE_FLIPNESS=${FlipLevel}

    if (( ${FlipLevel} >= ${#FlipLevels[@]} )); then
        let "FlipLevel = ${#FlipLevels[@]} - 1"
    fi

    if (( ${FlipLevel} == 0 )) && (( ${FlipLevel} < ${OriginalFlipLevel} )); then
        FlipPrompt="(ヘ･_･)ヘ ┳━┳"
    elif (( ${FlipLevel} == 0 )); then
        case $((1 + $RANDOM % 6)) in
        1)
            FlipPrompt="( ･_･)    ┳━┳"
            ;;
        2)
            FlipPrompt="(･_･ )    ┳━┳"
            ;;
        3)
            FlipPrompt="(^_^ )    ┳━┳"
            ;;
        4)
            FlipPrompt="( ^_^)    ┳━┳"
            ;;
        5)
            FlipPrompt="(^_^ )♫♪  ┳━┳"
            ;;
        6)
            FlipPrompt="( ^_^)♪♫  ┳━┳"
            ;;
        esac
    elif (( ${FlipLevel} > 0 )); then
        FlipPrompt="\[\e[1;${FlipLevels[${FlipLevel}]}m\](╯°□°）╯${RCol}︵┻━┻"
    fi

    PS1="${FlipPrompt} $ ${RCol}"
}