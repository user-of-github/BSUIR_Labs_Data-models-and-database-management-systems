import React from 'react'
import {tryAuthorize} from '../utils'
import {useHistory} from 'react-router-dom'

export const AuthForm = (): JSX.Element => {
    const email = React.useRef<string>('')
    const password = React.useRef<string>('')
    const history = useHistory()

    const onEmailChange = (event: any): void => {
        email.current = event.currentTarget.value
    }

    const onPasswordChange = (event: any): void => {
        password.current = event.currentTarget.value
    }

    const authButtonPressed = async () => {
        const response = await tryAuthorize({email: email.current, password: password.current})

        if (response) {
            history.push('/main')
        } else {
            window.alert('Authorization failed')
        }
    }

    return (
        <form onSubmit={e => e.preventDefault()} action='#' className={'form'}>
            <input maxLength={30} className={'form__input'} onChange={onEmailChange} type={'email'} required={true} placeholder={'Email'}/>
            <input maxLength={30} className={'form__input'} onChange={onPasswordChange} type={'password'} required={true} placeholder={'Password'}/>

            <button className={'button'} onClick={() => authButtonPressed()}>Authorize</button>
        </form>
    )
}
