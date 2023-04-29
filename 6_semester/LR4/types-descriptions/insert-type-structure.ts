interface JsonInsertStructure {
    queryType: 'INSERT',
    intoTable: string,
    columns: string[]
    values: string[]
}