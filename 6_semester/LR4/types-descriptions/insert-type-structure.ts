interface JsonInsertStructure {
    queryType: 'INSERT',
    intoTable: string,
    columns: string[]
    value: string
}