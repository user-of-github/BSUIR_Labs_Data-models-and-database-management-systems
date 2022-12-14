import {AuthForm} from '../components/Form'
import {LS_AUTH_STATUS} from '../constants'
import {Redirect} from 'react-router-dom'


export const Authorize = (): JSX.Element => {
    console.log(localStorage.getItem(LS_AUTH_STATUS))
    const isAuthorized: boolean = JSON.parse(localStorage.getItem(LS_AUTH_STATUS) || 'false')
    console.log(isAuthorized)
    if (isAuthorized) {
        return (
            <Redirect to={'/main'}/>
        )
    }

    return (
        (
            <>
                <h1>Authorization</h1>
                <AuthForm/>
            </>
        )
    )
}
