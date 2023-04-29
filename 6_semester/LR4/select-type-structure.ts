
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


type WhereStructure = Array<{ condition: WhereSingleConditionStructure, separator?: 'OR' | 'AND' }>

interface JoinType {
    joinType: 'JOIN' | 'LEFT JOIN' | 'RIGHT JOIN' | 'INNER JOIN' | 'OUTER JOIN'
    joinTable: string
    onCondition: string
}

interface JsonSelectStructure {
    queryType: 'SELECT',
    columnsNames: string[],
    tablesNames: string[]
    where: WhereStructure
    join: JoinType[]
}

