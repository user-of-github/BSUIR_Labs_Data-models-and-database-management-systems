import {AuthorizationResponse, CheckAuthorizationBody} from './types'
import {LS_AUTH_DATA, LS_AUTH_STATUS} from './constants'


export const tryAuthorize = async (authData: CheckAuthorizationBody) => {
    const response: Response = await fetch('http://localhost:8000/checkauthorization', {
        method: 'POST', // *GET, POST, PUT, DELETE, etc.
        headers: {'Content-Type': 'application/json'},
        redirect: 'follow', // manual, *follow, error
        body: JSON.stringify(authData)
    })
    const answer: AuthorizationResponse = await response.json()
    console.log(answer)

    changeLocalAuthStatus(answer)

    return answer.authorized
}


export const changeLocalAuthStatus = (authorizationResponse: AuthorizationResponse): void => {
    localStorage.setItem(LS_AUTH_STATUS, JSON.stringify(true))

    localStorage.setItem(LS_AUTH_DATA, JSON.stringify(authorizationResponse))
}

export const logOutFromLocalStorage = (): void => {
    localStorage.removeItem(LS_AUTH_DATA)
    localStorage.setItem(LS_AUTH_STATUS, JSON.stringify(false))
}
