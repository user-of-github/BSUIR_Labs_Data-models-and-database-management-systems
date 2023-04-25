
// что-то одно
type WhereSingleConditionStructure =
    { in?: JsonSelectStructure } |
    { notIn: JsonSelectStructure } |
    { exists: JsonSelectStructure } |
    { notExists: JsonSelectStructure } |
    { usualCondition: string }


type WhereStructure = Array<{
    condition: WhereSingleConditionStructure,
    separator?: 'OR' | 'AND'
}>

interface JsonSelectStructure {
    queryType: 'SELECT',
    columnsNames: string[],
    tablesNames: string[]
    where: WhereStructure
}

