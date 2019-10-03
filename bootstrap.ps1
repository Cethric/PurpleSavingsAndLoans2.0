Install-WindowsFeature web-server -includemanagementtools
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False