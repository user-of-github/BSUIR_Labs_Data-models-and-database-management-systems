import { Link } from "react-router-dom";
import {logOutFromLocalStorage} from '../utils'

export const Navigation = (): JSX.Element => {
    const onLogOut = () => {
        logOutFromLocalStorage()
    }

    return (
        <nav className="navigation">
            <Link to={'/main'}><button className={'navigation__item'}>Main page</button> </Link>
            <Link to={'/auth'}><button className={'navigation__item'}>Authorize</button> </Link>
            <button className={'navigation__item'} onClick={() => onLogOut()}>Log out</button>
        </nav>
    )
}
