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


interface JsonInsertStructure {
    queryType: 'DELETE',
    tableName: string,
    setValues: string[]
    where: WhereStructure
}