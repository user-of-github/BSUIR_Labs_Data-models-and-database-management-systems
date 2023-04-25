
interface InOrExistsSubQueryType {
    columnName?: string
    subquerySelect: JsonSelectStructure
}
// что-то одно
type WhereSingleConditionStructure =
    { in?: InOrExistsSubQueryType } |
    { notIn: InOrExistsSubQueryType } |
    { exists: InOrExistsSubQueryType } |
    { notExists: InOrExistsSubQueryType } |
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

