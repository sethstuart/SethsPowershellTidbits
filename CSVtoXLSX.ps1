Function CSVtoXLSX {
$writelocation = "C:\"
$csvname = = "outfile.csv"

# Create a new Excel workbook with one empty sheet
$excel = New-Object -ComObject excel.application 
$workbook = $excel.Workbooks.Add(1)
$worksheet = $workbook.worksheets.Item(1)

# Build the QueryTables.Add command and reformat the data
$TxtConnector = ("TEXT;" + ($writelocation + $csvname))
$Connector = $worksheet.QueryTables.add($TxtConnector,$worksheet.Range("A1"))
$query = $worksheet.QueryTables.item($Connector.name)
$query.TextFileOtherDelimiter = $global:delimiter
$query.TextFileParseType  = 1
$query.TextFileColumnDataTypes = ,1 * $worksheet.Cells.Columns.Count
$query.AdjustColumnWidth = 1

# Execute & delete the import query
$query.Refresh()
$query.Delete()

# Save & close the Workbook as XLSX.
$Workbook.SaveAs($writelocation+'UsersList.xlsx')
$excel.Quit()

Remove-Item ($writelocation + $csvname) #clean up the Csv

write-host "Your file is located in $writelocation as UsersList.xlsx."
}

CSVtoXLSX