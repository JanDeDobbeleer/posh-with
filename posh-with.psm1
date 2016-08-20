function Remove-With()
{
    param(
        [string]
        $command
    )

    $splitted = $command -split ' '
    if (!($splitted.Length -eq 1))
    {
        $splitted = $splitted[0..($splitted.Length - 2)]
    }    
    return "$splitted"
}

function Start-With()
{
    param(
        [string]
        $command
    )

    while($true)
    {
        Write-Host  ''
        Write-WithPrompt -command $command
        $input = [Microsoft.PowerShell.PSConsoleReadLine]::ReadLine($host.Runspace, $ExecutionContext)
        
        if ($input.ToLower() -eq ':q')
        {
            return
        }
        elseif ($input.StartsWith(':'))
        {
            if ($input.Length -eq 1)
            {
                continue
            }
            Invoke-Expression "$($input.Substring(1))"
        }
        elseif ($input.StartsWith($command)) {
            # let the user know the command is duplicated
            Write-Host "Your expression starts with '$command'"
            Write-Host 'When using with, make sure to not duplicate the expression.'
            Write-Host "Continuing assuming you meant '$($input.Substring($command.Length).Trim())'"
            Invoke-Expression "$input"
        }
        elseif ($input.StartsWith('>'))
        {
            $addition = $input.Substring(1).Trim()
            if (!($addition -eq ''))
            {
                $command += " $($input.Substring(1).Trim())"
            }
        }
        elseif ($input.StartsWith('<'))
        {
            $command = Remove-With -command $command
        }
        else 
        {
            Invoke-Expression "$command $input"
        }
        
    }
}

function Write-WithPrompt()
{
    param(
        [string]
        $command
    )

    Write-ClassicPrompt -command $command
}

function Write-ClassicPrompt()
{
    param(
        [string]
        $command
    )
    
    Write-Host "PS $pwd " -NoNewline
    Write-Host "$($command.ToUpper())" -ForegroundColor Yellow -NoNewline
    Write-Host "> " -NoNewline    
}

function Invoke-With()
{
    $command = $args
    if (Test-Command -command $command[0])
    {
        Start-With -command ($command.Trim())
    }
    else
    {
        Write-Host "$($command[0]): command not found"
    }
}

function Test-Command()
{
    param(
        [string]
        $command
    )
    return [bool](Get-Command -Name $command -ErrorAction SilentlyContinue)
}

Set-Alias with Invoke-With

