# Only load env from azd if azd command and azd environment exist
if (-not (Get-Command azd -ErrorAction SilentlyContinue)) {
  Write-Host "azd command not found, skipping .env file load"
} else {
  $output = azd env list
  if (!($output -like "*true*")) {
    Write-Output "No azd environments found, skipping .env file load"
  } else {
    Write-Host "Loading azd .env file from current environment"
    $output = azd env get-values
    foreach ($line in $output) {
      if (!$line.Contains('=')) {
        continue
      }

      $name, $value = $line.Split("=")
      $value = $value -replace '^\"|\"$'
      [Environment]::SetEnvironmentVariable($name, $value)
    }
  }
}
