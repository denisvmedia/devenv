Set-Location -Path coredns
& docker-compose up -d

# ## Delete:
# Get-DnsClientNrptRule | Where { $_.Namespace -eq ',devenv.test' } | Remove-DnsClientNrptRule -Force
# Get-DnsClientNrptRule | Where { $_.Namespace -eq 'devenv.test' } | Remove-DnsClientNrptRule -Force

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
  $arguments = '& Add-DnsClientNrptRule -Namespace "devenv.test" -NameServers "127.0.0.1"; & Add-DnsClientNrptRule -Namespace ".devenv.test" -NameServers "127.0.0.1"'
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}
