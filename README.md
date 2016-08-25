# with

[![Build status](https://img.shields.io/appveyor/ci/janjoris/posh-with/master.svg)](https://ci.appveyor.com/project/JanJoris/posh-with)

Program prefixing for continuous workflow using a single tool.

### Installation

Use the PowerShell Gallery to install posh-with:

    Install-Module posh-with

### Usage

    with <program>

Starts an interactive shell with where every command is prefixed using `<program>`.

For example:

    PS> with git
    PS GIT> add .
    PS GIT> commit -a -m "Commited"
    PS GIT> push

And to repeat commands:

    PS> with gcc -o output input.c
    PS GCC -O -OUTPUT INPUT.C>
    <enter>
    Compiling...
    PS GCC -O -OUTPUT INPUT.C>

To execute a shell command proper prefix line with `:`.


    PS GIT> :ls

You can also drop and add different commands.

    PS GIT> > add
    PS GIT ADD> <some file>
    PS GIT ADD> <
    PS GIT>

To exit use `:q`.

Currently supports command history and limited completions.

### Theming

To override the current prompt, create your own implementation using this function template:

    function global:Write-WithPrompt()
    {
        param(
            [string]
            $command
        )

        // Your awesome prompt building logic goes here
    }
