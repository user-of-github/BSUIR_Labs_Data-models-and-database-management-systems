interface InOrExistsSubQueryType {
    columnName?: string
    subquerySelect: JsonSelectStructure
}

type WhereSingleConditionStructure =
    { in?: InOrExistsSubQueryType } |
    { notIn: InOrExistsSubQueryType } |
    { exists: InOrExistsSubQueryType } |
    { notExists: InOrExistsSubQueryType } |
    { usualCondition: string }


type WhereStructure = Array<{ condition: WhereSingleConditionStructure, separator?: 'OR' | 'AND' }>

interface JsonDeleteStructure {
    queryType: 'DELETE',
    tableName: string[]
    where: WhereStructure
}