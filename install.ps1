# Install necessary Python packages
py -m pip install requests
py -m pip install pickleshare
py -m pip install jupyterlab
py -m pip install psycopg2

# Download the .ipynb file
$ipynbUrl = "https://raw.githubusercontent.com/owengonzalez46/KIDternship-2025/main/KIDternship%20Worksheet.ipynb"
$outputPath = "KIDternship Worksheet.ipynb"
Invoke-RestMethod -Uri $ipynbUrl -OutFile $outputPath

# Open the .ipynb file in JupyterLab
& py -m jupyterlab $outputPath