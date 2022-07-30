Connect-PowerBIServiceAccount
$pbix_path = "C:\Users\chris\Kery Business Intelligence Corp\Change Control - Documents\KERY SOLUTIONS"
$pbix_files = Get-ChildItem -Path $pbix_path -Recurse -Filter "Demo 2022.pbix" -File
$pbix_file = $pbix_files[0]
$workspaceName = "Demo%20World"
$DatasetName = "Demo 2022"
$connection_string = "powerbi://api.powerbi.com/v1.0/myorg/$workspaceName;initial catalog=Demo 2022"
$login_info = "User ID=cbayens@kerysolutions.com;Password=wasdwasd@QWE"
$dataset = (Get-PowerBIDataset -WorkspaceId 8aeb7c56-ba4d-459e-ac7a-18b941e7e6fe | Where-Object {$_.Name -like "Test Report"})[0]
$tabular_editor_root_path = "C:\Program Files (x86)\Tabular Editor"
$output_path = Join-Path "C:\Users\chris\OneDrive\Documents\GitHub\PBIXMetadataExtraction" $pbix_file.BaseName
$params = @(
            """Provider=MSOLAP;Data Source=$connection_string;$login_info"""
            """$($dataset.Name)"""
            "-SCRIPT ""$(Join-Path $tabular_editor_root_path 'ApplySerializeOptionsAnnotation.csx')"""
            "-FOLDER ""$output_path"" ""$($pbix_file.BaseName)"""
          )
$executable = "C:\Program Files (x86)\Tabular Editor\TabularEditor.exe"
$temp_name = "$($pbix_file.BaseName)-$(Get-Date -Format 'yyyyMMddTHHmmss')"
$p = Start-Process -FilePath $executable -Wait -PassThru -RedirectStandardOutput "$temp_name.log" -ArgumentList $params