# params
$xmlFilePath=$args[0]
$SchemaVersion=$args[1]

# load XML file into local variable and cast as XML type.
$doc = [xml](Get-Content $xmlFilePath)

# change node value
$nodeSchemaVersion = $doc.selectSingleNode('//Application/SchemaVersion')
$nodeSchemaVersion.set_InnerText($schemaVersion)

# # write results to disk
$doc.save($xmlFilePath)