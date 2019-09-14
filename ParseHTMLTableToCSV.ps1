# Very little of this is my work! All proper attribution goes to Lee Holmes over at leeholmes.com!!! All I did was function-ize it, have the resultObjects append to an array, and pass the array to a CSV. See his original blog post here: https://www.leeholmes.com/blog/2015/01/05/extracting-tables-from-powershells-invoke-webrequest/
# To use this, run this like: ./ParseHTMLTableToCSV.ps1 $WebRequest -TableNumber 0

Function ParseHTMLTableToCSV {
param(
    [Parameter(Mandatory = $true)]

    [Microsoft.PowerShell.Commands.HtmlWebResponseObject] $WebRequest,

    [Parameter(Mandatory = $true)]

    [int] $TableNumber

)

$writelocation = "C:\"
$csvname = = "outfile.csv"
$tables = @(WebRequest.ParsedHtml.getElementsByTagName("TABLE"))
$table = $tables[$TableNumber]
$titles = @()
$rows = @($table.Rows)
$TableArray = @()

## Go through all of the rows in the table

foreach($row in $rows)

{

    $cells = @($row.Cells)

   

    ## If we've found a table header, remember its titles

    if($cells[0].tagName -eq "TH")

    {

        $titles = @($cells | % { ("" + $_.InnerText).Trim() })

        continue

    }

    ## If we haven't found any table headers, make up names "P1", "P2", etc.

    if(-not $titles)

    {

        $titles = @(1..($cells.Count + 2) | % { "P$_" })

    }

    ## Now go through the cells in the the row. For each, try to find the

    ## title that represents that column and create a hashtable mapping those

    ## titles to content

    $resultObject = [Ordered] @{}

    for($counter = 0; $counter -lt $cells.Count; $counter++)

    {

        $title = $titles[$counter]

        if(-not $title) { continue }

       

        $resultObject[$title] = ("" + $cells[$counter].InnerText).Trim()

    }

    ## And finally cast that hashtable to a PSCustomObject

    $TableArray += [PSCustomObject] $resultObject 
}

$TableArray | Export-Csv -Path ($writelocation + $csvname) -Delimiter $delimiter -NoTypeInformation
}

ParseHTMLTableToCSV