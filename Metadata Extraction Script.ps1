Connect-PowerBIServiceAccount
$workspace = Get-PowerBIWorkspace | Where-Object {$_.Name -eq "CJBGithubTest"}
$pbix_path = "C:\Users\chris\Kery Business Intelligence Corp\Change Control - Documents\KERY SOLUTIONS"
$pbix_files = Get-ChildItem -Path $pbix_path -Recurse -Filter "Demo 2022.pbix" -File
$pbix_file = $pbix_files[0]
$temp_name = "$($pbix_file.BaseName)-$(Get-Date -Format 'yyyyMMddTHHmmss')"
$report = New-PowerBIReport -Path $pbix_file.FullName -Name $temp_name -WorkspaceId $workspace.Id
$workspaceName = $workspace.Name
$Dataset = Get-PowerBIDataset -WorkspaceId "b6ecd4d5-4b2b-4fe6-9814-f99d7adda784" | Where-Object {$_.Name -eq $temp_name}
$DatasetName = $Dataset.Name
$connection_string = "powerbi://api.powerbi.com/v1.0/myorg/$workspaceName;initial catalog="+$Dataset.Name
$login_info = "User ID=cbayens@kerysolutions.com;Password=wasdwasd@QWE"
$tabular_editor_root_path = "C:\Program Files (x86)\Tabular Editor"
$output_path = Join-Path "C:\Users\chris\OneDrive\Documents\GitHub\PBIXMetadataExtraction" $pbix_file.BaseName
$params = @(
            """Provider=MSOLAP;Data Source=$connection_string;$login_info"""
            """$($Dataset.Name)"""
            "-SCRIPT ""$(Join-Path $tabular_editor_root_path 'ApplySerializeOptionsAnnotation.csx')"""
            "-FOLDER ""$output_path"" ""$($pbix_file.BaseName)"""
          )
$executable = "C:\Program Files (x86)\Tabular Editor\TabularEditor.exe"

$p = Start-Process -FilePath $executable -Wait -PassThru -RedirectStandardOutput "$temp_name.log" -ArgumentList $params